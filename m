Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B654943B8A3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbhJZR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237975AbhJZR4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B73F6103C;
        Tue, 26 Oct 2021 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635270834;
        bh=whf4C39z/xu0gPPev4QsXNzrCAZV/tyBkKPQGGkpOIY=;
        h=From:To:Cc:Subject:Date:From;
        b=cTTPpv/H3LCY2pcS71KGdGZ6XNS+AQPCWSivUY3woXpvVYNglU5l7LRadhHF0SDUS
         vOWXSUHWm40JN8KQ3xtoL0wb+kcXVJIY50DrqCo8IS6HZs7Y9p4qapK4gE+2KBUJfR
         w10ewtewUvo7rDv7/H7LSGp3YwllWK4W2s5Fowlk2nJCy4pgP1cP5HxAeCKxr6xVsN
         2lT1veXkGfnX/SsVDNy5DfByGsC0yEwTSgtwCxA/U0sadXlBo8GdJJxJUzQx1XHBeQ
         hL/SsQ0Qd7VthQL6WIVS5ykecJuCq1A5cUu6YVhrqXgsTD1Mxbs/2P46Tffk08soe7
         RrKQBivraDAwQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, stefanr@s5r6.in-berlin.de,
        linux1394-devel@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] firewire: don't write directly to netdev->dev_addr
Date:   Tue, 26 Oct 2021 10:53:52 -0700
Message-Id: <20211026175352.3197750-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Prepare fwnet_hwaddr on the stack and use dev_addr_set() to copy
it to netdev->dev_addr. We no longer need to worry about alignment.
union fwnet_hwaddr does not have any padding and we set all fields
so we don't need to zero it upfront.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/firewire/net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 4c3fd2eed1da..dcc141068128 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1443,8 +1443,8 @@ static int fwnet_probe(struct fw_unit *unit,
 	struct net_device *net;
 	bool allocated_netdev = false;
 	struct fwnet_device *dev;
+	union fwnet_hwaddr ha;
 	int ret;
-	union fwnet_hwaddr *ha;
 
 	mutex_lock(&fwnet_device_mutex);
 
@@ -1491,12 +1491,12 @@ static int fwnet_probe(struct fw_unit *unit,
 	net->max_mtu = 4096U;
 
 	/* Set our hardware address while we're at it */
-	ha = (union fwnet_hwaddr *)net->dev_addr;
-	put_unaligned_be64(card->guid, &ha->uc.uniq_id);
-	ha->uc.max_rec = dev->card->max_receive;
-	ha->uc.sspd = dev->card->link_speed;
-	put_unaligned_be16(dev->local_fifo >> 32, &ha->uc.fifo_hi);
-	put_unaligned_be32(dev->local_fifo & 0xffffffff, &ha->uc.fifo_lo);
+	ha.uc.uniq_id = cpu_to_be64(card->guid);
+	ha.uc.max_rec = dev->card->max_receive;
+	ha.uc.sspd = dev->card->link_speed;
+	ha.uc.fifo_hi = cpu_to_be16(dev->local_fifo >> 32);
+	ha.uc.fifo_lo = cpu_to_be32(dev->local_fifo & 0xffffffff);
+	dev_addr_set(net, ha.u);
 
 	memset(net->broadcast, -1, net->addr_len);
 
-- 
2.31.1

