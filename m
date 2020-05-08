Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509E61CB25C
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgEHO5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgEHO5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:57:21 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0150C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 07:57:19 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so10917868wmg.1
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 07:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61WiaUyLJLohGByFYGZu/ePF3tNnUmgEJz3m+fbkvbE=;
        b=qNI59lFL1zg8Wddeechx6IXIu6ZN9ivzmSo6J2VzZqglT/IdoAbC6egHWL2hDJFa2C
         s7XWvbYF2ETkUZK6hNF19YTylbazo02IMWQn+j5/EJ1oG9C2gWWYOEXdlslDb7RFCffV
         knaQvx3834xxTw2pVr51p4wWLfHBQijF5/fTMUKMU4xIQ45hJIXJbwWGdXvZ6iqp85iM
         lRuj6KDpfYYY9KajR823HjTQi3aIujclwLBQBqII3q5hrrbSuIEiQ8OPj8REYiTF1yw1
         3m6bo/Q4mxXcNu3EPpS9iaSNE7LJThbaNkOWNrz6suqKbeco7LNz0puN/ww5iu56Vldr
         1clA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61WiaUyLJLohGByFYGZu/ePF3tNnUmgEJz3m+fbkvbE=;
        b=A6VTpUirD+Lx5OgSiljjrDbVDuRlWmtYNst7JOIK+tXJPneTgo+UxgKdsKakgyyD0/
         MBUEN6xFm4YwnkNCNRG1v4MvLY9NZnKWEc6BAZcQmRsRC5cshEZ0PoVOZDCCCeEuEilY
         tePV8+3BV1taJVDIn4U4xOqyZonPOzRbUjLK/0AyfAWhrJeRV07RZVaYrwrRAJg8pC8x
         kNI+pfVDIWxLTNbW3+eaaMcig7s5KuZPKzQnCrgylq04yxtIUdz2/xw5KX8UQVz9wj+d
         ZB0Bio7v8Zkp2j8PSo0HJypgUqS3Guip+En061Vnid08/3HzrXQoGDSvFFhgrwK15fgM
         I3qg==
X-Gm-Message-State: AGi0PuZvkvfEAzD/q89rFhk976BFjlqnitVCuWJCwBB54Pem6qveWvN3
        bhSFbufGB+FC803c9PPGJ1UeNkDZQDgJHVPKkheriQ==
X-Google-Smtp-Source: APiQypLAuLgh9vHeMnOftCpnzALpfsK4TXssWLT4DEBrPjPq+FO6K828+JXxRktL0ZbQU9s56bAz4ObOXa61S/euW1s=
X-Received: by 2002:a1c:7c13:: with SMTP id x19mr16404970wmc.124.1588949838132;
 Fri, 08 May 2020 07:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
 <20200508142309.11292-1-kelly@onechronos.com> <ec871922-bf92-32cf-c004-846974eed947@gmail.com>
In-Reply-To: <ec871922-bf92-32cf-c004-846974eed947@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 8 May 2020 10:56:42 -0400
Message-ID: <CACSApvaWRxgx_Q1ku=vXbArZc5EJHWhLhCQbzH0+-R3Pzmcf+A@mail.gmail.com>
Subject: Re: [PATCH v3] net: tcp: fix rx timestamp behavior for tcp_recvmsg
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Kelly Littlepage <kelly@onechronos.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, iris@onechronos.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        Mike Maloney <maloney@google.com>,
        netdev <netdev@vger.kernel.org>, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 10:45 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/8/20 7:23 AM, Kelly Littlepage wrote:
> > The stated intent of the original commit is to is to "return the timestamp
> > corresponding to the highest sequence number data returned." The current
> > implementation returns the timestamp for the last byte of the last fully
> > read skb, which is not necessarily the last byte in the recv buffer. This
> > patch converts behavior to the original definition, and to the behavior of
> > the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
> > SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
> > behavior.
> >
> > Fixes: 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
> > Co-developed-by: Iris Liu <iris@onechronos.com>
> > Signed-off-by: Iris Liu <iris@onechronos.com>
> > Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
> > ---
> > Reverted to the original subject line
>
>
> SGTM, thanks.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
