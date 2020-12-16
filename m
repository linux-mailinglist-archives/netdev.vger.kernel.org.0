Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773A42DC061
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 13:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgLPMgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 07:36:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44723 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgLPMgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 07:36:49 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kpW2G-0007cd-IZ; Wed, 16 Dec 2020 12:36:04 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George Cherian <george.cherian@marvell.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Fix undetected unmap PF error check
Date:   Wed, 16 Dec 2020 12:36:04 +0000
Message-Id: <20201216123604.15369-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check for an unmap PF error is always going to be false
because intr_val is a 32 bit int and is being bit-mask checked against
1ULL << 32.  Fix this by making intr_val a u64 to match the type at it
is copied from, namely npa_event_context->npa_af_rvu_ge.

Addresses-Coverity: ("Operands don't affect result")
Fixes: f1168d1e207c ("octeontx2-af: Add devlink health reporters for NPA")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 3f9d0ab6d5ae..bc0e4113370e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -275,7 +275,8 @@ static int rvu_npa_report_show(struct devlink_fmsg *fmsg, void *ctx,
 			       enum npa_af_rvu_health health_reporter)
 {
 	struct rvu_npa_event_ctx *npa_event_context;
-	unsigned int intr_val, alloc_dis, free_dis;
+	unsigned int alloc_dis, free_dis;
+	u64 intr_val;
 	int err;
 
 	npa_event_context = ctx;
-- 
2.29.2

