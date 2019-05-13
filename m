Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3951BEF4
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 23:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEMVG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 17:06:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40438 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEMVG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 17:06:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id u17so7844142pfn.7
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 14:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JKX8+TGCBym1W7RNRu7kSlxqFn5AiMIU9Uyu20CDlUc=;
        b=gOW3nWLH6HYfF8nW169LN2YP6glrBK4Or6LZ7IdHwSW0Cn70ZTd4C3fLs2Yk7m/src
         NlTZYV7TJ121kNQVNzX/TYT4CCgTxna4pwzmC1zQAC/CzwpXFwCcBQarDx9qiPeijtRa
         wqj9pP7o9uQ/G+7KzQq7dkz6xTJq90nbo3Jbjh2oxpneBsq0v5isciXPM1WaPp4uGxC8
         n5RyukBwEYQMJ3j+fMivY12pEFKTeQtGFAPC0CS+Mxr7izS+rsLmSUcbxkHdjdPeBXi7
         +bwHJ4SbWtNsiLJvjSwlNprS1YkDPN9gz7uQ2klKGPmweggjwfokzUbsjkeQCQnYh31X
         UkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JKX8+TGCBym1W7RNRu7kSlxqFn5AiMIU9Uyu20CDlUc=;
        b=uYk7r8pthY7yBZmJhJU9g489EqHtbhiZTBUvpn3IJcEUMZvHWXtqLm8MSW0HC9pi13
         5xDIDxU5wXrUSLLhBvRPG8oMZjg5rCXRogyAWj1fjT4PW/R6F3ZcQwcwCQUXVCwb4Y0x
         E+2YnKG4gRIEZhcta3xIAtYx3PzmhAY1m9dVzxm+G1L9c10YqnXsSlRRtHVqxd/syWOk
         /rMZXwOhPbl1Fpz5iR6l4dqRlZPhK7eMp7JZC7EcZFj3TdBgY4HF3GtDfoMGeC0HNsl9
         KFKJujNJQV5x2LL7WLGtVc/tz2B6Sbf1+4pK0ttZNo1vPCrxjv/YL2NqOO8U/zU819Mu
         S6GQ==
X-Gm-Message-State: APjAAAUYGDdRX06EMA15iazl/Bp8+6dW9wD7JgEmWGL3xEF22uJLXSbb
        JYHtCIPkOC/temR1oB1Mg9QROdgC
X-Google-Smtp-Source: APXvYqx6VNoi1qAZSU8u4XdmTOpzzFIpi9WpSeuxUMNdFuqnq7LWe8lvOUhh9WgrWpBCaS0hyRUDig==
X-Received: by 2002:aa7:998d:: with SMTP id k13mr23134292pfh.217.1557781587396;
        Mon, 13 May 2019 14:06:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id e12sm16401449pfl.122.2019.05.13.14.06.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 14:06:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] net: Always descend into dsa/
Date:   Mon, 13 May 2019 14:06:24 -0700
Message-Id: <20190513210624.10876-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri reported that with a kernel built with CONFIG_FIXED_PHY=y,
CONFIG_NET_DSA=m and CONFIG_NET_DSA_LOOP=m, we would not get to a
functional state where the mock-up driver is registered. Turns out that
we are not descending into drivers/net/dsa/ unconditionally, and we
won't be able to link-in dsa_loop_bdinfo.o which does the actual mock-up
mdio device registration.

Reported-by: Jiri Pirko <jiri@resnulli.us>
Fixes: 40013ff20b1b ("net: dsa: Fix functional dsa-loop dependency on FIXED_PHY")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 21cde7e78621..0d3ba056cda3 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -40,7 +40,7 @@ obj-$(CONFIG_ARCNET) += arcnet/
 obj-$(CONFIG_DEV_APPLETALK) += appletalk/
 obj-$(CONFIG_CAIF) += caif/
 obj-$(CONFIG_CAN) += can/
-obj-$(CONFIG_NET_DSA) += dsa/
+obj-y += dsa/
 obj-$(CONFIG_ETHERNET) += ethernet/
 obj-$(CONFIG_FDDI) += fddi/
 obj-$(CONFIG_HIPPI) += hippi/
-- 
2.17.1

