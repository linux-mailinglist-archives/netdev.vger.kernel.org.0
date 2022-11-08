Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011A862112C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiKHMoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiKHMoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:44:06 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC38C74A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:44:05 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z26so13726413pff.1
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 04:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PP4Bm62BP8/4FEBgiYjzUkDmaQifXAEEJgvTVQOGIfw=;
        b=Slyzr8A/f8GoR0kLUNiguFf0OmG2zcj4F9eWQYq43fPr5AS1N3vqdi4t92Flv3AI2R
         wsW6elg9ffPy+N/ceMSLGSDXE2HiZAbKnmyXA7m5CxXtQoLF9ACFX3naPjklf+gp51dq
         ZYP8/zPMQW4ZCDHtLQao/zxfT+v9Q9kJlOIRUNu63q4Lb7YUjfh4wZYYbBUR4U5f8id9
         7NqUfVMdsyFy7QRjUSjT7S4iqO/qgE7gHo7Z5gqJO6ESNiJXqLauS+hVsHZZxv6i9MO6
         XeTjgdXS9lSmTXkVyUi337mcSXebyC5qGWt5rfblBkrEcMGrANl9U11vVXnXqYdVudt5
         S0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PP4Bm62BP8/4FEBgiYjzUkDmaQifXAEEJgvTVQOGIfw=;
        b=BuI0ZSMds0QErKNLvWKm8+caoihimPNWpNxcLtHW0JoKDmkxTX1q10OzLp+aGyUY2F
         ap0tGL6VRA++PqKKOBuFpD8vHeyozoGpGgH9U62nNKHGJNDMOvmBJ6Odi5xUnu+63bzX
         voqgPSKTuzxbUXhnziPpjlaa9FeeBfIQa0tboFLBBfWRcShqLBY0Yb1Vj9wuJTGgJrxM
         eBou3H6dQdqCKyolnSYfcBO8dCgjk5KW+zfAo1D5qdiSRDSGjGTlZ8oQwodhqg5ToXwu
         GeKC9sDm+TjfX/kW9JDAKfggcEZe7ZLutjulxZY+sOxpoltBYCsVI2GZF87qSxvynH90
         3EnQ==
X-Gm-Message-State: ACrzQf3Ue6zc73ZXUp+Twm1kiEpUf604DFV/Tzo/xffVFRgELNZlXGgb
        FPZ/R0R/FUNDL2f7EvharwyfJUJsPsWi7g==
X-Google-Smtp-Source: AMsMyM4OJSLMJeaIOzLtcjUwvZwrWz9oZW2TRKVq+58lzYqU0XYSmTObJ3I5vSAzfrLX5cvhsHGWPg==
X-Received: by 2002:a63:464d:0:b0:441:5968:cd0e with SMTP id v13-20020a63464d000000b004415968cd0emr49317928pgk.595.1667911444915;
        Tue, 08 Nov 2022 04:44:04 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q23-20020a170902bd9700b001784a45511asm6835999pls.79.2022.11.08.04.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 04:44:04 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2] ip: fix return value for rtnl_talk failures
Date:   Tue,  8 Nov 2022 20:43:44 +0800
Message-Id: <20221108124344.192326-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since my last commit "rtnetlink: add new function rtnl_echo_talk()" we
return the kernel rtnl exit code directly, which breaks some kernel
selftest checking. As there are still a lot of tests checking -2 as the
error return value, to keep backward compatibility, let's keep using
-2 for all the rtnl return values.

Reported-by: Ido Schimmel <idosch@idosch.org>
Fixes: 6c09257f1bf6 ("rtnetlink: add new function rtnl_echo_talk()")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 ip/ipaddress.c | 10 ++++++++--
 ip/iplink.c    |  2 +-
 ip/ipnexthop.c | 10 ++++++++--
 ip/iproute.c   | 10 ++++++++--
 ip/iprule.c    | 10 ++++++++--
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 456545bb..5e833482 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2422,6 +2422,7 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 	__u32 preferred_lft = INFINITY_LIFE_TIME;
 	__u32 valid_lft = INFINITY_LIFE_TIME;
 	unsigned int ifa_flags = 0;
+	int ret;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "peer") == 0 ||
@@ -2604,9 +2605,14 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 	}
 
 	if (echo_request)
-		return rtnl_echo_talk(&rth, &req.n, json, print_addrinfo);
+		ret = rtnl_echo_talk(&rth, &req.n, json, print_addrinfo);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
 
-	return rtnl_talk(&rth, &req.n, NULL);
+	if (ret)
+		return -2;
+
+	return 0;
 }
 
 int do_ipaddr(int argc, char **argv)
diff --git a/ip/iplink.c b/ip/iplink.c
index 92ce6c47..301a535e 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1129,7 +1129,7 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 		ret = rtnl_talk(&rth, &req.n, NULL);
 
 	if (ret)
-		return ret;
+		return -2;
 
 	/* remove device from cache; next use can refresh with new data */
 	ll_drop_by_index(req.i.ifi_index);
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index c87e847f..9f16b809 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -920,6 +920,7 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 		.nhm.nh_family = preferred_family,
 	};
 	__u32 nh_flags = 0;
+	int ret;
 
 	while (argc > 0) {
 		if (!strcmp(*argv, "id")) {
@@ -1000,9 +1001,14 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 	req.nhm.nh_flags = nh_flags;
 
 	if (echo_request)
-		return rtnl_echo_talk(&rth, &req.n, json, print_nexthop_nocache);
+		ret = rtnl_echo_talk(&rth, &req.n, json, print_nexthop_nocache);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret)
+		return -2;
 
-	return rtnl_talk(&rth, &req.n, NULL);
+	return 0;
 }
 
 static int ipnh_get_id(__u32 id)
diff --git a/ip/iproute.c b/ip/iproute.c
index b4b9d1b2..f34289e8 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1134,6 +1134,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	int raw = 0;
 	int type_ok = 0;
 	__u32 nhid = 0;
+	int ret;
 
 	if (cmd != RTM_DELROUTE) {
 		req.r.rtm_protocol = RTPROT_BOOT;
@@ -1588,9 +1589,14 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 		req.r.rtm_type = RTN_UNICAST;
 
 	if (echo_request)
-		return rtnl_echo_talk(&rth, &req.n, json, print_route);
+		ret = rtnl_echo_talk(&rth, &req.n, json, print_route);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret)
+		return -2;
 
-	return rtnl_talk(&rth, &req.n, NULL);
+	return 0;
 }
 
 static int iproute_flush_cache(void)
diff --git a/ip/iprule.c b/ip/iprule.c
index 8f750425..8e5a2287 100644
--- a/ip/iprule.c
+++ b/ip/iprule.c
@@ -787,6 +787,7 @@ static int iprule_modify(int cmd, int argc, char **argv)
 		.frh.family = preferred_family,
 		.frh.action = FR_ACT_UNSPEC,
 	};
+	int ret;
 
 	if (cmd == RTM_NEWRULE) {
 		if (argc == 0) {
@@ -1017,9 +1018,14 @@ static int iprule_modify(int cmd, int argc, char **argv)
 		req.frh.table = RT_TABLE_MAIN;
 
 	if (echo_request)
-		return rtnl_echo_talk(&rth, &req.n, json, print_rule);
+		ret = rtnl_echo_talk(&rth, &req.n, json, print_rule);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret)
+		return -2;
 
-	return rtnl_talk(&rth, &req.n, NULL);
+	return 0;
 }
 
 int do_iprule(int argc, char **argv)
-- 
2.38.1

