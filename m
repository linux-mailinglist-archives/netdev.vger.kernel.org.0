Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1222B4EBF
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388068AbgKPR7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729795AbgKPR7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:59:34 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B60EC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 09:59:34 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id d12so19719338wrr.13
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 09:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aJ0kxvcNg8WudkW2GLLQQOG66wuKzFYPu3FPd9U7B4M=;
        b=je3OXBTqzuemDKlGGgZ035WduR32047oRbcTtP5OXVetbQoKce/sfz/E3WsMI9+lTr
         Pxcp01V58Ws4X2PLiSe+6BNtvAE/dRCI9+fbD7opMSqeigEbgYXOm41Q49INxmO9xedX
         8J8kxt3r32HTr/+mgYZSDngu2h4fp0LWja7HwYqjIrHmjdvnrCjsnfTy/an70ASqcckU
         HaiFcH+j158gJKXGzkV94n3lUFGBRuvqUqexI1y7yi4meJvldb+6pCG1wGYYoQ/pMDII
         9NfjEGySTmy6czqJIyK8pqkeDGtN16QQbh01rxN5gA0tX6gOsHlurib1gvLRBsfx2Kgc
         CGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aJ0kxvcNg8WudkW2GLLQQOG66wuKzFYPu3FPd9U7B4M=;
        b=Dy1v/a1SIf3CdqdYvz+7joHKCdHv7CBnXPVLt+G4+q8QJhrsMOG+mTggnj2iQx3fXm
         sy5CK8N3AQvc1oKL3XssNZbsIrw++AUacdv/YL7BngDa0WDLkGZeGjq5ZhJIqePsQDIv
         G+23cBLafTyUo0s6uP6iWF7d30r4JBd3bJ0TeuJZWJYzrnWdS3KFqWgVJmPPdzFjPc+Z
         PBZbEK5oXfNusGN7GIQpFjH7BzdFP2vP09OuUtulCRfeHv1ppy/Cgu8ODO1YLW0gRs1C
         awCJUqifB0M2LATSGXmKoNQipRLqu5r+enLLd5PoCFaG0lkUBqg+umeEM06bJsNBxtt5
         iinQ==
X-Gm-Message-State: AOAM531KQ4/N3xQbh01LyeqUmaJz3Tyjpq78QGSFa79d1ruK/TgRn+re
        3nY7pEV3+bPOXnYN4efmQtGo45u6e3z+35uADGxVDw==
X-Google-Smtp-Source: ABdhPJwHZRoSPWwwA7JC7cVxUFWAwpDr7rxkjtrsIt5KBcjgjTWMPH8aO6gnxcISmRMeaRBzDWxNQxPTEZrr4YohGXY=
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr20540222wrt.160.1605549572919;
 Mon, 16 Nov 2020 09:59:32 -0800 (PST)
MIME-Version: 1.0
References: <20201116174412.1433277-1-sharpelletti.kdev@gmail.com>
In-Reply-To: <20201116174412.1433277-1-sharpelletti.kdev@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 16 Nov 2020 12:58:57 -0500
Message-ID: <CACSApvYONt0V6oMvKq7GYEDZgGRPTXYYu+x9LQ94Hkj6aZWJ4w@mail.gmail.com>
Subject: Re: [PATCH net] tcp: only postpone PROBE_RTT if RTT is < current
 min_rtt estimate
To:     Ryan Sharpelletti <sharpelletti.kdev@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Ryan Sharpelletti <sharpelletti@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LGTM. Thanks!

On Mon, Nov 16, 2020 at 12:44 PM Ryan Sharpelletti
<sharpelletti.kdev@gmail.com> wrote:
>
> From: Ryan Sharpelletti <sharpelletti@google.com>
>
> During loss recovery, retransmitted packets are forced to use TCP
> timestamps to calculate the RTT samples, which have a millisecond
> granularity. BBR is designed using a microsecond granularity. As a
> result, multiple RTT samples could be truncated to the same RTT value
> during loss recovery. This is problematic, as BBR will not enter
> PROBE_RTT if the RTT sample is <= the current min_rtt sample, meaning
> that if there are persistent losses, PROBE_RTT will constantly be
> pushed off and potentially never re-entered. This patch makes sure
> that BBR enters PROBE_RTT by checking if RTT sample is < the current
> min_rtt sample, rather than <=.
>
> The Netflix transport/TCP team discovered this bug in the Linux TCP
> BBR code during lab tests.
>
> Fixes: 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
> Signed-off-by: Ryan Sharpelletti <sharpelletti@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> ---
>  net/ipv4/tcp_bbr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
> index 6c4d79baff26..6ea3dc2e4219 100644
> --- a/net/ipv4/tcp_bbr.c
> +++ b/net/ipv4/tcp_bbr.c
> @@ -945,7 +945,7 @@ static void bbr_update_min_rtt(struct sock *sk, const struct rate_sample *rs)
>         filter_expired = after(tcp_jiffies32,
>                                bbr->min_rtt_stamp + bbr_min_rtt_win_sec * HZ);
>         if (rs->rtt_us >= 0 &&
> -           (rs->rtt_us <= bbr->min_rtt_us ||
> +           (rs->rtt_us < bbr->min_rtt_us ||
>              (filter_expired && !rs->is_ack_delayed))) {
>                 bbr->min_rtt_us = rs->rtt_us;
>                 bbr->min_rtt_stamp = tcp_jiffies32;
> --
> 2.29.2.299.gdc1121823c-goog
>
