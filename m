Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9820C6919D4
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBJINx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjBJINw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:13:52 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3559CAD34;
        Fri, 10 Feb 2023 00:13:48 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qb15so11615536ejc.1;
        Fri, 10 Feb 2023 00:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RfxTuaXPFuuhKw07EKGJnJD31rzl8qOc8YDdNEsacKs=;
        b=RdcGv9oMi1uOe9HVvrUmX7JiCVTJVCJkgRvPkmB3cRA9PHZP6ohj5J7JRL8Ut1ZfNB
         zuTs9nl8pXxWPMkCSlDb1uEwDJwTjCIQexPTaZZdwpbxT4aZ3hq+S1h0scWw6EwBStES
         9C04sC0qokj1S9Iir7ew+S4MH+JfS8Xgia75GUncszm+DqVLi7BZ2afS/REVbewKysov
         h91V0BG2RoE+5cfr0Pq7vFN7GXaQEI1Rwsh/fRN9q6KNZ4ZlvILf7Po+vLv4S80pvgsW
         6O8KfT8jwPg2ZPb3sEinQaPbsqxuHvp6eDQWLjHPQ6qzFQErw87TMv9770H6Lqqf/bO9
         zCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RfxTuaXPFuuhKw07EKGJnJD31rzl8qOc8YDdNEsacKs=;
        b=iRI3O64p+KjECDfgzRzlVPcV6upujH0bmDXl/NWrNiIw9DO629Eb8SJAMwsrxV6FuO
         vwMDsHf8iTwpIWrsHWItOXG3txoceCvzneBd3yUAQjIKRzJVIoO4wsje4F1ll64bqSAk
         FrbctrGuNyu0qJf08T65dwHfdAlBht7mNpMnZ2zM7htDb9CY5M7Lo8SXpItz6VQg9msl
         GHomoYkF5MA3c27yo4bIkSemwPWD/m4CT3Q/AkAmDphOSP9184PrlbgeIosiq48EcKt1
         344uSr5O11+mo5bQrm3TCUJfCgLM7dfdM92w9wpLd61Okg90RzIHjuy9jIB0mth4rI2g
         E+DQ==
X-Gm-Message-State: AO0yUKUmOOOj7lHan91+hfpQYgw9MUl1FnHGUvPTKTnv/6oUgf71fOrP
        a2yUE70lFL5XDrX5mMPzMQ4av2NgvXE=
X-Google-Smtp-Source: AK7set8mqXrZb6jqki+1zDCnnlahbJj2YaPV0blCenw8kJwEKAEiaUrR1gBqwF0fVukNmx9UbgrkZw==
X-Received: by 2002:a17:906:d0c9:b0:8aa:dffa:badd with SMTP id bq9-20020a170906d0c900b008aadffabaddmr8951399ejb.1.1676016826535;
        Fri, 10 Feb 2023 00:13:46 -0800 (PST)
Received: from sakura.myxoz.lan (81-230-97-204-no2390.tbcn.telia.com. [81.230.97.204])
        by smtp.gmail.com with ESMTPSA id a18-20020a170906469200b007c0f217aadbsm2036701ejr.24.2023.02.10.00.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:13:46 -0800 (PST)
Message-ID: <2f74aab82a40e4c11c91ccba40f5b620f6cb209c.camel@gmail.com>
Subject: [PATCH] net/usb: kalmia: Don't pass act_len in usb_bulk_msg error
 path
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Paolo Abeni <pabeni@redhat.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Date:   Fri, 10 Feb 2023 09:13:44 +0100
In-Reply-To: <f0b62f38c042d2dcb8b8e83c827d76db2ac5d7ad.camel@gmail.com>
References: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
         <f0b62f38c042d2dcb8b8e83c827d76db2ac5d7ad.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported that act_len in kalmia_send_init_packet() is
uninitialized when passing it to the first usb_bulk_msg error path. Jiri
Pirko noted that it's pointless to pass it in the error path, and that
the value that would be printed in the second error path would be the
value of act_len from the first call to usb_bulk_msg.[1]

With this in mind, let's just not pass act_len to the usb_bulk_msg error
paths.

1: https://lore.kernel.org/lkml/Y9pY61y1nwTuzMOa@nanopsycho/

Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B37=
30")
Reported-and-tested-by: syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.c=
om
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
 drivers/net/usb/kalmia.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index 9f2b70ef39aa..613fc6910f14 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -65,8 +65,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg,=
 u8 init_msg_len,
 		init_msg, init_msg_len, &act_len, KALMIA_USB_TIMEOUT);
 	if (status !=3D 0) {
 		netdev_err(dev->net,
-			"Error sending init packet. Status %i, length %i\n",
-			status, act_len);
+			"Error sending init packet. Status %i\n",
+			status);
 		return status;
 	}
 	else if (act_len !=3D init_msg_len) {
@@ -83,8 +83,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg,=
 u8 init_msg_len,
=20
 	if (status !=3D 0)
 		netdev_err(dev->net,
-			"Error receiving init result. Status %i, length %i\n",
-			status, act_len);
+			"Error receiving init result. Status %i\n",
+			status);
 	else if (act_len !=3D expected_len)
 		netdev_err(dev->net, "Unexpected init result length: %i\n",
 			act_len);
--=20
2.39.1


