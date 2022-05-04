Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074D951ABAB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 19:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359386AbiEDRwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 13:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376265AbiEDRuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 13:50:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A664BBB6
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:10:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84895B827A6
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 17:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DB8C385A5;
        Wed,  4 May 2022 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651684229;
        bh=6CHT3GQPf3OXv2w80uv+sbzs7Tifj4kk4k9NeHKmYjM=;
        h=From:To:Cc:Subject:Date:From;
        b=nR5eh9RxnqU5SECnI7i2pm5ML3xJsKe/RtAmMo7t7MpqqkejWVNnzJ/HCIi9//gtn
         O8MiVfzYiN6stlIAG1iuMtRRtaj6DW64Yju56+/RJGJ4Txj87u8gapwhjPRmLgzz4a
         rxLM050ct0IrLmtqieb2JwPE69FVgvZ0OBpzL+A2FQJJvlsA0ScxF5Q9Du/RsZxs0H
         BhpHrjd59vnzSY3MdxOtEzqYVmwEjiW4OgcczTyRblDaZFVJgXU6ldXjC3MIP4SIR3
         +/4CeRQ9CfhrRY2QMXMShFfZvreOE8gnJYdg97aXTlbWihA6ctj77Pt8c4VIB7Jpde
         ldXDHgvRBVCbw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
Cc:     David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] net: Make msg_zerocopy_alloc static
Date:   Wed,  4 May 2022 10:09:47 -0700
Message-Id: <20220504170947.18773-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
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

msg_zerocopy_alloc is only used by msg_zerocopy_realloc; remove the
export and make static in skbuff.c

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h | 1 -
 net/core/skbuff.c      | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3270cb72e4d8..5c2599e3fe7d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1665,7 +1665,6 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
 }
 #endif
 
-struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size);
 struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 				       struct ubuf_info *uarg);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 475183f37891..15f7b6f99a8f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1165,7 +1165,7 @@ void mm_unaccount_pinned_pages(struct mmpin *mmp)
 }
 EXPORT_SYMBOL_GPL(mm_unaccount_pinned_pages);
 
-struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
+static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 {
 	struct ubuf_info *uarg;
 	struct sk_buff *skb;
@@ -1196,7 +1196,6 @@ struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 
 	return uarg;
 }
-EXPORT_SYMBOL_GPL(msg_zerocopy_alloc);
 
 static inline struct sk_buff *skb_from_uarg(struct ubuf_info *uarg)
 {
-- 
2.25.1

