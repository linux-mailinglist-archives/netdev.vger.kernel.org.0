Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C4652E25F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbiETCNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiETCNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F0D1059EE
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 19:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0598B828CA
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CECEC385B8;
        Fri, 20 May 2022 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653012829;
        bh=eRS656suuaumWRTJSpax4Si4hP+wmh8CSmnrlI3XSE8=;
        h=From:To:Cc:Subject:Date:From;
        b=DRjpoEemQJZhbS1BRcCTgUT4xFTHzcll7EvOAsb2BszPBmXghNYMoZ6AotAhOmuRW
         dk3LwvWY3fO3TIk99gJzOqrSUTJOkGYklr9DWJJy0RZXvPL4i10xLZoxEcx390nlQ6
         gqvjeGxKQX0iocGUNsx11GjgtpzpH41XnynQL1iLLWXfvwORwAD4wd0VErdCQJ5Zkv
         0LshbIa7oP8LHT8aeEJNcA8f59P1v/EPWMHFxQGg/CKyMn3QiNrYKmhDFdDZAVcCzW
         Ho12nGHFcCRMHF4HR8aVsxc5/3yXvXnDlitcpy1m+/hOhUQpOLV+9PpF3W0roFNneT
         23XiXjqmO0feQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, flyingpeng@tencent.com, imagedong@tencent.com,
        benbjiang@tencent.com
Subject: [PATCH net-next] tcp_ipv6: set the drop_reason in the right place
Date:   Thu, 19 May 2022 19:13:47 -0700
Message-Id: <20220520021347.2270207-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like the IPv6 version of the patch under Fixes was
a copy/paste of the IPv4 but hit the wrong spot.
It is tcp_v6_rcv() which uses drop_reason as a boolean, and
needs to be protected against reason == 0 before calling free.
tcp_v6_do_rcv() has a pretty straightforward flow.

Fixes: f8319dfd1b3b ("net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: yoshfuji@linux-ipv6.org
CC: dsahern@kernel.org
CC: flyingpeng@tencent.com
CC: imagedong@tencent.com
CC: benbjiang@tencent.com
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 28e47ca1e26d..f37dd4aa91c6 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1509,7 +1509,6 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 discard:
 	if (opt_skb)
 		__kfree_skb(opt_skb);
-	SKB_DR_OR(reason, NOT_SPECIFIED);
 	kfree_skb_reason(skb, reason);
 	return 0;
 csum_err:
@@ -1763,6 +1762,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	}
 
 discard_it:
+	SKB_DR_OR(drop_reason, NOT_SPECIFIED);
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
-- 
2.34.3

