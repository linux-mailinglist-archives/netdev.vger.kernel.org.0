Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F54600AF
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355826AbhK0RvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:51:17 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50601 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237445AbhK0RtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:49:17 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 38D935C00D2;
        Sat, 27 Nov 2021 12:46:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 27 Nov 2021 12:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/oy10D1uNcS39ArKv14L6Q2MVJKcr1vJBLhSQ1XeR1E=; b=Q6w1aZlG
        G0+ZdTi/fGwjHZIduN7VYudoOquW4/hNO6GdtUQyBKmqNp6EN7rqkjZikQstOQPo
        CgDG+tLuURfsDVMbQQm1A5yJIp82Lr5uu2lRY8cuc1HDWwtVHPyUn7S5GNxW7feT
        QQnwIL7PqXrug5WUnA6VLs4liqRI8wTOR6p2aUsTZYFL57N/c2A6biwSX3jMBWMI
        SUgvfZSJA0ptPKx+ZW6Ztaot4YERBmuUINaVl6ydqKM1+5eb+omKpMJcJlzyzD0i
        HiYSfOZwtNDoI++q8IhkDEv1hrMn/t5jcUWEfx9Odm4JnAzU6EOEwFBDMDMiwRFt
        RYg1iNL2ojbsTw==
X-ME-Sender: <xms:2m6iYRhMgpfrvTEs1mve2bLKDk8tgMBVRhfVl6Jt6Co2bp-QILXHvw>
    <xme:2m6iYWAS7tCH4ErI-QrGzFdNMBcvABEhvH174VzSx5tXb6RKFf86e78TOXhhZ4D-X
    -3HL53_LUacMYs>
X-ME-Received: <xmr:2m6iYRFrwAE55RMNQwcwUK3C7mvQrOcLjb3Jl11VR3ghmOILCBsaGXNd1iCqTZlZ31VN6FYYIkDjhZUlGrgyrO3K2qjhpjTgHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeggdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2m6iYWRIrlXIrPI1DPf0MXNm2lYIJxJbe34-TFfAU7jKFl7yVEuv5w>
    <xmx:2m6iYexussC7Y7lxRZs1piMh1KnxhkQisWhvAb97OsGtpKdXsfTGqg>
    <xmx:2m6iYc7eF8bTT9rqzfAg3ea3_VeAhT03vhVau88MIoIIuDnqU4HGhw>
    <xmx:2m6iYZz0gC52mbwspJUvdXNL0Q4yZedTWVAzgm3tn8cBd8z4hluwKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 27 Nov 2021 12:45:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 1/4] ethtool: Add ability to query transceiver modules' firmware information
Date:   Sat, 27 Nov 2021 19:45:27 +0200
Message-Id: <20211127174530.3600237-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211127174530.3600237-1-idosch@idosch.org>
References: <20211127174530.3600237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

CMIS compliant modules such as QSFP-DD may have up to three firmware
images: Two host updateable images stored in up to two storage banks (A
and B) and an internal factory image. These images have various states:

* Running: Whether the image is currently running or not
* Committed: Whether the image is to be run upon reset or not
* Valid: Whether the image is runnable and persistently stored
completely undamaged

When user space wishes to update the firmware of such a module, it needs to
choose one of two images provided by the module vendor based on the current
state. For example, if image A is running and committed, image B should be
used. By only downloading and running (but not committing) image B, user space
can choose to fallback to image A if image B does not work as expected.

To that end, add a new ethtool message that allows user space to query
this information. Example output from the succeeding netdevsim
implementation:

 # ethtool --show-module-firmware-info eth0
 Module firmware info for eth0:
 image:
   name: a
   running: true
   committed: true
   valid: true
   version: 1.2.3-test
 image:
   name: b
   running: false
   committed: false
   valid: true
   version: 5.6.7
 image:
   name: factory
   running: false
   committed: false
   valid: true
   version: 11.12.13

The user interface is designed with CMIS compliant modules in mind, but
kept generic enough to accommodate future use cases, if these arise.

