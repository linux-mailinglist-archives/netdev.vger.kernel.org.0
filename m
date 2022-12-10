Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D41648DB3
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLJJDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiLJJDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:03:13 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEA01572D;
        Sat, 10 Dec 2022 01:03:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so7395147pjm.2;
        Sat, 10 Dec 2022 01:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DVtAm9qztHyZBrD4ZVLrTHR+RA9lfulcIIjDcTmdPQ=;
        b=OrMCEYGTR/LDfFd3lfYST1dGQLTy+XYi+8lUHZpCR3sTtLTf9kTtLnjsWuiCo/yJFV
         upDwACLmxAWYT2a2lDQHD9aJCiX07KYRm1ryqAEJcDgYAaLlO1b0Ut7lEJXdHK4Wc0Q+
         T9UZxu5xe7+iN8wgO0VYDOZdP1RkyW4xPt+lACxYtk25rywKEo3T449w25za9Dw1Ym0U
         4199KBxpnuhbsBLtatH8bMSnJwxlnShphA6Z1EM5Yaw/3Pdw/OeyjtDDfmrXiHHRlom7
         z8PZvK98RQSU5VFhJoQVrZp6HVuqnA2VlPdLiqZmAHZVdQ2RMdKbFdv/cXl3HKiMQmnz
         ZaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4DVtAm9qztHyZBrD4ZVLrTHR+RA9lfulcIIjDcTmdPQ=;
        b=BxDSPqddc7mdnKRysFiF9b3UN5z28wXOwASur1R8f+u7EGjIb2YJC+uZxC4aajP2SU
         KHmZVV5YzGbmmamyfhP/VrUFEbNPI0BdIlzq7ba3JOC76Q/1MpRqMyb/qU7wjKHxM9KM
         4mmEUfT1A8I2n0s1lXPFuJt9TTcGencX7hIPk5pzi36Dl5Vxv8s5imaz4dtWZkhX09JG
         jwURAA9jsZ74dWDu2wRCRo7zAx6EhwBJCP77ProKQigZAOOPi0T+fgFrqCRUNBnZ9k6Y
         LtF50NEsD2ug3AHD4u8aqlzVjgCdIo4daZ378ReWY6H+L+Ed+HskLQJ1SvmTmONyqU8M
         +GPQ==
X-Gm-Message-State: ANoB5pkTU0dJLoqXda/nKA/BzO1p+Y9BrYawh7GsE3nVHy16CSgj4HQK
        Y1LMtxUY6/8qHr+ax5ce38I=
X-Google-Smtp-Source: AA0mqf4b370FMGctMLWBPB42Vhi2lbTxMKKU0lVOWD3OfcHBPeOclpu1y2MyDCcrZyPg9S/evE3B7g==
X-Received: by 2002:a05:6a20:28a0:b0:ad:58d4:2a7a with SMTP id q32-20020a056a2028a000b000ad58d42a7amr484019pzf.22.1670662982080;
        Sat, 10 Dec 2022 01:03:02 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:01 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
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
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 2/9] can: esd_usb: esd_usb_disconnect(): fix NULL pointer dereference
Date:   Sat, 10 Dec 2022 18:01:50 +0900
Message-Id: <20221210090157.793547-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

esd_usb sets the driver's priv data to NULL before waiting for the
completion of outsdanding urbs. This can results in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after esd_usb_disconnect() at [3].

[1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
@stable team: the file was renamed from esd_usb2.c to esd_usb.c in [4].

[4] 5e910bdedc84 ("can/esd_usb2: Rename esd_usb2.c to esd_usb.c")
---
 drivers/net/can/usb/esd_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 81b88e9e5bdc..f3006c6dc5d6 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -1127,8 +1127,6 @@ static void esd_usb_disconnect(struct usb_interface *intf)
 	device_remove_file(&intf->dev, &dev_attr_hardware);
 	device_remove_file(&intf->dev, &dev_attr_nets);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (dev) {
 		for (i = 0; i < dev->net_count; i++) {
 			if (dev->nets[i]) {
-- 
2.37.4

