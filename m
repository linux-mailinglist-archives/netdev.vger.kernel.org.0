Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FE5607BB0
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiJUQDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJUQDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:03:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A18263B4F;
        Fri, 21 Oct 2022 09:03:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D80ECCE28F3;
        Fri, 21 Oct 2022 16:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4926C433D7;
        Fri, 21 Oct 2022 16:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666368189;
        bh=mjKnHfLQjBlbvgpLol/1LWK9s0GkVbW/aDGXHQEartA=;
        h=From:To:Cc:Subject:Date:From;
        b=XwJkqipGOdIzv7igVzFUFb0oRs0SN7Oy/WNGfjSG7Nyufm4DwZbVC8uVwdaiT0QbV
         HSvXPxYzFs0wTZ53rAeJzTn90EyU4h0pBxrE58kmtE1x0b0sgEo5i08Jsd6rXDYbTI
         2ryzmWiShlJjaKfopjbGSkkbFlk82w1AGiN/CrA/pEeehc3DHDdZ1/z7wMmRFamxJ7
         UY3J49us43UayMH8+uo5hXHFlUYWJ0aLfke8c52A0co7OHmAH6IzGdaer30GdKIfGd
         QgT+deK1VRhkWBpIaLqCv75oVS3Q1LxCT4HKbmPfI6MieWIJLtBytUBrWD30NFEGjR
         T+PCH4ctByqxQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        cgroups@vger.kernel.org, roman.gushchin@linux.dev,
        Jakub Kicinski <kuba@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, weiwan@google.com,
        ncardwell@google.com, ycheng@google.com
Subject: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date:   Fri, 21 Oct 2022 09:03:04 -0700
Message-Id: <20221021160304.1362511-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Shakeel explains the commit under Fixes had the unintended
side-effect of no longer pre-loading the cached memory allowance.
Even tho we previously dropped the first packet received when
over memory limit - the consecutive ones would get thru by using
the cache. The charging was happening in batches of 128kB, so
we'd let in 128kB (truesize) worth of packets per one drop.

After the change we no longer force charge, there will be no
cache filling side effects. This causes significant drops and
connection stalls for workloads which use a lot of page cache,
since we can't reclaim page cache under GFP_NOWAIT.

Some of the latency can be recovered by improving SACK reneg
handling but nowhere near enough to get back to the pre-5.15
performance (the application I'm experimenting with still
sees 5-10x worst latency).

Apply the suggested workaround of using GFP_ATOMIC. We will now
be more permissive than previously as we'll drop _no_ packets
in softirq when under pressure. But I can't think of any good
and simple way to address that within networking.

Link: https://lore.kernel.org/all/20221012163300.795e7b86@kernel.org/
Suggested-by: Shakeel Butt <shakeelb@google.com>
Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: weiwan@google.com
CC: shakeelb@google.com
CC: ncardwell@google.com
CC: ycheng@google.com
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9e464f6409a7..22f8bab583dd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2585,7 +2585,7 @@ static inline gfp_t gfp_any(void)
 
 static inline gfp_t gfp_memcg_charge(void)
 {
-	return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
+	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
 }
 
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
-- 
2.37.3

