Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7BA63D565
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiK3MTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiK3MTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:19:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1415C21E29;
        Wed, 30 Nov 2022 04:19:41 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/4] netfilter: conntrack: fix using __this_cpu_add in preemptible
Date:   Wed, 30 Nov 2022 13:19:33 +0100
Message-Id: <20221130121934.1125-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130121934.1125-1-pablo@netfilter.org>
References: <20221130121934.1125-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

Currently in nf_conntrack_hash_check_insert(), when it fails in
nf_ct_ext_valid_pre/post(), NF_CT_STAT_INC() will be called in the
preemptible context, a call trace can be triggered:

   BUG: using __this_cpu_add() in preemptible [00000000] code: conntrack/1636
   caller is nf_conntrack_hash_check_insert+0x45/0x430 [nf_conntrack]
   Call Trace:
    <TASK>
    dump_stack_lvl+0x33/0x46
    check_preemption_disabled+0xc3/0xf0
    nf_conntrack_hash_check_insert+0x45/0x430 [nf_conntrack]
    ctnetlink_create_conntrack+0x3cd/0x4e0 [nf_conntrack_netlink]
    ctnetlink_new_conntrack+0x1c0/0x450 [nf_conntrack_netlink]
    nfnetlink_rcv_msg+0x277/0x2f0 [nfnetlink]
    netlink_rcv_skb+0x50/0x100
    nfnetlink_rcv+0x65/0x144 [nfnetlink]
    netlink_unicast+0x1ae/0x290
    netlink_sendmsg+0x257/0x4f0
    sock_sendmsg+0x5f/0x70

This patch is to fix it by changing to use NF_CT_STAT_INC_ATOMIC() for
nf_ct_ext_valid_pre/post() check in nf_conntrack_hash_check_insert(),
as well as nf_ct_ext_valid_post() in __nf_conntrack_confirm().

Note that nf_ct_ext_valid_pre() check in __nf_conntrack_confirm() is
safe to use NF_CT_STAT_INC(), as it's under local_bh_disable().

Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2692139ce417..23b3fedd619a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -891,7 +891,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	zone = nf_ct_zone(ct);
 
 	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC(net, insert_failed);
+		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
 		return -ETIMEDOUT;
 	}
 
@@ -938,7 +938,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return -ETIMEDOUT;
 	}
 
@@ -1275,7 +1275,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 */
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return NF_DROP;
 	}
 
-- 
2.30.2

