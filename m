Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E5A666427
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbjAKTzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjAKTzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:55:45 -0500
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC06C9;
        Wed, 11 Jan 2023 11:55:43 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id AF4D318631FE;
        Wed, 11 Jan 2023 22:55:39 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id v5ixd9kkAFuB; Wed, 11 Jan 2023 22:55:39 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 5EB981863D8C;
        Wed, 11 Jan 2023 22:55:39 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id k3e5njk-Uncm; Wed, 11 Jan 2023 22:55:39 +0300 (MSK)
Received: from ekaterina-MACHD-WXX9.. (host-189-224.skynet-msk.ru [91.227.189.224])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 98CC418631FE;
        Wed, 11 Jan 2023 22:55:38 +0300 (MSK)
From:   Esina Ekaterina <eesina@astralinux.ru>
To:     Zhao Qiang <qiang.zhao@nxp.com>
Cc:     Esina Ekaterina <eesina@astralinux.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH v4] net: wan: Add checks for NULL for utdm in  undo_uhdlc_init and unmap_si_regs
Date:   Wed, 11 Jan 2023 22:55:33 +0300
Message-Id: <20230111195533.82519-1-eesina@astralinux.ru>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111102848.44863b9c@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If uhdlc_priv_tsa !=3D 1 then utdm is not initialized.
And if ret !=3D NULL then goto undo_uhdlc_init, where
utdm is dereferenced. Same if dev =3D=3D NULL.

Found by Astra Linux on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>
  ---
v4: Fix style
v3: Remove braces
v2: Add check for NULL for unmap_si_regs
---
 drivers/net/wan/fsl_ucc_hdlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdl=
c.c
index 22edea6ca4b8..1c53b5546927 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1243,9 +1243,11 @@ static int ucc_hdlc_probe(struct platform_device *=
pdev)
 free_dev:
 	free_netdev(dev);
 undo_uhdlc_init:
-	iounmap(utdm->siram);
+	if (utdm)
+		iounmap(utdm->siram);
 unmap_si_regs:
-	iounmap(utdm->si_regs);
+	if (utdm)
+		iounmap(utdm->si_regs);
 free_utdm:
 	if (uhdlc_priv->tsa)
 		kfree(utdm);
--=20
2.39.0

