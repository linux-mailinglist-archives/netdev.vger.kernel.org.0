Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6545A1170
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242239AbiHYNEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242343AbiHYNDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:03:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CEEB4EB5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 06:03:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRCUz-0007zY-Nn; Thu, 25 Aug 2022 15:02:17 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRCUw-001uGV-Au; Thu, 25 Aug 2022 15:02:14 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRCUv-00FeUr-4Q; Thu, 25 Aug 2022 15:02:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v2 6/7] ethtool: add interface to interact with Ethernet Power Equipment
Date:   Thu, 25 Aug 2022 15:02:10 +0200
Message-Id: <20220825130211.3730461-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825130211.3730461-1-o.rempel@pengutronix.de>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add interface to support Power Sourcing Equipment. At current step it
provides generic way to address all variants of PSE devices as defined
in IEEE 802.3-2018 but support only objects specified for IEEE 802.3-2018 104.4
PoDL Power Sourcing Equipment (PSE).

Currently supported and mandatory objects are:
IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus
IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
IEEE 802.3-2018 30.15.1.2.1 acPoDLPSEAdminControl

This is minimal interface needed to control PSE on each separate
ethernet port but it provides not all mandatory objects specified in
IEEE 802.3-2018.

Since "PoDL PSE" and "PSE" have similar names, but some different values
I decide to not merge them and keep separate naming schema. This should
allow as to be as close to IEEE 802.3 spec as possible and avoid name
conflicts in the future.

This implementation is connected to PHYs instead of MACs because PSE
auto classification can potentially interfere with PHY auto negotiation.
So, may be some extra PHY related initialization will be needed.

With WIP version of ethtools interaction with PSE capable link looks
as following:

$ ip l
...
5: t1l1@eth0: <BROADCAST,MULTICAST> ..
...

$ ethtool --show-pse t1l1
PSE attributs for t1l1:
PoDL PSE Admin State: disabled
PoDL PSE Power Detection Status: disabled

$ ethtool --set-pse t1l1 podl-pse-admin-control enable
$ ethtool --show-pse t1l1
PSE attributs for t1l1:
PoDL PSE Admin State: enabled
PoDL PSE Power Detection Status: delivering power

Signed-off-by: kernel test robot <lkp@intel.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
- rework PSE ethtool API. Reduce it to get_status and set_config cbs
- remove phydev locking. Use PSE own locking instead.
---
 Documentation/networking/ethtool-netlink.rst |  60 ++++++
 drivers/net/pse-pd/pse_core.c                |  87 +++++++++
 include/linux/ethtool.h                      |  27 +++
 include/linux/pse-pd/pse.h                   |  41 ++++
 include/uapi/linux/ethtool.h                 |  50 +++++
 include/uapi/linux/ethtool_netlink.h         |  17 ++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/common.c                         |  10 +
 net/ethtool/common.h                         |   1 +
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/pse-pd.c                         | 187 +++++++++++++++++++
 12 files changed, 505 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/pse-pd.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index dbca3e9ec782f..c8b09b57bd65e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -220,6 +220,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_SET``            set transceiver module parameters
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
+  ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
+  ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
   ===================================== =================================
 
 Kernel to userspace:
@@ -260,6 +262,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
+  ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1625,6 +1628,63 @@ For SFF-8636 modules, low power mode is forced by the host according to table
 For CMIS modules, low power mode is forced by the host according to table 6-12
 in revision 5.0 of the specification.
 
