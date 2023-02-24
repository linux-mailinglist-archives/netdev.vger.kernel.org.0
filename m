Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A736A213C
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBXSLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBXSLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:11:48 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28A46695E
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:46 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1720600a5f0so349634fac.11
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BJqW6AMdL39TWiQEW5SFi4gWGGlM0+xAnx9lZTSkds=;
        b=trVV2u3Xew1BZAdI6ahsgu8bopseE1fZuq7kNJye6a64JgvWttRRCGZrVPiDf+/XHh
         C4ltYLVzuqKPB8kPvNWux9cj7VkaSzYnMiqMUaH+x49L2hFEHdV66G882qnJcCIgYGAc
         01zJANScvsQH8ueN29LjZu2H2eF1xFJOKk+AiB8Pi1hg8tbrhZsAPy7AIwTRLd5C6vlV
         Y8svWdDjyjshJzXU29lbM752OWVz18r3e2zMjouQqXu0tMHcDEnY75cTRuTnpxVHTFUk
         BLrl25n3LVkRcLu5RW0T5p5fK1znbO736GtjUwWr1WJF2xWhoaKqxzijPRNEYL5fQ3+0
         Fong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7BJqW6AMdL39TWiQEW5SFi4gWGGlM0+xAnx9lZTSkds=;
        b=QWJjmapqSjPO7+KGecEZZzM8Dhe4izxIjNRA/Yg/qQupp/X/OqBVXTvqY/DKmjUwOa
         EzJEqfx6XQahEgggyiIx8bSd7h9S+BTTaS4+s10HUrL4DCxrAoqNa4vQrRwHAQVicSqx
         AQioHmyDDo098M4B+uVJzhzCRxBpEn4WTWrEiH/bqYkzQUUhg1N8jIeR/lBKocM2sDZM
         RjMd7AF8eknaM0CxHiSAflR/M888cZi7E2/F2XsFIvAmZSt9l8zQhtn8w8ELcHe0Usnd
         grLn+4/v1WWm6uKM3K5nGRlfDAuZFcpjvdMdObpi77QEv93xBZrilBJY/N+YVwYr6GBw
         k89w==
X-Gm-Message-State: AO0yUKUzqPEcnitilSOKcVod6IgrX/xoqLPOcI0WLS5RYzBgZfh73xRj
        9P2npIRueSEglGePe8eC0bbEaOf/n0Y0AJ81
X-Google-Smtp-Source: AK7set/IWwt8h/qIH5IWE3I+/Z0gTEZjqsh9T7x+Drn+EZVOrVh6rb4fi+mWAzPq2uRZUiR+tJp0Tg==
X-Received: by 2002:a05:6870:9720:b0:16e:49fb:f78a with SMTP id n32-20020a056870972000b0016e49fbf78amr14690707oaq.39.1677262306086;
        Fri, 24 Feb 2023 10:11:46 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id y7-20020a9d5187000000b0068bb7bd2668sm4040827otg.73.2023.02.24.10.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:11:45 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 2/3] tc: m_mpls: parse index argument correctly
Date:   Fri, 24 Feb 2023 15:11:29 -0300
Message-Id: <20230224181130.187328-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224181130.187328-1-pctammela@mojatatu.com>
References: <20230224181130.187328-1-pctammela@mojatatu.com>
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

'action mpls index 1' is a valid cli according to TC's
architecture. Fix the grammar parsing to accept it.

