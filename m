Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFAA61073C
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 03:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiJ1B1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 21:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiJ1B1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 21:27:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7448A98E9;
        Thu, 27 Oct 2022 18:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA77625AF;
        Fri, 28 Oct 2022 01:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7849C43470;
        Fri, 28 Oct 2022 01:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666920441;
        bh=4lA8EUMV061NUVE2mYXUtkaSUiI75YYA0uKRElWxl6I=;
        h=From:To:Cc:Subject:Date:From;
        b=YZVZ4gyNrnB/MA/o6bnern910SiS2J/OE77bbVNz+6Ne9Npwtem7kPPbdDw9hVrq5
         dYzSK70A4T2l+t8rrdzRl/fXL5IA8Lz8Mdq9CvWNLlrhZvpxBOjF4aa+6uWDIdUFwH
         6B1ebgqgyP6i20LPgEKAVwVWK4lj/Z/vFtNChIbr+0CnD5TTXpV+k+RWFbJos19wBU
         UbhrkAgjx3c86u5WiQrKV+yDKvzK+h5CS4QA6ilRzmOjuu0DmreXOSGMVYzHCWwOXs
         RFzndEOXe6prk+PTScS+O4Z7Y87CeCli3XGtJ45j/GXkSeAwmVrUtZdAS/0XBSTq1N
         zg1Gn2Be1xbBQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        michael.chan@broadcom.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
Subject: [PATCH net-next v2] ethtool: linkstate: add a statistic for PHY down events
Date:   Thu, 27 Oct 2022 18:27:19 -0700
Message-Id: <20221028012719.2702267-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous attempt to augment carrier_down (see Link)
was not met with much enthusiasm so let's do the simple
thing of exposing what some devices already maintain.
Add a common ethtool statistic for link going down.
Currently users have to maintain per-driver mapping
to extract the right stat from the vendor-specific ethtool -S
stats. carrier_down does not fit the bill because it counts
a lot of software related false positives.

Add the statistic to the extended link state API to steer
vendors towards implementing all of it.

Implement for bnxt and all Linux-controlled PHYs. mlx5 and (possibly)
enic also have a counter for this but I leave the implementation
to their maintainers.

Link: https://lore.kernel.org/r/20220520004500.2250674-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
The Linux PHY part is compile-tested only. Could anyone
(who's not at netdev conf?) help testing it?

v2:
  - add the support for all Linux-driven PHYs
  - LinkDownEvents -> link_down_events
v1: https://lore.kernel.org/all/20221026020948.1913777-1-kuba@kernel.org/
---
CC: corbet@lwn.net
CC: michael.chan@broadcom.com
CC: andrew@lunn.ch
CC: hkallweit1@gmail.com
CC: linux@armlinux.org.uk
CC: huangguangbin2@huawei.com
CC: chenhao288@hisilicon.com
CC: moshet@nvidia.com
CC: linux@rempel-privat.de
CC: linux-doc@vger.kernel.org
---
 Documentation/networking/ethtool-netlink.rst  |  1 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 +++++++++++
 drivers/net/phy/phy.c                         |  1 +
 include/linux/ethtool.h                       | 14 +++++++++++
 include/linux/phy.h                           |  3 +++
 include/uapi/linux/ethtool_netlink.h          |  2 ++
 net/ethtool/linkstate.c                       | 25 ++++++++++++++++++-
 7 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d578b8bcd8a4..5454aa6c013c 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -491,6 +491,7 @@ any attributes.
   ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
   ``ETHTOOL_A_LINKSTATE_EXT_STATE``     u8      link extended state
   ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``  u8      link extended substate
+  ``ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT``  u64     count of link down events
   ====================================  ======  ============================
 
 For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index cc89e5eabcb9..d8f0351df954 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -4112,6 +4112,20 @@ static void bnxt_get_rmon_stats(struct net_device *dev,
 	*ranges = bnxt_rmon_ranges;
 }
 
+static void bnxt_get_link_ext_stats(struct net_device *dev,
+				    struct ethtool_link_ext_stats *stats)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u64 *rx;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS_EXT))
+		return;
+
+	rx = bp->rx_port_stats_ext.sw_stats;
+	stats->link_down_events =
+		*(rx + BNXT_RX_STATS_EXT_OFFSET(link_down_events));
+}
+
 void bnxt_ethtool_free(struct bnxt *bp)
 {
 	kfree(bp->test_info);
@@ -4161,6 +4175,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.get_eeprom             = bnxt_get_eeprom,
 	.set_eeprom		= bnxt_set_eeprom,
 	.get_link		= bnxt_get_link,
+	.get_link_ext_stats	= bnxt_get_link_ext_stats,
 	.get_eee		= bnxt_get_eee,
 	.set_eee		= bnxt_set_eee,
 	.get_module_info	= bnxt_get_module_info,
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e741d8aebffe..e5b6cb1a77f9 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -67,6 +67,7 @@ static void phy_link_down(struct phy_device *phydev)
 {
 	phydev->phy_link_change(phydev, false);
 	phy_led_trigger_change_speed(phydev);
+	WRITE_ONCE(phydev->link_down_events, phydev->link_down_events + 1);
 }
 
 static const char *phy_pause_str(struct phy_device *phydev)
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 99dc7bfbcd3c..fa8e0d52dd30 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -125,6 +125,17 @@ struct ethtool_link_ext_state_info {
 	};
 };
 
