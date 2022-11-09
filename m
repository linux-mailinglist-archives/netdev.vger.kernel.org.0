Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07759622A7F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiKIL2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiKIL2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:28:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CA3C113A;
        Wed,  9 Nov 2022 03:28:30 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/3] netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()
Date:   Wed,  9 Nov 2022 12:28:18 +0100
Message-Id: <20221109112820.206807-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221109112820.206807-1-pablo@netfilter.org>
References: <20221109112820.206807-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

When type is NFNL_CB_MUTEX and -EAGAIN error occur in nfnetlink_rcv_msg(),
it does not execute nfnl_unlock(). That would trigger potential dead lock.

Fixes: 50f2db9e368f ("netfilter: nfnetlink: consolidate callback types")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 9c44518cb70f..6d18fb346868 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -294,6 +294,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			nfnl_lock(subsys_id);
 			if (nfnl_dereference_protected(subsys_id) != ss ||
 			    nfnetlink_find_client(type, ss) != nc) {
+				nfnl_unlock(subsys_id);
 				err = -EAGAIN;
 				break;
 			}
-- 
2.30.2

