Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883155CF13
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGBMFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:05:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45641 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfGBMFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:05:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so17459903wre.12
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 05:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aZEj/XCFsNFlFULEN7f1Rmy+NlhgPUJTIq2bg1ycGU=;
        b=FgSKNCNfimG49RUeCXL6WnGtsCmjinJa964ufUQzJKCszetF4yVxNyWh20cvQNdIHF
         It7+LXtIHBeCW76WGc7Bob3w2PaZpQ+5xWZ42uFtN3VCbC1GaMarc+WH5hLFy2RUrsil
         rVBpjY9yoJPav+4dBhrrV8ApoEVxmubLu1PSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aZEj/XCFsNFlFULEN7f1Rmy+NlhgPUJTIq2bg1ycGU=;
        b=Kii9XLLQMkCRz8mxvrDIwTm8/uJ2IqW4B2iWnt/2TzXIAk5udxORhfYDt9T5eUcJZv
         9qlAMEQZ141ruRtDGEUN1uq797Ef9Z5nQYXB5VmNUe6CPLxQILNilLIVTm1ydSZ/lP8A
         apGjVjZHunvZ+kx+VNrLKdI+yHVNkqam0ANykS4cnNgyQBc0Fjw69F2w+dS/D7Wiywf9
         OUCTScS3Rhjju6wsP8oCwlutI+7VKOUPf3iMH6nJX9yyf/pJDWNPpbTWTY5ag5hY+2gV
         NujPodXqPc8L4PlBOJg/9nK8jHXSjtsguu2P1JckoZMfbqd9RS+lS2YVVjt3D0LcjtH4
         +oeQ==
X-Gm-Message-State: APjAAAXsvJGnFtu7FtPbRMYER71YO1ofNtD97UcX6YC0i8ToU+bU/nDG
        MYA/lxG5k/HdGqaz4V2dq78dKJWkJfY=
X-Google-Smtp-Source: APXvYqzzYLBakfoi7sbUJLZIiAE7f3XgIQ5bT05++eOYUGKeqMQ+nm/qSiPfkXaibjM4A5dOavV1YA==
X-Received: by 2002:a5d:5186:: with SMTP id k6mr25315886wrv.30.1562069103095;
        Tue, 02 Jul 2019 05:05:03 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x5sm2542655wmf.33.2019.07.02.05.05.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 05:05:02 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        martin@linuxlounge.net, bridge@lists.linux-foundation.org,
        yoshfuji@linux-ipv6.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 1/4] net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling
Date:   Tue,  2 Jul 2019 15:00:18 +0300
Message-Id: <20190702120021.13096-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
References: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We take a pointer to grec prior to calling pskb_may_pull and use it
afterwards to get nsrcs so record nsrcs before the pull when handling
igmp3 and we get a pointer to nsrcs and call pskb_may_pull when handling
mld2 which again could lead to reading 2 bytes out-of-bounds.

 ==================================================================
 BUG: KASAN: use-after-free in br_multicast_rcv+0x480c/0x4ad0 [bridge]
 Read of size 2 at addr ffff8880421302b4 by task ksoftirqd/1/16

 CPU: 1 PID: 16 Comm: ksoftirqd/1 Tainted: G           OE     5.2.0-rc6+ #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
 Call Trace:
  dump_stack+0x71/0xab
  print_address_description+0x6a/0x280
  ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
  __kasan_report+0x152/0x1aa
  ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
  ? br_multicast_rcv+0x480c/0x4ad0 [bridge]
  kasan_report+0xe/0x20
  br_multicast_rcv+0x480c/0x4ad0 [bridge]
  ? br_multicast_disable_port+0x150/0x150 [bridge]
  ? ktime_get_with_offset+0xb4/0x150
  ? __kasan_kmalloc.constprop.6+0xa6/0xf0
  ? __netif_receive_skb+0x1b0/0x1b0
  ? br_fdb_update+0x10e/0x6e0 [bridge]
  ? br_handle_frame_finish+0x3c6/0x11d0 [bridge]
  br_handle_frame_finish+0x3c6/0x11d0 [bridge]
  ? br_pass_frame_up+0x3a0/0x3a0 [bridge]
  ? virtnet_probe+0x1c80/0x1c80 [virtio_net]
  br_handle_frame+0x731/0xd90 [bridge]
  ? select_idle_sibling+0x25/0x7d0
  ? br_handle_frame_finish+0x11d0/0x11d0 [bridge]
  __netif_receive_skb_core+0xced/0x2d70
  ? virtqueue_get_buf_ctx+0x230/0x1130 [virtio_ring]
  ? do_xdp_generic+0x20/0x20
  ? virtqueue_napi_complete+0x39/0x70 [virtio_net]
  ? virtnet_poll+0x94d/0xc78 [virtio_net]
  ? receive_buf+0x5120/0x5120 [virtio_net]
  ? __netif_receive_skb_one_core+0x97/0x1d0
  __netif_receive_skb_one_core+0x97/0x1d0
  ? __netif_receive_skb_core+0x2d70/0x2d70
  ? _raw_write_trylock+0x100/0x100
  ? __queue_work+0x41e/0xbe0
  process_backlog+0x19c/0x650
  ? _raw_read_lock_irq+0x40/0x40
  net_rx_action+0x71e/0xbc0
  ? __switch_to_asm+0x40/0x70
  ? napi_complete_done+0x360/0x360
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70
  ? __schedule+0x85e/0x14d0
  __do_softirq+0x1db/0x5f9
  ? takeover_tasklets+0x5f0/0x5f0
  run_ksoftirqd+0x26/0x40
  smpboot_thread_fn+0x443/0x680
  ? sort_range+0x20/0x20
  ? schedule+0x94/0x210
  ? __kthread_parkme+0x78/0xf0
  ? sort_range+0x20/0x20
  kthread+0x2ae/0x3a0
  ? kthread_create_worker_on_cpu+0xc0/0xc0
  ret_from_fork+0x35/0x40

 The buggy address belongs to the page:
 page:ffffea0001084c00 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0
 flags: 0xffffc000000000()
 raw: 00ffffc000000000 ffffea0000cfca08 ffffea0001098608 0000000000000000
 raw: 0000000000000000 0000000000000003 00000000ffffff7f 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
 ffff888042130180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888042130200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 > ffff888042130280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                     ^
 ffff888042130300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888042130380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ==================================================================
 Disabling lock debugging due to kernel taint

