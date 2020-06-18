Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4F11FF2F4
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgFRNZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:25:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43514 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728049AbgFRNZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 09:25:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CFA8533519274ED6305F;
        Thu, 18 Jun 2020 21:25:20 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 18 Jun 2020
 21:25:12 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <michael-dev@fami-braun.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <zhengbin13@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH -next] macvlan: Fix memleak in macvlan_changelink_sources
Date:   Thu, 18 Jun 2020 21:26:29 +0800
Message-ID: <20200618132629.659977-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

macvlan_changelink_sources
  if (addr)
    ret = macvlan_hash_add_source(vlan, addr)
  nla_for_each_attr(nla, head, len, rem)
    ret = macvlan_hash_add_source(vlan, addr)
    -->If fail, need to free previous malloc memory

Fixes: 79cf79abce71 ("macvlan: add source mode")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/macvlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6a6cc9f75307..0017c5d28a27 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1379,8 +1379,10 @@ static int macvlan_changelink_sources(struct macvlan_dev *vlan, u32 mode,

 			addr = nla_data(nla);
 			ret = macvlan_hash_add_source(vlan, addr);
-			if (ret)
+			if (ret) {
+				macvlan_flush_sources(vlan->port, vlan);
 				return ret;
+			}
 		}
 	} else {
 		return -EINVAL;
--
2.25.4

