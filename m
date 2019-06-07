Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DBE398FC
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbfFGWiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731757AbfFGWiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:20 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA76121473;
        Fri,  7 Jun 2019 22:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947100;
        bh=OG0wc8/oYDzywD85XBqx7O/FRwq7vk/0t/+gQ7NluxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGFf/FjZ1oONNu0csQNeAyGlmLzYXGWrx7SY2LwhjIr9wAt+qdHBKWxgE6Z5jsVDm
         n6jMr0V/UI0IKYzC26pPMqxxzQLRzF/+456hFgrK28k+fKLaGk4PUTLb/cSW739l2S
         cM571TqyVquiTFo1qHIyRtxhI2omAV9rChjxFGzI=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 06/10] ip route: Export print_rt_flags, print_rta_if and print_rta_gateway
Date:   Fri,  7 Jun 2019 15:38:12 -0700
Message-Id: <20190607223816.27512-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Export print_rt_flags and print_rta_if for use by the nexthop
command.

Change print_rta_gateway to take the family versus rtmsg struct and
export for use by the nexthop command.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/ip_common.h |  5 ++++-
 ip/iproute.c   | 17 ++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index df279e4f7b9a..3e8183e2c48c 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -156,5 +156,8 @@ int name_is_vrf(const char *name);
 #endif
 
 void print_num(FILE *fp, unsigned int width, uint64_t count);
-
+void print_rt_flags(FILE *fp, unsigned int flags);
+void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix);
+void print_rta_gateway(FILE *fp, unsigned char family,
+		       const struct rtattr *rta);
 #endif /* _IP_COMMON_H_ */
diff --git a/ip/iproute.c b/ip/iproute.c
index 440b1fc8b413..1c443265d479 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -349,7 +349,7 @@ static void print_rtax_features(FILE *fp, unsigned int features)
 			    "features", "%#llx ", of);
 }
 
-static void print_rt_flags(FILE *fp, unsigned int flags)
+void print_rt_flags(FILE *fp, unsigned int flags)
 {
 	open_json_array(PRINT_JSON,
 			is_json_context() ?  "flags" : "");
@@ -394,8 +394,7 @@ static void print_rt_pref(FILE *fp, unsigned int pref)
 	}
 }
 
-static void print_rta_if(FILE *fp, const struct rtattr *rta,
-			const char *prefix)
+void print_rta_if(FILE *fp, const struct rtattr *rta, const char *prefix)
 {
 	const char *ifname = ll_index_to_name(rta_getattr_u32(rta));
 
@@ -532,17 +531,16 @@ static void print_rta_newdst(FILE *fp, const struct rtmsg *r,
 	}
 }
 
-static void print_rta_gateway(FILE *fp, const struct rtmsg *r,
-			      const struct rtattr *rta)
+void print_rta_gateway(FILE *fp, unsigned char family, const struct rtattr *rta)
 {
-	const char *gateway = format_host_rta(r->rtm_family, rta);
+	const char *gateway = format_host_rta(family, rta);
 
 	if (is_json_context())
 		print_string(PRINT_JSON, "gateway", NULL, gateway);
 	else {
 		fprintf(fp, "via ");
 		print_color_string(PRINT_FP,
-				   ifa_family_color(r->rtm_family),
+				   ifa_family_color(family),
 				   NULL, "%s ", gateway);
 	}
 }
@@ -679,7 +677,8 @@ static void print_rta_multipath(FILE *fp, const struct rtmsg *r,
 			if (tb[RTA_NEWDST])
 				print_rta_newdst(fp, r, tb[RTA_NEWDST]);
 			if (tb[RTA_GATEWAY])
-				print_rta_gateway(fp, r, tb[RTA_GATEWAY]);
+				print_rta_gateway(fp, r->rtm_family,
+						  tb[RTA_GATEWAY]);
 			if (tb[RTA_VIA])
 				print_rta_via(fp, tb[RTA_VIA]);
 			if (tb[RTA_FLOW])
@@ -822,7 +821,7 @@ int print_route(struct nlmsghdr *n, void *arg)
 	}
 
 	if (tb[RTA_GATEWAY] && filter.rvia.bitlen != host_len)
-		print_rta_gateway(fp, r, tb[RTA_GATEWAY]);
+		print_rta_gateway(fp, r->rtm_family, tb[RTA_GATEWAY]);
 
 	if (tb[RTA_VIA])
 		print_rta_via(fp, tb[RTA_VIA]);
-- 
2.11.0

