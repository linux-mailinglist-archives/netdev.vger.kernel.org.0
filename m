Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62842B7609
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 06:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgKRFqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 00:46:11 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:60821 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRFqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 00:46:11 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfGIA-0000tM-Br; Wed, 18 Nov 2020 06:46:06 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfGI9-00030X-GO; Wed, 18 Nov 2020 06:46:05 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E4CF1240041;
        Wed, 18 Nov 2020 06:46:04 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 85840240040;
        Wed, 18 Nov 2020 06:46:04 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 290F0204F6;
        Wed, 18 Nov 2020 06:46:04 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v4] net/tun: Call netdev notifiers
Date:   Wed, 18 Nov 2020 06:45:55 +0100
Message-ID: <20201118054555.14248-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1605678366-000064E4-D961B555/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call netdev notifiers before and after changing the device type.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
Changes to v3:
* Handle return value of call_netdevice_notifiers()

Changes to v2:
* Use subject_prefix 'net-next' to fix 'fixes_present' issue

Changes to v1:
* Fix 'subject_prefix' and 'checkpatch' warnings

---
 drivers/net/tun.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3d45d56172cb..704306695b88 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3071,10 +3071,19 @@ static long __tun_chr_ioctl(struct file *file, un=
signed int cmd,
 				   "Linktype set failed because interface is up\n");
 			ret =3D -EBUSY;
 		} else {
+			ret =3D call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
+						       tun->dev);
+			ret =3D notifier_to_errno(err);
+			if (ret) {
+				netif_info(tun, drv, tun->dev,
+					   "Refused to change device type\n");
+				break;
+			}
 			tun->dev->type =3D (int) arg;
 			netif_info(tun, drv, tun->dev, "linktype set to %d\n",
 				   tun->dev->type);
-			ret =3D 0;
+			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
+						 tun->dev);
 		}
 		break;
=20
--=20
2.20.1

