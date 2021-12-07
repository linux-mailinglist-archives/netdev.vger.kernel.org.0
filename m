Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5385746C7FD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242452AbhLGXJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:09:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:37262 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhLGXJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:09:37 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mujXA-0005Cv-2n; Wed, 08 Dec 2021 00:06:04 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mujX9-000OZA-Re; Wed, 08 Dec 2021 00:06:03 +0100
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
Message-ID: <039e954b-dba5-9548-44d2-51fc5432173c@iogearbox.net>
Date:   Wed, 8 Dec 2021 00:06:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26376/Tue Dec  7 10:34:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 10:48 PM, Daniel Borkmann wrote:
> On 12/7/21 3:27 PM, Willem de Bruijn wrote:
>> On Mon, Dec 6, 2021 at 9:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>
>>> The skb->tstamp may be set by a local sk (as a sender in tcp) which then
>>> forwarded and delivered to another sk (as a receiver).
>>>
>>> An example:
>>>      sender-sk => veth@netns =====> veth@host => receiver-sk
>>>                               ^^^
>>>                          __dev_forward_skb
>>>
>>> The skb->tstamp is marked with a future TX time.  This future
>>> skb->tstamp will confuse the receiver-sk.
>>>
>>> This patch marks the skb if the skb->tstamp is forwarded.
>>> Before using the skb->tstamp as a rx timestamp, it needs
>>> to be re-stamped to avoid getting a future time.  It is
>>> done in the RX timestamp reading helper skb_get_ktime().
>>>
>>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>>> ---
>>>   include/linux/skbuff.h | 14 +++++++++-----
>>>   net/core/dev.c         |  4 +++-
>>>   net/core/skbuff.c      |  6 +++++-
>>>   3 files changed, 17 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>> index b609bdc5398b..bc4ae34c4e22 100644
>>> --- a/include/linux/skbuff.h
>>> +++ b/include/linux/skbuff.h
>>> @@ -867,6 +867,7 @@ struct sk_buff {
>>>          __u8                    decrypted:1;
>>>   #endif
>>>          __u8                    slow_gro:1;
>>> +       __u8                    fwd_tstamp:1;
>>>
>>>   #ifdef CONFIG_NET_SCHED
>>>          __u16                   tc_index;       /* traffic control index */
>>> @@ -3806,9 +3807,12 @@ static inline void skb_copy_to_linear_data_offset(struct sk_buff *skb,
>>>   }
>>>
>>>   void skb_init(void);
>>> +void net_timestamp_set(struct sk_buff *skb);
>>>
>>> -static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
>>> +static inline ktime_t skb_get_ktime(struct sk_buff *skb)
>>>   {
>>> +       if (unlikely(skb->fwd_tstamp))
>>> +               net_timestamp_set(skb);
>>>          return ktime_mono_to_real_cond(skb->tstamp);
>>
>> This changes timestamp behavior for existing applications, probably
>> worth mentioning in the commit message if nothing else. A timestamp
>> taking at the time of the recv syscall is not very useful.
>>
>> If a forwarded timestamp is not a future delivery time (as those are
>> scrubbed), is it not correct to just deliver the original timestamp?
>> It probably was taken at some earlier __netif_receive_skb_core.
>>
>>>   }
>>>
>>> -static inline void net_timestamp_set(struct sk_buff *skb)
>>> +void net_timestamp_set(struct sk_buff *skb)
>>>   {
>>>          skb->tstamp = 0;
>>> +       skb->fwd_tstamp = 0;
>>>          if (static_branch_unlikely(&netstamp_needed_key))
>>>                  __net_timestamp(skb);
>>>   }
>>> +EXPORT_SYMBOL(net_timestamp_set);
>>>
>>>   #define net_timestamp_check(COND, SKB)                         \
>>>          if (static_branch_unlikely(&netstamp_needed_key)) {     \
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index f091c7807a9e..181ddc989ead 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
>>>   {
>>>          struct sock *sk = skb->sk;
>>>
>>> -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
>>> +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
>>
>> There is a slight race here with the socket flipping the feature on/off.
>>
>>>                  skb->tstamp = 0;
>>> +               skb->fwd_tstamp = 0;
>>> +       } else if (skb->tstamp) {
>>> +               skb->fwd_tstamp = 1;
>>> +       }
>>
>> SO_TXTIME future delivery times are scrubbed, but TCP future delivery
>> times are not?
>>
>> If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
>> scrub based on that. That is also not open to the above race.
> 
> One other thing I wonder, BPF progs at host-facing veth's tc ingress which
> are not aware of skb->tstamp will then see a tstamp from future given we
> intentionally bypass the net_timestamp_check() and might get confused (or
> would confuse higher-layer application logic)? Not quite sure yet if they
> would be the only affected user.

Untested (& unoptimized wrt netdev cachelines), but worst case maybe something
like this could work ... not generic, but smaller risk wrt timestamp behavior
changes for applications when pushing up the stack (?).

Meaning, the attribute would be set for host-facing veths and the phys dev with
sch_fq. Not generic unfortunately given this would require the coorperation from
BPF side on tc ingress of the host veths, meaning, given the net_timestamp_check()
is skipped, the prog would have to call net_timestamp_set() via BPF helper if it
decides to return with TC_ACT_OK. (So orchestrator would opt-in(/out) to set the
devs it manages to xnet_flush_tstamp to 0 and to update tstamp via helper.. hm)

  include/linux/netdevice.h |  4 +++-
  include/linux/skbuff.h    |  6 +++++-
  net/core/dev.c            |  1 +
  net/core/filter.c         |  9 ++++++---
  net/core/net-sysfs.c      | 18 ++++++++++++++++++
  net/core/skbuff.c         | 15 +++++++++------
  6 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a..df9141f92bbf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2172,6 +2172,7 @@ struct net_device {
  	struct timer_list	watchdog_timer;
  	int			watchdog_timeo;

+	u32			xnet_flush_tstamp;
  	u32                     proto_down_reason;

  	struct list_head	todo_list;
@@ -4137,7 +4138,8 @@ static __always_inline int ____dev_forward_skb(struct net_device *dev,
  		return NET_RX_DROP;
  	}

-	skb_scrub_packet(skb, !net_eq(dev_net(dev), dev_net(skb->dev)));
+	__skb_scrub_packet(skb, !net_eq(dev_net(dev), dev_net(skb->dev)),
+			   READ_ONCE(dev->xnet_flush_tstamp));
  	skb->priority = 0;
  	return 0;
  }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 686a666d073d..09b670bcd7fd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3688,7 +3688,11 @@ int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
  		 int len, int hlen);
  void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len);
  int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen);
