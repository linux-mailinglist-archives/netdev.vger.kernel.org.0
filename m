Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C80293084
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733093AbgJSVcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:32:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:41452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgJSVcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:32:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 274ADAD11;
        Mon, 19 Oct 2020 21:32:44 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E118760563; Mon, 19 Oct 2020 23:32:43 +0200 (CEST)
Message-Id: <1193886b3994f75c86327b09e6e1a966413181e1.1603142897.git.mkubecek@suse.cz>
In-Reply-To: <cover.1603142897.git.mkubecek@suse.cz>
References: <cover.1603142897.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 2/4] netlink: support 64-bit attribute types in pretty
 printed messages
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 19 Oct 2020 23:32:43 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NLA_U64 (unsigned), NLA_X64 (unsigned, printed as hex) and NLA_S64
(signed) attribute types in pretty printing code.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/prettymsg.c | 10 ++++++++++
 netlink/prettymsg.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/netlink/prettymsg.c b/netlink/prettymsg.c
index d5d999fddfbb..0a1fae3da54e 100644
--- a/netlink/prettymsg.c
+++ b/netlink/prettymsg.c
@@ -9,6 +9,7 @@
 #include <errno.h>
 #include <stdint.h>
 #include <limits.h>
+#include <inttypes.h>
 #include <linux/genetlink.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_link.h>
@@ -110,6 +111,9 @@ static int pretty_print_attr(const struct nlattr *attr,
 	case NLA_U32:
 		printf("%u", mnl_attr_get_u32(attr));
 		break;
+	case NLA_U64:
+		printf("%" PRIu64, mnl_attr_get_u64(attr));
+		break;
 	case NLA_X8:
 		printf("0x%02x", mnl_attr_get_u8(attr));
 		break;
@@ -119,6 +123,9 @@ static int pretty_print_attr(const struct nlattr *attr,
 	case NLA_X32:
 		printf("0x%08x", mnl_attr_get_u32(attr));
 		break;
+	case NLA_X64:
+		printf("%" PRIx64, mnl_attr_get_u64(attr));
+		break;
 	case NLA_S8:
 		printf("%d", (int)mnl_attr_get_u8(attr));
 		break;
@@ -128,6 +135,9 @@ static int pretty_print_attr(const struct nlattr *attr,
 	case NLA_S32:
 		printf("%d", (int)mnl_attr_get_u32(attr));
 		break;
+	case NLA_S64:
+		printf("%" PRId64, (int64_t)mnl_attr_get_u64(attr));
+		break;
 	case NLA_STRING:
 		printf("\"%.*s\"", alen, (const char *)adata);
 		break;
diff --git a/netlink/prettymsg.h b/netlink/prettymsg.h
index 6987c6ec5bca..25990cceffca 100644
--- a/netlink/prettymsg.h
+++ b/netlink/prettymsg.h
@@ -17,12 +17,15 @@ enum pretty_nla_format {
 	NLA_U8,
 	NLA_U16,
 	NLA_U32,
+	NLA_U64,
 	NLA_X8,
 	NLA_X16,
 	NLA_X32,
+	NLA_X64,
 	NLA_S8,
 	NLA_S16,
 	NLA_S32,
+	NLA_S64,
 	NLA_STRING,
 	NLA_FLAG,
 	NLA_BOOL,
@@ -62,12 +65,15 @@ struct pretty_nlmsg_desc {
 #define NLATTR_DESC_U8(_name)		NLATTR_DESC(_name, NLA_U8)
 #define NLATTR_DESC_U16(_name)		NLATTR_DESC(_name, NLA_U16)
 #define NLATTR_DESC_U32(_name)		NLATTR_DESC(_name, NLA_U32)
+#define NLATTR_DESC_U64(_name)		NLATTR_DESC(_name, NLA_U64)
 #define NLATTR_DESC_X8(_name)		NLATTR_DESC(_name, NLA_X8)
 #define NLATTR_DESC_X16(_name)		NLATTR_DESC(_name, NLA_X16)
 #define NLATTR_DESC_X32(_name)		NLATTR_DESC(_name, NLA_X32)
+#define NLATTR_DESC_X64(_name)		NLATTR_DESC(_name, NLA_X64)
 #define NLATTR_DESC_S8(_name)		NLATTR_DESC(_name, NLA_U8)
 #define NLATTR_DESC_S16(_name)		NLATTR_DESC(_name, NLA_U16)
 #define NLATTR_DESC_S32(_name)		NLATTR_DESC(_name, NLA_U32)
+#define NLATTR_DESC_S64(_name)		NLATTR_DESC(_name, NLA_S64)
 #define NLATTR_DESC_STRING(_name)	NLATTR_DESC(_name, NLA_STRING)
 #define NLATTR_DESC_FLAG(_name)		NLATTR_DESC(_name, NLA_FLAG)
 #define NLATTR_DESC_BOOL(_name)		NLATTR_DESC(_name, NLA_BOOL)
-- 
2.28.0

