Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D7063F413
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiLAPfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiLAPfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:35:25 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B11AD318
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:34:54 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so2400360pjd.5
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 07:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZ7ExXYGuSnqxV4+OsNKAmzbd32U+Wf+ypY7SnVru/A=;
        b=Ihsr5G6X/t4KDGlX0DECRIDUKE5M53bmpFtDFYJZ6az8x/MIWPyD27BL/PWNt9EB78
         nbrUQV2O7qVCovwLls8OeL/bvItk871GzQDaO7sFPjd30LdfVmBtSgkjtTolHTe/pxBy
         AB86PWhuNQrQ9zlrPkrMtw4a0bwcbwaoI12YbZ2Aaqqt1U8m2ERRkLe3VXS2AJGdLYe0
         IWcRkPVW9/BXgSw2P0ckPR+dYPnIMIPME+J6ODVD0Hp9eZs8sWkxQsVVeuqZW41vf+o9
         to8r2e7lW4kYEiqMs164nW1aZTYZqktSgAVWpzveJvSkdglg9+gwDmungebmmgD5Caet
         9gxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZ7ExXYGuSnqxV4+OsNKAmzbd32U+Wf+ypY7SnVru/A=;
        b=utwAtzX1TURdD16yo4jeHRdYsVbmA0geKWRscHJZ1nBxH1Oi3PDuLE4N6/GW1OyJu9
         DrjKR92Fe1u9g9VIS3SIa87DuSvo0wRHoKCEwWmXMmR4/wl83jLtRSo3FwRMnxHY6RCg
         6yaYjn1mTb1/2qgYBLafdHE1KrJ0w5HgmDBEHqwHqGGcUEeSs7fs0dppUHpdjoccEVv6
         8bA4wHWjpoGnjiXeb+RCo/IgFX6Ur9Qyn4R4L351xi+uJpWJkc4UZn+pmDtIO9xmKyxg
         9N7QtkdAJOrkM1jN0O0krbHeikvEyoTnL5tchi3eskF75tRxyX8f7TzIhm+/WxjVKtHe
         uSJg==
X-Gm-Message-State: ANoB5pmJmHw7eWJoP6QUDSXLoQkNhX6of1X1nZM1IjfPmlynV81I11hR
        b5gi0RxXutPNcX/Cq87d3d4cDOrMf/9OdEmB
X-Google-Smtp-Source: AA0mqf7pjxrsQqMtpTuv6ScNW/N5plGlMU9D1vZHumUjnx1PDihWYLmP66wiVaJD8mMyhHZL2T0TkQ==
X-Received: by 2002:a17:90b:4ccd:b0:218:b47b:9b69 with SMTP id nd13-20020a17090b4ccd00b00218b47b9b69mr54728319pjb.240.1669908894202;
        Thu, 01 Dec 2022 07:34:54 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090341cb00b001896af10ca7sm3813791ple.134.2022.12.01.07.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 07:34:53 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?q?Christian=20P=C3=B6ssinger?= <christian@poessinger.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] tc/basic: fix json output filter
Date:   Thu,  1 Dec 2022 07:34:50 -0800
Message-Id: <20221201153450.30481-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <e1fa5169db254301bc3b5b766c2df76a@poessinger.com>
References: <e1fa5169db254301bc3b5b766c2df76a@poessinger.com>
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

The flowid and handle in basic were not using JSON routines to print.
 To reproduce the issue:

 $ tc qdisc add dev eth1 handle ffff: ingress
 $ tc filter add dev eth1 parent ffff: prio 20 protocol all u32 match ip dport 22 \
     0xffff action police conform-exceed drop/ok rate 100000 burst 15k flowid ffff:1

 $ tc filter add dev eth1 parent ffff: prio 255 protocol all basic action police \
     conform-exceed drop/ok rate 100000 burst 15k flowid ffff:3

Reported-by: Christian Pössinger <christian@poessinger.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/f_basic.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tc/f_basic.c b/tc/f_basic.c
index 9a60758e803e..9055370e90b9 100644
--- a/tc/f_basic.c
+++ b/tc/f_basic.c
@@ -119,19 +119,22 @@ static int basic_print_opt(struct filter_util *qu, FILE *f,
 	parse_rtattr_nested(tb, TCA_BASIC_MAX, opt);
 
 	if (handle)
-		fprintf(f, "handle 0x%x ", handle);
+		print_hex(PRINT_ANY, "handle",
+			  "handle 0x%x ", handle);
 
 	if (tb[TCA_BASIC_CLASSID]) {
+		uint32_t classid = rta_getattr_u32(tb[TCA_BASIC_CLASSID]);
 		SPRINT_BUF(b1);
-		fprintf(f, "flowid %s ",
-			sprint_tc_classid(rta_getattr_u32(tb[TCA_BASIC_CLASSID]), b1));
+
+		print_string(PRINT_ANY, "flowid", "flowid %s ",
+			     sprint_tc_classid(classid, b1));
 	}
 
 	if (tb[TCA_BASIC_EMATCHES])
 		print_ematch(f, tb[TCA_BASIC_EMATCHES]);
 
 	if (tb[TCA_BASIC_POLICE]) {
-		fprintf(f, "\n");
+		print_nl();
 		tc_print_police(f, tb[TCA_BASIC_POLICE]);
 	}
 
-- 
2.35.1

