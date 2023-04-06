Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2F56D9ECA
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbjDFRdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbjDFRd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:33:26 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FC09012
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:33:15 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EAF4E40004;
        Thu,  6 Apr 2023 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680802394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KPqk2KxJIKptib5iRH01V/CYIzs4u7kdne+zBfrxPM=;
        b=eQcDAo9cK4kjM9z+oTGdTwnxGvwTtcmxA4SmCrLjRgAk/Q6y7T/b/yTiYZaI9C5fqOmxk9
        2F2f1Plc4fBW8hz/L9jbDI+7ffl6uK6Y/svVV/q5qxpr3jL19jPRW1/GT8zjN3c13+azbg
        enKMYOZQzCQsDMYfCHe5mWk4WAvudCyLjhAolvwMUKjON2doSfNy48PL6fzpDtG/mpneCK
        rJlezccFJJ8w6ZSNHiIGugySFLuplBwDN5m9zySKpBFppQot02W19Y1HFMvTh+IY8mufgA
        MfkYZxwmd5pP5lF2GHyeS+hdnuNNjwSyKincOzqVuteabBGu3UAQ0W3RZZBzEQ==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk,
        Kory Maincent <kory.maincent@bootlin.com>
Subject: [PATCH net-next RFC v4 2/5] net: Expose available time stamping layers to user space.
Date:   Thu,  6 Apr 2023 19:33:05 +0200
Message-Id: <20230406173308.401924-3-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230406173308.401924-1-kory.maincent@bootlin.com>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kory Maincent <kory.maincent@bootlin.com>

Time stamping on network packets may happen either in the MAC or in
the PHY, but not both.  In preparation for making the choice
selectable, expose both the current and available layers via ethtool.

In accordance with the kernel implementation as it stands, the current
layer will always read as "phy" when a PHY time stamping device is
present.  Future patches will allow changing the current layer
administratively.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    Changes in v2:
    - Move the introduction of selected_timestamping_layer variable in next
      patch.
    
    Changes in v3:
    - Move on to ethtool instead of syfs
    
    Changes in v4:
    - Move on to netlink ethtool instead of ioctl. I am not familiar with
      netlink so there might be some code that does not follow the good code
      practice.

 Documentation/networking/ethtool-netlink.rst |  40 +++++++
 include/uapi/linux/ethtool_netlink.h         |  15 +++
 include/uapi/linux/net_tstamp.h              |   8 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |  20 ++++
 net/ethtool/netlink.h                        |   3 +
 net/ethtool/ts.c                             | 114 +++++++++++++++++++
 7 files changed, 201 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/ts.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index cd0973d4ba01..539425fdaf7c 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -210,6 +210,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_EEE_GET``               get EEE settings
   ``ETHTOOL_MSG_EEE_SET``               set EEE settings
   ``ETHTOOL_MSG_TSINFO_GET``		get timestamping info
+  ``ETHTOOL_MSG_TS_GET``                get current hardware timestamping
+  ``ETHTOOL_MSG_TSLIST_GET``            list available hardware timestamping
   ``ETHTOOL_MSG_CABLE_TEST_ACT``        action start cable test
   ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``    action start raw TDR cable test
   ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
@@ -1990,6 +1992,42 @@ The attributes are propagated to the driver through the following structure:
 .. kernel-doc:: include/linux/ethtool.h
     :identifiers: ethtool_mm_cfg
 
+TS_GET
+======
+
+Gets transceiver module parameters.
+
+Request contents:
+
+  =================================  ======  ==========================
+  ``ETHTOOL_A_TS_HEADER``            nested  request header
+  =================================  ======  ==========================
+
+Kernel response contents:
+
+  =======================  ======  ====================================
+  ``ETHTOOL_A_TS_HEADER``  nested  reply header
+  ``ETHTOOL_A_TS_LAYER``   u32     current hardware timestamping
+  =======================  ======  ====================================
+
+TSLIST_GET
+==========
+
+Gets transceiver module parameters.
+
+Request contents:
+
+  =================================  ======  ==========================
+  ``ETHTOOL_A_TS_HEADER``            nested  request header
+  =================================  ======  ==========================
+
+Kernel response contents:
+
+  =======================  ======  ===================================
+  ``ETHTOOL_A_TS_HEADER``  nested  reply header
+  ``ETHTOOL_A_TS_LAYER``   u32     available hardware timestamping
+  =======================  ======  ===================================
+
 Request translation
 ===================
 
@@ -2096,4 +2134,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PLCA_GET_STATUS``
   n/a                                 ``ETHTOOL_MSG_MM_GET``
   n/a                                 ``ETHTOOL_MSG_MM_SET``
