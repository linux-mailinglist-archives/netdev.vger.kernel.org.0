Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6334249DB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbhJFWi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239850AbhJFWie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:34 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CB9C061746;
        Wed,  6 Oct 2021 15:36:39 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g10so15087217edj.1;
        Wed, 06 Oct 2021 15:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NMygWhMGOdBsZewnkOPqt2RNdLzU8nJnCYHfvZ5KPeY=;
        b=THL14kk0eVmez+8yo4Xrf7qDsp6CoNBg9wIYZ9f0QEq9szSgGasHFNiHujdUO8kVRJ
         Z53bjct0sSUquxNfjzPujYCQ2AW20E20SzmxLeD4Y2dK+CtQEhwWfiu+dsB869tJ9b0i
         qwUjDNFi1ervb98jn5Ue1249vwLPutNOgX8lDGVbUqEw/59Xwc0oQGZgVGNRf964FeXQ
         VcV6rRYEI+bOiPfwQZjbP6+CvXjmGmIWNamMXy5YWGdwMUX805IfgCNjGmHWoZehGM5y
         Z6NOlpylFuz4KGxqMtwDJt4+4o0Fgq/eTpdzee5hp6TdsZml1tnVLc1ZnQRljZDoLpbD
         LczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NMygWhMGOdBsZewnkOPqt2RNdLzU8nJnCYHfvZ5KPeY=;
        b=ouz3NBbwOJty5tt5nKr/viFxuu3nNwEs6nTT4m7eQVynSJq5aFc03+EFlxTvURkXby
         55rnjMqFI2IAn+bZXb/ffR0/uod8opIVzWS7q3MiGdMByKNhVXwI+4UZAvlXg4+We2EM
         bcaGS3r3FJiW9T5qu8Olaf1zfaFqf5C8HVktUYf4Y+wx0TWOmOwqAtbn0gPDx8/drswc
         1MHo953pT5NJuopnNQ1YvbmswW2D6vqeMZ5qBsR6gDUnrfV2h4itjQqM0youlUOolb2+
         ZC+TQhwiPNtfMkUN49ptuR2BbtqVlS+RuzxsA08MeLvGwqnKLj+6S+VkbZa/n6Cm0cqH
         7cvg==
X-Gm-Message-State: AOAM531rnFYSiTtyHrxlb8gaSOivyhuTGg2A/JbWkrirRA+V5YvS3us6
        BmDeQqFEXhM/aUHQp7I9XZk=
X-Google-Smtp-Source: ABdhPJyd1PSfFQmV2wnun91d0QauAV+KN2UGncQtHGp3UbJJbMl2aiRW22A2GWjOrcUoQ59f6Ln03Q==
X-Received: by 2002:a05:6402:1d2b:: with SMTP id dh11mr1227240edb.276.1633559798251;
        Wed, 06 Oct 2021 15:36:38 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:37 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH 09/13] net: dsa: qca8k: check rgmii also on port 6 if exchanged
Date:   Thu,  7 Oct 2021 00:35:59 +0200
Message-Id: <20211006223603.18858-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port 0 can be exchanged with port6. Handle this special case by also
checking the port6 if present.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3a040a3ed58e..4d4f23f7f948 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -906,7 +906,20 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
 	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
 	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
-		return 0;
+		/* Port 0 can be exchanged with port 6 */
+		dp = dsa_to_port(priv->ds, 6);
+		if (!dp)
+			return 0;
+
+		port_dn = dp->dn;
+
+		/* Check if port 6 is set to the correct type */
+		of_get_phy_mode(port_dn, &mode);
+		if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
+		    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
+		    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
+			return 0;
+		}
 	}
 
 	switch (mode) {
-- 
2.32.0

