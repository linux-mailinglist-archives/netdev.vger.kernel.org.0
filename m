Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAE389031
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfHKHhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:37:09 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42587 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbfHKHhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:37:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3D0A619D4;
        Sun, 11 Aug 2019 03:37:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:37:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=KeMmSMJ2Ur97KJDrgpX9Ylieso6JAuIlM6hhlFSh3Mk=; b=tsIk5o0y
        5Bty2m0XWpaLB2/JETdsD733uSmJ7HWQEdKGShUNElNcK2Fn1vqUqdf8sUjn9fEB
        lcryI14797fRI1wZTFveSCkeZ+r448cBI1ch0eAwBuIZh/jrm7gWhmtq0Rho0hdo
        5c5GbkYVvDpf4EywiTjlXL033oNoRpEp+SdN+dcT0O22dOMshj6I04MDT+FbDBYT
        SH8SU+p9sXfCLilLRf2WsTOQVTxoLQfY+dyp7S3CjTnFcJcNFvLZnYLUK/B4oOwo
        XMSXDnRHdZnOS67+X1N6VyskQMyov68H0v7BHE1FSUaDD8TV9nzj7h6VjzAAeWJ1
        Tww+kfraTnNijQ==
X-ME-Sender: <xms:osVPXf0343Q8HIdolaF7tSmVrqNNK_lRdgskLO7nSs_HApPUottlxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:osVPXeyS93pqc6SS_wy_AG0ZDLNJ_bYnjjyyyFT92cLb8ar9wn-Odw>
    <xmx:osVPXeFqripkKsaUINFhPOWQhLb2b7lL-rpnmgG_azoU7EqgQGEhhA>
    <xmx:osVPXZYHA9g6xAdtg0hMR4UZhA0s3xVwgMXMCdxl8MYoAZ3lr5ARjQ>
    <xmx:osVPXXqyH6cLsFHZtAZCxYIbAWOK0CYiXiVET-BD50T0fHfnEFB3Pw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9760D8005B;
        Sun, 11 Aug 2019 03:37:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 09/10] drop_monitor: Make drop queue length configurable
Date:   Sun, 11 Aug 2019 10:35:54 +0300
Message-Id: <20190811073555.27068-10-idosch@idosch.org>
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

In packet alert mode, each CPU holds a list of dropped skbs that need to
be processed in process context and sent to user space. To avoid
exhausting the system's memory the maximum length of this queue is
currently set to 1000.

Allow users to tune the length of this queue according to their needs.
The configured length is reported to user space when drop monitor
configuration is queried.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 3b765a8428b5..1d0bdb1ba954 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -79,6 +79,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_PAD,
 	NET_DM_ATTR_TRUNC_LEN,			/* u32 */
 	NET_DM_ATTR_ORIG_LEN,			/* u32 */
+	NET_DM_ATTR_QUEUE_LEN,			/* u32 */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 135638474ab8..eb3c34d69ea9 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -78,6 +78,7 @@ static LIST_HEAD(hw_stats_list);
 
 static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
 static u32 net_dm_trunc_len;
+static u32 net_dm_queue_len = 1000;
 
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
@@ -93,8 +94,6 @@ struct net_dm_skb_cb {
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
 
-#define NET_DM_QUEUE_LEN 1000
-
 static struct sk_buff *reset_per_cpu_data(struct per_cpu_dm_data *data)
 {
 	size_t al;
@@ -289,7 +288,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	data = this_cpu_ptr(&dm_cpu_data);
 
 	spin_lock_irqsave(&data->drop_queue.lock, flags);
-	if (skb_queue_len(&data->drop_queue) < NET_DM_QUEUE_LEN)
+	if (skb_queue_len(&data->drop_queue) < net_dm_queue_len)
 		__skb_queue_tail(&data->drop_queue, nskb);
 	else
 		goto unlock_free;
@@ -643,6 +642,14 @@ static void net_dm_trunc_len_set(struct genl_info *info)
 	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
 }
 
+static void net_dm_queue_len_set(struct genl_info *info)
+{
+	if (!info->attrs[NET_DM_ATTR_QUEUE_LEN])
+		return;
+
+	net_dm_queue_len = nla_get_u32(info->attrs[NET_DM_ATTR_QUEUE_LEN]);
+}
+
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
@@ -660,6 +667,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 
 	net_dm_trunc_len_set(info);
 
+	net_dm_queue_len_set(info);
+
 	return 0;
 }
 
@@ -691,6 +700,9 @@ static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
 	if (nla_put_u32(msg, NET_DM_ATTR_TRUNC_LEN, net_dm_trunc_len))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NET_DM_ATTR_QUEUE_LEN, net_dm_queue_len))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	return 0;
@@ -763,6 +775,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_UNSPEC] = { .strict_start_type = NET_DM_ATTR_UNSPEC + 1 },
 	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
 	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
+	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops dropmon_ops[] = {
-- 
2.21.0

