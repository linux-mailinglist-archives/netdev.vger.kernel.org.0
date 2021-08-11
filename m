Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EBC3E9A71
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhHKVik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232168AbhHKVif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F52261077;
        Wed, 11 Aug 2021 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628717891;
        bh=QUaTvlviFyTEOoRHW6ykVrEI6AwdYiNZJvvxcKb8mw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSJ3xkycM8Z2sPnuOZbabp76OFZYV/+SAoDhHaRrdcwV2uAOq4p/z4K8vXD26d5hb
         qrIaeG9JYKgep/4Hn/FE16uBmuUo/sAxEzbtVWSvHnjE72vn2uqgQcOTkK0lIpmF0e
         YOUXAYznCfEOhQoaEdBm+0/mTw/5kkDDjQptvYLSZ7/tpDlUEOThT8qdNdOn+rXVWU
         Fm6qeS0PJXqSEneeUyEBwaWR/FNBM9PoIkaDCvrysTKZNNCXNXS2ITdF6/vU/PVpFJ
         BACebufUJzRIZxF1H6dPvSRU8qeRIZIO78NZcfeF2lWZVA7DY44b3MmHoGxd6MNJ+u
         CF5sGRWG/OP/g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 2/4] bnxt: disable napi before canceling DIM
Date:   Wed, 11 Aug 2021 14:37:47 -0700
Message-Id: <20210811213749.3276687-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811213749.3276687-1-kuba@kernel.org>
References: <20210811213749.3276687-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi schedules DIM, napi has to be disabled first,
then DIM canceled.

Noticed while reading the code.

Fixes: 0bc0b97fca73 ("bnxt_en: cleanup DIM work on device shutdown")
Fixes: 6a8788f25625 ("bnxt_en: add support for software dynamic interrupt moderation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 365f8ae91acb..52f5c8405e76 100644
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

