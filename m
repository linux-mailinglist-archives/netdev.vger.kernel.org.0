Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB122506E4
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgHXRv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgHXRvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 13:51:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066D4C061575;
        Mon, 24 Aug 2020 10:51:22 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kAGco-00A1ue-Sm; Mon, 24 Aug 2020 19:51:18 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/3] libnetlink: add nl_print_policy() helper
Date:   Mon, 24 Aug 2020 19:51:07 +0200
Message-Id: <20200824175108.53101-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200824175108.53101-1-johannes@sipsolutions.net>
References: <20200824175108.53101-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prints out the data from the given nested attribute
to the given FILE pointer, interpreting the firmware that
the kernel has for showing netlink policies.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/libnetlink.h |  2 ++
 lib/libnetlink.c     | 73 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 0d4a9f29afbd..b9073a6a13ad 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -289,4 +289,6 @@ int rtnl_from_file(FILE *, rtnl_listen_filter_t handler,
 	     RTA_OK(attr, RTA_PAYLOAD(nest) - ((char *)(attr) - (char *)RTA_DATA((nest)))); \
 	     (attr) = RTA_TAIL((attr)))
 
+void nl_print_policy(const struct rtattr *attr, FILE *fp);
+
 #endif /* __LIBNETLINK_H__ */
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index e02d6294b02e..a7b60d873afb 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -28,6 +28,7 @@
 #include <linux/nexthop.h>
 
 #include "libnetlink.h"
+#include "utils.h"
 
 #define __aligned(x)		__attribute__((aligned(x)))
 
@@ -1440,3 +1441,75 @@ int __parse_rtattr_nested_compat(struct rtattr *tb[], int max,
 	memset(tb, 0, sizeof(struct rtattr *) * (max + 1));
 	return 0;
 }
+
+static const char *get_nla_type_str(unsigned int attr)
+{
+	switch (attr) {
+#define C(x) case NL_ATTR_TYPE_ ## x: return #x
+	C(U8);
+	C(U16);
+	C(U32);
+	C(U64);
+	C(STRING);
+	C(FLAG);
+	C(NESTED);
+	C(NESTED_ARRAY);
+	C(NUL_STRING);
+	C(BINARY);
+	C(S8);
+	C(S16);
+	C(S32);
+	C(S64);
+	C(BITFIELD32);
+	default:
+		return "unknown";
+	}
+}
+
+void nl_print_policy(const struct rtattr *attr, FILE *fp)
+{
+	const struct rtattr *pos;
+
+	rtattr_for_each_nested(pos, attr) {
+		const struct rtattr *attr;
+
+		fprintf(fp, " policy[%u]:", pos->rta_type & ~NLA_F_NESTED);
+
+		rtattr_for_each_nested(attr, pos) {
+			struct rtattr *tp[NL_POLICY_TYPE_ATTR_MAX + 1];
+
+			parse_rtattr_nested(tp, ARRAY_SIZE(tp) - 1, attr);
+
+			if (tp[NL_POLICY_TYPE_ATTR_TYPE])
+				fprintf(fp, "attr[%u]: type=%s",
+					attr->rta_type & ~NLA_F_NESTED,
+					get_nla_type_str(rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_TYPE])));
+
+			if (tp[NL_POLICY_TYPE_ATTR_POLICY_IDX])
+				fprintf(fp, " policy:%u",
+					rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_POLICY_IDX]));
+
+			if (tp[NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE])
+				fprintf(fp, " maxattr:%u",
+					rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE]));
+
+			if (tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_S] && tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_S])
+				fprintf(fp, " range:[%lld,%lld]",
+					(signed long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_S]),
+					(signed long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_S]));
+
+			if (tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_U] && tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_U])
+				fprintf(fp, " range:[%llu,%llu]",
+					(unsigned long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MIN_VALUE_U]),
+					(unsigned long long)rta_getattr_u64(tp[NL_POLICY_TYPE_ATTR_MAX_VALUE_U]));
+
+			if (tp[NL_POLICY_TYPE_ATTR_MIN_LENGTH])
+				fprintf(fp, " min len:%u",
+					rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_MIN_LENGTH]));
+
+			if (tp[NL_POLICY_TYPE_ATTR_MAX_LENGTH])
+				fprintf(fp, " max len:%u",
+					rta_getattr_u32(tp[NL_POLICY_TYPE_ATTR_MAX_LENGTH]));
+		}
+	}
+}
-- 
2.26.2

