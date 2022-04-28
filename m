Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AB8513F2C
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353379AbiD1XpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353323AbiD1XpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:45:11 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8775478FCA
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:41:55 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y6so2652886qke.10
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RcZBjBehyHJy4zX115KUPd8okHE++o8u27cKEYI7xUQ=;
        b=rAdN2eUC/uN+mDT5RcIGBbLNwIcjV/C/2YFU3qAoWExkhyJbrTGlEcFKLaNp91cEel
         tC75+YnI65Xc5rurpTVbMFdMRSyHNgqeL0Mix9svIrK8M2gzzl9PKCuAYtHqnb2HL/Dh
         pO1Qu0+71mdJxTIJTPXxsFDISbT2SS5phrRxOGd3dGy3H+Esnl4gGncm370HPOJFV6oI
         Poow/KH7VTUAWW15nfQQH3OU+QXr9NMrJYeWctNJ8fsrBQcNEnJ6nXMIDYmDAqkdWJ3k
         CcsJirBkgTZ3RHM66T+jjhNTj8kpC55+z5Amu3K1j5WFNb7iVxcWSfn8Ny0QDOJtHKmb
         U0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RcZBjBehyHJy4zX115KUPd8okHE++o8u27cKEYI7xUQ=;
        b=aI9zkCL7gMECtz2Qd/909CKpoIj/vVy/MrvGPW6P0nIWmPEcEJ8aFsSd5qZn2h79nw
         kfDOEzzrKxPjDyTSToDRg8SyddHKLlcp/rbi0iEWTC2tn6xGTf481uSBW/ykndCkFGYe
         xFBzSEbLHJxfsMMn370oR3hYz7gYAoMjLlijvxNSiO1s0lRp3rwT8M2G/DA5UF1Riej8
         Uax4/mL3tXdtvHJK1Duq0TIYsPVa3+LQVKbExY7COuleAfKh10QaWMArHkR64Wm+a9HY
         RUCoGMvY06Hmb0LlcYeAlerjD4y7/o3dXXpHPICPxFKlo6LSZnkFG4yQ9ONrTPobYvij
         rApA==
X-Gm-Message-State: AOAM530k+0XtqzVW8Ot4oSpfOcs/4BvMXgVydsJizDHMEEZAkpJ7GD4a
        PY187vcaYbsxtqAow/2QEVB2lwEYCZLJreuDbEKhYMj3N4x9SA==
X-Google-Smtp-Source: ABdhPJzOjCcPq4pdg0PE2Lgh/r28LG5mCtFZsHdkU3F7hpOvXMxLESsQLwoP+9/r+92AP/JlAz9v096+Vc4i/GyyfhI=
X-Received: by 2002:a05:620a:c87:b0:69f:8d43:dbeb with SMTP id
 q7-20020a05620a0c8700b0069f8d43dbebmr6495022qki.296.1651189314383; Thu, 28
 Apr 2022 16:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <2975a359-2422-71dc-db6b-9e4f369cae77@kernel.dk> <CANn89i+RPsrGb1Xgs5GnpAwxgdjnZEASPW0BimTD7GxnFU2sVw@mail.gmail.com>
In-Reply-To: <CANn89i+RPsrGb1Xgs5GnpAwxgdjnZEASPW0BimTD7GxnFU2sVw@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 28 Apr 2022 19:41:38 -0400
Message-ID: <CADVnQymVud=+D7WCZXJCQvhWnzXYhGSxePvEH+SCuuDDK6VoWg@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: pass back data left in socket after receive
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 7:23 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Apr 28, 2022 at 4:13 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > This is currently done for CMSG_INQ, add an ability to do so via struct
> > msghdr as well and have CMSG_INQ use that too. If the caller sets
> > msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
> >
> > Rearrange struct msghdr a bit so we can add this member while shrinking
> > it at the same time. On a 64-bit build, it was 96 bytes before this
> > change and 88 bytes afterwards.
> >
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
>
>
> SGTM, thanks.
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

The patch seems to add an extra branch or two to the recvmsg() fast
path even for the common application use case that does not use any of
these INQ features.

To avoid imposing one of these new extra branches for the common case
where the INQ features are not used, what do folks think about
structuring it something like the following:

               if (msg->msg_get_inq) {
                       msg->msg_inq = tcp_inq_hint(sk);
                       if (cmsg_flags & TCP_CMSG_INQ)
                               put_cmsg(msg, SOL_TCP, TCP_CM_INQ,
                                        sizeof(msg->msg_inq),
                                        &msg->msg_inq);
                }

neal
