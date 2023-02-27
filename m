Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00596A4A21
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjB0Spf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjB0Spd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:45:33 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622B51EBC0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:45:26 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1729bdcca99so8357789fac.12
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbOduyy9UFioZZzQFr3TgrNDEm6j0qB8Gmzagal905k=;
        b=PBM3RXYCRjETfL7TaDU6JB0VYg954v5xDZstMUretEnL5qBf7fQNgICMPLHH2e7zgN
         imnlOwZrPKz5pogP9e292wU4MhfpcKfW6fsQ2emInG5XN7RmY6fwhsJCAiWCMbM1FCEC
         cgBtT6BP89xJprjG+TB+vX/6kO+w9DSb20WvXqJJdJDBt5zE0+WOmlyHkaAqltJUjLvN
         fH1sy+dNytNBGT8lW5ps1f1i73JAdkO37/VO1eShcLlAHG0sENcPVh70t7u0FVs2kiBj
         J2PzOMugV+bX0GiZu7Syo7vAyYMdrEU7Sla4+5aEjR0izrsKsifT9H3SPlvFoG0vPFf/
         /7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BbOduyy9UFioZZzQFr3TgrNDEm6j0qB8Gmzagal905k=;
        b=rsTGk2SjUnpHAjRzjtJLuZybAb/SpgpVO7WiJECzQP8subbv95HUt5fUIKqROLFIty
         MrPBOPShBx36dQXQUDBMu1ni0/TlQ7KJXgTPHgjKQaflQNgJXvXefdNhPlG4x3ZZfDwn
         Mp5oow8FhKCAvHUtXYE8nZEuJwuvWIiQ1nNx5bWGQGSIC+NXvqVBPe8OITt8CUEbI+SV
         zBHK28Ppx6R/Qvuh8fgIH3NFdjfMUL7O43MazKnVZqtoM2L+vb6PG2fNP9VyWOU5579b
         gt9m97egp+WlSkn8qRx2IuIFq0KLZCdvTb9Q5FWTbt51LYIeLgHVJMeRB65TvLXpDRlk
         FLNQ==
X-Gm-Message-State: AO0yUKUoRJ3J7XIFhtIAo2DoRgOxEROYPunQ1boGuukytBwKTfqMEW1g
        0oZR3EYYtlt5XY7Ee34PDsmydoA2UeuCQEvD
X-Google-Smtp-Source: AK7set9HNN9WkQDwq5ooVhnr2sp+QcDMbDE8QKrkWvKZgViOXJC2oWlAwz30FCW3K2LFApv1JsMp+Q==
X-Received: by 2002:a05:6870:524a:b0:171:9702:8ec with SMTP id o10-20020a056870524a00b00171970208ecmr19629533oai.32.1677523525647;
        Mon, 27 Feb 2023 10:45:25 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:4174:ef7a:c9ab:ab62])
        by smtp.gmail.com with ESMTPSA id b5-20020a05687061c500b001435fe636f2sm2492061oah.53.2023.02.27.10.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 10:45:25 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, stephen@networkplumber.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH iproute2 v2 3/3] tc: m_nat: parse index argument correctly
Date:   Mon, 27 Feb 2023 15:45:10 -0300
Message-Id: <20230227184510.277561-4-pctammela@mojatatu.com>
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

'action nat index 1' is a valid cli according to TC's
architecture. Fix the grammar parsing to accept it.

tdc tests:
1..28
ok 1 7565 - Add nat action on ingress with default control action
ok 2 fd79 - Add nat action on ingress with pipe control action
ok 3 eab9 - Add nat action on ingress with continue control action
ok 4 c53a - Add nat action on ingress with reclassify control action
ok 5 76c9 - Add nat action on ingress with jump control action
ok 6 24c6 - Add nat action on ingress with drop control action
ok 7 2120 - Add nat action on ingress with maximum index value
ok 8 3e9d - Add nat action on ingress with invalid index value
ok 9 f6c9 - Add nat action on ingress with invalid IP address
ok 10 be25 - Add nat action on ingress with invalid argument
ok 11 a7bd - Add nat action on ingress with DEFAULT IP address
ok 12 ee1e - Add nat action on ingress with ANY IP address
ok 13 1de8 - Add nat action on ingress with ALL IP address
ok 14 8dba - Add nat action on egress with default control action
ok 15 19a7 - Add nat action on egress with pipe control action
ok 16 f1d9 - Add nat action on egress with continue control action
ok 17 6d4a - Add nat action on egress with reclassify control action
ok 18 b313 - Add nat action on egress with jump control action
ok 19 d9fc - Add nat action on egress with drop control action
ok 20 a895 - Add nat action on egress with DEFAULT IP address
ok 21 2572 - Add nat action on egress with ANY IP address
ok 22 37f3 - Add nat action on egress with ALL IP address
ok 23 6054 - Add nat action on egress with cookie
ok 24 79d6 - Add nat action on ingress with cookie
ok 25 4b12 - Replace nat action with invalid goto chain control
ok 26 b811 - Delete nat action with valid index
ok 27 a521 - Delete nat action with invalid index
ok 28 2c81 - Reference nat action object in filter

Fixes: fc2d0206 ("Add NAT action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tc/m_nat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tc/m_nat.c b/tc/m_nat.c
index 58315125..95b35584 100644
--- a/tc/m_nat.c
+++ b/tc/m_nat.c
@@ -88,7 +88,9 @@ parse_nat(struct action_util *a, int *argc_p, char ***argv_p, int tca_id, struct
 	while (argc > 0) {
 		if (matches(*argv, "nat") == 0) {
 			NEXT_ARG();
-			if (parse_nat_args(&argc, &argv, &sel)) {
+			if (strcmp(*argv, "index") == 0) {
+				goto skip_args;
+			} else if (parse_nat_args(&argc, &argv, &sel)) {
 				fprintf(stderr, "Illegal nat construct (%s)\n",
 					*argv);
 				explain();
@@ -113,6 +115,7 @@ parse_nat(struct action_util *a, int *argc_p, char ***argv_p, int tca_id, struct
 
 	if (argc) {
 		if (matches(*argv, "index") == 0) {
+skip_args:
 			NEXT_ARG();
 			if (get_u32(&sel.index, *argv, 10)) {
 				fprintf(stderr, "Nat: Illegal \"index\"\n");
-- 
2.34.1

