Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138B63900FE
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhEYMaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhEYM36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:29:58 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DABC061756;
        Tue, 25 May 2021 05:28:27 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id i19so16413181qtw.9;
        Tue, 25 May 2021 05:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZEBquhrvxEEZ+Rfflk8qX6KV/2dhTwjR4HwVe1AUMuA=;
        b=oEIBrt5eAQXFZH6xnY4AVKGequcDkyRtnOsajdKchUgZN0KzbPRJIwYR58NFLmIJgO
         CS449KwjpSBmP6OrgURbmtZW+dtu4axnCgrbmXwLg1r3AUqGfAFZqDhN7fAjMNBxxuQ4
         sC3rXoYB90iF5AXvesSiv0PyPG5Lv/kWfQQ8TT6P75avTMdIHzSudUgwCU+06wpWH9pI
         2miWb9sUgE9CPs4D67IC97y4gFFHWLvy9i9kc+xIGfWVYG3N9PkOJH1ARKZTMQBPa+vP
         eqPhCU2mdG9wY/u3F7lTAaPEVgTqNXb0kXC+TPmdr4F+eHL97pUXc49/3Ecd2sDChzFd
         kRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZEBquhrvxEEZ+Rfflk8qX6KV/2dhTwjR4HwVe1AUMuA=;
        b=QF6Puz+OS1QiMcxWL9vVAbxujVyCizoRKrud8i5AYOpYqQTigaalGAGtxGFgTTSx9S
         TCr+M7eq0ctFXMGY0Vdhf8lR20xVzpCbbdfUPu9fc+VzthvzMHu4CuXUPeIePqa0vVjN
         RE6MJ/Bi4YvYt7Y9GtHQyaUXhu5Fi8QgZvxqVb8m/jvemji1Dxo8sV6feWwyNBSehq9M
         s7nDub+2nm7MnBf56wuGjthA0jPPXjYRsqp1/+EK/61Z+Lviszv/DSerBZjEh0cU3Yut
         iKVKmA6AmXduOUt07R4phff3odwLMukG1wd7bxR7q6np1R190KHqKPsD/cuJ0Y1r106e
         yYFA==
X-Gm-Message-State: AOAM530fhFQMIFTpQOV/3cjslcjbCsJAh37SUTwEtyM414AAuLrUPxto
        eTDCP/Mye8ks0cl/keB1e54=
X-Google-Smtp-Source: ABdhPJyI4PoUWQdUVZbCc5YNfZZVUQaV7HBQM5d3rzdWBptYyoWYXe7BFKMkD9ypnwB23jRWIhQumw==
X-Received: by 2002:a05:622a:1114:: with SMTP id e20mr30942517qty.324.1621945707054;
        Tue, 25 May 2021 05:28:27 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:a465:c799:7794:b233])
        by smtp.gmail.com with ESMTPSA id t6sm13292572qkh.117.2021.05.25.05.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:28:26 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Peter Geis <pgwipeout@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/2] net: phy: fix yt8511 clang uninitialized variable warning
Date:   Tue, 25 May 2021 08:26:14 -0400
Message-Id: <20210525122615.3972574-2-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525122615.3972574-1-pgwipeout@gmail.com>
References: <20210525122615.3972574-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang doesn't preinitialize variables. If phy_select_page failed and
returned an error, phy_restore_page would be called with `ret` being
uninitialized.
Even though phy_restore_page won't use `ret` in this scenario,
initialize `ret` to silence the warning.

Fixes: b1b41c047f73 ("net: phy: add driver for Motorcomm yt8511 phy")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
---
 drivers/net/phy/motorcomm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 796b68f4b499..5795f446c528 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -51,7 +51,7 @@ static int yt8511_write_page(struct phy_device *phydev, int page)
 static int yt8511_config_init(struct phy_device *phydev)
 {
 	unsigned int ge, fe;
-	int ret, oldpage;
+	int oldpage, ret = 0;
 
 	/* set clock mode to 125mhz */
 	oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
-- 
2.25.1

