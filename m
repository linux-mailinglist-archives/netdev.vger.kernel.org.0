Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5018C41D8FC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350631AbhI3Lle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350565AbhI3Ll1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527E1C06177B
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bd28so20768634edb.9
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wJO5oPftinL12JBvf/5XpcqwmvPfZ919ITvh8uqRXRk=;
        b=2Y/zjZWSDfT0/f58BorM2T5rijLq9g66eO2SSTtiiI6+ifmF/cy7Bmy7F8bWvb+aqg
         d9rksMx6cWJi5umhik442WC5gLgcXhF+Thfa0BxDVA5SD+HzkoyCuoFpGgxjJanbRqCz
         ITSeHEl/5r+x4vtft2Y1EWgtwasLAeOnqDLSYz4sQzVajYQvD5TlxpqhwuqQcLnxSsZT
         ieLaY2WjMVhbZu7c//E473OADJXondlmIQxzk2989wI/pajdj/UruA2VZaQl+74+HZ9F
         KjRLlm8hx3LOC2xE7YBJGzJbYyoIK3aja8d1aEJphv7cLmVq0iM0l2bdLap5eR6gWyri
         0BbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wJO5oPftinL12JBvf/5XpcqwmvPfZ919ITvh8uqRXRk=;
        b=TAdAYIBt75g8sPfHid6VqUwtNf3/35P9wUncW55QQB144ip3IwwC5MN/f8cwukXS/H
         OVmwHN4QSNwEzJNSMevhA0ambbiQuzZmRBZnKrjlnhqgw8wgz+fUEN7ijpyR8W+88K6D
         U4AAm0roSVAgHOsqQIhg8umHzgbG+t8DV2HurZANHVfOCjKCKPo1Jsho5WOZvvm0h+Oi
         sUmF9g2fLBFGx/X/Obmi+Z3TtZMREpUy/U0mjC8jAWGTQ6q4VyfarRkKdlOOSRcOEGSW
         qflaMWNq8xoVDBBBBlCCOK/1LbwmdaH5c9phDuMke5zmXn8cwafYnAYYPIorWuTpcCDg
         1wxw==
X-Gm-Message-State: AOAM530AtrnLVIJj+0cZOjNEyd65/USVW0t3kLPz3ISBoob+6kjhbhr/
        faJNlCQJzeQsKW40HzPCLvP1pX2b31KnF5TK
X-Google-Smtp-Source: ABdhPJxa84K3hTGg/sVs9coQDZ97IgBtlgH9Omk/GSGWTEWRlEk1yBXjbhzeF8ttZLIfgSSb7hzNIA==
X-Received: by 2002:a50:da48:: with SMTP id a8mr6310954edk.155.1633001974606;
        Thu, 30 Sep 2021 04:39:34 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:34 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 12/12] ip: nexthop: add print_cache_nexthop which prints and manages the nh cache
Date:   Thu, 30 Sep 2021 14:38:44 +0300
Message-Id: <20210930113844.1829373-13-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
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
index 31462c57d299..b4d44a86429c 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -602,6 +602,42 @@ static void ipnh_cache_del(struct nh_entry *nhe)
 	free(nhe);
 }
 
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
 void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
 			    __u32 nh_id)
 {
@@ -618,7 +654,7 @@ void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
 	__print_nexthop_entry(fp, jsobj, nhe, false);
 }
 
-int print_nexthop(struct nlmsghdr *n, void *arg)
+int print_cache_nexthop(struct nlmsghdr *n, void *arg, bool process_cache)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
 	FILE *fp = (FILE *)arg;
@@ -651,11 +687,20 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
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
 int print_nexthop_bucket(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
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
index b448f1b5530b..4d6677e62e33 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -48,5 +48,6 @@ struct nh_entry {
 
 void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
 			    __u32 nh_id);
+int print_cache_nexthop(struct nlmsghdr *n, void *arg, bool process_cache);
 
 #endif /* __NH_COMMON_H__ */
-- 
2.31.1

