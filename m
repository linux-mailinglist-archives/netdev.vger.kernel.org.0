Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434942FF519
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbhAUTuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:50:23 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:34900 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbhAUTtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 14:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=DCQNuATp1OYUDQRh6i
        JYi/PlkzzDX7MrFZdp4K62XsI=; b=IkI3+XC7CjjnQT+I7OFNWb/umvDEkz8nhO
        PLBe0UCOIwbUBecjdcaZ/Rt/d+wCTntLbr5jov9e/cg6likD4errYIQLzF28duOl
        7Q+T9GPRvcPuqZq6FEIp5BgeDAaNTsTId/0Nmv4i/utDIsViyfGyDUCYvPJfTrKe
        l5bT/yXEY=
Received: from localhost.localdomain (unknown [111.201.134.89])
        by smtp4 (Coremail) with SMTP id HNxpCgDXYRBqlglg4ixihA--.16912S4;
        Thu, 21 Jan 2021 22:57:49 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] chtls: Fix potential resource leak
Date:   Thu, 21 Jan 2021 06:57:38 -0800
Message-Id: <20210121145738.51091-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HNxpCgDXYRBqlglg4ixihA--.16912S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrur15WryrtF1UWry3ury5CFg_yoWkKwc_Cr
        W7uF10gw4jvr1F9w4jgr45WFyYk395Xr95Xr1xtFy5Z3W7Kr4UZFyxCFy3Wr1Uuw47CasI
        kwnrJFn5A34I9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUXo2UUUUUU==
X-Originating-IP: [111.201.134.89]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBzw0hclaD9zXeSgAAsS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dst entry should be released if no neighbour is found. Goto label
free_dst to fix the issue. Besides, the check of ndev against NULL is
redundant.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index e5cfbe196ba6..19dc7dc054a2 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1158,11 +1158,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 #endif
 	}
 	if (!n || !n->dev)
-		goto free_sk;
+		goto free_dst;
 
 	ndev = n->dev;
-	if (!ndev)
-		goto free_dst;
 	if (is_vlan_dev(ndev))
 		ndev = vlan_dev_real_dev(ndev);
 
@@ -1250,7 +1248,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 free_csk:
 	chtls_sock_release(&csk->kref);
 free_dst:
-	neigh_release(n);
+	if (n)
+		neigh_release(n);
 	dst_release(dst);
 free_sk:
 	inet_csk_prepare_forced_close(newsk);
-- 
2.17.1

