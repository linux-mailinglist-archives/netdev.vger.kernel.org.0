Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A5F40ECB0
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhIPVfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhIPVfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:35:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715FFC061574;
        Thu, 16 Sep 2021 14:33:44 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id bg1so4733076plb.13;
        Thu, 16 Sep 2021 14:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ferZLYY6fTnKLI5lToHUrMElKCbn3+t8ZleK9UD2g+I=;
        b=lZmLMAniugA8MavhAfTYUvsLN+4bRYD3KBXTY1Tyo8RfFjNcOuDEukmRwW4MoJl4tX
         MNxXP+H9KXQ6izIETyGVw38P5EbR8FlZhiQSTn2m30FT1qjT1VRIYSLhvdVjKWu9qz+n
         d8V4hPl6LYePS8YWSnL4aBD3JmMhPmptWiJuRe5qlCyyIQO7ifFioS8UWwbSUFuhL7Hu
         k75rBIlZZSKOUqphUzEc/Qcz5piFAGDhAo6ugedQo40Oe6LaGl3SMSOG8UDwnFn7v05z
         jr6hR81tGdeK6tPgP8mpgjnXfk3OfUiOil2/RN4rYH3WDM2Y12TYQpXwA5Ua7CaJ8IVh
         qGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ferZLYY6fTnKLI5lToHUrMElKCbn3+t8ZleK9UD2g+I=;
        b=ZJJNEkUXa8iGdzPCSHS2yO6dAzQ/zDVqJImpNwp1ftbK/8uGfNoQEdRMnZ6AMeUQww
         VTxHw4E9xHCe0SA8uQlhFS/aA4prNvHg/lAJAy0watNzu+gSuhWClPtZWceVYtHdoB3o
         hNmuHeN8tft4fdVxjN3D8Suvpv07px65uPhImWKopwUjii6XHNzXw5OHJPkiY1bD3vHQ
         UN++rAewq7v/UpAaWU/Xm0SaV2BF9p+GSozamd3VmbRrDcmaPWSS3gBrT//39eznfFUq
         K5snR4MbsH9rjH1lhmoMf170274OleFxsyitMzigw8EyCY8YbB7AJIxHK15e42GIp1yq
         V6/A==
X-Gm-Message-State: AOAM532NNpXDMUmKO6aKRgVzcnJPIWvVsAQ9g6cAYN3EHFYM+6wEhls5
        ybKsfnjiGlxWghh/L5NGXoi/yEtj8ps=
X-Google-Smtp-Source: ABdhPJx0rabQ3Lg3Q3fkqvrnD/4itZzHX00RW218Q6Vikj5oE0e4i1dc1Ak0UbVlEiyj3bzmugsU0Q==
X-Received: by 2002:a17:90a:194a:: with SMTP id 10mr16586443pjh.221.1631828023519;
        Thu, 16 Sep 2021 14:33:43 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y1sm4125634pga.50.2021.09.16.14.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 14:33:42 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Fix array overrun in bcm_sf2_num_active_ports()
Date:   Thu, 16 Sep 2021 14:33:35 -0700
Message-Id: <20210916213336.1710044-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After d12e1c464988 ("net: dsa: b53: Set correct number of ports in the
DSA struct") we stopped setting dsa_switch::num_ports to DSA_MAX_PORTS,
which created an off by one error between the statically allocated
bcm_sf2_priv::port_sts array (of size DSA_MAX_PORTS). When
dsa_is_cpu_port() is used, we end-up accessing an out of bounds member
and causing a NPD.

Fix this by iterating with the appropriate port count using
ds->num_ports.

Fixes: d12e1c464988 ("net: dsa: b53: Set correct number of ports in the DSA struct")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 6ce9ec1283e0..b6c4b3adb171 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -68,7 +68,7 @@ static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	unsigned int port, count = 0;
 
-	for (port = 0; port < ARRAY_SIZE(priv->port_sts); port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_cpu_port(ds, port))
 			continue;
 		if (priv->port_sts[port].enabled)
-- 
2.25.1

