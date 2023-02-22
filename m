Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628D069F9A8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 18:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjBVRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 12:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjBVRJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 12:09:40 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA1120D1B;
        Wed, 22 Feb 2023 09:09:39 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id fp16so8194781qtb.10;
        Wed, 22 Feb 2023 09:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iBcq0pmdAn/4XG8y13P0hgBjKjCgMSw8ZQ/buDOWOcQ=;
        b=Ecisn3UPa5hbrjZq8naUJ19FdbaKZfJv+4vT343wn7TCgqsXpRVQO8sdQu00WlyeHZ
         myWJHj1VnX5owpSgg/shf2m9g8ng01QFyeCWAntXVnJBFADkVk1yd0oyPxsNhSvqOHzV
         pHt9B2SLuLw7gzeX0il8kGSVzAsRTu4PBFdZJ68HmYNXgYicb605rw4p2dBvQjlmHUH9
         RQq1Od3iuImF2AKc6VC8akbpvbTb8QL36idiYs0N0ucl6fBwjn5lGW6pgX5xMUd5qJ5k
         NEkN8b/NafOKRuXDUDfQd7PvCal+Ls9rijvpqxMuIvoc4kLbV3ttYOdkqD/IDE8UUKW+
         s30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iBcq0pmdAn/4XG8y13P0hgBjKjCgMSw8ZQ/buDOWOcQ=;
        b=b7es7fVKOxv5Puu1cBy6RfMb7BG+Ly//2okXsn6jqUqs4TNFVM2elG1UAMN7rDDJrJ
         cBTB5TCQA/OOXunZHrDrkXGZ79f5Lys9k9BKRophBlqn7BcYL/SKqWemtG42q/KOt44h
         UWwb9rgInYPQmulO1vqgK1pcgrFNbD/o5NBXoZJpnLW/Fr7efOFqv8vC2kam5MHOx0JJ
         6tSSMCgH63twEVq5JO+JTlUgiIwTzY1Vni26csb+nlcym0yHBWtuZUa4xUkUYlgC8UuB
         K6aKj7co3qte9COi6WQlY62te1ilDGZgT4wYeVvsskr0r8+qyZcFK973Th+RK08qOFsK
         SW/g==
X-Gm-Message-State: AO0yUKVQgvR1F1J0dBJ3tQkJ+29sc/rK9pN8GdkkT0ts9V3zOHG5v91E
        KB2ViaVaHKte+nF6U+hb4pg=
X-Google-Smtp-Source: AK7set8hnf9n6oN7lBKzmccUzRS7VG7Q6re6nuyehgVa8mijSeEfP+U5mo3VUWW5lKy5O/daqXOPRg==
X-Received: by 2002:a05:622a:414:b0:3ba:247a:3fbc with SMTP id n20-20020a05622a041400b003ba247a3fbcmr1183592qtx.39.1677085778299;
        Wed, 22 Feb 2023 09:09:38 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id s190-20020a372cc7000000b007422fa6376bsm2484074qkh.77.2023.02.22.09.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 09:09:37 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH net] net: sunhme: Return an error when we are out of slots
Date:   Wed, 22 Feb 2023 12:09:35 -0500
Message-Id: <20230222170935.1820939-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only allocate enough space for four devices when the parent is a QFE. If
we couldn't find a spot (because five devices were created for whatever
reason), we would not return an error from probe(). Return ENODEV, which
was what we did before.

Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1c16548415cd..523e26653ec8 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2861,12 +2861,13 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
 			if (!qp->happy_meals[qfe_slot])
-				break;
+				goto found_slot;
 
-		if (qfe_slot == 4)
-			goto err_out;
+		err = -ENODEV;
+		goto err_out;
 	}
 
+found_slot:
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
 	if (!dev) {
 		err = -ENOMEM;
-- 
2.37.1

