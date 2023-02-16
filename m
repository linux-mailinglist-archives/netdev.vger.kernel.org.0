Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077CF699362
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjBPLmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPLmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:42:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3701F488;
        Thu, 16 Feb 2023 03:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676547726; x=1708083726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FfCAalj2Nee1CcJLc+LGlUXcvI9FY2hBGzZJL2n+MEo=;
  b=mw3oNVc5RgBteAH7PI08t5I/AveePF5vQim6KoKMLITrr0hkCjsgV5sz
   bktGZBxTUDAjbZVBdScT/19Q8AZgtRQx2lbx+2avgvsoGXyLOcOisg5eV
   sNlvUikl2CGIyWKlhGCxu3oZicZFHaPxIkzrSUH/kIA2vaF7FWNUje1Ya
   /IaA+9ieNAvkyM8M0fzxniXvDsfzgWJ/RgvSRk7Mlt59eh5/j5P+obJBF
   eAxNAMemOZqr+Kg+6xjcz195vVP/oC8WShX7to8doECbydSAMRvtFw4sG
   4FLSUQ/NWewh+cf78qKFhYFgsqjhHIGyMku5t1XbyI53ocXXjqh3napdt
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359124747"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359124747"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 03:42:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="999003914"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="999003914"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 16 Feb 2023 03:42:00 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 199DC1C5; Thu, 16 Feb 2023 13:42:41 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Shevchenko <andy@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v1 2/2] dns: use memscan() instead of open coded variant
Date:   Thu, 16 Feb 2023 13:42:34 +0200
Message-Id: <20230216114234.36343-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216114234.36343-1-andriy.shevchenko@linux.intel.com>
References: <20230216114234.36343-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memscan() is a standard API to provide an equivalent to

	memchr(foo, $CHAR, end - foo) ?: end

so use it.

Memory footprint (x86_64):

  Function                                     old     new   delta
  dns_resolver_preparse                       1429    1393     -36
  Total: Before=3229, After=3193, chg -1.11%

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/dns_resolver/dns_key.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 01e54b46ae0b..835be6e2dd83 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -134,8 +134,8 @@ dns_resolver_preparse(struct key_preparsed_payload *prep)
 
 	/* deal with any options embedded in the data */
 	end = data + datalen;
-	opt = memchr(data, '#', datalen);
-	if (!opt) {
+	opt = memscan(data, '#', datalen);
+	if (opt == end) {
 		/* no options: the entire data is the result */
 		kdebug("no options");
 		result_len = datalen;
@@ -150,7 +150,7 @@ dns_resolver_preparse(struct key_preparsed_payload *prep)
 			const char *eq;
 			char optval[128];
 
-			next_opt = memchr(opt, '#', end - opt) ?: end;
+			next_opt = memscan(opt, '#', end - opt);
 			opt_len = next_opt - opt;
 			if (opt_len <= 0 || opt_len > sizeof(optval)) {
 				pr_warn_ratelimited("Invalid option length (%d) for dns_resolver key\n",
@@ -158,16 +158,10 @@ dns_resolver_preparse(struct key_preparsed_payload *prep)
 				return -EINVAL;
 			}
 
-			eq = memchr(opt, '=', opt_len);
-			if (eq) {
-				opt_nlen = eq - opt;
-				eq++;
-				memcpy(optval, eq, next_opt - eq);
-				optval[next_opt - eq] = '\0';
-			} else {
-				opt_nlen = opt_len;
-				optval[0] = '\0';
-			}
+			eq = memscan(opt, '=', opt_len);
+			opt_nlen = eq - opt;
+			memcpy(optval, eq, next_opt - eq);
+			optval[next_opt - eq] = '\0';
 
 			kdebug("option '%*.*s' val '%s'",
 			       opt_nlen, opt_nlen, opt, optval);
-- 
2.39.1

