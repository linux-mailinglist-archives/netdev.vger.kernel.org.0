Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874AA6A4A1F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjB0Sp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjB0Sp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:45:26 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A00F206A7
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:45:22 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-172afa7bee2so8397286fac.6
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V79hfPVv5aggVgmCvEzVUBRka2O7KgaVtYeBcbClcE8=;
        b=uwuL3gsVDjDKDlmLFbBk5GOV//ITDZU+d1l8I4FQ+nNdEBedXI2HlQq/amy5L02WOC
         zHC4b2HcxdLF8ApgfBzgXZma7laFJoxWHGEK4ilXo6UUg4sNHSKr1xoc5AwekWL1Hvn6
         Ew/RPbo802Oy25SXUHZJEqa8va3rU1gLGUYtmFViaJ3aLD17eIPxkoX0rr6ieaRYuUfS
         l8c9rv6gxYPYVDYbvmhAOoG7RDaTqDU6ue3NYCYG5b+GnHno/Pcutu1Cc2AzDOyZ0EQx
         d7vxzuJ5lPW3SIXV0XRcMxiH534h9TfRxr0HcS4UB+TP6OlhU2gyqOwj74xdNGkFgYsi
         C1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V79hfPVv5aggVgmCvEzVUBRka2O7KgaVtYeBcbClcE8=;
        b=P8gtIGYG625Ub74mQwMU/MFqDCpi2uaoHTpdNKP13FhopCxtNGIcMYSXvYYEFvawt7
         a/06SBEvxQ7IAZyNChMGZkdTagP8qPqAGL/Qe1eHN1zzYyLNClpsxUs9MEk44Cx6lYjj
         3esGUCT3MFKxiDvzfCfrDhdTS6EpWirZV8fU51yFsE5YSecXLBws+SpqmSpqny+rMdPv
         ENr8QhiL0Bl8Vt3+5CV2VrCD3D/VdqgZi8dbIO1sc3to/8tLfI6hBeO3eCkyKi6WLADE
         pfHL0flodiicfrxGQIEkKNZKBGHY5SdrsEMonwQyZ6OnEf79qkYd79yVfaMar+PldidI
         4JBQ==
X-Gm-Message-State: AO0yUKX9zJzux8yps91CMOwuZozB93HGABL4HzS95nM4pHK9PJ4rJWES
        6Qv7DcTZux/rI77ILOcSZz7if/ZqaPztaPDG
X-Google-Smtp-Source: AK7set9iwYma6aRS20ZwKys1KA/PFBVnRXUFl/cupQ9pAZM2OhxlOZSXtu6MdRe0B47QQE1zCVZvhg==
X-Received: by 2002:a05:6870:391e:b0:16e:862:6085 with SMTP id b30-20020a056870391e00b0016e08626085mr21315325oap.16.1677523521675;
        Mon, 27 Feb 2023 10:45:21 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:4174:ef7a:c9ab:ab62])
        by smtp.gmail.com with ESMTPSA id b5-20020a05687061c500b001435fe636f2sm2492061oah.53.2023.02.27.10.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 10:45:21 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, stephen@networkplumber.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH iproute2 v2 1/3] tc: m_csum: parse index argument correctly
Date:   Mon, 27 Feb 2023 15:45:08 -0300
Message-Id: <20230227184510.277561-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227184510.277561-1-pctammela@mojatatu.com>
References: <20230227184510.277561-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'action csum index 1' is a valid cli according to TC's
architecture. Fix the grammar parsing to accept it.

tdc tests:
1..24
ok 1 6d84 - Add csum iph action
ok 2 1862 - Add csum ip4h action
ok 3 15c6 - Add csum ipv4h action
ok 4 bf47 - Add csum icmp action
ok 5 cc1d - Add csum igmp action
ok 6 bccc - Add csum foobar action
ok 7 3bb4 - Add csum tcp action
ok 8 759c - Add csum udp action
ok 9 bdb6 - Add csum udp xor iph action
ok 10 c220 - Add csum udplite action
ok 11 8993 - Add csum sctp action
ok 12 b138 - Add csum ip & icmp action
ok 13 eeda - Add csum ip & sctp action
ok 14 0017 - Add csum udp or tcp action
ok 15 b10b - Add all 7 csum actions
ok 16 ce92 - Add csum udp action with cookie
ok 17 912f - Add csum icmp action with large cookie
ok 18 879b - Add batch of 32 csum tcp actions
ok 19 b4e9 - Delete batch of 32 csum actions
ok 20 0015 - Add batch of 32 csum tcp actions with large cookies
ok 21 989e - Delete batch of 32 csum actions with large cookies
ok 22 d128 - Replace csum action with invalid goto chain control
ok 23 eaf0 - Add csum iph action with no_percpu flag
ok 24 c619 - Reference csum action object in filter

Fixes: 3822cc98 ("tc: add ACT_CSUM action support (csum)")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tc/m_csum.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tc/m_csum.c b/tc/m_csum.c
index ba1e3e33..f5fe8f55 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -94,7 +94,9 @@ parse_csum(struct action_util *a, int *argc_p,
 	while (argc > 0) {
 		if (matches(*argv, "csum") == 0) {
 			NEXT_ARG();
-			if (parse_csum_args(&argc, &argv, &sel)) {
+			if (strcmp(*argv, "index") == 0) {
+				goto skip_args;
+			} else if (parse_csum_args(&argc, &argv, &sel)) {
 				fprintf(stderr, "Illegal csum construct (%s)\n",
 					*argv);
 				explain();
@@ -123,6 +125,7 @@ parse_csum(struct action_util *a, int *argc_p,
 
 	if (argc) {
 		if (matches(*argv, "index") == 0) {
+skip_args:
 			NEXT_ARG();
 			if (get_u32(&sel.index, *argv, 10)) {
 				fprintf(stderr, "Illegal \"index\" (%s) <csum>\n",
-- 
2.34.1

