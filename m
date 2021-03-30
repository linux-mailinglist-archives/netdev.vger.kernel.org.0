Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61D534DFD2
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhC3EAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhC3EAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D808461969;
        Tue, 30 Mar 2021 04:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617076802;
        bh=Q0JQiv0Vlu9DrM/CmQFAfw00GWoWVEhqsn8hJbRuLWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRMA7zC6Ziss4PZ4hKHU155lo2UrGvt0EHXW4wHOPrUSGZLqOyeQDJnc1mkl2xFgj
         t2FI/+NxfV+5XZ7D5loP4ORAgneSq7/hVMR6R28F2+sNG0o+IPztRjXD619fuaqHwg
         GiZMXJDbJkZm3PUrwdp5YkNIFS8HCErmcQbFyVRcBsJNdVHd6Y5+VGaOe2Pnk2Lr/Y
         iDjT5Mh/2toj7EfetAV8GzhoT3WYZrAvhNwxXFyJiZ4XfT7q399Uj1rlS+UGgQef5Y
         xCT2Fb40VBnRd3nHyVJKyV7VyJaxQN299JGrqi3kJhz+nQaCwanSYJA6Yffw+Fsast
         KE5oeWpzJDnhg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] ethtool: support FEC settings over netlink
Date:   Mon, 29 Mar 2021 20:59:52 -0700
Message-Id: <20210330035954.1206441-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330035954.1206441-1-kuba@kernel.org>
References: <20210330035954.1206441-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add FEC API to netlink.

This is not a 1-to-1 conversion.

FEC settings already depend on link modes to tell user which
modes are supported. Take this further an use link modes for
manual configuration. Old struct ethtool_fecparam is still
used to talk to the drivers, so we need to translate back
and forth. We can revisit the internal API if number of FEC
encodings starts to grow.

Enforce only one active FEC bit (by using a bit position
rather than another mask).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst |  62 ++++-
 include/uapi/linux/ethtool_netlink.h         |  17 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/fec.c                            | 238 +++++++++++++++++++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |   4 +
 6 files changed, 339 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/fec.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 05073482db05..4bdb4298f178 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -208,6 +208,8 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
   ``ETHTOOL_MSG_CABLE_TEST_ACT``        action start cable test
   ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``    action start raw TDR cable test
   ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
+  ``ETHTOOL_MSG_FEC_GET``               get FEC settings
+  ``ETHTOOL_MSG_FEC_SET``               set FEC settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -242,6 +244,8 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
   ``ETHTOOL_MSG_CABLE_TEST_NTF``        Cable test results
   ``ETHTOOL_MSG_CABLE_TEST_TDR_NTF``    Cable test TDR results
   ``ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY`` tunnel offload info
+  ``ETHTOOL_MSG_FEC_GET_REPLY``         FEC settings
+  ``ETHTOOL_MSG_FEC_NTF``               FEC settings
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1280,6 +1284,60 @@ Gets information about the tunnel state NIC is aware of.
 For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
 the table contains static entries, hard-coded by the NIC.
 
+FEC_GET
+=======
+
+Gets FEC configuration and state like ``ETHTOOL_GFECPARAM`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_FEC_HEADER``               nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_FEC_HEADER``               nested  request header
+  ``ETHTOOL_A_FEC_MODES``                bitset  configured modes
+  ``ETHTOOL_A_FEC_AUTO``                 bool    FEC mode auto selection
+  ``ETHTOOL_A_FEC_ACTIVE``               u32     index of active FEC mode
+  =====================================  ======  ==========================
+
+``ETHTOOL_A_FEC_ACTIVE`` is the bit index of the FEC link mode currently
+active on the interface. This attribute may not be present if device does
+not support FEC.
+
+``ETHTOOL_A_FEC_MODES`` and ``ETHTOOL_A_FEC_AUTO`` are only meaningful when
+autonegotiation is disabled. If ``ETHTOOL_A_FEC_AUTO`` is non-zero driver will
+select the FEC mode automatically based on the parameters of the SFP module.
+This is equivalent to the ``ETHTOOL_FEC_AUTO`` bit of the ioctl interface.
+``ETHTOOL_A_FEC_MODES`` carry the current FEC configuration using link mode
+bits (rather than old ``ETHTOOL_FEC_*`` bits).
+
+FEC_SET
+=======
+
+Sets FEC parameters like ``ETHTOOL_SFECPARAM`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_FEC_HEADER``               nested  request header
+  ``ETHTOOL_A_FEC_MODES``                bitset  configured modes
+  ``ETHTOOL_A_FEC_AUTO``                 bool    FEC mode auto selection
+  =====================================  ======  ==========================
+
+``FEC_SET`` is only meaningful when autonegotiation is disabled. Otherwise
+FEC mode is selected as part of autonegotiation.
+
+``ETHTOOL_A_FEC_MODES`` selects which FEC mode should be used. It's recommended
+to set only one bit, if multiple bits are set driver may choose between them
+in an implementation specific way.
+
+``ETHTOOL_A_FEC_AUTO`` requests the driver to choose FEC mode based on SFP
+module parameters. This does not mean autonegotiation.
+
 Request translation
 ===================
 
