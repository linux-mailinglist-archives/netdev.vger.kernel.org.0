Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2341C86F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345355AbhI2Pbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345314AbhI2Pbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA78FC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r18so9980049edv.12
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tgN79BvesPKY6SwuQbLpQKODnpT+35wR9t+40IBfPbY=;
        b=iN3HoSZD1wmNYmGPPDoJNwNrLQ7tOUheDnwvqEmvykzs3zTnXikf0IlQlYI0N3gBj1
         G2B8dSqlvoI+wSbpaL/IOrUTsvEmE4REOAjXp33Y40UQyQjt7PWTTk4ucQyLahA7VfLR
         ot7Lu78Z4lNXfBZ8aiffQ81uA84ewLkBTsIbmoMSUAKH/xdEZpvrkhvHytctb6Omzf6i
         xX6BYZbb3Sb8Ejv5Qg5ATPgD0jerYQzTf/S8Tk7MhaZBc6WqwrEAYIImaYOSdoqGz89B
         q9Yi9Zu4JAVyoTZ72J0WhC/20Cx/Z42HQ1jaMwUQGZLUdSkFsm1UvU+dR99jlU2AMYKh
         EsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tgN79BvesPKY6SwuQbLpQKODnpT+35wR9t+40IBfPbY=;
        b=GqD2360uu8OO3hySc2QoYtM/v9+x/yxg9WTInCHorD/m6ils+zKXfEOUTIg5vnC6e8
         PiV75oWhV4hVucbP+eB08VFpYBU+KgoHPUgDpMkI50wa7rOhKPH32ZKDSw9i+zmbEm1z
         dK3EJSldH9ciqrbLkFeRsBrr4CWX43qri41dB+Mv8Oe4YC5P5dvX1VPq+gysPP87MVUb
         CgY6m2TCvu2cGZV16cguVaINx/uPBA2J3EnLUusXcZeEdMpVSOeiz+lyyY6kRuAUX6aS
         JWUPoU+8kiODqReqG3GPde48UpusQ7rn+GxFmJsW2HclKYJFTPTS4nskCo5IT5qMeBQM
         ZdmQ==
X-Gm-Message-State: AOAM531lP60XNM/49LsIs2gklLoHP9RTCv4BXQGgWQFkmy5GKkyxTopf
        PMSa3dLHRzXOBs3SuNWW4JVPSgE9/Wugksdp
X-Google-Smtp-Source: ABdhPJwl9CVd14MkBUo1H58daphPHlfNfU2jQCKud2GCJVPgZ+EDVDveDi8aZs6gU5Szb6x1jmbF+Q==
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr334079ejb.139.1632929340250;
        Wed, 29 Sep 2021 08:29:00 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:59 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 07/11] ip: nexthop: add cache helpers
Date:   Wed, 29 Sep 2021 18:28:44 +0300
Message-Id: <20210929152848.1710552-8-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a static nexthop cache in a hash with 1024 buckets and helpers to
manage it (link, unlink, find, add nexthop, del nexthop). Adding new
nexthops is done by creating a new rtnl handle and using it to retrieve
the nexthop so the helper is safe to use while already reading a
response (i.e. using the global rth).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 112 +++++++++++++++++++++++++++++++++++++++++++++----
 ip/nh_common.h |   6 +++
 2 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 0a08230fc278..6e5ea47ac927 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -34,6 +34,8 @@ enum {
 #define RTM_NHA(h)  ((struct rtattr *)(((char *)(h)) + \
 			NLMSG_ALIGN(sizeof(struct nhmsg))))
 
+static struct hlist_head nh_cache[NH_CACHE_SIZE];
+
 static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
@@ -347,6 +349,41 @@ static void ipnh_destroy_entry(struct nh_entry *nhe)
 		free(nhe->nh_groups);
 }
 
+static struct hlist_head *ipnh_cache_head(__u32 nh_id)
+{
+	nh_id ^= nh_id >> 20;
+	nh_id ^= nh_id >> 10;
+
+	return &nh_cache[nh_id % NH_CACHE_SIZE];
+}
+
+static void ipnh_cache_link_entry(struct nh_entry *nhe)
+{
+	struct hlist_head *head = ipnh_cache_head(nhe->nh_id);
+
+	hlist_add_head(&nhe->nh_hash, head);
+}
+
+static void ipnh_cache_unlink_entry(struct nh_entry *nhe)
+{
+	hlist_del(&nhe->nh_hash);
+}
+
+static struct nh_entry *ipnh_cache_get(__u32 nh_id)
+{
+	struct hlist_head *head = ipnh_cache_head(nh_id);
+	struct nh_entry *nhe;
+	struct hlist_node *n;
+
+	hlist_for_each(n, head) {
+		nhe = container_of(n, struct nh_entry, nh_hash);
+		if (nhe->nh_id == nh_id)
+			return nhe;
+	}
+
+	return NULL;
+}
+
 /* parse nhmsg into nexthop entry struct which must be destroyed by
  * ipnh_destroy_enty when it's not needed anymore
  */
