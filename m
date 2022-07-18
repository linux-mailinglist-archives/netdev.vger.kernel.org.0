Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13325578E95
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbiGRX6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiGRX6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:58:33 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC0833A31;
        Mon, 18 Jul 2022 16:58:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s18-20020a17090aa11200b001f1e9e2438cso1312738pjp.2;
        Mon, 18 Jul 2022 16:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3odTeuZgW9//om5ESxe8jjVhzsbpQ8xVlKfb9HhKoWg=;
        b=G78PbYgF3R5GWsuh20gQlO9CS5Ez7669OGnmIRkucuL1CS7z7c9hqqOHaoLzzB5hPx
         dIytDvfIR2F+6xggpLqCGuI8vTSqZvurxkyqxA9M4s2oKh1IATYAzbhqjNPkRUVul8Mj
         9vDaeOX4NtlKe4RyB7FHQmiJeG0TwYrgnJTUtO++SeYhwi1OC7XzbR+yMw+WmrAzlYk0
         5/tknDohZNk2XjFvC4wRQ/ySUzqn8dJkNBsDfF57nadL+biF+CJnMmFPNStgzcqSBlQQ
         2TZkPSbptpAJ6a9VnaFlghiETveBiu3f4QXxubw5o34rBoqgNTPNviK1NwQzLcudyxmA
         wmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3odTeuZgW9//om5ESxe8jjVhzsbpQ8xVlKfb9HhKoWg=;
        b=WxlNbvhqTemR1/l3G3/kU9kUzWGRbzY0QIfQmbW4u9lubrWTTe+hjjsY/pfWin/U4A
         ZsZhNi8LKU5Lt7tE+Q6WIY05z3mIPswT/EaZrGMMsEpfPwgDzbx9yuO2W5JjezwCUz0c
         DApdACh5GFiCpqvlff0mqWACPTR5i5rN7pi7I0TFelmqGaaVBcfthocHFN0hsXqucl+Z
         NqBxgtdiCcFUysY0YLm5Mrr24KQ1XrsDKjigOIcdJCEQh8gcDpQDpjB2sRB+wm7PiVV8
         yOh7d/JcFCETsucfQ3dqCW/2zag+dXtJhXjnw31QOhRLX69S3c1jxN1UKIZ1YLiYxnIL
         FIfQ==
X-Gm-Message-State: AJIora+RRmLymRl+D+r7O3xAOuXGTDo3IzKNTGwvxm5g1972tVeRb7om
        ztsjaOLqUW9J5Z/cuvwrZHlfw6xzlFk=
X-Google-Smtp-Source: AGRyM1vUXBW6D46lFt62qLMlpQfbnFHLRnICpdbWZJ36IDQrz6R2xCuVqN8v/pJtB4kwzFkjuStK6Q==
X-Received: by 2002:a17:902:f1cc:b0:16c:f039:94 with SMTP id e12-20020a170902f1cc00b0016cf0390094mr8037853plc.158.1658188709876;
        Mon, 18 Jul 2022 16:58:29 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b00161ccdc172dsm10027067pll.300.2022.07.18.16.58.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 16:58:29 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, jannh@google.com, jackychou@asix.com.tw,
        jesionowskigreg@gmail.com, joalonsof@gmail.com,
        justinpopo6@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, f.fainelli@gmail.com
Cc:     justin.chen@broadcom.com
Subject: [PATCH 3/5] net: usb: ax88179_178a: restore state on resume
Date:   Mon, 18 Jul 2022 16:58:07 -0700
Message-Id: <1658188689-30846-4-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658188689-30846-1-git-send-email-justinpopo6@gmail.com>
References: <1658188689-30846-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

The hardware state was only partially restored, which meant certain
functionality was broken on resume. Do a full HW reset on resume to
fix this.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 8ca12db..60742bb 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -465,37 +465,12 @@ static int ax88179_auto_detach(struct usbnet *dev)
 static int ax88179_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	u16 tmp16;
-	u8 tmp8;
 
 	ax88179_set_pm_mode(dev, true);
 
 	usbnet_link_change(dev, 0, 0);
 
-	/* Power up ethernet PHY */
-	tmp16 = 0;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			  2, 2, &tmp16);
-	udelay(1000);
-
-	tmp16 = AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			  2, 2, &tmp16);
-	msleep(200);
-
-	/* Ethernet PHY Auto Detach*/
-	ax88179_auto_detach(dev);
-
-	/* Enable clock */
-	ax88179_read_cmd(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
-	tmp8 |= AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
-	msleep(100);
-
-	/* Configure RX control register => start operation */
-	tmp16 = AX_RX_CTL_DROPCRCERR | AX_RX_CTL_IPE | AX_RX_CTL_START |
-		AX_RX_CTL_AP | AX_RX_CTL_AMALL | AX_RX_CTL_AB;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+	ax88179_reset(dev);
 
 	ax88179_set_pm_mode(dev, false);
 
-- 
2.7.4