Fixes: bc8c20acaea1 ("bridge: multicast: treat igmpv3 report with INCLUDE and no sources as a leave")
Reported-by: Martin Weinelt <martin@linuxlounge.net>
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de22c8fbbb15..f37897e7b97b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -911,6 +911,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 	int type;
 	int err = 0;
 	__be32 group;
+	u16 nsrcs;
 
 	ih = igmpv3_report_hdr(skb);
 	num = ntohs(ih->ngrec);
@@ -924,8 +925,9 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		grec = (void *)(skb->data + len - sizeof(*grec));
 		group = grec->grec_mca;
 		type = grec->grec_type;
+		nsrcs = ntohs(grec->grec_nsrcs);
 
-		len += ntohs(grec->grec_nsrcs) * 4;
+		len += nsrcs * 4;
 		if (!ip_mc_may_pull(skb, len))
 			return -EINVAL;
 
@@ -946,7 +948,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		src = eth_hdr(skb)->h_source;
 		if ((type == IGMPV3_CHANGE_TO_INCLUDE ||
 		     type == IGMPV3_MODE_IS_INCLUDE) &&
-		    ntohs(grec->grec_nsrcs) == 0) {
+		    nsrcs == 0) {
 			br_ip4_multicast_leave_group(br, port, group, vid, src);
 		} else {
 			err = br_ip4_multicast_add_group(br, port, group, vid,
@@ -983,7 +985,8 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 	len = skb_transport_offset(skb) + sizeof(*icmp6h);
 
 	for (i = 0; i < num; i++) {
-		__be16 *nsrcs, _nsrcs;
+		__be16 *_nsrcs, __nsrcs;
+		u16 nsrcs;
 
 		nsrcs_offset = len + offsetof(struct mld2_grec, grec_nsrcs);
 
@@ -991,12 +994,13 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		    nsrcs_offset + sizeof(_nsrcs))
 			return -EINVAL;
 
-		nsrcs = skb_header_pointer(skb, nsrcs_offset,
-					   sizeof(_nsrcs), &_nsrcs);
-		if (!nsrcs)
+		_nsrcs = skb_header_pointer(skb, nsrcs_offset,
+					    sizeof(__nsrcs), &__nsrcs);
+		if (!_nsrcs)
 			return -EINVAL;
 
-		grec_len = struct_size(grec, grec_src, ntohs(*nsrcs));
+		nsrcs = ntohs(*_nsrcs);
+		grec_len = struct_size(grec, grec_src, nsrcs);
 
 		if (!ipv6_mc_may_pull(skb, len + grec_len))
 			return -EINVAL;
@@ -1021,7 +1025,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		src = eth_hdr(skb)->h_source;
 		if ((grec->grec_type == MLD2_CHANGE_TO_INCLUDE ||
 		     grec->grec_type == MLD2_MODE_IS_INCLUDE) &&
-		    ntohs(*nsrcs) == 0) {
+		    nsrcs == 0) {
 			br_ip6_multicast_leave_group(br, port, &grec->grec_mca,
 						     vid, src);
 		} else {
-- 
2.21.0

