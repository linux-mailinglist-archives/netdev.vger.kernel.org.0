Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9E72F932C
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbhAQPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:01:19 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45212 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729218AbhAQPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:01:05 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 17 Jan 2021 17:00:16 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10HF0F7J029614;
        Sun, 17 Jan 2021 17:00:16 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 8/8] net/tls: Except bond interface from some TLS checks
Date:   Sun, 17 Jan 2021 16:59:49 +0200
Message-Id: <20210117145949.8632-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210117145949.8632-1-tariqt@nvidia.com>
References: <20210117145949.8632-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the tls_dev_event handler, ignore tlsdev_ops requirement for bond
interfaces, they do not exist as the interaction is done directly with
the lower device.

Also, make the validate function pass when it's called with the upper
bond interface.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 net/tls/tls_device.c          | 2 ++
 net/tls/tls_device_fallback.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

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
index d946817ed065..cacf040872c7 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -424,7 +424,7 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 				      struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	if (dev == tls_get_ctx(sk)->netdev)
+	if (dev == tls_get_ctx(sk)->netdev || netif_is_bond_master(dev))
 		return skb;
 
 	return tls_sw_fallback(sk, skb);
-- 
2.21.0

