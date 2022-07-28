Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E1B58392F
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiG1HDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiG1HDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:03:07 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF55927A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:06 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id va17so1686236ejb.0
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W6W3RCGbQm1ftNxYyveQiUbovGJZ//OaxbWEapVu2yM=;
        b=RMGtU7wa3UslEpI8xFxyuBq85BrBQa1EIe6ZZK8JQfbmJImOag3Lo/f6/9n3yIeGAf
         rQGt8YLaIfAPDF3SEr3Ky6v2rPZ5bteL0UEN5FYZNbRGSrjJgoKR9tAvIb/4yzEu5042
         d3O57JASdLqdVorgzx3y0hGmbBl3BGVytE0nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W6W3RCGbQm1ftNxYyveQiUbovGJZ//OaxbWEapVu2yM=;
        b=rZxqRRnuufgdN/AGCz2YorTJl6wjG3CdwvHk1QEFWAaTmIi7NAqgpDMlVdu6GEmfuP
         e7YVS2wmr6UlJKFeW/iLoDD4V7jMIxAEQlNsZB6HCJSaRYiAYLIC0onO0UYRnFxQZ1Eb
         BYyF4ovp6jUv8mnYQYAQDAWCeezEhwHUgMXhAwoL2JgpKlFCYIBuoNAyAZQIfNdEkyt4
         86Ccnws3Ob+SdilmVL1ZdWoAT8rpshwqkOwpskSUTj9wx3ObFugUF0jwXbE00nmXIQyg
         GnGE+nL1lPrH2HcMPLmgWutPqHzxqBjnpZcEZCbAZiaCS+U4i38FBjsnL1DMjJCCXinZ
         +lzA==
X-Gm-Message-State: AJIora/1WzPPpR5oY92RExCPi0gNAzy40aBu8RNm3pjcHvnt5vIZpsxX
        J/fmIHuDjgRejE7wUa2t3XYJNA==
X-Google-Smtp-Source: AGRyM1spzt09OhzWtMpiRi8Bta1eT98E8Lb4duL5a3qcetXNCnKkplAmNgSlKyzj8QD9+m5ICLwuiQ==
X-Received: by 2002:a17:907:28d6:b0:72b:7497:76b with SMTP id en22-20020a17090728d600b0072b7497076bmr19828979ejc.365.1658991784453;
        Thu, 28 Jul 2022 00:03:04 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id r18-20020aa7d152000000b0042de3d661d2sm154742edo.1.2022.07.28.00.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 00:03:03 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [PATCH v4 1/7] can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded names
Date:   Thu, 28 Jul 2022 09:02:48 +0200
Message-Id: <20220728070254.267974-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
References: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The driver uses the string "slcan" to populate
tty_ldisc_ops::name. KBUILD_MODNAME also evaluates to "slcan". Use
KBUILD_MODNAME to get rid on the hardcoded string names.

Similarly, the pr_info() and pr_err() hardcoded the "slcan"
prefix. Define pr_fmt so that the "slcan" prefix gets automatically
added.

CC: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/slcan/slcan-core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index dfd1baba4130..2c9d9fc19ea9 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -35,6 +35,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
@@ -863,7 +865,7 @@ static struct slcan *slc_alloc(void)
 	if (!dev)
 		return NULL;
 
-	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
+	snprintf(dev->name, sizeof(dev->name), KBUILD_MODNAME "%d", i);
 	dev->netdev_ops = &slc_netdev_ops;
 	dev->base_addr  = i;
 	slcan_set_ethtool_ops(dev);
@@ -936,7 +938,7 @@ static int slcan_open(struct tty_struct *tty)
 		rtnl_unlock();
 		err = register_candev(sl->dev);
 		if (err) {
-			pr_err("slcan: can't register candev\n");
+			pr_err("can't register candev\n");
 			goto err_free_chan;
 		}
 	} else {
@@ -1027,7 +1029,7 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 static struct tty_ldisc_ops slc_ldisc = {
 	.owner		= THIS_MODULE,
 	.num		= N_SLCAN,
-	.name		= "slcan",
+	.name		= KBUILD_MODNAME,
 	.open		= slcan_open,
 	.close		= slcan_close,
 	.hangup		= slcan_hangup,
@@ -1043,8 +1045,8 @@ static int __init slcan_init(void)
 	if (maxdev < 4)
 		maxdev = 4; /* Sanity */
 
-	pr_info("slcan: serial line CAN interface driver\n");
-	pr_info("slcan: %d dynamic interface channels.\n", maxdev);
+	pr_info("serial line CAN interface driver\n");
+	pr_info("%d dynamic interface channels.\n", maxdev);
 
 	slcan_devs = kcalloc(maxdev, sizeof(struct net_device *), GFP_KERNEL);
 	if (!slcan_devs)
@@ -1053,7 +1055,7 @@ static int __init slcan_init(void)
 	/* Fill in our line protocol discipline, and register it */
 	status = tty_register_ldisc(&slc_ldisc);
 	if (status)  {
-		pr_err("slcan: can't register line discipline\n");
+		pr_err("can't register line discipline\n");
 		kfree(slcan_devs);
 	}
 	return status;
-- 
2.32.0

