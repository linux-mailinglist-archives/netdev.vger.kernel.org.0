Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE7636061
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbiKWNtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbiKWNtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:49:31 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744988D485
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:38:59 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id j4so28239210lfk.0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wS8FATQNxWPdriQp0BbXocQzCpC+MIR+DcVNfDAhwFk=;
        b=goY0xT6u7EULHQx2MRhg/J+3Xshao0AkK0Kw/Yhep2ABZQKNds0sD0jO44XqILT85D
         GMpgwtt4t0RcnMdLfGn72E9O9T3qn7XUT2okgutwciPevDbju3FcMf/01ixtJfXX7Iiq
         fDbqCLjRKHOzrt5uEOMdWfHgwoVRnlv2IfOnw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wS8FATQNxWPdriQp0BbXocQzCpC+MIR+DcVNfDAhwFk=;
        b=I837qklgSWUwvUy9Gdqw0x7NxL5fMOGwkL2OfYpWfU5lAhe+RECrSZ+JseRPyJcZdu
         loyqaosuosQvy8YXYFcrSr4Qyqk6khwu7hkKacdo5nAm1QeJjA5MLL5hejJauXhEW0rv
         s0h9AlwGG/dY7OVr3yHRWLehxd2S8Ri42++VwBoHPM4C51FC07p8Im8vnzy2znC7uu/E
         AY5ZQ98q9MYqkMUicD0ctGiYTh5JltLEOzQedOvWGdwfO4GDvvzk6A/7NbtA3tv5wo8r
         L/9AicE6SOj+PwDnvKUGqdwLil6KSqf9kHp1tL3cirqdw6jxC0e/fNoMQc3Z9Ss5N93T
         WeIQ==
X-Gm-Message-State: ANoB5pkm4cmdYcjMJyqlpIrw2EOeQrPr7fVPEuMk7YxMRihydOqN1UaY
        +AbAslf9D2o6YDNalNKJezBrdg==
X-Google-Smtp-Source: AA0mqf4f1qphI9rYgYg/KQyHXOZ4X9v9VsEAFcQc3JIS1A5jOOVNZ/Gqskm/9D51RpT1s9TMN21moQ==
X-Received: by 2002:ac2:4bc5:0:b0:4b4:c099:a994 with SMTP id o5-20020ac24bc5000000b004b4c099a994mr7840595lfq.193.1669210737739;
        Wed, 23 Nov 2022 05:38:57 -0800 (PST)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id r9-20020a2e5749000000b002774e7267a7sm2224924ljd.25.2022.11.23.05.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 05:38:57 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: fec: don't reset irq coalesce settings to defaults on "ip link up"
Date:   Wed, 23 Nov 2022 14:38:52 +0100
Message-Id: <20221123133853.1822415-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when a FEC device is brought up, the irq coalesce settings
are reset to their default values (1000us, 200 frames). That's
unexpected, and breaks for example use of an appropriate .link file to
make systemd-udev apply the desired
settings (https://www.freedesktop.org/software/systemd/man/systemd.link.html),
or any other method that would do a one-time setup during early boot.

Refactor the code so that fec_restart() instead uses
fec_enet_itr_coal_set(), which simply applies the settings that are
stored in the private data, and initialize that private data with the
default values.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f623c12eaf95..2ca2b61b451f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -74,7 +74,7 @@
 #include "fec.h"
 
 static void set_multicast_list(struct net_device *ndev);
-static void fec_enet_itr_coal_init(struct net_device *ndev);
+static void fec_enet_itr_coal_set(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
@@ -1220,8 +1220,7 @@ fec_restart(struct net_device *ndev)
 		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
-	fec_enet_itr_coal_init(ndev);
-
+	fec_enet_itr_coal_set(ndev);
 }
 
 static int fec_enet_ipc_handle_init(struct fec_enet_private *fep)
@@ -2856,19 +2855,6 @@ static int fec_enet_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-static void fec_enet_itr_coal_init(struct net_device *ndev)
-{
-	struct ethtool_coalesce ec;
-
-	ec.rx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.rx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	ec.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	fec_enet_set_coalesce(ndev, &ec, NULL, NULL);
-}
-
 static int fec_enet_get_tunable(struct net_device *netdev,
 				const struct ethtool_tunable *tuna,
 				void *data)
@@ -3623,6 +3609,10 @@ static int fec_enet_init(struct net_device *ndev)
 	fep->rx_align = 0x3;
 	fep->tx_align = 0x3;
 #endif
+	fep->rx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->tx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->rx_time_itr = FEC_ITR_ICTT_DEFAULT;
+	fep->tx_time_itr = FEC_ITR_ICTT_DEFAULT;
 
 	/* Check mask of the streaming and coherent API */
 	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
-- 
2.37.2

