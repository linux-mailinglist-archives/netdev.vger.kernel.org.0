Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7DB2E7001
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 12:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgL2LmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 06:42:11 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55471 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726168AbgL2LmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 06:42:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 29 Dec 2020 13:41:21 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BTBfKQh031596;
        Tue, 29 Dec 2020 13:41:21 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, andy@greyhouse.net,
        vfalico@gmail.com, j.vosburgh@gmail.com,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH RFC net-next 3/6] net/tls: Except bond interface from some TLS checks
Date:   Tue, 29 Dec 2020 13:41:01 +0200
Message-Id: <20201229114104.7120-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201229114104.7120-1-tariqt@nvidia.com>
References: <20201229114104.7120-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the tls_dev_event handler, ignore tls_dev_ops requirement for bond
interfaces, they do not exist as the interaction is done directly with
the slave.

Also, make the validate function pass when it's called with the upper
bond interface.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/tls/tls_device.c          | 2 ++
 net/tls/tls_device_fallback.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 75ceea0a41bf..d9cd229aa111 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1329,6 +1329,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 	switch (event) {
 	case NETDEV_REGISTER:
 	case NETDEV_FEAT_CHANGE:
+		if (netif_is_bond_master(dev))
+			return NOTIFY_DONE;
 		if ((dev->features & NETIF_F_HW_TLS_RX) &&
 		    !dev->tlsdev_ops->tls_dev_resync)
 			return NOTIFY_BAD;
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index d946817ed065..40e4cf321878 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -424,7 +424,8 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 				      struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	if (dev == tls_get_ctx(sk)->netdev)
+	/* TODO: verify slave belongs to the master? */
+	if (dev == tls_get_ctx(sk)->netdev || netif_is_bond_master(dev))
 		return skb;
 
 	return tls_sw_fallback(sk, skb);
-- 
2.21.0

