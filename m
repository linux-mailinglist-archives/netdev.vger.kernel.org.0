Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7E0648DAF
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiLJJDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLJJDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:03:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B9C11A0D;
        Sat, 10 Dec 2022 01:02:55 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so7394967pjm.2;
        Sat, 10 Dec 2022 01:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqgVYUfies8u75VfdvF2BT9HYo+3Ha/o4FJ8/jPxSkY=;
        b=q4wE7Kr2V8HQczzNJa1cXbsYY3gUGyYGsmvw5ElAt64oD33k0UIhL1RXRO0ulK0t3p
         LhC+EPNFCRtaBy5B+GsJKV1snWtepgWGVVqmiBherQTlo5WYeZa+/MoTgf35kOAMZufc
         rlneLzLK4+VhkK2qw3ua9wtLTA+K/sAXI1eMbJSE/Bh12iKngJXBSau/cdjOvnPkjK5B
         xi4WlJ/TKB9w1zD1EsMgO/ALk5wsNcNLN3+jVXlGIJ39G+qDrp9frV13RwOD1zp5ECOj
         YZu+rS6h0awCJJjJAPArHg9EvuIAf9NDWTR2tKF/RGbyQ11OP4x8xc5X+SJJSgqNKzN6
         9zEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qqgVYUfies8u75VfdvF2BT9HYo+3Ha/o4FJ8/jPxSkY=;
        b=1ujyAZlsesqE+ChLkYMhE9VqtUYO+LjhbRNdx4bo+gYx2tQ2dOk/RaoujYXfMdmoJz
         qleyI+jKLQjRYATg0CCgNS8pqqqHFBpoUHXvHgdky3tRyqC2/bftqxIuVj9pGYLsMo7R
         IcfWas7Kwbg4SXs0/dc0LTmOLegX1/xeawc4KgGRrXWzVD7n24SwqSltcGXD4lMnWa09
         444t6kbPxXDw6AjnPmjnHCTjWOvkV+cNO9PSOpCACmGrS2XSAMmlT+8OZeF2ky4eLfq5
         k4maKYo1xrmImDdKi7x3z57RU62hN4/kDjn/jl3IUcJy0PvC396oyhmy8C2X3INyqZaS
         fIdA==
X-Gm-Message-State: ANoB5pmElQfcxe6YHSyLmF86ZMY+wvVtUWvOL4AI+AkKue7IzLZlqNs+
        RIMWTkyP6Er5XOfV2IV1vGk=
X-Google-Smtp-Source: AA0mqf7eiHRvsVEhMkg5Lb5+E2zXGrfWNTNZ35Wo60ESDEpSAfI4aBdGcckttGmWINxPrsKI4c6Nbg==
X-Received: by 2002:a17:903:2012:b0:189:d3dc:a9c6 with SMTP id s18-20020a170903201200b00189d3dca9c6mr8457742pla.19.1670662974862;
        Sat, 10 Dec 2022 01:02:54 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:02:54 -0800 (PST)
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
Subject: [PATCH v2 1/9] can: ems_usb: ems_usb_disconnect(): fix NULL pointer dereference
Date:   Sat, 10 Dec 2022 18:01:49 +0900
Message-Id: <20221210090157.793547-2-mailhol.vincent@wanadoo.fr>
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

ems_usb sets the driver's priv data to NULL before waiting for the
completion of outsdanding urbs. This can results in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after ems_usb_disconnect() at [3].

[1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/ems_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 050c0b49938a..c64cb40ac8de 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1062,8 +1062,6 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 {
 	struct ems_usb *dev = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (dev) {
 		unregister_netdev(dev->netdev);
 
-- 
2.37.4

