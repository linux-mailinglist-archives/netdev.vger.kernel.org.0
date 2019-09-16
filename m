Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2658DB3BD8
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbfIPNxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:53:30 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:60783 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733036AbfIPNxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:53:30 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9254F41611;
        Mon, 16 Sep 2019 21:53:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     jiri@resnulli.us
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net v2] net/sched: cls_api: Fix nooffloaddevcnt counter when indr block call success
Date:   Mon, 16 Sep 2019 21:53:24 +0800
Message-Id: <1568642004-3150-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSE1LS0tKS0NMSkNDTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PQw6ODo4ITg0AysJTC0iCC0B
        CE0aCUxVSlVKTk1DTU9JS0tPTUNNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9LQ0I3Bg++
X-HM-Tid: 0a6d3a5976832086kuqy9254f41611
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

A vxlan or gretap device offload through indr block methord. If the device
successfully bind with a real hw through indr block call, It also add
nooffloadcnt counter. This counter will lead the rule add failed in
fl_hw_replace_filter-->tc_setup_cb_call with skip_sw flags.

In the tc_setup_cb_call will check the nooffloaddevcnt and skip_sw flags
as following:
if (block->nooffloaddevcnt && err_stop)
	return -EOPNOTSUPP;

So with this patch, if the indr block call success, it will not modify
the nooffloaddevcnt counter.

Fixes: 7f76fa36754b ("net: sched: register callbacks for indirect tc block binds")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_api.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index efd3cfb..8a1e3a5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -766,10 +766,10 @@ void tc_indr_block_cb_unregister(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
 
-static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
-			       struct tcf_block_ext_info *ei,
-			       enum flow_block_command command,
-			       struct netlink_ext_ack *extack)
+static int tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
+			      struct tcf_block_ext_info *ei,
+			      enum flow_block_command command,
+			      struct netlink_ext_ack *extack)
 {
 	struct tc_indr_block_cb *indr_block_cb;
 	struct tc_indr_block_dev *indr_dev;
@@ -785,7 +785,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 
 	indr_dev = tc_indr_block_dev_lookup(dev);
 	if (!indr_dev)
-		return;
+		return -ENOENT;
 
 	indr_dev->block = command == FLOW_BLOCK_BIND ? block : NULL;
 
@@ -793,7 +793,10 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 				  &bo);
 
-	tcf_block_setup(block, &bo);
+	if (list_empty(&bo.cb_list))
+		return -EOPNOTSUPP;
+
+	return tcf_block_setup(block, &bo);
 }
 
 static bool tcf_block_offload_in_use(struct tcf_block *block)
@@ -849,14 +852,14 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	if (err)
 		return err;
 
-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
 	return 0;
 
 no_offload_dev_inc:
 	if (tcf_block_offload_in_use(block))
 		return -EOPNOTSUPP;
-	block->nooffloaddevcnt++;
-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
+	err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
+	if (err)
+		block->nooffloaddevcnt++;
 	return 0;
 }
 
@@ -866,8 +869,6 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	struct net_device *dev = q->dev_queue->dev;
 	int err;
 
-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
-
 	if (!dev->netdev_ops->ndo_setup_tc)
 		goto no_offload_dev_dec;
 	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
@@ -876,7 +877,9 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	return;
 
 no_offload_dev_dec:
-	WARN_ON(block->nooffloaddevcnt-- == 0);
+	err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
+	if (err)
+		WARN_ON(block->nooffloaddevcnt-- == 0);
 }
 
 static int
-- 
1.8.3.1

