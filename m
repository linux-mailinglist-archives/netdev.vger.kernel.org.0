Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0E11799BD
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388332AbgCDUZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:25:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:33706 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388327AbgCDUZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:25:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AEA0DAF01;
        Wed,  4 Mar 2020 20:25:51 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5FE04E037F; Wed,  4 Mar 2020 21:25:51 +0100 (CET)
Message-Id: <822930f2261c04da4a02dcd7d8b1e4aed360d072.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 15/25] netlink: support getting wake-on-lan and
 debugging settings
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:25:51 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finish "ethtool <dev>" command implementation by adding support for
wake-on-lan (ETHTOOL_MSG_WOL_GET) and debugging (ETHTOOL_MSG_DEBUG_GET,
currently only msglevel) settings.

Register the callbacks also with monitor so that "ethtool --monitor" can
display corresponding notifications.

v2:
  - suppress error messages for -EOPNOTSUPP responses
  - perform WOL_GET and DEBUG_GET requests before LINKSTATE_GET
  - adjust to changes in patch 14

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/monitor.c  |  16 +++++++
 netlink/netlink.h  |   2 +
 netlink/settings.c | 115 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+)

diff --git a/netlink/monitor.c b/netlink/monitor.c
index e8fdcd2b93ef..5fce6b64c08c 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -23,6 +23,14 @@ static struct {
 		.cmd	= ETHTOOL_MSG_LINKINFO_NTF,
 		.cb	= linkinfo_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_WOL_NTF,
+		.cb	= wol_reply_cb,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_DEBUG_NTF,
+		.cb	= debug_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -86,6 +94,14 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "-s|--change",
 		.cmd		= ETHTOOL_MSG_LINKMODES_NTF,
 	},
+	{
+		.pattern	= "-s|--change",
+		.cmd		= ETHTOOL_MSG_WOL_NTF,
+	},
+	{
+		.pattern	= "-s|--change",
+		.cmd		= ETHTOOL_MSG_DEBUG_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 16754899976d..730f8e1b3fe9 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -49,6 +49,8 @@ int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname);
 
 int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int wol_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 static inline void copy_devname(char *dst, const char *src)
 {
diff --git a/netlink/settings.c b/netlink/settings.c
index 46c292a3d92d..e95bbcc9ad86 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -604,6 +604,110 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
+void wol_modes_cb(unsigned int idx, const char *name, bool val, void *data)
+{
+	struct ethtool_wolinfo *wol = data;
+
+	if (idx >= 32)
+		return;
+	wol->supported |= (1U << idx);
+	if (val)
+		wol->wolopts |= (1U << idx);
+}
+
+int wol_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_WOL_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	struct ethtool_wolinfo wol = {};
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_WOL_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	if (tb[ETHTOOL_A_WOL_MODES])
+		walk_bitset(tb[ETHTOOL_A_WOL_MODES], NULL, wol_modes_cb, &wol);
+	if (tb[ETHTOOL_A_WOL_SOPASS]) {
+		unsigned int len;
+
+		len = mnl_attr_get_payload_len(tb[ETHTOOL_A_WOL_SOPASS]);
+		if (len != SOPASS_MAX)
+			fprintf(stderr, "invalid SecureOn password length %u (should be %u)\n",
+				len, SOPASS_MAX);
+		else
+			memcpy(wol.sopass,
+			       mnl_attr_get_payload(tb[ETHTOOL_A_WOL_SOPASS]),
+			       SOPASS_MAX);
+	}
+	print_banner(nlctx);
+	dump_wol(&wol);
+
+	return MNL_CB_OK;
+}
+
+void msgmask_cb(unsigned int idx, const char *name, bool val, void *data)
+{
+	u32 *msg_mask = data;
+
+	if (idx >= 32)
+		return;
+	if (val)
+		*msg_mask |= (1U << idx);
+}
+
+void msgmask_cb2(unsigned int idx, const char *name, bool val, void *data)
+{
+	if (val)
+		printf(" %s", name);
+}
+
+int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_DEBUG_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	const struct stringset *msgmask_strings = NULL;
+	struct nl_context *nlctx = data;
+	u32 msg_mask = 0;
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_DEBUG_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	if (!tb[ETHTOOL_A_DEBUG_MSGMASK])
+		return MNL_CB_OK;
+	if (bitset_is_compact(tb[ETHTOOL_A_DEBUG_MSGMASK])) {
+		ret = netlink_init_ethnl2_socket(nlctx);
+		if (ret < 0)
+			return MNL_CB_OK;
+		msgmask_strings = global_stringset(ETH_SS_MSG_CLASSES,
+						   nlctx->ethnl2_socket);
+	}
+
+	print_banner(nlctx);
+	walk_bitset(tb[ETHTOOL_A_DEBUG_MSGMASK], NULL, msgmask_cb, &msg_mask);
+	printf("        Current message level: 0x%08x (%u)\n"
+	       "                              ",
+	       msg_mask, msg_mask);
+	walk_bitset(tb[ETHTOOL_A_DEBUG_MSGMASK], msgmask_strings, msgmask_cb2,
+		    NULL);
+	fputc('\n', stdout);
+
+	return MNL_CB_OK;
+}
+
 static int gset_request(struct nl_socket *nlsk, uint8_t msg_type,
 			uint16_t hdr_attr, mnl_cb_t cb)
 {
@@ -633,6 +737,16 @@ int nl_gset(struct cmd_context *ctx)
 	if (ret == -ENODEV)
 		return ret;
 
+	ret = gset_request(nlsk, ETHTOOL_MSG_WOL_GET, ETHTOOL_A_WOL_HEADER,
+			   wol_reply_cb);
+	if (ret == -ENODEV)
+		return ret;
+
+	ret = gset_request(nlsk, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
+			   debug_reply_cb);
+	if (ret == -ENODEV)
+		return ret;
+
 	ret = gset_request(nlsk, ETHTOOL_MSG_LINKSTATE_GET,
 			   ETHTOOL_A_LINKSTATE_HEADER, linkstate_reply_cb);
 	if (ret == -ENODEV)
@@ -643,5 +757,6 @@ int nl_gset(struct cmd_context *ctx)
 		return 75;
 	}
 
+
 	return 0;
 }
-- 
2.25.1

