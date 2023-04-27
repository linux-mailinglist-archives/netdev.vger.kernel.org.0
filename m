Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227C66F06D8
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 15:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbjD0Npx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 09:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243708AbjD0Nps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 09:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A2C4C18
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3876380D
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D097C433D2;
        Thu, 27 Apr 2023 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682603142;
        bh=IKw9u4/AevM6AVhGjUM+97AFlcGCbDH+7YZ5T4PEUxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEeZS4IJwlONzipz0Ow1/H8a0hpAJi3MgBOW5erf5MJEVs0nUOzEmM1LoIh65L/nC
         4S6+BZ7yqPbO+hsvRLeVudaxdVbkV+dUkCY9jOz04mmsieSeUDSvsXO+svJl7P7w6a
         dOnZ0rDS4F7FheAxL0bdgnvxobIJGXd6gQX8uzV9IEmJ1gx53JsXPHSFJUQwWzPi8j
         U85JfddpKMex+8FyNqSmkpGnA1KmONge3Cl7c6f0g256nL+cla0rnM2ORMQYjbFUp5
         ZLh1asJAcBAuYOaif8J3UxOb+rzU7fCvDe8gpo/blcOAQeQEtT4VLP+1D1zV/aaQkC
         9TSiky/AbFORQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
Date:   Thu, 27 Apr 2023 15:45:27 +0200
Message-Id: <20230427134527.18127-5-atenart@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230427134527.18127-1-atenart@kernel.org>
References: <20230427134527.18127-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
sk->sk_txhash is not a canonical 4-tuple hash. sk->sk_txhash is
used in the TCP Tx path to populate skb->hash, with skb->l4_hash=1.
With this, skb->l4_hash does not always indicate the hash is a
"canonical 4-tuple hash over transport ports" but rather a hash from L4
layer to provide a uniform distribution over flows. Reword the comment
accordingly, to avoid misunderstandings.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 738776ab8838..f54c84193b23 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -791,8 +791,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
- *	@l4_hash: indicate hash is a canonical 4-tuple hash over transport
- *		ports.
+ *	@l4_hash: indicate hash is from layer 4 and provides a uniform
+ *		distribution over flows.
  *	@sw_hash: indicates hash was computed in software stack
  *	@wifi_acked_valid: wifi_acked was set
  *	@wifi_acked: whether frame was acked on wifi or not
-- 
2.40.0

