Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1975F438088
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhJVXU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhJVXU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DBE861038;
        Fri, 22 Oct 2021 23:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944719;
        bh=0CdJBfEhvqrYf9UenU/nJ3QMAiVFDGxZBpBM+XZIFuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSZ6ort6jMTk2WON1+Q0YrcpcJ+bJOtv4rJ6BlxuHUiD7yLmyDjcpppd/LZZlQck3
         lAuJM3+JIEf5DrFud77UrjQ1XA2kfzCCFSqMkNkLi7KFNR/E7a5p6amZEk/90ahRRp
         s9LUxi7ibwZSEPo3fcoYvOIMSdM11C8lGPYQ8QtBosVYOlW4pGNiX6vjytcx9QBQSD
         0FWeY9mfeFzJo2ozanXuMh+j4wsQyl5wieuo6QiOl3jWzBzzDxFaP9doi5+D9hghsp
         B8bmnsmQtTNfWldCSpiVtAuduMt7vZYJRrYjpUwbyYH81EoX+ajdBZRd882+q7GqXW
         /8Rm2sjbzI0Lg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/2] bluetooth: use eth_hw_addr_set()
Date:   Fri, 22 Oct 2021 16:18:33 -0700
Message-Id: <20211022231834.2710245-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022231834.2710245-1-kuba@kernel.org>
References: <20211022231834.2710245-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Convert bluetooth from memcpy(... ETH_ADDR) to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - memcpy(dev->dev_addr, np, ETH_ALEN)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/bnep/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 72f47b372705..c9add7753b9f 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -594,7 +594,7 @@ int bnep_add_connection(struct bnep_connadd_req *req, struct socket *sock)
 	 * ie. eh.h_dest is our local address. */
 	memcpy(s->eh.h_dest,   &src, ETH_ALEN);
 	memcpy(s->eh.h_source, &dst, ETH_ALEN);
-	memcpy(dev->dev_addr, s->eh.h_dest, ETH_ALEN);
+	eth_hw_addr_set(dev, s->eh.h_dest);
 
 	s->dev   = dev;
 	s->sock  = sock;
-- 
2.31.1

