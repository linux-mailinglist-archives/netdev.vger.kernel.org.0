Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82560333C28
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCJMFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhCJMEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:50 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5D5C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:50 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jt13so38238712ejb.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+AAyewktgEXL0O/8ExlIFLXjGVBFM+lqDw29htiKYs4=;
        b=n/2DlZnBliXQMCCnEI1Q9SPEo45fdNFzCqhFewKo//Uylb4DIhNi7VohkkKUoQNpod
         GSWN/HsUoxLUiyKOWOhhOAxTI+FEtoy/MuqzZKU22L8snsTM2OCWnxCJuiTG6xO1Iih2
         1/E23AsT8szNeEuryV1h+c8foWrwmMB2q6g+ptQfOOkfNKasDGzLk0AIWBq0bgY6CaCo
         3s5EP6A6Vs21RvE1Blhap3sVMmF6PC3BaedRp6Mjwl1cfojAh7XtfAPCdqs57duOU8K6
         Mxn2FC21UbbLw6UZdAfehJ7usbiSaLi6AXHiaiQKcGjwyFJzsIhvvogYKeXBW4CMzRTj
         LkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+AAyewktgEXL0O/8ExlIFLXjGVBFM+lqDw29htiKYs4=;
        b=R58+Ys0hcTLO2dYtxEy6tS47pBAWZD+TXQZx1XdC1nLsPrWfnYhsYlcqGpvVViqhg0
         uwMDy3RINOixZgNzkPvJy4OtmHJRzYLfikXPnnjWaZkC8wruQCX0axsiZvtXCQ1Ug1oI
         x38zb2wLZHS1qMJwVYXlo6T8cdpN6vneJFzYIDLMmYOVLwAuHVlEHqq5ZOOa/obLwysU
         E16PLB7o0wiXHV8962PCPPNnz1V00py9WL0Yda3YTpRv/oIxO7u9+iVabhL+XhPBaKss
         bRnZazI+1w/L5vJSd8Y0XNn6DEwG+7GO26KteQYKArCXoPpra5Zj4hMUQ6NATsptxNk3
         00qA==
X-Gm-Message-State: AOAM530yz/RWJ9QWfoMPpTCKs2CXAojGGw9r2BvYxYoHE+5lqukT3dgK
        tPwHxCGL8rMsIMrjYWFw78k=
X-Google-Smtp-Source: ABdhPJwx0GPrIAW3V1dpRfSNuwwucSXIHCW3ZyUStnbpD9LGADTPVzwPCvqFpgFytfoQYX7FZrbIsw==
X-Received: by 2002:a17:906:1ecc:: with SMTP id m12mr3273486ejj.4.1615377888996;
        Wed, 10 Mar 2021 04:04:48 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:48 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 09/12] net: enetc: use enum enetc_active_offloads
Date:   Wed, 10 Mar 2021 14:03:48 +0200
Message-Id: <20210310120351.542292-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The active_offloads variable of enetc_ndev_priv has an enum type, use it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 30b9ad550d7b..773e412b9f4e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -261,7 +261,7 @@ struct enetc_ndev_priv {
 	u16 rx_bd_count, tx_bd_count;
 
 	u16 msg_enable;
-	int active_offloads;
+	enum enetc_active_offloads active_offloads;
 
 	u32 speed; /* store speed for compare update pspeed */
 
-- 
2.25.1

