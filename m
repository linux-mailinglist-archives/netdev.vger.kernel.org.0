Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762653B154E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFWID5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:03:57 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53185 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230273AbhFWIDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:03:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id EF63B580709;
        Wed, 23 Jun 2021 04:01:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 23 Jun 2021 04:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=VIp+bhIp3mYonk/f1uQ5ROwnOm/7WKJ1lUe9jtFBXf0=; b=iEIvvNHW
        ibabgWcIzh3kkaIQ7guyvfzJAERwPhCreZPyQoQkhPiAOjoftbhB/t4qNxbdrnwJ
        TI7hKr2KXkWAWZ4HY9y68qYl+1e1mgjjZhg4w2bbhbOxg2pwUR5mac19NApwLGMK
        z66wCB0Ky7rHsibXMeF4jrVZiMbUsLU4h482mbk3vOY8bbXVp07u19WmKeQ8liFb
        D58/2XTnrUD3idPePqzBzMkyArWv1GctrX7Wuudb3xKzNc0yyLdxLJ8GR8c4Ftt6
        ngQ183UvXXMHTJSejGoh8CnX83cYxONNNgn/IbvlkwcCJHRbPqccZPRFDW/cfFBj
        oEk2gSRMAdHoyg==
X-ME-Sender: <xms:UerSYAAK2glzkwJUgRLoGxELupmo9-ah6YM_rTEBqY95i5_n01eCdg>
    <xme:UerSYCheyJbUFPTnwZ6WJLjbPvV1t0hkMfTxyz4Sw6hjQrwke38ECg4MomZvIdG85
    MdLVBdfgOxrNV8>
X-ME-Received: <xmr:UerSYDlfKKxGE99alY9JyCIZwVWP6ZGAcQSI574OsSNMumSjH93-phN-NqLPWJEoz20gUey3sPE-aQ77dU8VlLLjDJ8lY2X5pJmWwyC7-wGzEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegvddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UerSYGwtLQ67xMBrFyuU58lRTVxLIYYH3w0F-gBtDkUMcS80d6stNg>
    <xmx:UerSYFQj32PMsSom9cQYdCRRn8Etoysz-07pljg7cGvlmgvbcSB80Q>
    <xmx:UerSYBYfFupQ9dFn2XlNEc0GOP2r-5d-lW9HckffNMpKWLXTV7YJhQ>
    <xmx:UerSYAGIgcS0BnOYLy4Lq_FFBGs0HqizuPJ455YYVGOBGWVG_OLVQw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:01:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 3/4] ethtool: Add ability to write to transceiver module EEPROM
Date:   Wed, 23 Jun 2021 10:59:24 +0300
Message-Id: <20210623075925.2610908-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210623075925.2610908-1-idosch@idosch.org>
References: <20210623075925.2610908-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In a similar fashion to read access to transceiver module EEPROM by
page, add write access. This allows user space to configure various
registers specified in the transceiver module EEPROM memory map (e.g.,
SFF-8636, CMIS).

In the case of CMIS, this also allows user space to implement various
Command Data Block (CDB) messages for interaction with the module. This
is required for advanced functionality such as firmware update.

The new generic netlink command (i.e., 'ETHTOOL_MSG_MODULE_EEPROM_SET')
is fully described in Documentation/networking/ethtool-netlink.rst.

Note that while the 'ETHTOOL_A_MODULE_EEPROM_LENGTH' attribute might
seem redundant, it allows the kernel to validate
'ETHTOOL_MSG_MODULE_EEPROM_SET' messages in a similar fashion to
'ETHTOOL_MSG_MODULE_EEPROM_GET' messages. In addition, it adds another
confirmation regarding the number of bytes to write to the module
EEPROM.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst |  47 +++++++
 include/linux/ethtool.h                      |  21 ++-
 include/uapi/linux/ethtool_netlink.h         |   2 +
 net/ethtool/eeprom.c                         | 133 +++++++++++++++++++
 net/ethtool/netlink.c                        |   7 +
 net/ethtool/netlink.h                        |   2 +
 6 files changed, 205 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 6ea91e41593f..b7da1f5a9a9d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -212,6 +212,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_FEC_SET``               set FEC settings
   ``ETHTOOL_MSG_MODULE_EEPROM_GET``     read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET``             get standard statistics
+  ``ETHTOOL_MSG_MODULE_EEPROM_SET``     write to SFP module EEPROM
   ===================================== ================================
 
 Kernel to userspace:
@@ -250,6 +251,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_FEC_NTF``                  FEC settings
   ``ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY``  read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
+  ``ETHTOOL_MSG_MODULE_EEPROM_NTF``        SFP module EEPROM settings
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1477,6 +1479,50 @@ Low and high bounds are inclusive, for example:
  etherStatsPkts512to1023Octets 512  1023
  ============================= ==== ====
 
