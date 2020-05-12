Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC281CFBB9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgELROA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:14:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43842 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELRN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:13:59 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jYYTb-00026T-Sc; Tue, 12 May 2020 17:13:55 +0000
From:   Colin King <colin.king@canonical.com>
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] sfc: fix dereference of table before it is null checked
Date:   Tue, 12 May 2020 18:13:55 +0100
Message-Id: <20200512171355.221810-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently pointer table is being dereferenced on a null check of
table->must_restore_filters before it is being null checked, leading
to a potential null pointer dereference issue.  Fix this by null
checking table before dereferencing it when checking for a null
table->must_restore_filters.

Addresses-Coverity: ("Dereference before null check")
Fixes: e4fe938cff04 ("sfc: move 'must restore' flags out of ef10-specific nic_data")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/sfc/mcdi_filters.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 88de95a8c08c..455a62814fb9 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1369,10 +1369,7 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 
 	WARN_ON(!rwsem_is_locked(&efx->filter_sem));
 
-	if (!table->must_restore_filters)
-		return;
-
-	if (!table)
+	if (!table || !table->must_restore_filters)
 		return;
 
 	down_write(&table->lock);
-- 
2.25.1

