Return-Path: <netdev+bounces-8655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1485725160
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF463281152
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAEA62A;
	Wed,  7 Jun 2023 01:08:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00457C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE560C433D2;
	Wed,  7 Jun 2023 01:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686100108;
	bh=3e2m0ANaODjZQ6OCWGCXqO65I3TmhSwyWFSXVVgxLm4=;
	h=From:To:Cc:Subject:Date:From;
	b=hWeJ5yoqnE3u56uTRRTtpZuqQp7VbMIuzl6D3oZBGvvlFr++yLm26xjD6BAeIv8Zi
	 3k5T+qWWGgnbyh19bFsEpkQDtutggdIO7QflMad00fmJvoed8vHABdlj4WSo8t+qqU
	 co/D0u59pRPNXzqITjCQwp3ZkeIdmMYa2ShZ6lHHKwbp38ZvAG6tXTU3M8KkAMNXQS
	 rJRXT+dB82SxhWA881CdR3U8QJ7xCM3uA7LzDFnNp7Zw5Y1xata+Q0gjaIYAxB3kRF
	 YshrXSS0qf5ufsM7voPjOzY1ShZ5m5ZVo5csebFo7oYtQTL2AC0gIcytGcF9GDQ+Kg
	 TyRgeirmOgTaA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	David Wei <davidhwei@meta.com>,
	michael.chan@broadcom.com
Subject: [PATCH net 1/2] eth: bnxt: fix the wake condition
Date: Tue,  6 Jun 2023 18:08:25 -0700
Message-Id: <20230607010826.960226-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The down condition should be the negation of the wake condition,
IOW when I moved it from:

 if (cond && wake())
to
 if (__netif_txq_completed_wake(cond))

Cond should have been negated. Flip it now.

This bug leads to occasional crashes with netconsole.
It may also lead to queue never waking up in case BQL is not enabled.

Reported-by: David Wei <davidhwei@meta.com>
Fixes: 08a096780d92 ("bnxt: use new queue try_stop/try_wake macros")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: michael.chan@broadcom.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dcd9367f05af..1f04cd4cfab9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -692,7 +692,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 
 	__netif_txq_completed_wake(txq, nr_pkts, tx_bytes,
 				   bnxt_tx_avail(bp, txr), bp->tx_wake_thresh,
-				   READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING);
+				   READ_ONCE(txr->dev_state) == BNXT_DEV_STATE_CLOSING);
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
-- 
2.40.1


