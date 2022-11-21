Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8698632398
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiKUNbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiKUNaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:30:52 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Nov 2022 05:30:49 PST
Received: from zproxy110.enst.fr (zproxy110.enst.fr [IPv6:2001:660:330f:2::c0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC675B960E;
        Mon, 21 Nov 2022 05:30:49 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by zproxy110.enst.fr (Postfix) with ESMTP id 2598E8178C;
        Mon, 21 Nov 2022 14:14:53 +0100 (CET)
Received: from zproxy110.enst.fr ([IPv6:::1])
        by localhost (zproxy110.enst.fr [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id YxON5zsV5vs7; Mon, 21 Nov 2022 14:14:52 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by zproxy110.enst.fr (Postfix) with ESMTP id C60A381708;
        Mon, 21 Nov 2022 14:14:52 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 zproxy110.enst.fr C60A381708
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=imt-atlantique.fr;
        s=50EA75E8-DE22-11E6-A6DE-0662BA474D24; t=1669036492;
        bh=aJJOodTsPa2Ecy/ELaEaLyge5Npy7UNg4STVNNQkDe4=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=b22Gvep5+R/VsmgZ4PLxjvNigTW8ZUYQg20Inuw8Sa30A3kd/qBcTZ/Bl9JyPSFFN
         jtgM8gzI65M7zZTAsUeFBiOk/btAG1a0X5uwRySrnTFg4XbZU+sA5q28nV14OqCSzv
         ncd3+Cmn33jZirEZWvFiL3wUtDytykz+7PBeTG4M=
X-Virus-Scanned: amavisd-new at zproxy110.enst.fr
Received: from zproxy110.enst.fr ([IPv6:::1])
        by localhost (zproxy110.enst.fr [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id cxeTwijy0Ayi; Mon, 21 Nov 2022 14:14:52 +0100 (CET)
Received: from localhost (unknown [10.29.225.100])
        by zproxy110.enst.fr (Postfix) with ESMTPSA id 9ADA9813EE;
        Mon, 21 Nov 2022 14:14:52 +0100 (CET)
From:   =?UTF-8?q?Santiago=20Ruano=20Rinc=C3=B3n?= 
        <santiago.ruano-rincon@imt-atlantique.fr>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Santiago=20Ruano=20Rinc=C3=B3n?= 
        <santiago.ruano-rincon@imt-atlantique.fr>
Subject: [PATCH] net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP
Date:   Mon, 21 Nov 2022 14:13:37 +0100
Message-Id: <20221121131336.21494-1-santiago.ruano-rincon@imt-atlantique.fr>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZLP for DisplayLink ethernet devices was enabled in 6.0:
266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices")=
.
The related driver_info should be the "same as cdc_ncm_info, but with
FLAG_SEND_ZLP". However, set_rx_mode that enables handling multicast
traffic was missing in the new cdc_ncm_zlp_info.

usbnet_cdc_update_filter rx mode was introduced in linux 5.9 with:
e10dcb1b6ba7 ("net: cdc_ncm: hook into set_rx_mode to admit multicast
traffic")

Without this hook, multicast, and then IPv6 SLAAC, is broken.

Fixes: 266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet
devices")

Signed-off-by: Santiago Ruano Rinc=C3=B3n <santiago.ruano-rincon@imt-atla=
ntique.fr>
---
 drivers/net/usb/cdc_ncm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8d5cbda33f66..0897fdb6254b 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1915,6 +1915,7 @@ static const struct driver_info cdc_ncm_zlp_info =3D=
 {
 	.status =3D cdc_ncm_status,
 	.rx_fixup =3D cdc_ncm_rx_fixup,
 	.tx_fixup =3D cdc_ncm_tx_fixup,
+	.set_rx_mode =3D usbnet_cdc_update_filter,
 };
=20
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
--=20
2.38.1

