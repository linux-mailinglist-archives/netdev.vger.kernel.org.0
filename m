Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8859120C
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfHQRLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 13:11:02 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34724 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfHQRLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 13:11:02 -0400
Received: by mail-ot1-f67.google.com with SMTP id c7so12536487otp.1
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 10:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oem3sRHAmS2NmewbEgIrW115Gzc4Z+SBjXWch3a+dy0=;
        b=vNB18Ww+6Q6PZxtf47UjPPOreARQLtaxjgoBargU6FS/dkACawDzoH1/VGGbg/0dfT
         6KWHGLABHFU0juanvREg3eFHImPM92+T9SM6nvcUYvKvx5adwCFJNpGCYxaaqy1lOYTR
         KwZGVrz380RKdz5fqHOZWEl9HzV79opk8Rgfbmzf4UV0/Z10sCxAuq0+/3t4X9Lc9MlH
         LEfvFdN7codUKIl9345R5zUIOgeDMUnReK35akvnLjTlIDg8FfbgjncWuyREqxnrcM3c
         sfEC6hQ9hzUL7ZFTeTVIZr56qq6i6EI2Ij78FNAKfFn+Q0OQjsldryPyKFPUfhhSvuN0
         qEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oem3sRHAmS2NmewbEgIrW115Gzc4Z+SBjXWch3a+dy0=;
        b=OjcivaPVbKtYqNnD0zwa56Am3qwUuyLIuCq1FNakG8FqkTKQ27IcFMstSy+NbdIuU7
         USOg+ytSdLj5AilvglOEWvE2/irhcI+fMuEMjOxGAJTuDYd18KJr5UteRrZiQJ/U0Oie
         HoV4vERrUXOx+o/qT/4sHtkJ/eTIo6SPLzNVi3zh5/UzMFhI+uDb9F8TTjQmmePhtReg
         /4X/8L2C1nimbXsKbidIj3muv4GSSPFG7M9NVZVXcf4spX+Jz5l5HmLNp31atc/opgAm
         yL1bGhxni9lsX6VV+HIZsiyXtTeAaoKcIBAoZSVODsNJRxFDGGidRpRDa46nGy+ihVW2
         dogg==
X-Gm-Message-State: APjAAAXysKtkFH52S5rjRy0Eo8MfMawv+/djPo/BlMlQ0ixVJSFW/ef4
        1sEvjfCZ968TLm+0tJb2Urr5ODKctVR41lb60ig4MA==
X-Google-Smtp-Source: APXvYqyeBRR6qyVWmHKvn9Bv7b4E+tBsnQQgvtkeWTlrH6Frxhy8ubspmPow7tTVH62qYMwaNq0Mw/KEkkS3kQr+Rsw=
X-Received: by 2002:a9d:b90:: with SMTP id 16mr12352691oth.371.1566061861200;
 Sat, 17 Aug 2019 10:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190817042622.91497-1-edumazet@google.com>
In-Reply-To: <20190817042622.91497-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 17 Aug 2019 13:10:44 -0400
Message-ID: <CADVnQyn1YYH-jsSMTxMcpVhJqDnB4-bOSb3rOg16tdSySNr4HQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: make sure EPOLLOUT wont be missed
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 17, 2019 at 12:26 AM Eric Dumazet <edumazet@google.com> wrote:
>
> As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
> under memory pressure"), it is crucial we properly set SOCK_NOSPACE
> when needed.
>
> However, Jason patch had a bug, because the 'nonblocking' status
> as far as sk_stream_wait_memory() is concerned is governed
> by MSG_DONTWAIT flag passed at sendmsg() time :
>
>     long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
>
> So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
> and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
> cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
> value.
>
> This patch removes the 'noblock' variable since we must always
> set SOCK_NOSPACE if -EAGAIN is returned.
>
> It also renames the do_nonblock label since we might reach this
> code path even if we were in blocking mode.
>
> Fixes: 790ba4566c1a ("tcp: set SOCK_NOSPACE under memory pressure")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky  <rutsky@google.com>
> ---
>  net/core/stream.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Eric!

neal
