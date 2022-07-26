Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881BE581B78
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbiGZVDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiGZVD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:03:27 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC163204B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:26 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id fy29so28178823ejc.12
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W6W3RCGbQm1ftNxYyveQiUbovGJZ//OaxbWEapVu2yM=;
        b=VlEPTxUOtupcAqH7Q4BD8fcqrFDVV/Op6UWKf2AerNjOnj1M9GeBbUX05bPqPMGwgh
         4Pasf+xKWSfvxxbCCdonxcXzlMEv2B6VPJhQzQMJkqLHxeb/35XOoyive9dcYQbiIaXE
         qoMYB3pGw8UaVztIg2OSZ7ofDzMG7VDJjkEIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W6W3RCGbQm1ftNxYyveQiUbovGJZ//OaxbWEapVu2yM=;
        b=T2HvN8TJDqG9a4Z874NJqpoD0Jzugbe2MrTWyhzRqFpPxxG7Iu1jnbWTixe3g69mpE
         eR3vDkb1Nc2OLNxQL1UM/fyy8HpN9xpdYHIKhfu10gUGwDt8fSZ1S2k4yhxmdXg1Qonf
         0O4LIT3ootJM4rRUGKbm/fa2KnykemyV1IrdAWHbm4+vIyN2JYXx7t26r/va3kOEkC0i
         KtVToqq58oYoKOU7GorQj7m8tRvRhEQFZA6rMhiJd2C74eTBcCILzzfJeySziqnJSFUU
         zAMggo3w0Nvxt3kCi9HukFZ5jqz5mF0QiMZ2KlluuKMcpK4UlHUcGgxzTCYNFex+xZsr
         fz+w==
X-Gm-Message-State: AJIora8RmUUsYB1+GEMa6T1rMOtvwPEk2dq9L7m7QrbVe5NFXaOqKcxG
        BnPwLhluewLvI3r26x/8KqxAzA==
X-Google-Smtp-Source: AGRyM1vdjURo5XZsAvWoObXRQZFMuwHajMMkylLtEPuoRNgyUYUVe6IoiY1vN0nttuSapaQH3q0gEA==
X-Received: by 2002:a17:907:2722:b0:72b:735a:d3b4 with SMTP id d2-20020a170907272200b0072b735ad3b4mr15381214ejl.363.1658869404930;
        Tue, 26 Jul 2022 14:03:24 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id y19-20020aa7d513000000b0043a7293a03dsm9092849edq.7.2022.07.26.14.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 14:03:24 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [RFC PATCH v3 1/9] can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded names
Date:   Tue, 26 Jul 2022 23:02:09 +0200
Message-Id: <20220726210217.3368497-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
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

