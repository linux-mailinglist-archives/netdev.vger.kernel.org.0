Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD96E27A13B
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgI0Nbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 09:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgI0Nbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 09:31:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABD9C0613CE;
        Sun, 27 Sep 2020 06:31:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id m6so8842825wrn.0;
        Sun, 27 Sep 2020 06:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QK+CNqV2RawiQsdUjO+AkwK+0EE8a7HDH6rwLCEoY2M=;
        b=t0scRr8J/uICsLm0njOEG5K2sdZBfDOfD6UT8OCdYSaHAQhbrBzy+x3Qd+kaswZgGU
         LxaC2hkS4ZtMTn0qy0ER7y2SmIsU+a7OQVer6A4z2Z1VnDRXAYOeNELs3JgpGseJU1GK
         YqD3oasX1RCjcs0E/frUbzcg69OQk8XHnFXux/EB82i2OtUx1yZxvLlB5GeMHASaKc3/
         1UX/wotUFmNgj984S1+z7eNoYnBm+5UZQ/7EdtAmco+jobr+e5goHqIsoAaw0w5gxTtP
         C4jk57QM+Ml8ifPf7AgcpCnwBjfeEOF2KSAJoJYesRdZNvZmJwmQaecFz2XzLtx3nfaT
         L8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QK+CNqV2RawiQsdUjO+AkwK+0EE8a7HDH6rwLCEoY2M=;
        b=ctZXBSWohKg7x/5PYFA6E2Jiuhrcr2IOx7RMGs4MuNWFDN8YpSm0rVb5yfiedpUoQS
         lsGl8n1GkOaG0SiOwx7WCvRqey0tJMrV84pQbUV5JKuaxcU6g6sOBF411S5Hq/hSB7vp
         nq6zBdUMRXitWG6g1+n1ALSkmHJpNG4llhP7v7P1e5Y6DyeDFk15LgT631mblO/ETTP4
         /Ktu++vmu9u6nCryOkm6KSJ/WrK/n2XWeMg2LEF9GIgVWNp4XUTe1Xf11k1OqepJk+hU
         lu4NR0ypZ5ULWknrV544XLOGzZenNSZdTsXlb+GBKnM6JpfYhHMCFyn7nBDWrnaE0B29
         c4Yg==
X-Gm-Message-State: AOAM530lQT7e8IyOLsQ6HUzIxOWPIhD337km+H/WMYqnuARhEnDvqh1R
        R8ng0Ux9Tyvsg+eu2yFnMSQ=
X-Google-Smtp-Source: ABdhPJxcf+fIszPWUO6Fg2on0jlCjY3+yQhOROMCyjbDppnvgplBLT5v9KgtEVhrHWvCoxfQ5L0dWw==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr14325249wrv.139.1601213492561;
        Sun, 27 Sep 2020 06:31:32 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id e13sm9637805wre.60.2020.09.27.06.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 06:31:32 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dpaa2-mac: Fix potential null pointer dereference
Date:   Sun, 27 Sep 2020 14:31:20 +0100
Message-Id: <20200927133119.586083-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dpaa2_pcs_destroy, variable pcs is dereference before it is
null-checked. Fix this.

Addresses-Coverity: CID 1497159: Null pointer dereferences (REVERSE_INULL)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 6ff64dd1cf27..09bf4fec1172 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -291,11 +291,10 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 {
 	struct lynx_pcs *pcs = mac->pcs;
-	struct device *dev = &pcs->mdio->dev;
 
 	if (pcs) {
 		lynx_pcs_destroy(pcs);
-		put_device(dev);
+		put_device(&pcs->mdio->dev);
 		mac->pcs = NULL;
 	}
 }
-- 
2.28.0