+  n/a                                 ``ETHTOOL_MSG_TS_GET``
+  n/a                                 ``ETHTOOL_MSG_TSLIST_GET``
   =================================== =====================================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 1ebf8d455f07..447908393b91 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -39,6 +39,8 @@ enum {
 	ETHTOOL_MSG_EEE_GET,
 	ETHTOOL_MSG_EEE_SET,
 	ETHTOOL_MSG_TSINFO_GET,
+	ETHTOOL_MSG_TSLIST_GET,
+	ETHTOOL_MSG_TS_GET,
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
@@ -92,6 +94,8 @@ enum {
 	ETHTOOL_MSG_EEE_GET_REPLY,
 	ETHTOOL_MSG_EEE_NTF,
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
+	ETHTOOL_MSG_TSLIST_GET_REPLY,
+	ETHTOOL_MSG_TS_GET_REPLY,
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
@@ -484,6 +488,17 @@ enum {
 	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
 };
 
+/* TS LAYER */
+
+enum {
+	ETHTOOL_A_TS_UNSPEC,
+	ETHTOOL_A_TS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_TS_LAYER,			/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TS_CNT,
+	ETHTOOL_A_TS_MAX = (__ETHTOOL_A_TS_CNT - 1)
+};
 /* PHC VCLOCKS */
 
 enum {
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index a2c66b3d7f0f..d7c1798d45fe 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -13,6 +13,14 @@
 #include <linux/types.h>
 #include <linux/socket.h>   /* for SO_TIMESTAMPING */
 
+/* Hardware layer of the SO_TIMESTAMPING provider */
+enum timestamping_layer {
+	SOF_MAC_TIMESTAMPING = (1<<0),
+	SOF_PHY_TIMESTAMPING = (1<<1),
+
+	SOF_LAYER_TIMESTAMPING_LAST = SOF_PHY_TIMESTAMPING,
+};
+
 /* SO_TIMESTAMPING flags */
 enum {
 	SOF_TIMESTAMPING_TX_HARDWARE = (1<<0),
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 504f954a1b28..4ea64c080639 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -8,4 +8,4 @@ ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o mm.o \
-		   module.o pse-pd.o plca.o mm.o
+		   module.o pse-pd.o plca.o mm.o ts.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 08120095cc68..8d9e27b13e28 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -293,6 +293,8 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_FEC_SET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
+	[ETHTOOL_MSG_TS_GET]		= &ethnl_ts_request_ops,
+	[ETHTOOL_MSG_TSLIST_GET]	= &ethnl_tslist_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
@@ -1011,6 +1013,24 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_tsinfo_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_tsinfo_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_TSLIST_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_ts_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ts_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_TS_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_ts_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ts_get_policy) - 1,
+	},
 	{
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_ACT,
 		.flags	= GENL_UNS_ADMIN_PERM,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 79424b34b553..49c700777a32 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -385,6 +385,8 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_ts_request_ops;
+extern const struct ethnl_request_ops ethnl_tslist_request_ops;
 extern const struct ethnl_request_ops ethnl_fec_request_ops;
 extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
@@ -423,6 +425,7 @@ extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
 extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_TX_LPI_TIMER + 1];
 extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER + 1];
+extern const struct nla_policy ethnl_ts_get_policy[ETHTOOL_A_TS_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
diff --git a/net/ethtool/ts.c b/net/ethtool/ts.c
new file mode 100644
index 000000000000..a71c47ff0c6b
--- /dev/null
+++ b/net/ethtool/ts.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/net_tstamp.h>
+#include <linux/phy.h>
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct ts_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct ts_reply_data {
+	struct ethnl_reply_data		base;
+	u32				ts;
+};
+
+#define TS_REPDATA(__reply_base) \
+	container_of(__reply_base, struct ts_reply_data, base)
+
+/* TS_GET */
+const struct nla_policy ethnl_ts_get_policy[] = {
+	[ETHTOOL_A_TS_HEADER]		=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int ts_prepare_data(const struct ethnl_req_info *req_base,
+			       struct ethnl_reply_data *reply_base,
+			       struct genl_info *info)
+{
+	struct ts_reply_data *data = TS_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	if (phy_has_tsinfo(dev->phydev))
+		data->ts = SOF_PHY_TIMESTAMPING;
+	else if (ops->get_ts_info)
+		data->ts = SOF_MAC_TIMESTAMPING;
+	else
+		return -EOPNOTSUPP;
+
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int ts_reply_size(const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u32));
+}
+
+static int ts_fill_reply(struct sk_buff *skb,
+			     const struct ethnl_req_info *req_base,
+			     const struct ethnl_reply_data *reply_base)
+{
+	struct ts_reply_data *data = TS_REPDATA(reply_base);
+	return nla_put_u32(skb, ETHTOOL_A_TS_LAYER, data->ts);
+}
+
+const struct ethnl_request_ops ethnl_ts_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_TS_GET,
+	.reply_cmd		= ETHTOOL_MSG_TS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_TS_HEADER,
+	.req_info_size		= sizeof(struct ts_req_info),
+	.reply_data_size	= sizeof(struct ts_reply_data),
+
+	.prepare_data		= ts_prepare_data,
+	.reply_size		= ts_reply_size,
+	.fill_reply		= ts_fill_reply,
+};
+
+/* TSLIST_GET */
+static int tslist_prepare_data(const struct ethnl_req_info *req_base,
+			       struct ethnl_reply_data *reply_base,
+			       struct genl_info *info)
+{
+	struct ts_reply_data *data = TS_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	data->ts = 0;
+	if (phy_has_tsinfo(dev->phydev))
+		data->ts = SOF_PHY_TIMESTAMPING;
+	if (ops->get_ts_info)
+		data->ts |= SOF_MAC_TIMESTAMPING;
+
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+const struct ethnl_request_ops ethnl_tslist_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_TSLIST_GET,
+	.reply_cmd		= ETHTOOL_MSG_TSLIST_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_TS_HEADER,
+	.req_info_size		= sizeof(struct ts_req_info),
+	.reply_data_size	= sizeof(struct ts_reply_data),
+
+	.prepare_data		= tslist_prepare_data,
+	.reply_size		= ts_reply_size,
+	.fill_reply		= ts_fill_reply,
+};
-- 
2.25.1

