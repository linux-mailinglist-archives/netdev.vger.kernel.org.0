Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE7B632ECD
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiKUV1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiKUV1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:27:08 -0500
Received: from zproxy110.enst.fr (zproxy110.enst.fr [137.194.2.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B8FDB858;
        Mon, 21 Nov 2022 13:27:06 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by zproxy110.enst.fr (Postfix) with ESMTP id BF83581A21;
        Mon, 21 Nov 2022 22:27:05 +0100 (CET)
Received: from zproxy110.enst.fr ([IPv6:::1])
        by localhost (zproxy110.enst.fr [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id DDCCyg_cKh4n; Mon, 21 Nov 2022 22:27:05 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by zproxy110.enst.fr (Postfix) with ESMTP id 7385C81972;
        Mon, 21 Nov 2022 22:27:05 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 zproxy110.enst.fr 7385C81972
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=imt-atlantique.fr;
        s=50EA75E8-DE22-11E6-A6DE-0662BA474D24; t=1669066025;
        bh=zx4Cdk0YBUX790wuwU1BkV3ye7TR0ZHocy6xkxXkMec=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=kELn5PdoP/LfJs2vEg2fSbOULWWduIolV3A7dc4EXrq9tAgjMkAOMG9jRZAKLWC3L
         XUn40SCeNZDW7EwdWf0jAkwtB60gILe7FSk7ClHhBy+yQSK88BiGwu9tv8NUmOvLZ3
         Nol2/OTcqS+xgkE6yvOF0Zm1lTNdVZr5mY0gbV1k=
X-Virus-Scanned: amavisd-new at zproxy110.enst.fr
Received: from zproxy110.enst.fr ([IPv6:::1])
        by localhost (zproxy110.enst.fr [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id VApbQ0rEBinJ; Mon, 21 Nov 2022 22:27:05 +0100 (CET)
Received: from localhost (unknown [10.29.225.100])
        by zproxy110.enst.fr (Postfix) with ESMTPSA id 4953B81971;
        Mon, 21 Nov 2022 22:27:05 +0100 (CET)
From:   =?UTF-8?q?Santiago=20Ruano=20Rinc=C3=B3n?= 
        <santiago.ruano-rincon@imt-atlantique.fr>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Santiago=20Ruano=20Rinc=C3=B3n?= 
        <santiago.ruano-rincon@imt-atlantique.fr>
Subject: [PATCH v2] net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP
Date:   Mon, 21 Nov 2022 21:53:05 +0100
Message-Id: <20221121205304.62587-1-santiago.ruano-rincon@imt-atlantique.fr>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y3u/2gDlJFi9HB/x@kroah.com>
References: <Y3u/2gDlJFi9HB/x@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

Fixes: 266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet de=
vices")
Signed-off-by: Santiago Ruano Rinc=C3=B3n <santiago.ruano-rincon@imt-atla=
ntique.fr>
---
V1 -> V2: Fixed Fixes: tag format and removed stray blank line in changel=
og

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

