Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA845B6D9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfGAI3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:29:24 -0400
Received: from mx140-tc.baidu.com ([61.135.168.140]:47198 "EHLO
        tc-sys-mailedm03.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727243AbfGAI3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 04:29:24 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm03.tc.baidu.com (Postfix) with ESMTP id A1ACA450003E
        for <netdev@vger.kernel.org>; Mon,  1 Jul 2019 16:29:07 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH] xfrm: use list_for_each_entry_safe in xfrm_policy_flush
Date:   Mon,  1 Jul 2019 16:29:07 +0800
Message-Id: <1561969747-8629-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iterated pol maybe be freed since it is not protected
by RCU or spinlock when put it, lead to UAF, so use _safe
function to iterate over it against removal

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 3235562f6588..87d770dab1f5 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1772,7 +1772,7 @@ xfrm_policy_flush_secctx_check(struct net *net, u8 type, bool task_valid)
 int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
 {
 	int dir, err = 0, cnt = 0;
-	struct xfrm_policy *pol;
+	struct xfrm_policy *pol, *tmp;
 
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 
@@ -1781,7 +1781,7 @@ int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
 		goto out;
 
 again:
-	list_for_each_entry(pol, &net->xfrm.policy_all, walk.all) {
+	list_for_each_entry_safe(pol, tmp, &net->xfrm.policy_all, walk.all) {
 		dir = xfrm_policy_id2dir(pol->index);
 		if (pol->walk.dead ||
 		    dir >= XFRM_POLICY_MAX ||
-- 
2.16.2

