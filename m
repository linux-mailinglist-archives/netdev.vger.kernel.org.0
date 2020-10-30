Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E452A0574
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgJ3Mbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgJ3MbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:31:11 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF29C0613D4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:31:11 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CN1rF0LhLzQl8x;
        Fri, 30 Oct 2020 13:31:09 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604061067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTWKdB9jKvPLlGcL64b7TayarsnysHuzTi2oE2fPlwI=;
        b=GQaHfAa9BH/V8obvaobK/cg6ESlyy5l+VZVUl2a5wvM2gRftLqLLd5vUOanrBYfzoiDu48
        LMR/0t9dg4PrZuGW6cyzFieFTQ1vq6I0wzWE8Ll2N0z6/e2+iYfiwKO2iyJ4wbFVxXzroz
        b0KgLFyNxjWrucXvVsCxYe6BCfAmlzqHzGbVKskqLnbw3/vcT1HOYMYD+dT2ckXH56CKxg
        TAjkzSZijM3Cf/874DwWj8UIieC+KVkIln3aIi8gFMiN29sY5cM2e42NgbnVujL+sFcNHN
        K6vgVM6jsy4ln3cR+r5whP4hVFQh3ljUScsMKXkLkZvjqeQ9fpkeD7POLLwkAw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id aZOoE6h2C3Zs; Fri, 30 Oct 2020 13:31:05 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 03/11] lib: utils: Add print_on_off_bool()
Date:   Fri, 30 Oct 2020 13:29:50 +0100
Message-Id: <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
In-Reply-To: <cover.1604059429.git.me@pmachata.org>
References: <cover.1604059429.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.06 / 15.00 / 15.00
X-Rspamd-Queue-Id: 07756171C
X-Rspamd-UID: d16a04
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of a number of booleans is shown as "on" and "off" in the plain
output, and as an actual boolean in JSON mode. Add a function that does
that.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h | 1 +
 lib/utils.c     | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index bd62cdcd7122..e3cdb098834a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -328,5 +328,6 @@ int do_batch(const char *name, bool force,
 int parse_one_of(const char *msg, const char *realval, const char * const *list,
 		 size_t len, int *p_err);
 int parse_on_off(const char *msg, const char *realval, int *p_err);
+void print_on_off_bool(FILE *fp, const char *flag, bool val);
 
 #endif /* __UTILS_H__ */
diff --git a/lib/utils.c b/lib/utils.c
index 930877ae0f0d..8deec86ecbcd 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1763,3 +1763,11 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
 
 	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
 }
+
+void print_on_off_bool(FILE *fp, const char *flag, bool val)
+{
+	if (is_json_context())
+		print_bool(PRINT_JSON, flag, NULL, val);
+	else
+		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
+}
-- 
2.25.1

