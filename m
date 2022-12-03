Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB35E641704
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiLCNeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLCNdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:33:45 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6977D32B87;
        Sat,  3 Dec 2022 05:33:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so10810121pjh.2;
        Sat, 03 Dec 2022 05:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fxHyzRD+OA0ZiW4eG2/9faFb16Ofuaf9BEH5sngLak=;
        b=HOT0P6wpuwAHMJkR5T7OtYtanEI2rfVIg+ru6zxJLZukWem+R65baDM40tZWQaoQXF
         XCwmBPo56lSEFwZ9mkHiPLG8WVexDl5yb2sg1Gi4x0SW+unyu8AibTSIqinlgKaIo78i
         2rFCUDla5mRhthb8F3eo+eV+51m7JP2QDu0joDCvRLwrrO0Z/H97X0DfAaeRKk9YF3e4
         Uao4WPnUnO4n8Adbg1xfjvE+Z+JOt9YV8rP2QPQNhrtRRsYnQsa5mWOS5rgHKWj4db4u
         1CKg9nWZPoJZOUSK9hLPaS7k//Tn+DN9BMLVDOVpKAbjXja/lE/5AjeYnHmcaIrVz8NU
         k6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3fxHyzRD+OA0ZiW4eG2/9faFb16Ofuaf9BEH5sngLak=;
        b=UEfTn++PwkDUxMN4cDfU15pIH/vR+o7Joz7yhkqYeak+GUcYf+4BddOEiGhDW8v7az
         68Ju8h77rrvXHyxEa0iI6kPpNbxXlu+RZq6bRNMMQJfTHAdQ0g7YJOAt6df9bn8LExmT
         mE9nXFxD2WolwLsswQaf1Nlis68OMgmk/PmplzELyOZTULjsPXPIYoIj8BXn6JpmECFC
         jamFVFqiy0tG0BMcvoZoExILFFd5PNltRUoMp71kEZ+b1v9L4w+B5OB6UfM0LV0vj5wp
         PGhpoBW/dU7pbUUeYRfD3D5y60hMFeyZDnmQ1THIfwjoC6vNfex1xb9i/EL4j2G90FFl
         d/mw==
X-Gm-Message-State: ANoB5pnCjz8bSQGA3pPwJeoSovwj0EfhOtOwblUJY+57Zf8w/nZLv6h/
        diWvJZ2P6+lRpAbxywGk+98NYfjO+tKNjQ==
X-Google-Smtp-Source: AA0mqf7gBuprbi8zQWvCsrE9FrQAOJzeJcPQS8Nl3G2KyFkIPUBY09D/wPreD9zLisOrLdvRv5LgZg==
X-Received: by 2002:a17:903:2651:b0:189:acbc:f032 with SMTP id je17-20020a170903265100b00189acbcf032mr16684607plb.9.1670074386824;
        Sat, 03 Dec 2022 05:33:06 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:33:06 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 7/8] can: usb_8dev: usb_8dev_disconnect(): fix NULL pointer dereference
Date:   Sat,  3 Dec 2022 22:31:58 +0900
Message-Id: <20221203133159.94414-8-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

usb_8dev sets the usb_interface to NULL before waiting for the
completion of outstanding urbs. This can result in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after usb_8dev_disconnect() at [3].

[1] commit 27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/usb_8dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 8a5596ce4e46..ae618809fc05 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -990,8 +990,6 @@ static void usb_8dev_disconnect(struct usb_interface *intf)
 {
 	struct usb_8dev_priv *priv = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (priv) {
 		netdev_info(priv->netdev, "device disconnected\n");
 
-- 
2.37.4

