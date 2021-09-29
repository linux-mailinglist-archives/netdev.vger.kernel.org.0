Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9CC41C86D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345335AbhI2Pbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345322AbhI2Pbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123FDC061760
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:30:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id bd28so10042056edb.9
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oq58EzNy664aUWc2V8EL3IoGwOqdTRT7Eo3bwpve3h8=;
        b=0BGG03do6qXO8pppx8FP/TlbsJHv/Ez5W6BCOj/ncvfXhCksixoQEqTh36mUyyKa7l
         k/QfTNMjkewDjcNUIvdeTqkJ5hlfE/2EOvVUqdst598gO2C49U2I9WXfi04njO6k/0ro
         dDoeQMqLlxmvgbavBciYW2cNJnFRB6K0yGgiUUGsk9q4flDggCXf5OyNg5lekY2t5Ipa
         C1z+ds0YqGkdnmVbxr4Dzka9hG4OvPNMQb2umJtSMUvADFb1zzAZGBzsMdITwnHABqU5
         ZzcV09A+Odget2xbHki60YbkTYLGyKJpd9y/sbfWVR0t4W9D7g+bdBE69elSwFwP5NEj
         opng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oq58EzNy664aUWc2V8EL3IoGwOqdTRT7Eo3bwpve3h8=;
        b=7ZL2iYb3MdG/rGkZlrHi9RVBXiDzBe5MqyK3Qb4X6eonC3L4qSc0sSmnfLNHrWeb+s
         +4S00ExOvR63+PETYJ6vmtsi+UbZKwZ/u3IZyXDM7ka2CzRubdOdeO5wOuZmQGneW3hi
         6HgZwgoU+y+7hZ6gzUK0SA8MgBC2ch2J5RE/uMI8HlqC5falUfZF9KJ4j6Bsb4/RtU2h
         PcPSR655qY2538y4XkbrnEPT0VhzToF78+Ri3nc48sRV6BPeUvJrhgAUnHZR/zawt7vz
         UG9evKulObEa4mWmwCyLpuEk4C5rIWm4r4rA/LM2VjvIElcsSYr5cgd8dV2aaI29go79
         R3fQ==
X-Gm-Message-State: AOAM533JqRrHh5P099d0FVvMLgPTkjMFHBlMEw8lXhbaTgwrc5xTVhNg
        5AlQ2S4bWsSVQdYvlfQVsi/k1d9jI6rgeGQq
X-Google-Smtp-Source: ABdhPJwilPpRXfgtzctrLEAd9V4D6nI6ey8+jV6MyNz2AadBXNQBv7XPJChhdo2LGemx1/cXvCnWmw==
X-Received: by 2002:a50:dac2:: with SMTP id s2mr581558edj.141.1632929342630;
        Wed, 29 Sep 2021 08:29:02 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:29:02 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 09/11] ip: nexthop: add a helper which retrieves and prints cached nh entry
Date:   Wed, 29 Sep 2021 18:28:46 +0300
Message-Id: <20210929152848.1710552-10-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a helper which looks for a nexthop in the cache and if not found
reads the entry from the kernel and caches it. Finally the entry is
printed.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 16 ++++++++++++++++
 ip/nh_common.h |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 37b94d6702df..fdd0d0926630 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -640,6 +640,22 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
+			    __u32 nh_id)
+{
+	struct nh_entry *nhe = ipnh_cache_get(nh_id);
+
+	if (!nhe) {
+		nhe = ipnh_cache_add(nh_id);
+		if (!nhe)
+			return;
+	}
+
+	if (fp_prefix)
+		print_string(PRINT_FP, NULL, "%s", fp_prefix);
+	__print_nexthop_entry(fp, jsobj, nhe, false);
+}
+
 int print_nexthop_bucket(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
diff --git a/ip/nh_common.h b/ip/nh_common.h
index a34b0d20916e..a672d658a9ea 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -46,4 +46,7 @@ struct nh_entry {
 	struct nexthop_grp	*nh_groups;
 };
 
+void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
+			    __u32 nh_id);
+
 #endif /* __NH_COMMON_H__ */
-- 
2.31.1

