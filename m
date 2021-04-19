Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBC9364E9D
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhDSXaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:30:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:27880 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhDSXaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:30:10 -0400
IronPort-SDR: Lft6792p4PakNmrhMgRmpwMKToIPQD5Darg+/M+AEte5fKmktHWyi68lCrU72eFH1obX3WZUBG
 SsIlJ+iAig2g==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="182908116"
X-IronPort-AV: E=Sophos;i="5.82,235,1613462400"; 
   d="scan'208";a="182908116"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 16:29:37 -0700
IronPort-SDR: 4AjvXw0bhyfNbTLUAtmUl6N2eSwmFLEiW6JEDeEyFivMGmskh+qpCmfJrc83yxRfIh+4u8gfGc
 x0NGdofiliig==
X-IronPort-AV: E=Sophos;i="5.82,235,1613462400"; 
   d="scan'208";a="426689845"
Received: from pdanley-desk.amr.corp.intel.com ([10.212.162.30])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 16:29:37 -0700
Date:   Mon, 19 Apr 2021 16:29:36 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
In-Reply-To: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
Message-ID: <e48bb6f-48c1-681-3288-72cd7b9661c3@linux.intel.com>
References: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 16 Apr 2021, Xuan Zhuo wrote:

> In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
> can use build_skb to create skb directly. No need to alloc for
> additional space. And it can save a 'frags slot', which is very friendly
> to GRO.
>
> Here, if the payload of the received package is too small (less than
> GOOD_COPY_LEN), we still choose to copy it directly to the space got by
> napi_alloc_skb. So we can reuse these pages.
>
> Testing Machine:
>    The four queues of the network card are bound to the cpu1.
>
> Test command:
>    for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
>
> The size of the udp package is 1000, so in the case of this patch, there
> will always be enough tailroom to use build_skb. The sent udp packet
> will be discarded because there is no port to receive it. The irqsoftd
> of the machine is 100%, we observe the received quantity displayed by
> sar -n DEV 1:
>
> no build_skb:  956864.00 rxpck/s
> build_skb:    1158465.00 rxpck/s
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>
> v3: fix the truesize when headroom > 0
>
> v2: conflict resolution
>
> drivers/net/virtio_net.c | 69 ++++++++++++++++++++++++++++------------
> 1 file changed, 48 insertions(+), 21 deletions(-)

Xuan,

I realize this has been merged to net-next already, but I'm getting a 
use-after-free with KASAN in page_to_skb() with this patch. Reverting this 
change fixes the UAF. I've included the KASAN dump below, and a couple of 
comments inline.


>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 101659cd4b87..8cd76037c724 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -379,21 +379,17 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> 				   struct receive_queue *rq,
> 				   struct page *page, unsigned int offset,
> 				   unsigned int len, unsigned int truesize,
> -				   bool hdr_valid, unsigned int metasize)
> +				   bool hdr_valid, unsigned int metasize,
> +				   unsigned int headroom)
> {
> 	struct sk_buff *skb;
> 	struct virtio_net_hdr_mrg_rxbuf *hdr;
> 	unsigned int copy, hdr_len, hdr_padded_len;
> -	char *p;
> +	int tailroom, shinfo_size;
> +	char *p, *hdr_p;
>
> 	p = page_address(page) + offset;
> -
> -	/* copy small packet so we can reuse these pages for small data */
> -	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> -	if (unlikely(!skb))
> -		return NULL;
> -
> -	hdr = skb_vnet_hdr(skb);
> +	hdr_p = p;

hdr_p is assigned here, pointer to an address in the provided page...

>
> 	hdr_len = vi->hdr_len;
> 	if (vi->mergeable_rx_bufs)

(snip)

> @@ -431,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> 			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
> 		else
> 			put_page(page);

page is potentially released here...

> -		return skb;
> +		goto ok;
> 	}
>
> 	/*
> @@ -458,6 +473,18 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> 	if (page)
> 		give_pages(rq, page);
>
> +ok:
> +	/* hdr_valid means no XDP, so we can copy the vnet header */
> +	if (hdr_valid) {
> +		hdr = skb_vnet_hdr(skb);
> +		memcpy(hdr, hdr_p, hdr_len);

and hdr_p is dereferenced here.

I'm seeing this KASAN UAF at boot time in a kvm VM (Fedora 33 host and 
guest, if that helps):