@@ -372,7 +409,7 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
 		if (RTA_PAYLOAD(tb[NHA_GATEWAY]) > sizeof(nhe->nh_gateway)) {
 			fprintf(fp, "<nexthop id %u invalid gateway length %lu>\n",
 				nhe->nh_id, RTA_PAYLOAD(tb[NHA_GATEWAY]));
-			err = EINVAL;
+			err = -EINVAL;
 			goto out_err;
 		}
 		nhe->nh_gateway_len = RTA_PAYLOAD(tb[NHA_GATEWAY]);
@@ -383,7 +420,7 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
 	if (tb[NHA_ENCAP]) {
 		nhe->nh_encap = malloc(RTA_LENGTH(RTA_PAYLOAD(tb[NHA_ENCAP])));
 		if (!nhe->nh_encap) {
-			err = ENOMEM;
+			err = -ENOMEM;
 			goto out_err;
 		}
 		memcpy(nhe->nh_encap, tb[NHA_ENCAP],
@@ -396,13 +433,13 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
 		if (!__valid_nh_group_attr(tb[NHA_GROUP])) {
 			fprintf(fp, "<nexthop id %u invalid nexthop group>",
 				nhe->nh_id);
-			err = EINVAL;
+			err = -EINVAL;
 			goto out_err;
 		}
 
 		nhe->nh_groups = malloc(RTA_PAYLOAD(tb[NHA_GROUP]));
 		if (!nhe->nh_groups) {
-			err = ENOMEM;
+			err = -ENOMEM;
 			goto out_err;
 		}
 		nhe->nh_groups_cnt = RTA_PAYLOAD(tb[NHA_GROUP]) /
@@ -450,6 +487,67 @@ static int  __ipnh_get_id(struct rtnl_handle *rthp, __u32 nh_id,
 	return rtnl_talk(rthp, &req.n, answer);
 }
 
+static int __ipnh_cache_parse_nlmsg(const struct nlmsghdr *n,
+				    struct nh_entry *nhe)
+{
+	int err, len;
+
+	len = n->nlmsg_len - NLMSG_SPACE(sizeof(struct nhmsg));
+	if (len < 0) {
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
+		return -EINVAL;
+	}
+
+	err = ipnh_parse_nhmsg(stderr, NLMSG_DATA(n), len, nhe);
+	if (err) {
+		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(-err));
+		return err;
+	}
+
+	return 0;
+}
+
+static struct nh_entry *ipnh_cache_add(__u32 nh_id)
+{
+	struct rtnl_handle cache_rth = { .fd = -1 };
+	struct nlmsghdr *answer = NULL;
+	struct nh_entry *nhe = NULL;
+
+	if (rtnl_open(&cache_rth, 0) < 0)
+		goto out;
+
+	if (__ipnh_get_id(&cache_rth, nh_id, &answer) < 0)
+		goto out;
+
+	nhe = malloc(sizeof(*nhe));
+	if (!nhe)
+		goto out;
+
+	if (__ipnh_cache_parse_nlmsg(answer, nhe))
+		goto out_free_nhe;
+
+	ipnh_cache_link_entry(nhe);
+
+out:
+	if (answer)
+		free(answer);
+	rtnl_close(&cache_rth);
+
+	return nhe;
+
+out_free_nhe:
+	free(nhe);
+	nhe = NULL;
+	goto out;
+}
+
+static void ipnh_cache_del(struct nh_entry *nhe)
+{
+	ipnh_cache_unlink_entry(nhe);
+	ipnh_destroy_entry(nhe);
+	free(nhe);
+}
+
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
@@ -476,10 +574,10 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (filter.proto && filter.proto != nhm->nh_protocol)
 		return 0;
 
-	err = parse_nexthop_rta(fp, nhm, len, &nhe);
+	err = ipnh_parse_nhmsg(fp, nhm, len, &nhe);
 	if (err) {
 		close_json_object();
-		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(err));
+		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(-err));
 		return -1;
 	}
 	open_json_object(NULL);
@@ -530,7 +628,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	close_json_object();
 	fflush(fp);
-	destroy_nexthop_entry(&nhe);
+	ipnh_destroy_entry(&nhe);
 
 	return 0;
 }
diff --git a/ip/nh_common.h b/ip/nh_common.h
index 8c96f9993562..a34b0d20916e 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -2,6 +2,10 @@
 #ifndef __NH_COMMON_H__
 #define __NH_COMMON_H__ 1
 
+#include <list.h>
+
+#define NH_CACHE_SIZE		1024
+
 struct nha_res_grp {
 	__u16			buckets;
 	__u32			idle_timer;
@@ -10,6 +14,8 @@ struct nha_res_grp {
 };
 
 struct nh_entry {
+	struct hlist_node	nh_hash;
+
 	__u32			nh_id;
 	__u32			nh_oif;
 	__u32			nh_flags;
-- 
2.31.1