tdc tests:
1..54
ok 1 a933 - Add MPLS dec_ttl action with pipe opcode
ok 2 08d1 - Add mpls dec_ttl action with pass opcode
ok 3 d786 - Add mpls dec_ttl action with drop opcode
ok 4 f334 - Add mpls dec_ttl action with reclassify opcode
ok 5 29bd - Add mpls dec_ttl action with continue opcode
ok 6 48df - Add mpls dec_ttl action with jump opcode
ok 7 62eb - Add mpls dec_ttl action with trap opcode
ok 8 09d2 - Add mpls dec_ttl action with opcode and cookie
ok 9 c170 - Add mpls dec_ttl action with opcode and cookie of max length
ok 10 9118 - Add mpls dec_ttl action with invalid opcode
ok 11 6ce1 - Add mpls dec_ttl action with label (invalid)
ok 12 352f - Add mpls dec_ttl action with tc (invalid)
ok 13 fa1c - Add mpls dec_ttl action with ttl (invalid)
ok 14 6b79 - Add mpls dec_ttl action with bos (invalid)
ok 15 d4c4 - Add mpls pop action with ip proto
ok 16 91fb - Add mpls pop action with ip proto and cookie
ok 17 92fe - Add mpls pop action with mpls proto
ok 18 7e23 - Add mpls pop action with no protocol (invalid)
ok 19 6182 - Add mpls pop action with label (invalid)
ok 20 6475 - Add mpls pop action with tc (invalid)
ok 21 067b - Add mpls pop action with ttl (invalid)
ok 22 7316 - Add mpls pop action with bos (invalid)
ok 23 38cc - Add mpls push action with label
ok 24 c281 - Add mpls push action with mpls_mc protocol
ok 25 5db4 - Add mpls push action with label, tc and ttl
ok 26 7c34 - Add mpls push action with label, tc ttl and cookie of max length
ok 27 16eb - Add mpls push action with label and bos
ok 28 d69d - Add mpls push action with no label (invalid)
ok 29 e8e4 - Add mpls push action with ipv4 protocol (invalid)
ok 30 ecd0 - Add mpls push action with out of range label (invalid)
ok 31 d303 - Add mpls push action with out of range tc (invalid)
ok 32 fd6e - Add mpls push action with ttl of 0 (invalid)
ok 33 19e9 - Add mpls mod action with mpls label
ok 34 1fde - Add mpls mod action with max mpls label
ok 35 0c50 - Add mpls mod action with mpls label exceeding max (invalid)
ok 36 10b6 - Add mpls mod action with mpls label of MPLS_LABEL_IMPLNULL (invalid)
ok 37 57c9 - Add mpls mod action with mpls min tc
ok 38 6872 - Add mpls mod action with mpls max tc
ok 39 a70a - Add mpls mod action with mpls tc exceeding max (invalid)
ok 40 6ed5 - Add mpls mod action with mpls ttl
ok 41 77c1 - Add mpls mod action with mpls ttl and cookie
ok 42 b80f - Add mpls mod action with mpls max ttl
ok 43 8864 - Add mpls mod action with mpls min ttl
ok 44 6c06 - Add mpls mod action with mpls ttl of 0 (invalid)
ok 45 b5d8 - Add mpls mod action with mpls ttl exceeding max (invalid)
ok 46 451f - Add mpls mod action with mpls max bos
ok 47 a1ed - Add mpls mod action with mpls min bos
ok 48 3dcf - Add mpls mod action with mpls bos exceeding max (invalid)
ok 49 db7c - Add mpls mod action with protocol (invalid)
ok 50 b070 - Replace existing mpls push action with new ID
ok 51 95a9 - Replace existing mpls push action with new label, tc, ttl and cookie
ok 52 6cce - Delete mpls pop action
ok 53 d138 - Flush mpls actions
ok 54 7a70 - Reference mpls action object in filter

Fixes: fb57b092 ("tc: add mpls actions")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tc/m_mpls.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 9b39d853..10a75885 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -91,6 +91,9 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 
 	NEXT_ARG();
 
+	if (matches(*argv, "index") == 0)
+		goto skip_args;
+
 	while (argc > 0) {
 		if (matches(*argv, "pop") == 0) {
 			if (check_double_action(action, *argv))
@@ -164,6 +167,7 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 
 	if (argc) {
 		if (matches(*argv, "index") == 0) {
+skip_args:
 			NEXT_ARG();
 			if (get_u32(&parm.index, *argv, 10))
 				invarg("illegal index", *argv);
-- 
2.34.1

