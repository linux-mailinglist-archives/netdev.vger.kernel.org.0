Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA92287B9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgGURq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgGURq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:46:27 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A542C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:27 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t6so10580943plo.3
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Aw1VCtLQwFy/bRNCot7lwpI/hG+gYM/cfiPxqIs0Atc=;
        b=EoHZuMsaL/mQ8Zm2gbbB/EBHrkXAxoISTTQ9eGvbeQNgS5qGzHaZ9SqC+XfWUelBEN
         ncBVp8WEls9VHgAVz/0VSwL4zmiq6Ac1sxhAveUFQbHipP9K4lnm/Sxnkte1L4iXSFE3
         Ne0MU0JJ9ZRfdVamhA2jo9fS+SDm0h0MzDJt/RyffF50WnPjRVmkBd2q6fwSri/wzZb2
         s1335N94vaR97yWJQ8d0t/zwh8Qhr/dRv+B+6TGWijz19zha4x5YS7rApCl6ei6pbrSa
         SSIFUOs8t9WuKBN6bVpnmBNpNT+5guk64un9EneFj71nMCxmK7CQgZJXpOY9zcjajqDR
         nWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Aw1VCtLQwFy/bRNCot7lwpI/hG+gYM/cfiPxqIs0Atc=;
        b=tiUeiZ36kGRqmGHlv7GzCA090TEkf9b94J4wOWMwH5DP3K32qWAhVu1ZW1TohyYFmJ
         HwoBqPoWX2L//fkdNNH86aUs8fKlOBNyag/z3vKrK1j1duQWnCraJwhZBvEx0GZM/uUe
         jW2DekOyTacw0F1U3NZ8w1q+zS44a88DdbHR26hjGwm3souRt4ybKefGZMe+nlq44jj9
         A2JiQP8iWpY6mJqQ2JLKerQFC02B0XeAp31RkQ/bcSsKSyLfFHNZ4FyTazHC32iMcdHl
         pVC9LwApHhHyNZE0tIKmZA2P+HVfZYJUh+gnHGTohpklFfSrY+kVenVItBufwgybrDEq
         jlBw==
X-Gm-Message-State: AOAM530ngxFsZcR9x6mxucDdlOgx61jTmfemBAlM5MzBPtAUpRfeSRtG
        yciFRhZaGBnNXXRJOiNt4cX81lPwbss=
X-Google-Smtp-Source: ABdhPJwAENs7mZQ7rsfj4Y7tsxmvF79TVKjYZ1aqtfRxTwUTiEcRnWTLS/C+k0waV1QwdQnQ9TOLpw==
X-Received: by 2002:a17:90b:46d7:: with SMTP id jx23mr6310844pjb.191.1595353586860;
        Tue, 21 Jul 2020 10:46:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c14sm4598712pgb.1.2020.07.21.10.46.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:46:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 1/6] ionic: use offset for ethtool regs data
Date:   Tue, 21 Jul 2020 10:46:14 -0700
Message-Id: <20200721174619.39860-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721174619.39860-1-snelson@pensando.io>
References: <20200721174619.39860-1-snelson@pensando.io>
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

