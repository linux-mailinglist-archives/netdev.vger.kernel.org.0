Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F93227294
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGTXAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgGTXAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:00:30 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7A2C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:30 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so9801624pfe.5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Aw1VCtLQwFy/bRNCot7lwpI/hG+gYM/cfiPxqIs0Atc=;
        b=B9Im0OEjzDhscP/5gmctJZFma7oDEw7nh8PX8A0zg3AoEe4w/udY2TmjuDNEJPA5XE
         c3rIjCs5Ril1WVsLtUG8yvy87XbPzIg/kx5kajfSORWZZHdpscfISQQjDOTzjIaav5AL
         AwAiiHgV/qX0/OZHUe0bnXMxi2jGBQNr3Xagorb7fbEmexDJqchj3MJXJlGSL+W+Ekl/
         xJPmvClm6ZEDk7lalq0oZoorg9b+KdzFXdnFIIRHe8gu5EUmtWD21dKcgP6g89gJ3qWh
         29HIaVoS2rRe3t6DqFqnvRYqg9axwTPrsiCn/1YOvUuu/vp+zn5nnDwCXx4KNkWjXa8d
         BVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Aw1VCtLQwFy/bRNCot7lwpI/hG+gYM/cfiPxqIs0Atc=;
        b=dLLlETPovnCsAjqr8Sq5Rw9PyoWZflnarkzxD/CAkS4qNWSNoYtH2TmH4JxtoKZlw9
         qaC4zOhB0rSwFdI6qTkmq2Z4hLzX3ha97MC0TNDaYQnnO5igGJaKv9oQo6XNOd6Mt2Ty
         ZIXlu6sA+XRMB2sWk9ooyTtxFuKRVhHMZZbUowdUjQ7EjV9A5RdsH8AzkKt6sMUmvpsD
         5dnz3goqaXVD7/okVSCrEixuKWkYfJPve2QVowdnKLHlKp0sQb9PMTzTLv7nnkuTIwIW
         fEivc6OzeLNhMEB+qKvW2pLUFlH21KFKcCfkfEU+BvV6AiyfpAlivSNL8tFWdtn37dFq
         sd3w==
X-Gm-Message-State: AOAM530NxwvGAbScQuO2r1VZfeoovVst19/XabmNd50nt1naiIsZTr0g
        bh/Pn2OFkDUNx/MJNCgg2fPQADXIZz0=
X-Google-Smtp-Source: ABdhPJxICO5Io5w/LpoO6Vxw31OF3RUgprUaT//qiaw2V/oN8vqp9C6v2J9A4axhPA6eYY0iwuwxhQ==
X-Received: by 2002:a63:4b1d:: with SMTP id y29mr20815187pga.264.1595286029435;
        Mon, 20 Jul 2020 16:00:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n9sm606738pjo.53.2020.07.20.16.00.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:00:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/5] ionic: use offset for ethtool regs data
Date:   Mon, 20 Jul 2020 16:00:13 -0700
Message-Id: <20200720230017.20419-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720230017.20419-1-snelson@pensando.io>
References: <20200720230017.20419-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use an offset to write the second half of the regs data into the
second half of the buffer instead of overwriting the first half.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index e03ea9b18f95..095561924bdc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -103,15 +103,18 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
 			   void *p)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	unsigned int offset;
 	unsigned int size;
 
 	regs->version = IONIC_DEV_CMD_REG_VERSION;
 
+	offset = 0;
 	size = IONIC_DEV_INFO_REG_COUNT * sizeof(u32);
-	memcpy_fromio(p, lif->ionic->idev.dev_info_regs->words, size);
+	memcpy_fromio(p + offset, lif->ionic->idev.dev_info_regs->words, size);
 
+	offset += size;
 	size = IONIC_DEV_CMD_REG_COUNT * sizeof(u32);
-	memcpy_fromio(p, lif->ionic->idev.dev_cmd_regs->words, size);
+	memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
 }
 
 static int ionic_get_link_ksettings(struct net_device *netdev,
-- 
2.17.1

