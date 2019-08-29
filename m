Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE07CA1FD3
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfH2PvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:51:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:32928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728295AbfH2Pui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 11:50:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E69AAFE8;
        Thu, 29 Aug 2019 15:50:36 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 12/15] net: sgi: ioc3-eth: use csum_fold
Date:   Thu, 29 Aug 2019 17:50:10 +0200
Message-Id: <20190829155014.9229-13-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190829155014.9229-1-tbogendoerfer@suse.de>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

replace open coded checksum folding by csum_fold.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index d62a75f2ed29..0c2713bba741 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1394,16 +1394,12 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* Sum up dest addr, src addr and protocol  */
 		ehsum = eh[0] + eh[1] + eh[2] + eh[3] + eh[4] + eh[5] + eh[6];
 
-		/* Fold ehsum.  can't use csum_fold which negates also ...  */
-		ehsum = (ehsum & 0xffff) + (ehsum >> 16);
-		ehsum = (ehsum & 0xffff) + (ehsum >> 16);
-
 		/* Skip IP header; it's sum is always zero and was
 		 * already filled in by ip_output.c
 		 */
 		csum = csum_tcpudp_nofold(ih->saddr, ih->daddr,
 					  ih->tot_len - (ih->ihl << 2),
-					  proto, 0xffff ^ ehsum);
+					  proto, csum_fold(ehsum));
 
 		csum = (csum & 0xffff) + (csum >> 16);	/* Fold again */
 		csum = (csum & 0xffff) + (csum >> 16);
-- 
2.13.7

