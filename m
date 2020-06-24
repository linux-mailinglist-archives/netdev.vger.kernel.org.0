Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F648206EE1
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390396AbgFXIUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:39 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:36439 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390391AbgFXIUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 94DCF580522;
        Wed, 24 Jun 2020 04:20:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=seFfXLdqF66SGgYNUV1qCjr/Zd1mliHHuhwQ/TihAXw=; b=KKuBtSva
        l7i7MmW/57wkw0mA6JSaz/AE66uKYxYEl1uMZ+Mx9C7AwCnSyBw1/7sDmoygT8g7
        I3EIEDMasDjCOR6YvyanJq0G71jGDUN2uQ8NQeggDgm6yrPywBeHZRc1FDjp3gd1
        StphgS+WzSaXkt2TBf/xfAUMKkIWTbodVr45Il15GKZt3tqyaJF2JzsOjbPaDlSM
        Y7k+2j3PASZk8FYOpftsDH5l99KETK0j8KarH3S0S5vWxcA6e+1f5GUj9hg4EKzZ
        qVimpQxVMTWQwD4xJqJPyOUuCTgk6pDeGCRXN9e7sUcAWps7qrfciOe4Ei+mrj87
        Wgd8OApsHU4Ngg==
X-ME-Sender: <xms:0AzzXp_eqRe0NKI6Sp30QMuNhQUuBnoYR0qHFwQ6XEc_GXayKISqzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0AzzXtu_4BVU3A5prSVyK-H2zOjJIjD5V5vPF8BRDlJLAMVuDpQE9g>
    <xmx:0AzzXnDKVPzJV5mHJMKqy0A-iTNZwsmhpze7wQuArYuybGca69u6Lg>
    <xmx:0AzzXtc9HqLdzLjsl1O3V0Nj09XIFFD2Sg6HAkviVkM5p7yy_N8eCg>
    <xmx:0AzzXvgui61_zan44eXa8M5XtoUurK7gYLNLQwoOei2x50KuJe41Yw>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DD4230675F9;
        Wed, 24 Jun 2020 04:20:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/10] ethtool: Add link extended state
Date:   Wed, 24 Jun 2020 11:19:18 +0300
Message-Id: <20200624081923.89483-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Currently, drivers can only tell whether the link is up/down using
LINKSTATE_GET, but no additional information is given.

Add attributes to LINKSTATE_GET command in order to allow drivers
to expose the user more information in addition to link state to ease
the debug process, for example, reason for link down state.

Extended state consists of two attributes - link_ext_state and link_ext_substate.
The idea is to avoid 'vendor specific' states in order to prevent
drivers to use specific link_ext_state that can be in the future common
link_ext_state.

The substates allows drivers to add more information to the common
link_ext_state. For example, vendor can expose 'Autoneg' as link_ext_state and add
'No partner detected during force mode' as link_ext_substate.

If a driver cannot pinpoint the extended state with the substate
accuracy, it is free to expose only the extended state and omit the
substate attribute.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/linux/ethtool.h              | 22 +++++++++
 include/uapi/linux/ethtool.h         | 70 ++++++++++++++++++++++++++++
 include/uapi/linux/ethtool_netlink.h |  2 +
 net/ethtool/linkstate.c              | 56 ++++++++++++++++++++--
 4 files changed, 145 insertions(+), 5 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a23b26eab479..be2fd37ec84a 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -86,6 +86,22 @@ struct net_device;
 u32 ethtool_op_get_link(struct net_device *dev);
 int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
 
