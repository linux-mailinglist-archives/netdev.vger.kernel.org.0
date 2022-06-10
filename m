Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE54545B83
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbiFJFQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiFJFQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:16:45 -0400
Received: from smtp.ruc.edu.cn (m177126.mail.qiye.163.com [123.58.177.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9307765C;
        Thu,  9 Jun 2022 22:16:40 -0700 (PDT)
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp.ruc.edu.cn (Hmail) with ESMTPSA id 337D98009D;
        Fri, 10 Jun 2022 13:16:38 +0800 (CST)
From:   Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
To:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] l2tp: fix possible use-after-free
Date:   Fri, 10 Jun 2022 13:16:33 +0800
Message-Id: <20220610051633.8582-1-xiaohuizhang@ruc.edu.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWUJOT05WTEgZQ05CSUwfGR
        9JVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pgw6Syo*Cj00HwoBEAJNLRxN
        HyIaCjdVSlVKTU5PQ0hDSkJCS0lJVTMWGhIXVQMSGhQTDhIBExoVHDsJDhhVHh8OVRgVRVlXWRIL
        WUFZSUtJVUpKSVVKSkhVSUpJWVdZCAFZQUhOQ0o3Bg++
X-HM-Tid: 0a814c0b01282c20kusn337d98009d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the handling of l2tp_tunnel_get in commit a622b40035d1
("l2ip: fix possible use-after-free"), we thought a patch might
be needed here as well.

Before taking a refcount on a rcu protected structure,
we need to make sure the refcount is not zero.

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
---
 net/l2tp/l2tp_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7499c51b1850..96e8966f900d 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -252,8 +252,8 @@ struct l2tp_session *l2tp_tunnel_get_session(struct l2tp_tunnel *tunnel,
 
 	rcu_read_lock_bh();
 	hlist_for_each_entry_rcu(session, session_list, hlist)
-		if (session->session_id == session_id) {
-			l2tp_session_inc_refcount(session);
+		if (session->session_id == session_id &&
+		    refcount_inc_not_zero(&session->ref_count)) {
 			rcu_read_unlock_bh();
 
 			return session;
@@ -273,8 +273,8 @@ struct l2tp_session *l2tp_session_get(const struct net *net, u32 session_id)
 
 	rcu_read_lock_bh();
 	hlist_for_each_entry_rcu(session, session_list, global_hlist)
-		if (session->session_id == session_id) {
-			l2tp_session_inc_refcount(session);
+		if (session->session_id == session_id &&
+		    refcount_inc_not_zero(&session->ref_count)) {
 			rcu_read_unlock_bh();
 
 			return session;
@@ -294,8 +294,8 @@ struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth)
 	rcu_read_lock_bh();
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
 		hlist_for_each_entry_rcu(session, &tunnel->session_hlist[hash], hlist) {
-			if (++count > nth) {
-				l2tp_session_inc_refcount(session);
+			if (++count > nth &&
+			    refcount_inc_not_zero(&session->ref_count)) {
 				rcu_read_unlock_bh();
 				return session;
 			}
@@ -321,8 +321,8 @@ struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
 	rcu_read_lock_bh();
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++) {
 		hlist_for_each_entry_rcu(session, &pn->l2tp_session_hlist[hash], global_hlist) {
-			if (!strcmp(session->ifname, ifname)) {
-				l2tp_session_inc_refcount(session);
+			if (!strcmp(session->ifname, ifname) &&
+			    refcount_inc_not_zero(&session->ref_count)) {
 				rcu_read_unlock_bh();
 
 				return session;
-- 
2.17.1

