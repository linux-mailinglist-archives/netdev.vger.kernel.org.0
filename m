Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118C2159273
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgBKPBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:01:00 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:01:00 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6577c25f;
        Tue, 11 Feb 2020 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=11b3qdMpEUn3A+QDH0DblVlTP
        iM=; b=cONoA0izQ5VAJYgFqSp9C1NAZYImk+htrDRv8h4STTPNqGmdwmk+tkSpH
        xPwqSmQBJ7BYttHpw0OPav4z3Vyqi4Vx+J6J6X8ulRfgEsiDsW2VjLj0owTPhIqA
        6oYU92C2amOoCO8X6vW7p80laayFZDH/6y7pxR7d3u0cynQYQzU+8gsQijXohNwb
        /HcHVJcCToRJaybY5gf47bCePy96muMldMbkPhRF0tH5cSdZFPaDh0rVCymxkUQ3
        EZXC4ankiMRsXmjOM09+ZReYM7LcEtMMORU9m9MOU1mGPCZ//AdNLJkXMM+7LnMM
        oZzXT2ienMkA/EV7V2cWE+yykQAkg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e0e14332 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:59:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: [PATCH v3 net 7/9] ipvlan: remove skb_share_check from xmit path
Date:   Tue, 11 Feb 2020 16:00:26 +0100
Message-Id: <20200211150028.688073-8-Jason@zx2c4.com>
In-Reply-To: <20200211150028.688073-1-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an impossible condition to reach; an skb in ndo_start_xmit won't
be shared by definition.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Link: https://lore.kernel.org/netdev/CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com/
---
 drivers/net/ipvlan/ipvlan_core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 30cd0c4f0be0..da40723065f2 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -605,9 +605,6 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
 				return ipvlan_rcv_frame(addr, &skb, true);
 			}
 		}
-		skb = skb_share_check(skb, GFP_ATOMIC);
-		if (!skb)
-			return NET_XMIT_DROP;
 
 		/* Packet definitely does not belong to any of the
 		 * virtual devices, but the dest is local. So forward
-- 
2.25.0

