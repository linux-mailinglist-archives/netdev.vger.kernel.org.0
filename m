Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947F328A56D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 06:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJKEVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 00:21:50 -0400
Received: from smtp.h3c.com ([60.191.123.56]:24772 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgJKEVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 00:21:49 -0400
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([10.8.0.66])
        by h3cspam01-ex.h3c.com with ESMTPS id 09B4LGgD040947
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 11 Oct 2020 12:21:16 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from localhost.localdomain (10.99.212.201) by
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 11 Oct 2020 12:21:18 +0800
From:   Xianting Tian <tian.xianting@h3c.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xianting Tian <tian.xianting@h3c.com>
Subject: [PATCH] net: Avoid allocing memory on memoryless numa node
Date:   Sun, 11 Oct 2020 12:11:40 +0800
Message-ID: <20201011041140.8945-1-tian.xianting@h3c.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.99.212.201]
X-ClientProxiedBy: BJSMTP02-EX.srv.huawei-3com.com (10.63.20.133) To
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66)
X-DNSRBL: 
X-MAIL: h3cspam01-ex.h3c.com 09B4LGgD040947
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In architecture like powerpc, we can have cpus without any local memory
attached to it. In such cases the node does not have real memory.

Use local_memory_node(), which is guaranteed to have memory.
local_memory_node is a noop in other architectures that does not support
memoryless nodes.

Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 266073e30..dcb4533ef 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2590,7 +2590,7 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
 		new_map = kzalloc(XPS_MAP_SIZE(alloc_len), GFP_KERNEL);
 	else
 		new_map = kzalloc_node(XPS_MAP_SIZE(alloc_len), GFP_KERNEL,
-				       cpu_to_node(attr_index));
+				       local_memory_node(cpu_to_node(attr_index)));
 	if (!new_map)
 		return NULL;
 
-- 
2.17.1

