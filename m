Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91447421A68
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 01:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhJDXDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 19:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231575AbhJDXDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 19:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 195C46126A;
        Mon,  4 Oct 2021 23:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633388504;
        bh=Bm/jQXiJU5yBX5ctMTB7mwj4NyuRX9y3Mrw2XSx7AAQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cwRL5vvHY6Y9sOlTVU1pyPb/3IijBN1JyY5cO1joTpaJJMJaEBAUQT5OBA9v4OqGD
         vbXYLo0lyOk7UJCvya8ILCWXTJDuRcBu3CTtdL6BBtffiVKXK8Wq9d2JIWUa9ki4UF
         TRVxOIJ8W5WnHYhTZGIK9/jwtX8mVfHaOXkoLivMWPLk9lzHfEf4MLQfghlnRMPwLs
         sX7Ic29wB8DuB+tuq99ykcGogQlLPe4Nhvx3F2D6lZBpP6L1uxen9FA9ZS4f6W9gZB
         HbgTRPf/Ni3kQHFjDH89//ahTNre6yD7ZwYuCFEPee2AmioYBd0NXj6xEKKqPtPqjZ
         NSEQ/mioGBVSA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] etherdevice: use __dev_addr_set()
Date:   Mon,  4 Oct 2021 16:01:40 -0700
Message-Id: <20211004230140.2547271-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew points out that eth_hw_addr_set() replaces memcpy()
calls so we can't use ether_addr_copy() which assumes
both arguments are 2-bytes aligned.

Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/etherdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index e7b2e5fd8d24..c8442d954d19 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -308,7 +308,7 @@ static inline void ether_addr_copy(u8 *dst, const u8 *src)
  */
 static inline void eth_hw_addr_set(struct net_device *dev, const u8 *addr)
 {
-	ether_addr_copy(dev->dev_addr, addr);
+	__dev_addr_set(dev, addr, ETH_ALEN);
 }
 
 /**
-- 
2.31.1

