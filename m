Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FAE8498F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfHGKb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:31:57 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37435 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729495AbfHGKbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:31:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 58BFC15EB;
        Wed,  7 Aug 2019 06:31:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=NEpfo1sARwye2Rtp6K2gNB6AHArBy4NgIsnRVq+Yqcc=; b=YVCLtMO/
        DX9OGrZpckIY8YJj5Hy24B3cQelSfn7vOzJTMcGRJCDCppe8d0jms9pS8OBVuDlJ
        PEayfuey2EXixvOMt8oqjNJziH4WUPafNHJ9SDYcylfSHPTxshgLWxeqwmjaPvyt
        dbS118uOX9vx6S66D5NFvbbRPebbJfqV4K75+zRbyaR4JuIJLfxNKaWbIeBblA28
        x6xVuek2fGdnte49VHQHUrDRI8vcOTMfbmvANNTuhcHKkN1RLqZT9MCYOTt9QZiR
        yJlCVf48HuyYQjXwQHsb/ueWZ6QYiDI5OXpLdKCa0BfMnmiVH0h3bByWInPSYtu3
        x+zBJ1UWpCKG9Q==
X-ME-Sender: <xms:mqhKXYyy5cSfp1_bmWJ1-D5yiRpqGSaBmhExAF3ahTGGvCeRGvIqlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:mqhKXQjDa9YGVWwKtVI94WdchcCjS1M53xWLGursNYosE53qDsOcPg>
    <xmx:mqhKXVUnJppBzeZi3pqarOLyzkprNN7Fy3FkpFaNEtaXolxDMy7K4Q>
    <xmx:mqhKXa0m8PAmhm-EcNS_TSWzDI_aet-9_C5FG8CN2AyjLqAXiC9LUw>
    <xmx:mqhKXeJTJUqlkoHdFQW8Fl2jDlSZY8rw_aluLwafELjDxfriaK6j3w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59F45380090;
        Wed,  7 Aug 2019 06:31:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/10] drop_monitor: Allow truncation of dropped packets
Date:   Wed,  7 Aug 2019 13:30:56 +0300
Message-Id: <20190807103059.15270-8-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190807103059.15270-1-idosch@idosch.org>
References: <20190807103059.15270-1-idosch@idosch.org>
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
 net/core/drop_monitor.c          | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 22c6108dcfd4..9c7b3ea44ee5 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -74,6 +74,8 @@ enum net_dm_attr {
 	NET_DM_ATTR_TIMESTAMP,			/* struct timespec */
 	NET_DM_ATTR_PAYLOAD,			/* binary */
 	NET_DM_ATTR_PAD,
+	NET_DM_ATTR_TRUNC_LEN,			/* u32 */
+	NET_DM_ATTR_ORIG_LEN,			/* u32 */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 5fa0b34033d0..440766e1f260 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -77,6 +77,7 @@ static unsigned long dm_hw_check_delta = 2*HZ;
 static LIST_HEAD(hw_stats_list);
 
 static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
+static u32 net_dm_trunc_len;
 
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
@@ -334,6 +335,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	       net_dm_in_port_size() +
 	       /* NET_DM_ATTR_TIMESTAMP */
 	       nla_total_size(sizeof(struct timespec)) +
+	       /* NET_DM_ATTR_ORIG_LEN */
+	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PAYLOAD */
 	       nla_total_size(payload_len);
 }
@@ -389,6 +392,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
+		goto nla_put_failure;
+
 	if (!payload_len)
 		goto out;
 
@@ -424,6 +430,8 @@ static void net_dm_packet_report(struct sk_buff *skb)
 
 	/* Ensure packet fits inside a single netlink attribute */
 	payload_len = min_t(size_t, skb->len, NET_DM_MAX_PACKET_SIZE);
+	if (net_dm_trunc_len)
+		payload_len = min_t(size_t, net_dm_trunc_len, payload_len);
 
 	msg = nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
 	if (!msg)
@@ -622,6 +630,14 @@ static int net_dm_alert_mode_set(struct genl_info *info)
 	return 0;
 }
 
+static void net_dm_trunc_len_set(struct genl_info *info)
+{
+	if (!info->attrs[NET_DM_ATTR_TRUNC_LEN])
+		return;
+
+	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
+}
+
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
@@ -637,6 +653,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 	if (rc)
 		return rc;
 
+	net_dm_trunc_len_set(info);
+
 	return 0;
 }
 
@@ -695,6 +713,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_UNSPEC] = { .strict_start_type = NET_DM_ATTR_UNSPEC + 1 },
 	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
+	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops dropmon_ops[] = {
-- 
2.21.0

