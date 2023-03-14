Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08BD6B8DA1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCNIkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjCNIjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:39:52 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A406E19A;
        Tue, 14 Mar 2023 01:39:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VdrZsQW_1678783142;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VdrZsQW_1678783142)
          by smtp.aliyun-inc.com;
          Tue, 14 Mar 2023 16:39:03 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Heng Qi <hengqi@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net 1/2] virtio_net: fix page_to_skb() miss headroom
Date:   Tue, 14 Mar 2023 16:39:00 +0800
Message-Id: <20230314083901.40521-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230314083901.40521-1-xuanzhuo@linux.alibaba.com>
References: <20230314083901.40521-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 007492630ac1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because headroom is not passed to page_to_skb(), this causes the shinfo
exceeds the range. Then the frags of shinfo are changed by other process.

[  157.724634] stack segment: 0000 [#1] PREEMPT SMP NOPTI
[  157.725358] CPU: 3 PID: 679 Comm: xdp_pass_user_f Tainted: G            E      6.2.0+ #150
[  157.726401] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/4
[  157.727820] RIP: 0010:skb_release_data+0x11b/0x180
[  157.728449] Code: 44 24 02 48 83 c3 01 39 d8 7e be 48 89 d8 48 c1 e0 04 41 80 7d 7e 00 49 8b 6c 04 30 79 0c 48 89 ef e8 89 b
[  157.730751] RSP: 0018:ffffc90000178b48 EFLAGS: 00010202
[  157.731383] RAX: 0000000000000010 RBX: 0000000000000001 RCX: 0000000000000000
[  157.732270] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff888100dd0b00
[  157.733117] RBP: 5d5d76010f6e2408 R08: ffff888100dd0b2c R09: 0000000000000000
[  157.734013] R10: ffffffff82effd30 R11: 000000000000a14e R12: ffff88810981ffc0
[  157.734904] R13: ffff888100dd0b00 R14: 0000000000000002 R15: 0000000000002310
[  157.735793] FS:  00007f06121d9740(0000) GS:ffff88842fcc0000(0000) knlGS:0000000000000000
[  157.736794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  157.737522] CR2: 00007ffd9a56c084 CR3: 0000000104bda001 CR4: 0000000000770ee0
[  157.738420] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  157.739283] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  157.740146] PKRU: 55555554
[  157.740502] Call Trace:
[  157.740843]  <IRQ>
[  157.741117]  kfree_skb_reason+0x50/0x120
[  157.741613]  __udp4_lib_rcv+0x52b/0x5e0
[  157.742132]  ip_protocol_deliver_rcu+0xaf/0x190
[  157.742715]  ip_local_deliver_finish+0x77/0xa0
[  157.743280]  ip_sublist_rcv_finish+0x80/0x90
[  157.743834]  ip_list_rcv_finish.constprop.0+0x16f/0x190
[  157.744493]  ip_list_rcv+0x126/0x140
[  157.744952]  __netif_receive_skb_list_core+0x29b/0x2c0
[  157.745602]  __netif_receive_skb_list+0xed/0x160
[  157.746190]  ? udp4_gro_receive+0x275/0x350
[  157.746732]  netif_receive_skb_list_internal+0xf2/0x1b0
[  157.747398]  napi_gro_receive+0xd1/0x210
[  157.747911]  virtnet_receive+0x75/0x1c0
[  157.748422]  virtnet_poll+0x48/0x1b0
[  157.748878]  __napi_poll+0x29/0x1b0
[  157.749330]  net_rx_action+0x27a/0x340
[  157.749812]  __do_softirq+0xf3/0x2fb
[  157.750298]  do_softirq+0xa2/0xd0
[  157.750745]  </IRQ>
[  157.751563]  <TASK>
[  157.752329]  __local_bh_enable_ip+0x6d/0x80
[  157.753178]  virtnet_xdp_set+0x482/0x860
[  157.754159]  ? __pfx_virtnet_xdp+0x10/0x10
[  157.755129]  dev_xdp_install+0xa4/0xe0
[  157.756033]  dev_xdp_attach+0x20b/0x5e0
[  157.756933]  do_setlink+0x82e/0xc90
[  157.757777]  ? __nla_validate_parse+0x12b/0x1e0
[  157.758744]  rtnl_setlink+0xd8/0x170
[  157.759549]  ? mod_objcg_state+0xcb/0x320
[  157.760328]  ? security_capable+0x37/0x60
[  157.761209]  ? security_capable+0x37/0x60
[  157.762072]  rtnetlink_rcv_msg+0x145/0x3d0
[  157.762929]  ? ___slab_alloc+0x327/0x610
[  157.763754]  ? __alloc_skb+0x141/0x170
[  157.764533]  ? __pfx_rtnetlink_rcv_msg+0x10/0x10
[  157.765422]  netlink_rcv_skb+0x58/0x110
[  157.766229]  netlink_unicast+0x21f/0x330
[  157.766951]  netlink_sendmsg+0x240/0x4a0
[  157.767654]  sock_sendmsg+0x93/0xa0
[  157.768434]  ? sockfd_lookup_light+0x12/0x70
[  157.769245]  __sys_sendto+0xfe/0x170
[  157.770079]  ? handle_mm_fault+0xe9/0x2d0
[  157.770859]  ? preempt_count_add+0x51/0xa0
[  157.771645]  ? up_read+0x3c/0x80
[  157.772340]  ? do_user_addr_fault+0x1e9/0x710
[  157.773166]  ? kvm_read_and_reset_apf_flags+0x49/0x60
[  157.774087]  __x64_sys_sendto+0x29/0x30
[  157.774856]  do_syscall_64+0x3c/0x90
[  157.775518]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  157.776382] RIP: 0033:0x7f06122def70

Fixes: 18117a842ab0 ("virtio-net: remove xdp related info from page_to_skb()")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 1a309cfb4976..8ecf7a341d54 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -446,7 +446,8 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
-				   unsigned int len, unsigned int truesize)
+				   unsigned int len, unsigned int truesize,
+				   unsigned int headroom)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -464,11 +465,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
-	buf = p;
+	buf = p - headroom;
 	len -= hdr_len;
 	offset += hdr_padded_len;
 	p += hdr_padded_len;
-	tailroom = truesize - hdr_padded_len - len;
+	tailroom = truesize - headroom  - hdr_padded_len - len;
 
 	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
@@ -1009,7 +1010,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
 {
 	struct page *page = buf;
 	struct sk_buff *skb =
-		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -1332,7 +1333,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	rcu_read_unlock();
 
 skip_xdp:
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, headroom);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.32.0.3.g01195cf9f

