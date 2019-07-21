Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519056F372
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfGUNqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 09:46:22 -0400
Received: from ja.ssi.bg ([178.16.129.10]:44274 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726326AbfGUNqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 09:46:22 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x6LDk4ik006816;
        Sun, 21 Jul 2019 16:46:04 +0300
Date:   Sun, 21 Jul 2019 16:46:04 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
cc:     davem@davemloft.net, netdev@vger.kernel.org, dsahern@gmail.com,
        marek@cloudflare.com
Subject: Re: [PATCH net v3] net: neigh: fix multiple neigh timer scheduling
In-Reply-To: <552d7c8de6a07e12f7b76791da953e81478138cd.1563134704.git.lorenzo.bianconi@redhat.com>
Message-ID: <alpine.LFD.2.21.1907211606200.3535@ja.home.ssi.bg>
References: <552d7c8de6a07e12f7b76791da953e81478138cd.1563134704.git.lorenzo.bianconi@redhat.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sun, 14 Jul 2019, Lorenzo Bianconi wrote:

> Neigh timer can be scheduled multiple times from userspace adding

	If the garbage comes from ndm_state, why we should create
a patch that just covers the problem?:

State: INCOMPLETE, STALE, FAILED, 0x8400 (0x8425)

	User space is trying to create entry that is both
STALE (no timer) and INCOMPLETE (with timer). So, in the
2nd NL message __neigh_event_send() detects timer with NUD_STALE
bit. What if this 2nd message never comes? Such inconsistence
between nud_state and the timer can trigger other bugs in
other functions.

	May be we just need to restrict ndm_state and to drop
this patch, for example, by adding checks in __neigh_update():

        if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
            (old & (NUD_NOARP | NUD_PERMANENT)))
                goto out;
+	/* State must be single bit or 0 */
+	if (new & (new - 1))
+		goto out;
        if (neigh->dead) {

	If needed, this check can be moved only for ndm_state
in neigh_add().

> multiple neigh entries and forcing the neigh timer scheduling passing
> NTF_USE in the netlink requests.
> This will result in a refcount leak and in the following dump stack:

	It is a single create with multiple bits in state with following
__neigh_event_send(). And who knows, this bug may exist even in Linux 2.2 
and below...

> [   32.465295] NEIGH: BUG, double timer add, state is 8
> [   32.465308] CPU: 0 PID: 416 Comm: double_timer_ad Not tainted 5.2.0+ #65
> [   32.465311] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.12.0-2.fc30 04/01/2014
> [   32.465313] Call Trace:
> [   32.465318]  dump_stack+0x7c/0xc0
> [   32.465323]  __neigh_event_send+0x20c/0x880
> [   32.465326]  ? ___neigh_create+0x846/0xfb0
> [   32.465329]  ? neigh_lookup+0x2a9/0x410
> [   32.465332]  ? neightbl_fill_info.constprop.0+0x800/0x800
> [   32.465334]  neigh_add+0x4f8/0x5e0
> [   32.465337]  ? neigh_xmit+0x620/0x620
> [   32.465341]  ? find_held_lock+0x85/0xa0
> [   32.465345]  rtnetlink_rcv_msg+0x204/0x570
> [   32.465348]  ? rtnl_dellink+0x450/0x450
> [   32.465351]  ? mark_held_locks+0x90/0x90
> [   32.465354]  ? match_held_lock+0x1b/0x230
> [   32.465357]  netlink_rcv_skb+0xc4/0x1d0
> [   32.465360]  ? rtnl_dellink+0x450/0x450
> [   32.465363]  ? netlink_ack+0x420/0x420
> [   32.465366]  ? netlink_deliver_tap+0x115/0x560
> [   32.465369]  ? __alloc_skb+0xc9/0x2f0
> [   32.465372]  netlink_unicast+0x270/0x330
> [   32.465375]  ? netlink_attachskb+0x2f0/0x2f0
> [   32.465378]  netlink_sendmsg+0x34f/0x5a0
> [   32.465381]  ? netlink_unicast+0x330/0x330
> [   32.465385]  ? move_addr_to_kernel.part.0+0x20/0x20
> [   32.465388]  ? netlink_unicast+0x330/0x330
> [   32.465391]  sock_sendmsg+0x91/0xa0
> [   32.465394]  ___sys_sendmsg+0x407/0x480
> [   32.465397]  ? copy_msghdr_from_user+0x200/0x200
> [   32.465401]  ? _raw_spin_unlock_irqrestore+0x37/0x40
> [   32.465404]  ? lockdep_hardirqs_on+0x17d/0x250
> [   32.465407]  ? __wake_up_common_lock+0xcb/0x110
> [   32.465410]  ? __wake_up_common+0x230/0x230
> [   32.465413]  ? netlink_bind+0x3e1/0x490
> [   32.465416]  ? netlink_setsockopt+0x540/0x540
> [   32.465420]  ? __fget_light+0x9c/0xf0
> [   32.465423]  ? sockfd_lookup_light+0x8c/0xb0
> [   32.465426]  __sys_sendmsg+0xa5/0x110
> [   32.465429]  ? __ia32_sys_shutdown+0x30/0x30
> [   32.465432]  ? __fd_install+0xe1/0x2c0
> [   32.465435]  ? lockdep_hardirqs_off+0xb5/0x100
> [   32.465438]  ? mark_held_locks+0x24/0x90
> [   32.465441]  ? do_syscall_64+0xf/0x270
> [   32.465444]  do_syscall_64+0x63/0x270
> [   32.465448]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Fix the issue unscheduling neigh_timer if selected entry is in 'IN_TIMER'
> receiving a netlink request with NTF_USE flag set
> 
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Fixes: 0c5c2d308906 ("neigh: Allow for user space users of the neighbour table")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
> Changes since v2:
> - remove check_timer flag and run neigh_del_timer directly
> Changes since v1:
> - fix compilation errors defining neigh_event_send_check_timer routine
> ---
>  net/core/neighbour.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 742cea4ce72e..0dfc97bc8760 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1124,6 +1124,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  
>  			atomic_set(&neigh->probes,
>  				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
> +			neigh_del_timer(neigh);
>  			neigh->nud_state     = NUD_INCOMPLETE;
>  			neigh->updated = now;
>  			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
> @@ -1140,6 +1141,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  		}
>  	} else if (neigh->nud_state & NUD_STALE) {
>  		neigh_dbg(2, "neigh %p is delayed\n", neigh);
> +		neigh_del_timer(neigh);
>  		neigh->nud_state = NUD_DELAY;
>  		neigh->updated = jiffies;
>  		neigh_add_timer(neigh, jiffies +
> -- 
> 2.21.0

Regards

--
Julian Anastasov <ja@ssi.bg>
