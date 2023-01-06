Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC79F660775
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 20:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbjAFTym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 14:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbjAFTyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 14:54:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9515081C39
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 11:54:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEC2D61F1C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 19:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB99C433EF;
        Fri,  6 Jan 2023 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673034842;
        bh=BE/w00XWlxsVRLdFITecDHmgDjOZU/hjHFK+/cy7e4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cF39X0P7hHCLe5DsUmaGNSXozs9/Qw+qG69HizbbQvjnL1hOeUAJYKS3g2U9xmE1N
         86FoRXiA7xLggLfHM9aFSaIHzzLalw/X+NlTksAJrSQOIZ65aDtL8pM4at6w/rWjgL
         xYvnyBdZIwW8clYd8AYmfwVaUQ5c9VPmfDf+x0yyVfRsqoWexFhNhmWC3WpuFrEvVC
         1lf3w21e0CbD+8mqYKTPAw4HSQuPbZ82GBIFM1RolbykRcyt91QgPI9Dz77pndsXm+
         g9Ww7Z9VZhzjvwuwsIqi2SGm126aV7ad0cPxYdzRl1D/oADV4Gqwi8YSkZ45IXRkGT
         /cro14xioHb8g==
Date:   Fri, 6 Jan 2023 11:54:00 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 1/2] net: fix call location in
 kfree_skb_list_reason
Message-ID: <Y7h8WPoi6hS/2Hs2@x130>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
 <167293336279.249536.18331792118487373874.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <167293336279.249536.18331792118487373874.stgit@firesoul>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jan 16:42, Jesper Dangaard Brouer wrote:
>The SKB drop reason uses __builtin_return_address(0) to give the call
>"location" to trace_kfree_skb() tracepoint skb:kfree_skb.
>
>To keep this stable for compilers kfree_skb_reason() is annotated with
>__fix_address (noinline __noclone) as fixed in commit c205cc7534a9
>("net: skb: prevent the split of kfree_skb_reason() by gcc").
>
>The function kfree_skb_list_reason() invoke kfree_skb_reason(), which
>cause the __builtin_return_address(0) "location" to report the
>unexpected address of kfree_skb_list_reason.
>
>Example output from 'perf script':
> kpktgend_0  1337 [000]    81.002597: skb:kfree_skb: skbaddr=0xffff888144824700 protocol=2048 location=kfree_skb_list_reason+0x1e reason: QDISC_DROP
>
>Patch creates an __always_inline __kfree_skb_reason() helper call that
>is called from both kfree_skb_list() and kfree_skb_list_reason().
>Suggestions for solutions that shares code better are welcome.
>
>As preparation for next patch move __kfree_skb() invocation out of
>this helper function.
>
>Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>---
> net/core/skbuff.c |   34 +++++++++++++++++++++-------------
> 1 file changed, 21 insertions(+), 13 deletions(-)
>
>diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>index 4a0eb5593275..007a5fbe284b 100644
>--- a/net/core/skbuff.c
>+++ b/net/core/skbuff.c
>@@ -932,6 +932,21 @@ void __kfree_skb(struct sk_buff *skb)
> }
> EXPORT_SYMBOL(__kfree_skb);
>
>+static __always_inline
>+bool __kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
>+{
>+	if (unlikely(!skb_unref(skb)))
>+		return false;
>+
>+	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
>+
>+	if (reason == SKB_CONSUMED)
>+		trace_consume_skb(skb);
>+	else
>+		trace_kfree_skb(skb, __builtin_return_address(0), reason);
>+	return true;

why not just call __kfree_skb(skb); here instead of the boolean return ? 
if it because __kfree_skb() makes a call to
skb_release_all()->..->kfree_skb_list_reason()
then it's already too deep and the return address in that case isn't
predictable, so you're not avoiding any breakage by keeping
direct calls to __kfree_skb() from kfree_skb_reason and+kfree_skb_list_reason

>+}
>+
> /**
>  *	kfree_skb_reason - free an sk_buff with special reason
>  *	@skb: buffer to free
>@@ -944,26 +959,19 @@ EXPORT_SYMBOL(__kfree_skb);
> void __fix_address
> kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
> {
>-	if (unlikely(!skb_unref(skb)))
>-		return;
>-
>-	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
>-
>-	if (reason == SKB_CONSUMED)
>-		trace_consume_skb(skb);
>-	else
>-		trace_kfree_skb(skb, __builtin_return_address(0), reason);
>-	__kfree_skb(skb);
>+	if (__kfree_skb_reason(skb, reason))
>+		__kfree_skb(skb);
> }
> EXPORT_SYMBOL(kfree_skb_reason);
>
>-void kfree_skb_list_reason(struct sk_buff *segs,
>-			   enum skb_drop_reason reason)
>+void __fix_address
>+kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
> {
> 	while (segs) {
> 		struct sk_buff *next = segs->next;
>
>-		kfree_skb_reason(segs, reason);
>+		if (__kfree_skb_reason(segs, reason))
>+			__kfree_skb(segs);
> 		segs = next;
> 	}
> }
>
>
