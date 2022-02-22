Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9264BF0EE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiBVEaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 23:30:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiBVEaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 23:30:13 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBB117078
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 20:29:45 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 61C8B202A4; Tue, 22 Feb 2022 12:29:43 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next] mctp: Fix warnings reported by clang-analyzer
Date:   Tue, 22 Feb 2022 12:29:36 +0800
Message-Id: <20220222042936.516874-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/mctp/device.c:140:11: warning: Assigned value is garbage or undefined
[clang-analyzer-core.uninitialized.Assign]
        mcb->idx = idx;

- Not a real problem due to how the callback runs, fix the warning.

net/mctp/route.c:458:4: warning: Value stored to 'msk' is never read
[clang-analyzer-deadcode.DeadStores]
        msk = container_of(key->sk, struct mctp_sock, sk);

- 'msk' dead assignment can be removed here.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/device.c | 2 +-
 net/mctp/route.c  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 9e097e61f23a..224f067e9d4c 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -107,7 +107,7 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	struct ifaddrmsg *hdr;
 	struct mctp_dev *mdev;
 	int ifindex;
-	int idx, rc;
+	int idx = 0, rc;
 
 	hdr = nlmsg_data(cb->nlh);
 	// filter by ifindex if requested
diff --git a/net/mctp/route.c b/net/mctp/route.c
index fe6c8bf1ec2c..85acfcbabd9c 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -456,7 +456,6 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		 * the reassembly/response key
 		 */
 		if (!rc && flags & MCTP_HDR_FLAG_EOM) {
-			msk = container_of(key->sk, struct mctp_sock, sk);
 			sock_queue_rcv_skb(key->sk, key->reasm_head);
 			key->reasm_head = NULL;
 			__mctp_key_done_in(key, net, f, MCTP_TRACE_KEY_REPLIED);
-- 
2.32.0

