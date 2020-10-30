Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C1A2A0569
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgJ3MbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgJ3MbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:31:17 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C7CC0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:31:17 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CN1rM1hbVzQkLK;
        Fri, 30 Oct 2020 13:31:15 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604061073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6eCmMsC7TqxsBhNRrnZ8Cb0HXn6LSNmhzQNeYBA8EeM=;
        b=068hic9QGaH9w74Ehs2GZtbvzlBsxf53Q09jLcSHw1U3nJ+28GUw1CIsQKfw4AZz+0rGSL
        C/HdLCjZ3sl/wewJ+w1Qq5EX4D6ir4GBoslWBREax0Pk1JLnq0I4nbRpKswXcmdM+VCsce
        8Df4sq9F0He4bjw+qWibfzm5/IDLW3Bcu1HzDBg4dofZlHUStCfEA/YIlPZvMyUBnDx3xY
        Jv9u8oTOEMNQ0HkW4yOCVxoB7c5R1AbuMQUjfeEUiMDcOwHAJSxTb+ILBqKgU76Sr6ksBE
        yUwpzfiW1c11pdzf9SUSgCKY8JM7LFCyOzaSbVzINWglYotyikkXWjPqhLyxJA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id CxLL_Q36-byU; Fri, 30 Oct 2020 13:31:12 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 09/11] lib: parse_mapping: Recognize a keyword "all"
Date:   Fri, 30 Oct 2020 13:29:56 +0100
Message-Id: <e865ef2f656e836662c0cd307c17250f072d3d1b.1604059429.git.me@pmachata.org>
In-Reply-To: <cover.1604059429.git.me@pmachata.org>
References: <cover.1604059429.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.51 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3E0541707
X-Rspamd-UID: cf5443
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
index 1c72221ae92c..8ec1b7ab0d8d 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -330,7 +330,7 @@ int parse_one_of(const char *msg, const char *realval, const char * const *list,
 int parse_on_off(const char *msg, const char *realval, int *p_err);
 void print_on_off_bool(FILE *fp, const char *flag, bool val);
 
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
index 089bbde715da..3b3b42b15013 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1772,7 +1772,7 @@ void print_on_off_bool(FILE *fp, const char *flag, bool val)
 		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
 }
 
-int parse_mapping(int *argcp, char ***argvp,
+int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data)
 {
@@ -1788,7 +1788,9 @@ int parse_mapping(int *argcp, char ***argvp,
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

