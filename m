Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9F541D8F2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350532AbhI3LlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350531AbhI3LlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CC2C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:26 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g7so20814773edv.1
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EE38NogxNtaKTmKp2iIN72gRdSeWsh1uBV6CKHtm1Ls=;
        b=fRlfhMNcAPDAO0dQu+cgQV57tXluBTj2+du1H2IdIJujIORYA96akpqPif5YRnt7ld
         NUUgLFDvfR2+/eS/p/mtPHyNWedrJDUg4aomRMwvH8DL5U5phReSogpM8ylnB4357csb
         LeuhssLFr6mTi0OCgo0AQ4LcqJDQF5favtUGYCUQQWpvwqQQs25ypIFJybmx6k5EER6S
         Ozf6AIU+X2M9Aan8z7FHhDiZMvI2WKtS+tyqJqT5PGSCesOO8vsmwum8FKqp/L0xJU9a
         vg1C5qw+QoHZ4OYZV1bmkY46PjH0NPWwGT60+l2HTp2QitfPTadsQIeWUOPxIVx92A2/
         FFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EE38NogxNtaKTmKp2iIN72gRdSeWsh1uBV6CKHtm1Ls=;
        b=qdO9XNHeys6ldH4wiss6AD7SJ/5wQ6hgno6qug+0TNRoVErkX3x1viG2tEwwEk9bcv
         Ooj+slLTiTfTlTcbHqpl8L6SGBg7rKRtC6Oa0yMdeGd2Nl/U8YH+nF8vFjcxW4/jge5c
         5yN8ce/KHRmzbrK+Akwi4fI4z8vbB+UR/1V04Q34qZYsFPtFVi1llyTK8mv8ShW5MeF6
         iCZ6knpou+E2Xlv8fSovKwJ9cjcPkq2+SHGhndwYcbxEI0F8wJIoXUT2tITMSo2foHAc
         Qqw0oDttPR/MPN0bNLmrDIaFbrErk5lr40FcfxllknWxj0V7Zdermmv61vS4jcOU6VCR
         Ih3A==
X-Gm-Message-State: AOAM533pI13X4+8kuWKvMvHtGqTeCu01+LZyUxHm4LLt/D6yt4n2wZ1G
        2T5SOFsCZt/TRalLcOSE76cZJn2Japbu/gZp
X-Google-Smtp-Source: ABdhPJxHl+Ae0MeTzD8q1cM5lA6i58tlGshZed9OejdBxMSQYZwbxqa7oairhl4pipor37oadSrVKw==
X-Received: by 2002:a17:906:c005:: with SMTP id e5mr6007140ejz.480.1633001964618;
        Thu, 30 Sep 2021 04:39:24 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:24 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 01/12] ip: print_rta_if takes ifindex as device argument instead of attribute
Date:   Thu, 30 Sep 2021 14:38:33 +0300
Message-Id: <20210930113844.1829373-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need print_rta_if() to take ifindex directly so later we can use it
with cached converted nexthop objects.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ip_common.h |  2 +-
 ip/ipnexthop.c |  2 +-
 ip/iproute.c   | 12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index ad018183eac0..d3d50cbca74d 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -168,7 +168,7 @@ int name_is_vrf(const char *name);
 
 void print_num(FILE *fp, unsigned int width, uint64_t count);
 void print_rt_flags(FILE *fp, unsigned int flags);
-void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix);
+void print_rta_ifidx(FILE *fp, __u32 ifidx, const char *prefix);
 void print_rta_gateway(FILE *fp, unsigned char family,
 		       const struct rtattr *rta);
 #endif /* _IP_COMMON_H_ */
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 9478aa5298eb..a4048d803325 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -381,7 +381,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 		print_rta_gateway(fp, nhm->nh_family, tb[NHA_GATEWAY]);
 
 	if (tb[NHA_OIF])
-		print_rta_if(fp, tb[NHA_OIF], "dev");
+		print_rta_ifidx(fp, rta_getattr_u32(tb[NHA_OIF]), "dev");
 
 	if (nhm->nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
 		print_string(PRINT_ANY, "scope", "scope %s ",
diff --git a/ip/iproute.c b/ip/iproute.c
index 1e5e2002d2ed..f2bf4737b958 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -410,13 +410,13 @@ static void print_rt_pref(FILE *fp, unsigned int pref)
 	}
 }
 
-void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix)
+void print_rta_ifidx(FILE *fp, __u32 ifidx, const char *prefix)
 {
-	const char *ifname = ll_index_to_name(rta_getattr_u32(rta));
+	const char *ifname = ll_index_to_name(ifidx);
 
-	if (is_json_context())
+	if (is_json_context()) {
 		print_string(PRINT_JSON, prefix, NULL, ifname);
-	else {
+	} else {
 		fprintf(fp, "%s ", prefix);
 		color_fprintf(fp, COLOR_IFNAME, "%s ", ifname);
 	}
@@ -862,7 +862,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 		print_rta_via(fp, tb[RTA_VIA]);
 
 	if (tb[RTA_OIF] && filter.oifmask != -1)
-		print_rta_if(fp, tb[RTA_OIF], "dev");
+		print_rta_ifidx(fp, rta_getattr_u32(tb[RTA_OIF]), "dev");
 
 	if (table && (table != RT_TABLE_MAIN || show_details > 0) && !filter.tb)
 		print_string(PRINT_ANY,
@@ -946,7 +946,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 		print_rta_metrics(fp, tb[RTA_METRICS]);
 
 	if (tb[RTA_IIF] && filter.iifmask != -1)
-		print_rta_if(fp, tb[RTA_IIF], "iif");
+		print_rta_ifidx(fp, rta_getattr_u32(tb[RTA_IIF]), "iif");
 
 	if (tb[RTA_PREF])
 		print_rt_pref(fp, rta_getattr_u8(tb[RTA_PREF]));
-- 
2.31.1

