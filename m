Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F28841C870
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345372AbhI2Pbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345323AbhI2Pbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:42 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA873C061765
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ba1so10223429edb.4
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iywxHLGLbQZJ2pqzj06yOx10EVmFHqmsnHs+I0KD2mw=;
        b=QxoIzQZP3CGImo8ESuMbOpEqN+njrknQFJRqJy6Dy5MLMlTgDbITT34bTUkLS4BoKY
         9Zpa6Xus8MuwsT/u5FBFRVo2DwgL2Os+zouEdA82zo8uJ6yRTmX6nv95RkG7WzocahOb
         N2yN674vqNJBGDSaNnGRCdUgmw6Mkso/8LpG2JOYpil2M2e00tKKc1hMoWJIrKYqOn4Q
         AUStEFxl7XKmXhfGvNZ+w/fBII4QpLTAog7VjwXtP1nM0KcmugWxfb9UgIa0owPlPkMf
         UvL/h8yu/4fUEop+j9VCYFxs5qiWzrED2+7Qghing/WZ0pv8b/k6jEbmRosaF0GihKmG
         S/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iywxHLGLbQZJ2pqzj06yOx10EVmFHqmsnHs+I0KD2mw=;
        b=XmlMp5cF9/m6zooWnxD10zo3Ko+SChePMhi6jnN3icgComPSfJr7tcHHDDidym7aRX
         8dGpqGyq+vNn+da9CRFOg4rqVXcWCKVrsyIIdxd/M+ahdPwk5ao3clYvxQ6swSc+lk75
         XdR0FBhhxdnSVKXZWgGhKhhoeFvpif4b9v7n42559qs/ieN7TPu/foGQYb9rXQNg2aPT
         1OTF5yGE5gNWuUFc56Cf/cjNZCRqRhEtYYc+FnsGIKMuqeaQDgENsVit1h4eJsKVZVvj
         Sv6BCmifQ2IRpHEdIj1EtDVh7VpDgbht5ZhB0XY7KbidE6edbiTlCNwth2wv/U0cz0FE
         yyzw==
X-Gm-Message-State: AOAM5316E7/AJK1NDqDZfhaB5KRtWCeBu9ZgAG31RbxU2gj5r1rga2qY
        nwSS++tdWwpwhK1hT86m1UmiE8/3/vQjw4MQ
X-Google-Smtp-Source: ABdhPJwKbDsD3dsiYUPUkkPvGS8eUXgw0ImVP+0rokAp0AkJIxjgjSZiMloYlOnYqSn8jb7rAf3+Ow==
X-Received: by 2002:a17:906:144e:: with SMTP id q14mr332891ejc.19.1632929341267;
        Wed, 29 Sep 2021 08:29:01 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:29:00 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 08/11] ip: nexthop: factor out entry printing
Date:   Wed, 29 Sep 2021 18:28:45 +0300
Message-Id: <20210929152848.1710552-9-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out nexthop entry printing into a separate function.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 103 ++++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 48 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 6e5ea47ac927..37b94d6702df 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -548,6 +548,60 @@ static void ipnh_cache_del(struct nh_entry *nhe)
 	free(nhe);
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
+						nhe->nh_gateway_len,
+						&nhe->nh_gateway));
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
@@ -555,8 +609,6 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	struct nh_entry nhe;
 	int len, err;
 
-	SPRINT_BUF(b1);
-
 	if (n->nlmsg_type != RTM_DELNEXTHOP &&
 	    n->nlmsg_type != RTM_NEWNEXTHOP) {
 		fprintf(stderr, "Not a nexthop: %08x %08x %08x\n",
@@ -580,53 +632,8 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
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
-						nhe.nh_gateway_len,
-						&nhe.nh_gateway));
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

