Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675406435FA
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 21:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiLEUqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 15:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbiLEUqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 15:46:11 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6542A957
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 12:46:08 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id fc4so1329678ejc.12
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 12:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WuFAQ0v5aLWdC7HoyL7gWW2N4Fcoas9srNPvbE2PlSI=;
        b=Kh9022foKHxv2IuneGH3KcskvUGhatfsHW9pjdrTewUvyQ4ouVTRQf63B9VThbyG/V
         lgH7Qp+FZwJq5DuniTFh7ihD5jt2Q+AKlAcKHKrf7mSZuibkbFf8fspeBx7/hBAs1r/1
         KYBCp9EFJL7YgVR956qPSVu+aWeRzUFJctbxY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WuFAQ0v5aLWdC7HoyL7gWW2N4Fcoas9srNPvbE2PlSI=;
        b=NEh6JTCuhSMKJ4loS/AxKWRBg7ZTuFhtDTiVpqax7u4sbE63r963i3+PuvviMEt8sA
         kcAejgaiF2/xyNccPFY3ViiEHt0yutYMJR2YRvBjfhU72zDGSS90G385eVT2Je+Dbzbl
         dyjZFCfftOO0N3/stlQ7BxXQgZHwB5oelcCyv7GL2rjeeKWVJItZ1PtkOhxt7hlA+Jbu
         /OSxMQNvOH5hvjXqsujsOfE9lm4dz/ObzKLOdNaLKK9HVQ1jOtQPYmWYhaSoHvy2oeZB
         zNxx0Djm8O9z61TAqRcDxx6gYibtUVmTZSfd40U2W/IQMedlncCmSFf4tNgSBEGLHaC+
         Ld/Q==
X-Gm-Message-State: ANoB5pnD1m4EWWRfLQ/wUD0PskadnifbuojSZeNMZlJrAiz38gBDgLzb
        3QaXR93PLEP/R0lkTZQ1Knt8uA==
X-Google-Smtp-Source: AA0mqf6Ff/YPDvYU4XmfxDeXWo8Pxe41pVK2kq7G17XK99TY5VKTtdXzb9kyGYZtgUSb0wGH9Mjdug==
X-Received: by 2002:a17:906:7f90:b0:7c0:ba2c:a4e8 with SMTP id f16-20020a1709067f9000b007c0ba2ca4e8mr15296522ejr.642.1670273166741;
        Mon, 05 Dec 2022 12:46:06 -0800 (PST)
Received: from localhost.localdomain ([80.208.71.65])
        by smtp.gmail.com with ESMTPSA id d21-20020a170906305500b007838e332d78sm6584829ejd.128.2022.12.05.12.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 12:46:06 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Ungerer <gregungerer@westnet.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: fec: properly guard irq coalesce setup
Date:   Mon,  5 Dec 2022 21:46:04 +0100
Message-Id: <20221205204604.869853-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to the Fixes: commit, the initialization code went through the
same fec_enet_set_coalesce() function as used by ethtool, and that
function correctly checks whether the current variant has support for
irq coalescing.

Now that the initialization code instead calls fec_enet_itr_coal_set()
directly, that call needs to be guarded by a check for the
FEC_QUIRK_HAS_COALESCE bit.

Fixes: df727d4547de (net: fec: don't reset irq coalesce settings to defaults on "ip link up")
Reported-by: Greg Ungerer <gregungerer@westnet.com.au>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2ca2b61b451f..23e1a94b9ce4 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1220,7 +1220,8 @@ fec_restart(struct net_device *ndev)
 		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
-	fec_enet_itr_coal_set(ndev);
+	if (fep->quirks & FEC_QUIRK_HAS_COALESCE)
+		fec_enet_itr_coal_set(ndev);
 }
 
 static int fec_enet_ipc_handle_init(struct fec_enet_private *fep)
-- 
2.37.2

