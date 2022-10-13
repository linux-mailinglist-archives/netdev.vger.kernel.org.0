Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7D5FDD19
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJMPXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiJMPXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:23:39 -0400
X-Greylist: delayed 294 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Oct 2022 08:23:22 PDT
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C5163374
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:23:21 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 29DFIEM44167620;
        Thu, 13 Oct 2022 17:18:14 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 29DFIEM44167620
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1665674294;
        bh=QQKO2Gt95d0S/UD87ZROBlqSFHYhACkqDca6PMq68og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nGPOnL391tusZVM8FyvGI6BoeE9YL8AgrwzoTpZbHd2YZhkoPTHQRMaWZ254Kskin
         YxJbgmFslsmcOjXzsIWcWoOuNaWisSKxRMH+hRO5GVHK+nYqBAaLkFvsW5F8Tyoc6W
         GUy4qbNuZSvTMTtm8EwuWPcMO+ZvsoMRzkbfF8j0=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 29DFIDuG4167619;
        Thu, 13 Oct 2022 17:18:13 +0200
Date:   Thu, 13 Oct 2022 17:18:13 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Christian =?utf-8?Q?P=C3=B6ssinger?= <christian@poessinger.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: iproute2/tc invalid JSON in 6.0.0 for flowid
Message-ID: <Y0gsNeByeUnTF3AT@electric-eye.fr.zoreil.com>
References: <f4806731521546b0bb7011b8c570b52b@poessinger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4806731521546b0bb7011b8c570b52b@poessinger.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Pössinger <christian@poessinger.com> :
[...]
> If you can point me to the location which could be responsible for this issue, I am happy to submit a fix to the net tree.

If the completely untested patch below does not work, you may also
dig the bits in include/json_print.h and lib/json_print.c 

(Ccing Stephen as the unidentified "both" in README.devel)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index d787eb91..70098bcd 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -1275,11 +1275,11 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 		fprintf(stderr, "divisor and hash missing ");
 	}
 	if (tb[TCA_U32_CLASSID]) {
+		char *fmt = !sel || !(sel->flags & TC_U32_TERMINAL) ? "*flowid %s" : "flowid %s";
 		SPRINT_BUF(b1);
-		fprintf(f, "%sflowid %s ",
-			!sel || !(sel->flags & TC_U32_TERMINAL) ? "*" : "",
-			sprint_tc_classid(rta_getattr_u32(tb[TCA_U32_CLASSID]),
-					  b1));
+
+		print_string(PRINT_ANY, "flowid", fmt,
+			    sprint_tc_classid(rta_getattr_u32(tb[TCA_U32_CLASSID]), b1));
 	} else if (sel && sel->flags & TC_U32_TERMINAL) {
 		print_string(PRINT_FP, NULL, "terminal flowid ", NULL);
 	}

-- 
Ueimor
