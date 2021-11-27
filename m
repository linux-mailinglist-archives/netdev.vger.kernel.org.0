Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962A34600B1
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355833AbhK0RvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:51:25 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39479 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232836AbhK0RtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:49:24 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 26E9A5C0129;
        Sat, 27 Nov 2021 12:46:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 27 Nov 2021 12:46:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Y64/FrLRhC9QAyR9mN6RmoQCGukQGGT5nf40xws4Ufc=; b=CZb4OqSH
        B45YA6xvL1R8ciNWrnyf+MeATfQSeWQvfdVrP6kAuzjXdBJHH0qV+xIhbU1iuGTv
        492UlneJSOdoq4cZ7b/ki6U8mqNIeicpVC4cC1s0Vzjzm3o7bdQCAptnRX9sRW/i
        AzeiarJ520tS2MI1h+Nt2W5pKo5ZbhbC05VlTTgwyHZKdAVBWyFNZb1/PIlDcw3n
        EOAv8ptpJSbSIyZPG39UPsCoDFp+yGXIWKih594IHamhdlOfMlOquCSOKYJ90zZZ
        l3V5I43HZmELFgdbEdxbTDPA4h5vUs5OkgWPzg3t3ZcItmrfaqBrqrRmpiG3h8v/
        6aMOQkkYNhHMOQ==
X-ME-Sender: <xms:4G6iYWO3-zHnkUSY-BiO0u-uQcnda0s2oG4tm7kTqFkeZ6lzri1_ew>
    <xme:4G6iYU8jKqChDD9XNdf8f_jRXHkzZTvEzy1YaGF_7jSj7XDzoftfyyxwyO_yLWyir
    LqYFh7V3CHj124>
X-ME-Received: <xmr:4G6iYdRa3hN7BElb591lFchUFEE4z-Ow41qxJcbxQtaYy2gYhYPPdYS0r1DCLV1zcJh_KoAZL3EtAXTVhpo8OGZYFcQRpz8ngg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeggdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4W6iYWuQmhMnJ9xUNP5KJ29m-mESocZp27xl84wsN5aizkHVU9vu8A>
    <xmx:4W6iYedjd1_kWcqbaYHuqjEE4m79yikWBgKCOFSTDH2gDMeO9TSIMA>
    <xmx:4W6iYa2vcdU5K27P22wiaMsN-jgIfdXMyEUxcJ_xi3xAyGOd2oR_VQ>
    <xmx:4W6iYUsfL5EAhJ9nOK-dQo_suoR0e_y2sMPM6x5yR42ZPUo5KA22VA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 27 Nov 2021 12:46:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 3/4] ethtool: Add ability to flash transceiver modules' firmware
Date:   Sat, 27 Nov 2021 19:45:29 +0200
Message-Id: <20211127174530.3600237-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211127174530.3600237-1-idosch@idosch.org>
References: <20211127174530.3600237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

CMIS complaint modules such as QSFP-DD might be running a firmware that
can be updated in a vendor-neutral way by exchanging messages between
the host and the module as described in section 7.3.1 of revision 5.0 of
the CMIS standard.

Add a pair of new ethtool messages that allow:

* User space to trigger firmware update of transceiver modules

* The kernel to notify user space about the progress of the process

The user interface is designed to be asynchronous in order to avoid RTNL
being held for too long and to allow several modules to be updated
simultaneously. The interface is designed with CMIS complaint modules in
mind, but kept generic enough to accommodate future use cases, if these
arise.

Example from the succeeding netdevsim implementation:

Trigger the firmware update process:

 # ethtool --flash-module-firmware eth0 file test.img

 Transceiver module firmware flashing started for device eth0

 Transceiver module firmware flashing in progress for device eth0
 Status message: Downloading firmware image
 Progress: 0%

 Transceiver module firmware flashing in progress for device eth0
 Status message: Downloading firmware image
 Progress: 50%

 Transceiver module firmware flashing in progress for device eth0
 Status message: Downloading firmware image
 Progress: 100%

 Transceiver module firmware flashing in progress for device eth0
 Status message: Validating firmware image download

 Transceiver module firmware flashing in progress for device eth0
 Status message: Running firmware image

 Transceiver module firmware flashing completed for device eth0

