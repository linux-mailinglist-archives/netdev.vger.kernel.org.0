Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E33229EA7
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgGVRkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:40:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45963 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGVRkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:40:07 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jyIip-000752-QJ; Wed, 22 Jul 2020 17:40:03 +0000
From:   Colin King <colin.king@canonical.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ionic: fix memory leak of object 'lid'
Date:   Wed, 22 Jul 2020 18:40:03 +0100
Message-Id: <20200722174003.962374-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently when netdev fails to allocate the error return path
fails to free the allocated object 'lid'.  Fix this by setting
err to the return error code and jumping to a new label that
performs the kfree of lid before returning.

Addresses-Coverity: ("Resource leak")
Fixes: 4b03b27349c0 ("ionic: get MTU from lif identity")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7ad338a4653c..728dd6429d80 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2034,7 +2034,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 				    ionic->ntxqs_per_lif, ionic->ntxqs_per_lif);
 	if (!netdev) {
 		dev_err(dev, "Cannot allocate netdev, aborting\n");
-		return ERR_PTR(-ENOMEM);
+		err = -ENOMEM;
+		goto err_out_free_lid;
 	}
 
 	SET_NETDEV_DEV(netdev, dev);
@@ -2120,6 +2121,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 err_out_free_netdev:
 	free_netdev(lif->netdev);
 	lif = NULL;
+err_out_free_lid:
 	kfree(lid);
 
 	return ERR_PTR(err);
-- 
2.27.0

