Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C0E9B3D5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 17:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436544AbfHWPsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 11:48:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58527 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732803AbfHWPsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 11:48:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5464A21FB5;
        Fri, 23 Aug 2019 11:48:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 23 Aug 2019 11:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=r6SHtg25+J8kkAqUE
        +++N6I18Q2YUwQNNSfVbonVy5o=; b=ImSBfEC9AvzaE074dkztOHcKyB4WCOtpr
        WgJCd6BRCPwzvUG1eJKJyp+xnPJbgqPSBmAwwWi/a2ib4d2kNfRcVozh+LH6KhB/
        Z1FNR00or1FjJwPdnKIFC7v48YAqFFgvQaZ6dwXUoAI0is9K/N9CGgyByTB680iO
        V4+QhvXUeMwS2GbfUb2VCrDsbepX6w5PNMCyTaZC8Xn8g+mwfqW3BFzIWSeLN10h
        GtGBZAdR5KUmgpvj5YgJJ4txVic7mSIIDxv7z/USnyNhRKExc6A4qOZ+EkxFVGI9
        1CUG1YOwWir9J1dRIDi8AGAjT86V9qcxzwtlvn2S/PsZLZrpjy5zQ==
X-ME-Sender: <xms:tApgXSZgjWUHJ2i68NpmdMKeRL6EPJQamWqeApLonKhKxbZpnI-pHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegkedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudejiedrfeehrddvfeenucfrrghrrghmpehmrghilh
    hfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigv
    pedt
X-ME-Proxy: <xmx:tApgXRnAQLvS-GObc8J0RKtRAaGBBoSQTluFJ7gTn_KtQM8s-4svhw>
    <xmx:tApgXUGnBLGsVMUt6AQXSd3xkg5DyoB_nfaMlq1fG5mQh-GDjM_7BQ>
    <xmx:tApgXQP_tgmDNQDY2UVkx48C0J2Qgyn5Mcd0lJIc2pg8lKrlx-vvQg>
    <xmx:tgpgXQPo9UV2XNhPohTnk2uDvVzO08HAvaT49X9v5Kq3RrUbjvNm4g>
Received: from splinter.mtl.com (bzq-79-176-35-23.red.bezeqint.net [79.176.35.23])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38016D60062;
        Fri, 23 Aug 2019 11:48:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, arnd@arndb.de,
        andrew@lunn.ch, ayal@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] drop_monitor: Make timestamps y2038 safe
Date:   Fri, 23 Aug 2019 18:47:21 +0300
Message-Id: <20190823154721.9927-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Timestamps are currently communicated to user space as 'struct
timespec', which is not considered y2038 safe since it uses a 32-bit
signed value for seconds.

Fix this while the API is still not part of any official kernel release
by using 64-bit nanoseconds timestamps instead.

Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
Arnd, I have followed your recommendation to use 64-bit nanoseconds
timestamps. I would appreciate it if you could review this change.

Thanks!
---
 include/uapi/linux/net_dropmon.h |  2 +-
 net/core/drop_monitor.c          | 14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 75a35dccb675..8bf79a9eb234 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -75,7 +75,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_PC,				/* u64 */
 	NET_DM_ATTR_SYMBOL,			/* string */
 	NET_DM_ATTR_IN_PORT,			/* nested */
-	NET_DM_ATTR_TIMESTAMP,			/* struct timespec */
+	NET_DM_ATTR_TIMESTAMP,			/* u64 */
 	NET_DM_ATTR_PROTO,			/* u16 */
 	NET_DM_ATTR_PAYLOAD,			/* binary */
 	NET_DM_ATTR_PAD,
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index bfc024024aa3..cc60cc22e2db 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -552,7 +552,7 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	       /* NET_DM_ATTR_IN_PORT */
 	       net_dm_in_port_size() +
 	       /* NET_DM_ATTR_TIMESTAMP */
-	       nla_total_size(sizeof(struct timespec)) +
+	       nla_total_size(sizeof(u64)) +
 	       /* NET_DM_ATTR_ORIG_LEN */
 	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PROTO */
@@ -592,7 +592,6 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
 	char buf[NET_DM_MAX_SYMBOL_LEN];
 	struct nlattr *attr;
-	struct timespec ts;
 	void *hdr;
 	int rc;
 
@@ -615,8 +614,8 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (rc)
 		goto nla_put_failure;
 
-	if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
-	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_TIMESTAMP,
+			      ktime_to_ns(skb->tstamp), NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
@@ -716,7 +715,7 @@ net_dm_hw_packet_report_size(size_t payload_len,
 	       /* NET_DM_ATTR_IN_PORT */
 	       net_dm_in_port_size() +
 	       /* NET_DM_ATTR_TIMESTAMP */
-	       nla_total_size(sizeof(struct timespec)) +
+	       nla_total_size(sizeof(u64)) +
 	       /* NET_DM_ATTR_ORIG_LEN */
 	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PROTO */
@@ -730,7 +729,6 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 {
 	struct net_dm_hw_metadata *hw_metadata;
 	struct nlattr *attr;
-	struct timespec ts;
 	void *hdr;
 
 	hw_metadata = NET_DM_SKB_CB(skb)->hw_metadata;
@@ -761,8 +759,8 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 			goto nla_put_failure;
 	}
 
-	if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
-	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_TIMESTAMP,
+			      ktime_to_ns(skb->tstamp), NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
-- 
2.21.0

