Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878D6523B69
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345454AbiEKRXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345045AbiEKRXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D5B2108AF
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11A5061D4B
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F38C34116;
        Wed, 11 May 2022 17:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652289789;
        bh=jObzVqYxPYUo+GYN1nU1AHn2v+BT/MtwUBXLQJcJWmM=;
        h=From:To:Cc:Subject:Date:From;
        b=muXknEegenu1Vs4A+xC1eWU+6K1Zpt+FgqMW0TRlB/hk/TBLTOyRWNPpcVGQ7NrhP
         v1ejoLxF2yBHMNbMLCiDfF7oNoZWYy2UCDNplAgB/LyQCP8so0jsKzOKoC97r164P3
         KzhQUzHt58Ux/DvGtR/Xkatw7j9KlS1lo8KbVVEiwTFTfGFsGRKvUBEYrdkCr7DI8u
         KTyWzzxBLFq2IEUz9Jy5qUmu02wnkPImsEpX2YS1zYzw9Jzwm/mXsS7NZONBJYeoQi
         4eljCeB+UduIqf7JRNN4+uZ4ksbF5BU0rbdnqe0+vZHwfZUaRIfjnVCE24/t29v2p9
         jzFGcIdkf0VOQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, imagedong@tencent.com
Subject: [PATCH net-next] skbuff: replace a BUG_ON() with the new DEBUG_NET_WARN_ON_ONCE()
Date:   Wed, 11 May 2022 10:23:05 -0700
Message-Id: <20220511172305.1382810-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Very few drivers actually have Kconfig knobs for adding
-DDEBUG. 8 according to a quick grep, while there are
93 users of skb_checksum_none_assert(). Switch to the
new DEBUG_NET_WARN_ON_ONCE() to catch bad skbs.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: imagedong@tencent.com
---
 include/linux/skbuff.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b91d225fdc13..9d82a8b6c8f1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5048,9 +5048,7 @@ static inline void skb_forward_csum(struct sk_buff *skb)
  */
 static inline void skb_checksum_none_assert(const struct sk_buff *skb)
 {
-#ifdef DEBUG
-	BUG_ON(skb->ip_summed != CHECKSUM_NONE);
-#endif
+	DEBUG_NET_WARN_ON_ONCE(skb->ip_summed != CHECKSUM_NONE);
 }
 
 bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off);
-- 
2.34.3

