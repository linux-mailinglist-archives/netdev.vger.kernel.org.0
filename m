Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37522998E6
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389469AbgJZVeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbgJZVeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:34:14 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DFD3207C4;
        Mon, 26 Oct 2020 21:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603748054;
        bh=xqB3X08bN2svUASvlYu38zyWDmiDAAvYC7985pJeF4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYovXbsBze1BmDe27+xif23hvxMIpGhp9aPbxWLlDRr4FYNP1Ant6CcdBwSQlkAlF
         XWgpTqfxbKNoCySSINjmmqcD7Jve0DekqlN6cxHgiDfRrbLkTgTjv23VTNfD2VnQN/
         LPCfPlu2NNPYKO44FVt+sg5vW9fVs1V1l1gGDTQQ=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, YueHaibing <yuehaibing@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/11] ch_ktls: fix enum-conversion warning
Date:   Mon, 26 Oct 2020 22:29:57 +0100
Message-Id: <20201026213040.3889546-10-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc points out an incorrect enum assignment:

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c: In function 'chcr_ktls_cpl_set_tcb_rpl':
drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:684:22: warning: implicit conversion from 'enum <anonymous>' to 'enum ch_ktls_open_state' [-Wenum-conversion]

This appears harmless, and should apparently use 'CH_KTLS_OPEN_SUCCESS'
instead of 'false', with the same value '0'.

Fixes: efca3878a5fb ("ch_ktls: Issue if connection offload fails")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 5195f692f14d..83787f62577d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -681,7 +681,7 @@ static int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 		kvfree(tx_info);
 		return 0;
 	}
-	tx_info->open_state = false;
+	tx_info->open_state = CH_KTLS_OPEN_SUCCESS;
 	spin_unlock(&tx_info->lock);
 
 	complete(&tx_info->completion);
-- 
2.27.0

