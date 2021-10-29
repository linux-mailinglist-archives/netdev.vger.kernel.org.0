Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1047A43F510
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 04:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJ2Ctm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 22:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231584AbhJ2Ctl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 22:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2617861175;
        Fri, 29 Oct 2021 02:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635475633;
        bh=tiMVZ2XyRVbORniU+vtW0g1IFv6IL3znQKoUPUMCTIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvF0DzL8BaGh+RxlEhqAinVDifdP1rnwBubvubniCLq+jD1TakXUu9rMSxXO/1OrA
         9Y5WpWNjj8v9sXrc89QUVnn7u6nSSFObb+0ZVK/ZzuchYLrUFwm8A2I4Gvy6WLOUq8
         QKsjg67iqydQ+ZT3wV2sT9uzhfOl3P7lexKsQVih4xC6W23jGPk9q+ZuWSdkSfrFNv
         RpKmsv11rmuG2Zw5qc4H5BANlxr4OwEvB4hZHj78dP5vLntyk+AxUCMpiQQczxIQGf
         mk/WV6U2J3anA4108im43wXDD53hfchDLJDFbJqZtLRRrutCWxeWTub06SQmhoU5M0
         5PukDNbv+MDHA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        johannes.berg@intel.com, linux-um@lists.infradead.org
Subject: [PATCH net-next 2/3] net: um: use eth_hw_addr_set()
Date:   Thu, 28 Oct 2021 19:47:06 -0700
Message-Id: <20211029024707.316066-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029024707.316066-1-kuba@kernel.org>
References: <20211029024707.316066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jdike@addtoit.com
CC: richard@nod.at
CC: anton.ivanov@cambridgegreys.com
CC: johannes.berg@intel.com
CC: linux-um@lists.infradead.org
---
 arch/um/drivers/net_kern.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 2fc0b038ff8a..59331384c2d3 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -276,7 +276,7 @@ static const struct ethtool_ops uml_net_ethtool_ops = {
 
 void uml_net_setup_etheraddr(struct net_device *dev, char *str)
 {
-	unsigned char *addr = dev->dev_addr;
+	u8 addr[ETH_ALEN];
 	char *end;
 	int i;
 
@@ -316,6 +316,7 @@ void uml_net_setup_etheraddr(struct net_device *dev, char *str)
 		       addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4],
 		       addr[5]);
 	}
+	eth_hw_addr_set(dev, addr);
 	return;
 
 random:
-- 
2.31.1