On the other hand, the device driver API is kept CMIS specific, but
extensible (see 'enum ethtool_module_fw_info_type'). This design choice
exploits the fact that the interface to query firmware information from
CMIS compliant modules is standardized by the CMIS specification. As
such, the information queried from device drivers is structured and
easier to police.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  68 ++++++-
 include/linux/ethtool.h                      |  70 +++++++
 include/uapi/linux/ethtool_netlink.h         |  28 +++
 net/ethtool/module.c                         | 202 +++++++++++++++++++
 net/ethtool/netlink.c                        |  10 +
 net/ethtool/netlink.h                        |   2 +
 6 files changed, 378 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 9d98e0511249..01393de9d759 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -184,7 +184,7 @@ according to message purpose:
 
 Userspace to kernel:
 
-  ===================================== =================================
+  ===================================== ====================================
   ``ETHTOOL_MSG_STRSET_GET``            get string set
   ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
   ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
@@ -220,7 +220,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_SET``            set transceiver module parameters
   ``ETHTOOL_MSG_MODULE_GET``            get transceiver module parameters
-  ===================================== =================================
+  ``ETHTOOL_MSG_MODULE_FW_INFO_GET``    get transceiver module firmware info
+  ===================================== ====================================
 
 Kernel to userspace:
 
@@ -260,6 +261,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
   ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
+  ``ETHTOOL_MSG_MODULE_FW_INFO_GET_REPLY`` transceiver module firmware info
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1598,6 +1600,67 @@ For SFF-8636 modules, low power mode is forced by the host according to table
 For CMIS modules, low power mode is forced by the host according to table 6-12
 in revision 5.0 of the specification.
 
+MODULE_FW_INFO_GET
+==================
+
+Gets transceiver module firmware information.
+
+Request contents:
+
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_FW_INFO_HEADER``     nested  request header
+  ======================================  ======  ==========================
+
+Kernel response contents:
+
+ +---------------------------------------------------+--------+----------------+
+ | ``ETHTOOL_A_MODULE_FW_INFO_HEADER``               | nested | reply header   |
+ +---------------------------------------------------+--------+----------------+
+ | ``ETHTOOL_A_MODULE_FW_INFO_IMAGE``                | nested | firmware image |
+ +-+-------------------------------------------------+--------+----------------+
+ | | ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_NAME``         | string | image name     |
+ +-+-------------------------------------------------+--------+----------------+
+ | | ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_RUNNING``      | bool   | running        |
+ +-+-------------------------------------------------+--------+----------------+
+ | | ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_COMMITTED``    | bool   | committed      |
+ +-+-------------------------------------------------+--------+----------------+
+ | | ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_VALID``        | bool   | valid          |
+ +-+-------------------------------------------------+--------+----------------+
+ | | ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_VERSION``      | string | image version  |
+ +-+-------------------------------------------------+--------+----------------+
+
+The ``ETHTOOL_A_MODULE_FW_INFO_IMAGE`` nested attribute may appear multiple
+times in the response, according to the number of firmware images stored in the
+transceiver module. CMIS modules, for example, may have up to three images: Two
+host updateable images stored in up to two storage banks (A and B) and an
+internal factory image. The following paragraphs describe various image
+attributes.
+
+The ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_NAME`` attribute encodes the image's name.
+The name is significant as a vendor may provide two firmware images, each one
+intended for a different bank.
+
+The ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_RUNNING`` attribute indicates if the image
+is currently running or not.
+
+The ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_COMMITTED`` attribute indicates if the
+image is to be run upon reset or not.
+
+The last two attributes can be used by user space to determine which firmware
+image should be used for the firmware update. In CMIS modules, for example, if
+image A is running and committed, image B should be used.
+
+The ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_VALID`` attribute encodes the validity of
+the image. A valid image is runnable and persistently stored completely
+undamaged.
+
+The ``ETHTOOL_A_MODULE_FW_INFO_IMAGE_VERSION`` attribute encodes the version of
+the image.
+
+For CMIS modules, the above mentioned information can be queried from the
+module using CDB CMD 0100h (Get Firmware Info). See section 9.7.1 in revision
+5.0 of the specification.
+
 Request translation
 ===================
 
@@ -1699,4 +1762,5 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_FW_INFO_GET``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a26f37a27167..43506b119429 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -443,6 +443,71 @@ struct ethtool_module_power_mode_params {
 	enum ethtool_module_power_mode mode;
 };
 
