Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42ED411F539
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 02:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLOBLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 20:11:03 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39033 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfLOBLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 20:11:03 -0500
Received: by mail-il1-f195.google.com with SMTP id n1so2614844ilm.6;
        Sat, 14 Dec 2019 17:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iCgRvU1WGRJdB8v0mlRWij6VbYbiUNZ9qlhjDWyv8b8=;
        b=mm8H9mwC/H/B8L0ty+x6fcNvz2ecrsgaucPP5ScxIuULp9xV8c3kSOfLyVGkYoQpn7
         uPXaE/CijJAssAhAeilkHYXZLa5R/2oicE0u0UnqKFdBpeQUFPDWIE5xaL21KMv3yrKt
         1joiBx5xrRHuWNl6KMt1g2wW2p5lwVHRxxfFbwcUBJ8F1QSMRkEDGAfWAwx8WvipCkaF
         NFBphQv26wL4csd5dfB6/GZfyJ4yJEs5yWtfF98WpHkQGeGigkdWbt6K8QLgCssj8PCM
         0ScrtnuJO3zF57oGe5SIDAeVJV6N/vzck3Y5jtHGa52HTIu+yL2NMDLe6nebM1P8TB1d
         Osqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iCgRvU1WGRJdB8v0mlRWij6VbYbiUNZ9qlhjDWyv8b8=;
        b=M42Cu2hKNcZD2fo2pSOfRKRz/MRNhcOSqKOVZvUAKqcHqOYK6S+jQ8M/5cvjlG1xvP
         zojyj6YsFMjdy/XWO7liAJTI4CjvjaBYwcyHaqYY5gsTHIHVdvtYDie7gZZRh6uwaEMx
         2V17Lbjh68P69fWzeaqgUjrzH0jlAx37ib5sm8Oi7Y6QYATyQ3OJF4g9DsAD1bRpSKn+
         6/0eeNGM5obbv5SoezdkujiGCXidcKVH5daxqqI5h1oI8w0x4jJBUoLUy68w8qzOHTcy
         8IofWhb+evR9V4xWTcJqMCFIP4lxCpnlNZUOuTyl3MuqYKomIUjEBOF/IyMMzGS7dQUt
         UXzQ==
X-Gm-Message-State: APjAAAU6i2Sg0tlbeiZSDjaIF5V/+iAg62T62cxtZnP24od/9cM80INh
        HVRAGqMKXysHQrSohyJntT4=
X-Google-Smtp-Source: APXvYqwKeEjguHOSD5k7hXba9znk0S8i3ioaEZxvZ7qBuvFHYAtLl17fRxCyhC2/A6BeFGt22r3lwA==
X-Received: by 2002:a92:5c8f:: with SMTP id d15mr6913133ilg.102.1576372262269;
        Sat, 14 Dec 2019 17:11:02 -0800 (PST)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id 129sm3173169iox.84.2019.12.14.17.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 17:11:01 -0800 (PST)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] net: gemini: Fix memory leak in gmac_setup_txqs
Date:   Sat, 14 Dec 2019 19:10:44 -0600
Message-Id: <20191215011045.15453-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of gmac_setup_txqs() the allocated desc_ring is
leaked if TX queue base is not aligned. Release it via
dma_free_coherent.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/cortina/gemini.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index a8f4c69252ff..3a796fe099dd 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -576,6 +576,8 @@ static int gmac_setup_txqs(struct net_device *netdev)
 
 	if (port->txq_dma_base & ~DMA_Q_BASE_MASK) {
 		dev_warn(geth->dev, "TX queue base is not aligned\n");
+		dma_free_coherent(geth->dev, len * sizeof(*desc_ring),
+				  desc_ring, port->txq_dma_base);
 		kfree(skb_tab);
 		return -ENOMEM;
 	}
-- 
2.17.1

