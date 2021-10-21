Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5179B436283
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhJUNOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhJUNOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5517960EE5;
        Thu, 21 Oct 2021 13:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821943;
        bh=JmyJm3i/SiDhWjXRNY20qubgZ/OCIxCqa+xNKoe0hX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXilTkFOvuzTPl18vzNrjkgnnM/2aZJSSPqiVVZJfUTwC3Opgcq65LKz1buVdZ4AF
         LFCf5EwgGksu16uLwNw/gFOFNRMdVB2HjuG4enpnwAhXA8W77nbognqfy01Tiq0JLZ
         hbm102VG0r3JD6K8GbkcvXcMuX6/6GgHLx0x/5AOe3efviRrjJjE75qes55rE/FkHM
         C1o/nMkva+NBK1XJpatz9PEbgp7d3FjC7oMKWN+KnbrwoFpXY05pnecMSzDlkqDVsq
         5tlwyyilLh2V98vMWohBWOTPpCIoNUqL1MUwtJQEVylNjmy557zBEqjwiwrrsVZFnJ
         DR0QEglf22O3g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        khc@pm.waw.pl
Subject: [PATCH net-next v2 12/12] net: hldc_fr: use dev_addr_set()
Date:   Thu, 21 Oct 2021 06:12:14 -0700
Message-Id: <20211021131214.2032925-13-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
References: <20211021131214.2032925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: khc@pm.waw.pl
---
 drivers/net/wan/hdlc_fr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 7637edce443e..81e72bc1891f 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1093,7 +1093,9 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 		eth_hw_addr_random(dev);
 	} else {
-		*(__be16 *)dev->dev_addr = htons(dlci);
+		__be16 addr = htons(dlci);
+
+		dev_addr_set(dev, (u8 *)&addr);
 		dlci_to_q922(dev->broadcast, dlci);
 	}
 	dev->netdev_ops = &pvc_ops;
-- 
2.31.1

