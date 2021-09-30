Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E38341D8F6
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350585AbhI3LlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350531AbhI3LlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0173BC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:31 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y35so20936680ede.3
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iuVLJJIvg962GHVOqJeAReROnxYdjRumeXo15IjKdno=;
        b=LgKaPTP27D00VTclH0FPPbGS4E2XAWD74DvM2C49StgZ+PokmhYuVoU2TLViB9ZAip
         lL2FGlgduEtcZlZ4lUwHgkjCVkjKXJAJzciH4eXjHwgq7o3lWt5jU3YUeli5iklBDMqb
         HG6JylxrZ+Tn9gHglm/jX+twB+FrPtTZK9/1kex9zPPoPLIREDn70HaYEtP36Vv+Iu2D
         rusfq8W3W24+95apLB6H8n7M/0UsbqeUHk7DBqJpxy3s3MCcdTqEDYJ33k+WMOlFGz4t
         HbcTsJkgiUgXZClMLBoDEcZrlCTPLRHroDzGPBTdGG1bVBBRj6BUihmEG4YbcR+zHCVv
         bj/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iuVLJJIvg962GHVOqJeAReROnxYdjRumeXo15IjKdno=;
        b=1JsBlig2c7BUn/O7jug8rtQ/Ngg1A4q4ZzPSoUoqOsx4dMqpbxXPy7szZ5xvNjEAWD
         qrVUbfd+KzAnyPRHrcu7jSH/CM0yOSJHoWOytjU7GcGIX2mZxr/WwZ0Ia8pYJ88VeXDg
         CEr58t2/r3MwGPOsuQHaPdOeMsP39ey1kLRDMQd9FoJknXoAnIC2nC4KL6jZFND+ZWto
         ATND+IZmcRyqRjjCkUo0GCRd/ZwrKnlbE2dDmyj75N1le7UOKWvbNqSU1Y39rH+alGv5
         rgRozxikzFqsiL3+ccsZeEGoK7DnNboz1mZlA9xPz2jwJ+t7k4x+2fzXjZE2cPl/RZB8
         zUhw==
X-Gm-Message-State: AOAM5305NkA+LDWHRBAIrL0Btt78+fn6F6ugHDbgeZKCUKz2RkkT8kx0
        ZiGjwHBteDnN/Uu/KmkDNhNCrhE0sukPXo3q
X-Google-Smtp-Source: ABdhPJxe3Hp2gnQOhCeYgmZP8yfF5P08KtmKX6ALqp+iIrDSHpv0u4dFwOcG1cPYECL+U1twdksOYA==
X-Received: by 2002:a17:906:4ac3:: with SMTP id u3mr1824936ejt.72.1633001969320;
        Thu, 30 Sep 2021 04:39:29 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:28 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 06/12] ip: nexthop: parse attributes into nh entry structure before printing
Date:   Thu, 30 Sep 2021 14:38:38 +0300
Message-Id: <20210930113844.1829373-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out the nexthop attribute parsing and parse attributes into a
nexthop entry structure which is then used to print.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 186 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 139 insertions(+), 47 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 7094d6cbb5e6..0edb3c265b6f 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -213,28 +213,29 @@ out:
 	return rc;
 }
 
-static void print_nh_group(FILE *fp, const struct rtattr *grps_attr)
+static bool __valid_nh_group_attr(const struct rtattr *g_attr)
 {
-	struct nexthop_grp *nhg = RTA_DATA(grps_attr);
-	int num = RTA_PAYLOAD(grps_attr) / sizeof(*nhg);
-	int i;
+	int num = RTA_PAYLOAD(g_attr) / sizeof(struct nexthop_grp);
 
-	if (!num || num * sizeof(*nhg) != RTA_PAYLOAD(grps_attr)) {
-		fprintf(fp, "<invalid nexthop group>");
-		return;
-	}
+	return num && num * sizeof(struct nexthop_grp) == RTA_PAYLOAD(g_attr);
+}
+
+static void print_nh_group(const struct nh_entry *nhe)
+{
+	int i;
 
 	open_json_array(PRINT_JSON, "group");
 	print_string(PRINT_FP, NULL, "%s", "group ");
-	for (i = 0; i < num; ++i) {
+	for (i = 0; i < nhe->nh_groups_cnt; ++i) {
 		open_json_object(NULL);
 
 		if (i)
 			print_string(PRINT_FP, NULL, "%s", "/");
 
-		print_uint(PRINT_ANY, "id", "%u", nhg[i].id);
-		if (nhg[i].weight)
-			print_uint(PRINT_ANY, "weight", ",%u", nhg[i].weight + 1);
+		print_uint(PRINT_ANY, "id", "%u", nhe->nh_groups[i].id);
+		if (nhe->nh_groups[i].weight)
+			print_uint(PRINT_ANY, "weight", ",%u",
+				   nhe->nh_groups[i].weight + 1);
 
 		close_json_object();
 	}
@@ -254,15 +255,13 @@ static const char *nh_group_type_name(__u16 type)
 	}
 }
 
