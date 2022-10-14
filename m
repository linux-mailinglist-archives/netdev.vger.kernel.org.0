Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54FE5FF206
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiJNQH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJNQHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:07:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6E31B76E3
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40D8BB8220F
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 16:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3020C433C1;
        Fri, 14 Oct 2022 16:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665763672;
        bh=7daPzmMue2tqbCI7t67urpE0u2pW43vHLYs69uoz9AU=;
        h=From:To:Cc:Subject:Date:From;
        b=TnzzAg/3AOCf9NkSK7GvnYf3RJZYvZoKDVteyD9y8U+zhRwO9a8gYtbFjCnATCa2n
         hG3DQ9Nw/9c3YTDrhQhk/OU0eA4AgUs/aSTeC0C5wWbXBYpsbQHSANbtMfidGFHl4b
         tavN55NXCLsgBeCTS88KW6wUS98FyEtm19/Vl1NjDGINQJROJP4PAhuBpV1RuAQm73
         1XBN75NXr3W9PM4+dMojlcDO9uA5Cm4w4FLBwDrK6ANpnMV4++mWME8BbJyaO0YpYp
         ewN8brNCe4USUkfcwE7D3RdyvtKKhdO1onEjYmb6XU1uK9uzveO1mgts1kDbJt4hQ+
         EjcSScJtddJ8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        guoren@kernel.org, yury.norov@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] Revert "net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}"
Date:   Fri, 14 Oct 2022 09:07:46 -0700
Message-Id: <20221014160746.553813-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 854701ba4c39afae2362ba19a580c461cb183e4f.

We have more violations around, which leads to:

  WARNING: CPU: 2 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x14e/0x770

Let's back this out and retry with a larger clean up in -next.

Fixes: 854701ba4c39 ("net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}")
Link: https://lore.kernel.org/all/20221014030459.3272206-2-guoren@kernel.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a36edb0ec199..eddf8ee270e7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3663,8 +3663,9 @@ static inline bool netif_attr_test_online(unsigned long j,
 static inline unsigned int netif_attrmask_next(int n, const unsigned long *srcp,
 					       unsigned int nr_bits)
 {
-	/* n is a prior cpu */
-	cpu_max_bits_warn(n + 1, nr_bits);
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpu_max_bits_warn(n, nr_bits);
 
 	if (srcp)
 		return find_next_bit(srcp, nr_bits, n + 1);
@@ -3685,8 +3686,9 @@ static inline int netif_attrmask_next_and(int n, const unsigned long *src1p,
 					  const unsigned long *src2p,
 					  unsigned int nr_bits)
 {
-	/* n is a prior cpu */
-	cpu_max_bits_warn(n + 1, nr_bits);
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpu_max_bits_warn(n, nr_bits);
 
 	if (src1p && src2p)
 		return find_next_and_bit(src1p, src2p, nr_bits, n + 1);
-- 
2.37.3

