Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC623B6922
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhF1Tdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbhF1Tdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:33:39 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BCEC061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 12:31:12 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w26so14344451qto.13
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 12:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x64architecture.com; s=x64;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7vivyoATp21GASveQ74efh0B6E/CH9k37BCnn5YtXjA=;
        b=RD5d0Tu8v5/Z4wZWP2xj8p9eQok8jaRXqtjsEhR7BmpMOgkAiVfE6lFogbBfcOTkBc
         P1JSZfak5UkMLXcvq1RFSIdCh7QtN5OE7BbhqrfiphUKB9IaK+8HN+ro3hvbTIIIzC8X
         ddMjEDWsd11uJOfof46kGNuJRagrgiBaYMG1EqlfBIIMjKQLs+qsBas3oBWHhiuI8pJy
         HuXQjT5dgfVaTbWAEWOTS/t6EJzZRf8Y4NMhbuVj1DDqlQaF7/LfX11tv0cgIfQsigr9
         CbTzFM0Xop0xegwinrbpzagq0jTFyCIveoMIymUgsRxbkwteIEcS2sPBbFobGVHH0Git
         cCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7vivyoATp21GASveQ74efh0B6E/CH9k37BCnn5YtXjA=;
        b=od+wHXSmtN8kXQgF5Ipm3Vq7CbBv0gEOZnkUMBIGBmprgxKbt5PmPABxjvm5HgjZoM
         dTvUuW0fLvD+zlcQzaO3t6IOZ1l/0A189Vfjs5+bLsu9VuDgIitIUGZJZpPqUuBeIkj+
         OjnrOcrOyvpmwpY3lS04sWhDUxnihdoO4wj7JqjEOgTYzEvwQ5ur5XSt+y+WV0XHd/g5
         M7Pth7wvoqqoAr7kremDbF92usgImM67wohH1X/QYnvS0xvW9p0HPzKoIPRieTTw5eBW
         eVAEKcsv05UGxe65bq6p+4/gu7RKZg+Gvnf8OMH+v4EsIw00wqM8TUzJ0IsePXRTjX7V
         e+ew==
X-Gm-Message-State: AOAM530zE+2lw09Cg9eNN98X0e2RwhxPSzHxoU2MLLA9nw5Amf5oOCTe
        SJFN06JuXd2RuqkYYwGfu3UVVuSx1W4BIlQI
X-Google-Smtp-Source: ABdhPJzdk4g5SvpwZjtb+cFsg0pIh4yKM2h0bcgFezZymN+PLmeUVpMN8xQThyypQF5GVqO7JZAQ9g==
X-Received: by 2002:a05:622a:1a1d:: with SMTP id f29mr15127435qtb.359.1624908672039;
        Mon, 28 Jun 2021 12:31:12 -0700 (PDT)
Received: from kcancemi-arch.Engineering.com ([167.206.126.218])
        by smtp.gmail.com with ESMTPSA id c4sm4011866qtv.81.2021.06.28.12.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:31:11 -0700 (PDT)
From:   Kurt Cancemi <kurt@x64architecture.com>
To:     netdev@vger.kernel.org
Cc:     Kurt Cancemi <kurt@x64architecture.com>
Subject: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with plain RGMII interface
Date:   Mon, 28 Jun 2021 15:28:26 -0400
Message-Id: <20210628192826.1855132-2-kurt@x64architecture.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210628192826.1855132-1-kurt@x64architecture.com>
References: <20210628192826.1855132-1-kurt@x64architecture.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the default behavior to enable RX and TX delays for
the PHY_INTERFACE_MODE_RGMII case by default.

Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>
---
 drivers/net/phy/marvell.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e6721c1c26c2..a5a9d76b6bab 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -546,7 +546,8 @@ static int m88e1121_config_aneg_rgmii_delays(struct phy_device *phydev)
 {
 	int mscr;
 
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
 		mscr = MII_88E1121_PHY_MSCR_RX_DELAY |
 		       MII_88E1121_PHY_MSCR_TX_DELAY;
 	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-- 
2.32.0

