Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA2DF068
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfJUOwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:52:12 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:43172 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbfJUOwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:52:11 -0400
Received: from ramsan ([84.194.98.4])
        by andre.telenet-ops.be with bizsmtp
        id GErr2100E05gfCL01Erri3; Mon, 21 Oct 2019 16:52:09 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMZ2F-000767-52; Mon, 21 Oct 2019 16:51:51 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMZ2F-0008Fi-1d; Mon, 21 Oct 2019 16:51:51 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David@rox.of.borg, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Casey Leedom <leedom@chelsio.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Kevin Hilman <khilman@kernel.org>, Nishanth Menon <nm@ti.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/5] ionic: Use debugfs_create_bool() to export bool
Date:   Mon, 21 Oct 2019 16:51:49 +0200
Message-Id: <20191021145149.31657-6-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021145149.31657-1-geert+renesas@glider.be>
References: <20191021145149.31657-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bool ionic_cq.done_color is exported using
debugfs_create_u8(), which requires a cast, preventing further compiler
checks.

Fix this by switching to debugfs_create_bool(), and dropping the cast.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index bc03cecf80cc9eb4..5beba915f69d12dd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -170,8 +170,7 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	debugfs_create_x64("base_pa", 0400, cq_dentry, &cq->base_pa);
 	debugfs_create_u32("num_descs", 0400, cq_dentry, &cq->num_descs);
 	debugfs_create_u32("desc_size", 0400, cq_dentry, &cq->desc_size);
-	debugfs_create_u8("done_color", 0400, cq_dentry,
-			  (u8 *)&cq->done_color);
+	debugfs_create_bool("done_color", 0400, cq_dentry, &cq->done_color);
 
 	debugfs_create_file("tail", 0400, cq_dentry, cq, &cq_tail_fops);
 
-- 
2.17.1

