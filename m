Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A733141D8F7
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350589AbhI3LlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350557AbhI3LlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:14 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D901EC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:31 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b26so21119559edt.0
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vI94Rz9w3cwEX8AnqfIcA0ZYpgtmdoARIPrkq5Dkh3c=;
        b=IiWjTqyxmf04XtloLnhZdOhdo6OiWEPYzQ7cYvy9sDLkRE+gw7mDMbMR8qOFZFC6Jp
         GxyUjXqmUJyJ4kYlle9wVg8AuYk1E1Q0s0RWE6BjLSVsEwCBtDTeQGkHGbdfbT+JH8cT
         GrGUoOGIEuHEQalKApFvy3jDM/4z0jS9bPGZxPFVN6rA4Xe+YnLkPbaNxEFba+qFLYPZ
         p+SIF7VSlEKYPkS9n/SbEnvlwekRFT/ifRVRfFvJBMTk2HpYxSXE1B1DALA+uIlyh4Ml
         /BvF1YbU8ZB47sEgG9Jl61R0+8bpz6wtVbDmiOxq1MFcY9CgEuivTGU52NwBw5zlOVQO
         WW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vI94Rz9w3cwEX8AnqfIcA0ZYpgtmdoARIPrkq5Dkh3c=;
        b=y/TnmPb/zudEUhM/m/3TDhwXZYtHbWP9kM4FvMjF+ksK9lkRzCHUn38k2OyhQOjWhf
         bGcrLFXd2uLjhTwUzCGLJ+r254jrfkLiFE8C7gowztYFPCY45oFMesJ3azncSKww4ZEV
         m5qB0ZCAi1mOpmW858jtczcqc1WdZit/le/SKVuYO6GdSm5vUE/zFDPunEx8vTawFsEY
         hCyLQx5ITR7doN/VgaXd+KWO73NfqGttxXbh1hdTRxRSW6XsSNK9mGbkWoLDW1B4k4da
         k1yQHOqSA+7uzH/bB2677De5RYzmlYfhXpjYSGTDJmhpqNTs/9R0LbOtGGNNHTrEZJFk
         RWww==
X-Gm-Message-State: AOAM531yUPet7nPoa7dVrm2Qvu9QnhZGPOEqx2/23+hE5Rur8oRz7tnf
        pIV5Em5KzsBnj+At1pJMKvpwk5Jzj2zV0ZtA
X-Google-Smtp-Source: ABdhPJxeeBIJI/UiGqgKfvGZuAjeybMxDAXfs3Bc5+SRs6QNnmF0yUjekPt+DOtr/iA4397DrEGSXg==
X-Received: by 2002:a17:906:7ce:: with SMTP id m14mr84157ejc.192.1633001970222;
        Thu, 30 Sep 2021 04:39:30 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:29 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 07/12] ip: nexthop: factor out print_nexthop's nh entry printing
Date:   Thu, 30 Sep 2021 14:38:39 +0300
Message-Id: <20210930113844.1829373-8-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out nexthop entry structure printing from print_nexthop,
effectively splitting it into parse and print parts.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 103 ++++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 48 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 0edb3c265b6f..a589febca605 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -431,6 +431,60 @@ out_err:
 	return err;
 }
 
