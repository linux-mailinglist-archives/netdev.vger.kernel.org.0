Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A58346B68
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhCWVx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233748AbhCWVxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 17:53:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65016619B3;
        Tue, 23 Mar 2021 21:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616536386;
        bh=V2fb0UEzfZd0vcBsxcQi9LFzvRC/iqf0tbUqQZ9dIro=;
        h=From:To:Cc:Subject:Date:From;
        b=oRbUi/3D7F2htn4xL5TWxJs1pRdEvhBd+BHbFymNrH7HKx61Taw56BuNdC0qjratR
         8X11eovz0s6pJJ8OODTqkilsd6xDMueZgnOP7ChpNTV1lPpVskpdKbJ5mXwTQFKPBI
         uom0UNPWxHr7udMNIlNABAmYE7jlm1aTpeYX8868lzY9zL5S4waCERlX43iDfwA7ow
         q0XJ8IA9FRD5On/WuW/rYP8FIBMNI4IddR6Bqx/0bkG6sIWffUlHbUGKGMh8/zqJXh
         qq+MqzT8LiCXOMbdqkJSNUhbAU77aX6GL1ScaiYMMVD6QHhSEZoNC13eEziy8MX1xr
         skBUlIC0Q5adA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] [RESEND] ch_ktls: fix enum-conversion warning
Date:   Tue, 23 Mar 2021 22:52:50 +0100
Message-Id: <20210323215302.30944-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I sent this last October, but it never made it in, resending
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 46a809f2aeca..7c599195e256 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -722,7 +722,7 @@ static int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 		kvfree(tx_info);
 		return 0;
 	}
-	tx_info->open_state = false;
+	tx_info->open_state = CH_KTLS_OPEN_SUCCESS;
 	spin_unlock(&tx_info->lock);
 
 	complete(&tx_info->completion);
-- 
2.29.2

