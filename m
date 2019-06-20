Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB9A4CCDB
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 13:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731566AbfFTLYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 07:24:54 -0400
Received: from mx59.baidu.com ([61.135.168.59]:55823 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726392AbfFTLYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 07:24:53 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 118FC11C0059;
        Thu, 20 Jun 2019 19:24:41 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Subject: [PATCH][net-next] netns: restore ops before calling ops_exit_list
Date:   Thu, 20 Jun 2019 19:24:40 +0800
Message-Id: <1561029880-1666-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ops has been iterated to first element when call pre_exit, and
it needs to restore from save_ops, not save ops to save_ops

Fixes: d7d99872c144 ("netns: add pre_exit method to struct pernet_operations")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/net_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 89dc99a28978..198ce503ae73 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -345,7 +345,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 
 	synchronize_rcu();
 
-	saved_ops = ops;
+	ops = saved_ops;
 	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
 		ops_exit_list(ops, &net_exit_list);
 
-- 
2.16.2