@@ -1373,8 +1431,8 @@ are netlink only.
                                       ``ETHTOOL_MSG_LINKMODES_SET``
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
-  ``ETHTOOL_GFECPARAM``               n/a
-  ``ETHTOOL_SFECPARAM``               n/a
+  ``ETHTOOL_GFECPARAM``               ``ETHTOOL_MSG_FEC_GET``
+  ``ETHTOOL_SFECPARAM``               ``ETHTOOL_MSG_FEC_SET``
   n/a                                 ''ETHTOOL_MSG_CABLE_TEST_ACT''
   n/a                                 ''ETHTOOL_MSG_CABLE_TEST_TDR_ACT''
   n/a                                 ``ETHTOOL_MSG_TUNNEL_INFO_GET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a286635ac9b8..7f1bdb5b31ba 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,8 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
+	ETHTOOL_MSG_FEC_GET,
+	ETHTOOL_MSG_FEC_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -80,6 +82,8 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
+	ETHTOOL_MSG_FEC_GET_REPLY,
+	ETHTOOL_MSG_FEC_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -629,6 +633,19 @@ enum {
 	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
 };
 
+/* FEC */
+
+enum {
+	ETHTOOL_A_FEC_UNSPEC,
+	ETHTOOL_A_FEC_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_FEC_MODES,				/* bitset */
+	ETHTOOL_A_FEC_AUTO,				/* u8 */
+	ETHTOOL_A_FEC_ACTIVE,				/* u32 */
+
+	__ETHTOOL_A_FEC_CNT,
+	ETHTOOL_A_FEC_MAX = (__ETHTOOL_A_FEC_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 7a849ff22dad..c2dc9033a8f7 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o
+		   tunnels.o fec.o
diff --git a/net/ethtool/fec.c b/net/ethtool/fec.c
new file mode 100644
index 000000000000..31454b9188bd
--- /dev/null
+++ b/net/ethtool/fec.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct fec_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct fec_reply_data {
+	struct ethnl_reply_data		base;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(fec_link_modes);
+	u32 active_fec;
+	u8 fec_auto;
+};
+
+#define FEC_REPDATA(__reply_base) \
+	container_of(__reply_base, struct fec_reply_data, base)
+
+#define ETHTOOL_FEC_MASK	((ETHTOOL_FEC_LLRS << 1) - 1)
+
+const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1] = {
+	[ETHTOOL_A_FEC_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
+};
+
+static void
+ethtool_fec_to_link_modes(u32 fec, unsigned long *link_modes, u8 *fec_auto)
+{
+	if (fec_auto)
+		*fec_auto = !!(fec & ETHTOOL_FEC_AUTO);
+
+	if (fec & ETHTOOL_FEC_OFF)
+		__set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, link_modes);
+	if (fec & ETHTOOL_FEC_RS)
+		__set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, link_modes);
+	if (fec & ETHTOOL_FEC_BASER)
+		__set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, link_modes);
+	if (fec & ETHTOOL_FEC_LLRS)
+		__set_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT, link_modes);
+}
+
+static int
+ethtool_link_modes_to_fecparam(struct ethtool_fecparam *fec,
+			       unsigned long *link_modes, u8 fec_auto)
+{
+	memset(fec, 0, sizeof(*fec));
+
+	if (fec_auto)
+		fec->fec |= ETHTOOL_FEC_AUTO;
+
+	if (__test_and_clear_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, link_modes))
+		fec->fec |= ETHTOOL_FEC_OFF;
+	if (__test_and_clear_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, link_modes))
+		fec->fec |= ETHTOOL_FEC_RS;
+	if (__test_and_clear_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, link_modes))
+		fec->fec |= ETHTOOL_FEC_BASER;
+	if (__test_and_clear_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT, link_modes))
+		fec->fec |= ETHTOOL_FEC_LLRS;
+
+	if (!bitmap_empty(link_modes, __ETHTOOL_LINK_MODE_MASK_NBITS))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fec_prepare_data(const struct ethnl_req_info *req_base,
+			    struct ethnl_reply_data *reply_base,
+			    struct genl_info *info)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(active_fec_modes) = {};
+	struct fec_reply_data *data = FEC_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	struct ethtool_fecparam fec = {};
+	int ret;
+
+	if (!dev->ethtool_ops->get_fecparam)
+		return -EOPNOTSUPP;
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	ret = dev->ethtool_ops->get_fecparam(dev, &fec);
+	ethnl_ops_complete(dev);
+	if (ret)
+		return ret;
+
+	WARN_ON_ONCE(fec.reserved);
+
+	ethtool_fec_to_link_modes(fec.fec, data->fec_link_modes,
+				  &data->fec_auto);
+
+	ethtool_fec_to_link_modes(fec.active_fec, active_fec_modes, NULL);
+	data->active_fec = find_first_bit(active_fec_modes,
+					  __ETHTOOL_LINK_MODE_MASK_NBITS);
+	/* Don't report attr if no FEC mode set. Note that
+	 * ethtool_fecparam_to_link_modes() ignores NONE and AUTO.
+	 */
+	if (data->active_fec == __ETHTOOL_LINK_MODE_MASK_NBITS)
+		data->active_fec = 0;
+
+	return 0;
+}
+
+static int fec_reply_size(const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct fec_reply_data *data = FEC_REPDATA(reply_base);
+	int len = 0;
+	int ret;
+
+	ret = ethnl_bitset_size(data->fec_link_modes, NULL,
+				__ETHTOOL_LINK_MODE_MASK_NBITS,
+				link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	len += nla_total_size(sizeof(u8)) +	/* _FEC_AUTO */
+	       nla_total_size(sizeof(u32));	/* _FEC_ACTIVE */
+
+	return len;
+}
+
+static int fec_fill_reply(struct sk_buff *skb,
+			  const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct fec_reply_data *data = FEC_REPDATA(reply_base);
+	int ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_FEC_MODES,
+			       data->fec_link_modes, NULL,
+			       __ETHTOOL_LINK_MODE_MASK_NBITS,
+			       link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+
+	if (nla_put_u8(skb, ETHTOOL_A_FEC_AUTO, data->fec_auto) ||
+	    (data->active_fec &&
+	     nla_put_u32(skb, ETHTOOL_A_FEC_ACTIVE, data->active_fec)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_fec_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_FEC_GET,
+	.reply_cmd		= ETHTOOL_MSG_FEC_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_FEC_HEADER,
+	.req_info_size		= sizeof(struct fec_req_info),
+	.reply_data_size	= sizeof(struct fec_reply_data),
+
+	.prepare_data		= fec_prepare_data,
+	.reply_size		= fec_reply_size,
+	.fill_reply		= fec_fill_reply,
+};
+
+/* FEC_SET */
+
+const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1] = {
+	[ETHTOOL_A_FEC_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_FEC_MODES]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_FEC_AUTO]	= NLA_POLICY_MAX(NLA_U8, 1),
+};
+
+int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(fec_link_modes) = {};
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct ethtool_fecparam fec = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	u8 fec_auto;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_FEC_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	ret = -EOPNOTSUPP;
+	if (!ops->get_fecparam || !ops->set_fecparam)
+		goto out_dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	ret = ops->get_fecparam(dev, &fec);
+	if (ret < 0)
+		goto out_ops;
+
+	ethtool_fec_to_link_modes(fec.fec, fec_link_modes, &fec_auto);
+
+	ret = ethnl_update_bitset(fec_link_modes,
+				  __ETHTOOL_LINK_MODE_MASK_NBITS,
+				  tb[ETHTOOL_A_FEC_MODES],
+				  link_mode_names, info->extack, &mod);
+	if (ret < 0)
+		goto out_ops;
+	ethnl_update_u8(&fec_auto, tb[ETHTOOL_A_FEC_AUTO], &mod);
+
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	ret = ethtool_link_modes_to_fecparam(&fec, fec_link_modes, fec_auto);
+	if (ret) {
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_FEC_MODES],
+				    "invalid FEC modes requested");
+		goto out_ops;
+	}
+	if (!fec.fec) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_FEC_MODES],
+				    "no FEC modes set");
+		goto out_ops;
+	}
+
+	ret = dev->ethtool_ops->set_fecparam(dev, &fec);
+	if (ret < 0)
+		goto out_ops;
+	ethtool_notify(dev, ETHTOOL_MSG_FEC_NTF, NULL);
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
index 50d3c8896f91..705a4b201564 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -244,6 +244,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_COALESCE_GET]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
+	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
 };
 
@@ -551,6 +552,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_COALESCE_NTF]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_NTF]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
+	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 };
 
 /* default notification handler */
@@ -643,6 +645,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_COALESCE_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PAUSE_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -912,6 +915,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_tunnel_info_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_FEC_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_fec_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_fec_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_FEC_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_fec,
+		.policy = ethnl_fec_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_fec_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 6eabd58d81bf..785f7ee45930 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -344,6 +344,7 @@ extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_fec_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -375,6 +376,8 @@ extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +
 extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
 extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
 extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
+extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
+extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -392,5 +395,6 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.30.2

