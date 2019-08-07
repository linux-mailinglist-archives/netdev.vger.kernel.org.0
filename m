Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483A784993
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfHGKb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:31:59 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:36099 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729568AbfHGKb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:31:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D21581674;
        Wed,  7 Aug 2019 06:31:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:31:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GJFe/O8sSnZD/3D9EJvgJXFl/zBoW//k0mkiU90zOZ0=; b=09ubbFat
        JZ4FvKVKzWeIDAxs4BOL8gXE3AIcJeqPEODk09JIpQ52osAAgBB+M5/VJAS9aSub
        +qAqyIDQo4BNste/BCiU7O6/vfj+lQQ3H6L1Z2ONv74g65J8HJdiIWyesP3b15ay
        UFUU1hAmkeIfOnutPIFv75KfWSARfz0PZ1TSo9Xebg2yUeLM3ZhUtmfib5jg9KIl
        P8F9IMZtGXzu72Yahbdqw5RaJ+oMiFQNndvEJd0P6i6jjvBJ9iRqhELmZljX+Mac
        PsdEXAybFTV7A9mx371ppf/BFbU2o0SOuYL7C0+uc5g0rCaB05MxcAu9ccL2ZJnC
        nLlRuzVN79weeA==
X-ME-Sender: <xms:nKhKXbNzUoJ7RA-7PeqUtw0_urSyDeKnScA2oO0j-y5wp_WtazByiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:nKhKXUcoFg7o_lSh4ouRBhkJ1myUZe5YBmKCfSd2HsYPKQMV4WBZWQ>
    <xmx:nKhKXQ9mzOT_ZB-eCB-ZRfimqOUe6YyERqPGktoaP2tWZ5A9jhEC5g>
    <xmx:nKhKXe3YwbL2e-Bjpibrdgli12oA9Zn4o4ihEkqkFiRT7lpBDZ8KLg>
    <xmx:nKhKXcn8TnQTs3Sz0yxBTEuKlf_rkSy5XBXTYf82xQzU5DAj_U1k1w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 347BA380083;
        Wed,  7 Aug 2019 06:31:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/10] drop_monitor: Add a command to query current configuration
Date:   Wed,  7 Aug 2019 13:30:57 +0300
Message-Id: <20190807103059.15270-9-idosch@idosch.org>
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
index 9c7b3ea44ee5..7b15f632c045 100644
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
index 440766e1f260..f5dfad283fe2 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -671,6 +671,50 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
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
@@ -733,6 +777,10 @@ static const struct genl_ops dropmon_ops[] = {
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