After testing the new firmware image, commit it so that it is run upon
reset:

 # ethtool --flash-module-firmware eth0 commit on

 Transceiver module firmware flashing started for device eth0

 Transceiver module firmware flashing in progress for device eth0
 Status message: Committing firmware image

 Transceiver module firmware flashing completed for device eth0

The two stages can be combined together:

 # ethtool --flash-module-firmware eth0 file test.img commit on

 Transceiver module firmware flashing started for device eth0

 Transceiver module firmware flashing in progress for device eth0
 Status message: Downloading firmware image
 Progress: 0%

 Transceiver module firmware flashing in progress for device eth0
 Status message: Downloading firmware image
 Progress: 50%

 Transceiver module firmware flashing in progress for device eth0
 Status message: Downloading firmware image
 Progress: 100%

 Transceiver module firmware flashing in progress for device eth0
 Status message: Validating firmware image download

 Transceiver module firmware flashing in progress for device eth0
 Status message: Running firmware image

 Transceiver module firmware flashing in progress for device eth0
 Status message: Committing firmware image

 Transceiver module firmware flashing completed for device eth0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  60 +++++++++
 include/linux/ethtool.h                      |  39 ++++++
 include/linux/ethtool_netlink.h              |   9 ++
 include/uapi/linux/ethtool.h                 |  18 +++
 include/uapi/linux/ethtool_netlink.h         |  21 ++++
 net/ethtool/module.c                         | 125 +++++++++++++++++++
 net/ethtool/netlink.c                        |   7 ++
 net/ethtool/netlink.h                        |   2 +
 8 files changed, 281 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 01393de9d759..e845b6576962 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -221,6 +221,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_MODULE_SET``            set transceiver module parameters
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
   ``ETHTOOL_MSG_MODULE_FW_INFO_GET``    get transceiver module firmware info
+  ``ETHTOOL_MSG_MODULE_FW_FLASH_ACT``   flash transceiver module firmware
   ===================================== ====================================
 
 Kernel to userspace:
@@ -262,6 +263,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ``ETHTOOL_MSG_MODULE_FW_INFO_GET_REPLY`` transceiver module firmware info
+  ``ETHTOOL_MSG_MODULE_FW_FLASH_NTF``      transceiver module flash updates
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1661,6 +1663,63 @@ For CMIS modules, the above mentioned information can be queried from the
 module using CDB CMD 0100h (Get Firmware Info). See section 9.7.1 in revision
 5.0 of the specification.
 
+MODULE_FW_FLASH_ACT
+===================
+
+Flashes transceiver module firmware.
+
+Request contents:
+
+  =======================================  ======  ===========================
+  ``ETHTOOL_A_MODULE_FW_FLASH_HEADER``     nested  request header
+  ``ETHTOOL_A_MODULE_FW_FLASH_FILE_NAME``  string  firmware image file name
+  ``ETHTOOL_A_MODULE_FW_FLASH_PASS``       u32     transceiver module password
+  ``ETHTOOL_A_MODULE_FW_FLASH_COMMIT``     u8      commit firmware image
+  =======================================  ======  ===========================
+
+The optional ``ETHTOOL_A_MODULE_FW_FLASH_FILE_NAME`` attribute encodes the
+firmware image file name.
+
+The optional ``ETHTOOL_A_MODULE_FW_FLASH_PASS`` attribute encodes a password
+that might be required as part of the transceiver module firmware update
+process.
+
+The optional ``ETHTOOL_A_MODULE_FW_FLASH_COMMIT`` attribute is used to control
+whether the running firmware image is committed. That is, if the image is to be
+run upon reset. When not specified or not set, the specified firmware image
+(mandatory) is downloaded to the transceiver module and run, but not committed.
+This allows user space to make sure only valid images are committed.
+
+The firmware update process can take several minutes to complete. Therefore,
+during the update process notifications are emitted from the kernel to user
+space updating it about the status and progress.
+
+Notification contents:
+
+ +---------------------------------------------------+--------+----------------+
+ | ``ETHTOOL_A_MODULE_FW_FLASH_HEADER``              | nested | reply header   |
+ +---------------------------------------------------+--------+----------------+
+ | ``ETHTOOL_A_MODULE_FW_FLASH_STATUS``              | u8     | status         |
+ +---------------------------------------------------+--------+----------------+
+ | ``ETHTOOL_A_MODULE_FW_FLASH_STATUS_MSG``          | string | status message |
+ +---------------------------------------------------+--------+----------------+
+ | ``ETHTOOL_A_MODULE_FW_FLASH_DONE``                | u64    | progress       |
+ +---------------------------------------------------+--------+----------------+
+ | ``ETHTOOL_A_MODULE_FW_FLASH_TOTAL``               | u64    | total          |
+ +---------------------------------------------------+--------+----------------+
+
+The ``ETHTOOL_A_MODULE_FW_FLASH_STATUS`` attribute encodes the current status
+of the firmware update process. Possible values are:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_module_fw_flash_status
+
+The ``ETHTOOL_A_MODULE_FW_FLASH_STATUS_MSG`` attribute encodes a status message
+string.
+
+The ``ETHTOOL_A_MODULE_FW_FLASH_DONE`` and ``ETHTOOL_A_MODULE_FW_FLASH_TOTAL``
+attributes encode the completed and total amount of work, respectively.
+
 Request translation
 ===================
 
