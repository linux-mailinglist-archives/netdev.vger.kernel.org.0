Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E916A213D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBXSL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBXSLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:11:53 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A19767980
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:48 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1729bdcca99so344087fac.12
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wHrLAVhse45kRLq3ikoHh9ZeIZ/I2OA8vMLZ/L3UKA=;
        b=xVyGwpCjYQvrHiFTK0BiN59D2vhoEU5ijqMWZJ8V9loXLgRLPyZU99lE21MTymHCBZ
         a6cS+jPFRO6oEoV+4X2zyjeHCk/4Z0uEfd0LPK2PM4l+OmPp9VzxxIW/KHGgljZurps9
         pzPm3MTdIHGDeR5Toq+BXUFpvLskpcBLTftOjlCz7PbWlAdgYMGwc+hD19TEsVe2tH1v
         ab/7hxK3SG5guUORgK4m8g7/pqaqkU9BJv4ZpYxC0R/N4PagfOdxsVgCGEoQzxz9Eo0t
         Urc9AOX059bVEQ33kDb/FBSDw61kobXaA+FyXiHG2dU93QAmU6Mzmr0qJzqtqenxkQ84
         htdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0wHrLAVhse45kRLq3ikoHh9ZeIZ/I2OA8vMLZ/L3UKA=;
        b=1oimqXNYA2FAenipGBjQF4h1yj2l2c3GDzHQz7KLT2Y3ZkAjEFBd9qrrKlgeX4iGkI
         /f+icHvXTJZBML03VWiM8R9lCtk2ul7/MCOCvSzzv7NRJEpROlR4hlfw/FtlG/ZNxbEl
         1SQr7XCEmKYFdFmjdBAkBiEGQ6nndZ7i4nCB12VzY0Aof8IABH1JRyQh11DZxzYhm0Ki
         XZ1GKxrcTqalDjoYiM1I5qKR+MH/kOb4lO3R06THAzYd7DeLk+BbfZ8tMo8QClJrg/iM
         bnHTPxM+Q8/U9t9pL+xy2sog9GdQFpzla6lZOnQBOIv6qO2tlxZnGjkieMFRPwo26gu7
         LCBw==
X-Gm-Message-State: AO0yUKW8QNlVNK2ALYoMFeZ0nzJAUSzEMuy+HZN+APS4BJ82flu3zVms
        /fDn0ARGF67uqp3cQgOrainM9E/RMGA1zMWY
X-Google-Smtp-Source: AK7set+1uFoctGDv8ylIXefwy5ZqXZcDA58WPhZxz71PrWCFu8yIcv5cQTssDuqrxdgO6jikbR5frA==
X-Received: by 2002:a05:6870:61cc:b0:15b:8c60:52de with SMTP id b12-20020a05687061cc00b0015b8c6052demr15209968oah.42.1677262307653;
        Fri, 24 Feb 2023 10:11:47 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id y7-20020a9d5187000000b0068bb7bd2668sm4040827otg.73.2023.02.24.10.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:11:47 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 3/3] tc: m_nat: parse index argument correctly
Date:   Fri, 24 Feb 2023 15:11:30 -0300
Message-Id: <20230224181130.187328-4-pctammela@mojatatu.com>
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
index 58315125..722575c7 100644
--- a/tc/m_nat.c
+++ b/tc/m_nat.c
@@ -88,7 +88,9 @@ parse_nat(struct action_util *a, int *argc_p, char ***argv_p, int tca_id, struct
 	while (argc > 0) {
 		if (matches(*argv, "nat") == 0) {
 			NEXT_ARG();
-			if (parse_nat_args(&argc, &argv, &sel)) {
+			if (matches(*argv, "index") == 0) {
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

