Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47865521FE9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346626AbiEJPwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347244AbiEJPwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:52:08 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F8F1C924;
        Tue, 10 May 2022 08:48:02 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id x22so13822868qto.2;
        Tue, 10 May 2022 08:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4h/3sgiwZZAh9sVqTF8TpILnTbNrmnSNrow0mo4Rdcc=;
        b=nJkTTrZSgx/CxVZqlMx3R99vSMQL//nFGa0hZ07IqiBvDSeqXSh9woBb7OJS56Cgai
         0Eczz7GiCbLotCzZ0RoAwk+04UmWVPqefXwHcWCtVHfsoYKir1gUkz5PcvJDzZPWYQ75
         URMLPjFUroRtaY2wPU9e49KSkKK2clyA5OTfTPRmfC3LA7D5bBVwUwv6tWChLYpP5q4b
         YliYKg8zx9K6d2Adk173DWMSF7K6ESmJdunxWxXgdW2HhDVTAcgzgFAfINNDUzoIKXXd
         lGkUlRAVou6efYVNj35qLHlyuwca4XCM01AFtngv6grLtyX/iW52ydqcsC8bm+QKi7Sq
         0urg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4h/3sgiwZZAh9sVqTF8TpILnTbNrmnSNrow0mo4Rdcc=;
        b=l83P71Whvn/JgaMEcnYfNYMxDEL50qE+Ys7rvvh6UwpxG2Y15Kb7h/avTwFhJCgK1F
         9G1Ca7F9hx1UxAWw6h7donXrCuSDMkJVY4oTVWXMuS06jTQRTSiy9NDQ4KBS9Wpx+feU
         YouAqp2KnjF7UF4MUExJrkpHTPFI/Wc/RDuBBJmSj8STIfzvDfFtPjxv4ysPB3+F/dVZ
         Z1JfGC4eTTqtAqwZNfJUl9TL5y52LQ8Wyo/3ob8fQ/39r+mh7CIM1xgnPhD9kC6vi+lK
         5WIyvzMLPavR1/Jz+qYbv+wsn3TnHSHw6BSuJLXZmtmK2WfxU/S+zgzA7z3/jkQX7a/Y
         ySPQ==
X-Gm-Message-State: AOAM533UUWEg41uKTc9TDCnzHCEHzi4+u1tNgpa7cpEv8nx+OPsxHqj2
        dmlZ+rsUCEupG206X8vIjvg=
X-Google-Smtp-Source: ABdhPJyRxWRJRs5edGWoSur4H0QL70ANK42gtong6CQMuKkJqvRPmtDL3Ea8w/9GEy/oZ2btzNbyrw==
X-Received: by 2002:ac8:5ad4:0:b0:2f3:e0fb:df1c with SMTP id d20-20020ac85ad4000000b002f3e0fbdf1cmr6254624qtd.267.1652197681464;
        Tue, 10 May 2022 08:48:01 -0700 (PDT)
Received: from localhost ([98.242.65.84])
        by smtp.gmail.com with ESMTPSA id o2-20020ac841c2000000b002f39b99f691sm9288209qtm.43.2022.05.10.08.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:48:01 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jerin Jacob <jerinj@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>, netdev@vger.kernel.org
Subject: [PATCH 06/22] octeontx2: use bitmap_empty() instead of bitmap_weight()
Date:   Tue, 10 May 2022 08:47:34 -0700
Message-Id: <20220510154750.212913-7-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510154750.212913-1-yury.norov@gmail.com>
References: <20220510154750.212913-1-yury.norov@gmail.com>
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

bitmap_empty() is better than bitmap_weight() because it may return
earlier, and improves on readability.

CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Geetha sowjanya <gakula@marvell.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Jerin Jacob <jerinj@marvell.com>
CC: Linu Cherian <lcherian@marvell.com>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Subbaraya Sundeep <sbhatta@marvell.com>
CC: Sunil Goutham <sgoutham@marvell.com>
CC: hariprasad <hkelam@marvell.com>
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 6 +++---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 25491edc35ce..921bf9cb707b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -615,7 +615,7 @@ void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
 		return;
 
 	/* Pause frames are not enabled just return */
-	if (!bitmap_weight(lmac->rx_fc_pfvf_bmap.bmap, lmac->rx_fc_pfvf_bmap.max))
+	if (bitmap_empty(lmac->rx_fc_pfvf_bmap.bmap, lmac->rx_fc_pfvf_bmap.max))
 		return;
 
 	cgx_lmac_get_pause_frm_status(cgx, lmac_id, &rx_pause, &tx_pause);
@@ -870,13 +870,13 @@ int verify_lmac_fc_cfg(void *cgxd, int lmac_id, u8 tx_pause, u8 rx_pause,
 		set_bit(pfvf_idx, lmac->tx_fc_pfvf_bmap.bmap);
 
 	/* check if other pfvfs are using flow control */
-	if (!rx_pause && bitmap_weight(lmac->rx_fc_pfvf_bmap.bmap, lmac->rx_fc_pfvf_bmap.max)) {
+	if (!rx_pause && !bitmap_empty(lmac->rx_fc_pfvf_bmap.bmap, lmac->rx_fc_pfvf_bmap.max)) {
 		dev_warn(&cgx->pdev->dev,
 			 "Receive Flow control disable not permitted as its used by other PFVFs\n");
 		return -EPERM;
 	}
 
-	if (!tx_pause && bitmap_weight(lmac->tx_fc_pfvf_bmap.bmap, lmac->tx_fc_pfvf_bmap.max)) {
+	if (!tx_pause && !bitmap_empty(lmac->tx_fc_pfvf_bmap.bmap, lmac->tx_fc_pfvf_bmap.max)) {
 		dev_warn(&cgx->pdev->dev,
 			 "Transmit Flow control disable not permitted as its used by other PFVFs\n");
 		return -EPERM;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 47e83d7a5804..f2c866825c81 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -109,7 +109,7 @@ void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable)
 		return;
 
 	/* Pause frames are not enabled just return */
-	if (!bitmap_weight(lmac->rx_fc_pfvf_bmap.bmap, lmac->rx_fc_pfvf_bmap.max))
+	if (bitmap_empty(lmac->rx_fc_pfvf_bmap.bmap, lmac->rx_fc_pfvf_bmap.max))
 		return;
 
 	if (enable) {
-- 
2.32.0