-static void print_nh_group_type(FILE *fp, const struct rtattr *grp_type_attr)
+static void print_nh_group_type(__u16 nh_grp_type)
 {
-	__u16 type = rta_getattr_u16(grp_type_attr);
-
-	if (type == NEXTHOP_GRP_TYPE_MPATH)
+	if (nh_grp_type == NEXTHOP_GRP_TYPE_MPATH)
 		/* Do not print type in order not to break existing output. */
 		return;
 
-	print_string(PRINT_ANY, "type", "type %s ", nh_group_type_name(type));
+	print_string(PRINT_ANY, "type", "type %s ", nh_group_type_name(nh_grp_type));
 }
 
 static void parse_nh_res_group_rta(const struct rtattr *res_grp_attr,
@@ -340,12 +339,104 @@ static void print_nh_res_bucket(FILE *fp, const struct rtattr *res_bucket_attr)
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
+			err = -EINVAL;
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
+			err = -ENOMEM;
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
+			err = -EINVAL;
+			goto out_err;
+		}
+
+		nhe->nh_groups = malloc(RTA_PAYLOAD(tb[NHA_GROUP]));
+		if (!nhe->nh_groups) {
+			err = -ENOMEM;
+			goto out_err;
+		}
+		nhe->nh_groups_cnt = RTA_PAYLOAD(tb[NHA_GROUP]) /
+				     sizeof(struct nexthop_grp);
+		memcpy(nhe->nh_groups, RTA_DATA(tb[NHA_GROUP]),
+		       RTA_PAYLOAD(tb[NHA_GROUP]));
+	}
+
+	if (tb[NHA_RES_GROUP]) {
+		parse_nh_res_group_rta(tb[NHA_RES_GROUP], &nhe->nh_res_grp);
+		nhe->nh_has_res_grp = true;
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
-	struct rtattr *tb[NHA_MAX+1];
 	FILE *fp = (FILE *)arg;
-	int len;
+	struct nh_entry nhe;
+	int len, err;
 
 	SPRINT_BUF(b1);
 
@@ -366,60 +457,61 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (filter.proto && filter.proto != nhm->nh_protocol)
 		return 0;
 
-	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
-
+	err = ipnh_parse_nhmsg(fp, nhm, len, &nhe);
+	if (err) {
+		close_json_object();
+		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(-err));
+		return -1;
+	}
 	open_json_object(NULL);
 
 	if (n->nlmsg_type == RTM_DELNEXTHOP)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
 
-	if (tb[NHA_ID])
-		print_uint(PRINT_ANY, "id", "id %u ",
-			   rta_getattr_u32(tb[NHA_ID]));
+	print_uint(PRINT_ANY, "id", "id %u ", nhe.nh_id);
 
-	if (tb[NHA_GROUP])
-		print_nh_group(fp, tb[NHA_GROUP]);
+	if (nhe.nh_groups)
+		print_nh_group(&nhe);
 
-	if (tb[NHA_GROUP_TYPE])
-		print_nh_group_type(fp, tb[NHA_GROUP_TYPE]);
+	print_nh_group_type(nhe.nh_grp_type);
 
-	if (tb[NHA_RES_GROUP]) {
-		struct nha_res_grp res_grp;
+	if (nhe.nh_has_res_grp)
+		print_nh_res_group(&nhe.nh_res_grp);
 
-		parse_nh_res_group_rta(tb[NHA_RES_GROUP], &res_grp);
-		print_nh_res_group(&res_grp);
-	}
+	if (nhe.nh_encap)
+		lwt_print_encap(fp, &nhe.nh_encap_type.rta, nhe.nh_encap);
 
-	if (tb[NHA_ENCAP])
-		lwt_print_encap(fp, tb[NHA_ENCAP_TYPE], tb[NHA_ENCAP]);
+	if (nhe.nh_gateway_len)
+		__print_rta_gateway(fp, nhe.nh_family,
+				    format_host(nhe.nh_family,
+				    nhe.nh_gateway_len,
+				    &nhe.nh_gateway));
 
-	if (tb[NHA_GATEWAY])
-		print_rta_gateway(fp, nhm->nh_family, tb[NHA_GATEWAY]);
+	if (nhe.nh_oif)
+		print_rta_ifidx(fp, nhe.nh_oif, "dev");
 
-	if (tb[NHA_OIF])
-		print_rta_ifidx(fp, rta_getattr_u32(tb[NHA_OIF]), "dev");
-
-	if (nhm->nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
+	if (nhe.nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
 		print_string(PRINT_ANY, "scope", "scope %s ",
-			     rtnl_rtscope_n2a(nhm->nh_scope, b1, sizeof(b1)));
+			     rtnl_rtscope_n2a(nhe.nh_scope, b1, sizeof(b1)));
 	}
 
-	if (tb[NHA_BLACKHOLE])
+	if (nhe.nh_blackhole)
 		print_null(PRINT_ANY, "blackhole", "blackhole ", NULL);
 
-	if (nhm->nh_protocol != RTPROT_UNSPEC || show_details > 0) {
+	if (nhe.nh_protocol != RTPROT_UNSPEC || show_details > 0) {
 		print_string(PRINT_ANY, "protocol", "proto %s ",
-			     rtnl_rtprot_n2a(nhm->nh_protocol, b1, sizeof(b1)));
+			     rtnl_rtprot_n2a(nhe.nh_protocol, b1, sizeof(b1)));
 	}
 
-	print_rt_flags(fp, nhm->nh_flags);
+	print_rt_flags(fp, nhe.nh_flags);
 
-	if (tb[NHA_FDB])
+	if (nhe.nh_fdb)
 		print_null(PRINT_ANY, "fdb", "fdb", NULL);
 
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	close_json_object();
 	fflush(fp);
+	ipnh_destroy_entry(&nhe);
 
 	return 0;
 }
-- 
2.31.1

