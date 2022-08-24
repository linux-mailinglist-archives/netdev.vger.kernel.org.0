Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8661259F372
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 08:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiHXGKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 02:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiHXGKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 02:10:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83AB15A02;
        Tue, 23 Aug 2022 23:10:48 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 2so14821317pll.0;
        Tue, 23 Aug 2022 23:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc;
        bh=dCALWe0Lpc17kneuprlgwYN5B636Jm/G9IT6scrrQtM=;
        b=ns6RPMp3yGpbXlpltT1jcEkXTkjLNt5QZF7/0wJBrXyh6Gph4aMjACEJW9OBGpnDZI
         BFzZNVfeQdeoDmQcYho3Kgj1RT8DSj6EGdLiQKpK8EP2zhSr7847bhUYs8oarB392kry
         D+yNkMx8pS92sh5T9CJmRh/ifrJxMynRYui0CMW2KPVIZ5zrUn1Mx5Ks/CD6Pui7T+dV
         Q8ehLQjbJI4nRI9m8PQQqX8qXXR9OPi8pameKK7hKlIW/e5JKW+YYJgBJZS3LNiwTYEZ
         jUQ33o7/UGFnOCJPImCFDPqqCeFRn45B2wiLa/E0zQ4J/QhySELWHGOOgxIHqy7FD80C
         bp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc;
        bh=dCALWe0Lpc17kneuprlgwYN5B636Jm/G9IT6scrrQtM=;
        b=JLupm0LaU2je5A4O2pJNKvWPbVEKcIHVaCRO2Bno/YaRMSbq8Ntd/Qp3IqOLsMeMmB
         T6nVvdwzB/q9OZvEWjvgLz+0ZgGSHTpiZTqEbdd0GvSZuouDFBEOdbAuNs6VP8BxnNBi
         JpNJLCJLzkV7k5xFCSgLJO6qIY2PhUnx9DsuJdQPpLSjo6EsFciCJk5AE+s1BAxz4TZH
         GfgyjxoGbTbvbU7S5nm3fMQcMAynH1P3XqfeUqWp2WfFCMY7D3FWiTs8DWM0E0ViZK4t
         IvVEWLqrNnD5P3RFbc+wyRq0d5K3d/1lsQTzc9Ma+y0yZD07kecvBPtenWst4lJbeIEz
         eZIw==
X-Gm-Message-State: ACgBeo1BbbngWqXmrePwxDppmSAP9zSrPeifkVuDvp+7t4nIN6kbb5h2
        qHB9wdZMlWOb/2n2rVaHC8o=
X-Google-Smtp-Source: AA6agR6BuIv0VqqZw4hWd1VS+00+tOon3DOEVQtB2wPk1UvujyKM1QfpGI+ZIKJJNOyX+h5MBb/ZTg==
X-Received: by 2002:a17:902:f542:b0:173:a8a:d7bf with SMTP id h2-20020a170902f54200b001730a8ad7bfmr4217911plf.134.1661321447866;
        Tue, 23 Aug 2022 23:10:47 -0700 (PDT)
Received: from localhost.localdomain ([104.28.240.137])
        by smtp.gmail.com with ESMTPSA id v30-20020aa799de000000b0052d4ffac466sm11954334pfi.188.2022.08.23.23.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 23:10:47 -0700 (PDT)
From:   Qingfang DENG <dqfext@gmail.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: phylink: allow RGMII/RTBI in-band status
Date:   Wed, 24 Aug 2022 14:10:34 +0800
Message-Id: <20220824061034.3922371-1-dqfext@gmail.com>
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

As per RGMII specification v2.0, section 3.4.1, RGMII/RTBI has an
optional in-band status feature where the PHY's link status, speed and
duplex mode can be passed to the MAC.
Allow RGMII/RTBI to use in-band status.

Signed-off-by: Qingfang DENG <dqfext@gmail.com>
---
v1 -> v2: rebased and targeted to net-next.

 drivers/net/phy/phylink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index d2455df1d8d2..e487bdea9b47 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -634,6 +634,11 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 		case PHY_INTERFACE_MODE_SGMII:
 		case PHY_INTERFACE_MODE_QSGMII:
 		case PHY_INTERFACE_MODE_QUSGMII:
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+		case PHY_INTERFACE_MODE_RTBI:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
-- 
2.34.1

