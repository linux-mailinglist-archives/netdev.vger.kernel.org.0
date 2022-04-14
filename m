Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A65003E9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 03:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiDNCBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 22:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiDNCBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 22:01:34 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EB5E326F3;
        Wed, 13 Apr 2022 18:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0HLUY
        /xCiurn6rc3fSoQtal9tLcyYz3af3bsJdpjOxg=; b=msXBodO8I4J4vb1EkRIv0
        lO8QOohoWdKUsUMXbm3uNUyb3tBQyXrJjoGhq8bTCPFpgM0qkjQq1VjgrmcqY5Zw
        i+ksZov7UOUIoyfunGlIRlN0XY7u6zjlMxdTWfKH7vDtXBfQ+uIKouiVkhyJwLJM
        GF0D0G7fGXcX+Mu9JyUOCM=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp7 (Coremail) with SMTP id DsmowADHlfG2f1di0jytAQ--.55055S2;
        Thu, 14 Apr 2022 09:58:14 +0800 (CST)
From:   Hongbin Wang <wh_bin@126.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] tcp: fix error return code in tcp_xmit_probe_skb
Date:   Wed, 13 Apr 2022 21:58:02 -0400
Message-Id: <20220414015802.101877-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowADHlfG2f1di0jytAQ--.55055S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr4xKr1xur1DAF4xXrWkZwb_yoWxCFb_Cw
        nrXayjq3y5tFn2vwsrZw45JryrKanFvFyFgr13Ca43ta4UGFn8Jrs7Cr93CFn3ursakryD
        Kr4Dtry8urW3XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0C4iUUUUUU==
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbiOhfioluvn+sadwAAsA
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When alloc_skb failed, should return ENOMEM

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c221f3bce975..b97c85814d9c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3996,7 +3996,7 @@ static int tcp_xmit_probe_skb(struct sock *sk, int urgent, int mib)
 	skb = alloc_skb(MAX_TCP_HEADER,
 			sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
 	if (!skb)
-		return -1;
+		return -ENOMEM;
 
 	/* Reserve space for headers and set control bits. */
 	skb_reserve(skb, MAX_TCP_HEADER);
-- 
2.25.1