+static void __print_nexthop_entry(FILE *fp, const char *jsobj,
+				  struct nh_entry *nhe,
+				  bool deleted)
+{
+	SPRINT_BUF(b1);
+
+	open_json_object(jsobj);
+
+	if (deleted)
+		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
+
+	print_uint(PRINT_ANY, "id", "id %u ", nhe->nh_id);
+
+	if (nhe->nh_groups)
+		print_nh_group(nhe);
+
+	print_nh_group_type(nhe->nh_grp_type);
+
+	if (nhe->nh_has_res_grp)
+		print_nh_res_group(&nhe->nh_res_grp);
+
+	if (nhe->nh_encap)
+		lwt_print_encap(fp, &nhe->nh_encap_type.rta, nhe->nh_encap);
+
+	if (nhe->nh_gateway_len)
+		__print_rta_gateway(fp, nhe->nh_family,
+				    format_host(nhe->nh_family,
+				    nhe->nh_gateway_len,
+				    &nhe->nh_gateway));
+
+	if (nhe->nh_oif)
+		print_rta_ifidx(fp, nhe->nh_oif, "dev");
+
+	if (nhe->nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
+		print_string(PRINT_ANY, "scope", "scope %s ",
+			     rtnl_rtscope_n2a(nhe->nh_scope, b1, sizeof(b1)));
+	}
+
+	if (nhe->nh_blackhole)
+		print_null(PRINT_ANY, "blackhole", "blackhole ", NULL);
+
+	if (nhe->nh_protocol != RTPROT_UNSPEC || show_details > 0) {
+		print_string(PRINT_ANY, "protocol", "proto %s ",
+			     rtnl_rtprot_n2a(nhe->nh_protocol, b1, sizeof(b1)));
+	}
+
+	print_rt_flags(fp, nhe->nh_flags);
+
+	if (nhe->nh_fdb)
+		print_null(PRINT_ANY, "fdb", "fdb", NULL);
+
+	close_json_object();
+}
+
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
@@ -438,8 +492,6 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	struct nh_entry nhe;
 	int len, err;
 
-	SPRINT_BUF(b1);
-
 	if (n->nlmsg_type != RTM_DELNEXTHOP &&
 	    n->nlmsg_type != RTM_NEWNEXTHOP) {
 		fprintf(stderr, "Not a nexthop: %08x %08x %08x\n",
@@ -463,53 +515,8 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(-err));
 		return -1;
 	}
-	open_json_object(NULL);
-
-	if (n->nlmsg_type == RTM_DELNEXTHOP)
-		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
-
-	print_uint(PRINT_ANY, "id", "id %u ", nhe.nh_id);
-
-	if (nhe.nh_groups)
-		print_nh_group(&nhe);
-
-	print_nh_group_type(nhe.nh_grp_type);
-
-	if (nhe.nh_has_res_grp)
-		print_nh_res_group(&nhe.nh_res_grp);
-
-	if (nhe.nh_encap)
-		lwt_print_encap(fp, &nhe.nh_encap_type.rta, nhe.nh_encap);
-
-	if (nhe.nh_gateway_len)
-		__print_rta_gateway(fp, nhe.nh_family,
-				    format_host(nhe.nh_family,
-				    nhe.nh_gateway_len,
-				    &nhe.nh_gateway));
-
-	if (nhe.nh_oif)
-		print_rta_ifidx(fp, nhe.nh_oif, "dev");
-
-	if (nhe.nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
-		print_string(PRINT_ANY, "scope", "scope %s ",
-			     rtnl_rtscope_n2a(nhe.nh_scope, b1, sizeof(b1)));
-	}
-
-	if (nhe.nh_blackhole)
-		print_null(PRINT_ANY, "blackhole", "blackhole ", NULL);
-
-	if (nhe.nh_protocol != RTPROT_UNSPEC || show_details > 0) {
-		print_string(PRINT_ANY, "protocol", "proto %s ",
-			     rtnl_rtprot_n2a(nhe.nh_protocol, b1, sizeof(b1)));
-	}
-
-	print_rt_flags(fp, nhe.nh_flags);
-
-	if (nhe.nh_fdb)
-		print_null(PRINT_ANY, "fdb", "fdb", NULL);
-
+	__print_nexthop_entry(fp, NULL, &nhe, n->nlmsg_type == RTM_DELNEXTHOP);
 	print_string(PRINT_FP, NULL, "%s", "\n");
-	close_json_object();
 	fflush(fp);
 	ipnh_destroy_entry(&nhe);
 
-- 
2.31.1

