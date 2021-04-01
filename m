Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A401C350E44
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 06:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhDAExd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 00:53:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15060 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDAExH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 00:53:07 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F9rN16404zNrLr;
        Thu,  1 Apr 2021 12:50:25 +0800 (CST)
Received: from localhost (10.174.242.151) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Thu, 1 Apr 2021
 12:52:55 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <chenchanghu@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] net: cls_api: Fix uninitialised struct field bo->unlocked_driver_cb
Date:   Thu, 1 Apr 2021 12:52:48 +0800
Message-ID: <1617252768-19320-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.151]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The 'unlocked_driver_cb' struct field in 'bo' is not being initialized
in tcf_block_offload_init(). The uninitialized 'unlocked_driver_cb'
will be used when calling unlocked_driver_cb(). So initialize 'bo' to
zero to avoid the issue.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 13341e7fb077..9332ec6863e8 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -646,7 +646,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 	struct net_device *dev = block_cb->indr.dev;
 	struct Qdisc *sch = block_cb->indr.sch;
 	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo;
+	struct flow_block_offload bo = {};
 
 	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
 			       block_cb->indr.binder_type,
-- 
2.23.0

