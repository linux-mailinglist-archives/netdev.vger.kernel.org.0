Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E1841F95F
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 04:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhJBC25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 22:28:57 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33964 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhJBC2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 22:28:55 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 5717E20272; Sat,  2 Oct 2021 10:27:06 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 2/2] mctp: test: defer mdev setup until we've registered
Date:   Sat,  2 Oct 2021 10:26:56 +0800
Message-Id: <20211002022656.1681956-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002022656.1681956-1-jk@codeconstruct.com.au>
References: <20211002022656.1681956-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MCTP device isn't available until we've registered the netdev, so
defer storing our convenience pointer.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/utils.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mctp/test/utils.c b/net/mctp/test/utils.c
index e2ab1f3da357..cc6b8803aa9d 100644
--- a/net/mctp/test/utils.c
+++ b/net/mctp/test/utils.c
@@ -46,17 +46,17 @@ struct mctp_test_dev *mctp_test_create_dev(void)
 	dev = netdev_priv(ndev);
 	dev->ndev = ndev;
 
-	rcu_read_lock();
-	dev->mdev = __mctp_dev_get(ndev);
-	mctp_dev_hold(dev->mdev);
-	rcu_read_unlock();
-
 	rc = register_netdev(ndev);
 	if (rc) {
 		free_netdev(ndev);
 		return NULL;
 	}
 
+	rcu_read_lock();
+	dev->mdev = __mctp_dev_get(ndev);
+	mctp_dev_hold(dev->mdev);
+	rcu_read_unlock();
+
 	return dev;
 }
 
-- 
2.30.2

