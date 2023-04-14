Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642546E27F0
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjDNQER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjDNQEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2CAF32
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BEF648DE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 16:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AD3C433D2;
        Fri, 14 Apr 2023 16:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681488243;
        bh=13R25JvpyMOYGcsyULUqxj+JuEPmLGACYTksdYhdW34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arT/ThSQdZAN4NmH86IZxA3rWcIETg9wporQW8VAFgAowRKXHzkeWYtqpnog6cop7
         MCljzP0q9amjMRhdK96YXWZrTlfgN7M5oywIRJUHjhyHBtSe720FJb7N/OVjgsPBD+
         /J/k5T389NSu9pybVJVDr/fPFkRh+KBB1pbUVcysg7OcXLNt/crZhkfxKoFhmNau98
         mCSiou+9JsW9Al+VvBCiUfh52mqObQ7fjyDQPOltiQW8STwvqlv3kAheQiZXsvrxnj
         2eoMOfv4p07F9QHIaLDtNgSHyyGnV274GYM+t5+SrH+ej3NBhYnH0p9n/kt4tjlwVm
         0doqfwh3K21Ow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/5] net: skbuff: move alloc_cpu into a potential hole
Date:   Fri, 14 Apr 2023 09:01:03 -0700
Message-Id: <20230414160105.172125-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414160105.172125-1-kuba@kernel.org>
References: <20230414160105.172125-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 45c3044e8123..fd6344aca94a 100644
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

