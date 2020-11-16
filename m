Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452242B4148
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgKPKld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:41:33 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:30151 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgKPKlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:41:32 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kebwt-0008hw-Ty; Mon, 16 Nov 2020 11:41:27 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kebwt-0004Ut-74; Mon, 16 Nov 2020 11:41:27 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id EBE7B240049;
        Mon, 16 Nov 2020 11:41:26 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 90BC9240047;
        Mon, 16 Nov 2020 11:41:26 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 524FC21E6A;
        Mon, 16 Nov 2020 11:41:26 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v3] net/tun: Call netdev notifiers
Date:   Mon, 16 Nov 2020 11:41:21 +0100
Message-ID: <20201116104121.20884-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1605523287-00014126-C1E0DC53/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call netdev notifiers before and after changing the device type.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---

Change from v2:
use subject_prefix 'net-next' to fix 'fixes_present' issue

Change from v1:
fix 'subject_prefix' and 'checkpatch' warnings

---
 drivers/net/tun.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3d45d56172cb..2d9a00f41023 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3071,9 +3071,13 @@ static long __tun_chr_ioctl(struct file *file, uns=
igned int cmd,
 				   "Linktype set failed because interface is up\n");
 			ret =3D -EBUSY;
 		} else {
+			call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
+						 tun->dev);
 			tun->dev->type =3D (int) arg;
 			netif_info(tun, drv, tun->dev, "linktype set to %d\n",
 				   tun->dev->type);
+			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
+						 tun->dev);
 			ret =3D 0;
 		}
 		break;
--=20
2.20.1

