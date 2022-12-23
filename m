Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED567655166
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiLWOd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 09:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLWOdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 09:33:25 -0500
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2CB40818;
        Fri, 23 Dec 2022 06:33:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id A8D211864455;
        Fri, 23 Dec 2022 17:33:18 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id UFprKO6oY6NS; Fri, 23 Dec 2022 17:33:18 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 5CF381864449;
        Fri, 23 Dec 2022 17:33:18 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oLOt4vvLP2u6; Fri, 23 Dec 2022 17:33:18 +0300 (MSK)
Received: from localhost.localdomain (unknown [213.87.131.26])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 1EAF0186441A;
        Fri, 23 Dec 2022 17:33:17 +0300 (MSK)
From:   Ekaterina Esina <eesina@astralinux.ru>
To:     Zhao Qiang <qiang.zhao@nxp.com>
Cc:     Ekaterina Esina <eesina@astralinux.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH] net-wan: Add check for NULL for utdm in ucc_hdlc_probe
Date:   Fri, 23 Dec 2022 17:32:25 +0300
Message-Id: <20221223143225.23153-1-eesina@astralinux.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If uhdlc_priv_tsa !=3D 1 then utdm is not initialized.
And if ret !=3D NULL then goto undo_uhdlc_init, where utdm is dereference=
d.
Same if dev =3D=3D NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdl=
c.c
index 22edea6ca4b8..2ddb0f71e648 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1243,7 +1243,9 @@ static int ucc_hdlc_probe(struct platform_device *p=
dev)
 free_dev:
 	free_netdev(dev);
 undo_uhdlc_init:
-	iounmap(utdm->siram);
+	if (utdm !=3D NULL) {
+		iounmap(utdm->siram);
+	}
 unmap_si_regs:
 	iounmap(utdm->si_regs);
 free_utdm:
--=20
2.30.2

