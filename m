Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E41A41C866
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345280AbhI2PbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345157AbhI2PbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33511C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:43 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dj4so10523565edb.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OZ3GkQ+8Nx5Bb569cVbmprs3JRZYrk6EPVO1lIAUa98=;
        b=zcHtwLnJ94rdBbd3lpnJNP6sznDnzfsmm1+J1Ep0DT0nioUU++4Varn7VnlGILHzE6
         QzmCgZGqJrjm/eDYxaQceVQi1LmPCu7bqrihciTKRkYDJrHK4NDOxTJ6FXHh6UBWYnbp
         udtt6WDNCmuVYq4Eo9KVUNEv/g6eK1f/cB0Zgu2wkrRF9cwqtCTIrcFQB2v5GQdYaMfv
         +6EP0sv6F6KMapfbzRek1tKIE6RHDltC1SgLIOt/6/y8FWrdOGOW+NRBGEPIr096xk1V
         QAQWjEcMltUX4RtBqO/Agthzl22UUzwdRLXY3YwBztn9rwPoFDaUbz1WDCHPOZiw5bOL
         HaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OZ3GkQ+8Nx5Bb569cVbmprs3JRZYrk6EPVO1lIAUa98=;
        b=OnXoT1SdPLZohQVQAiLDJkDpD/faJy7qXCiUxPERRlcx3tqVrIpRBGKLHloNnG9ouY
         Qr13n79Won2Jj3KUWu6kHPSt/eH4GxLhFR7z0W58kCgyC1Bjyfag+5SCRwbJ2MAgYyd8
         pu9JDB9YKCzhkAjFwqXu8JqlDRsvOqxXkuhMfYFovFetAK0o9Mgf8Hxd1REbyaOx+YtY
         SZ+nSRsEK4it4Sv8YLgiBRq3JOgg7jsTEqPyLwfCcz6e5UE8pc9Vxs8cJD1nF6fLrESt
         1bTQ2UeI2/eDNj3/WJxXRV8ONCPKDBqS6vzzniufhANBNg8M05UoaRZjV26CBxwtHSok
         Qx3g==
X-Gm-Message-State: AOAM533YGlh1nAEQ+75focWEfXEnXxkugX2JbsI8hGHxACbZTqQWikTf
        +S4XruTfZpEuX34BZZ4ueuNZJLhjFGmO0LHe
X-Google-Smtp-Source: ABdhPJyncIBz9kHeE3VAQYQnsh3OBqFe5vDbEsvpgCjMtRantIP4697QVa313Z94DfkjhBmkmYzvqA==
X-Received: by 2002:a17:906:b052:: with SMTP id bj18mr343248ejb.55.1632929335981;
        Wed, 29 Sep 2021 08:28:55 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:55 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 03/11] ip: nexthop: add nh struct and a helper to parse nhmsg into it
Date:   Wed, 29 Sep 2021 18:28:40 +0300
Message-Id: <20210929152848.1710552-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a structure which describes a nexthop with all of its properties and
a helper which parses a nhmsg into it. Note the LWT attribute is copied
because there are too many different types with their own structures,
having to follow them all for changes would be overkill. It's much better
to copy the attribtue and pass it for decoding to the lwt code which is
already well maintained.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++-
 ip/nh_common.h | 33 +++++++++++++++++
 2 files changed, 129 insertions(+), 1 deletion(-)
 create mode 100644 ip/nh_common.h

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index a4048d803325..be8541476fa6 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -13,6 +13,7 @@
 
 #include "utils.h"
 #include "ip_common.h"
+#include "nh_common.h"
 
 static struct {
 	unsigned int flushed;
@@ -212,13 +213,20 @@ out:
 	return rc;
 }
 
