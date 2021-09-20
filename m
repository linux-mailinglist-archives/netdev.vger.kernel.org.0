Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C295412AC9
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238826AbhIUB6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbhIUBuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:03 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B4BC06AB06;
        Mon, 20 Sep 2021 14:54:31 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t20so12965490pju.5;
        Mon, 20 Sep 2021 14:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WZ6RJ7HFQNhOC4mLQr6EMZ4GwtvjqnBfYVXzAg81n0o=;
        b=IubD7crUDdrfc2WtTw2ZcqZIQipVj6aN/zaJAHDUCVwpUrOTO40JypE//7wDwCRD4s
         tota9WbVPsBOM3rjl+pq58S7kBVAZtV7++GBJwxoQlkV9FYQ36h4pw/dvE6h+ptzfncN
         2u/T0VooRv1b9rCU5MCea8zRzDYXLaB4tIf9xYAozGdei8ARy4CoVWOayXC5u7WhlnqI
         0ul5HgLBT24b8MTTEiR+NQ+UaHk2JwWLj9DWrnOFgkfAHWSJCxx2S5Ip47jR2sxLT1Wn
         becIMK7KVoCO6n0E965fEoiLmF/kn8ZaOzNv0CQiTHekdcx0hTGJ7L6gZMiRBRRf3hb6
         JluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WZ6RJ7HFQNhOC4mLQr6EMZ4GwtvjqnBfYVXzAg81n0o=;
        b=rTJKF2UkQK9cqve7IIlZpx/vR9huelxCYMucDZdqG3V242AuqOSUzru91BPfdb4BJs
         otQdEF0qlWMeJpM2BHuBYjLvLHN1Vv3vlc46Scr0uI1AaOvCZjoHQbdaTJZbcGwOxkEc
         zWWOb1dZofwjhs2PgILoxXqVhgHnT190nq/WzCRuk/KGxONlmAZFLEa3L3ZZMh/48NwX
         N9A9xscKwrLmOm+ke3Rjmo7t7UudymdZTT+VTEZryL8jtRfgIpPjarUmn+qalVASfyG8
         5b+//whRkQdbs1kpXRdrgWxKyKo+TxjilPx6z7wjEUTg8had6KuI3MW9skZXV23Ng78M
         KN8w==
X-Gm-Message-State: AOAM531emnidUgyvuHmxs5sr5aTRyZa8TdUsh0iCzaYGjLC3HpjtbEWn
        oRHn2yPEasa+XrlW8nThDcjwKbfk42o=
X-Google-Smtp-Source: ABdhPJySmdXkzaVQKWKLKiibo7jux4n/VMHKakyPXvk10SVtLpaA3vxvVnhYi0Bnub4faVDPaE4q3g==
X-Received: by 2002:a17:90a:ea8b:: with SMTP id h11mr1344894pjz.124.1632174871072;
        Mon, 20 Sep 2021 14:54:31 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m28sm16224297pgl.9.2021.09.20.14.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:54:30 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 5/5] net: dsa: bcm_sf2: Request APD, DLL disable and IDDQ-SR
Date:   Mon, 20 Sep 2021 14:54:18 -0700
Message-Id: <20210920215418.3247054-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920215418.3247054-1-f.fainelli@gmail.com>
References: <20210920215418.3247054-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When interfacing with a Broadcom PHY, request the auto-power down, DLL
disable and IDDQ-SR modes to be enabled.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 6ce9ec1283e0..aa713936d77c 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -667,7 +667,9 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
 	if (priv->int_phy_mask & BIT(port))
 		return priv->hw_params.gphy_rev;
 	else
-		return 0;
+		return PHY_BRCM_AUTO_PWRDWN_ENABLE |
+		       PHY_BRCM_DIS_TXCRXC_NOENRGY |
+		       PHY_BRCM_IDDQ_SUSPEND;
 }
 
 static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
-- 
2.25.1

