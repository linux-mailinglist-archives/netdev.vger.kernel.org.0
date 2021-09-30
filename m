Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C68741D8F4
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350573AbhI3LlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350546AbhI3LlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34134C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:29 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id dj4so21371517edb.5
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XYvV0L1uHbDbInpFf1SHlMgNFXX7h4Ao7TwGFHRSCDs=;
        b=qZc13XjtQwbdfSO9dvJ/Zi+ajD/psY1uX8bTjZkQhSUKsskxFGp1kYlgwgx6P1xbm2
         qMu+gZubETfwjtxTAAc6bYOQ9BGk4jXuFN++pwPBW/anGpq1FtwpExSxJ+9eL2FMuyZt
         R1BByBf4GMhLA4typ32F8bccvFIy3rwDH2LUWU6Q/f3qnokJii4yiWac/vhvhCWksQ9S
         4D+raOkOc3QHlySSFSUwOsGaXs6QsjObPmx8hAZof006wxeOLrstwlTCM8PaMsDQf1ed
         fwgFFthSwGsZX4MO0JB/VeXM62zZDdoSONqaKiziWRoVnCnOufMYfm8X1curjaisGp9M
         gL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XYvV0L1uHbDbInpFf1SHlMgNFXX7h4Ao7TwGFHRSCDs=;
        b=cYwPPkHDJROT21J7pDpCGSNhSPWqCeRj0ke3Z4Wfd5Wgovs+eV7UCYObysGyG96wQS
         1cr0N4jlCvAhQ3/z9mZLFg1GEoW+pekzMxX0j0GUEG1BRWvYA0e3LM5lZxSPeRaDOdBB
         sbf/XkN05sncXP0DcCBT05xqV8d46m+huhWnBCTBmTyZmUttl9sgISwhCM/6JJGLivOF
         wxb8+jyQb0JLq4i80bYMWMfAXv+OtBh6/DNk2FiHcyfRM/9LE0hFUv2AsuvR1n2kfx3w
         Q+QCXW2C8q1aB2rcoZrlqIrnZplBrNT+gp/m19sJjJS5N0zzu5V6EmdOTvBfDIoqvtZM
         V9VQ==
X-Gm-Message-State: AOAM5306VUj09wj4a0B7mpNwUAOGPkeFWnhC9RS1C5rq8kjr+KFnwq4n
        0GzMcrlJZz33gL3+LWyb9SHqPHyjlRUhzzHm
X-Google-Smtp-Source: ABdhPJxt+9q54wqdGfEtcuw41Q06Db3nQzdS/t4rOxZr/7mFzk+YI1NiIQAkJMJPuz4b1z7T1lJrFw==
X-Received: by 2002:a17:907:e91:: with SMTP id ho17mr6259205ejc.287.1633001967450;
        Thu, 30 Sep 2021 04:39:27 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:27 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 04/12] ip: nexthop: split print_nh_res_group into parse and print parts
Date:   Thu, 30 Sep 2021 14:38:36 +0300
Message-Id: <20210930113844.1829373-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Now that we have resilient group structure split print_nh_res_group into
a parse and print functions, print_nexthop calls the parse function
first to parse the attributes into the structure and then uses the print
function to print the parsed structure.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 48 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index a4048d803325..7094d6cbb5e6 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -13,6 +13,7 @@
 
 #include "utils.h"
 #include "ip_common.h"
+#include "nh_common.h"
 
 static struct {
 	unsigned int flushed;
@@ -264,39 +265,50 @@ static void print_nh_group_type(FILE *fp, const struct rtattr *grp_type_attr)
 	print_string(PRINT_ANY, "type", "type %s ", nh_group_type_name(type));
 }
 
-static void print_nh_res_group(FILE *fp, const struct rtattr *res_grp_attr)
+static void parse_nh_res_group_rta(const struct rtattr *res_grp_attr,
+				   struct nha_res_grp *res_grp)
 {
 	struct rtattr *tb[NHA_RES_GROUP_MAX + 1];
 	struct rtattr *rta;
-	struct timeval tv;
 
+	memset(res_grp, 0, sizeof(*res_grp));
 	parse_rtattr_nested(tb, NHA_RES_GROUP_MAX, res_grp_attr);
 
-	open_json_object("resilient_args");
-
 	if (tb[NHA_RES_GROUP_BUCKETS])
-		print_uint(PRINT_ANY, "buckets", "buckets %u ",
-			   rta_getattr_u16(tb[NHA_RES_GROUP_BUCKETS]));
+		res_grp->buckets = rta_getattr_u16(tb[NHA_RES_GROUP_BUCKETS]);
 
 	if (tb[NHA_RES_GROUP_IDLE_TIMER]) {
 		rta = tb[NHA_RES_GROUP_IDLE_TIMER];
-		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
-		print_tv(PRINT_ANY, "idle_timer", "idle_timer %g ", &tv);
+		res_grp->idle_timer = rta_getattr_u32(rta);
 	}
 
 	if (tb[NHA_RES_GROUP_UNBALANCED_TIMER]) {
 		rta = tb[NHA_RES_GROUP_UNBALANCED_TIMER];
-		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
-		print_tv(PRINT_ANY, "unbalanced_timer", "unbalanced_timer %g ",
-			 &tv);
+		res_grp->unbalanced_timer = rta_getattr_u32(rta);
 	}
 
 	if (tb[NHA_RES_GROUP_UNBALANCED_TIME]) {
 		rta = tb[NHA_RES_GROUP_UNBALANCED_TIME];
-		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
-		print_tv(PRINT_ANY, "unbalanced_time", "unbalanced_time %g ",
-			 &tv);
+		res_grp->unbalanced_time = rta_getattr_u64(rta);
 	}
+}
+
+static void print_nh_res_group(const struct nha_res_grp *res_grp)
+{
+	struct timeval tv;
+
+	open_json_object("resilient_args");
+
+	print_uint(PRINT_ANY, "buckets", "buckets %u ", res_grp->buckets);
+
+	 __jiffies_to_tv(&tv, res_grp->idle_timer);
+	print_tv(PRINT_ANY, "idle_timer", "idle_timer %g ", &tv);
+
+	__jiffies_to_tv(&tv, res_grp->unbalanced_timer);
+	print_tv(PRINT_ANY, "unbalanced_timer", "unbalanced_timer %g ", &tv);
+
+	__jiffies_to_tv(&tv, res_grp->unbalanced_time);
+	print_tv(PRINT_ANY, "unbalanced_time", "unbalanced_time %g ", &tv);
 
 	close_json_object();
 }
@@ -371,8 +383,12 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (tb[NHA_GROUP_TYPE])
 		print_nh_group_type(fp, tb[NHA_GROUP_TYPE]);
 
-	if (tb[NHA_RES_GROUP])
-		print_nh_res_group(fp, tb[NHA_RES_GROUP]);
+	if (tb[NHA_RES_GROUP]) {
+		struct nha_res_grp res_grp;
+
+		parse_nh_res_group_rta(tb[NHA_RES_GROUP], &res_grp);
+		print_nh_res_group(&res_grp);
+	}
 
 	if (tb[NHA_ENCAP])
 		lwt_print_encap(fp, tb[NHA_ENCAP_TYPE], tb[NHA_ENCAP]);
-- 
2.31.1

