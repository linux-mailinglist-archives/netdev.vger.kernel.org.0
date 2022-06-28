Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A345355E9E9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbiF1Qfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237610AbiF1Qeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:46 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A20932068
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fi2so26872159ejb.9
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=El3W9x0OB1VE70B0Lt3SBVyO+pC/HDeoL5aPqYtLRdg=;
        b=npVyrA+/Jxlq6fQfSTCBYtF6RmczZxbWUN+tD+OAYyplLmUOvHpooBMDuJlKKO4PZJ
         yCZoY4jC/PAH7YPpacPIeDx58jw6tAJqfpGJC8HRQ+q5j8M0r5LiiQuEpXcF8XKwWMq+
         JsMRX/RrrOZLybaPcnDecKT1rm1MJeKuhH3vY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=El3W9x0OB1VE70B0Lt3SBVyO+pC/HDeoL5aPqYtLRdg=;
        b=o5KxxqkyiYds4Xbw4OUcGXiblVRrZZ6Mpx4DtfcTo6w3YXAICj34HO10514kZ3nFXa
         bSyJRvJYUyBVVehoel0GjmPsaSy1V8tvioYyN2TXoEg+d6GLLjOUi+hK7lhJP2Uebuqs
         hDthf+FXioJEBhDaEvWgiU/YJgeQ2VNZ4mbS+LYTjjka3qHgcOel/wqkMeBHno8OdBTb
         bC1wwvu3wp92hyWJgJBHU4FE5ExV17bRLMT24puZ8XYKzyiRMTAwNzEgYf3CyPsZv5uF
         FGEfGiOFtBonhDeL4a3Sg2Od7MWeIrfGdHfmZ1mGUQG7fNrcwBeaukpvtLT+eZz/2Sx+
         5uDg==
X-Gm-Message-State: AJIora810q14RHlaeOX0XYVurz3X4CImN1PCOrQj7UOn0WDvAP3FQaV7
        2pv6stxckRDhtvZj+F5PV+2m4g==
X-Google-Smtp-Source: AGRyM1ug5KAKVeOz1cwMowwc8MY9LikfKxR5xcB86gl7L4gplcpPsJB7grN/of4FQuYTMReB9hEP3g==
X-Received: by 2002:a17:907:7e90:b0:704:b67d:623e with SMTP id qb16-20020a1709077e9000b00704b67d623emr19098655ejc.634.1656433910961;
        Tue, 28 Jun 2022 09:31:50 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:50 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 02/12] can: slcan: use netdev helpers to print out messages
Date:   Tue, 28 Jun 2022 18:31:26 +0200
Message-Id: <20220628163137.413025-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace printk() calls with corresponding netdev helpers.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/slcan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index b37d35c2a23a..6162a9c21672 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -365,7 +365,7 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 	spin_lock(&sl->lock);
 	if (!netif_running(dev))  {
 		spin_unlock(&sl->lock);
-		printk(KERN_WARNING "%s: xmit: iface is down\n", dev->name);
+		netdev_warn(dev, "xmit: iface is down\n");
 		goto out;
 	}
 	if (sl->tty == NULL) {
@@ -776,8 +776,7 @@ static void __exit slcan_exit(void)
 
 		sl = netdev_priv(dev);
 		if (sl->tty) {
-			printk(KERN_ERR "%s: tty discipline still running\n",
-			       dev->name);
+			netdev_err(dev, "tty discipline still running\n");
 		}
 
 		unregister_netdev(dev);
-- 
2.32.0

