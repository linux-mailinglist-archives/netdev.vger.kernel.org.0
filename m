Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7ED29327C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389672AbgJTA7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389662AbgJTA66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:58 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83CFC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:58 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CFZy85wtszQkmC;
        Tue, 20 Oct 2020 02:58:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgcVMprNydWwSMOG/kvq0fcYmMeCQGKrbYNPSWJQi98=;
        b=qXvCbagWhl8RFnxhu9XNDLR8dHq8ZeOt9ia+qnPqRmqG+ib9y0BNClmdSPE8/r3NAYRTvx
        iSbo1CXuc7Dg4NB+UKI8gFFh/ud/66ihAG/80eeVLpRmsD9QbMmZMmC8Hm9l7tOkKaZX8I
        UMTQuOCJSuZISyLrsWfRNpAsXLAqwK6stmk7sBsNhnplBpo05Gz6nGuE/fZNGk5iCDrNXL
        2N7xBQSs/XeY3UiJxfE2p5bb9q4stGcz964T9eMT04SBf9xGsWzj7qp1fDw5XLnkzGHdRv
        famAwvFTcDV5wtp86AzFaEV0+RqQI9QEvbhyHzeUTz3pmm+Ievnrg7DnPeJsDw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id Q8A__0ggYiPh; Tue, 20 Oct 2020 02:58:53 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 11/15] lib: Extract from iplink_vlan a helper to parse key:value arrays
Date:   Tue, 20 Oct 2020 02:58:19 +0200
Message-Id: <233147e872018f538306e5f8dad3f3be07540d81.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.51 / 15.00 / 15.00
X-Rspamd-Queue-Id: D302617E6
X-Rspamd-UID: c74065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN netdevices have two similar attributes: ingress-qos-map and
egress-qos-map. These attributes can be configured with a series of
802.1-priority-to-skb-priority (and vice versa) mappings. A reusable helper
along those lines will be handy for configuration of various
priority-to-tc, tc-to-algorithm, and other arrays in DCB. Therefore extract
the logic to a function parse_mapping(), move to utils.c, and dispatch to
utils.c from iplink_vlan.c.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h  |  4 ++++
 ip/iplink_vlan.c | 37 ++++++++++++++++---------------------
 lib/utils.c      | 28 ++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 681110fcf8af..8323e3cf1103 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -339,4 +339,8 @@ int parse_on_off(const char *msg, const char *realval, int *p_err);
 void parse_flag_on_off(const char *msg, const char *realval,
 		       unsigned int *p_flags, unsigned int flag, int *p_ret);
 
+int parse_mapping(int *argcp, char ***argvp,
+		  int (*mapping_cb)(__u32 key, char *value, void *data),
+		  void *mapping_cb_data);
+
 #endif /* __UTILS_H__ */
diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index 66c4c0fb57f1..73aa94acde3c 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -43,36 +43,31 @@ static void explain(void)
 	print_explain(stderr);
 }
 
+static int parse_qos_mapping(__u32 key, char *value, void *data)
+{
+	struct nlmsghdr *n = data;
+	struct ifla_vlan_qos_mapping m = {
+		.from = key,
+	};
+
+	if (get_u32(&m.to, value, 0))
+		return 1;
+
+	addattr_l(n, 1024, IFLA_VLAN_QOS_MAPPING, &m, sizeof(m));
+	return 0;
+}
+
 static int vlan_parse_qos_map(int *argcp, char ***argvp, struct nlmsghdr *n,
 			      int attrtype)
 {
-	int argc = *argcp;
-	char **argv = *argvp;
-	struct ifla_vlan_qos_mapping m;
 	struct rtattr *tail;
 
 	tail = addattr_nest(n, 1024, attrtype);
 
-	while (argc > 0) {
-		char *colon = strchr(*argv, ':');
-
-		if (!colon)
-			break;
-		*colon = '\0';
-
-		if (get_u32(&m.from, *argv, 0))
-			return 1;
-		if (get_u32(&m.to, colon + 1, 0))
-			return 1;
-		argc--, argv++;
-
-		addattr_l(n, 1024, IFLA_VLAN_QOS_MAPPING, &m, sizeof(m));
-	}
+	if (parse_mapping(argcp, argvp, &parse_qos_mapping, n))
+		return 1;
 
 	addattr_nest_end(n, tail);
-
-	*argcp = argc;
-	*argvp = argv;
 	return 0;
 }
 
diff --git a/lib/utils.c b/lib/utils.c
index fb25c64d36ff..93521a49eaec 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1774,3 +1774,31 @@ void parse_flag_on_off(const char *msg, const char *realval,
 
 	set_flag(p_flags, flag, on_off);
 }
+
+int parse_mapping(int *argcp, char ***argvp,
+		  int (*mapping_cb)(__u32 key, char *value, void *data),
+		  void *mapping_cb_data)
+{
+	int argc = *argcp;
+	char **argv = *argvp;
+
+	while (argc > 0) {
+		char *colon = strchr(*argv, ':');
+		__u32 key;
+
+		if (!colon)
+			break;
+		*colon = '\0';
+
+		if (get_u32(&key, *argv, 0))
+			return 1;
+		if (mapping_cb(key, colon + 1, mapping_cb_data))
+			return 1;
+
+		argc--, argv++;
+	}
+
+	*argcp = argc;
+	*argvp = argv;
+	return 0;
+}
-- 
2.25.1

