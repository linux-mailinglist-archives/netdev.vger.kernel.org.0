Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501592F68C9
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbhANSCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:02:45 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57098 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729679AbhANSCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:02:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 14 Jan 2021 20:01:52 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EI1pYP001704;
        Thu, 14 Jan 2021 20:01:52 +0200
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
Subject: [PATCH net-next V2 7/8] net/tls: Device offload to use lowest netdevice in chain
Date:   Thu, 14 Jan 2021 20:01:34 +0200
Message-Id: <20210114180135.11556-8-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210114180135.11556-1-tariqt@nvidia.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not call the tls_dev_ops of upper devices. Instead, ask them
for the proper slave and communicate with it directly.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
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

