Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F754AC80F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbiBGR7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346592AbiBGRya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:54:30 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA52C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:54:29 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id y203so1867029yby.11
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+QTT1Fbw38O8F+oxHccgSwSHhvYFU77T78AafO6f8A=;
        b=JwIqzU1X4Y5WwGQD3il0fZVrLr5VSmwBZXyXL9CLxuQYKvY/DxDrf+N3z3R/9iHeij
         +ctxbnwcMnSjAKUiNz9Vy4/dQ0BJ1PU9y4q4sl3U+5GLay3XhTnXAkMLbMSz0lgAFQ46
         NZDL6nZw3tsP6Ws0D3GyFUwATFlRfLiHKGx83U/MWEOSXUGAFtxI0jkPRiY5mmdGMJk/
         hP6VSs/u1XLOdajdiruKQyRe1O0+/8BXSOa9OU4c5xJdO5rynyape1YTi7oipcaR7Zj1
         9gLndtxfBE9G6VQS4GPdqsbPV7HVgHpE0P3ZP2XOg1h9BJSjgYWnQva7OyuOPb75Ahw+
         8jDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+QTT1Fbw38O8F+oxHccgSwSHhvYFU77T78AafO6f8A=;
        b=OWa88qLtbxBvrhRA5ZGgrtwjl7CbUySZ6KFEDmDPBxm9QIs173T0fUmVINFCLsqoHL
         Kiy/tY68GFLPz4oyiNbGRKNXjj0Etg2e4KTUeWAer0nvQ0rvdoXPXxq3fVqVsZz9l0N7
         1H2qw/QoEDqSVk9oWPdxHdd9KGgjcLhPur3fU4HJqqB+aDQ1knobjW5T4F7xjw2S8s+K
         TBoy0TVE7NGOQ+TOvTS0IbSt+058zVTPoYrlVBeARIRw+Lskhv0MLZtMmtY+mBpOY88i
         XWX/FHVWSKK52SCilQMVOolLrxqxg/psyqjlgqnoVKmjO8JO0g1FUoz4lMt/2Wrl1rvV
         S8ew==
X-Gm-Message-State: AOAM533dYgqd3kVB+aCTKQj0VHRXlCI0PG7wG5F/dCp4q3wj/9f0LZvp
        YooML2aotkXP5yjZ927QW/purHyoFQuY6jc6luEkFg==
X-Google-Smtp-Source: ABdhPJzn0uNY6oaGqdO+kPZ4ZvHyLvQV2vdQXTGNNZ1QmiCNQ4MCkei3P3gXknuQitJeT463ZjdZcIM/EeSf9wxV9Ug=
X-Received: by 2002:a25:508b:: with SMTP id e133mr820763ybb.293.1644256468237;
 Mon, 07 Feb 2022 09:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-10-eric.dumazet@gmail.com> <c81703cb-a2b1-4a45-3c5f-0833576f4785@hartkopp.net>
In-Reply-To: <c81703cb-a2b1-4a45-3c5f-0833576f4785@hartkopp.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Feb 2022 09:54:17 -0800
Message-ID: <CANn89iJhf+-myjz0GgTeWmohnoBottRa+nP8DPqM3yoS64cmHQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/11] can: gw: switch cangw_pernet_exit() to
 batch mode
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 9:41 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>
>
>
> On 07.02.22 18:17, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > cleanup_net() is competing with other rtnl users.
> >
> > Avoiding to acquire rtnl for each netns before calling
> > cgw_remove_all_jobs() gives chance for cleanup_net()
> > to progress much faster, holding rtnl a bit longer.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > ---
> >   net/can/gw.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/can/gw.c b/net/can/gw.c
> > index d8861e862f157aec36c417b71eb7e8f59bd064b9..24221352e059be9fb9aca3819be6a7ac4cdef144 100644
> > --- a/net/can/gw.c
> > +++ b/net/can/gw.c
> > @@ -1239,16 +1239,19 @@ static int __net_init cangw_pernet_init(struct net *net)
> >       return 0;
> >   }
> >
> > -static void __net_exit cangw_pernet_exit(struct net *net)
> > +static void __net_exit cangw_pernet_exit_batch(struct list_head *net_list)
> >   {
> > +     struct net *net;
> > +
> >       rtnl_lock();
> > -     cgw_remove_all_jobs(net);
> > +     list_for_each_entry(net, net_list, exit_list)
> > +             cgw_remove_all_jobs(net);
>
> Instead of removing the jobs for ONE net namespace it seems you are
> remove removing the jobs for ALL net namespaces?
>
> Looks wrong to me.

I see nothing wrong in my patch.

I think you have to look more closely at ops_exit_list() in
net/core/net_namespace.c


BTW, the sychronize_rcu() call in cgw_remove_all_jobs is definitely
bad, you should absolutely replace it by call_rcu() or kfree_rcu()

>
> Best regards,
> Oliver
>
>
> >       rtnl_unlock();
> >   }
> >
> >   static struct pernet_operations cangw_pernet_ops = {
> >       .init = cangw_pernet_init,
> > -     .exit = cangw_pernet_exit,
> > +     .exit_batch = cangw_pernet_exit_batch,
> >   };
> >
> >   static __init int cgw_module_init(void)
