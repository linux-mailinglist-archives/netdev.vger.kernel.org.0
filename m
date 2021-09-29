Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89A041C86A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345320AbhI2Pbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345310AbhI2Pbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A6FC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:53 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id dj4so10525855edb.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t8pP26/7fb5Wq+dpeoArozy4Jca0fDg3x4MgpY2CvXY=;
        b=w1dP7KQsV+0AZQp0DZAVlJ0jJ5clsLTFD5g2mjiy3f7J3suDb+Th1UOCHOb9KbIAZS
         g1ves4JPO74hBF8f9jfq3EiTDj12S+GE2PpKnWe6M+pUrqL8wjJbj/arAY80Qi1XPY7U
         nNNSZtq2uUeYZ5HbSziH3bRFxviLNEcXTMD3zD50tZT++jxxf5csd60fJedy2Qi9zl34
         L/jaC6jRGTjhyUJZcokGvFExWBY1o8MCXQhOn7prNoA29ry12lu9PfuJasN+GU+JWwqs
         PFSGY31URbA/PHiAu2MqtF1Tf7u91PzzIGRTz2jLLXv3oPkrY0hAkwBVQdTFtJukN7c+
         +sXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t8pP26/7fb5Wq+dpeoArozy4Jca0fDg3x4MgpY2CvXY=;
        b=4vj0XLbg3X0C6FHS42Dl2wmGMKkcpyGVcAVj0KQmduN8KucINjVmvEE05oADp5OHSO
         kL3g3WKG3D6+gs/FriyAN1BfP9OK0oJd9hXUos68m3JaIeWe8o1BhA3EotXTnjLVX5zT
         omXGXmpVrjy704FRrKu6qkZMnQ7RabLpzUsaUvtPCOTuw4tZ49ova0imL8k5dkGDcfFE
         9Bsf+f7zBdshwGFYP1Y0niD5Px464Ntk27+YEDBkimsGG7dA64KExh/gFRuXZ+V+lI4j
         fWnAlRxAqHRyqlmBR8R4guoGldH3Qer6mTgoc4nAtGNu+8DBIXRnlTY0ns/aiTtrVBPN
         YC8g==
X-Gm-Message-State: AOAM533ozANULmtOcnEx0kmUhe03mvd5z0Iik0FLqV+QXcQ/91OXKUI0
        U7eJi+uctjSwZz0DzBuwUXtMJxMStNSO/+ys
X-Google-Smtp-Source: ABdhPJw8s24H0nJhtp72jqVkDQvgwQu2EK6pZgTHTDX53e+EeYpyM6EiQ+eu6NEL2OIrMOpDOR5AEg==
X-Received: by 2002:a05:6402:16d8:: with SMTP id r24mr562317edx.47.1632929345861;
        Wed, 29 Sep 2021 08:29:05 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:29:05 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 11/11] ip: nexthop: add print_cache_nexthop which prints and manages the nh cache
Date:   Wed, 29 Sep 2021 18:28:48 +0300
Message-Id: <20210929152848.1710552-12-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a new helper print_cache_nexthop replacing print_nexthop which can
update the nexthop cache if the process_cache argument is true. It is
used when monitoring netlink messages to keep the nexthop cache up to
date with nexthop changes happening. For the old callers and anyone
who's just dumping nexthops its _nocache version is used which is a
wrapper for print_cache_nexthop.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ip_common.h |  1 -
 ip/ipmonitor.c |  3 ++-
 ip/ipnexthop.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++----
 ip/nh_common.h |  1 +
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index a02a3b96f7fd..ea04c8ff3dea 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -53,7 +53,6 @@ int print_prefix(struct nlmsghdr *n, void *arg);
 int print_rule(struct nlmsghdr *n, void *arg);
 int print_netconf(struct rtnl_ctrl_data *ctrl,
 		  struct nlmsghdr *n, void *arg);
-int print_nexthop(struct nlmsghdr *n, void *arg);
 int print_nexthop_bucket(struct nlmsghdr *n, void *arg);
 void netns_map_init(void);
 void netns_nsid_socket_init(void);
diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index ab1af2ebd6df..0badda4e7812 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -22,6 +22,7 @@
 
 #include "utils.h"
 #include "ip_common.h"
+#include "nh_common.h"
 
 static void usage(void) __attribute__((noreturn));
 static int prefix_banner;
@@ -88,7 +89,7 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 	case RTM_NEWNEXTHOP:
 	case RTM_DELNEXTHOP:
 		print_headers(fp, "[NEXTHOP]", ctrl);
-		print_nexthop(n, arg);
+		print_cache_nexthop(n, arg, true);
 		return 0;
 
 	case RTM_NEWNEXTHOPBUCKET:
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index fdd0d0926630..43dc238c7725 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -602,7 +602,43 @@ static void __print_nexthop_entry(FILE *fp, const char *jsobj,
 	close_json_object();
 }
 
-int print_nexthop(struct nlmsghdr *n, void *arg)
+/* update, add or delete a nexthop entry based on nlmsghdr */
+static int ipnh_cache_process_nlmsg(const struct nlmsghdr *n,
+				    struct nh_entry *new_nhe)
+{
+	struct nh_entry *nhe;
+
+	nhe = ipnh_cache_get(new_nhe->nh_id);
+	switch (n->nlmsg_type) {
+	case RTM_DELNEXTHOP:
+		if (nhe)
+			ipnh_cache_del(nhe);
+		ipnh_destroy_entry(new_nhe);
+		break;
+	case RTM_NEWNEXTHOP:
+		if (!nhe) {
+			nhe = malloc(sizeof(*nhe));
+			if (!nhe) {
+				ipnh_destroy_entry(new_nhe);
+				return -1;
+			}
+		} else {
+			/* this allows us to save 1 allocation on updates by
+			 * reusing the old nh entry, but we need to cleanup its
+			 * internal storage
+			 */
+			ipnh_cache_unlink_entry(nhe);
+			ipnh_destroy_entry(nhe);
+		}
+		memcpy(nhe, new_nhe, sizeof(*nhe));
+		ipnh_cache_link_entry(nhe);
+		break;
+	}
+
+	return 0;
+}
+
+int print_cache_nexthop(struct nlmsghdr *n, void *arg, bool process_cache)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
 	FILE *fp = (FILE *)arg;
@@ -635,11 +671,20 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	__print_nexthop_entry(fp, NULL, &nhe, n->nlmsg_type == RTM_DELNEXTHOP);
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	fflush(fp);
-	ipnh_destroy_entry(&nhe);
+
+	if (process_cache)
+		ipnh_cache_process_nlmsg(n, &nhe);
+	else
+		ipnh_destroy_entry(&nhe);
 
 	return 0;
 }
 
+static int print_nexthop_nocache(struct nlmsghdr *n, void *arg)
+{
+	return print_cache_nexthop(n, arg, false);
+}
+
 void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
 			    __u32 nh_id)
 {
@@ -967,7 +1012,7 @@ static int ipnh_get_id(__u32 id)
 
 	new_json_obj(json);
 
-	if (print_nexthop(answer, (void *)stdout) < 0) {
+	if (print_nexthop_nocache(answer, (void *)stdout) < 0) {
 		free(answer);
 		return -1;
 	}
@@ -1052,7 +1097,7 @@ static int ipnh_list_flush(int argc, char **argv, int action)
 
 	new_json_obj(json);
 
-	if (rtnl_dump_filter(&rth, print_nexthop, stdout) < 0) {
+	if (rtnl_dump_filter(&rth, print_nexthop_nocache, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
 		return -2;
 	}
diff --git a/ip/nh_common.h b/ip/nh_common.h
index a672d658a9ea..2ad8b134f891 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -48,5 +48,6 @@ struct nh_entry {
 
 void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
 			    __u32 nh_id);
+int print_cache_nexthop(struct nlmsghdr *n, void *arg, bool process_cache);
 
 #endif /* __NH_COMMON_H__ */
-- 
2.31.1

