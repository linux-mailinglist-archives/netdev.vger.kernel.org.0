Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9468238007F
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 00:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhEMWtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 18:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhEMWts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 18:49:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38FD9613CD;
        Thu, 13 May 2021 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946118;
        bh=zjDn79+oCEcXN7/ywRSvtSC+DVZKzNYOS/1XNPve5xk=;
        h=Date:From:To:Cc:Subject:From;
        b=UlNmGjy+Sr9KgC8Jul/5pxK7lQ0Ewhr04wTCFE0VpWtnTelzSfXWoUgoSVRCCmtf+
         FjcJtomzJWOJbRL22GadqACRdFcahUhlPtcKwiCNkkwACllCMz9xEf30u8ErqooM+q
         21Pl8jDgT1Bk2cOt9uN65TeS/rT9b3jFdRDUDDMBkLSnuXC7szI4G4/KOcnNANi4cj
         f4fPvbmR6/DvXLj1Bkl3lHknyRh3lmABpt8/Dmbzx4OUPXNB8XNkGL+hiRuWTbHTnR
         R4FTbTtGyhyfw9bw5aC8yxC+xgItBG81ASwRWWdHMDO8o0sTICpllveNuKPTaj33YU
         MSK2RiJYBFMLg==
Date:   Thu, 13 May 2021 17:49:14 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: mana: Use struct_size() in kzalloc()
Message-ID: <20210513224914.GA216478@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows
that, in the worst scenario, could lead to heap overflows.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 04d067243457..46aee2c49f1b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1387,8 +1387,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	gc = gd->gdma_context;
 
-	rxq = kzalloc(sizeof(*rxq) +
-		      RX_BUFFERS_PER_QUEUE * sizeof(struct mana_recv_buf_oob),
+	rxq = kzalloc(struct_size(rxq, rx_oobs, RX_BUFFERS_PER_QUEUE),
 		      GFP_KERNEL);
 	if (!rxq)
 		return NULL;
-- 
2.27.0

