Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6068902F
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfHKHhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:37:04 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36561 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfHKHhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:37:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3644919C0;
        Sun, 11 Aug 2019 03:37:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=x2xuAtt41uywrkH7ZSffXkkhCQnkRbOcSlHetzMqqAM=; b=MCRycAUT
        Nb20ihQhmXDRlhN4b4yUwm5adQKh6k9nsVWtNrp+VLoMBpGtHZ0Zwr28ISwvION+
        PX3xrqVIJd/8ZJy/SlBTFpGYuM0lDmoCrr3DAjXPzTCW+8KIjjUafN+p42m4wbSW
        Ywoh44J3ZAuf5LMkTwHqexioyPiOVYZdU2SaiTY09u0mRJ6GPt5lBC/m63snzjjx
        /wG3iV7WjRMF9QkYoh3HsHEye+jkL2xi1KQH6luK770Z7YaB9vkoQMW56SwxNrcW
        +Kg9hbn7rvItV4eGacngJ0k98DBCXOgp5rV5JKAgKNo/jvVc8N7TsY+8WbybwlIN
        kNsZ9a4/mc0QYA==
X-ME-Sender: <xms:nMVPXckvRfGec15IMhqMayw3i5LF54i1b4AL1gi12hHRt-LPSIr6CA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:ncVPXSQQekii4kK8ouDH_I2UFoH7M2ISwhX9d7_g__Nhbl8YXIn3hg>
    <xmx:ncVPXYLrt2lHv1iXww8y2dyFCLbujLRgRBvf4AmaxzXXdOHwZNYYXg>
    <xmx:ncVPXQ8geJdJF9_ylsqcKsh_8oR5VAurbx92-r7k1QGWJSaziXPI8A>
    <xmx:ncVPXQMOs5-1dOydU6sK3PPBgj5LDQyhwb79SI2XGHHZZoRqIELxMQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91E9C80059;
        Sun, 11 Aug 2019 03:36:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/10] drop_monitor: Allow truncation of dropped packets
Date:   Sun, 11 Aug 2019 10:35:52 +0300
Message-Id: <20190811073555.27068-8-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811073555.27068-1-idosch@idosch.org>
References: <20190811073555.27068-1-idosch@idosch.org>
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
index cfaaf75371b8..5cd7eb1f66ba 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -75,6 +75,8 @@ enum net_dm_attr {
 	NET_DM_ATTR_PROTO,			/* u16 */
 	NET_DM_ATTR_PAYLOAD,			/* binary */
 	NET_DM_ATTR_PAD,
+	NET_DM_ATTR_TRUNC_LEN,			/* u32 */
+	NET_DM_ATTR_ORIG_LEN,			/* u32 */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index ba765832413b..9f884adaa85f 100644
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
 	       /* NET_DM_ATTR_PROTO */
 	       nla_total_size(sizeof(u16)) +
 	       /* NET_DM_ATTR_PAYLOAD */
@@ -391,6 +394,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))
+		goto nla_put_failure;
+
 	if (!payload_len)
 		goto out;
 
@@ -429,6 +435,8 @@ static void net_dm_packet_report(struct sk_buff *skb)
 
 	/* Ensure packet fits inside a single netlink attribute */
 	payload_len = min_t(size_t, skb->len, NET_DM_MAX_PACKET_SIZE);
+	if (net_dm_trunc_len)
+		payload_len = min_t(size_t, net_dm_trunc_len, payload_len);
 
 	msg = nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
 	if (!msg)
@@ -627,6 +635,14 @@ static int net_dm_alert_mode_set(struct genl_info *info)
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
@@ -642,6 +658,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 	if (rc)
 		return rc;
 
+	net_dm_trunc_len_set(info);
+
 	return 0;
 }
 
@@ -700,6 +718,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_UNSPEC] = { .strict_start_type = NET_DM_ATTR_UNSPEC + 1 },
 	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
+	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops dropmon_ops[] = {
-- 
2.21.0

