Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC091224405
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgGQTMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:12:44 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:22978 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgGQTMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:12:44 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06HJCQuo018261;
        Fri, 17 Jul 2020 12:12:27 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     borisp@mellanox.com, daniel@iogearbox.net, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net v2] crypto/chtls: correct net_device reference count
Date:   Sat, 18 Jul 2020 00:41:07 +0530
Message-Id: <20200717191106.1488-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_dev_find() call holds net_device reference which is not needed,
use __ip_dev_find() which does not hold reference.

v1->v2:
- Correct submission tree.
- Add fixes tag.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index e271fd37cf40..9cc1376b174d 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -100,7 +100,7 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 	case PF_INET:
 		if (likely(!inet_sk(sk)->inet_rcv_saddr))
 			return ndev;
-		ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
+		ndev = __ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr, false);
 		break;
 	case PF_INET6:
 		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
-- 
2.18.1

