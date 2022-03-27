Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827724E8680
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 09:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiC0Hbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 03:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiC0Hbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 03:31:35 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3392ED6F;
        Sun, 27 Mar 2022 00:29:56 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p17so12205462plo.9;
        Sun, 27 Mar 2022 00:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ePlxqAE5iGrFihA2Q4Z4ld5wSFajhQzdLqDAPiSBsk4=;
        b=Evt4NNs0BTMwVQkUI61ueB1M/Lp4wgh3d9ssAylr2GTHRb4SCiGqNTNQaWFCQ2LO5T
         LhH8IibqV+HR0Lv8U8CujAm3KZCojw3tFUjpXGun6a9oPciLP6kLw0ZtFoLlcImTMVqi
         Jv8GO2mEQ5klK7/FpCPQ7G3sfLknjxZLQ5HKIhOVdany6QYAhejU0TvPbWge6/l3dy9f
         +ljbSp43tAiXwRur3Zduit3ZdJcTVKdXFrXSPDqg49kLqXNhP6jsJap7qh0delN0SxWR
         QonM92MO6icYylGqlUc1T1d+riKh63AY1NA24+3IhSRHnZZd2WFq0eIMJLO1yJxw/W2v
         Xt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ePlxqAE5iGrFihA2Q4Z4ld5wSFajhQzdLqDAPiSBsk4=;
        b=oZdmWrIexYGwSSH9RN6mfOFiiHLlZXZbeBeIbPylHGRhcQwtTWBBUY+Br2bL0Uw+HK
         KxsYpPlHUpA9BAyl/YlU/t/YWi16JCfCBI+Qyc5PQbdRTusb43Yw7vJMLuD4eulvTeqQ
         jCZB27A/wDfTpyEMJQkS3nNcYZHqT0WD9vIp0oH9HeYWa9q6Jf3Xh1PSuqWk7UR1f79e
         FTAtkLCJb8AaIVfGP4iREt0vIHKKZ7ay4D/nH8XPQiK1L+6Li6lgo0gRL93yHySwo6Jc
         FnF97Kr2gGyjmZnsRztHBWAIwlA3aaHsKzFSGJdx1bxOqtFvYaOyOC5bkBpKNpF4zaqO
         BI8Q==
X-Gm-Message-State: AOAM531IZHYA3+ozBNip0KOzHC6PcCjDElGgaFSE0DKt7I98yoGT3Sv2
        Vq5zVZzR8PDI/BgFOqSCMLM=
X-Google-Smtp-Source: ABdhPJyL7QeVlRrSiJPqXJwQUGj7PUQasYUfIXXGoyaA4BakL6WTboFLrrvrnjP2cZDCm3tu/mOb0Q==
X-Received: by 2002:a17:90b:1b4e:b0:1c6:fff4:34dc with SMTP id nv14-20020a17090b1b4e00b001c6fff434dcmr34403014pjb.76.1648366196343;
        Sun, 27 Mar 2022 00:29:56 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id c9-20020a056a00248900b004fb05c0f32bsm8431909pfv.185.2022.03.27.00.29.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:29:55 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] carl9170: tx: fix an incorrect use of list iterator
Date:   Sun, 27 Mar 2022 15:29:47 +0800
Message-Id: <20220327072947.10744-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the previous list_for_each_entry_continue_rcu() don't exit early
(no goto hit inside the loop), the iterator 'cvif' after the loop
will be a bogus pointer to an invalid structure object containing
the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
will lead to a invalid memory access (i.e., 'cvif->id': the invalid
pointer dereference when return back to/after the callsite in the
carl9170_update_beacon()).

The original intention should have been to return the valid 'cvif'
when found in list, NULL otherwise. So just make 'cvif' NULL when
no entry found, to fix this bug.

Cc: stable@vger.kernel.org
Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/wireless/ath/carl9170/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 1b76f4434c06..2b8084121001 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1558,6 +1558,9 @@ static struct carl9170_vif_info *carl9170_pick_beaconing_vif(struct ar9170 *ar)
 					goto out;
 			}
 		} while (ar->beacon_enabled && i--);
+
+		/* no entry found in list */
+		cvif = NULL;
 	}
 
 out:
-- 
2.17.1

