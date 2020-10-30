Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D912A0568
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgJ3MbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgJ3MbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:31:15 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27645C0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:31:15 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CN1rK1MsPzQlLp;
        Fri, 30 Oct 2020 13:31:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604061071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKDkDR26cv382P/wWzdsxp81FE6zSa+DRTi4nffKL3w=;
        b=YCaIyLKNrEKM4gDGZoHMpHV0v4PRtX5hTieegBqLLxepi0IRINLOISd2ViEHgrzV82GG2i
        sDEmyZbq+rn2iBbdrZVzJI8lV5vxSRmj/iyGPbjYhfV8WQAL5ADIyVIrCeTl7HsMd9YgMp
        QY7QOKY4pbe5lHXC5JbrrvuTxHKG5QEiMVDhOQGVh0tw94mlahZunRsvhXA6H55BhNKA1p
        U+5t2rW9Jh9LNyxPdtb6R8IP/om2pDd1cBjXr/taxGU06ehOlCgQBmvjFxsqJDTop1Jotu
        n0tDj+axksMToeBPoMoQqC7KQVqO8+CGReAd6F9hBM56j8TjpdlRDzpw4McTmg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id AbOV79nnv_Yc; Fri, 30 Oct 2020 13:31:10 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 07/11] lib: Extract from iplink_vlan a helper to parse key:value arrays
Date:   Fri, 30 Oct 2020 13:29:54 +0100
Message-Id: <15cf4f253c8a261e9df1c1d6e6115194945a0c21.1604059429.git.me@pmachata.org>
In-Reply-To: <cover.1604059429.git.me@pmachata.org>
References: <cover.1604059429.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.10 / 15.00 / 15.00
X-Rspamd-Queue-Id: 22E09171E
X-Rspamd-UID: bde3a5
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
index e3cdb098834a..1c72221ae92c 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -330,4 +330,8 @@ int parse_one_of(const char *msg, const char *realval, const char * const *list,
 int parse_on_off(const char *msg, const char *realval, int *p_err);
 void print_on_off_bool(FILE *fp, const char *flag, bool val);
 
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
index 8deec86ecbcd..aba7cc0960cd 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1771,3 +1771,31 @@ void print_on_off_bool(FILE *fp, const char *flag, bool val)
 	else
 		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
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

