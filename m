Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2491E2680
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgEZQH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgEZQH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:07:28 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3638C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 09:07:28 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so24425757ejd.0
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 09:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oUX2U4JS3w0Y2qYxpOXghH6eOc+2SRemQlTn795nUco=;
        b=Y4NPsLdjzHhMjro6pFDoV1bAICpfzxuL4D4diGL2bQi8jjT77h2Djuh4nxjLz17cTI
         gqU8n1bTGOtPg5PwOyejoMZntYBwNLjpJkZ0nL8cFb/sjQ2n1CzzKF9uIokea2RdJOWM
         f56pqR/u//tsKXxztbMuF86GXIlQmJy2+pd6RNPA65b2ttFTxBgALQJwR2iHE6p5gmHA
         WQeZ/fb2cHctLolp8PTPi9WOaZCHUPQROA6h/XmVIfSMVCcw16ANLBwL5jEGTKZ1Yhoz
         VJC21zP2nUPJTxRcbTj2opbrKTYqMCi7fbpJcRh1JmNmcHYl/BsqPNb/PhSkx5cEyDOB
         VKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oUX2U4JS3w0Y2qYxpOXghH6eOc+2SRemQlTn795nUco=;
        b=cO0wLZjG/S6KHlIRRsI5/sKOPi7bLpZGMjRbM5cDWESSOn5/yYKdaPcdXdcLT879jG
         Uu51cymH2A6jz82iyhmUBrKveJlNilR+kpOD+/9F3rpXlJeHSeoIGnxf/bfhUeHwvsi+
         7dO+rI+H1BHoGMgN8hsfUjtrJK8faUEHUESTBBnB2G5SyyBsC6k4mABu0Xkx3CCa/OyG
         A6982o+Oh2da2hYtIeQ/j6I4Juouwi2GduO4GZpPGyyAxevfc6iCzHkpOdxgb8VvU+N7
         D+SW0Mf3Y8VfuU3dybAKgqxCAzE60sFmfFotLp34P7yyh9jwp3CvOlHsflkih0s8cEB+
         Apng==
X-Gm-Message-State: AOAM531eTDKPjX0TQn8q5kw+FZ4XDc2HwZ3aCxY023GNM/DmCFUvrwst
        dQPDzqxpZRnxcTs6FuLDySeQzfoSPymMl1WcmEM=
X-Google-Smtp-Source: ABdhPJzfXlu8h+WqSL6k/XQ0gJO8pKHebaWk/1ATLnGYGzrwf5q05j3N5RdJkj74p5gGUhqdj29yMD+6fnf+WRI66Q4=
X-Received: by 2002:a17:906:4803:: with SMTP id w3mr1728034ejq.316.1590509247324;
 Tue, 26 May 2020 09:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200525181508.13492-1-fw@strlen.de> <20200525181508.13492-3-fw@strlen.de>
In-Reply-To: <20200525181508.13492-3-fw@strlen.de>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Tue, 26 May 2020 09:07:16 -0700
Message-ID: <CALMXkpa8iryjBDu0dpduHnZXROwT5xWWY9rifau93gDE1HJsxg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] mptcp: move recbuf adjustment to recvmsg path
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, May 25, 2020 at 3:19 PM Florian Westphal <fw@strlen.de> wrote:
>
> From: Paolo Abeni <pabeni@redhat.com>
>
> Place receive window tuning in the recvmsg path.
> This makes sure the size is only increased when userspace consumes data.
>
> Previously we would grow the sk receive buffer towards tcp_rmem[2], now we
> so only if userspace reads data.
>
> Simply adjust the msk rcvbuf size to the largest receive buffer of any of
> the existing subflows.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This patch is new in v2.
>
>  net/mptcp/protocol.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index dbb86cbb9e77..89a35c3fc499 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -190,13 +190,6 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
>                 return false;
>         }
>
> -       if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
> -               int rcvbuf = max(ssk->sk_rcvbuf, sk->sk_rcvbuf);
> -
> -               if (rcvbuf > sk->sk_rcvbuf)
> -                       sk->sk_rcvbuf = rcvbuf;
> -       }
> -
>         tp = tcp_sk(ssk);
>         do {
>                 u32 map_remaining, offset;
> @@ -933,6 +926,25 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
>         return moved > 0;
>  }
>
> +static void mptcp_rcv_space_adjust(struct mptcp_sock *msk)
> +{
> +       const struct mptcp_subflow_context *subflow;
> +       struct sock *sk = (struct sock *)msk;
> +       const struct sock *ssk;
> +       int rcvbuf = 0;
> +
> +       if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
> +               return;
> +
> +       mptcp_for_each_subflow(msk, subflow) {
> +               ssk = mptcp_subflow_tcp_sock(subflow);
> +               rcvbuf = max(ssk->sk_rcvbuf, rcvbuf);

tcp_rcv_space_adjust is called even when the app is not yet reading,
thus wouldn't this mean that we still end up with an ever-growing
window?
E.g., imagine an app that does not read at all at the beginning. The
call to tcp_rcv_space_adjust in patch 1/2 will make the subflow's
window grow. Now, the app comes and reads one byte. Then, the window
at MPTCP-level will jump regardless of how much the app actually read.

I think what is needed is to size the MPTCP-level window to 2 x the
amount of data read by the application within an RTT (maximum RTT
among all the active subflows). That way if an app reads 1 byte a
second, the window will remain low. While for a bulk-transfer it will
allow all subflows to receive at full speed [1].

Or do you think that kind of tuning can be done in a follow-up patch?


Christoph

[1]: https://www.usenix.org/system/files/conference/nsdi12/nsdi12-final125.pdf
-> Section 4.2
