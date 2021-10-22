Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D82437C2F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhJVRo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233305AbhJVRoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED5296109D;
        Fri, 22 Oct 2021 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634924558;
        bh=QOVNcAcQ6j4lXFQzvAxlv4geOgG9g056VbLlYNNJGz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnhKvWn92LHM0bajjcJl+t2P4oF2t3FJyHYxIWdt9QNvmY4o5jBIkA8XqqC3lpFdC
         HNLd7GFssBEaxazNMY7+CT2fzpHl02BfHwDp2UA/syqafPjn6tSeNUoZpr5crSBHC1
         IIRs22aMavHHNvYgiOaSz8y/Nlig4cf/YEt0mhVApcoOfznhrTS/vQ0369FXje8diu
         Dn+YTxM3CPV+NCNNinmGVDgGyboRu9hPL+YOc3v3ThZLqBSKEOwcBsCUtfG7VmCYLn
         Q2+FpUcsiqmGg5H9/xyVhUE9yTHE/qJ5PqMQcF7YjVS1bMu3YMFcqAxW7L7tkWo5IW
         cfyba2klAKAnA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] bluetooth: use eth_hw_addr_set()
Date:   Fri, 22 Oct 2021 10:42:31 -0700
Message-Id: <20211022174232.2510917-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022174232.2510917-1-kuba@kernel.org>
References: <20211022174232.2510917-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

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

