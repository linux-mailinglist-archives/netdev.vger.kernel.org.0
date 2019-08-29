Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC7BA2422
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbfH2SRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbfH2SRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EF5233FF;
        Thu, 29 Aug 2019 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102661;
        bh=nP5kv1JKYorryJCXJOQKQYxTAfSHNsL1M5YLvCVaqgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oB+UiqZZK2CONe+eS0EjYkep7bZkLt+SZSvTCt/E6F8h0E8LqicTOYMPQqwU9/PQq
         B/PLrghbGaZSOFzc1mDzIh+UCE4OfiLIbI28OYWaVEcy9FuQgMAeX3E1l4I2QjWBV/
         l74Slq3q7PFUnxU/om834pyItsSManylgYvxEzk8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 02/16] net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx
Date:   Thu, 29 Aug 2019 14:17:20 -0400
Message-Id: <20190829181736.9040-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181736.9040-1-sashal@kernel.org>
References: <20190829181736.9040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 125b7e0949d4e72b15c2b1a1590f8cece985a918 ]

clang warns:

drivers/net/ethernet/toshiba/tc35815.c:1507:30: warning: use of logical
'&&' with constant operand [-Wconstant-logical-operand]
                        if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
                                                  ^  ~~~~~~~~~~~~
drivers/net/ethernet/toshiba/tc35815.c:1507:30: note: use '&' for a
bitwise operation
                        if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
                                                  ^~
                                                  &
drivers/net/ethernet/toshiba/tc35815.c:1507:30: note: remove constant to
silence this warning
                        if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
                                                 ~^~~~~~~~~~~~~~~
1 warning generated.

Explicitly check that NET_IP_ALIGN is not zero, which matches how this
is checked in other parts of the tree. Because NET_IP_ALIGN is a build
time constant, this check will be constant folded away during
optimization.

Fixes: 82a9928db560 ("tc35815: Enable StripCRC feature")
Link: https://github.com/ClangBuiltLinux/linux/issues/608
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/toshiba/tc35815.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 5b01b3fa9fec9..47ebac456ae57 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -1498,7 +1498,7 @@ tc35815_rx(struct net_device *dev, int limit)
 			pci_unmap_single(lp->pci_dev,
 					 lp->rx_skbs[cur_bd].skb_dma,
 					 RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN)
+			if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN != 0)
 				memmove(skb->data, skb->data - NET_IP_ALIGN,
 					pkt_len);
 			data = skb_put(skb, pkt_len);
-- 
2.20.1

