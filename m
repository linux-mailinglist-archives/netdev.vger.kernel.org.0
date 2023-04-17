Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0076D6E4DB7
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjDQPx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjDQPxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6F0E7B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 08:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA0EB621C2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBBCC433A0;
        Mon, 17 Apr 2023 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681746833;
        bh=Mlqdsrzj6Lmq86teLsERRxTRy60NtlHlA3+qL8jRJfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI7NB0dvaWDVVUEg6QsJcn5Tzn9rKrWKLW5Ke54+Ze4H7xujdKbQApMunka/HrsMS
         xzOSVgU7URFUil6vMti/ACdCFkLQ8icwIrk7KjgjOqgF8l3FbbLn3XqJYf7zJs7HEQ
         c6TKpEQgbKzzpUe+PTV7WRN3g9OURy5gAVJyy5vwV2RvJlgTg1Uq6MKjyUG0aWfMfL
         PuUaOHqN9XiMv0iOT1J299nkqBXe4mcpH+pValL6ukSg4xWMEqGnImCK4qLN+cXq2q
         j97E5gcCsP/XKVqsX9vr1BJ90qNVyAt1b3d0QplvUgVOMmCgcTow6ZB3GU98FGKy29
         ibJi9IR5RBpfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v2 3/5] net: skbuff: move alloc_cpu into a potential hole
Date:   Mon, 17 Apr 2023 08:53:48 -0700
Message-Id: <20230417155350.337873-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417155350.337873-1-kuba@kernel.org>
References: <20230417155350.337873-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

alloc_cpu is currently between 4 byte fields, so it's almost
guaranteed to create a 2B hole. It has a knock on effect of
creating a 4B hole after @end (and @end and @tail being in
different cachelines).

None of this matters hugely, but for kernel configs which
don't enable all the features there may well be a 2B hole
after the bitfield. Move alloc_cpu there.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 98d6b48f4dcf..2595b2cfba0d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -991,6 +991,8 @@ struct sk_buff {
 	__u16			tc_index;	/* traffic control index */
 #endif
 
+	u16			alloc_cpu;
+
 	union {
 		__wsum		csum;
 		struct {
@@ -1014,7 +1016,6 @@ struct sk_buff {
 		unsigned int	sender_cpu;
 	};
 #endif
-	u16			alloc_cpu;
 #ifdef CONFIG_NETWORK_SECMARK
 	__u32		secmark;
 #endif
-- 
2.39.2

