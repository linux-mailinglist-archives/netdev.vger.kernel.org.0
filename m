Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6CF2E77D3
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 11:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgL3KjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 05:39:13 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10012 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgL3KjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 05:39:12 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D5SR908sGzj1G8;
        Wed, 30 Dec 2020 18:37:41 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Wed, 30 Dec 2020
 18:38:20 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] macvlan: fix null pointer dereference in macvlan_changelink_sources()
Date:   Wed, 30 Dec 2020 18:38:15 +0800
Message-ID: <1609324695-1516-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently pointer data is dereferenced when declaring addr before
pointer data is null checked. This could lead to a null pointer
dereference. Fix this by checking if pointer data is null first.

Fixes: 79cf79abce71 ("macvlan: add source mode")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index fb51329f8964..e412fd6b6798 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1356,7 +1356,7 @@ static int macvlan_changelink_sources(struct macvlan_dev *vlan, u32 mode,
 	struct nlattr *nla, *head;
 	struct macvlan_source_entry *entry;
 
-	if (data[IFLA_MACVLAN_MACADDR])
+	if (data && data[IFLA_MACVLAN_MACADDR])
 		addr = nla_data(data[IFLA_MACVLAN_MACADDR]);
 
 	if (mode == MACVLAN_MACADDR_ADD) {
-- 
2.23.0

