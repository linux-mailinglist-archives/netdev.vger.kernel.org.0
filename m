Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A4C3B245A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 02:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFXAze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 20:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhFXAzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 20:55:32 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567C1C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 17:53:13 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id r5so7272431lfr.5
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hi1YbzpzCridy/vQ8hgizgyXmNuKaQ2Nkv0Kcn9srVY=;
        b=IbkuQi3Lsis6XdOo041PEiUdza67ZYLueW6eeFY9IHRHupcoNmz32sylAbB7DKNGil
         LyryqlxPd1VcbgiYgOLAWrtSBxIlhgr66wnfd2M9CL6Eqs/i0eS+WXA4tamuYkdAd+mV
         n2kw7xkiOMejUr6bElaBKZnAFbKSwSPcC4tcoifQE/aGyMfEvXePTjCjVAr8wBLYwdZD
         7dw8h+QLJ76vrlPZgoHz6hrk7jkT9ke6E9g3H0Y6g7y0C/c8ZUHBxilbTm/kh7qX+6C1
         S70bAV7VX8omEHtohhRV3AC2AVC8deN8DSdeQPEjqLmenqs3opix9xoqjINt/hasP/1M
         C/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hi1YbzpzCridy/vQ8hgizgyXmNuKaQ2Nkv0Kcn9srVY=;
        b=AQZwnhANZ/WSad2DGY6GKQtOGXtqZ93xsVHAYGz9CFOegrWHGEeGgbHLd21H3i+bPN
         sI/tc8WWWylnaaN/seGif2PFDFXKF9ivpYPeBhf5bNXquYi8hPGJ9wD5TZ+hs/2NAUOr
         Wp4qebD2I6AorU4Ig2M9eg6mE/JJ+Yyg7oWOlss4RA0jB3BcNuzMUo3QD5Zq8zDgn4ae
         GgpiEwz9GaS7us2AA1delTcKuNjKhBx59oiiWRJG6WQN53uyzQLSbT19fZDmvOdFgpJR
         sa0MuTWhOQY+LG5uPlm2EYbuT56cHakmOz2Uazf105SLcb31Qlh1sGFUQ+9lEg6ie0Rn
         u3wQ==
X-Gm-Message-State: AOAM533ly+nH+OwdDKGCnOIljiSH9dnbCLtlMBXPmyj8EUvw3KjNU20Q
        STb2aCZd33O+Mq7prZ9EbvAdD0Vy8lMd9Q==
X-Google-Smtp-Source: ABdhPJwT0gYoxoJzqyF+mVw5EZY02M4E2KchGORLvfheKSkDDqC/tfso23X/QH0o/X6r0jm1aYbWiQ==
X-Received: by 2002:ac2:5a11:: with SMTP id q17mr1734969lfn.479.1624495991567;
        Wed, 23 Jun 2021 17:53:11 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id b7sm53776lfe.151.2021.06.23.17.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 17:53:11 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jon@solid-run.com, tn@semihalf.com, jaz@semihalf.com,
        hkallweit1@gmail.com, andrew@lunn.ch,
        Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH] net: mdiobus: fix fwnode_mdbiobus_register() fallback case
Date:   Thu, 24 Jun 2021 02:51:51 +0200
Message-Id: <20210624005151.3735706-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fallback case of fwnode_mdbiobus_register()
(relevant for !CONFIG_FWNODE_MDIO) was defined with wrong
argument name, causing a compilation error. Fix that.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/fwnode_mdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index 13d4ae8fee0a..f62817c23137 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -40,7 +40,7 @@ static inline int fwnode_mdiobus_register(struct mii_bus *bus,
 	 * This way, we don't have to keep compat bits around in drivers.
 	 */
 
-	return mdiobus_register(mdio);
+	return mdiobus_register(bus);
 }
 #endif
 
-- 
2.29.0

