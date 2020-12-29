Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5282C2E7002
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 12:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL2LmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 06:42:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55470 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725964AbgL2LmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 06:42:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 29 Dec 2020 13:41:21 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BTBfKQg031596;
        Tue, 29 Dec 2020 13:41:20 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, andy@greyhouse.net,
        vfalico@gmail.com, j.vosburgh@gmail.com,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH RFC net-next 2/6] net/tls: Device offload to use lowest netdevice in chain
Date:   Tue, 29 Dec 2020 13:41:00 +0200
Message-Id: <20201229114104.7120-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201229114104.7120-1-tariqt@nvidia.com>
References: <20201229114104.7120-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not call the tls_dev_ops of upper devices. Instead, ask them
for the proper slave and communicate with it directly.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/tls/tls_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f7fb7d2c1de1..75ceea0a41bf 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -113,7 +113,7 @@ static struct net_device *get_netdev_for_sock(struct sock *sk)
 	struct net_device *netdev = NULL;
 
 	if (likely(dst)) {
-		netdev = dst->dev;
+		netdev = netdev_sk_get_lowest_dev(dst->dev, sk);
 		dev_hold(netdev);
 	}
 
-- 
2.21.0

