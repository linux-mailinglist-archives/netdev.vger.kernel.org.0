Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A930DB78
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhBCNja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:39:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37195 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhBCNjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 08:39:19 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l7IMd-0007Q7-2D; Wed, 03 Feb 2021 13:38:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Coiby Xu <coiby.xu@gmail.com>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] staging: qlge: fix read of an uninitialized pointer
Date:   Wed,  3 Feb 2021 13:38:34 +0000
Message-Id: <20210203133834.22388-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the pointer 'reporter' is not being initialized and is
being read in a netdev_warn message.  The pointer is not used
and is redundant, fix this by removing it and replacing the reference
to it with priv->reporter instead.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: 1053c27804df ("staging: qlge: coredump via devlink health reporter")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/qlge/qlge_devlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index c6ef5163e241..86834d96cebf 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -150,7 +150,6 @@ static const struct devlink_health_reporter_ops qlge_reporter_ops = {
 
 void qlge_health_create_reporters(struct qlge_adapter *priv)
 {
-	struct devlink_health_reporter *reporter;
 	struct devlink *devlink;
 
 	devlink = priv_to_devlink(priv);
@@ -160,5 +159,5 @@ void qlge_health_create_reporters(struct qlge_adapter *priv)
 	if (IS_ERR(priv->reporter))
 		netdev_warn(priv->ndev,
 			    "Failed to create reporter, err = %ld\n",
-			    PTR_ERR(reporter));
+			    PTR_ERR(priv->reporter));
 }
-- 
2.29.2

