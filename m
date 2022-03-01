Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B5E4C985F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiCAW3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiCAW3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:29:37 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652AD1CB1A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 14:28:55 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id i11so23883680eda.9
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 14:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dp2oVP3qjzT/hSJQBTqgn28llToz992qrD5qJEQZqRs=;
        b=cK0KAl7FTFlF294LxPeD1FhzVOXfl8kZtor5fUCykvsXoky0cLv5CKBldwBg98rimN
         R6AbT2X9PukTeJSeM2VOWib48a7/yBFwADEhOLjqcD+sEuuN9g+tdb1b3WvM54+VkOdp
         h/qA2qsW9XBT/eAN0OrdYz82xKZlpX6R2romxTUi1Zp6XuHoAyTxeSOC82FqIqVUNBQ9
         O8krVJ5du8RRuxf0qdk6swvLlZ3DqVoTBQgpPZf3kZJrSM6woJ/Hk2P5p80HCa/VnTVO
         zdokS+9qCr5pkhlnVBb5f5EFsnfsfFn508/VTo6qTANick00tJHYB+BFTw5f2D15yDMO
         O6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dp2oVP3qjzT/hSJQBTqgn28llToz992qrD5qJEQZqRs=;
        b=KP6SqOw8BSRixEUjkuLi3rl5iEZ2ktbCxOGr7Lu4P0zeqsfIAQAyoM22c8FkLYkDFh
         NaP0aCrUMzTJlJuKi5w7+D9zOj6sUz1hNgm/BJ32GYBAvT0lF2SRf2ITjFx2FM+sBnFp
         Q46u7BonchP0ztNEoJUw2K68dSWx3TMK9vNI2FcKVbtWzAGiSiS079sdwH3XoNxTTFBn
         xyoMRcYS7kCl+9xe+dMFgRACRiog828+LYJ6s99XecV+nEQ/yGcKdK5fhVzgdgEcK336
         I69yDWPWhR+JyXzKCKTCTSMkB7yv8HaXh5jTmXt0IQSqHHu7+W5TBGFAL7Mozzncxbra
         LCVw==
X-Gm-Message-State: AOAM530trKnJt7bFCVllZ9aHrboxe/mt3/rx7/YcdhnA5g603yYBK3cd
        OZBwiziZmT4jprPnfTVfBdQv0SFXAz4=
X-Google-Smtp-Source: ABdhPJzaxcoh+936UNrBUJ9nz1nWH9+IvjHplJ44rT9WFfeUIIRwmTWbVLFNm1b8j4RP7Tjwy8jl+Q==
X-Received: by 2002:a05:6402:50d4:b0:413:2a27:6b56 with SMTP id h20-20020a05640250d400b004132a276b56mr26879456edb.228.1646173733994;
        Tue, 01 Mar 2022 14:28:53 -0800 (PST)
Received: from nlaptop.localdomain (178-117-134-240.access.telenet.be. [178.117.134.240])
        by smtp.gmail.com with ESMTPSA id t19-20020a1709060c5300b006d582121f99sm5687350ejf.36.2022.03.01.14.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 14:28:53 -0800 (PST)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] sfc: extend the locking on mcdi->seqno
Date:   Tue,  1 Mar 2022 23:28:22 +0100
Message-Id: <20220301222822.19241-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
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

seqno could be read as a stale value outside of the lock. The lock is
already acquired to protect the modification of seqno against a possible
race condition. Place the reading of this value also inside this locking
to protect it against a possible race condition.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
 drivers/net/ethernet/sfc/mcdi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index be6bfd6b7ec7..50baf62b2cbc 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -163,9 +163,9 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 	/* Serialise with efx_mcdi_ev_cpl() and efx_mcdi_ev_death() */
 	spin_lock_bh(&mcdi->iface_lock);
 	++mcdi->seqno;
+	seqno = mcdi->seqno & SEQ_MASK;
 	spin_unlock_bh(&mcdi->iface_lock);
 
-	seqno = mcdi->seqno & SEQ_MASK;
 	xflags = 0;
 	if (mcdi->mode == MCDI_MODE_EVENTS)
 		xflags |= MCDI_HEADER_XFLAGS_EVREQ;
-- 
2.35.1