+#define ETH_MODULE_FW_VER_LEN 48
+
+/**
+ * struct ethtool_module_fw_info_image - Module firmware image information
+ * @running: Whether the image is currently running or not.
+ * @committed: Whether the image is run upon resets.
+ * @valid: Whether the image is runnable and persistently stored completely
+ *	undamaged.
+ * @ver_major: Firmware image major revision.
+ * @ver_minor: Firmware image minor revision.
+ * @ver_build: Firmware image build number.
+ * @ver_extra_str: Firmware image additional information.
+ */
+struct ethtool_module_fw_info_image {
+	u8 running:1,
+	   committed:1,
+	   valid:1;
+	u8 ver_major;
+	u8 ver_minor;
+	u8 ver_build;
+	char ver_extra_str[ETH_MODULE_FW_VER_LEN];
+};
+
+/**
+ * struct ethtool_module_fw_info_cmis - CMIS module firmware information
+ * @a_present: Whether image A is present or not.
+ * @b_present: Whether image B is present or not.
+ * @factory_present: Whether factory image is present or not.
+ * @a: Image A firmware information.
+ * @b: Image B firmware information.
+ * @factory: Factory image firmware information.
+ *
+ * CMIS modules can have up to two host updateable images stored in up to two
+ * firmware banks, called A and B. In addition, the module may also have an
+ * internal factory image.
+ */
+struct ethtool_module_fw_info_cmis {
+	u8 a_present:1,
+	   b_present:1,
+	   factory_present:1;
+	struct ethtool_module_fw_info_image a;
+	struct ethtool_module_fw_info_image b;
+	struct ethtool_module_fw_info_image factory;
+};
+
+/**
+ * enum ethtool_module_fw_info_type - Module firmware information type
+ * @ETHTOOL_MODULE_FW_INFO_TYPE_CMIS: CMIS module firmware information type.
+ */
+enum ethtool_module_fw_info_type {
+	ETHTOOL_MODULE_FW_INFO_TYPE_CMIS = 1,
+};
+
+/**
+ * struct ethtool_module_fw_info - module firmware information
+ * @type: Module firmware information type.
+ * @cmis: CMIS module firmware information.
+ */
+struct ethtool_module_fw_info {
+	enum ethtool_module_fw_info_type type;
+	union {
+		struct ethtool_module_fw_info_cmis cmis;
+	};
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -614,6 +679,8 @@ struct ethtool_module_power_mode_params {
  *	plugged-in.
  * @set_module_power_mode: Set the power mode policy for the plug-in module
  *	used by the network device.
+ * @get_module_fw_info: Get the firmware information of the plug-in module
+ *	used by the network device.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -750,6 +817,9 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	int	(*get_module_fw_info)(struct net_device *dev,
+				      struct ethtool_module_fw_info *info,
+				      struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index cca6e474a085..7f09bfb28a42 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -49,6 +49,7 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 	ETHTOOL_MSG_MODULE_GET,
 	ETHTOOL_MSG_MODULE_SET,
+	ETHTOOL_MSG_MODULE_FW_INFO_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -94,6 +95,7 @@ enum {
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
+	ETHTOOL_MSG_MODULE_FW_INFO_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -853,6 +855,32 @@ enum {
 	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
 };
 
+/* MODULE_FW_INFO */
+
+enum {
+	ETHTOOL_A_MODULE_FW_INFO_UNSPEC,
+	ETHTOOL_A_MODULE_FW_INFO_HEADER,	/* nest - _A_HEADER_* */
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE,		/* nest */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MODULE_FW_INFO_CNT,
+	ETHTOOL_A_MODULE_FW_INFO_MAX = (__ETHTOOL_A_MODULE_FW_INFO_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE_UNSPEC,
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE_NAME,		/* string */
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE_RUNNING,		/* u8 */
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE_COMMITTED,	/* u8 */
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE_VALID,		/* u8 */
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE_VERSION,		/* string */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MODULE_FW_INFO_IMAGE_CNT,
+	ETHTOOL_A_MODULE_FW_INFO_IMAGE_MAX
+		= (__ETHTOOL_A_MODULE_FW_INFO_IMAGE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index bc2cef11bbda..7f86c01a0b40 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -18,6 +18,18 @@ struct module_reply_data {
 #define MODULE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct module_reply_data, base)
 
+struct module_fw_info_req_info {
+	struct ethnl_req_info base;
+};
+
+struct module_fw_info_reply_data {
+	struct ethnl_reply_data	base;
+	struct ethtool_module_fw_info fw_info;
+};
+
+#define MODULE_FW_INFO_REPDATA(__reply_base) \
+	container_of(__reply_base, struct module_fw_info_reply_data, base)
+
 /* MODULE_GET */
 
 const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1] = {
@@ -178,3 +190,193 @@ int ethnl_set_module(struct sk_buff *skb, struct genl_info *info)
 	dev_put(dev);
 	return ret;
 }
+
+/* MODULE_FW_INFO_GET */
+
+const struct nla_policy ethnl_module_fw_info_get_policy[ETHTOOL_A_MODULE_FW_INFO_HEADER + 1] = {
+	[ETHTOOL_A_MODULE_FW_INFO_HEADER] =
+		NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static int module_get_fw_info(struct net_device *dev,
+			      struct ethtool_module_fw_info *fw_info,
+			      struct netlink_ext_ack *extack)
+{
+	int ret;
+
+	ret = dev->ethtool_ops->get_module_fw_info(dev, fw_info, extack);
+	if (ret < 0)
+		return ret;
+
+	if (!fw_info->type) {
+		NL_SET_ERR_MSG(extack, "Module firmware info type was not set");
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static int module_fw_info_prepare_data(const struct ethnl_req_info *req_base,
+				       struct ethnl_reply_data *reply_base,
+				       struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
+	struct net_device *dev = reply_base->dev;
+	struct module_fw_info_reply_data *data;
+	int ret;
+
+	if (!dev->ethtool_ops->get_module_fw_info)
+		return -EOPNOTSUPP;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	data = MODULE_FW_INFO_REPDATA(reply_base);
+	ret = module_get_fw_info(dev, &data->fw_info, extack);
+	if (ret < 0)
+		goto out_complete;
+
+out_complete:
+	ethnl_ops_complete(dev);
+	return ret;
+}
+
+static int
+module_fw_info_reply_size_image(const struct ethtool_module_fw_info_image *image,
+				int name_len)
+{
+	       /* _MODULE_FW_INFO_IMAGE */
+	return nla_total_size(0) +
+	       /* _MODULE_FW_INFO_IMAGE_NAME */
+	       nla_total_size(name_len + 1) +
+	       /* _MODULE_FW_INFO_IMAGE_RUNNING */
+	       nla_total_size(sizeof(u8)) +
+	       /* _MODULE_FW_INFO_IMAGE_COMMITTED */
+	       nla_total_size(sizeof(u8)) +
+	       /* _MODULE_FW_INFO_IMAGE_VALID */
+	       nla_total_size(sizeof(u8)) +
+	       /* _MODULE_FW_INFO_IMAGE_VERSION */
+	       nla_total_size(ETH_MODULE_FW_VER_LEN + 1);
+}
+
+static int
+module_fw_info_reply_size_cmis(const struct ethtool_module_fw_info_cmis *cmis)
+{
+	int len = 0;
+
+	if (cmis->a_present)
+		len += module_fw_info_reply_size_image(&cmis->a, strlen("a"));
+	if (cmis->b_present)
+		len += module_fw_info_reply_size_image(&cmis->b, strlen("b"));
+	if (cmis->factory_present)
+		len += module_fw_info_reply_size_image(&cmis->factory,
+						       strlen("factory"));
+
+	return len;
+}
+
+static int module_fw_info_reply_size(const struct ethnl_req_info *req_base,
+				     const struct ethnl_reply_data *reply_base)
+{
+	struct module_fw_info_reply_data *data;
+
+	data = MODULE_FW_INFO_REPDATA(reply_base);
+
+	switch (data->fw_info.type) {
+	case ETHTOOL_MODULE_FW_INFO_TYPE_CMIS:
+		return module_fw_info_reply_size_cmis(&data->fw_info.cmis);
+	default:
+		/* Module firmware information type was already validated to be
+		 * set in prepare_data() callback.
+		 */
+		WARN_ON(1);
+		return -EINVAL;
+	}
+}
+
+static int
+module_fw_info_fill_reply_image(struct sk_buff *skb,
+				const struct ethtool_module_fw_info_image *image,
+				const char *image_name)
+{
+	char buf[ETH_MODULE_FW_VER_LEN];
+	struct nlattr *nest;
+
+	if (strlen(image->ver_extra_str))
+		snprintf(buf, ETH_MODULE_FW_VER_LEN, "%d.%d.%d-%s",
+			 image->ver_major, image->ver_minor, image->ver_build,
+			 image->ver_extra_str);
+	else
+		snprintf(buf, ETH_MODULE_FW_VER_LEN, "%d.%d.%d",
+			 image->ver_major, image->ver_minor, image->ver_build);
+
+	nest = nla_nest_start(skb, ETHTOOL_A_MODULE_FW_INFO_IMAGE);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_string(skb, ETHTOOL_A_MODULE_FW_INFO_IMAGE_NAME,
+			   image_name) ||
+	    nla_put_u8(skb, ETHTOOL_A_MODULE_FW_INFO_IMAGE_RUNNING,
+		       image->running) ||
+	    nla_put_u8(skb, ETHTOOL_A_MODULE_FW_INFO_IMAGE_COMMITTED,
+		       image->committed) ||
+	    nla_put_u8(skb, ETHTOOL_A_MODULE_FW_INFO_IMAGE_VALID,
+		       image->valid) ||
+	    nla_put_string(skb, ETHTOOL_A_MODULE_FW_INFO_IMAGE_VERSION, buf))
+		goto err_cancel;
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int
+module_fw_info_fill_reply_cmis(struct sk_buff *skb,
+			       const struct ethtool_module_fw_info_cmis *cmis)
+{
+	if (cmis->a_present &&
+	    module_fw_info_fill_reply_image(skb, &cmis->a, "a"))
+		return -EMSGSIZE;
+	if (cmis->b_present &&
+	    module_fw_info_fill_reply_image(skb, &cmis->b, "b"))
+		return -EMSGSIZE;
+	if (cmis->factory_present &&
+	    module_fw_info_fill_reply_image(skb, &cmis->factory, "factory"))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int module_fw_info_fill_reply(struct sk_buff *skb,
+				     const struct ethnl_req_info *req_base,
+				     const struct ethnl_reply_data *reply_base)
+{
+	const struct module_fw_info_reply_data *data;
+
+	data = MODULE_FW_INFO_REPDATA(reply_base);
+
+	switch (data->fw_info.type) {
+	case ETHTOOL_MODULE_FW_INFO_TYPE_CMIS:
+		return module_fw_info_fill_reply_cmis(skb, &data->fw_info.cmis);
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+}
+
+const struct ethnl_request_ops ethnl_module_fw_info_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MODULE_FW_INFO_GET,
+	.reply_cmd		= ETHTOOL_MSG_MODULE_FW_INFO_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MODULE_FW_INFO_HEADER,
+	.req_info_size		= sizeof(struct module_fw_info_req_info),
+	.reply_data_size	= sizeof(struct module_fw_info_reply_data),
+
+	.prepare_data		= module_fw_info_prepare_data,
+	.reply_size		= module_fw_info_reply_size,
+	.fill_reply		= module_fw_info_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 38b44c0291b1..380a38b8535c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -283,6 +283,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_MODULE_FW_INFO_GET] = &ethnl_module_fw_info_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1018,6 +1019,15 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_module_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_FW_INFO_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_module_fw_info_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_module_fw_info_get_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 490598e5eedd..041ffe8db8cb 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -338,6 +338,7 @@ extern const struct ethnl_request_ops ethnl_module_eeprom_request_ops;
 extern const struct ethnl_request_ops ethnl_stats_request_ops;
 extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
+extern const struct ethnl_request_ops ethnl_module_fw_info_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -376,6 +377,7 @@ extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
+extern const struct nla_policy ethnl_module_fw_info_get_policy[ETHTOOL_A_MODULE_FW_INFO_HEADER + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.31.1

