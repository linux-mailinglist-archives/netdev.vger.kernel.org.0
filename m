Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC49D3F8E7E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbhHZTMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhHZTMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:12:40 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE94C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:11:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h13so6713953wrp.1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKyPTQjw5QI2XEtqHA7LuvAWr36xYYzQW8dAHFnO0kY=;
        b=Xa4hMERLBQmklza+7hMlmZgbtMUVsB9BpiqKwIdlCe+F+m4yqzK3c4xquJAK51IiSG
         l/CREs+xRtCXs6IJJM8wz6igsODXPJ7vIYt10Ron8dETx5/pXGWYvcjXCwXmKPSIAub7
         ygd5P5c/cTp90PDqEWGfRVmPSo5PcU9r8nsh193lQtbnJehm8pFeeodUQPMAWmTHG5Ve
         Oy1QrbGgsE1Y9148P+dq8+4cFgx1XW+VViTypxDD6ziPiWRc5IeA16w+eCN6FowrPviV
         aB2RCSYl0XBCA1FT9/m8aPk9jAvLuJkMnmPl/BMFbOPlYgJhyAyweKXyuGSPi7T2Gf65
         5Cjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKyPTQjw5QI2XEtqHA7LuvAWr36xYYzQW8dAHFnO0kY=;
        b=Ej+lKkc6FPZda8fnHU39N/8bWOVUwzde6GtL3A9Fdm6I/RO0GFmAjreAVceqcG+EOJ
         Ag2Fb05XVz/xSH+UqERfIaSjDPIuSRaeSBAahSMrHTpOK5+qPmX4ari06cD52bOdY1DC
         3O5E43yw88GuRDi4CI9UUd17/HWFsTaHYYnv99AlTceWK6xPm4UtOMGITHpAq11FG76e
         gY7eHJPEx9WyvtaUnVrRxrUhzqCmNv3yFXegL2GHkBmyTEjl5toDIZMoru+xp+VpW7qb
         3IytfjcPjKKKYh3ie90Q3ZyCyZapGtphg98nj6qfOWV3jbo9GjicuN4+RGD+zfLARsZN
         LAFQ==
X-Gm-Message-State: AOAM530gcKui2FSA/DkI0bsjug8LQiihAP6KXMoZTJcgJ9c9MbTb1003
        nM9UMJbfkpKonwd3SLOIFTPUaxKBMDJQKH5QCMpASQ==
X-Google-Smtp-Source: ABdhPJwZ5P/CsMjmlnhSMb1lUfrcEL8QqEInchwAq5YB/+HUo/LSyEXtOiNGNunxF5vcJiUfGJ9tMz7CR6ceOo3FE6w=
X-Received: by 2002:adf:d4ce:: with SMTP id w14mr5890212wrk.407.1630005110749;
 Thu, 26 Aug 2021 12:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210825210117.1668371-1-ntspring@fb.com>
In-Reply-To: <20210825210117.1668371-1-ntspring@fb.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Thu, 26 Aug 2021 12:11:13 -0700
Message-ID: <CAK6E8=cB=XA25CYftOvUYR+8euEZC=iU8-JY79v45qghY0vtXg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] tcp: enable mid stream window clamp
To:     Neil Spring <ntspring@fb.com>
Cc:     davem@davemloft.net, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        ncardwell@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 2:02 PM Neil Spring <ntspring@fb.com> wrote:
>
> The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the size
> of the advertised window to this value."  Window clamping is distributed
> across two variables, window_clamp ("Maximal window to advertise" in
> tcp.h) and rcv_ssthresh ("Current window clamp").
>
> This patch updates the function where the window clamp is set to also
> reduce the current window clamp, rcv_sshthresh, if needed.  With this,
> setting the TCP_WINDOW_CLAMP option has the documented effect of limiting
> the window.
This patch looks like a bug-fix so it should be applied to net not net-next?

>
> Signed-off-by: Neil Spring <ntspring@fb.com>
> ---
> v2: - fix email formatting
>
> v3: - address comments by setting rcv_ssthresh based on prior window
>
>  net/ipv4/tcp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index f931def6302e..e8b48df73c85 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3338,6 +3338,7 @@ int tcp_set_window_clamp(struct sock *sk, int val)
>         } else {
>                 tp->window_clamp = val < SOCK_MIN_RCVBUF / 2 ?
>                         SOCK_MIN_RCVBUF / 2 : val;
> +               tp->rcv_ssthresh = min(tp->rcv_wnd, tp->window_clamp);
>         }
>         return 0;
>  }
> --
> 2.30.2
>
