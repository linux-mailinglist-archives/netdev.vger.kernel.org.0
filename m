Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BA6359F88
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhDINHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:07:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45840 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhDINHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:07:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUqr8-00080K-KD; Fri, 09 Apr 2021 13:07:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ganapatrao Kulkarni <ganapatrao.kulkarni@caviumnetworks.com>,
        David Daney <david.daney@cavium.com>,
        Sruthi Vangala <svangala@cavium.com>,
        Thanneeru Srinivasulu <tsrinivasulu@caviumnetworks.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: thunderx: Fix unintentional sign extension issue
Date:   Fri,  9 Apr 2021 14:07:26 +0100
Message-Id: <20210409130726.665490-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The shifting of the u8 integers rq->caching by 26 bits to
the left will be promoted to a 32 bit signed int and then
sign-extended to a u64. In the event that rq->caching is
greater than 0x1f then all then all the upper 32 bits of
the u64 end up as also being set because of the int
sign-extension. Fix this by casting the u8 values to a
u64 before the 26 bit left shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: 4863dea3fab0 ("net: Adding support for Cavium ThunderX network controller")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index f782e6af45e9..50bbe79fb93d 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -776,7 +776,7 @@ static void nicvf_rcv_queue_config(struct nicvf *nic, struct queue_set *qs,
 	mbx.rq.msg = NIC_MBOX_MSG_RQ_CFG;
 	mbx.rq.qs_num = qs->vnic_id;
 	mbx.rq.rq_num = qidx;
-	mbx.rq.cfg = (rq->caching << 26) | (rq->cq_qs << 19) |
+	mbx.rq.cfg = ((u64)rq->caching << 26) | (rq->cq_qs << 19) |
 			  (rq->cq_idx << 16) | (rq->cont_rbdr_qs << 9) |
 			  (rq->cont_qs_rbdr_idx << 8) |
 			  (rq->start_rbdr_qs << 1) | (rq->start_qs_rbdr_idx);
-- 
2.30.2

