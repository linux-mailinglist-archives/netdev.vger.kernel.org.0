Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED61A293280
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389703AbgJTA7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389674AbgJTA7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:59:01 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42499C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:59:01 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CFZyC51krzQkSN;
        Tue, 20 Oct 2020 02:58:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myIJ54qqKNFKZpGiNsfVfRGoR91uBY8gGS1Zz6FWIgE=;
        b=d1HYuBKzB2KInvdE5BOAIgo+7YyWZIp0iN0tui9Y4o9+ow0CEhWrAKNhQDTuCDgt7C3tZn
        X+REHn/klkn6kRPce8N9WpH1R76wEKyn1wJYqH49VYTu4LDWAWRq+U8z6K1oHPHRX+wkKR
        ILW3hdwPCpRct9RFLLC6AlppTBNOaXRTjGGogmNKPgempNxdE2hafMta9sKDWC6qfwoNcE
        nBq6hwsumd5VcKmBVsK8CKa0RMGo15DtZF3dY0/d8gm03CT8X+V6X2B9PUlhn8J3WACEJV
        ptourA3mRBzOTIA0NY4hsE83vyUZNVBGEUaJ5GzTrKiKOa0qAKheHrx7gdTgzg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 6vsbInq2gmJT; Tue, 20 Oct 2020 02:58:56 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 13/15] lib: parse_mapping: Recognize a keyword "all"
Date:   Tue, 20 Oct 2020 02:58:21 +0200
Message-Id: <f3f263759f21a99c63309eddb20bd7cf05fce0d7.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.52 / 15.00 / 15.00
X-Rspamd-Queue-Id: B0833271
X-Rspamd-UID: cd7f37
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
index 8323e3cf1103..cad87d39695a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -339,7 +339,7 @@ int parse_on_off(const char *msg, const char *realval, int *p_err);
 void parse_flag_on_off(const char *msg, const char *realval,
 		       unsigned int *p_flags, unsigned int flag, int *p_ret);
 
-int parse_mapping(int *argcp, char ***argvp,
+int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data);
 
diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index 73aa94acde3c..8ab2250cf110 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -64,7 +64,7 @@ static int vlan_parse_qos_map(int *argcp, char ***argvp, struct nlmsghdr *n,
 
 	tail = addattr_nest(n, 1024, attrtype);
 
-	if (parse_mapping(argcp, argvp, &parse_qos_mapping, n))
+	if (parse_mapping(argcp, argvp, false, &parse_qos_mapping, n))
 		return 1;
 
 	addattr_nest_end(n, tail);
diff --git a/lib/utils.c b/lib/utils.c
index 87cc6ae0cfba..51471ba73b8d 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1775,7 +1775,7 @@ void parse_flag_on_off(const char *msg, const char *realval,
 	set_flag(p_flags, flag, on_off);
 }
 
-int parse_mapping(int *argcp, char ***argvp,
+int parse_mapping(int *argcp, char ***argvp, bool allow_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data)
 {
@@ -1791,7 +1791,9 @@ int parse_mapping(int *argcp, char ***argvp,
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

