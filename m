Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E299E50CACE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiDWNts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbiDWNtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:49:39 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6F156E07;
        Sat, 23 Apr 2022 06:46:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VAvbgGg_1650721596;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VAvbgGg_1650721596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 23 Apr 2022 21:46:37 +0800
Message-ID: <1650720683.8168066-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] virtio_net: fix wrong buf address calculation when using xdp
Date:   Sat, 23 Apr 2022 21:31:23 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <razor@blackwall.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220423112612.2292774-1-razor@blackwall.org>
In-Reply-To: <20220423112612.2292774-1-razor@blackwall.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Apr 2022 14:26:12 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> We received a report[1] of kernel crashes when Cilium is used in XDP
> mode with virtio_net after updating to newer kernels. After
> investigating the reason it turned out that when using mergeable bufs
> with an XDP program which adjusts xdp.data or xdp.data_meta page_to_buf()
> calculates the build_skb address wrong because the offset can become less
> than the headroom so it gets the address of the previous page (-X bytes
> depending on how lower offset is):
>  page_to_skb: page addr ffff9eb2923e2000 buf ffff9eb2923e1ffc offset 252 headroom 256
>
> This is a pr_err() I added in the beginning of page_to_skb which clearly
> shows offset that is less than headroom by adding 4 bytes of metadata
> via an xdp prog. The calculations done are:
>  receive_mergeable():
>  headroom = VIRTIO_XDP_HEADROOM; // VIRTIO_XDP_HEADROOM == 256 bytes
>  offset = xdp.data - page_address(xdp_page) -
>           vi->hdr_len - metasize;
>
>  page_to_skb():
>  p = page_address(page) + offset;
>  ...
>  buf = p - headroom;
>
> Now buf goes -4 bytes from the page's starting address as can be seen
> above which is set as skb->head and skb->data by build_skb later. Depending
> on what's done with the skb (when it's freed most often) we get all kinds
> of corruptions and BUG_ON() triggers in mm[2]. The story of the faulty
> commit is interesting because the patch was sent and applied twice (it
> seems the first one got lost during merge back in 5.13 window). The
> first version of the patch that was applied as:
>  commit 7bf64460e3b2 ("virtio-net: get build_skb() buf by data ptr")
> was actually correct because it calculated the page starting address
> without relying on offset or headroom, but then the second version that
> was applied as:
>  commit 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> was wrong and added the above calculation.
> An example xdp prog[3] is below.
>
> [1] https://github.com/cilium/cilium/issues/19453
>
> [2] Two of the many traces:
>  [   40.437400] BUG: Bad page state in process swapper/0  pfn:14940
>  [   40.916726] BUG: Bad page state in process systemd-resolve  pfn:053b7
>  [   41.300891] kernel BUG at include/linux/mm.h:720!
>  [   41.301801] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>  [   41.302784] CPU: 1 PID: 1181 Comm: kubelet Kdump: loaded Tainted: G    B   W         5.18.0-rc1+ #37
>  [   41.304458] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
>  [   41.306018] RIP: 0010:page_frag_free+0x79/0xe0
>  [   41.306836] Code: 00 00 75 ea 48 8b 07 a9 00 00 01 00 74 e0 48 8b 47 48 48 8d 50 ff a8 01 48 0f 45 fa eb d0 48 c7 c6 18 b8 30 a6 e8 d7 f8 fc ff <0f> 0b 48 8d 78 ff eb bc 48 8b 07 a9 00 00 01 00 74 3a 66 90 0f b6
>  [   41.310235] RSP: 0018:ffffac05c2a6bc78 EFLAGS: 00010292
>  [   41.311201] RAX: 000000000000003e RBX: 0000000000000000 RCX: 0000000000000000
>  [   41.312502] RDX: 0000000000000001 RSI: ffffffffa6423004 RDI: 00000000ffffffff
>  [   41.313794] RBP: ffff993c98823600 R08: 0000000000000000 R09: 00000000ffffdfff
>  [   41.315089] R10: ffffac05c2a6ba68 R11: ffffffffa698ca28 R12: ffff993c98823600
>  [   41.316398] R13: ffff993c86311ebc R14: 0000000000000000 R15: 000000000000005c
>  [   41.317700] FS:  00007fe13fc56740(0000) GS:ffff993cdd900000(0000) knlGS:0000000000000000
>  [   41.319150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [   41.320152] CR2: 000000c00008a000 CR3: 0000000014908000 CR4: 0000000000350ee0
>  [   41.321387] Call Trace:
>  [   41.321819]  <TASK>
>  [   41.322193]  skb_release_data+0x13f/0x1c0
>  [   41.322902]  __kfree_skb+0x20/0x30
>  [   41.343870]  tcp_recvmsg_locked+0x671/0x880
>  [   41.363764]  tcp_recvmsg+0x5e/0x1c0
>  [   41.384102]  inet_recvmsg+0x42/0x100
>  [   41.406783]  ? sock_recvmsg+0x1d/0x70
>  [   41.428201]  sock_read_iter+0x84/0xd0
>  [   41.445592]  ? 0xffffffffa3000000
>  [   41.462442]  new_sync_read+0x148/0x160
>  [   41.479314]  ? 0xffffffffa3000000
>  [   41.496937]  vfs_read+0x138/0x190
>  [   41.517198]  ksys_read+0x87/0xc0
>  [   41.535336]  do_syscall_64+0x3b/0x90
>  [   41.551637]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>  [   41.568050] RIP: 0033:0x48765b
>  [   41.583955] Code: e8 4a 35 fe ff eb 88 cc cc cc cc cc cc cc cc e8 fb 7a fe ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
>  [   41.632818] RSP: 002b:000000c000a2f5b8 EFLAGS: 00000212 ORIG_RAX: 0000000000000000
>  [   41.664588] RAX: ffffffffffffffda RBX: 000000c000062000 RCX: 000000000048765b
>  [   41.681205] RDX: 0000000000005e54 RSI: 000000c000e66000 RDI: 0000000000000016
>  [   41.697164] RBP: 000000c000a2f608 R08: 0000000000000001 R09: 00000000000001b4
>  [   41.713034] R10: 00000000000000b6 R11: 0000000000000212 R12: 00000000000000e9
>  [   41.728755] R13: 0000000000000001 R14: 000000c000a92000 R15: ffffffffffffffff
>  [   41.744254]  </TASK>
>  [   41.758585] Modules linked in: br_netfilter bridge veth netconsole virtio_net
>
>  and
>
>  [   33.524802] BUG: Bad page state in process systemd-network  pfn:11e60
>  [   33.528617] page ffffe05dc0147b00 ffffe05dc04e7a00 ffff8ae9851ec000 (1) len 82 offset 252 metasize 4 hroom 0 hdr_len 12 data ffff8ae9851ec10c data_meta ffff8ae9851ec108 data_end ffff8ae9851ec14e
>  [   33.529764] page:000000003792b5ba refcount:0 mapcount:-512 mapping:0000000000000000 index:0x0 pfn:0x11e60
>  [   33.532463] flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
>  [   33.532468] raw: 000fffffc0000000 0000000000000000 dead000000000122 0000000000000000
>  [   33.532470] raw: 0000000000000000 0000000000000000 00000000fffffdff 0000000000000000
>  [   33.532471] page dumped because: nonzero mapcount
>  [   33.532472] Modules linked in: br_netfilter bridge veth netconsole virtio_net
>  [   33.532479] CPU: 0 PID: 791 Comm: systemd-network Kdump: loaded Not tainted 5.18.0-rc1+ #37
>  [   33.532482] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
>  [   33.532484] Call Trace:
>  [   33.532496]  <TASK>
>  [   33.532500]  dump_stack_lvl+0x45/0x5a
>  [   33.532506]  bad_page.cold+0x63/0x94
>  [   33.532510]  free_pcp_prepare+0x290/0x420
>  [   33.532515]  free_unref_page+0x1b/0x100
>  [   33.532518]  skb_release_data+0x13f/0x1c0
>  [   33.532524]  kfree_skb_reason+0x3e/0xc0
>  [   33.532527]  ip6_mc_input+0x23c/0x2b0
>  [   33.532531]  ip6_sublist_rcv_finish+0x83/0x90
>  [   33.532534]  ip6_sublist_rcv+0x22b/0x2b0
>
> [3] XDP program to reproduce(xdp_pass.c):
>  #include <linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
>
>  SEC("xdp_pass")
>  int xdp_pkt_pass(struct xdp_md *ctx)
>  {
>           bpf_xdp_adjust_head(ctx, -(int)32);
>           return XDP_PASS;
>  }
>
>  char _license[] SEC("license") = "GPL";
>
>  compile: clang -O2 -g -Wall -target bpf -c xdp_pass.c -o xdp_pass.o
>  load on virtio_net: ip link set enp1s0 xdpdrv obj xdp_pass.o sec xdp_pass
>
> CC: stable@vger.kernel.org
> CC: Jason Wang <jasowang@redhat.com>
> CC: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> CC: Daniel Borkmann <daniel@iogearbox.net>
> CC: "Michael S. Tsirkin" <mst@redhat.com>
> CC: virtualization@lists.linux-foundation.org
> Fixes: 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  drivers/net/virtio_net.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 87838cbe38cf..0687dd88e97f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -434,9 +434,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	 * Buffers with headroom use PAGE_SIZE as alloc size, see
>  	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>  	 */
> -	truesize = headroom ? PAGE_SIZE : truesize;
> +	if (headroom) {
> +		truesize = PAGE_SIZE;
> +		buf = (char *)((unsigned long)p & PAGE_MASK);

The reason for not doing this is that buf and p may not be on the same page, and
buf is probably not page-aligned.

The implementation of virtio-net merge is add_recvbuf_mergeable(), which
allocates a large block of memory at one time, and allocates from it each time.
Although in xdp mode, each allocation is page_size, it does not guarantee that
each allocation is page-aligned .

The problem here is that the value of headroom is wrong, the package is
structured like this:

from device    | headroom          | virtio-net hdr | data |
after xdp      | headroom  |  virtio-net hdr | meta | data |

The page_address(page) + offset we pass to page_to_skb() points to the
virtio-net hdr.

So I think it might be better to change it this way.

Thanks.


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 87838cbe38cf..086ae835ec86 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1012,7 +1012,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
                                head_skb = page_to_skb(vi, rq, xdp_page, offset,
                                                       len, PAGE_SIZE, false,
                                                       metasize,
-                                                      VIRTIO_XDP_HEADROOM);
+                                                      VIRTIO_XDP_HEADROOM - metazie);
                                return head_skb;
                        }
                        break;