+MODULE_EEPROM_SET
+=================
+
+Write to SFP module EEPROM.
+This interface is designed to allow writes of at most 1/2 page at once. This
+means only writes of 128 (or less) bytes are allowed, without crossing half
+page boundary located at offset 128. For pages other than 0 only high 128 bytes
+are accessible.
+
+Request contents:
+
+  =======================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_EEPROM_HEADER``       nested  request header
+  ``ETHTOOL_A_MODULE_EEPROM_OFFSET``       u32     offset within a page
+  ``ETHTOOL_A_MODULE_EEPROM_LENGTH``       u32     amount of bytes to write
+  ``ETHTOOL_A_MODULE_EEPROM_PAGE``         u8      page number
+  ``ETHTOOL_A_MODULE_EEPROM_BANK``         u8      bank number
+  ``ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS``  u8      page I2C address
+  ``ETHTOOL_A_MODULE_EEPROM_DATA``         binary  array of bytes to write
+  =======================================  ======  ==========================
+
+The amount of bytes to write encoded in ``ETHTOOL_A_MODULE_EEPROM_LENGTH`` must
+match the length of the payload of ``ETHTOOL_A_MODULE_EEPROM_DATA``.
+
+If ``ETHTOOL_A_MODULE_EEPROM_BANK`` is not specified, bank 0 is assumed.
+
+Upon a successful write, a ``ETHTOOL_MSG_MODULE_EEPROM_NTF`` notification is
+sent to user space.
+
+Notification contents:
+
+  =======================================  ======  ==========================
+  ``ETHTOOL_A_MODULE_EEPROM_HEADER``       nested  reply header
+  ``ETHTOOL_A_MODULE_EEPROM_OFFSET``       u32     offset within a page
+  ``ETHTOOL_A_MODULE_EEPROM_LENGTH``       u32     amount of bytes written
+  ``ETHTOOL_A_MODULE_EEPROM_PAGE``         u8      page number
+  ``ETHTOOL_A_MODULE_EEPROM_BANK``         u8      bank number
+  ``ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS``  u8      page I2C address
+  =======================================  ======  ==========================
+
+The notification does not include the ``ETHTOOL_A_MODULE_EEPROM_DATA``
+attribute in order to prevent exposing module EEPROM contents to users without
+admin privileges.
+
 Request translation
 ===================
 
@@ -1575,4 +1621,5 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_CABLE_TEST_ACT``
   n/a                                 ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``
   n/a                                 ``ETHTOOL_MSG_TUNNEL_INFO_GET``
