Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966EF1986B8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgC3VjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34544 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbgC3VjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id 65so23534797wrl.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H2a/hDQCPDT4q++d11lo8Qlh4ZxoshhA5o4y1evMiik=;
        b=RWCSEfwQLutFQL9Z0YgUoS3LTnAf/YJ11FGBq76BQsu6TB4jOkfKyk4Sga0oxh8vyP
         01PCnqauWRMBGPHdz5Keo3RRv6TNarnVnJMrJfxtVl62LssNeJz5kEmmzIxYrC1gpv6r
         Dq28aYC8RyBSYPu4CWPUdEAn8zZZ15BYxsW6SkgHbc20S61DOXoQ+h/VOasM4xkv9Gcu
         /fLgcEOAMVnIcmOkaKxeVY1Wk6zAAXvn/5XDxBAZXjXhKn4lQZtr/tRk1+rDXCDZRg2B
         niM3RDhK91KLsWzzHCn2fRv53GaLnVhwuhQSFb7/EH4ib38TO6/CPE6mgB5tEuFYFvoA
         xbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H2a/hDQCPDT4q++d11lo8Qlh4ZxoshhA5o4y1evMiik=;
        b=RpaGF24XG15ipAEvTNFqyymBB/39db6e5cu2qmNFrhAE97lfFOyiytuM4V7dlFkGrP
         Q+jL30yRSmrGVMtxhuwngxHtRXdRYZUjuorSVdxkPVK/Z97U6CFLCpi095h2fkikybeM
         u+3Gpsmaye7kNytYplohOrEv7pN0luZKxl42NInzhxlnAwKL9aelDOm8nDUJ2Y9STuDY
         EKEKMu7RDiqnCmJggf/X03uvrBOmHjc2a3Nt7+LxX9pQ9Q+Pfjvv0o6PNJXZ61cJJd0M
         bT8TysfHDDPDbCATsBH36RC8DF2s3be++Mf6jaksfOasXlEN7oCeQD2Frc+OhiEgdhNT
         cQOw==
X-Gm-Message-State: ANhLgQ0mm/fNCqU/A2N00eiRSaH5yFyS78+TNtsQ8mSIGqhKXLXPViTR
        8Pe3WDTlPm/4JTky9orOEhDwCnzL
X-Google-Smtp-Source: ADFU+vsS/nX5/cCTeaUtQ/yvLu4l+9vGZlkrHbKRXKgzozDYiz3n9z31mQgsjSj14rrJNZBu5DAfKA==
X-Received: by 2002:adf:9346:: with SMTP id 64mr16530843wro.174.1585604350879;
        Mon, 30 Mar 2020 14:39:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:10 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 5/9] net: dsa: bcm_sf2: Disable learning for ASP port
Date:   Mon, 30 Mar 2020 14:38:50 -0700
Message-Id: <20200330213854.4856-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want to enable learning for the ASP port since it only receives
directed traffic, this allows us to bypass ARL-driven forwarding rules
which could conflict with Broadcom tags and/or CFP forwarding.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 368ead87e07a..affa5c6e135c 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -178,9 +178,17 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	core_writel(priv, reg, CORE_DIS_LEARN);
 
 	/* Enable Broadcom tags for that port if requested */
-	if (priv->brcm_tag_mask & BIT(port))
+	if (priv->brcm_tag_mask & BIT(port)) {
 		b53_brcm_hdr_setup(ds, port);
 
+		/* Disable learning on ASP port */
+		if (port == 7) {
+			reg = core_readl(priv, CORE_DIS_LEARN);
+			reg |= BIT(port);
+			core_writel(priv, reg, CORE_DIS_LEARN);
+		}
+	}
+
 	/* Configure Traffic Class to QoS mapping, allow each priority to map
 	 * to a different queue number
 	 */
-- 
2.17.1

