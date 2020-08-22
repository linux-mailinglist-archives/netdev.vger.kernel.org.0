Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2F124E4A1
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 04:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgHVCNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 22:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgHVCNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 22:13:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70017C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:13:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z23so1699468plo.8
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jpVs58+8wt1umVjS8q08BQmq+7vcL2HuWLoscQOXeHE=;
        b=BAEWdsVm863Ud5ccdFOkaLOjGWOJ3VUwbXKd5CTJ3+eRnX1IKG29Ip8lAWtYHWO3mg
         jihRZxRVPZ/JCQOxgpzEcbS/tfjllhpr7c3jg7JGy3NgwcZfZ+3NHaQl8ND/PdNuprJo
         u7DbntmgCffdVORQIq0Ch6gOPSCQCTA0o8AXmZbnVlO22Aj8Qc7Q52EtbSy1i4UJHMpR
         LA2KDLi+j5C091lRlW4V6x3MoIWLCArgesmGt3XyraJsCB293VcNuz+QqWH8PH+2mcqg
         MS1sOiBBAsky5I6oF4QgssK517pEQZ/P6WtdDQ0Z4tbYuvB85rF16ZLMDBERHHE5fvdG
         wtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jpVs58+8wt1umVjS8q08BQmq+7vcL2HuWLoscQOXeHE=;
        b=fe3cW/tUlsUOBnaX/bvLssRm6S3eJiK5BJ0LVqn6eqrK6hasiDjADVbMdR8X1UGohR
         h6I7EkV1N/893ASbqOn1m8eE/zL5PCBuCbBqjFNhSCNTSTl/Op+o2vyxjG/vWxIUcT1+
         ccIHWLa8ZrfITPeyvyxjvDsNDjrFq1lTPLM7uph0LApg8ygahsnHvodyy9Q3DSTNtsqY
         Hx/uwxx9F+P4pnQ5/4b0snzC9cp3Uv9sKLcUeQTYr9bQW3xmIeLu3FNKwp3Y4N4qZNNu
         dB5lke7AF4GAJW3BwAvPnH+UstMzev8MvmRkyUp/45kYC9UBnlWK4oslQJuwb2yUB/wi
         O2sQ==
X-Gm-Message-State: AOAM5308E5ui95phG3zKfaKcgMaWB5dv8/1sa/vrY6b2Bfop54Bgoe9w
        /vF9KIuEiy+BePzdk2+OBtOShm7DStiWpOIlS/YOGA==
X-Google-Smtp-Source: ABdhPJzwRT3pmx4dTMXqVSP35m0L5K+hYdQJW9e1j4r7UunHECjXC0U0BQzVJaajfVFYhjs7ek5VzTgSxfA9qUNuInM=
X-Received: by 2002:a17:902:ec02:: with SMTP id l2mr4471777pld.153.1598062427531;
 Fri, 21 Aug 2020 19:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <9abca73b-de63-f69d-caff-ae3ed24854de@kernel.dk>
 <20200822020442.2677358-1-luke.w.hsiao@gmail.com> <20200822020442.2677358-2-luke.w.hsiao@gmail.com>
 <8a2dcf9a-7ccd-f28d-deb4-bda0a4a7a387@kernel.dk>
In-Reply-To: <8a2dcf9a-7ccd-f28d-deb4-bda0a4a7a387@kernel.dk>
From:   Luke Hsiao <lukehsiao@google.com>
Date:   Fri, 21 Aug 2020 19:13:20 -0700
Message-ID: <CADFWnLxQL5_1_E7Pa8tG4aBhY45sOY_PK1ct0kHs1uUbJSKS-A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] io_uring: ignore POLLIN for recvmsg on MSG_ERRQUEUE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jens,

On Fri, Aug 21, 2020 at 7:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/21/20 8:04 PM, Luke Hsiao wrote:
> >
> Sorry, one more minor thing to fix up:
>
> > @@ -4932,6 +4934,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
> >               mask |= POLLIN | POLLRDNORM;
> >       if (def->pollout)
> >               mask |= POLLOUT | POLLWRNORM;
> > +
> > +     /* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
> > +     if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
> > +             mask &= ~POLLIN;
> > +
>
> Don't pass in the sqe here, but use req->sr_msg.msg_flags for this check. This
> is actually really important, as you don't want to re-read anything from the
> sqe.
>
> I'm actually surprised this one got past Jann :-)

Got it, I will make the change and send v3. In Jann's defense, he
reviewed the previous commit, but not this one :). Thanks for your
detailed feedback.

--
Luke
