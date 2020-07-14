Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50521F491
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgGNOkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729388AbgGNOkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 10:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A14DE2223C;
        Tue, 14 Jul 2020 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737631;
        bh=YQdGdyFZCQb1etR9mwK5uyrGf4eoBu/JddeSOQZWijc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hclcMJnhQdqmaYpycAXe2BbQQiIOkONlFfE3TU1CI6LwxVD5wVVMHJ2SdQkw3rff5
         d1AQxoXf9J8bDk3l/nv2EzrxVbqPStKjZnkHqBqia/qGhaksIx+V0z2zlcJzMy/jJi
         ScOdUb/bfk4RdjX2O9WzPPUJt3/b7OPZTNw81qHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 6/9] drivers/net/wan/lapbether: Fixed the value of hard_header_len
Date:   Tue, 14 Jul 2020 10:40:20 -0400
Message-Id: <20200714144024.4036118-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714144024.4036118-1-sashal@kernel.org>
References: <20200714144024.4036118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 9dc829a135fb5927f1519de11286e2bbb79f5b66 ]

When this driver transmits data,
  first this driver will remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes,
  then this driver will prepend a length field of 2 bytes,
  then the underlying Ethernet device will prepend its own header.

So, the header length required should be:
  -1 + 3 + 2 + "the header length needed by the underlying device".

This patch fixes kernel panic when this driver is used with AF_PACKET
SOCK_DGRAM sockets.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 6676607164d65..f5657783fad4e 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -308,7 +308,6 @@ static void lapbeth_setup(struct net_device *dev)
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->destructor	     = free_netdev;
 	dev->type            = ARPHRD_X25;
-	dev->hard_header_len = 3;
 	dev->mtu             = 1000;
 	dev->addr_len        = 0;
 }
@@ -329,6 +328,14 @@ static int lapbeth_new_device(struct net_device *dev)
 	if (!ndev)
 		goto out;
 
+	/* When transmitting data:
+	 * first this driver removes a pseudo header of 1 byte,
+	 * then the lapb module prepends an LAPB header of at most 3 bytes,
+	 * then this driver prepends a length field of 2 bytes,
+	 * then the underlying Ethernet device prepends its own header.
+	 */
+	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
+
 	lapbeth = netdev_priv(ndev);
 	lapbeth->axdev = ndev;
 
-- 
2.25.1

