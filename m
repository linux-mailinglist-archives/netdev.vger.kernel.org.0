Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D433239AD4F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFCV6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:58:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52503 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhFCV6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 17:58:48 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lovKk-0000Gd-6t; Thu, 03 Jun 2021 21:56:58 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Yuval Avnery <yuvalav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] netdevsim: Fix unsigned being compared to less than zero
Date:   Thu,  3 Jun 2021 22:56:57 +0100
Message-Id: <20210603215657.154776-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison of len < 0 is always false because len is a size_t. Fix
this by making len a ssize_t instead.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: d395381909a3 ("netdevsim: Add max_vfs to bus_dev")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/netdevsim/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index b56003dfe3cc..ccec29970d5b 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -111,7 +111,7 @@ ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
 {
 	struct nsim_bus_dev *nsim_bus_dev = file->private_data;
 	char buf[11];
-	size_t len;
+	ssize_t len;
 
 	len = snprintf(buf, sizeof(buf), "%u\n", nsim_bus_dev->max_vfs);
 	if (len < 0)
-- 
2.31.1

