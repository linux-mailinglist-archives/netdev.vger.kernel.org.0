Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B584C418824
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 12:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhIZKum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 06:50:42 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:23953 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhIZKuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 06:50:35 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HHMpf11mPzbmp8;
        Sun, 26 Sep 2021 18:44:42 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Sun, 26 Sep 2021 18:48:56 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <robin@protonic.nl>
CC:     <linux@rempel-privat.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] can: j1939: fix UAF for rx_kref of j1939_priv
Date:   Sun, 26 Sep 2021 18:47:57 +0800
Message-ID: <20210926104757.2021540-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will trigger UAF for rx_kref of j1939_priv as following.

        cpu0                                    cpu1
j1939_sk_bind(socket0, ndev0, ...)
j1939_netdev_start
                                        j1939_sk_bind(socket1, ndev0, ...)
                                        j1939_netdev_start
j1939_priv_set
                                        j1939_priv_get_by_ndev_locked
j1939_jsk_add
.....
j1939_netdev_stop
kref_put_lock(&priv->rx_kref, ...)
                                        kref_get(&priv->rx_kref, ...)
                                        REFCOUNT_WARN("addition on 0;...")

====================================================
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 20874 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0
RIP: 0010:refcount_warn_saturate+0x169/0x1e0
Call Trace:
 j1939_netdev_start+0x68b/0x920
 j1939_sk_bind+0x426/0xeb0
 ? security_socket_bind+0x83/0xb0

The rx_kref's kref_get() and kref_put() should use j1939_netdev_lock to
protect.

Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
Reported-by: syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/j1939/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 08c8606cfd9c..9bc55ecb37f9 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -249,11 +249,14 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
 	struct j1939_priv *priv, *priv_new;
 	int ret;
 
-	priv = j1939_priv_get_by_ndev(ndev);
+	spin_lock(&j1939_netdev_lock);
+	priv = j1939_priv_get_by_ndev_locked(ndev);
 	if (priv) {
 		kref_get(&priv->rx_kref);
+		spin_unlock(&j1939_netdev_lock);
 		return priv;
 	}
+	spin_unlock(&j1939_netdev_lock);
 
 	priv = j1939_priv_create(ndev);
 	if (!priv)
@@ -269,10 +272,10 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
 		/* Someone was faster than us, use their priv and roll
 		 * back our's.
 		 */
+		kref_get(&priv_new->rx_kref);
 		spin_unlock(&j1939_netdev_lock);
 		dev_put(ndev);
 		kfree(priv);
-		kref_get(&priv_new->rx_kref);
 		return priv_new;
 	}
 	j1939_priv_set(ndev, priv);
-- 
2.25.1

