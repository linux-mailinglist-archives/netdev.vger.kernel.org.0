Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9958B0D4
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 22:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240985AbiHEU1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 16:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiHEU1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 16:27:39 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494801EAD7;
        Fri,  5 Aug 2022 13:27:38 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id q190so3540503vsb.7;
        Fri, 05 Aug 2022 13:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=qZTxGWc+7EbTsBQ2Gh9v3Z8wvoxer/nBnDSZxaGynCc=;
        b=QoqgBAK9GFHTdVGXzUZkqnz4ERn5ruregPoSLrLIQ/7AIY1yDjYxndJEbrN5a/sd2n
         s4xF9Wu0628SN4whZC/a/34V7aqAi5Ft5EfWVfpx8zd61BU/O8tCADNDhoDRnz6NRCET
         FOoNnCo52b+TPppO6JqW9FpcxAbm0dbtekQra/ECzWWDmJoiWLpU/KBa5WSCzTMSFb72
         8mpkQtX4gyGlP015/BbtUvXwW295cIj+m/Nk9KzxohkgSCjouOnCHkUy08eyUN093uhg
         vDCuGb7DIDt91VeZ6EjgdHdFQ4olgwPntfBVGPe6+YRnLQjkZtRvkqUV6/+qflTY+zFS
         wkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=qZTxGWc+7EbTsBQ2Gh9v3Z8wvoxer/nBnDSZxaGynCc=;
        b=T2l97NApxfAe6vnguffT/AKwlUael+mELSimJzwUBOJvnuLXVb06onuCJgbwACl6+2
         awTfCCCkrowEo3bV62gYZ8DD4lrV7pXDFlnM6l1HhV9rtEMSMw9kS/MLuTfvDMBP0TUI
         i3W/q6Br7zC5PUL1BcMWHz8zJEpE7rra7n2VtcrJGrzEYlcBQGCkMBc57xJfNi1pB2dK
         da8i8S5FoD0etEUUdmN5EhoEdSYHfx0Mtp3eXQXBzkbw7f/HlC/iSrABbH+I6F23eNxX
         oOWGuvfTSLW92KVQryWrP9kmKa3WNdpmUchmITWdDHf9+MYH0IVCLS2jovA+GzMgw6/S
         mhiA==
X-Gm-Message-State: ACgBeo1xTiG5vKyRRGGhc1SnMsOlWM8VpKTL7UFFF2YFAJSuQHhLo/Po
        6QMjh6n+fAYtd2NLStUCQcU=
X-Google-Smtp-Source: AA6agR4wjNpyLDckUvS1JocOMTxtunKgv+qHF8U6b+2ZAf7/U+gSsQCUpJqaPtUeEtMnFD9COs4fdg==
X-Received: by 2002:a67:ae09:0:b0:357:4b92:a8be with SMTP id x9-20020a67ae09000000b003574b92a8bemr3831087vse.75.1659731257320;
        Fri, 05 Aug 2022 13:27:37 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8fe6:28d:a348:5d75:1a38? ([2804:14c:71:8fe6:28d:a348:5d75:1a38])
        by smtp.gmail.com with ESMTPSA id v11-20020ab0658b000000b0038764c1121esm4186213uam.20.2022.08.05.13.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 13:27:36 -0700 (PDT)
Message-ID: <9a6829ee42e4e88639d35428c378f9da7802245b.camel@gmail.com>
Subject: [PATCH v2 net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Date:   Fri, 05 Aug 2022 17:27:33 -0300
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

To: David S. Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linux=
foundation.org>
Cc: netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>, Ronal=
d Wahl <ronald.wahl@raritan.com>

    [PATCH net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
    The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
    versions that have no issues.
   =20
    The FLAG_SEND_ZLP is not safe to use in this context.
    See:
    https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.cam=
el@Linuxdev4-laptop/#118378
   =20
    Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216327
    Link: https://bugs.archlinux.org/task/75491
   =20
    Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
    Signed-off-by: Jose Alonso <joalonsof@gmail.com>
   =20
    --

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