@@ -1763,4 +1822,5 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
   n/a                                 ``ETHTOOL_MSG_MODULE_FW_INFO_GET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_FW_FLASH_ACT``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 43506b119429..25f4ef05abac 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -508,6 +508,37 @@ struct ethtool_module_fw_info {
 	};
 };
 
+/**
+ * struct ethtool_module_fw_flash_params - module firmware flashing parameters
+ * @file_name: Firmware image file name. Can be NULL when committing an
+ *	existing image. That is, not downloading and running a new one.
+ * @pass: Module password. Only valid when @pass_valid is set.
+ * @commit: Whether to commit the currently running firmware or not. If set and
+ *	@file_name is not NULL, the specified firmware image file needs to be
+ *	downloaded, run and committed.
+ * @pass_valid: Whether the module password is valid or not.
+ */
+struct ethtool_module_fw_flash_params {
+	const char *file_name;
+	u32 pass;
+	u8 commit:1,
+	   pass_valid:1;
+};
+
+/**
+ * struct ethtool_module_fw_flash_ntf_params - module firmware flashing notification parameters
+ * @status: Module firmware flashing status.
+ * @status_msg: Module firmware flashing status message.
+ * @done: Amount of work completed of total amount.
+ * @total: Amount of work expected to be done.
+ */
+struct ethtool_module_fw_flash_ntf_params {
+	enum ethtool_module_fw_flash_status status;
+	const char *status_msg;
+	u64 done;
+	u64 total;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -681,6 +712,11 @@ struct ethtool_module_fw_info {
  *	used by the network device.
  * @get_module_fw_info: Get the firmware information of the plug-in module
  *	used by the network device.
+ * @start_fw_flash_module: Start firmware flashing of the plug-in module used
+ *	by the network device. Device drivers are expected to defer the
+ *	operation to avoid holding RTNL for long periods of time and to allow
+ *	multiple modules to be flashed simultaneously. User space can be
+ *	notified about the progress by calling ethnl_module_fw_flash_ntf().
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -820,6 +856,9 @@ struct ethtool_ops {
 	int	(*get_module_fw_info)(struct net_device *dev,
 				      struct ethtool_module_fw_info *info,
 				      struct netlink_ext_ack *extack);
+	int	(*start_fw_flash_module)(struct net_device *dev,
+					 const struct ethtool_module_fw_flash_params *params,
+					 struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index aba348d58ff6..1052989f881a 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -29,6 +29,9 @@ int ethnl_cable_test_amplitude(struct phy_device *phydev, u8 pair, s16 mV);
 int ethnl_cable_test_pulse(struct phy_device *phydev, u16 mV);
 int ethnl_cable_test_step(struct phy_device *phydev, u32 first, u32 last,
 			  u32 step);
+void
+ethnl_module_fw_flash_ntf(struct net_device *dev,
+			  const struct ethtool_module_fw_flash_ntf_params *params);
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
 {
@@ -70,5 +73,11 @@ static inline int ethnl_cable_test_step(struct phy_device *phydev, u32 first,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void
+ethnl_module_fw_flash_ntf(struct net_device *dev,
+			  const struct ethtool_module_fw_flash_ntf_params *params)
+{
+}
 #endif /* IS_ENABLED(CONFIG_ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 7bc4b8def12c..e23779201f36 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -736,6 +736,24 @@ enum ethtool_module_power_mode {
 	ETHTOOL_MODULE_POWER_MODE_HIGH,
 };
 
+/**
+ * enum ethtool_module_fw_flash_status - plug-in module firmware flashing status
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_STARTED: The firmware flashing process has
+ *	started.
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS: The firmware flashing process
+ *	is in progress.
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_COMPLETED: The firmware flashing process was
+ *	completed successfully.
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_ERROR: The firmware flashing process was
+ *	stopped due to an error.
+ */
+enum ethtool_module_fw_flash_status {
+	ETHTOOL_MODULE_FW_FLASH_STATUS_STARTED = 1,
+	ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS,
+	ETHTOOL_MODULE_FW_FLASH_STATUS_COMPLETED,
+	ETHTOOL_MODULE_FW_FLASH_STATUS_ERROR,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7f09bfb28a42..e60a44f01c58 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -50,6 +50,7 @@ enum {
 	ETHTOOL_MSG_MODULE_GET,
 	ETHTOOL_MSG_MODULE_SET,
 	ETHTOOL_MSG_MODULE_FW_INFO_GET,
+	ETHTOOL_MSG_MODULE_FW_FLASH_ACT,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -96,6 +97,7 @@ enum {
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_MODULE_FW_INFO_GET_REPLY,
+	ETHTOOL_MSG_MODULE_FW_FLASH_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -881,6 +883,25 @@ enum {
 		= (__ETHTOOL_A_MODULE_FW_INFO_IMAGE_CNT - 1)
 };
 
+/* MODULE_FW_FLASH */
+
+enum {
+	ETHTOOL_A_MODULE_FW_FLASH_UNSPEC,
+	ETHTOOL_A_MODULE_FW_FLASH_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_MODULE_FW_FLASH_FILE_NAME,		/* string */
+	ETHTOOL_A_MODULE_FW_FLASH_PASS,			/* u32 */
+	ETHTOOL_A_MODULE_FW_FLASH_COMMIT,		/* u8 */
+	ETHTOOL_A_MODULE_FW_FLASH_PAD,
+	ETHTOOL_A_MODULE_FW_FLASH_STATUS,		/* u8 */
+	ETHTOOL_A_MODULE_FW_FLASH_STATUS_MSG,		/* string */
+	ETHTOOL_A_MODULE_FW_FLASH_DONE,			/* u64 */
+	ETHTOOL_A_MODULE_FW_FLASH_TOTAL,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MODULE_FW_FLASH_CNT,
+	ETHTOOL_A_MODULE_FW_FLASH_MAX = (__ETHTOOL_A_MODULE_FW_FLASH_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 7f86c01a0b40..aa93fd7a8188 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -380,3 +380,128 @@ const struct ethnl_request_ops ethnl_module_fw_info_request_ops = {
 	.reply_size		= module_fw_info_reply_size,
 	.fill_reply		= module_fw_info_fill_reply,
 };
+
+/* MODULE_FW_FLASH_ACT */
+
+const struct nla_policy
+ethnl_module_fw_flash_act_policy[ETHTOOL_A_MODULE_FW_FLASH_COMMIT + 1] = {
+	[ETHTOOL_A_MODULE_FW_FLASH_HEADER] =
+		NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MODULE_FW_FLASH_FILE_NAME] = { .type = NLA_NUL_STRING },
+	[ETHTOOL_A_MODULE_FW_FLASH_PASS] = { .type = NLA_U32 },
+	[ETHTOOL_A_MODULE_FW_FLASH_COMMIT] = NLA_POLICY_MAX(NLA_U8, 1),
+};
+
+static int module_flash_fw(struct net_device *dev, struct nlattr **tb,
+			   struct netlink_ext_ack *extack)
+{
+	struct ethtool_module_fw_flash_params params = {};
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+
+	if (!ops->start_fw_flash_module) {
+		NL_SET_ERR_MSG(extack,
+			       "Flashing module firmware is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	/* Firmware image file name is only optional when committing the
+	 * currently running firmware.
+	 */
+	if (!tb[ETHTOOL_A_MODULE_FW_FLASH_FILE_NAME] &&
+	    (!tb[ETHTOOL_A_MODULE_FW_FLASH_COMMIT] ||
+	     !nla_get_u8(tb[ETHTOOL_A_MODULE_FW_FLASH_COMMIT]))) {
+		NL_SET_ERR_MSG(extack, "Missing firmware file name");
+		return -EINVAL;
+	}
+
+	if (tb[ETHTOOL_A_MODULE_FW_FLASH_FILE_NAME])
+		params.file_name =
+			nla_data(tb[ETHTOOL_A_MODULE_FW_FLASH_FILE_NAME]);
+
+	if (tb[ETHTOOL_A_MODULE_FW_FLASH_COMMIT])
+		params.commit =
+			nla_get_u8(tb[ETHTOOL_A_MODULE_FW_FLASH_COMMIT]);
+
+	if (tb[ETHTOOL_A_MODULE_FW_FLASH_PASS]) {
+		params.pass = nla_get_u32(tb[ETHTOOL_A_MODULE_FW_FLASH_PASS]);
+		params.pass_valid = true;
+	}
+
+	return ops->start_fw_flash_module(dev, &params, extack);
+}
+
+int ethnl_act_module_fw_flash(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct net_device *dev;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_MODULE_FW_FLASH_HEADER],
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
+	ret = module_flash_fw(dev, tb, info->extack);
+
+	ethnl_ops_complete(dev);
+
+out_rtnl:
+	rtnl_unlock();
+	dev_put(dev);
+	return ret;
+}
+
+void
+ethnl_module_fw_flash_ntf(struct net_device *dev,
+			  const struct ethtool_module_fw_flash_ntf_params *params)
+{
+	struct sk_buff *skb;
+	void *hdr;
+	int ret;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	hdr = ethnl_bcastmsg_put(skb, ETHTOOL_MSG_MODULE_FW_FLASH_NTF);
+	if (!hdr)
+		goto err_skb;
+
+	ret = ethnl_fill_reply_header(skb, dev,
+				      ETHTOOL_A_MODULE_FW_FLASH_HEADER);
+	if (ret < 0)
+		goto err_skb;
+
+	if (nla_put_u8(skb, ETHTOOL_A_MODULE_FW_FLASH_STATUS, params->status))
+		goto err_skb;
+
+	if (params->status_msg &&
+	    nla_put_string(skb, ETHTOOL_A_MODULE_FW_FLASH_STATUS_MSG,
+			   params->status_msg))
+		goto err_skb;
+
+	if (nla_put_u64_64bit(skb, ETHTOOL_A_MODULE_FW_FLASH_DONE, params->done,
+			      ETHTOOL_A_MODULE_FW_FLASH_PAD))
+		goto err_skb;
+
+	if (nla_put_u64_64bit(skb, ETHTOOL_A_MODULE_FW_FLASH_TOTAL,
+			      params->total, ETHTOOL_A_MODULE_FW_FLASH_PAD))
+		goto err_skb;
+
+	genlmsg_end(skb, hdr);
+	ethnl_multicast(skb, dev);
+	return;
+
+err_skb:
+	nlmsg_free(skb);
+}
+EXPORT_SYMBOL_GPL(ethnl_module_fw_flash_ntf);
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 380a38b8535c..2337b576451f 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -1028,6 +1028,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_fw_info_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_fw_info_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_FW_FLASH_ACT,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_act_module_fw_flash,
+		.policy	= ethnl_module_fw_flash_act_policy,
+		.maxattr = ARRAY_SIZE(ethnl_module_fw_flash_act_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 041ffe8db8cb..37fe8bd90ec0 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -378,6 +378,7 @@ extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCK
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
 extern const struct nla_policy ethnl_module_fw_info_get_policy[ETHTOOL_A_MODULE_FW_INFO_HEADER + 1];
+extern const struct nla_policy ethnl_module_fw_flash_act_policy[ETHTOOL_A_MODULE_FW_FLASH_COMMIT + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -397,6 +398,7 @@ int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
+int ethnl_act_module_fw_flash(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
-- 
2.31.1

