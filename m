Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60B051C69E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382932AbiEESAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243661AbiEESAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:00:37 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126FE11C36;
        Thu,  5 May 2022 10:56:58 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-ee1e7362caso849252fac.10;
        Thu, 05 May 2022 10:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cORiy5zHWuygJV7CIo4MrW6dqN9icrRMZPDsxDaZ0tY=;
        b=7h8EyJpPSLQWC/25xDMBzlOull0MO7GnMox5m2l8qmFVgVU2CyL/bUB6hMd/ndSW8A
         K+cmonYC25X+0QiHj3Bsy12Jgf5z9H8xyTA662cJrbTaPP6mO0roz4oYDOm4NGFeetPl
         bx/EgIX40yM3HsfrMfapUzqtyvU4CNaYA5AbXxDsdjFMGCKEpw/3uKfHHYlIk8gjTYzn
         OUsJ79Bo3wtPrpQqCzbbyqaFg2/pn0A8zDI9rpgQEaQqvL89f8QwHMJ+mwXD3eNhmfHA
         vkeTR6sU/bHZ+lwc7Mj1JhgPBbopJ+swrovlxgXddtvIKx/E1Q8g3h9s6m9AI2OpX5qD
         zS8g==
X-Gm-Message-State: AOAM533fSekQ4yS62zBi/81W1b+cPVQOWY2E7mHGlJkakQPLn4kjNt+6
        rng0g2CFtpB8t9rWH7Q8YF6ISQ7zRYRDktdJ1CKSYA==
X-Google-Smtp-Source: ABdhPJwP0mNznjiC97fIDE2XSAFuH9TvbAy+3V12u2GibG8lTKDQOtqbRHVbILAMKmxDosLUsUtItg==
X-Received: by 2002:a05:6870:d297:b0:e6:589e:2217 with SMTP id d23-20020a056870d29700b000e6589e2217mr2791584oae.291.1651773417412;
        Thu, 05 May 2022 10:56:57 -0700 (PDT)
Received: from treble ([2600:1700:6e32:6c00::35])
        by smtp.gmail.com with ESMTPSA id 42-20020a9d012d000000b006060322124dsm817181otu.29.2022.05.05.10.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 10:56:57 -0700 (PDT)
Date:   Thu, 5 May 2022 10:56:54 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] net: make tcp keepalive timer upper bound
Message-ID: <20220505175654.jhu3zldboxdcjifr@treble>
References: <87zgkwjtq2.ffs@tglx>
 <20220505131811.3744503-1-asavkov@redhat.com>
 <20220505131811.3744503-3-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220505131811.3744503-3-asavkov@redhat.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:18:11PM +0200, Artem Savkov wrote:
> Make sure TCP keepalive timer does not expire late. Switching to upper
> bound timers means it can fire off early but in case of keepalive
> tcp_keepalive_timer() handler checks elapsed time and resets the timer
> if it was triggered early. This results in timer "cascading" to a
> higher precision and being just a couple of milliseconds off it's
> original mark.
> This adds minimal overhead as keepalive timers are never re-armed and
> are usually quite long.
> 
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  net/ipv4/inet_connection_sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 1e5b53c2bb26..bb2dbfb6f5b5 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -589,7 +589,7 @@ EXPORT_SYMBOL(inet_csk_delete_keepalive_timer);
>  
>  void inet_csk_reset_keepalive_timer(struct sock *sk, unsigned long len)
>  {
> -	sk_reset_timer(sk, &sk->sk_timer, jiffies + len);
> +	sk_reset_timer(sk, &sk->sk_timer, jiffies + upper_bound_timeout(len));
>  }
>  EXPORT_SYMBOL(inet_csk_reset_keepalive_timer);

As I mentioned before, there might be two sides to the same coin,
depending on whether the keepalive is detecting vs preventing the
disconnect.  So this might possibly fix one case, while breaking
another.

Hopefully a networking expert can chime in.

-- 
Josh
