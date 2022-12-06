Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2AC644D2F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiLFUWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLFUWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:22:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9E4D2F2
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:22:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392236155F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622EEC433D6;
        Tue,  6 Dec 2022 20:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670358160;
        bh=n/Ttm1jrcVUyuep5gdF6WEPIx4rJiAFWaz0/05XqFzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tRv0sxGG36N/trrVvQN4kK4TKTjzvbKcJgPFR3m8PRJhZ1NFr3H1xhnIIOo1sHIaB
         Ol3L5XmNuq+buLyE+FeHKXXH6s88HZ0RUa6kil+ytNqonA6pLCAlQd9EblfQ4BlVVJ
         /e1yNDYf95H6IraLJl1Qukh9wWV3odxStRbUlpfQ2DJjez4Xkso7dQhChhQn6ZSxtJ
         31kyYUyzERne1EGBSNYcwaauhd6r3hiTw+1HuEhZ71E79TYk0oWDoSc7m2wk2G0k0O
         oLY9YmmGRWIdBfukVzSzWoUtENnGtdErpRyRJbyw+sojmV3e33cXIBInh/ZnmIhUAm
         b5+5Tiy3GcKbA==
Date:   Tue, 6 Dec 2022 12:22:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, soheil@google.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
Message-ID: <20221206122239.58e16ae4@kernel.org>
In-Reply-To: <20221205230925.3002558-1-willemdebruijn.kernel@gmail.com>
References: <20221205230925.3002558-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Dec 2022 18:09:25 -0500 Willem de Bruijn wrote:
> Add an option to initialize SOF_TIMESTAMPING_OPT_ID for TCP from
> write_seq sockets instead of snd_una.
> 
> Intuitively the contract is that the counter is zero after the
> setsockopt, so that the next write N results in a notification for
> last byte N - 1.
> 
> On idle sockets snd_una == write_seq so this holds for both. But on
> sockets with data in transmission, snd_una depends on the ACK response
> from the peer. A process cannot learn this in a race free manner
> (ioctl SIOCOUTQ is one racy approach).

We can't just copy back the value of 

	tcp_sk(sk)->snd_una - tcp_sk(sk)->write_seq

to the user if the input of setsockopt is large enough (ie. extend the
struct, if len >= sizeof(new struct) -> user is asking to get this?
Or even add a bit somewhere that requests a copy back?

Highly unlikely to break anything, I reckon? But whether setsockopt()
can copy back is not 100% clear to me...

> write_seq is a better starting point because based on the seqno of
> data written by the process only.
> 
> But the existing behavior may already be relied upon. So make the new
> behavior optional behind a flag.
> 
> The new timestamp flag necessitates increasing sk_tsflags to 32 bits.
> Move the field in struct sock to avoid growing the socket (for some
> common CONFIG variants). The UAPI interface so_timestamping.flags is
> already int, so 32 bits wide.
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>

Reported-by: Sotirios Delimanolis <sotodel@meta.com>

I'm just a bad human information router.

> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> ---
> 
> Alternative solutions are
> 
> * make the change unconditionally: a one line change.
> * make the condition a (per netns) sysctl instead of flag
> * make SOF_TIMESTAMPING_OPT_ID_TCP not a modifier of, but alternative
>   to SOF_TIMESTAMPING_OPT_ID. That requires also updating all existing
>   code that now tests OPT_ID to test a new OPT_ID_MASK.

 * copy back the SIOCOUTQ

;)

> Weighing the variants, this seemed the best option to me.
> ---
>  Documentation/networking/timestamping.rst | 19 +++++++++++++++++++
>  include/net/sock.h                        |  6 +++---
>  include/uapi/linux/net_tstamp.h           |  3 ++-
>  net/core/sock.c                           |  9 ++++++++-
>  net/ethtool/common.c                      |  1 +
>  5 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> index be4eb1242057..578f24731be5 100644
> --- a/Documentation/networking/timestamping.rst
> +++ b/Documentation/networking/timestamping.rst
> @@ -192,6 +192,25 @@ SOF_TIMESTAMPING_OPT_ID:
>    among all possibly concurrently outstanding timestamp requests for
>    that socket.
>  
> +SOF_TIMESTAMPING_OPT_ID_TCP:
> +  Pass this modifier along with SOF_TIMESTAMPING_OPT_ID for new TCP
> +  timestamping applications. SOF_TIMESTAMPING_OPT_ID defines how the
> +  counter increments for stream sockets, but its starting point is
> +  not entirely trivial. This modifier option changes that point.
> +
> +  A reasonable expectation is that the counter is reset to zero with
> +  the system call, so that a subsequent write() of N bytes generates
> +  a timestamp with counter N-1. SOF_TIMESTAMPING_OPT_ID_TCP
> +  implements this behavior under all conditions.
> +
> +  SOF_TIMESTAMPING_OPT_ID without modifier often reports the same,
> +  especially when the socket option is set when no data is in
> +  transmission. If data is being transmitted, it may be off by the
> +  length of the output queue (SIOCOUTQ) due to being based on snd_una
> +  rather than write_seq. That offset depends on factors outside of
> +  process control, including network RTT and peer response time. The
> +  difference is subtle and unlikely to be noticed when confiugred at
> +  initial socket creation. But .._OPT_ID behavior is more predictable.

I reckon this needs to be more informative. Say how exactly they differ
(written vs queued for transmission). And I'd add to
SOF_TIMESTAMPING_OPT_ID docs a note to "see also .._OPT_ID_TCP version".
