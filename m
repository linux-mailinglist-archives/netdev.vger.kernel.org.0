Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F6708B4
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbfGVSdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:49 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36895 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729752AbfGVSdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 34F3E262E;
        Mon, 22 Jul 2019 14:33:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=R/UH9gDNGN7hIuqrgjcsu1MHdT/gxLrK1K6RVQeRPvY=; b=gzrna1hC
        qEmkjJ1EiBpG+gwLghGlmaFPA4m1qi//pv9s9KjHm/Pp6OaYs8tTh6NmLbpNZNe1
        iV+uM6BYqDPzYNw7xBNaVwoQio6I3VAXiNdrv5M5ZrwJzLKTWxPewydsqfWJPekM
        Dfj7aINTd/hIkQbK85pqEkick4cNPJrx4uz3c96yrcwEtcHYTo42gmCOCgy35Jqh
        2YdnJCw8fa3FCuSGFhsje1y36JfKZmNjZZnyj3YKdw6HWv7/0XgOSEfeBbKFS6JH
        vrDndnUlfWFcXrlbZP8G38AO/yatZYy1awTjM2s5gM2+c3kL80vQIZg2tF20dntq
        a5jc/U5x+KdWpQ==
X-ME-Sender: <xms:iQE2XaNDClaTvtAntZICd8mTj1xR9xkURWLWnO2khMVxK8P_rhlMbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeel
X-ME-Proxy: <xmx:igE2XTkx-e9ssmRQ09KHQVyFlijZvzGMgn7Q8SvBREZ7PtjEIHOabg>
    <xmx:igE2XdS3McXOrJt3TK_fWDlCca065yr_3k3zJCtjPFiw8r0FCn6ReQ>
    <xmx:igE2Xa-KfsPrgqvLG2PMwLCAmVGKK0fEKYZW0vQl-EKbeO0nqXY0SA>
    <xmx:igE2Xe9dFblhRRh5dtF0oPo6RGGrLRMC3xqaRQDF8Bnisc-BuSYBNQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCF2C8005A;
        Mon, 22 Jul 2019 14:33:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 11/12] drop_monitor: Allow truncation of dropped packets
Date:   Mon, 22 Jul 2019 21:31:33 +0300
Message-Id: <20190722183134.14516-12-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When sending dropped packets to user space it is not always necessary to
copy the entire packet as usually only the headers are of interest.

Allow user to specify the truncation length and add the original length
of the packet as additional metadata to the netlink message.

By default no truncation is performed.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  2 ++
 net/core/drop_monitor.c          | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 7708c8a440a1..eb36b61485ef 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -75,6 +75,8 @@ enum net_dm_attr {
 	NET_DM_ATTR_TIMESTAMP,			/* struct timespec */
 	NET_DM_ATTR_PAYLOAD,			/* binary */
 	NET_DM_ATTR_PAD,
+	NET_DM_ATTR_TRUNC_LEN,			/* u32 */
+	NET_DM_ATTR_ORIG_LEN,			/* u32 */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 512935fc235b..5af1e1e8d4d0 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -77,6 +77,7 @@ static unsigned long dm_hw_check_delta = 2*HZ;
 static LIST_HEAD(hw_stats_list);
 
 static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
+static u32 net_dm_trunc_len;
 
 struct net_dm_skb_cb {
 	void *pc;
@@ -332,6 +333,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	       nla_total_size(IFNAMSIZ + 1) +
 	       /* NET_DM_ATTR_TIMESTAMP */
 	       nla_total_size(sizeof(struct timespec)) +
+	       /* NET_DM_ATTR_ORIG_LEN */
+	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PAYLOAD */
 	       nla_total_size(payload_len);
 }
@@ -369,6 +372,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
+		goto nla_put_failure;
+
 	if (!payload_len)
 		goto out;
 
@@ -404,6 +410,8 @@ static void net_dm_packet_report(struct sk_buff *skb)
 
 	/* Ensure packet fits inside a single netlink attribute */
 	payload_len = min_t(size_t, skb->len, NET_DM_MAX_PACKET_SIZE);
+	if (net_dm_trunc_len)
+		payload_len = min_t(size_t, net_dm_trunc_len, payload_len);
 
 	msg = nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
 	if (!msg)
@@ -603,6 +611,16 @@ static int net_dm_alert_mode_set(struct genl_info *info)
 	return 0;
 }
 
+static int net_dm_trunc_len_set(struct genl_info *info)
+{
+	if (!info->attrs[NET_DM_ATTR_TRUNC_LEN])
+		return 0;
+
+	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
+
+	return 0;
+}
+
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
@@ -618,6 +636,10 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 	if (rc)
 		return rc;
 
+	rc = net_dm_trunc_len_set(info);
+	if (rc)
+		return rc;
+
 	return 0;
 }
 
@@ -676,6 +698,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_UNSPEC] = { .strict_start_type = NET_DM_ATTR_UNSPEC + 1 },
 	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
+	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops dropmon_ops[] = {
-- 
2.21.0

