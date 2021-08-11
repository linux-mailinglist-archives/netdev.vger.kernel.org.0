Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A163E98CD
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhHKTdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhHKTdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 15:33:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E4F6105A;
        Wed, 11 Aug 2021 19:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628710361;
        bh=Y9ijIe3t+vSj65xBYYS1D5mdjRafr2aNgBVULU20ZOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLhjHxcFMN/OjdYiJ+V/fHY3Q7yaOqeLbEYExA+Fzasyso1H6Yxm7y0QmaVEdec31
         wW4C+okhjv+luezAlwTuJnL5f0tdy+8e/5Mi7CoZqpRonOh5yRjyGvfvfN6GsH5vuk
         FQkwfloW+yegIdyZRV69ojXyHy0hZ6d3PqJoQVf2F4Puu3O6bMfRXfs5BLslcffLnD
         dTSwLmfI8TQxfZgomEjdqhmMYGqN8eqk9e5MOXPMvoxXrnv7/Ql6yxaFGTDF9Huk31
         ucy1obW0vwKA6przexAyEl0ppkS6nHV86TlN8qaFao5fm8lApMRXkBLvgy90M/wcyz
         h2KbMtLhp4Q5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/4] bnxt: disable napi before cancelling DIM
Date:   Wed, 11 Aug 2021 12:32:37 -0700
Message-Id: <20210811193239.3155396-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811193239.3155396-1-kuba@kernel.org>
References: <20210811193239.3155396-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi schedules DIM, napi has to be disabled first,
then DIM cancelled.

Noticed while reading the code.

Fixes: 0bc0b97fca73 ("bnxt_en: cleanup DIM work on device shutdown")
Fixes: 6a8788f25625 ("bnxt_en: add support for software dynamic interrupt moderation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 07827d6b0fec..2c0240ee2105 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9222,10 +9222,9 @@ static void bnxt_disable_napi(struct bnxt *bp)
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_cp_ring_info *cpr = &bp->bnapi[i]->cp_ring;
 
+		napi_disable(&bp->bnapi[i]->napi);
 		if (bp->bnapi[i]->rx_ring)
 			cancel_work_sync(&cpr->dim.work);
-
-		napi_disable(&bp->bnapi[i]->napi);
 	}
 }
 
-- 
2.31.1

