Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6E9639723
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKZQWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiKZQWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:22:46 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A0813D25;
        Sat, 26 Nov 2022 08:22:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so5472142pjo.3;
        Sat, 26 Nov 2022 08:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqxbdWmkDaYh64fn5vJKWcy9PbC9sFK7pSd5yFtHB2A=;
        b=Vbr686uQefXtARICYQMOWq68c10KROWIUykAqWE3v/K6+O3EKosQse7pUL4xetrAXJ
         miZraXXF9B+zQkT/2QY5dbRShtbaJ2KD0F9FYYlGjzvI95DULAKbw9edrf36TrQ80dT7
         xBgJ/K2iYOBtPHqOtckAUfKSoU6iRClkcJBoFrkKvCCKzB4KFlUPwvHADR8yQYkhVWl9
         7EmGQzaeN5QXnbxbhJORYWFcq8hk4beQ5fiCQfXFsFlAWMFagyWpT1i34IWM1kK6T76c
         B9aGkenxsIgmOtY6895/RgKu4+5IDXFV8ZVYYtQFeEy3emyqbFNTCxvl48oPiWj+Jy5m
         v+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FqxbdWmkDaYh64fn5vJKWcy9PbC9sFK7pSd5yFtHB2A=;
        b=IXxA1vyGr0TnXRnz0P56ISx1Q0mG/q+xpinDWmEtdBf94+sTMQcX8IUW4/pwVHRXIj
         +2iLr9Cqni/W5qNA0jdGnB1gj/+dgx5kjtp7tuGD3l2Oj1+ewuYmCIE2YIsTgZi5VxCp
         iQ632qOG6kK8opXLFuBkQTzqn9KjC+DU2v5X6VDufciJAhfWaCrW7X36LSRt60DUDaV1
         I0TO876hmoyjO2Uky8BJqL5bp+ftHibkrW01PJxILWmM6xyUkxld7wbgMlMuefnoLqUP
         WrRLl1QYiu+SZLtV5fHxSaUrU7HBn9fzHuIcjOxad63Hz/AMckD1WkQE9le9SbNejvp3
         tNkw==
X-Gm-Message-State: ANoB5pkdo/pJ/1pVrDePbOVWfw2PVuATNloa2p6RnDhel6JIS4Y2kITX
        PvkWxo/GGiFydvp4jvWVXHXNaHypZx+6Kw==
X-Google-Smtp-Source: AA0mqf4mX1qFUWuATPxlMlDaQjawAqjHlT/TdpUe9PSGgYe5cqivO4RhUHoaHg8iREh2zPwX7nqjdQ==
X-Received: by 2002:a17:902:9881:b0:188:62b8:2278 with SMTP id s1-20020a170902988100b0018862b82278mr29895394plp.96.1669479764254;
        Sat, 26 Nov 2022 08:22:44 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y14-20020a63e24e000000b00460ea630c1bsm4169601pgj.46.2022.11.26.08.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 08:22:44 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 4/6] can: etas_es58x: remove es58x_get_product_info()
Date:   Sun, 27 Nov 2022 01:22:09 +0900
Message-Id: <20221126162211.93322-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the product information is available under devlink, no more
need to print them in the kernel log. Remove es58x_get_product_info().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 52 ++-------------------
 1 file changed, 3 insertions(+), 49 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index d29c1bf90d73..e81ef23d8698 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2120,48 +2120,6 @@ static void es58x_free_netdevs(struct es58x_device *es58x_dev)
 	}
 }
 
-/**
- * es58x_get_product_info() - Get the product information and print them.
- * @es58x_dev: ES58X device.
- *
- * Do a synchronous call to get the product information.
- *
- * Return: zero on success, errno when any error occurs.
- */
-static int es58x_get_product_info(struct es58x_device *es58x_dev)
-{
-	struct usb_device *udev = es58x_dev->udev;
-	const int es58x_prod_info_idx = 6;
-	/* Empirical tests show a prod_info length of maximum 83,
-	 * below should be more than enough.
-	 */
-	const size_t prod_info_len = 127;
-	char *prod_info;
-	int ret;
-
-	prod_info = kmalloc(prod_info_len, GFP_KERNEL);
-	if (!prod_info)
-		return -ENOMEM;
-
-	ret = usb_string(udev, es58x_prod_info_idx, prod_info, prod_info_len);
-	if (ret < 0) {
-		dev_err(es58x_dev->dev,
-			"%s: Could not read the product info: %pe\n",
-			__func__, ERR_PTR(ret));
-		goto out_free;
-	}
-	if (ret >= prod_info_len - 1) {
-		dev_warn(es58x_dev->dev,
-			 "%s: Buffer is too small, result might be truncated\n",
-			 __func__);
-	}
-	dev_info(es58x_dev->dev, "Product info: %s\n", prod_info);
-
- out_free:
-	kfree(prod_info);
-	return ret < 0 ? ret : 0;
-}
-
 /**
  * es58x_init_es58x_dev() - Initialize the ES58X device.
  * @intf: USB interface.
@@ -2240,28 +2198,24 @@ static int es58x_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
 	struct es58x_device *es58x_dev;
-	int ch_idx, ret;
+	int ch_idx;
 
 	es58x_dev = es58x_init_es58x_dev(intf, id->driver_info);
 	if (IS_ERR(es58x_dev))
 		return PTR_ERR(es58x_dev);
 
-	ret = es58x_get_product_info(es58x_dev);
-	if (ret)
-		return ret;
-
 	es58x_parse_product_info(es58x_dev);
 	devlink_register(priv_to_devlink(es58x_dev));
 
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
-		ret = es58x_init_netdev(es58x_dev, ch_idx);
+		int ret = es58x_init_netdev(es58x_dev, ch_idx);
 		if (ret) {
 			es58x_free_netdevs(es58x_dev);
 			return ret;
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.37.4

