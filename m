Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97682663F78
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjAJLsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237985AbjAJLsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:48:16 -0500
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E5D5130D;
        Tue, 10 Jan 2023 03:47:58 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 936B018645D4;
        Tue, 10 Jan 2023 14:47:55 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id teKG9EtdPpka; Tue, 10 Jan 2023 14:47:55 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 36769186430F;
        Tue, 10 Jan 2023 14:47:55 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hm14qot5vYFk; Tue, 10 Jan 2023 14:47:55 +0300 (MSK)
Received: from ekaterina-MACHD-WXX9.. (unknown [10.177.227.133])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 653E518640AB;
        Tue, 10 Jan 2023 14:47:54 +0300 (MSK)
From:   Esina Ekaterina <eesina@astralinux.ru>
To:     Zhao Qiang <qiang.zhao@nxp.com>
Cc:     Esina Ekaterina <eesina@astralinux.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wan: Add checks for NULL. If uhdlc_priv_tsa != 1 then utdm is not initialized. And if ret != NULL then goto undo_uhdlc_init, where utdm is dereferenced. Same if dev == NULL.
Date:   Tue, 10 Jan 2023 14:47:45 +0300
Message-Id: <20230110114745.43894-1-eesina@astralinux.ru>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>

v2: Add check for NULL for unmap_si_regs
---
 drivers/net/wan/fsl_ucc_hdlc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdl=
c.c
index 22edea6ca4b8..ed7886bde727 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1243,9 +1243,13 @@ static int ucc_hdlc_probe(struct platform_device *=
pdev)
 free_dev:
 	free_netdev(dev);
 undo_uhdlc_init:
-	iounmap(utdm->siram);
+	if (utdm !=3D NULL) {
+		iounmap(utdm->siram);
+	}
 unmap_si_regs:
-	iounmap(utdm->si_regs);
+	if (utdm !=3D NULL) {
+		iounmap(utdm->si_regs);
+	}
 free_utdm:
 	if (uhdlc_priv->tsa)
 		kfree(utdm);
--=20
2.34.1

