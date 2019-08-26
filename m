Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA909D4D3
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbfHZRSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:18:42 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36966 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfHZRSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 13:18:42 -0400
Received: by mail-ot1-f67.google.com with SMTP id f17so15949914otq.4
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 10:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BNNz2uFnhDixB1BI6O2w8SbNwfqh5iTOEAPHAhOzKG0=;
        b=WOPu9Zl5x3nFalIkJMmsFbF9lB5oWV2A0/cXdBjSudN1isH9CbhlkclKbrcMLtgkpM
         pP7HPCNfFqjq1n7XiK4I3SFceTR9/JruIIO/tpxFq2mgh08/plt2PZMhrQsFknXJG3UI
         NXcS/P/BOvtQQlEfFtMWSlficIGci047O/XHct9Um903R1NkUkSpPfaEYKw/+knn/+GR
         +Pycd6PSkpVq9mX3GKLYICgSPP6cqgJG4i4FcNO8fJaVC1JkzzE2FCjE9EF9qbdKKKpz
         vTCoYw6OozhZnCdeSCN+PJblUDQVf2uDovySBJe82U+FghHlgEn4BPS7QF8sJH+bxRTG
         aSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BNNz2uFnhDixB1BI6O2w8SbNwfqh5iTOEAPHAhOzKG0=;
        b=kjSzGIjq82UUcdM0fWBBONWkuvOS9np7eppyqCE4908JjSQ65HYtdWpvPgraPiiLwH
         Gf7QBH6kwZU9RbI0W59dG69EDyxCb4VmSAaOI6/utUvihRRf1nQrRT2DPapuHTTnyS4W
         r4DwmAFYE9oPmqjCiDTk448eVk+xqG8+zcSGd6fmbLAYnHfNUKDIwgOILcLZekvI0xam
         9UGxvL9MdlvA9g9Imz3vLNd++vWCo+BhW69zr/ww6oxFPsU8Y8XXItAePzZgYqP+YrMJ
         jZLCXhWOqRI2xm2RNbBrgA5Gk1tOc8WJ8gLhX9xNrLpwKg90xdgeZWnwzKvoPu2tWCSo
         PtvQ==
X-Gm-Message-State: APjAAAWrf40LKVU5glPNfaZHOwdFC6zFt01GjF3XHrx07Zo4JZNdO+Io
        AZFOkJGyOWt4EmhPLFtPnCf5E/2ldjpBintF8yo1FA==
X-Google-Smtp-Source: APXvYqwEglNN7fl4rYuoZPch70e6bKR3kBfC6BrLIdbUsD76M243uW46syA00tdUBHHHj8O9qRPHwhvEw9ez7uA2BnA=
X-Received: by 2002:a05:6830:1e05:: with SMTP id s5mr15397669otr.247.1566839921037;
 Mon, 26 Aug 2019 10:18:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190826161915.81676-1-edumazet@google.com>
In-Reply-To: <20190826161915.81676-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 26 Aug 2019 13:18:23 -0400
Message-ID: <CADVnQynhZ3Vr9pC5_id4z5d3Y-RhVr5c-AapbQcVntZ1=DN9YA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: remove empty skb from write queue in error cases
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

On Mon, Aug 26, 2019 at 12:19 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Vladimir Rutsky reported stuck TCP sessions after memory pressure
> events. Edge Trigger epoll() user would never receive an EPOLLOUT
> notification allowing them to retry a sendmsg().
>
> Jason tested the case of sk_stream_alloc_skb() returning NULL,
> but there are other paths that could lead both sendmsg() and sendpage()
> to return -1 (EAGAIN), with an empty skb queued on the write queue.
>
> This patch makes sure we remove this empty skb so that
> Jason code can detect that the queue is empty, and
> call sk->sk_write_space(sk) accordingly.
>
> Fixes: ce5ec440994b ("tcp: ensure epoll edge trigger wakeup when write queue is empty")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky <rutsky@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Nice detective work. :-) Thanks, Eric!

neal