+PSE_GET
+=======
+
+Gets PSE attributes.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PSE_HEADER``               nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_PSE_HEADER``                nested  reply header
+  ``ETHTOOL_A_PODL_PSE_ADMIN_STATE``          u8  Operational state of the PoDL
+                                                  PSE functions
+  ``ETHTOOL_A_PODL_PSE_PW_D_STATUS``          u8  power detection status of the
+                                                  PoDL PSE.
+  ======================================  ======  ==========================
+
+The ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` identifies the operational state of the
+PoDL PSE functions.  The operational state of the PSE function can be changed
+using the ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL`` action. This option is
+corresponding to IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState. Possible values
+are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_podl_pse_admin_state
+
+The ``ETHTOOL_A_PODL_PSE_PW_D_STATUS`` identifies the power detection status of the
+PoDL PSE.  The status depend on internal PSE state machine and automatic
+PD classification support. This option is corresponding to IEEE 802.3-2018
+30.15.1.1.3 aPoDLPSEPowerDetectionStatus. Possible values are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_podl_pse_admin_state
+
+PSE_SET
+=======
+
+Sets PSE parameters.
+
+Request contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_PSE_HEADER``                nested  request header
+  ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL``        u8  Control PoDL PSE Admin state
+  ======================================  ======  ==========================
+
+When set, the optional ``ETHTOOL_A_PODL_PSE_ADMIN_CONTROL`` attribute is used
+to control PoDL PSE Admin functions. This option is implementing
+IEEE 802.3-2018 30.15.1.2.1 acPoDLPSEAdminControl. Possible values are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_podl_pse_admin_state
+
 Request translation
 ===================
 
diff --git a/drivers/net/pse-pd/pse_core.c b/drivers/net/pse-pd/pse_core.c
index 7bf3acc721c0a..d0f8fb6ac038b 100644
--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -292,3 +292,90 @@ devm_pse_control_get(struct device *dev)
 	return psec;
 }
 EXPORT_SYMBOL_GPL(devm_pse_control_get);
+
+/**
+ * pse_ethtool_get_status - get status of PSE control
+ * @psec: PSE control pointer
+ * @extack: extack for reporting useful error messages
+ */
+static int pse_ethtool_get_status(struct pse_control *psec,
+				  struct netlink_ext_ack *extack,
+				  struct pse_control_status *status)
+{
+	const struct pse_controller_ops *ops;
+	int err;
+
+	if (!psec)
+		return 0;
+
+	if (WARN_ON(IS_ERR(psec)))
+		return -EINVAL;
+
+	ops = psec->pcdev->ops;
+
+	if (!ops->ethtool_get_status) {
+		NL_SET_ERR_MSG(extack,
+			       "PSE driver does not support status report");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&psec->pcdev->lock);
+	err = ops->ethtool_get_status(psec->pcdev, psec->id, extack, status);
+	mutex_unlock(&psec->pcdev->lock);
+
+	return err;
+}
+
+/**
+ * pse_ethtool_set_config - set PSE control configuration
+ * @psec: PSE control pointer
+ * @extack: extack for reporting useful error messages
+ * @config: Configuration of the test to run
+ */
+static int pse_ethtool_set_config(struct pse_control *psec,
+				  struct netlink_ext_ack *extack,
+				  const struct pse_control_config *config)
+{
+	const struct pse_controller_ops *ops;
+	int err;
+
+	if (!psec)
+		return 0;
+
+	if (WARN_ON(IS_ERR(psec)))
+		return -EINVAL;
+
+	ops = psec->pcdev->ops;
+
+	if (!ops->ethtool_set_config) {
+		NL_SET_ERR_MSG(extack,
+			       "PSE driver does not configuration");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&psec->pcdev->lock);
+	err = ops->ethtool_set_config(psec->pcdev, psec->id, extack, config);
+	mutex_unlock(&psec->pcdev->lock);
+
+	return err;
+}
+
+static const struct ethtool_pse_ops pse_ethtool_pse_ops = {
+	.get_status = pse_ethtool_get_status,
+	.set_config = pse_ethtool_set_config,
+};
+
+static int __init pse_init(void)
+{
+	ethtool_set_ethtool_pse_ops(&pse_ethtool_pse_ops);
+
+	return 0;
+}
+
+static void __exit pse_exit(void)
+{
+	ethtool_set_ethtool_pse_ops(NULL);
+}
+
+subsys_initcall(pse_init);
+module_exit(pse_exit);
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 99dc7bfbcd3c3..0ab95703d5517 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -815,6 +815,33 @@ struct ethtool_phy_ops {
  */
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
 
+struct pse_control;
+struct pse_control_config;
+struct pse_control_status;
+
+/**
+ * struct ethtool_pse_ops - Optional PSE device options
+ * @get_status: Returns status of PSE.
+ * @set_config: Set PSE configuration.
+ *
+ * All operations are optional (i.e. the function pointer may be set to %NULL)
+ * and callers must take this into account. Callers must hold the RTNL lock.
+ */
+struct ethtool_pse_ops {
+	int (*get_status)(struct pse_control *psec,
+			  struct netlink_ext_ack *extack,
+			  struct pse_control_status *status);
+	int (*set_config)(struct pse_control *psec,
+			  struct netlink_ext_ack *extack,
+			  const struct pse_control_config *config);
+};
+
+/**
+ * ethtool_set_ethtool_pse_ops - Set the ethtool_pse_ops singleton
+ * @ops: Ethtool PHY operations to set
+ */
+void ethtool_set_ethtool_pse_ops(const struct ethtool_pse_ops *ops);
+
 /**
  * ethtool_params_from_link_mode - Derive link parameters from a given link mode
  * @link_ksettings: Link parameters to be derived from the link mode
diff --git a/include/linux/pse-pd/pse.h b/include/linux/pse-pd/pse.h
index 8bf84288db418..d6daa525fbfd3 100644
--- a/include/linux/pse-pd/pse.h
+++ b/include/linux/pse-pd/pse.h
@@ -9,6 +9,47 @@
 #include <linux/list.h>
 #include <uapi/linux/ethtool.h>
 
+struct phy_device;
+struct pse_controller_dev;
+
+/**
+ * struct pse_control_config - PSE control/channel configuration.
+ *
+ * @admin_cotrol: set PoDL PSE admin control as described in
+ *	IEEE 802.3-2018 30.15.1.2.1 acPoDLPSEAdminControl
+ */
+struct pse_control_config {
+	enum ethtool_podl_pse_admin_state admin_cotrol;
+};
+
+/**
+ * struct pse_control_status - PSE control/channel status.
+ *
+ * @admin_state: operational state of the PoDL PSE
+ *	functions. IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
+ * @pw_status: power detection status of the PoDL PSE.
+ *	IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus:
+ */
+struct pse_control_status {
+	enum ethtool_podl_pse_admin_state podl_admin_state;
+	enum ethtool_podl_pse_pw_d_status podl_pw_status;
+};
+
+/**
+ * struct pse_controller_ops - PSE controller driver callbacks
+ *
+ * @get_status: get PSE control status for ethtool interface
+ * @set_config: set PSE control configuration over ethtool interface
+ */
+struct pse_controller_ops {
+	int (*ethtool_get_status)(struct pse_controller_dev *pcdev,
+		unsigned long id, struct netlink_ext_ack *extack,
+		struct pse_control_status *status);
+	int (*ethtool_set_config)(struct pse_controller_dev *pcdev,
+		unsigned long id, struct netlink_ext_ack *extack,
+		const struct pse_control_config *config);
+};
+
 struct module;
 struct device_node;
 struct of_phandle_args;
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 2d5741fd44bbc..783f19f78c633 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -736,6 +736,56 @@ enum ethtool_module_power_mode {
 	ETHTOOL_MODULE_POWER_MODE_HIGH,
 };
 
+/**
+ * enum ethtool_podl_pse_admin_state - operational state of the PoDL PSE
+ *	functions. IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
+ * @ETHTOOL_PSE_MODE_POLICY_UNKNOWN: state of PoDL PSE functions are unknown
+ * @ETHTOOL_PSE_MODE_POLICY_HIGH: PoDL PSE functions are disabled
+ * @ETHTOOL_PSE_MODE_POLICY_AUTO: PoDL PSE functions are enabled
+ */
+enum ethtool_podl_pse_admin_state {
+	ETHTOOL_PODL_PSE_ADMIN_STATE_UNKNOWN = 1,
+	ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED,
+	ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED,
+
+	/* add new constants above here */
+	ETHTOOL_PODL_PSE_ADMIN_STATE_COUNT
+};
+
+/**
+ * enum ethtool_podl_pse_pw_d_status - power detection status of the PoDL PSE.
+ *	IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus:
+ * @ETHTOOL_PODL_PSE_PW_D_STATUS_UNKNOWN: PoDL PSE
+ * @ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED: "The enumeration “disabled” is
+ *	asserted true when the PoDL PSE state diagram variable mr_pse_enable is
+ *	false"
+ * @ETHTOOL_PODL_PSE_PW_D_STATUS_SEARCHING: "The enumeration “searching” is
+ *	asserted true when either of the PSE state diagram variables
+ *	pi_detecting or pi_classifying is true."
+ * @ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING: "The enumeration “deliveringPower”
+ *	is asserted true when the PoDL PSE state diagram variable pi_powered is
+ *	true."
+ * @ETHTOOL_PODL_PSE_PW_D_STATUS_SLEEP: "The enumeration “sleep” is asserted
+ *	true when the PoDL PSE state diagram variable pi_sleeping is true."
+ * @ETHTOOL_PODL_PSE_PW_D_STATUS_IDLE: "The enumeration “idle” is asserted true
+ *	when the logical combination of the PoDL PSE state diagram variables
+ *	pi_prebiased*!pi_sleeping is true."
+ * @ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR: "The enumeration “error” is asserted
+ *	true when the PoDL PSE state diagram variable overload_held is true."
+ */
+enum ethtool_podl_pse_pw_d_status {
+	ETHTOOL_PODL_PSE_PW_D_STATUS_UNKNOWN = 1,
+	ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED,
+	ETHTOOL_PODL_PSE_PW_D_STATUS_SEARCHING,
+	ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING,
+	ETHTOOL_PODL_PSE_PW_D_STATUS_SLEEP,
+	ETHTOOL_PODL_PSE_PW_D_STATUS_IDLE,
+	ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR,
+
+	/* add new constants above here */
+	ETHTOOL_PODL_PSE_PW_D_STATUS_COUNT
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d2fb4f7be61b2..1c890a37a35b5 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -49,6 +49,8 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 	ETHTOOL_MSG_MODULE_GET,
 	ETHTOOL_MSG_MODULE_SET,
+	ETHTOOL_MSG_PSE_GET,
+	ETHTOOL_MSG_PSE_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -94,6 +96,8 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
+	ETHTOOL_MSG_PSE_GET_REPLY,
+	ETHTOOL_MSG_PSE_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -862,6 +866,19 @@ enum {
 	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
 };
 
+/* Power Sourcing Equipment */
+enum {
+	ETHTOOL_A_PSE_UNSPEC,
+	ETHTOOL_A_PSE_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PODL_PSE_ADMIN_STATE,		/* u8 */
+	ETHTOOL_A_PODL_PSE_ADMIN_CONTROL,	/* u8 */
+	ETHTOOL_A_PODL_PSE_PW_D_STATUS,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PSE_CNT,
+	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index b76432e70e6ba..72ab0944262af 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
+		   pse-pd.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 566adf85e658d..c41a8599dc514 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -582,6 +582,16 @@ void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
 }
 EXPORT_SYMBOL_GPL(ethtool_set_ethtool_phy_ops);
 
+const struct ethtool_pse_ops *ethtool_pse_ops;
+
+void ethtool_set_ethtool_pse_ops(const struct ethtool_pse_ops *ops)
+{
+	rtnl_lock();
+	ethtool_pse_ops = ops;
+	rtnl_unlock();
+}
+EXPORT_SYMBOL_GPL(ethtool_set_ethtool_pse_ops);
+
 void
 ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
 			      enum ethtool_link_mode_bit_indices link_mode)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 2dc2b80aea5f5..c1779657e074f 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -46,6 +46,7 @@ int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
 int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
 extern const struct ethtool_phy_ops *ethtool_phy_ops;
+extern const struct ethtool_pse_ops *ethtool_pse_ops;
 
 int ethtool_get_module_info_call(struct net_device *dev,
 				 struct ethtool_modinfo *modinfo);
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e26079e11835c..ec84a12ba4918 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -286,6 +286,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -598,6 +599,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_PSE_NTF]		= &ethnl_pse_request_ops,
 };
 
 /* default notification handler */
@@ -691,6 +693,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_PSE_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1020,6 +1023,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PSE_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_pse_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_pse_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_PSE_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_pse,
+		.policy = ethnl_pse_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_pse_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index c0d5876118546..1bfd374f97188 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -345,6 +345,7 @@ extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
+extern const struct ethnl_request_ops ethnl_pse_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -383,6 +384,8 @@ extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
+extern const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1];
+extern const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -402,6 +405,7 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
new file mode 100644
index 0000000000000..f11dadcde2cc4
--- /dev/null
+++ b/net/ethtool/pse-pd.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// ethtool interface for for Ethernet PSE (Power Sourcing Equipment)
+// and PD (Powered Device)
+//
+// Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+//
+
+#include "common.h"
+#include "linux/pse-pd/pse.h"
+#include "netlink.h"
+#include <linux/ethtool_netlink.h>
+#include <linux/ethtool.h>
+#include <linux/phy.h>
+
+struct pse_req_info {
+	struct ethnl_req_info base;
+};
+
+struct pse_reply_data {
+	struct ethnl_reply_data	base;
+	struct pse_control_status status;
+};
+
+#define PSE_REPDATA(__reply_base) \
+	container_of(__reply_base, struct pse_reply_data, base)
+
+/* PSE_GET */
+
+const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1] = {
+	[ETHTOOL_A_PSE_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int pse_get_pse_attributs(struct net_device *dev,
+				 struct netlink_ext_ack *extack,
+				 struct pse_reply_data *data)
+{
+	struct phy_device *phydev = dev->phydev;
+	const struct ethtool_pse_ops *ops;
+
+	if (!phydev)
+		return -EOPNOTSUPP;
+
+	if (!phydev->psec)
+		return -EOPNOTSUPP;
+
+	ops = ethtool_pse_ops;
+	if (!ops || !ops->get_status)
+		return -EOPNOTSUPP;
+
+	memset(&data->status, 0, sizeof(data->status));
+
+	return ops->get_status(phydev->psec, extack, &data->status);
+}
+
+static int pse_prepare_data(const struct ethnl_req_info *req_base,
+			       struct ethnl_reply_data *reply_base,
+			       struct genl_info *info)
+{
+	struct pse_reply_data *data = PSE_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return 0;
+
+	ret = pse_get_pse_attributs(dev, info->extack, data);
+
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int pse_reply_size(const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	const struct pse_reply_data *data = PSE_REPDATA(reply_base);
+	const struct pse_control_status *st = &data->status;
+	int len = 0;
+
+	if (st->podl_admin_state >= 0)
+		len += nla_total_size(sizeof(u8)); /* _PODL_PSE_ADMIN_STATE */
+	if (st->podl_pw_status >= 0)
+		len += nla_total_size(sizeof(u8)); /* _PODL_PSE_PW_D_STATUS */
+
+	return len;
+}
+
+static int pse_fill_reply(struct sk_buff *skb,
+			  const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	const struct pse_reply_data *data = PSE_REPDATA(reply_base);
+	const struct pse_control_status *st = &data->status;
+
+	if (st->podl_admin_state > 0 &&
+	    nla_put_u8(skb, ETHTOOL_A_PODL_PSE_ADMIN_STATE,
+		       st->podl_admin_state))
+		return -EMSGSIZE;
+
+	if (st->podl_pw_status > 0 &&
+	    nla_put_u8(skb, ETHTOOL_A_PODL_PSE_PW_D_STATUS,
+		       st->podl_pw_status))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_pse_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PSE_GET,
+	.reply_cmd		= ETHTOOL_MSG_PSE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PSE_HEADER,
+	.req_info_size		= sizeof(struct pse_req_info),
+	.reply_data_size	= sizeof(struct pse_reply_data),
+
+	.prepare_data		= pse_prepare_data,
+	.reply_size		= pse_reply_size,
+	.fill_reply		= pse_fill_reply,
+};
+
+/* PSE_SET */
+
+const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1] = {
+	[ETHTOOL_A_PSE_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL] =
+		NLA_POLICY_RANGE(NLA_U8, ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED,
+				 ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED),
+};
+
+static int pse_set_pse_config(struct net_device *dev,
+			      struct netlink_ext_ack *extack,
+			      struct nlattr **tb)
+{
+	struct phy_device *phydev = dev->phydev;
+	struct pse_control_config config = {};
+	const struct ethtool_pse_ops *ops;
+	int ret;
+
+	if (!tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL])
+		return 0;
+
+	ops = ethtool_pse_ops;
+	if (!ops || !ops->set_config)
+		return -EOPNOTSUPP;
+
+	config.admin_cotrol = nla_get_u8(tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL]);
+
+	if (!phydev)
+		return -EOPNOTSUPP;
+
+	// todo resolve phydev dependecy
+	if (!phydev->psec)
+		ret = -EOPNOTSUPP;
+	else
+		ret = ops->set_config(phydev->psec, extack, &config);
+
+	return ret;
+}
+
+int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct net_device *dev;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_PSE_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = pse_set_pse_config(dev, info->extack, tb);
+
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
-- 
2.30.2

