Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A179740591A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbhIIOez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348719AbhIIOea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:34:30 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8232CC14C428
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 06:38:34 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id t4so1739760qkb.9
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 06:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2k0eAi7t3UrMFYZt8LeToOvDYg6YcEBCtET5Cwweb0Q=;
        b=a/pypywgt7cW30O1KFYWLltCJGb9Zz7F6LlM8OzSxgXQ3PcrqwMe8zyTRvV5X2gtsj
         nRa5cP5UIh3PX8L2ODDTt0LhIYYxRwR7C3+ctfrvFqYSPhGjIx2ZFtFEHQkWOqzJUieQ
         NfgsMNjOHc/HumdLUR4AfFy3+Tw87htuRuLSky7L1lVHNXEjGK0gwmCsLKQe/Xn6Yfa1
         8u6sYN6o9EAoK7S8SdU0QkY3L4VRbQdIhuOTw5OJYqFNwVqAd1PsYGXh0fWi4Ih1dmXr
         QwvztC9RQoYtF3QY2ti1VxlaafpBb0tAfOb36W/N/J+HUkh7mdQkFJhfQl3xRGfi+C1n
         ekKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2k0eAi7t3UrMFYZt8LeToOvDYg6YcEBCtET5Cwweb0Q=;
        b=1IUk2K+u5DaNkvgkP0PXT5oNRDd7LRyMTe9l9nRpgynfCEZIL0wsYE/t/5Y5DHvYJF
         LOGKQHcUVWXUOJ7b4E1MOAAK5sGv/IWaXpMUW4TkcIxLfVCdb37O3uOzcxMnQU2ry2dP
         IW8IUMpgKy9Qyv9eGC3vuAi9CT80IO+xCf5WWZDEg866oT78XNtSuRwO1AMKzW180rcI
         q7edMlAE3kJApCwwkEZDMdslILTsXeSpZGoibNJi0stiGdgwR+L18UG7u95ZjnvVC4sn
         7Zuy1ceLt3/a1hfIqFjRNmP45zxivrw53pYmAoHkXJp+cVq9HoSMNhi6EAnR3JaTozXC
         VjgA==
X-Gm-Message-State: AOAM5333Y8Uo4UtWq2b6g/p6tku+BDVTOSI1tvnzdU4s6XOVsatYMEdh
        ZZckchqLM0SG8Owk5jxTTfBSoJL8iND2XX4Z4yby3A==
X-Google-Smtp-Source: ABdhPJxMrv3yq1Vhhq4HQHDvB5zCRaAltbsGKzY0XdZaLS6TaTOVGyEqc7r26mABnJHDJ7FqWJmySIMGKgbYNmcDY28=
X-Received: by 2002:a05:620a:29cf:: with SMTP id s15mr2758712qkp.250.1631194713560;
 Thu, 09 Sep 2021 06:38:33 -0700 (PDT)
MIME-Version: 1.0
References: <1630238373-12912-1-git-send-email-zhenggy@chinatelecom.cn>
In-Reply-To: <1630238373-12912-1-git-send-email-zhenggy@chinatelecom.cn>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 9 Sep 2021 09:38:16 -0400
Message-ID: <CADVnQykZvz3qSEm3c16cHOG66nwXnRVq5FhBT05h6Dj4dnxyiQ@mail.gmail.com>
Subject: Re: [PATCH] net: fix tp->undo_retrans accounting in tcp_sacktag_one()
To:     zhenggy <zhenggy@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 6:34 AM zhenggy <zhenggy@chinatelecom.cn> wrote:
>
> Commit a71d77e6be1e ("tcp: fix segment accounting when DSACK range covers
> multiple segments") fix some DSACK accounting for multiple segments.
> In tcp_sacktag_one(), we should also use the actual DSACK rang(pcount)
> for tp->undo_retrans accounting.
>
> Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
> ---
>  net/ipv4/tcp_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3f7bd7a..141e85e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1346,7 +1346,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
>         if (dup_sack && (sacked & TCPCB_RETRANS)) {
>                 if (tp->undo_marker && tp->undo_retrans > 0 &&
>                     after(end_seq, tp->undo_marker))
> -                       tp->undo_retrans--;
> +                       tp->undo_retrans = max_t(int, 0, tp->undo_retrans - pcount);
>                 if ((sacked & TCPCB_SACKED_ACKED) &&
>                     before(start_seq, state->reord))
>                                 state->reord = start_seq;
> --

Thanks for the fix!

I think it would be useful to have a Fixes: footer to help maintainers
know how far back to backport the fix.

I think an appropriate fixes footer might be the following:

Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")

Before that commit, the assumption underlying the tp->undo_retrans--
seems correct, AFAICT.

thanks,
neal