+
+/**
+ * struct ethtool_link_ext_state_info - link extended state and substate.
+ */
+struct ethtool_link_ext_state_info {
+	enum ethtool_link_ext_state link_ext_state;
+	union {
+		enum ethtool_link_ext_substate_autoneg autoneg;
+		enum ethtool_link_ext_substate_link_training link_training;
+		enum ethtool_link_ext_substate_link_logical_mismatch link_logical_mismatch;
+		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
+		enum ethtool_link_ext_substate_cable_issue cable_issue;
+		int __link_ext_substate;
+	};
+};
+
 /**
  * ethtool_rxfh_indir_default - get default value for RX flow hash indirection
  * @index: Index in RX flow hash indirection table
@@ -245,6 +261,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  * @get_link: Report whether physical link is up.  Will only be called if
  *	the netdev is up.  Should usually be set to ethtool_op_get_link(),
  *	which uses netif_carrier_ok().
+ * @get_link_ext_state: Report link extended state. Should set link_ext_state and
+ *	link_ext_substate (link_ext_substate of 0 means link_ext_substate is unknown,
+ *	do not attach ext_substate attribute to netlink message). If not
+ *	implemented, link_ext_state and link_ext_substate will not be sent to userspace.
  * @get_eeprom: Read data from the device EEPROM.
  *	Should fill in the magic field.  Don't need to check len for zero
  *	or wraparound.  Fill in the data argument with the eeprom values
@@ -384,6 +404,8 @@ struct ethtool_ops {
 	void	(*set_msglevel)(struct net_device *, u32);
 	int	(*nway_reset)(struct net_device *);
 	u32	(*get_link)(struct net_device *);
+	int	(*get_link_ext_state)(struct net_device *,
+				      struct ethtool_link_ext_state_info *);
 	int	(*get_eeprom_len)(struct net_device *);
 	int	(*get_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f4662b3a9e1e..58cee8c2c292 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -579,6 +579,76 @@ struct ethtool_pauseparam {
 	__u32	tx_pause;
 };
 
+/**
+ * enum ethtool_link_ext_state - link extended state
+ */
+enum ethtool_link_ext_state {
+	ETHTOOL_LINK_EXT_STATE_AUTONEG,
+	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+	ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+	ETHTOOL_LINK_EXT_STATE_NO_CABLE,
+	ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
+	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_autoneg - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_AUTONEG.
+ */
+enum ethtool_link_ext_substate_autoneg {
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
+};
+
+/**
+ * enum ethtool_link_ext_substate_link_training - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
+ */
+enum ethtool_link_ext_substate_link_training {
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_logical_mismatch - more information in addition
+ * to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
+ */
+enum ethtool_link_ext_substate_link_logical_mismatch {
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
+};
+
+/**
+ * enum ethtool_link_ext_substate_bad_signal_integrity - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+ */
+enum ethtool_link_ext_substate_bad_signal_integrity {
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+};
+
+/**
+ * enum ethtool_link_ext_substate_cable_issue - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE.
+ */
+enum ethtool_link_ext_substate_cable_issue {
+	ETHTOOL_LINK_EXT_SUBSTATE_UNSUPPORTED_CABLE = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_CABLE_TEST_FAILURE,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 4dda5e4244a7..c12ce4df4b6b 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -236,6 +236,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
 	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
 	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
+	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
+	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 7f47ba89054e..8bc1b3c5ad4d 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -9,10 +9,12 @@ struct linkstate_req_info {
 };
 
 struct linkstate_reply_data {
-	struct ethnl_reply_data		base;
-	int				link;
-	int				sqi;
-	int				sqi_max;
+	struct ethnl_reply_data			base;
+	int					link;
+	int					sqi;
+	int					sqi_max;
+	bool					link_ext_state_provided;
+	struct ethtool_link_ext_state_info	ethtool_link_ext_state_info;
 };
 
 #define LINKSTATE_REPDATA(__reply_base) \
@@ -25,6 +27,8 @@ linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_EXT_STATE]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE]	= { .type = NLA_REJECT },
 };
 
 static int linkstate_get_sqi(struct net_device *dev)
@@ -61,6 +65,25 @@ static int linkstate_get_sqi_max(struct net_device *dev)
 	mutex_unlock(&phydev->lock);
 
 	return ret;
+};
+
+static int linkstate_get_link_ext_state(struct net_device *dev,
+					struct linkstate_reply_data *data)
+{
+	int err;
+
+	if (!dev->ethtool_ops->get_link_ext_state)
+		return -EOPNOTSUPP;
+
+	err = dev->ethtool_ops->get_link_ext_state(dev, &data->ethtool_link_ext_state_info);
+	if (err) {
+		data->link_ext_state_provided = false;
+		return err;
+	}
+
+	data->link_ext_state_provided = true;
+
+	return 0;
 }
 
 static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
@@ -69,7 +92,7 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 {
 	struct linkstate_reply_data *data = LINKSTATE_REPDATA(reply_base);
 	struct net_device *dev = reply_base->dev;
-	int ret;
+	int ret, err;
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
@@ -88,6 +111,12 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 
 	data->sqi_max = ret;
 
+	if (dev->flags & IFF_UP) {
+		err = linkstate_get_link_ext_state(dev, data);
+		if (err < 0 && err != -EOPNOTSUPP && err != -ENODATA)
+			return err;
+	}
+
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -108,6 +137,12 @@ static int linkstate_reply_size(const struct ethnl_req_info *req_base,
 	if (data->sqi_max != -EOPNOTSUPP)
 		len += nla_total_size(sizeof(u32));
 
+	if (data->link_ext_state_provided)
+		len += nla_total_size(sizeof(u8)); /* LINKSTATE_EXT_STATE */
+
+	if (data->ethtool_link_ext_state_info.__link_ext_substate)
+		len += nla_total_size(sizeof(u8)); /* LINKSTATE_EXT_SUBSTATE */
+
 	return len;
 }
 
@@ -129,6 +164,17 @@ static int linkstate_fill_reply(struct sk_buff *skb,
 	    nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI_MAX, data->sqi_max))
 		return -EMSGSIZE;
 
+	if (data->link_ext_state_provided) {
+		if (nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_STATE,
+			       data->ethtool_link_ext_state_info.link_ext_state))
+			return -EMSGSIZE;
+
+		if (data->ethtool_link_ext_state_info.__link_ext_substate &&
+		    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,
+			       data->ethtool_link_ext_state_info.__link_ext_substate))
+			return -EMSGSIZE;
+	}
+
 	return 0;
 }
 
-- 
2.26.2

