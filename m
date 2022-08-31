Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E445A7E20
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiHaM65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiHaM6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:58:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E65FA98EA
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:58:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n8-20020a17090a73c800b001fd832b54f6so12253805pjk.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=iGILs1Z/ug57WB4JrphIpzgDfHBe9gl30ieBlpx6SJY=;
        b=GxzqbovCvzc3V8xpGR3Gw7XfB8e+nCtasC3Pj8pDTLyClF/ylpUjMjbkXAEL3Ymm4g
         rY0TkDpt+I44GAHez3AYDY/5JVb5W6Vr/h9Yjazrw2BHsZPHAmMhBZKu0wbLaao6Ubvc
         ejsdxR0Fb3v+6o8t14YxyuIcitxG8/WPPR4muEr3pdBEgYGs0Xa3fNqByTaynrBiolxC
         AluM/PV/4oL2PKGTg87vCscaGWP1kxI9m8GKmvzupsD80OU5pgf/WTXSfqMn6aYh6b0n
         /93NiNrG+y1ii8Ae4YO2w2pZfIU49JkEnT5ArNTxTQwfVFM+3ig5aD29xSACTv2r2BaI
         EbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=iGILs1Z/ug57WB4JrphIpzgDfHBe9gl30ieBlpx6SJY=;
        b=jDjznuwCMXpAZ9MtbY1dbubBmoigNk7lRS4N+sX7iZDWxEa5zjRXCwPxexOe5SDofx
         oJr+wvT9utvatP6hvEG6Zn7NHuvucevqQVSVr04zsGPNPSvtrFunEIzZmOZWuufTSEPP
         qENF4uJuYGoXWqwi6Nc0VL3MZHJ4Z83Ilb4Ry+6NCtJLiaoTi81THHRDxHRug6sHF1Fc
         UBpYf8fZRkkBX6MZ21gN9q8d6bwN/9tGjQjeydRu52Mq25UMstTqzi3VQj18b09hs3KJ
         nBf2HxIo5ek2eRu5rHJDqpEb8FJZrSCtKIiTJjQlmBd72Yc/V7RFSolQ7ecvJ85h/WZJ
         0YjQ==
X-Gm-Message-State: ACgBeo2iqxGPmWGSAKUctdXFXWuFmX4Zi3f/Y9B/BsAIQ6buZg9N41/P
        3BJKIwt149fQsIOsBRRGcDHSREMhhAw39UX+
X-Google-Smtp-Source: AA6agR4MIRLKV1c5HoctVeIlP6dllKywyO6j24vtsXRqJwUhweBurJCi2ebGfYwV9ReaUgI3jrd/0w==
X-Received: by 2002:a17:90b:380e:b0:1fe:8e4:96be with SMTP id mq14-20020a17090b380e00b001fe08e496bemr3174861pjb.18.1661950731583;
        Wed, 31 Aug 2022 05:58:51 -0700 (PDT)
Received: from 5-19.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id d22-20020a656216000000b0042ba0a822cbsm3285265pgv.8.2022.08.31.05.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 05:58:50 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH] net: rtnetlink: use netif_oper_up instead of open code
Date:   Wed, 31 Aug 2022 21:58:45 +0900
Message-Id: <20220831125845.1333-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The open code is defined as a new helper function(netif_oper_up) on netdev.h,
the code is dev->operstate == IF_OPER_UP || dev->operstate == IF_OPER_UNKNOWN.
Thus, replace the open code to netif_oper_up. This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 net/core/rtnetlink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4b5b15c684ed..f5e87fe57c83 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -866,14 +866,12 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
 		break;
 
 	case IF_OPER_TESTING:
-		if (operstate == IF_OPER_UP ||
-		    operstate == IF_OPER_UNKNOWN)
+		if (netif_oper_up(dev))
 			operstate = IF_OPER_TESTING;
 		break;
 
 	case IF_OPER_DORMANT:
-		if (operstate == IF_OPER_UP ||
-		    operstate == IF_OPER_UNKNOWN)
+		if (netif_oper_up(dev))
 			operstate = IF_OPER_DORMANT;
 		break;
 	}
-- 
2.34.1