-void skb_scrub_packet(struct sk_buff *skb, bool xnet);
+void __skb_scrub_packet(struct sk_buff *skb, bool xnet, bool tstamp);
+static __always_inline void skb_scrub_packet(struct sk_buff *skb, bool xnet)
+{
+	__skb_scrub_packet(skb, xnet, true);
+}
  bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int mtu);
  bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len);
  struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features);
diff --git a/net/core/dev.c b/net/core/dev.c
index 15ac064b5562..1678032bd5a3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10853,6 +10853,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
  	dev->gso_max_segs = GSO_MAX_SEGS;
  	dev->upper_level = 1;
  	dev->lower_level = 1;
+	dev->xnet_flush_tstamp = 1;
  #ifdef CONFIG_LOCKDEP
  	dev->nested_level = 0;
  	INIT_LIST_HEAD(&dev->unlink_list);
diff --git a/net/core/filter.c b/net/core/filter.c
index fe27c91e3758..69366af42141 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,7 +2107,8 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
  	}

  	skb->dev = dev;
-	skb->tstamp = 0;
+	if (READ_ONCE(dev->xnet_flush_tstamp))
+		skb->tstamp = 0;

  	dev_xmit_recursion_inc();
  	ret = dev_queue_xmit(skb);
@@ -2176,7 +2177,8 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
  	}

  	skb->dev = dev;
-	skb->tstamp = 0;
+	if (READ_ONCE(dev->xnet_flush_tstamp))
+		skb->tstamp = 0;

  	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
  		skb = skb_expand_head(skb, hh_len);
@@ -2274,7 +2276,8 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
  	}

  	skb->dev = dev;
-	skb->tstamp = 0;
+	if (READ_ONCE(dev->xnet_flush_tstamp))
+		skb->tstamp = 0;

  	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
  		skb = skb_expand_head(skb, hh_len);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9c01c642cf9e..d8ad9dbbbf55 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -403,6 +403,23 @@ static ssize_t gro_flush_timeout_store(struct device *dev,
  }
  NETDEVICE_SHOW_RW(gro_flush_timeout, fmt_ulong);

+static int change_xnet_flush_tstamp(struct net_device *dev, unsigned long val)
+{
+	WRITE_ONCE(dev->xnet_flush_tstamp, val);
+	return 0;
+}
+
+static ssize_t xnet_flush_tstamp_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	return netdev_store(dev, attr, buf, len, change_xnet_flush_tstamp);
+}
+NETDEVICE_SHOW_RW(xnet_flush_tstamp, fmt_dec);
+
  static int change_napi_defer_hard_irqs(struct net_device *dev, unsigned long val)
  {
  	WRITE_ONCE(dev->napi_defer_hard_irqs, val);
@@ -651,6 +668,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
  	&dev_attr_flags.attr,
  	&dev_attr_tx_queue_len.attr,
  	&dev_attr_gro_flush_timeout.attr,
+	&dev_attr_xnet_flush_tstamp.attr,
  	&dev_attr_napi_defer_hard_irqs.attr,
  	&dev_attr_phys_port_id.attr,
  	&dev_attr_phys_port_name.attr,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ba2f38246f07..b0f6b96c7b2a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5440,19 +5440,21 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
  EXPORT_SYMBOL(skb_try_coalesce);

  /**
- * skb_scrub_packet - scrub an skb
+ * __skb_scrub_packet - scrub an skb
   *
   * @skb: buffer to clean
   * @xnet: packet is crossing netns
+ * @tstamp: timestamp needs scrubbing
   *
- * skb_scrub_packet can be used after encapsulating or decapsulting a packet
+ * __skb_scrub_packet can be used after encapsulating or decapsulting a packet
   * into/from a tunnel. Some information have to be cleared during these
   * operations.
- * skb_scrub_packet can also be used to clean a skb before injecting it in
+ *
+ * __skb_scrub_packet can also be used to clean a skb before injecting it in
   * another namespace (@xnet == true). We have to clear all information in the
   * skb that could impact namespace isolation.
   */
-void skb_scrub_packet(struct sk_buff *skb, bool xnet)
+void __skb_scrub_packet(struct sk_buff *skb, bool xnet, bool tstamp)
  {
  	skb->pkt_type = PACKET_HOST;
  	skb->skb_iif = 0;
@@ -5472,9 +5474,10 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)

  	ipvs_reset(skb);
  	skb->mark = 0;
-	skb->tstamp = 0;
+	if (tstamp)
+		skb->tstamp = 0;
  }
-EXPORT_SYMBOL_GPL(skb_scrub_packet);
+EXPORT_SYMBOL_GPL(__skb_scrub_packet);

  /**
   * skb_gso_transport_seglen - Return length of individual segments of a gso packet
-- 
2.21.0
