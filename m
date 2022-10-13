Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2EB5FDD3B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJMPcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJMPco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:32:44 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAA189CED
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:32:43 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h13so2268998pfr.7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wwbnh1ONXR3EI0jkuhvyOK1Ll93eGLUbOaiGxJkFRt8=;
        b=CpinfC3xMT0TJO2xjSrI5wIWR+PnIoJR2KVdpDOuAdypNgTYXYcaAtnxgolAbX2yJ+
         VFbPJ+jaatML7haUZlwHIsJrpOwPYVmwHMyyTmfs08ADsLWZXe4JkY0aP2IiFQpmDq3R
         cTeJ/R+5cclC1wavECUjNal/WN1hYiQugIVXtZvSrSuKk72xcB5Hlq0hxcJBCGnfYTLe
         8DFmPU3QGheFZwg9dj8H1ZYzFkEe4UQwCs/dOcSppCGwGHQNxdNM9BumgRGIPLIXNjxl
         MFHDyUqEaKo2h8iUQC3S2nfV1gnwOj7yzOSkIa4ImUAEhJucNHSTU4fE8GptzUc+4IVY
         rwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wwbnh1ONXR3EI0jkuhvyOK1Ll93eGLUbOaiGxJkFRt8=;
        b=J23lZjfxQDsPijmZJBzmRB36Nwaztf7lfl8mIp6iRkIqHs2GXb9FMvwta8c55Zca8H
         B4k74MRa3RMgTj3ePia7Lo/OfWf+2zv9dyE8BwTnGiKWSNDF/4bfkAvE4kpwFNL3Ybn4
         HLk26/cjJrHefDmutpavnUpddq1YyOGdVhD3gWoNhZ8a+B97h8aDx+/+pN5ZBWMWDS5s
         agtIhyTQ8pzYAB6hLSxE7cY69ch0KGq9LqjlJDIIpck/asS/YpSddlKOUSq6G+ZRFvbF
         4nBBYSHB4u5aEO3sC89AfCDtxyXUZVW00qgieIaXBUIyVam7Hm0U67EtfjZKqEpguQKe
         KB4w==
X-Gm-Message-State: ACrzQf3m4olFMJBT6+rR5bdVGWMucD4eI7dnX2KzVDpJAjtb33+1xGoR
        ij33sWIZ90Mk9vM/Ktl6xagejlwyN+oWOA==
X-Google-Smtp-Source: AMsMyM48H8EYISnVl6cAkRcfY7L+dTg2vjuJOonYlCZYTqOVIS5AMiK+jaKViNQ+ot2rl4qgo3pAVw==
X-Received: by 2002:a05:6a00:248e:b0:563:7910:29b9 with SMTP id c14-20020a056a00248e00b00563791029b9mr50494pfv.43.1665675162610;
        Thu, 13 Oct 2022 08:32:42 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p4-20020a637f44000000b0043954df3162sm11676298pgn.10.2022.10.13.08.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:32:42 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Christian=20P=C3=B6ssinger?= <christian@poessinger.com>
Subject: [PATCH iproute2] u32: fix json formatting of flowid
Date:   Thu, 13 Oct 2022 08:32:40 -0700
Message-Id: <20221013153240.108340-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <f4806731521546b0bb7011b8c570b52b@poessinger.com>
References: <f4806731521546b0bb7011b8c570b52b@poessinger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code to print json was not done for the flow id.
This would lead to incorrect JSON format output.

Reported-by: Christian Pössinger <christian@poessinger.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/f_u32.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index d787eb915603..e4e0ab121c57 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -1275,12 +1275,14 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 		fprintf(stderr, "divisor and hash missing ");
 	}
 	if (tb[TCA_U32_CLASSID]) {
+		__u32 classid = rta_getattr_u32(tb[TCA_U32_CLASSID]);
 		SPRINT_BUF(b1);
-		fprintf(f, "%sflowid %s ",
-			!sel || !(sel->flags & TC_U32_TERMINAL) ? "*" : "",
-			sprint_tc_classid(rta_getattr_u32(tb[TCA_U32_CLASSID]),
-					  b1));
-	} else if (sel && sel->flags & TC_U32_TERMINAL) {
+		if (sel && (sel->flags & TC_U32_TERMINAL))
+			print_string(PRINT_FP, NULL, "*", NULL);
+
+		print_string(PRINT_ANY, "flowid", "flowid %s ",
+			     sprint_tc_classid(classid, b1));
+	} else if (sel && (sel->flags & TC_U32_TERMINAL)) {
 		print_string(PRINT_FP, NULL, "terminal flowid ", NULL);
 	}
 	if (tb[TCA_U32_LINK]) {
-- 
2.35.1

