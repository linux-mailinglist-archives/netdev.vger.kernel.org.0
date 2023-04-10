Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB846DC2A5
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 04:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjDJCWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 22:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjDJCWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 22:22:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256FD3C34;
        Sun,  9 Apr 2023 19:22:01 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pvt2c5mqQzKxhh;
        Mon, 10 Apr 2023 10:19:20 +0800 (CST)
Received: from huawei.com (10.175.104.82) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 10 Apr
 2023 10:21:52 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <asml.silence@gmail.com>,
        <imagedong@tencent.com>, <brouer@redhat.com>,
        <keescook@chromium.org>, <jbenc@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: Add check for csum_start in skb_partial_csum_set()
Date:   Mon, 10 Apr 2023 10:21:52 +0800
Message-ID: <20230410022152.4049060-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an AF_PACKET socket is used to send packets through a L3 mode ipvlan
and a vnet header is set via setsockopt() with the option name of
PACKET_VNET_HDR, the value of offset will be nagetive in function
skb_checksum_help() and trigger the following warning:

WARNING: CPU: 3 PID: 2023 at net/core/dev.c:3262
skb_checksum_help+0x2dc/0x390
......
Call Trace:
 <TASK>
 ip_do_fragment+0x63d/0xd00
 ip_fragment.constprop.0+0xd2/0x150
 __ip_finish_output+0x154/0x1e0
 ip_finish_output+0x36/0x1b0
 ip_output+0x134/0x240
 ip_local_out+0xba/0xe0
 ipvlan_process_v4_outbound+0x26d/0x2b0
 ipvlan_xmit_mode_l3+0x44b/0x480
 ipvlan_queue_xmit+0xd6/0x1d0
 ipvlan_start_xmit+0x32/0xa0
 dev_hard_start_xmit+0xdf/0x3f0
 packet_snd+0xa7d/0x1130
 packet_sendmsg+0x7b/0xa0
 sock_sendmsg+0x14f/0x160
 __sys_sendto+0x209/0x2e0
 __x64_sys_sendto+0x7d/0x90

The root cause is:
1. skb->csum_start is set in packet_snd() according vnet_hdr:
   skb->csum_start = skb_headroom(skb) + (u32)start;

   'start' is the offset from skb->data, and mac header has been
   set at this moment.

2. when this skb arrives ipvlan_process_outbound(), the mac header
   is unset and skb_pull is called to expand the skb headroom.

3. In function skb_checksum_help(), the variable offset is calculated
   as:
      offset = skb->csum_start - skb_headroom(skb);

   since skb headroom is expanded in step2, offset is nagetive, and it
   is converted to an unsigned integer when compared with skb_headlen
   and trigger the warning.

In fact the data to be checksummed should not contain the mac header
since the mac header is stripped after a packet leaves L2 layer.
This patch fixes this by adding a check for csum_start to make it
start after the mac header.

Fixes: 52b5d6f5dcf0 ("net: make skb_partial_csum_set() more robust against overflows")
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/core/skbuff.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1a31815104d6..5e24096076fa 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5232,9 +5232,11 @@ bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off)
 	u32 csum_end = (u32)start + (u32)off + sizeof(__sum16);
 	u32 csum_start = skb_headroom(skb) + (u32)start;
 
-	if (unlikely(csum_start > U16_MAX || csum_end > skb_headlen(skb))) {
-		net_warn_ratelimited("bad partial csum: csum=%u/%u headroom=%u headlen=%u\n",
-				     start, off, skb_headroom(skb), skb_headlen(skb));
+	if (unlikely(csum_start > U16_MAX || csum_end > skb_headlen(skb) ||
+		     csum_start < skb->network_header)) {
+		net_warn_ratelimited("bad partial csum: csum=%u/%u headroom=%u headlen=%u network_header=%u\n",
+				     start, off, skb_headroom(skb),
+				     skb_headlen(skb), skb->network_header);
 		return false;
 	}
 	skb->ip_summed = CHECKSUM_PARTIAL;
-- 
2.25.1

