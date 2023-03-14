Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDAB6B9EAE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjCNSf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjCNSft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:35:49 -0400
Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [IPv6:2001:41d0:203:375::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE49EB53FD
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 11:35:22 -0700 (PDT)
Message-ID: <a8c21051-b6e0-a9f6-2530-5b36cb27d613@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678818847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SwJKXnde6xuu4fjvLFS0gHLJtbHGUQQPIJjJop2D0PE=;
        b=vZAwHHl6L4Mz/9TKuM58QxP5L3QjZHTMEyNXr0f8EB02xnYfyXfAipGHuU5vI45DGnIHU2
        3wT9orvKHZERaniO189kiBB0y4o9mcregjQNpKt7TTr7TLfpiw6lOYwx29tiLzMQmnf2Sy
        W9+9nPiNcNqqPKgDB7Q2NSE2gPdDIkg=
Date:   Tue, 14 Mar 2023 11:34:01 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 net 1/2] tcp: Fix bind() conflict check for dual-stack
 wildcard address.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Paul Holzinger <pholzing@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
References: <20230312031904.4674-1-kuniyu@amazon.com>
 <20230312031904.4674-2-kuniyu@amazon.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230312031904.4674-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/23 7:19 PM, Kuniyuki Iwashima wrote:
> Paul Holzinger reported [0] that commit 5456262d2baa ("net: Fix
> incorrect address comparison when searching for a bind2 bucket")
> introduced a bind() regression.  Paul also gave a nice repro that
> calls two types of bind() on the same port, both of which now
> succeed, but the second call should fail:
> 
>    bind(fd1, ::, port) + bind(fd2, 127.0.0.1, port)
> 
> The cited commit added address family tests in three functions to
> fix the uninit-value KMSAN report. [1]  However, the test added to
> inet_bind2_bucket_match_addr_any() removed a necessary conflict
> check; the dual-stack wildcard address no longer conflicts with
> an IPv4 non-wildcard address.
> 
> If tb->family is AF_INET6 and sk->sk_family is AF_INET in
> inet_bind2_bucket_match_addr_any(), we still need to check
> if tb has the dual-stack wildcard address.
> 
> Note that the IPv4 wildcard address does not conflict with
> IPv6 non-wildcard addresses.
> 
> [0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
> [1]: https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/
> 
> Fixes: 5456262d2baa ("net: Fix incorrect address comparison when searching for a bind2 bucket")
> Reported-by: Paul Holzinger <pholzing@redhat.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks for the fix.

Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>

