Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452AB41D8F9
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350597AbhI3Ll3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350581AbhI3LlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:19 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1037C061775
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:33 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g7so20815984edv.1
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k1RmNcVoX+kLSBgaMA/S8z2XYkL/ljTubxIHEdK9yg0=;
        b=1xU8VUvg2r28WWiPPxFf46ucRcsPrLHxwQ34kr+zOmaFJb3BYAycqzsZN34jJaq1g2
         7GRVg6eoR7CO2E77NtQbOO6xB4hLGD6is1NGi9lZ/6OPdLEaRG3/2Y3cndgjkDKgVHfs
         N8axEuoanQvknxI9mye4Lr5qk+//9wbazd9xnEr+wywxtvo98SaNeGWO8/8EvMlG8cH3
         U9JzV2414LrMQ0EfzB/vD+IsWtrgQm1lZYq+58e6qukYsvDEqrtebnsiJ5mubhkJcdQe
         6cQB9yT8QqJxIHey4e09jbi5eHggaQpQieJRgpnHMiAHNtCP+TFuOkp698KI1LeouHlc
         8Evw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1RmNcVoX+kLSBgaMA/S8z2XYkL/ljTubxIHEdK9yg0=;
        b=qRGyvJvDS7CUVARfk2hOjXvw0em7NBaoRC/9A3HDgGrxWrnCgrqPDbZZarQ8vZWyGc
         nKQlaOwbSL2gZkQPV/74+cdPutYTw7wyY2QU8xqCnAYKO5g18vuqj33VUjsfqaRA4V53
         CfO9S8sFuiNTpIlwydYaSJYKayQJFCbqDldJ91HpT5bre5m2XQ1PJftC9oHSP2Wsrtec
         a5DEwuUQTX/T6Pq6AhAQVJA6rKB4VpPITcITPSqZFgi7OYHvr6e1cK07ltY2XPwiMiSP
         5Kg34lGqwuY3kT8CoGxMYvsqCp9/D7vQwUtjZAfkIQdfF6otJZJgDT0QHJzXYwGj+UYg
         58og==
X-Gm-Message-State: AOAM531xiIprjQw25QQCvQwhtB5ZU5I1kC0YJ0s2oSlvXh/2fgXYNAJY
        0msvbgvm46/wC1fr7nyEILWgIAz5QKnsGHjb
X-Google-Smtp-Source: ABdhPJw3MQ3g4brwksZDNiBu7UJsb6K3jtcdRzg//+oh/RCWL5xSn7IS22+/QwS1f3r5n3uoxHq1yg==
X-Received: by 2002:a17:907:d23:: with SMTP id gn35mr6338919ejc.556.1633001972020;
        Thu, 30 Sep 2021 04:39:32 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:31 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 09/12] ip: nexthop: add cache helpers
Date:   Thu, 30 Sep 2021 14:38:41 +0300
Message-Id: <20210930113844.1829373-10-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
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
 ip/ipnexthop.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++
 ip/nh_common.h |  6 ++++
 2 files changed, 104 insertions(+)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 454c7416e30f..e0f0f78460c9 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -34,6 +34,8 @@ enum {
 #define RTM_NHA(h)  ((struct rtattr *)(((char *)(h)) + \
 			NLMSG_ALIGN(sizeof(struct nhmsg))))
 
+static struct hlist_head nh_cache[NH_CACHE_SIZE];
+
 static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
@@ -504,6 +506,102 @@ static int  __ipnh_get_id(struct rtnl_handle *rthp, __u32 nh_id,
 	return rtnl_talk(rthp, &req.n, answer);
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
diff --git a/ip/nh_common.h b/ip/nh_common.h
index d9730f45c6fb..ee84d968d8dd 100644
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

