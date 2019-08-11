Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA6C89030
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHKHhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:37:05 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36061 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbfHKHhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:37:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id AA6FA198D;
        Sun, 11 Aug 2019 03:37:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=BIiJDGROt4GB/Ahp+vm95FtF+LH6JbWYhCgO9HogDD0=; b=odxWRgcM
        hD3bo4zbyKC1uVFjGuIDj/2zFcrwmKAfcYUZ0DGxcmgruXuFbcUP0RA60UxXt+oq
        k5EPANBp2YxWEBiPGIJPEp/0auFogPfUlViXt+d4kjMOZkTSA5ETK5nQA3XZt8pM
        DZjv8MzNFIYUzz/LdGFRqP4d6q+BUo33pU2DAvtJTIOeUkh5mAVqmXpGuuuHXXN5
        3NecluweyTkWRbH0q7O9yJO1nvRVM+PgjabWwQlxKJxzgZwhTFwk/AHN65xJjsbH
        +T09PdwINwkvzNS9DDJ1wSZPlrUUKzWwyoWGNorc5/aflgrEgwc5adedx5/Ed/zl
        GqZ6Y7NyjtmVUA==
X-ME-Sender: <xms:n8VPXcjZfOsNRceMVJscIm-lqrGusE-OqP77ccAK1HVk01ddHzX1wQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:n8VPXWEh44uejbCxvOwCHeQit-rSzyixlZBmWviD9Wh17Sac7FzwuQ>
    <xmx:n8VPXXAxprl4y8v7mHS1OKqM_2AW1Fzf5aoV-uCmDU4s5xzu6H6jSA>
    <xmx:n8VPXa_yR2ItGnXulNaoy3rgtpNjRHt4dB9FQadYPCbs3_jN5rZLrw>
    <xmx:n8VPXfQRTBMKQYJuWR5GGpifrr5SJe0m-szastK8bi_fbNVXFwoEgw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D8898005C;
        Sun, 11 Aug 2019 03:37:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/10] drop_monitor: Add a command to query current configuration
Date:   Sun, 11 Aug 2019 10:35:53 +0300
Message-Id: <20190811073555.27068-9-idosch@idosch.org>
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

Users should be able to query the current configuration of drop monitor
before they start using it. Add a command to query the existing
configuration which currently consists of alert mode and packet
truncation length.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/net_dropmon.h |  2 ++
 net/core/drop_monitor.c          | 48 ++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 5cd7eb1f66ba..3b765a8428b5 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -54,6 +54,8 @@ enum {
 	NET_DM_CMD_START,
 	NET_DM_CMD_STOP,
 	NET_DM_CMD_PACKET_ALERT,
+	NET_DM_CMD_CONFIG_GET,
+	NET_DM_CMD_CONFIG_NEW,
 	_NET_DM_CMD_MAX,
 };
 
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9f884adaa85f..135638474ab8 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -676,6 +676,50 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &net_drop_monitor_family, 0, NET_DM_CMD_CONFIG_NEW);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(msg, NET_DM_ATTR_ALERT_MODE, net_dm_alert_mode))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NET_DM_ATTR_TRUNC_LEN, net_dm_trunc_len))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int net_dm_cmd_config_get(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	int rc;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	rc = net_dm_config_fill(msg, info);
+	if (rc)
+		goto free_msg;
+
+	return genlmsg_reply(msg, info);
+
+free_msg:
+	nlmsg_free(msg);
+	return rc;
+}
+
 static int dropmon_net_event(struct notifier_block *ev_block,
 			     unsigned long event, void *ptr)
 {
@@ -738,6 +782,10 @@ static const struct genl_ops dropmon_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = net_dm_cmd_trace,
 	},
+	{
+		.cmd = NET_DM_CMD_CONFIG_GET,
+		.doit = net_dm_cmd_config_get,
+	},
 };
 
 static int net_dm_nl_pre_doit(const struct genl_ops *ops,
-- 
2.21.0

