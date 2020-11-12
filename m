Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9172B116B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgKLW0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgKLW0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:26:12 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBA4C0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:12 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CXGQp4n50zQlRS;
        Thu, 12 Nov 2020 23:26:10 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605219968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CejmdtCpUP4hF0QdUazjGj0eVhhM9Cy+N5Lrnfd7Z4Y=;
        b=kS5dxACXGzvfswhdCLKg7VzTNNqCGvvnfeSoCiqLGd91BQJiY3gQIIe1H/NB0pXspPbhSX
        tdBrl1ZcKXtipspI5l3GH4nQCKawjMUxOL2MChulasUz73YE/WOeekNuX8H3DflwWyhIFo
        r8o6CYvQTJGeVr9R7qy89bYIm3sWifX3urOiGLIGnwkwehRmmqaSWe+DoEVW6WvLTMGWuy
        vHcpxFPxdcXR3BdJYCs2zAHXmVb00jXLTGwdpgpIGiEfdPNAWnsyujfTOOM4GQjq8WQ85N
        U8k4pA8BjKqRMqwn8+ilOmIKv+gwbrc2yM/iN3m8or5gRtIoSZXMz6RSEJ1nEg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id rd1xXh01Z1FK; Thu, 12 Nov 2020 23:26:07 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v5 07/11] lib: Extract from iplink_vlan a helper to parse key:value arrays
Date:   Thu, 12 Nov 2020 23:24:44 +0100
Message-Id: <b0ab7e4796d55c258c800003a39bf9a263108b94.1605218735.git.me@pmachata.org>
In-Reply-To: <cover.1605218735.git.me@pmachata.org>
References: <cover.1605218735.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.57 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9770D108B
X-Rspamd-UID: 4f2034
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN netdevices have two similar attributes: ingress-qos-map and
egress-qos-map. These attributes can be configured with a series of
802.1-priority-to-skb-priority (and vice versa) mappings. A reusable helper
along those lines will be handy for configuration of various
priority-to-tc, tc-to-algorithm, and other arrays in DCB.

Therefore extract the logic to a function parse_mapping(), move to utils.c,
and dispatch to utils.c from iplink_vlan.c. That necessitates extraction of
a VLAN-specific parse_qos_mapping(). Do that, and propagate addattr_l()
return value up, unlike the original.

Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v2:
    - In parse_qos_mapping(), propagate return value from addattr_l()
      [Roman Mashak]

 include/utils.h  |  4 ++++
 ip/iplink_vlan.c | 36 +++++++++++++++---------------------
 lib/utils.c      | 28 ++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index d7653273af5f..2d1a587cb1ef 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -329,4 +329,8 @@ int parse_one_of(const char *msg, const char *realval, const char * const *list,
 		 size_t len, int *p_err);
 bool parse_on_off(const char *msg, const char *realval, int *p_err);
 
+int parse_mapping(int *argcp, char ***argvp,
+		  int (*mapping_cb)(__u32 key, char *value, void *data),
+		  void *mapping_cb_data);
+
 #endif /* __UTILS_H__ */
diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index 1e6817f5de3d..dadc349db16c 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -49,36 +49,30 @@ static int on_off(const char *msg, const char *arg)
 	return -1;
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
+	return addattr_l(n, 1024, IFLA_VLAN_QOS_MAPPING, &m, sizeof(m));
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
index eab0839a13c7..1dfaaf564915 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1763,3 +1763,31 @@ bool parse_on_off(const char *msg, const char *realval, int *p_err)
 
 	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
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

