Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C0B11A8A7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfLKKMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:12:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:14670 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfLKKMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 05:12:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 02:08:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="210676404"
Received: from jaertebj-mobl3.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.49.151])
  by fmsmga007.fm.intel.com with ESMTP; 11 Dec 2019 02:08:52 -0800
Subject: Re: [PATCH bpf 3/4] net/i40e: Fix concurrency issues between config
 flow and XSK
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20191205155028.28854-1-maximmi@mellanox.com>
 <20191205155028.28854-4-maximmi@mellanox.com>
 <CAJ+HfNiXPo_Qkja=tCakX6a=swVY_KRMXmT79wQuQa_+kORQ=g@mail.gmail.com>
 <121c3135-3b52-1d64-c1e0-26de38687b4f@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8e8a8cc2-9347-df33-0e98-1594b6d0171d@intel.com>
Date:   Wed, 11 Dec 2019 11:08:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <121c3135-3b52-1d64-c1e0-26de38687b4f@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-10 15:26, Maxim Mikityanskiy wrote:
> On 2019-12-06 11:03, Björn Töpel wrote:
>> On Thu, 5 Dec 2019 at 16:52, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>>>
>>> Use synchronize_rcu to wait until the XSK wakeup function finishes
>>> before destroying the resources it uses:
>>>
>>> 1. i40e_down already calls synchronize_rcu. On i40e_down either
>>> __I40E_VSI_DOWN or __I40E_CONFIG_BUSY is set. Check the latter in
>>> i40e_xsk_async_xmit (the former is already checked there).
>>>
>>> 2. After switching the XDP program, call synchronize_rcu to let
>>> i40e_xsk_async_xmit exit before the XDP program is freed.
>>>
>>> 3. Changing the number of channels brings the interface down (see
>>> i40e_prep_for_reset and i40e_pf_quiesce_all_vsi).
>>>
>>> 4. Disabling UMEM sets __I40E_CONFIG_BUSY, too.
>>>
>>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>>> ---
>>>    drivers/net/ethernet/intel/i40e/i40e_main.c | 7 +++++--
>>>    drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 4 ++++
>>>    2 files changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
>>> index 1ccabeafa44c..afa3a99e68e1 100644
>>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>>> @@ -6823,8 +6823,8 @@ void i40e_down(struct i40e_vsi *vsi)
>>>           for (i = 0; i < vsi->num_queue_pairs; i++) {
>>>                   i40e_clean_tx_ring(vsi->tx_rings[i]);
>>>                   if (i40e_enabled_xdp_vsi(vsi)) {
>>> -                       /* Make sure that in-progress ndo_xdp_xmit
>>> -                        * calls are completed.
>>> +                       /* Make sure that in-progress ndo_xdp_xmit and
>>> +                        * ndo_xsk_async_xmit calls are completed.
> 
> Ooops, I see now some changes were lost during rebasing. I had a version
> of this series with ndo_xsk_async_xmit -> ndo_xsk_wakeup fixed.
> 
>>>                            */
>>>                           synchronize_rcu();
>>>                           i40e_clean_tx_ring(vsi->xdp_rings[i]);
>>> @@ -12545,6 +12545,9 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
>>>                   i40e_prep_for_reset(pf, true);
>>>
>>>           old_prog = xchg(&vsi->xdp_prog, prog);
>>> +       if (old_prog)
>>> +               /* Wait until ndo_xsk_async_xmit completes. */
>>> +               synchronize_rcu();
>>
>> This is not needed -- please correct me if I'm missing something! If
>> we're disabling XDP, the need_reset-clause will take care or the
>> proper synchronization.
> 
> Yes, it was added to cover the case of disabling XDP. I'm not sure how
> i40e_reset_and_rebuild will help here. What I wanted to achieve is to
> wait until all i40e_xsk_wakeups finish after setting vsi->xdp_prog =
> NULL and before doing anything else. I don't see how
> i40e_reset_and_rebuild helps here, but I'm not very familiar with i40e
> code. Could you guide me through the code of i40e_reset_and_rebuild and
> show how it takes care of the synchronization?
> 
>> And we don't need to worry about old_prog for
>> the swap-XDP case,
> 
> Right.
> 
>> because bpf_prog_put() does cleanup with
>> call_rcu().
> 
> But if i40e_xsk_wakeup is not wrapped with rcu_read_lock, it won't sync
> with it.
> 
>>
>>>
>>>           if (need_reset)
>>>                   i40e_reset_and_rebuild(pf, true, true);
>>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>> index d07e1a890428..f73cd917c44f 100644
>>> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>> @@ -787,8 +787,12 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
>>>    {
>>>           struct i40e_netdev_priv *np = netdev_priv(dev);
>>>           struct i40e_vsi *vsi = np->vsi;
>>> +       struct i40e_pf *pf = vsi->back;
>>>           struct i40e_ring *ring;
>>>
>>> +       if (test_bit(__I40E_CONFIG_BUSY, pf->state))
>>> +               return -ENETDOWN;
>>> +
>>
>> You right that we need to check for BUSY, since the XDP ring might be
>> stale! Thanks for catching this! Can you respin this patch, with just
>> this hunk? (Unless I'm wrong! :-))
> 
> This check itself will not be enough, unless you wrap i40e_xsk_wakeup
> with rcu_read_lock.
> 
> i40e_xsk_wakeup does some checks in the beginning, then the main part of
> the code goes. My assumption is that if the checks don't pass, the main
> part will fail in some way (e.g., NULL or dangling pointer when
> accessing the ring), otherwise you wouldn't need those checks at all.
> Without RCU, even if you do these checks, it may still fail in the
> following scenario:
> 
> 1. i40e_xsk_wakeup starts running, checks the flag, the flag is set, the
> function goes on.
> 
> 2. The flag gets cleared.
> 
> 3. The resources are destroyed.
> 
> 4. i40e_xsk_wakeup tries to access the resources that were destroyed.
> 
> I don't see anything in i40e and ixgbe that currently protects from such
> a race condition. If I'm missing anything, please point me to it,
> otherwise i40e_xsk_wakeup really needs to be wrapped into rcu_read_lock.
> I would prefer to have rcu_read_lock in the kernel, so that all drivers
> could benefit from it, because I think it's the same issue in all
> drivers, but I'm fine with moving it to the drivers if there is a reason
> why some drivers may not need it.
> 
> Thanks for taking a look. Let's settle the case with Intel's drivers, so
> that I will know what fixes to include into the respin.
>

Max, you're right. It's not correct without RCU locking. Thanks for the
patience.

For the Intel ndo_xsk_wakeup implementation we need to make sure that 
the 1. umem(socket) exists, and that the 2. XDP rings exists for the 
duration of the call.

1. In xsk_unbind_dev() the state is changed to UNBOUND and then
    followed by synchronize_net(). It would be, as you wrote, incorrect
    without RCU locking the ndo_xsk_wakeup() region.

2. To ensure that the XDP rings are intact for the duration of the
    ndo_xsk_wakeup(), a synchronize_rcu() is required when the XDP
    program is swapped out (prog->NULL).

Again, both 1 and 2 requires RCU locking.

What do you think about the this patch for xsk.c (and the Intel 
drivers)? It moves all ndo_xsk_wakeup calls do one place.


diff --git a/drivers/net/ethernet/intel/i40e/i40e.h 
b/drivers/net/ethernet/intel/i40e/i40e.h
index cb6367334ca7..4833187bd259 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1152,7 +1152,7 @@ void i40e_set_fec_in_flags(u8 fec_cfg, u32 *flags);

  static inline bool i40e_enabled_xdp_vsi(struct i40e_vsi *vsi)
  {
-	return !!vsi->xdp_prog;
+	return !!READ_ONCE(vsi->xdp_prog);
  }

  int i40e_create_queue_channel(struct i40e_vsi *vsi, struct 
i40e_channel *ch);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c 
b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1ccabeafa44c..fd084f03f00d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12546,8 +12546,11 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,

  	old_prog = xchg(&vsi->xdp_prog, prog);

-	if (need_reset)
+	if (need_reset) {
+		if (!prog)
+			synchronize_rcu();
  		i40e_reset_and_rebuild(pf, true, true);
+	}

  	for (i = 0; i < vsi->num_queue_pairs; i++)
  		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c 
b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 25c097cd8100..adff2cbcde1a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10261,7 +10261,11 @@ static int ixgbe_xdp_setup(struct net_device 
*dev, struct bpf_prog *prog)

  	/* If transitioning XDP modes reconfigure rings */
  	if (need_reset) {
-		int err = ixgbe_setup_tc(dev, adapter->hw_tcs);
+		int err;
+
+		if (!prog)
+			synchronize_rcu();
+		err = ixgbe_setup_tc(dev, adapter->hw_tcs);

  		if (err) {
  			rcu_assign_pointer(adapter->xdp_prog, old_prog);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 956793893c9d..dbf06c3b7061 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -334,12 +334,20 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, 
struct xdp_desc *desc)
  }
  EXPORT_SYMBOL(xsk_umem_consume_tx);

-static int xsk_zc_xmit(struct xdp_sock *xs)
+static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
  {
  	struct net_device *dev = xs->dev;
+	int err;

-	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
-					       XDP_WAKEUP_TX);
+	rcu_read_lock();
+	err = dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
+	rcu_read_unlock();
+	return err;
+}
+
+static int xsk_zc_xmit(struct xdp_sock *xs)
+{
+	return xsk_wakeup(xs, XDP_WAKEUP_TX);
  }

  static void xsk_destruct_skb(struct sk_buff *skb)
@@ -453,19 +461,16 @@ static __poll_t xsk_poll(struct file *file, struct 
socket *sock,
  	__poll_t mask = datagram_poll(file, sock, wait);
  	struct sock *sk = sock->sk;
  	struct xdp_sock *xs = xdp_sk(sk);
-	struct net_device *dev;
  	struct xdp_umem *umem;

  	if (unlikely(!xsk_is_bound(xs)))
  		return mask;

-	dev = xs->dev;
  	umem = xs->umem;

  	if (umem->need_wakeup) {
-		if (dev->netdev_ops->ndo_xsk_wakeup)
-			dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
-							umem->need_wakeup);
+		if (xs->zc)
+			xsk_wakeup(umem->need_wakeup);
  		else
  			/* Poll needs to drive Tx also in copy mode */
  			__xsk_sendmsg(sk);