[   61.202483] ==================================================================
[   61.204005] BUG: KASAN: use-after-free in page_to_skb+0x32a/0x4b0
[   61.205387] Read of size 12 at addr ffff888105bdf800 by task NetworkManager/579
[   61.207035] 
[   61.207408] CPU: 0 PID: 579 Comm: NetworkManager Not tainted 5.12.0-rc7+ #2
[   61.208715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
[   61.210257] Call Trace:
[   61.210730]  <IRQ>
[   61.211209]  dump_stack+0x93/0xc2
[   61.211996]  print_address_description.constprop.0+0x18/0x130
[   61.213310]  ? page_to_skb+0x32a/0x4b0
[   61.214318]  ? page_to_skb+0x32a/0x4b0
[   61.215085]  kasan_report.cold+0x7f/0x111
[   61.215966]  ? trace_hardirqs_off+0x10/0xe0
[   61.216823]  ? page_to_skb+0x32a/0x4b0
[   61.217809]  kasan_check_range+0xf9/0x1e0
[   61.217834]  memcpy+0x20/0x60
[   61.217848]  page_to_skb+0x32a/0x4b0
[   61.217888]  receive_buf+0x1434/0x2690
[   61.217926]  ? page_to_skb+0x4b0/0x4b0
[   61.217947]  ? find_held_lock+0x85/0xa0
[   61.217964]  ? lock_release+0x1d0/0x400
[   61.217974]  ? virtnet_poll+0x1d8/0x6b0
[   61.217983]  ? detach_buf_split+0x254/0x290
[   61.218008]  ? virtqueue_get_buf_ctx_split+0x145/0x1f0
[   61.218032]  virtnet_poll+0x2a8/0x6b0
[   61.218057]  ? receive_buf+0x2690/0x2690
[   61.218067]  ? lock_release+0x400/0x400
[   61.218119]  __napi_poll+0x57/0x2f0
[   61.229624]  net_rx_action+0x4dd/0x590
[   61.230453]  ? napi_threaded_poll+0x2b0/0x2b0
[   61.231379]  ? rcu_implicit_dynticks_qs+0x430/0x430
[   61.232429]  ? lock_is_held_type+0x98/0x110
[   61.233342]  __do_softirq+0xfd/0x59d
[   61.234131]  do_softirq+0x8a/0xb0
[   61.234896]  </IRQ>
[   61.235397]  ? virtnet_open+0x10a/0x2e0
[   61.236273]  __local_bh_enable_ip+0xb1/0xc0
[   61.237199]  virtnet_open+0x11b/0x2e0
[   61.237981]  __dev_open+0x1b7/0x2c0
[   61.238689]  ? dev_set_rx_mode+0x60/0x60
[   61.239499]  ? lockdep_hardirqs_on_prepare+0x12e/0x1f0
[   61.240523]  ? __local_bh_enable_ip+0x7b/0xc0
[   61.241399]  ? trace_hardirqs_on+0x1c/0x100
[   61.242248]  __dev_change_flags+0x2e6/0x370
[   61.243098]  ? dev_set_allmulti+0x10/0x10
[   61.243908]  ? lock_chain_count+0x20/0x20
[   61.244759]  dev_change_flags+0x55/0xb0
[   61.245595]  do_setlink+0xb52/0x1950
[   61.246385]  ? rtnl_getlink+0x560/0x560
[   61.247218]  ? mark_lock+0x101/0x19c0
[   61.248003]  ? lock_chain_count+0x20/0x20
[   61.248864]  ? lock_chain_count+0x20/0x20
[   61.249728]  ? lockdep_hardirqs_on_prepare+0x1f0/0x1f0
[   61.250821]  ? memset+0x20/0x40
[   61.251474]  ? __nla_validate_parse+0xac/0x12f0
[   61.252433]  ? nla_get_range_signed+0x1c0/0x1c0
[   61.253409]  ? __lock_acquire+0x85f/0x3090
[   61.254291]  __rtnl_newlink+0x85f/0xca0
[   61.255131]  ? rtnl_setlink+0x220/0x220
[   61.255988]  ? lock_is_held_type+0x98/0x110
[   61.256911]  ? find_held_lock+0x85/0xa0
[   61.257782]  ? __is_insn_slot_addr+0xa5/0x130
[   61.257794]  ? lock_downgrade+0x390/0x390
[   61.257802]  ? stack_access_ok+0x35/0x90
[   61.257818]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[   61.257840]  ? __is_insn_slot_addr+0xc4/0x130
[   61.257859]  ? kernel_text_address+0xc8/0xf0
[   61.257876]  ? __kernel_text_address+0x9/0x30
[   61.257885]  ? unwind_get_return_address+0x2a/0x40
[   61.257893]  ? create_prof_cpu_mask+0x20/0x20
[   61.257903]  ? arch_stack_walk+0x99/0xf0
[   61.258007]  ? lock_release+0x1d0/0x400
[   61.258016]  ? fs_reclaim_release+0x56/0x90
[   61.258027]  ? lock_downgrade+0x390/0x390
[   61.258036]  ? find_held_lock+0x80/0xa0
[   61.258049]  ? lock_release+0x1d0/0x400
[   61.258059]  ? lock_is_held_type+0x98/0x110
[   61.258087]  rtnl_newlink+0x4b/0x70
[   61.258099]  rtnetlink_rcv_msg+0x22c/0x5e0
[   61.258116]  ? rtnetlink_put_metrics+0x2c0/0x2c0
[   61.258131]  ? lock_acquire+0x157/0x4d0
[   61.258140]  ? netlink_deliver_tap+0xa6/0x570
[   61.258154]  ? lock_release+0x400/0x400
[   61.258172]  netlink_rcv_skb+0xc4/0x1f0
[   61.258180]  ? rtnetlink_put_metrics+0x2c0/0x2c0
[   61.258193]  ? netlink_ack+0x4f0/0x4f0
[   61.258199]  ? netlink_deliver_tap+0x129/0x570
[   61.258234]  netlink_unicast+0x2d3/0x410
[   61.258248]  ? netlink_attachskb+0x400/0x400
[   61.258257]  ? _copy_from_iter_full+0xd8/0x360
[   61.258280]  netlink_sendmsg+0x394/0x670
[   61.258299]  ? netlink_unicast+0x410/0x410
[   61.258305]  ? iovec_from_user+0xa1/0x1d0
[   61.258327]  ? netlink_unicast+0x410/0x410
[   61.258340]  sock_sendmsg+0x91/0xa0
[   61.258353]  ____sys_sendmsg+0x3b7/0x400
[   61.258366]  ? kernel_sendmsg+0x30/0x30
[   61.258376]  ? __ia32_sys_recvmmsg+0x150/0x150
[   61.258390]  ? lockdep_hardirqs_on_prepare+0x1f0/0x1f0
[   61.258398]  ? stack_trace_save+0x8c/0xc0
[   61.258408]  ? stack_trace_consume_entry+0x80/0x80
[   61.258416]  ? __fput+0x1a9/0x3d0
[   61.258435]  ___sys_sendmsg+0xd3/0x130
[   61.258446]  ? sendmsg_copy_msghdr+0x110/0x110
[   61.258458]  ? find_held_lock+0x85/0xa0
[   61.258471]  ? lock_release+0x1d0/0x400
[   61.258479]  ? __fget_files+0x133/0x210
[   61.258490]  ? lock_downgrade+0x390/0x390
[   61.258508]  ? lockdep_hardirqs_on_prepare+0x1f0/0x1f0
[   61.258529]  ? __fget_files+0x152/0x210
[   61.258547]  ? __fget_light+0x66/0xf0
[   61.258568]  __sys_sendmsg+0xae/0x120
[   61.258578]  ? __sys_sendmsg_sock+0x10/0x10
[   61.258589]  ? lockdep_hardirqs_on_prepare+0x12e/0x1f0
[   61.258598]  ? call_rcu+0x414/0x670
[   61.258616]  ? mark_held_locks+0x25/0x90
[   61.258630]  ? lockdep_hardirqs_on_prepare+0x12e/0x1f0
[   61.258639]  ? syscall_enter_from_user_mode+0x1d/0x50
[   61.258647]  ? trace_hardirqs_on+0x1c/0x100
[   61.258662]  do_syscall_64+0x33/0x40
[   61.258670]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   61.258679] RIP: 0033:0x7fb33db83ecd
[   61.258686] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 4a ee ff ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 9e ee ff ff 48
[   61.258692] RSP: 002b:00007ffc85e90e30 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
[   61.258702] RAX: ffffffffffffffda RBX: 000055f87a7aa030 RCX: 00007fb33db83ecd
[   61.258708] RDX: 0000000000000000 RSI: 00007ffc85e90e70 RDI: 000000000000000c
[   61.258713] RBP: 000000000000000c R08: 0000000000000000 R09: 0000000000000000
[   61.258717] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[   61.258722] R13: 00007ffc85e90fd0 R14: 00007ffc85e90fcc R15: 0000000000000000


--
Mat Martineau
Intel
