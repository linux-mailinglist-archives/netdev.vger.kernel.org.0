Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4F71B0890
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgDTL6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:58:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2412 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726902AbgDTL6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:58:01 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 76A779186AD4605649F2;
        Mon, 20 Apr 2020 19:57:58 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 19:57:48 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Eric Dumazet <edumazet@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next] macvlan: silence RCU list debugging warning
Date:   Mon, 20 Apr 2020 19:59:30 +0800
Message-ID: <20200420115930.135509-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

macvlan_hash_lookup() uses list_for_each_entry_rcu() for traversing
outside of an RCU read side critical section but under the protection
of rtnl_mutex. Hence, add the corresponding lockdep expression to
silence the following false-positive warning:

=============================
WARNING: suspicious RCU usage
5.7.0-rc1-next-20200416-00003-ga3b8d28bc #1 Not tainted
-----------------------------
drivers/net/macvlan.c:126 RCU-list traversed in non-reader section!!

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/macvlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e7289d67268f..654c1fa11826 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -123,7 +123,8 @@ static struct macvlan_dev *macvlan_hash_lookup(const struct macvlan_port *port,
 	struct macvlan_dev *vlan;
 	u32 idx = macvlan_eth_hash(addr);
 
-	hlist_for_each_entry_rcu(vlan, &port->vlan_hash[idx], hlist) {
+	hlist_for_each_entry_rcu(vlan, &port->vlan_hash[idx], hlist,
+				 lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(vlan->dev->dev_addr, addr))
 			return vlan;
 	}
-- 
2.17.1