+  n/a                                 ``ETHTOOL_MSG_MODULE_EEPROM_SET``
   =================================== =====================================
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 29dbb603bc91..a91e31a1aeeb 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -388,17 +388,19 @@ struct ethtool_rmon_stats {
 #define ETH_MODULE_MAX_I2C_ADDRESS	0x7f
 
 /**
- * struct ethtool_module_eeprom - EEPROM dump from specified page
- * @offset: Offset within the specified EEPROM page to begin read, in bytes.
- * @length: Number of bytes to read.
- * @page: Page number to read from.
- * @bank: Page bank number to read from, if applicable by EEPROM spec.
+ * struct ethtool_module_eeprom - EEPROM read / write from / to specified page
+ * @offset: Offset within the specified EEPROM page to begin read / write,
+ *	in bytes.
+ * @length: Number of bytes to read / write.
+ * @page: Page number to read / write from / to.
+ * @bank: Page bank number to read / write from /to , if applicable by EEPROM
+ *	spec.
  * @i2c_address: I2C address of a page. Value less than 0x7f expected. Most
  *	EEPROMs use 0x50 or 0x51.
  * @data: Pointer to buffer with EEPROM data of @length size.
  *
- * This can be used to manage pages during EEPROM dump in ethtool and pass
- * required information to the driver.
+ * This can be used to manage pages during EEPROM read / write in ethtool and
+ * pass required information to the driver.
  */
 struct ethtool_module_eeprom {
 	u32	offset;
@@ -574,6 +576,8 @@ struct ethtool_module_eeprom {
  * @get_eth_ctrl_stats: Query some of the IEEE 802.3 MAC Ctrl statistics.
  * @get_rmon_stats: Query some of the RMON (RFC 2819) statistics.
  *	Set %ranges to a pointer to zero-terminated array of byte ranges.
+ * @set_module_eeprom_by_page: Write to a region of plug-in module EEPROM.
+ *	Returns a negative error code or zero.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -693,6 +697,9 @@ struct ethtool_ops {
 	void	(*get_rmon_stats)(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats,
 				  const struct ethtool_rmon_hist_range **ranges);
+	int	(*set_module_eeprom_by_page)(struct net_device *dev,
+					     const struct ethtool_module_eeprom *page,
+					     struct netlink_ext_ack *extack);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index c7135c9c37a5..9cf2f5a860ba 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -46,6 +46,7 @@ enum {
 	ETHTOOL_MSG_FEC_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
+	ETHTOOL_MSG_MODULE_EEPROM_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -88,6 +89,7 @@ enum {
 	ETHTOOL_MSG_FEC_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
+	ETHTOOL_MSG_MODULE_EEPROM_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 945b95e64f0d..dc8ffa67b249 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -250,3 +250,136 @@ const struct nla_policy ethnl_module_eeprom_get_policy[] = {
 		NLA_POLICY_RANGE(NLA_U8, 0, ETH_MODULE_MAX_I2C_ADDRESS),
 };
 
+const struct nla_policy ethnl_module_eeprom_set_policy[] = {
+	[ETHTOOL_A_MODULE_EEPROM_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MODULE_EEPROM_OFFSET]	=
+		NLA_POLICY_MAX(NLA_U32, ETH_MODULE_EEPROM_PAGE_LEN * 2 - 1),
+	[ETHTOOL_A_MODULE_EEPROM_LENGTH]	=
+		NLA_POLICY_RANGE(NLA_U32, 1, ETH_MODULE_EEPROM_PAGE_LEN),
+	[ETHTOOL_A_MODULE_EEPROM_PAGE]		= { .type = NLA_U8 },
+	[ETHTOOL_A_MODULE_EEPROM_BANK]		= { .type = NLA_U8 },
+	[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]	=
+		NLA_POLICY_RANGE(NLA_U8, 0, ETH_MODULE_MAX_I2C_ADDRESS),
+	[ETHTOOL_A_MODULE_EEPROM_DATA]		=
+		NLA_POLICY_RANGE(NLA_BINARY, 1, ETH_MODULE_EEPROM_PAGE_LEN),
+};
+
+static int ethnl_module_eeprom_ntf(struct net_device *dev,
+				   const struct ethtool_module_eeprom *page)
+{
+	struct sk_buff *skb;
+	void *ehdr;
+	int err;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	ehdr = ethnl_bcastmsg_put(skb, ETHTOOL_MSG_MODULE_EEPROM_NTF);
+	if (!ehdr) {
+		err = -EMSGSIZE;
+		goto out;
+	}
+
+	err = ethnl_fill_reply_header(skb, dev, ETHTOOL_A_MODULE_EEPROM_HEADER);
+	if (err)
+		goto out;
+
+	err = nla_put_u32(skb, ETHTOOL_A_MODULE_EEPROM_OFFSET, page->offset);
+	if (err)
+		goto out;
+
+	err = nla_put_u32(skb, ETHTOOL_A_MODULE_EEPROM_LENGTH, page->length);
+	if (err)
+		goto out;
+
+	err = nla_put_u8(skb, ETHTOOL_A_MODULE_EEPROM_PAGE, page->page);
+	if (err)
+		goto out;
+
+	err = nla_put_u8(skb, ETHTOOL_A_MODULE_EEPROM_BANK, page->bank);
+	if (err)
+		goto out;
+
+	err = nla_put_u8(skb, ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,
+			 page->i2c_address);
+	if (err)
+		goto out;
+
+	genlmsg_end(skb, ehdr);
+
+	return ethnl_multicast(skb, dev);
+
+out:
+	nlmsg_free(skb);
+	return err;
+}
+
+int ethnl_set_module_eeprom(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethtool_module_eeprom page = {};
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	int ret;
+
+	if (!tb[ETHTOOL_A_MODULE_EEPROM_OFFSET] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_LENGTH] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_PAGE] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_DATA])
+		return -EINVAL;
+
+	if (nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]) !=
+	    nla_len(tb[ETHTOOL_A_MODULE_EEPROM_DATA]))
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
+				    "data length does not match specified length");
+
+	ret = eeprom_validate(tb, info->extack);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_MODULE_EEPROM_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	ret = -EOPNOTSUPP;
+	if (!ops->set_module_eeprom_by_page)
+		goto out_dev;
+
+	page.offset = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET]);
+	page.length = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]);
+	page.page = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_PAGE]);
+	page.i2c_address = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]);
+	page.data = nla_data(tb[ETHTOOL_A_MODULE_EEPROM_DATA]);
+	if (tb[ETHTOOL_A_MODULE_EEPROM_BANK])
+		page.bank = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_BANK]);
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = dev->ethtool_ops->set_module_eeprom_by_page(dev, &page,
+							  info->extack);
+	if (ret < 0)
+		goto out_ops;
+
+	ethnl_module_eeprom_ntf(dev, &page);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index a7346346114f..71afb80fda20 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -958,6 +958,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_stats_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_stats_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_EEPROM_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_module_eeprom,
+		.policy	= ethnl_module_eeprom_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_module_eeprom_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3e25a47fd482..5540d5713d33 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -382,6 +382,7 @@ extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
 extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
+extern const struct nla_policy ethnl_module_eeprom_set_policy[ETHTOOL_A_MODULE_EEPROM_DATA + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -400,6 +401,7 @@ int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_module_eeprom(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
-- 
2.31.1