+struct ethtool_link_ext_stats {
+	/* Custom Linux statistic for PHY level link down events.
+	 * In a simpler world it should be equal to netdev->carrier_down_count
+	 * unfortunately netdev also counts local reconfigurations which don't
+	 * actually take the physical link down, not to mention NC-SI which,
+	 * if present, keeps the link up regardless of host state.
+	 * This statistic counts when PHY _actually_ went down, or lost link.
+	 */
+	u64 link_down_events;
+};
+
 /**
  * ethtool_rxfh_indir_default - get default value for RX flow hash indirection
  * @index: Index in RX flow hash indirection table
@@ -481,6 +492,7 @@ struct ethtool_module_power_mode_params {
  *	do not attach ext_substate attribute to netlink message). If link_ext_state
  *	and link_ext_substate are unknown, return -ENODATA. If not implemented,
  *	link_ext_state and link_ext_substate will not be sent to userspace.
+ * @get_link_ext_stats: Read extra link-related counters.
  * @get_eeprom_len: Read range of EEPROM addresses for validation of
  *	@get_eeprom and @set_eeprom requests.
  *	Returns 0 if device does not support EEPROM access.
@@ -652,6 +664,8 @@ struct ethtool_ops {
 	u32	(*get_link)(struct net_device *);
 	int	(*get_link_ext_state)(struct net_device *,
 				      struct ethtool_link_ext_state_info *);
+	void	(*get_link_ext_stats)(struct net_device *,
+				      struct ethtool_link_ext_stats *);
 	int	(*get_eeprom_len)(struct net_device *);
 	int	(*get_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ddf66198f751..9a3752c0c444 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -600,6 +600,7 @@ struct macsec_ops;
  * @psec: Pointer to Power Sourcing Equipment control struct
  * @lock:  Mutex for serialization access to PHY
  * @state_queue: Work queue for state machine
+ * @link_down_events: Number of times link was lost
  * @shared: Pointer to private data shared by phys in one package
  * @priv: Pointer to driver private data
  *
@@ -723,6 +724,8 @@ struct phy_device {
 
 	int pma_extable;
 
+	unsigned int link_down_events;
+
 	void (*phy_link_change)(struct phy_device *phydev, bool up);
 	void (*adjust_link)(struct net_device *dev);
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index bb57084ac524..8167848983d0 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -262,6 +262,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
 	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
 	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
+	ETHTOOL_A_LINKSTATE_PAD,
+	ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT,	/* u64 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index fb676f349455..7276ff752b80 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -13,6 +13,7 @@ struct linkstate_reply_data {
 	int					link;
 	int					sqi;
 	int					sqi_max;
+	struct ethtool_link_ext_stats		link_stats;
 	bool					link_ext_state_provided;
 	struct ethtool_link_ext_state_info	ethtool_link_ext_state_info;
 };
@@ -22,7 +23,7 @@ struct linkstate_reply_data {
 
 const struct nla_policy ethnl_linkstate_get_policy[] = {
 	[ETHTOOL_A_LINKSTATE_HEADER]		=
-		NLA_POLICY_NESTED(ethnl_header_policy),
+		NLA_POLICY_NESTED(ethnl_header_policy_stats),
 };
 
 static int linkstate_get_sqi(struct net_device *dev)
@@ -107,6 +108,19 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 			goto out;
 	}
 
+	ethtool_stats_init((u64 *)&data->link_stats,
+			   sizeof(data->link_stats) / 8);
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		if (dev->phydev)
+			data->link_stats.link_down_events =
+				READ_ONCE(dev->phydev->link_down_events);
+
+		if (dev->ethtool_ops->get_link_ext_stats)
+			dev->ethtool_ops->get_link_ext_stats(dev,
+							     &data->link_stats);
+	}
+
 	ret = 0;
 out:
 	ethnl_ops_complete(dev);
@@ -134,6 +148,9 @@ static int linkstate_reply_size(const struct ethnl_req_info *req_base,
 	if (data->ethtool_link_ext_state_info.__link_ext_substate)
 		len += nla_total_size(sizeof(u8)); /* LINKSTATE_EXT_SUBSTATE */
 
+	if (data->link_stats.link_down_events != ETHTOOL_STAT_NOT_SET)
+		len += nla_total_size_64bit(sizeof(u64));
+
 	return len;
 }
 
@@ -166,6 +183,12 @@ static int linkstate_fill_reply(struct sk_buff *skb,
 			return -EMSGSIZE;
 	}
 
+	if (data->link_stats.link_down_events != ETHTOOL_STAT_NOT_SET)
+		if (nla_put_u64_64bit(skb, ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT,
+				      data->link_stats.link_down_events,
+				      ETHTOOL_A_LINKSTATE_PAD))
+			return -EMSGSIZE;
+
 	return 0;
 }
 
-- 
2.37.3

