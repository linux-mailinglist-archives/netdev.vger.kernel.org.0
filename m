Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAACFA354
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbfKMB7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbfKMB7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8633222469;
        Wed, 13 Nov 2019 01:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610376;
        bh=3N5qwJ28NYzzO8le2/ydKVm0EDx1lQt2MdyjGiVw1Lw=;
        h=From:To:Cc:Subject:Date:From;
        b=epFIyoLnGEtxVWzO2WB09rhbvmoDcSqtOak1469jSqEi0QNN7hd4tTHu/etV8suRX
         ZlILOimW9i1Gt46PHafzMMV86isw3DWNE1YSscWcqLZ6V93qTra/gt+ztxigLdIYyd
         OaqLBbt6ZTx0thAfCixhrZxLZwzKIChONe4FiJs4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH AUTOSEL 4.9 01/68] net: ovs: fix return type of ndo_start_xmit function
Date:   Tue, 12 Nov 2019 20:58:25 -0500
Message-Id: <20191113015932.12655-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit eddf11e18dff0e8671e06ce54e64cfc843303ab9 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-internal_dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index e7da29021b38b..c233924825801 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -44,7 +44,8 @@ static struct internal_dev *internal_dev_priv(struct net_device *netdev)
 }
 
 /* Called with rcu_read_lock_bh. */
-static int internal_dev_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t
+internal_dev_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	int len, err;
 
@@ -63,7 +64,7 @@ static int internal_dev_xmit(struct sk_buff *skb, struct net_device *netdev)
 	} else {
 		netdev->stats.tx_errors++;
 	}
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 static int internal_dev_open(struct net_device *netdev)
-- 
2.20.1

