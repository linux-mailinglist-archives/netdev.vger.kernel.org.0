Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAD1589F08
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 17:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiHDP74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 11:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiHDP7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 11:59:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606425F11E
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 08:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F179B824B3
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 15:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3851BC433D7;
        Thu,  4 Aug 2022 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659628791;
        bh=fTFvrGA/i+VKDee3qHFL4iib0JFp2UIGyEgSST/9z80=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BiCoBDlh9ANh/n0ACa4C6w6sQBCOCyDskzsm8gtLRDs4yZEYM7/WLsPo75or07djs
         KgyhvIKe0nS8LUGwmpRYbg/sEUqZYhwPM/SBWFaDDyzi7eV9WEhBvuIXzHM4ucZEyM
         8gxLWLxYAXGXdl/bBy9gNLpXGZwoNMBBlKzasKA7Ho892t4EKp+sZ/RlJNM252F5xc
         F9WP/+zMsYnp8f2pUMCQjXuOmfjBBi5GqCcCkPO0gF0Mp2FkkNUTzpbWRcFALDVwF3
         THBUSulznTYe+WXwfj/e3JrGl+Cwd648L6M2bcNHQqTw2v94hwbXx28cjOWU8tpS8b
         rMwkpH9JnydFw==
Date:   Thu, 4 Aug 2022 08:59:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20220804085950.414bfa41@kernel.org>
In-Reply-To: <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
        <20220803182432.363b0c04@kernel.org>
        <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Aug 2022 11:05:18 +0300 Tariq Toukan wrote:
> >   	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,  
> 
> Now we see a different trace:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 4 PID: 45887 at net/tls/tls_strp.c:53 

OK, if you find another I promise I'll try to hassle a machine with
offload from somewhere... here's the fix for the new one:

--->8----------------
tls: rx: device: don't try to copy too much on detach

Another device offload bug, we use the length of the output
skb as an indication of how much data to copy. But that skb
is sized to offset + record length, and we start from offset.
So we end up double-counting the offset which leads to
skb_copy_bits() returning -EFAULT.

Reported-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index f0b7c9122fba..9b79e334dbd9 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -41,7 +41,7 @@ static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
 	struct sk_buff *skb;
 	int i, err, offset;
 
-	skb = alloc_skb_with_frags(0, strp->anchor->len, TLS_PAGE_ORDER,
+	skb = alloc_skb_with_frags(0, strp->stm.full_len, TLS_PAGE_ORDER,
 				   &err, strp->sk->sk_allocation);
 	if (!skb)
 		return NULL;
-- 
2.37.1

