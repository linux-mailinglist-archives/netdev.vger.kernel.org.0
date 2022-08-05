Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCF258B0B1
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 22:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbiHEUC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 16:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241308AbiHEUC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 16:02:27 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F087656A;
        Fri,  5 Aug 2022 13:02:26 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id z5so1450085uav.0;
        Fri, 05 Aug 2022 13:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=4XSNHwAH6vmEUC0vC2u6B3iLf/yGWtVZcvpaaKg7oxQ=;
        b=JR3pf5O1gpIfDMhP7pwpgHb7t8w5BLBvXTTvPODw50HEhfEcdp2gwEDDMQ0kdLR1iH
         feVztZCAi/yR63o6PajgzIZRoV+UQ6hmGwQBph5x3/XVCRyxJIlgKYb1mQvuzPRBkK7q
         1PWzXQwKRkommDpVDh7i2WxW1faUXvVPBSnDdcJaGT20a84/qgsN8APw9QSDO2ThoNBj
         B0uNAET7kEmcSEExqh4IP2ZJZoqStDNvq9+xrS3KfeCZCASM1Fb4zJJxM/ZVTeE2Drgm
         pLMDbnhk3PEgCN29u96sMk6uMsEnz4Z/r3t/pG5niVq0/C1bjHgYPeXN+YCcfcUAT3c2
         4NQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=4XSNHwAH6vmEUC0vC2u6B3iLf/yGWtVZcvpaaKg7oxQ=;
        b=VWF2NNtlRnJi8Ktvx3efHZkn2OqmfxCYexaubdBSmf3aUsboJjPmef3FIJG9F+RlCr
         pYtA4wQFPSov+Nd4m+3S+jf49Xr3pEb5W1tLM5/QFXQtrC9FUizbscVfnHLY7QJNrt0a
         8FKPA2pOE2omPkQFtOxOJVZMAYB1dUQUvT8dpjmwOg5ZgC4opasxmtu11NjVexKbYfTj
         01MTg0GfPg/seQ++CeLkNfaO7Xakj8enmKsUZKY9nbyPJxG9Lqr3SHRrLizfbel3uTej
         K8GDTs5ULNdIqhcRf+VDZFkEdPapxjtMwZOadEMAiwlamlAyGmunseBTgrc/L2StevGK
         so3A==
X-Gm-Message-State: ACgBeo2Tseu5Ol+sYpKbXZX3nt9EVk72+lTlIubOusZYB4mnbG4om9B8
        8GLRSxxFHYYHsVtbHlMRM50=
X-Google-Smtp-Source: AA6agR6XnPIkGbt9tMXSSC6imDm0JsjQzBui5xBKFSXPz/zwF8+YsVFpIsle3lWsCCdYG4VlRWXCjw==
X-Received: by 2002:ab0:23ca:0:b0:384:e51b:372f with SMTP id c10-20020ab023ca000000b00384e51b372fmr4093803uan.64.1659729745185;
        Fri, 05 Aug 2022 13:02:25 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8fe6:28d:a348:5d75:1a38? ([2804:14c:71:8fe6:28d:a348:5d75:1a38])
        by smtp.gmail.com with ESMTPSA id s17-20020a67f4d1000000b00373d697e3e2sm3830357vsn.19.2022.08.05.13.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 13:02:24 -0700 (PDT)
Message-ID: <b0f0a44a72bdcbca2573aaa5cdb3ed2de233fbdd.camel@gmail.com>
Subject: [PATCH net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Date:   Fri, 05 Aug 2022 17:02:22 -0300
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

