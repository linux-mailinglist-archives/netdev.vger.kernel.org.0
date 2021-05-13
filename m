Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A2D37F726
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhEMLuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:50:06 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52686 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233672AbhEMLtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:49:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UYkHiQI_1620906488;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UYkHiQI_1620906488)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 May 2021 19:48:09 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 1/2] virtio-net: fix for unable to handle page fault for address
Date:   Thu, 13 May 2021 19:48:07 +0800
Message-Id: <20210513114808.120031-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210513114808.120031-1-xuanzhuo@linux.alibaba.com>
References: <20210513114808.120031-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In merge mode, when xdp is enabled, if the headroom of buf is smaller
than virtnet_get_headroom(), xdp_linearize_page() will be called but the
variable of "headroom" is still 0, which leads to wrong logic after
entering page_to_skb().

[   16.600944] BUG: unable to handle page fault for address: ffffecbfff7b43c8[   16.602175] #PF: supervisor read access in kernel mode
[   16.603350] #PF: error_code(0x0000) - not-present page
[   16.604200] PGD 0 P4D 0
[   16.604686] Oops: 0000 [#1] SMP PTI
[   16.605306] CPU: 4 PID: 715 Comm: sh Tainted: G    B             5.12.0+ #312
[   16.606429] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/04
[   16.608217] RIP: 0010:unmap_page_range+0x947/0xde0
[   16.609014] Code: 00 00 08 00 48 83 f8 01 45 19 e4 41 f7 d4 41 83 e4 03 e9 a4 fd ff ff e8 b7 63 ed ff 4c 89 e0 48 c1 e0 065
[   16.611863] RSP: 0018:ffffc90002503c58 EFLAGS: 00010286
[   16.612720] RAX: ffffecbfff7b43c0 RBX: 00007f19f7203000 RCX: ffffffff812ff359
[   16.613853] RDX: ffff888107778000 RSI: 0000000000000000 RDI: 0000000000000005
[   16.614976] RBP: ffffea000425e000 R08: 0000000000000000 R09: 3030303030303030
[   16.616124] R10: ffffffff82ed7d94 R11: 6637303030302052 R12: 7c00000afffded0f
[   16.617276] R13: 0000000000000001 R14: ffff888119ee7010 R15: 00007f19f7202000
[   16.618423] FS:  0000000000000000(0000) GS:ffff88842fd00000(0000) knlGS:0000000000000000
[   16.619738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.620670] CR2: ffffecbfff7b43c8 CR3: 0000000103220005 CR4: 0000000000370ee0
[   16.621792] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.622920] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   16.624047] Call Trace:
[   16.624525]  ? release_pages+0x24d/0x730
[   16.625209]  unmap_single_vma+0xa9/0x130
[   16.625885]  unmap_vmas+0x76/0xf0
[   16.626480]  exit_mmap+0xa0/0x210
[   16.627129]  mmput+0x67/0x180
[   16.627673]  do_exit+0x3d1/0xf10
[   16.628259]  ? do_user_addr_fault+0x231/0x840
[   16.629000]  do_group_exit+0x53/0xd0
[   16.629631]  __x64_sys_exit_group+0x1d/0x20
[   16.630354]  do_syscall_64+0x3c/0x80
[   16.630988]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   16.631828] RIP: 0033:0x7f1a043d0191
[   16.632464] Code: Unable to access opcode bytes at RIP 0x7f1a043d0167.
[   16.633502] RSP: 002b:00007ffe3d993308 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   16.634737] RAX: ffffffffffffffda RBX: 00007f1a044c9490 RCX: 00007f1a043d0191
[   16.635857] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
[   16.636986] RBP: 0000000000000000 R08: ffffffffffffff88 R09: 0000000000000001
[   16.638120] R10: 0000000000000008 R11: 0000000000000246 R12: 00007f1a044c9490
[   16.639245] R13: 0000000000000001 R14: 00007f1a044c9968 R15: 0000000000000000
[   16.640408] Modules linked in:
[   16.640958] CR2: ffffecbfff7b43c8
[   16.641557] ---[ end trace bc4891c6ce46354c ]---
[   16.642335] RIP: 0010:unmap_page_range+0x947/0xde0
[   16.643135] Code: 00 00 08 00 48 83 f8 01 45 19 e4 41 f7 d4 41 83 e4 03 e9 a4 fd ff ff e8 b7 63 ed ff 4c 89 e0 48 c1 e0 065
[   16.645983] RSP: 0018:ffffc90002503c58 EFLAGS: 00010286
[   16.646845] RAX: ffffecbfff7b43c0 RBX: 00007f19f7203000 RCX: ffffffff812ff359
[   16.647970] RDX: ffff888107778000 RSI: 0000000000000000 RDI: 0000000000000005
[   16.649091] RBP: ffffea000425e000 R08: 0000000000000000 R09: 3030303030303030
[   16.650250] R10: ffffffff82ed7d94 R11: 6637303030302052 R12: 7c00000afffded0f
[   16.651394] R13: 0000000000000001 R14: ffff888119ee7010 R15: 00007f19f7202000
[   16.652529] FS:  0000000000000000(0000) GS:ffff88842fd00000(0000) knlGS:0000000000000000
[   16.653887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.654841] CR2: ffffecbfff7b43c8 CR3: 0000000103220005 CR4: 0000000000370ee0
[   16.655992] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.657150] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   16.658290] Kernel panic - not syncing: Fatal exception
[   16.659613] Kernel Offset: disabled
[   16.660234] ---[ end Kernel panic - not syncing: Fatal exception ]---

Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9b6a4a875c55..3e46c12dde08 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -380,7 +380,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct page *page, unsigned int offset,
 				   unsigned int len, unsigned int truesize,
 				   bool hdr_valid, unsigned int metasize,
-				   unsigned int headroom)
+				   bool whole_page)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -398,12 +398,12 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
-	/* If headroom is not 0, there is an offset between the beginning of the
+	/* If whole_page, there is an offset between the beginning of the
 	 * data and the allocated space, otherwise the data and the allocated
 	 * space are aligned.
 	 */
-	if (headroom) {
-		/* Buffers with headroom use PAGE_SIZE as alloc size,
+	if (whole_page) {
+		/* Buffers with whole_page use PAGE_SIZE as alloc size,
 		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
 		 */
 		truesize = PAGE_SIZE;
@@ -958,7 +958,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				put_page(page);
 				head_skb = page_to_skb(vi, rq, xdp_page, offset,
 						       len, PAGE_SIZE, false,
-						       metasize, headroom);
+						       metasize, true);
 				return head_skb;
 			}
 			break;
@@ -1016,7 +1016,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}
 
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
-			       metasize, headroom);
+			       metasize, !!headroom);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.31.0