+static bool __valid_nh_group_attr(const struct rtattr *g_attr)
+{
+	int num = RTA_PAYLOAD(g_attr) / sizeof(struct nexthop_grp);
+
+	return num && num * sizeof(struct nexthop_grp) == RTA_PAYLOAD(g_attr);
+}
+
 static void print_nh_group(FILE *fp, const struct rtattr *grps_attr)
 {
 	struct nexthop_grp *nhg = RTA_DATA(grps_attr);
 	int num = RTA_PAYLOAD(grps_attr) / sizeof(*nhg);
 	int i;
 
-	if (!num || num * sizeof(*nhg) != RTA_PAYLOAD(grps_attr)) {
+	if (!__valid_nh_group_attr(grps_attr)) {
 		fprintf(fp, "<invalid nexthop group>");
 		return;
 	}
@@ -328,6 +336,93 @@ static void print_nh_res_bucket(FILE *fp, const struct rtattr *res_bucket_attr)
 	close_json_object();
 }
 
+static void ipnh_destroy_entry(struct nh_entry *nhe)
+{
+	if (nhe->nh_encap)
+		free(nhe->nh_encap);
+	if (nhe->nh_groups)
+		free(nhe->nh_groups);
+}
+
+/* parse nhmsg into nexthop entry struct which must be destroyed by
+ * ipnh_destroy_enty when it's not needed anymore
+ */
+static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
+			    struct nh_entry *nhe)
+{
+	struct rtattr *tb[NHA_MAX+1];
+	int err = 0;
+
+	memset(nhe, 0, sizeof(*nhe));
+	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
+
+	if (tb[NHA_ID])
+		nhe->nh_id = rta_getattr_u32(tb[NHA_ID]);
+
+	if (tb[NHA_OIF])
+		nhe->nh_oif = rta_getattr_u32(tb[NHA_OIF]);
+
+	if (tb[NHA_GROUP_TYPE])
+		nhe->nh_grp_type = rta_getattr_u16(tb[NHA_GROUP_TYPE]);
+
+	if (tb[NHA_GATEWAY]) {
+		if (RTA_PAYLOAD(tb[NHA_GATEWAY]) > sizeof(nhe->nh_gateway)) {
+			fprintf(fp, "<nexthop id %u invalid gateway length %lu>\n",
+				nhe->nh_id, RTA_PAYLOAD(tb[NHA_GATEWAY]));
+			err = EINVAL;
+			goto out_err;
+		}
+		nhe->nh_gateway_len = RTA_PAYLOAD(tb[NHA_GATEWAY]);
+		memcpy(&nhe->nh_gateway, RTA_DATA(tb[NHA_GATEWAY]),
+		       RTA_PAYLOAD(tb[NHA_GATEWAY]));
+	}
+
+	if (tb[NHA_ENCAP]) {
+		nhe->nh_encap = malloc(RTA_LENGTH(RTA_PAYLOAD(tb[NHA_ENCAP])));
+		if (!nhe->nh_encap) {
+			err = ENOMEM;
+			goto out_err;
+		}
+		memcpy(nhe->nh_encap, tb[NHA_ENCAP],
+		       RTA_LENGTH(RTA_PAYLOAD(tb[NHA_ENCAP])));
+		memcpy(&nhe->nh_encap_type, tb[NHA_ENCAP_TYPE],
+		       sizeof(nhe->nh_encap_type));
+	}
+
+	if (tb[NHA_GROUP]) {
+		if (!__valid_nh_group_attr(tb[NHA_GROUP])) {
+			fprintf(fp, "<nexthop id %u invalid nexthop group>",
+				nhe->nh_id);
+			err = EINVAL;
+			goto out_err;
+		}
+
+		nhe->nh_groups = malloc(RTA_PAYLOAD(tb[NHA_GROUP]));
+		if (!nhe->nh_groups) {
+			err = ENOMEM;
+			goto out_err;
+		}
+		nhe->nh_groups_cnt = RTA_PAYLOAD(tb[NHA_GROUP]) /
+				     sizeof(struct nexthop_grp);
+		memcpy(nhe->nh_groups, RTA_DATA(tb[NHA_GROUP]),
+		       RTA_PAYLOAD(tb[NHA_GROUP]));
+	}
+
+	nhe->nh_blackhole = !!tb[NHA_BLACKHOLE];
+	nhe->nh_fdb = !!tb[NHA_FDB];
+
+	nhe->nh_family = nhm->nh_family;
+	nhe->nh_protocol = nhm->nh_protocol;
+	nhe->nh_scope = nhm->nh_scope;
+	nhe->nh_flags = nhm->nh_flags;
+
+	return 0;
+
+out_err:
+	ipnh_destroy_entry(nhe);
+	return err;
+}
+
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
diff --git a/ip/nh_common.h b/ip/nh_common.h
new file mode 100644
index 000000000000..f2ff0e6532d3
--- /dev/null
+++ b/ip/nh_common.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NH_COMMON_H__
+#define __NH_COMMON_H__ 1
+
+struct nh_entry {
+	__u32			nh_id;
+	__u32			nh_oif;
+	__u32			nh_flags;
+	__u16			nh_grp_type;
+	__u8			nh_family;
+	__u8			nh_scope;
+	__u8			nh_protocol;
+
+	bool			nh_blackhole;
+	bool			nh_fdb;
+
+	int			nh_gateway_len;
+	union {
+		__be32		ipv4;
+		struct in6_addr	ipv6;
+	}			nh_gateway;
+
+	struct rtattr		*nh_encap;
+	union {
+		struct rtattr	rta;
+		__u8		_buf[RTA_LENGTH(sizeof(__u16))];
+	}			nh_encap_type;
+
+	int			nh_groups_cnt;
+	struct nexthop_grp	*nh_groups;
+};
+
+#endif /* __NH_COMMON_H__ */
-- 
2.31.1

