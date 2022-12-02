Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8A26403E1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiLBJ6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiLBJ6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:58:36 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B847D9855D;
        Fri,  2 Dec 2022 01:58:33 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o7-20020a05600c510700b003cffc0b3374so3874952wms.0;
        Fri, 02 Dec 2022 01:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BWSIvQT615Lxx3SW2gsJZM1lgPmuBtNCLkFLBWYmSgs=;
        b=Hh0Y4ITWHxUxcZ88wjU1cia5cd5bxhtvliLbDQinQDN+NlVOnpBcz6SgoTD+UQ82fk
         aFutl0kVC0K4d6TfFWW8imi3ywMY0OcX4nPrGlbyuyZ9yTdTG2bR6/tG8cIaKDqCvEL1
         z++dfJ787mgY3BrexXJnJLU/BiyIUczIEn5JQ1uCUo+nXdGwoNI+UewQYtxog43ZqHgm
         NTbrT0R4F2L1ocJzbL4CbI1ioRY91wIpfdSQsXVotAjCVU/Um69aUas1w3GXXCDAvv60
         FLnZRqzcwU3F5vAhXZQFQl/2Ur79Xnd9BFWEoDJnkx78HdVGH830G8Th/RujvyLKWd/B
         G/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWSIvQT615Lxx3SW2gsJZM1lgPmuBtNCLkFLBWYmSgs=;
        b=Hr4rkFAOAaqT+JGx118pUlP5KJhaWNxvKMyufxnC8bvE40UL/F2VYKTez5ejS8K9+Y
         1QiwHIh70Ng2mvH/uL38Tft2UhdNu/D+Ec1ejMEhnaURwoTGv4PcpDc5MCRGUz4Ib+Dm
         eFzhsBMbQ1l8446eR71CSYk6Opnd+bC6pxFp/dRMM10QPxRnPBNAhCxyi4IqH2kvci1m
         SgvQRt/Xzv6oWCnebps/D/TnANl/qCtxyp9oAdb6jj/G1loQxlFMoX0AsyPVnHqf2eEH
         GZqBO+h9YxyLgfWw0WfvYWFEy1YEvvYr/2UDyTAVMrJdJ+TaX6eK7h8L/3tRn0ZmQBsN
         LENQ==
X-Gm-Message-State: ANoB5pmLknF1T1ZBZ1ypSNCBNzwgJyxJT7S4hQPl2y0WSRd/+hSNkNAi
        HsEhMFM82dhxK5qT8XdglYc=
X-Google-Smtp-Source: AA0mqf48uxe4cwZTr683xZ3RgC1ZEeH9ELSF5+T3a3WnasVK5/pBPbNEhlJbswzbp2sasiwlasVB+g==
X-Received: by 2002:a05:600c:538b:b0:3b4:7e87:895f with SMTP id hg11-20020a05600c538b00b003b47e87895fmr51966112wmb.30.1669975112217;
        Fri, 02 Dec 2022 01:58:32 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r11-20020a05600c35cb00b003a84375d0d1sm12880466wmq.44.2022.12.02.01.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 01:58:31 -0800 (PST)
Date:   Fri, 2 Dec 2022 12:58:26 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: mvneta: Prevent out of bounds read in
 mvneta_config_rss()
Message-ID: <Y4nMQuEtuVO+rlQy@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pp->indir[0] value comes from the user.  It is passed to:

	if (cpu_online(pp->rxq_def))

inside the mvneta_percpu_elect() function.  It needs bounds checkeding
to ensure that it is not beyond the end of the cpu bitmap.

Fixes: cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c2cb98d24f5c..5abc7c3e399e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4927,6 +4927,9 @@ static int  mvneta_config_rss(struct mvneta_port *pp)
 		napi_disable(&pp->napi);
 	}
 
+	if (pp->indir[0] >= nr_cpu_ids)
+		return -EINVAL;
+
 	pp->rxq_def = pp->indir[0];
 
 	/* Update unicast mapping */
-- 
2.35.1

