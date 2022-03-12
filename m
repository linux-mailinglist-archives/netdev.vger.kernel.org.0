Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D61F4D7005
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 17:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiCLQ4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 11:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiCLQ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 11:56:07 -0500
X-Greylist: delayed 1594 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Mar 2022 08:55:00 PST
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF5E5E771;
        Sat, 12 Mar 2022 08:55:00 -0800 (PST)
Received: from excmbx-17.um.gwdg.de ([134.76.9.228] helo=email.gwdg.de)
        by mailer.gwdg.de with esmtp (GWDG Mailer)
        (envelope-from <alexander.vorwerk@stud.uni-goettingen.de>)
        id 1nT4bM-0008G0-Sr; Sat, 12 Mar 2022 17:28:20 +0100
Received: from notebook.fritz.box (10.250.9.199) by excmbx-17.um.gwdg.de
 (134.76.9.228) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2375.24; Sat, 12
 Mar 2022 17:28:19 +0100
From:   Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Subject: [PATCH] net: ipv4: tcp.c: fix an assignment in an if condition
Date:   Sat, 12 Mar 2022 17:27:44 +0100
Message-ID: <20220312162744.32318-1-alexander.vorwerk@stud.uni-goettingen.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.250.9.199]
X-ClientProxiedBy: excmbx-28.um.gwdg.de (134.76.9.201) To excmbx-17.um.gwdg.de
 (134.76.9.228)
X-Virus-Scanned: (clean) by clamav
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reported by checkpatch.pl

Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
---
 net/ipv4/tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 28ff2a820f7c..7fa6e7e6ea80 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -959,10 +959,10 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool can_coalesce;
-	int copy, i;
+	int copy = size_goal - skb->len;
+	int i;
 
-	if (!skb || (copy = size_goal - skb->len) <= 0 ||
-	    !tcp_skb_can_collapse_to(skb)) {
+	if (!skb || copy <= 0 || !tcp_skb_can_collapse_to(skb)) {
 new_segment:
 		if (!sk_stream_memory_free(sk))
 			return NULL;
-- 
2.17.1

