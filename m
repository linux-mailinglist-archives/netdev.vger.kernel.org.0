Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2112F75CE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbhAOJss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbhAOJsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:48:46 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D86C061796;
        Fri, 15 Jan 2021 01:48:13 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p18so5651122pgm.11;
        Fri, 15 Jan 2021 01:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=A+I0MIghGu/sRDrDxSDK4hlZ4vTYndFrjssnvjJD4zk=;
        b=t1Gc//qmrlw/xOOKPmZZVXvXS05pY8Ij3hnAkn6OvZ/8g6gUdyRHPi3PPogFfxihLo
         01MtYgmU1pCDdTrShpnV2JDVoOKeEwarellXK1fwe8WYxhQ735BlNfbzKQE1HxcEPtQZ
         xFYC/i1gll63FjAi9e3Slt5rg+EzUi6UAFEhlJBI9zy9oY4qYW3N0lUdp+qQaj8GvQWu
         PZrEB8CmX9datWadColHUtRuyEEX2pgmq/RcS0tpAUM7++uQ31NqU1FBvEGdsJVgcS2d
         hbdGYEkSmnGR0LI16PnUD1wsNF0ZjS+YWZcsW9P8NGt2Ni2eLalRri5IInlM/zRiRUb0
         3LNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=A+I0MIghGu/sRDrDxSDK4hlZ4vTYndFrjssnvjJD4zk=;
        b=OHZoOUSklGChoeHNR1NRbxFup2IrvkwgeewB3nTQOmpgvxuPkZ6D29lN7wU3W7UQM9
         5ywBa65Jb8I3EkniKkgBoVecgHefTbIU+nTYuqYDmUdsNFFR+btixa/Wtpwaz9Ykwlq7
         RTPeezE5kOtVecCsEHuzwrkeSlOjTfBS4kordj//AdiUz3cxuDRrDxFrW9ZhGxKa6XhL
         dqPxthELxZW1loKHMTcdt1k4DQ+VFYSuHpGLItsj0V/PO3PjX83XCS9Gh+BOAZHJlmkv
         WXyFGynhOJhBIuoSHo91q/sjoqhkMlLiLCm5dJG9vEEYHpeNC6zmrAY8xW31OVGFLLoH
         fDkA==
X-Gm-Message-State: AOAM530SnrCQxTy9upj2tQKWQA89UpmNk0aeQE26rq5b8Xc3szSWC8jD
        VMe5d1wjLd3341M05DePfZrFd9bmohGOPQ==
X-Google-Smtp-Source: ABdhPJyI/DyVnuIQ66TffmL5M+MjZapXmYsfeJ0PPHQ9wDcb+b4ePwt+kI2Tfo7ufYGEkE2w5hcaVw==
X-Received: by 2002:a05:6a00:851:b029:1b3:fbb3:faed with SMTP id q17-20020a056a000851b02901b3fbb3faedmr970154pfk.18.1610704093322;
        Fri, 15 Jan 2021 01:48:13 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w131sm7656113pfc.46.2021.01.15.01.48.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 01:48:12 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 2/3] geneve: add NETIF_F_FRAGLIST flag for dev features
Date:   Fri, 15 Jan 2021 17:47:46 +0800
Message-Id: <ecdc99699bf9e367ee445238c836b025e16376e5.1610704037.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <25be5f99a282231f29ba984596dbb462e8196171.1610704037.git.lucien.xin@gmail.com>
References: <cover.1610704037.git.lucien.xin@gmail.com>
 <25be5f99a282231f29ba984596dbb462e8196171.1610704037.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610704037.git.lucien.xin@gmail.com>
References: <cover.1610704037.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some protocol HW GSO requires fraglist supported by the device, like
SCTP. Without NETIF_F_FRAGLIST set in the dev features of geneve, it
would have to do SW GSO before the packets enter the driver, even
when the geneve dev and lower dev (like veth) both have the feature
of NETIF_F_GSO_SCTP.

So this patch is to add it for geneve.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/geneve.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 6aa775d..4ac0373 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1197,11 +1197,12 @@ static void geneve_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &geneve_type);
 
 	dev->features    |= NETIF_F_LLTX;
-	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
 	dev->features    |= NETIF_F_RXCSUM;
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
 
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
+	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 
 	/* MTU range: 68 - (something less than 65535) */
-- 
2.1.0

