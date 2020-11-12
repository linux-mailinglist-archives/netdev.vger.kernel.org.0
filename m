Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30EF2B1173
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKLW00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgKLW0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:26:19 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF564C0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:18 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CXGQw37lSzQlKH;
        Thu, 12 Nov 2020 23:26:16 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605219974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knKqnF1zJmuRCXbT34BozvnJMAmwYT+16StvsvU/LEQ=;
        b=orGyCTcrUtoRWTEnz3fMNpUFsRS83rSYAVxBF22lNPjLASlCiOTdBnILwyy+PJ5SDP81on
        y4TbGZ5la1wvHtBBg8SI52mrK4AuapiegEK8+5C7565NIS7zoKn/t7SnjD/xr54SA30ViU
        qdUk6DjtNuvaa1qDUn8gcTSOAwykYMFVxgbbHq+qi3wlo/+zJkZrzzC2gPvjDxBt+thZb0
        yT7buUp7eYPY6JyP+yiAkiAwS8pEBPJNdjMolnQdZMLA0CoN+2htChy4UJb9MLG2f0Jw0Q
        ert6KK8N3eoPc5IEgTRZLlRJngGZFVm55kVvAbE2WP3VmwTItYjOj2ucCtcJnw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id N6r7xJTUou78; Thu, 12 Nov 2020 23:26:10 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v5 09/11] lib: parse_mapping: Recognize a keyword "all"
Date:   Thu, 12 Nov 2020 23:24:46 +0100
Message-Id: <5ddbd73d50423a1da0b6f7b89b1f4ac2c9d19e56.1605218735.git.me@pmachata.org>
In-Reply-To: <cover.1605218735.git.me@pmachata.org>
References: <cover.1605218735.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.58 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4DC4517B2
X-Rspamd-UID: d6fb00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DCB tool will have to provide an interface to a number of fixed-size
arrays. Unlike the egress- and ingress-qos-map, it makes good sense to have
an interface to set all members to the same value. For example to set
strict priority on all TCs besides select few, or to reset allocated
bandwidth to all zeroes, again besides several explicitly-given ones.

To support this usage, extend the parse_mapping() with a boolean that
determines whether this special use is supported. If "all" is given and
recognized, mapping_cb is called with the key of -1.

Have iplink_vlan pass false for allow_all.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h  | 2 +-
 ip/iplink_vlan.c | 2 +-
 lib/utils.c      | 6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 2d1a587cb1ef..588fceb72442 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -329,7 +329,7 @@ int parse_one_of(const char *msg, const char *realval, const char * const *list,
 		 size_t len, int *p_err);
 bool parse_on_off(const char *msg, const char *realval, int *p_err);
 
-int parse_mapping(int *argcp, char ***argvp,
+int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data);
 
diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index dadc349db16c..1426f2afca23 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -69,7 +69,7 @@ static int vlan_parse_qos_map(int *argcp, char ***argvp, struct nlmsghdr *n,
 
 	tail = addattr_nest(n, 1024, attrtype);
 
-	if (parse_mapping(argcp, argvp, &parse_qos_mapping, n))
+	if (parse_mapping(argcp, argvp, false, &parse_qos_mapping, n))
 		return 1;
 
 	addattr_nest_end(n, tail);
diff --git a/lib/utils.c b/lib/utils.c
index 67d64df7e3e6..a0ba5181160e 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1764,7 +1764,7 @@ bool parse_on_off(const char *msg, const char *realval, int *p_err)
 	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
 }
 
-int parse_mapping(int *argcp, char ***argvp,
+int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data)
 {
@@ -1780,7 +1780,9 @@ int parse_mapping(int *argcp, char ***argvp,
 			break;
 		*colon = '\0';
 
-		if (get_u32(&key, *argv, 0)) {
+		if (allow_all && matches(*argv, "all") == 0) {
+			key = (__u32) -1;
+		} else if (get_u32(&key, *argv, 0)) {
 			ret = 1;
 			break;
 		}
-- 
2.25.1

