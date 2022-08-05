Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3734358AF94
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiHESIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 14:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiHESIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 14:08:48 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE1E785AD;
        Fri,  5 Aug 2022 11:08:44 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id z5so1344552uav.0;
        Fri, 05 Aug 2022 11:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=pWqGh5Qz6RZaLHUV/NaP4Qo03yw0upYvaJlwshpKeNs=;
        b=CqJO04w8Qy4jw4QCFeGnhIiTna6mlU4UzFSgq3o1L1zTlFXjfdGowsNlxcm7+H8xNz
         rfnMLq2b0I5DA4vJANEtyyqiv0esUCwAUOvGAG1jCwjUvvzm/oz7Jk0fCJ3+cZE61ssC
         4BbgCQJMbwOLitUhmIXsM923XVuLfLYRMfGQ6hVHk05EYVYCqgfNIe2OrXojhtnRcmZb
         c+7EIufazQD+rUhxC7bNQYAjGjgVJXHRBg1ewXcfvwFMftq7W4U0YMU5tZ/ujyHefNm7
         1SU9w1/uEmO2Y05IPLLlUxoQFk8tCTQWXOnYSSTg1zrY/cnsXx1OqVdiA2eRArmAkRgg
         mfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=pWqGh5Qz6RZaLHUV/NaP4Qo03yw0upYvaJlwshpKeNs=;
        b=2v4IQPqRosr1spL5fLxTqOsAvgSSizb5/r0fP8O+f92d0KLmJJx/UBadwMTXz9ltPh
         OTtWlPIzFVpeCHNxKY0t1o/jn6+leatRGuLJRKgn5cz0SRnhb74/xHln3vwoDWZ/Z5IS
         oAvkfQ/b7wKiSjf+5KKt6VXqixYuEMuex8UhHKOX4LODE6uWB6+0fvv94P50nBhYDxyf
         PVE86kr2Cr7w3jRj/NtneY5jt/5p+ftH/fjCfu0MJ40yfY2riBc8YG6ZYzek4MokcLL2
         eUv1kCKUpSUy98lNXvJOHtz8wNUN/rjpDiiJuZNm+awPrHRvIMYQq+BwINmIZltADRkU
         9C5Q==
X-Gm-Message-State: ACgBeo1iaY2mf6+dNHLiSaqkh3Vjm5oItklj6xhEH+9oWFirez7IyXLk
        +e8xC6Ry0VBMEH/cold+ZeVSwoXN3XFAjA==
X-Google-Smtp-Source: AA6agR6+7mHmMFx+d+qgH+o5/358huWMHujekHD4xl7y6nLuTS/8Unj3c+mZKJcgA1NIkWrpiFBp4w==
X-Received: by 2002:ab0:7c50:0:b0:384:e315:a358 with SMTP id d16-20020ab07c50000000b00384e315a358mr3704101uaw.118.1659722923134;
        Fri, 05 Aug 2022 11:08:43 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8fe6:28d:a348:5d75:1a38? ([2804:14c:71:8fe6:28d:a348:5d75:1a38])
        by smtp.gmail.com with ESMTPSA id w8-20020ab07288000000b00384293c4199sm3823297uao.23.2022.08.05.11.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 11:08:42 -0700 (PDT)
Message-ID: <dc920ea721a8846c49e7a8752e8d3209edd94f4e.camel@gmail.com>
Subject: [PATCH net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Date:   Fri, 05 Aug 2022 15:08:40 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware versi=
ons
that have no issues.

This patch is reverting 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SE=
ND_ZLP")
because using FLAG_SEND_ZLP in this context is not safe.
See:
https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@L=
inuxdev4-laptop/#118378

reported by:
Ronald Wahl <ronald.wahl@raritan.com>
https://bugzilla.kernel.org/show_bug.cgi?id=3D216327
https://bugs.archlinux.org/task/75491

--

 drivers/net/usb/ax88179_178a.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.=
c
index 0ad468a00064..aff39bf3161d 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1680,7 +1680,7 @@ static const struct driver_info ax88179_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1693,7 +1693,7 @@ static const struct driver_info ax88178a_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1706,7 +1706,7 @@ static const struct driver_info cypress_GX3_info =3D =
{
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1719,7 +1719,7 @@ static const struct driver_info dlink_dub1312_info =
=3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1732,7 +1732,7 @@ static const struct driver_info sitecom_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1745,7 +1745,7 @@ static const struct driver_info samsung_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1758,7 +1758,7 @@ static const struct driver_info lenovo_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset =3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1771,7 +1771,7 @@ static const struct driver_info belkin_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop	=3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1784,7 +1784,7 @@ static const struct driver_info toshiba_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop =3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1797,7 +1797,7 @@ static const struct driver_info mct_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset	=3D ax88179_reset,
 	.stop	=3D ax88179_stop,
-	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	=3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1810,7 +1810,7 @@ static const struct driver_info at_umc2000_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset  =3D ax88179_reset,
 	.stop   =3D ax88179_stop,
-	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1823,7 +1823,7 @@ static const struct driver_info at_umc200_info =3D {
 	.link_reset =3D ax88179_link_reset,
 	.reset  =3D ax88179_reset,
 	.stop   =3D ax88179_stop,
-	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };
@@ -1836,7 +1836,7 @@ static const struct driver_info at_umc2000sp_info =3D=
 {
 	.link_reset =3D ax88179_link_reset,
 	.reset  =3D ax88179_reset,
 	.stop   =3D ax88179_stop,
-	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  =3D FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup =3D ax88179_rx_fixup,
 	.tx_fixup =3D ax88179_tx_fixup,
 };

