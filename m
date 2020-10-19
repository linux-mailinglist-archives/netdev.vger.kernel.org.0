Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE3293083
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbgJSVcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:32:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:41422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgJSVcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:32:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1F34FAC2F;
        Mon, 19 Oct 2020 21:32:41 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DBFF860563; Mon, 19 Oct 2020 23:32:40 +0200 (CEST)
Message-Id: <e285c4df6b03b9bd72174d2059a7718c55f03edf.1603142897.git.mkubecek@suse.cz>
In-Reply-To: <cover.1603142897.git.mkubecek@suse.cz>
References: <cover.1603142897.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/4] netlink: support u32 enumerated types in pretty
 printing
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 19 Oct 2020 23:32:40 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some numeric attributes take values from a short list/range with symbolic
names. Showing the symbolic names instead of numeric values will make the
pretty printed netlink messages easier to read. If the value is too big for
provided names array (e.g. running on newer kernel) or the name is omitted,
numeric attribute value is shown.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/prettymsg.c |  9 +++++++++
 netlink/prettymsg.h | 18 ++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/netlink/prettymsg.c b/netlink/prettymsg.c
index f992dcaf071f..d5d999fddfbb 100644
--- a/netlink/prettymsg.c
+++ b/netlink/prettymsg.c
@@ -137,6 +137,15 @@ static int pretty_print_attr(const struct nlattr *attr,
 	case NLA_BOOL:
 		printf("%s", mnl_attr_get_u8(attr) ? "on" : "off");
 		break;
+	case NLA_U32_ENUM: {
+		uint32_t val = mnl_attr_get_u32(attr);
+
+		if (adesc && val < adesc->n_names && adesc->names[val])
+			printf("%s", adesc->names[val]);
+		else
+			printf("%u", val);
+		break;
+	}
 	default:
 		if (alen <= __DUMP_LINE)
 			__print_binary_short(adata, alen);
diff --git a/netlink/prettymsg.h b/netlink/prettymsg.h
index b5e5f735ac8a..6987c6ec5bca 100644
--- a/netlink/prettymsg.h
+++ b/netlink/prettymsg.h
@@ -28,13 +28,20 @@ enum pretty_nla_format {
 	NLA_BOOL,
 	NLA_NESTED,
 	NLA_ARRAY,
+	NLA_U32_ENUM,
 };
 
 struct pretty_nla_desc {
 	enum pretty_nla_format		format;
 	const char			*name;
-	const struct pretty_nla_desc	*children;
-	unsigned int			n_children;
+	union {
+		const struct pretty_nla_desc	*children;
+		const char			*const *names;
+	};
+	union {
+		unsigned int			n_children;
+		unsigned int			n_names;
+	};
 };
 
 struct pretty_nlmsg_desc {
@@ -81,6 +88,13 @@ struct pretty_nlmsg_desc {
 		.children = __ ## _children_desc ## _desc, \
 		.n_children = 1, \
 	}
+#define NLATTR_DESC_U32_ENUM(_name, _names_table) \
+	[_name] = { \
+		.format = NLA_U32_ENUM, \
+		.name = #_name, \
+		.names = __ ## _names_table ## _names, \
+		.n_children = ARRAY_SIZE(__ ## _names_table ## _names), \
+	}
 
 #define NLMSG_DESC(_name, _attrs) \
 	[_name] = { \
-- 
2.28.0

