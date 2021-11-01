Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2285441D64
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 16:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhKAP1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 11:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhKAP1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 11:27:02 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABBFC061714;
        Mon,  1 Nov 2021 08:24:29 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id x27so37039926lfu.5;
        Mon, 01 Nov 2021 08:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eZYI9uvVCBQKgTkq4oCfUYzQKc9GNXcLcsMzBPkU+Jo=;
        b=Ff8Uyco99hJdLYLNs92twSEltGW3VCt6x4imDGEVsjD9YsLYlRI3ipQRGX3pdTLiIW
         ac9yHLcnnIg1RmgEEOSCfscFaDuWRQIxiG9IpfBbNVcEc/5Cn73WmX/4moJIPO1Yzdq6
         A7xPFs0Nql1o6GYgkzoAl3JvfeorDTdd7hNr3GXCqmtUmKNY1LGeGOOETA0Z9rQTrcVa
         gpaltMVZlfJv8HEInOP83QlqQec97LZpn7bsT0NXk3YMcFk/yTcS/D/3hgeqdVvgNbq4
         +0AvL5Of5lUSRycpbQHaDzYNsqgL1zOWHBlJHV/xR08q0nCLrHQh57ogkycd0GWkY0ek
         t/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eZYI9uvVCBQKgTkq4oCfUYzQKc9GNXcLcsMzBPkU+Jo=;
        b=Ln3bXKacRGuRbHKFwoUUvApC1qwHbvE9a2QgiGZJpGTXQQWrWe4bZZ8uu8hySKZW+h
         B9cb+pACWEGATUov8G6ruvKg210MA3z63HJmX2/NEQMX9qNlaJZ3KCUCFGWDzqTuHEcT
         C1NO0jd6y+77OXh1XWLan60NQSL7G2P5wS2j7TWdLVwIwRIi+9LzcdFHyh3AFX0Dc2nk
         u6NWbDDFyt+jdsp5f3k0IGHHVSi2Z/bCN2gt0XKQm5Qm1isFnApTXcm9YquXoIY6t3SA
         7A1QRNiA30GcaxQm5dmgkHOQxrgpaJH//JzzGtgankunt/Huypapd6stRRsasRGNnncb
         AgRw==
X-Gm-Message-State: AOAM532dTQZMobYZeuVs94XC16yAA6BPSQci6/ZijGnivXWx1j3k2kgm
        NUsD5qBXg5g08W3vfTmpJ2g=
X-Google-Smtp-Source: ABdhPJzHP4sMx5IKHpr2iQftrF/pxi/OdPIm1znDmR/jbsswl1m/wNyEPz+g6A4TqWqsYls7c/ZCPQ==
X-Received: by 2002:a05:6512:2609:: with SMTP id bt9mr28820959lfb.202.1635780267466;
        Mon, 01 Nov 2021 08:24:27 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id t12sm1436052lfc.55.2021.11.01.08.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 08:24:26 -0700 (PDT)
From:   Maxim Kiselev <bigunclemax@gmail.com>
Cc:     Maxim Kiselev <bigunclemax@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Colin Ian King <colin.king@canonical.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Michael Walle <michael@walle.cc>, Sriram <srk@ti.com>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: davinci_emac: Fix interrupt pacing disable
Date:   Mon,  1 Nov 2021 18:23:41 +0300
Message-Id: <20211101152343.4193233-1-bigunclemax@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
disable rx irq coalescing.

Previously we could enable rx irq coalescing via ethtool
(For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
it because this part rejects 0 value:

       if (!coal->rx_coalesce_usecs)
               return -EINVAL;

Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing
functionality.")

Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Changes v1 -> v2 (after review of Grygorii Strashko):

 - Simplify !coal->rx_coalesce_usecs handler

---
 drivers/net/ethernet/ti/davinci_emac.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index e8291d8488391..d243ca5dfde00 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -420,8 +420,20 @@ static int emac_set_coalesce(struct net_device *ndev,
 	u32 int_ctrl, num_interrupts = 0;
 	u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;
 
-	if (!coal->rx_coalesce_usecs)
-		return -EINVAL;
+	if (!coal->rx_coalesce_usecs) {
+		priv->coal_intvl = 0;
+
+		switch (priv->version) {
+		case EMAC_VERSION_2:
+			emac_ctrl_write(EMAC_DM646X_CMINTCTRL, 0);
+			break;
+		default:
+			emac_ctrl_write(EMAC_CTRL_EWINTTCNT, 0);
+			break;
+		}
+
+		return 0;
+	}
 
 	coal_intvl = coal->rx_coalesce_usecs;
 
-- 
2.30.2

