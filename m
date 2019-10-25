Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3433EE4A99
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502396AbfJYL6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:58:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43307 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393497AbfJYL6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:58:17 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iNyEN-0005rC-QD; Fri, 25 Oct 2019 11:58:11 +0000
From:   Colin King <colin.king@canonical.com>
To:     Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>,
        Sergey Samoilenko <sergey.samoilenko@aquantia.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: aquantia: fix unintention integer overflow on left shift
Date:   Fri, 25 Oct 2019 12:58:11 +0100
Message-Id: <20191025115811.20433-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Shifting the integer value 1 is evaluated using 32-bit
arithmetic and then used in an expression that expects a 64-bit
value, so there is potentially an integer overflow. Fix this
by using the BIT_ULL macro to perform the shift and avoid the
overflow.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: 04a1839950d9 ("net: aquantia: implement data PTP datapath")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 232df785488c..3eb9d22f7402 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -713,7 +713,7 @@ static int aq_ptp_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
 		aq_nic->aq_hw_ops->hw_irq_enable(aq_nic->aq_hw,
-					1 << aq_ptp->ptp_ring_param.vec_idx);
+					BIT_ULL(aq_ptp->ptp_ring_param.vec_idx));
 	}
 
 err_exit:
-- 
2.20.1

