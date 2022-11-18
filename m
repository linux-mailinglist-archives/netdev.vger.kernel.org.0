Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A946962EAC7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 02:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbiKRBN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 20:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240442AbiKRBMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 20:12:48 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BA485ECF
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:12:44 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id e189so2812310iof.1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1nEQgHnJ3mToQ4Y8AU47leGp2bx85OsCS3Yng1ByM5g=;
        b=jAiUM6n8fPzCk4etsLh5vHbzmAphcNVgk2NYTsSycCua2b0xBeQb7Cz/19byCflgsy
         X5AXgnMMBgg108CFB6nt6M2AzlTkf5g84Pq8nlXb8twtab7av3lSIlSowzqG2CH6CSNB
         MILL514zNmYNHE22FYO4GTdBsfD3SvqxuJplhzHnBU4qzpScYjksDrF9eX1+YIevib1F
         tiDUZaJygCJ3DGCcUm4hYlCBH81UZn/3Mv0fKWV1pBJqaifilkaG3tIAk2yZ7PPzjDw3
         SGfdFXFMKhkL0MlH25j/NumiiZ05+lZLrR3lzxoVZCKt/ueCK4lAnnpS8VDp9NpTRKWf
         8Jyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1nEQgHnJ3mToQ4Y8AU47leGp2bx85OsCS3Yng1ByM5g=;
        b=nCUDQJ52JvXaN58qSjlygMIlcSYbaoDZTuYDvua0M0NPDeU8bCn8F8w4Z+IcK8YZlp
         WypCutvJmQTVgtvdWoS65A4iIEqYdEQZAycWymi6DihjCQwj+Sus1CvChGLck4TpqGm2
         /s2XQhrYhkKO42dHczyu/byg9B5vIZmeG648v+jAVQ9Gb7jbVwChBdpL8GbyAiTjvg0R
         X+XJBrGgn/L9s/a3ao1k/h0wyMq+19U2kZaYhxHHYpHAyYgI46sbe2LveV2TXqFztOIw
         95W2tulFpvsaz98xNXSLN6QQbNHthHvHuY1uuwLt4lVHIkG8DJslO79Gngyq0tvw+ePC
         9iTw==
X-Gm-Message-State: ANoB5pkj98PZENh5EnAulJkgnCtLyL4yFe46JV3zc1HsSs6HiN/Hagbv
        fzXhWA6Wh9foiKQ4u0ga18tgNdvGUhEOaWQ1q/I+bg==
X-Google-Smtp-Source: AA0mqf5t6BPijE6Cc+oI0fl/UCvTRQdEtwuBuJlZz84oIjqUP+6zOJnmDeGn5HJoc24bCjz4DjGCNms/n4Wk7x6yd8g=
X-Received: by 2002:a5d:8f84:0:b0:6d9:56fc:ef25 with SMTP id
 l4-20020a5d8f84000000b006d956fcef25mr2517540iol.56.1668733963791; Thu, 17 Nov
 2022 17:12:43 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <20221117031551.1142289-2-joel@joelfernandes.org> <CANn89iK345JjXoCAPYK6hZF99zBBWRM1z7xCWbstQJLb4aBGQg@mail.gmail.com>
 <Y3bXXYOeZQPkhQmP@google.com>
In-Reply-To: <Y3bXXYOeZQPkhQmP@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 17:12:32 -0800
Message-ID: <CANn89iKKr87hr4gAyHeK_uw9pK2QPg4oAE_JXUu=WHc8o9D-JQ@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 2/3] net: Use call_rcu_flush() for in_dev_rcu_put
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com
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

On Thu, Nov 17, 2022 at 4:52 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> Hi Eric,
>
> On Thu, Nov 17, 2022 at 01:58:18PM -0800, Eric Dumazet wrote:
> > On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> > <joel@joelfernandes.org> wrote:
> > >
> > > In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> > > causes a networking test to fail in the teardown phase.
> > >
> > > The failure happens during: ip netns del <name>
> > >
> > > Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> > > call_rcu_flush() to revert to the old behavior. With that, the test passes.
> > >
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > ---
> > >  net/ipv4/devinet.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> > > index e8b9a9202fec..98b20f333e00 100644
> > > --- a/net/ipv4/devinet.c
> > > +++ b/net/ipv4/devinet.c
> > > @@ -328,7 +328,7 @@ static void inetdev_destroy(struct in_device *in_dev)
> > >         neigh_parms_release(&arp_tbl, in_dev->arp_parms);
> > >         arp_ifdown(dev);
> > >
> > > -       call_rcu(&in_dev->rcu_head, in_dev_rcu_put);
> > > +       call_rcu_flush(&in_dev->rcu_head, in_dev_rcu_put);
> > >  }
> >
> > For this one, I suspect the issue is about device refcount lingering ?
> >
> > I think we should release refcounts earlier (and only delegate the
> > freeing part after RCU grace period, which can be 'lazy' just fine)
> >
> > Something like:
>
> The below diff where you reduce refcount before RCU grace period, also makes the
> test pass.
>
> If you are Ok with it, I can roll it into a patch with your Author tag and my
> Tested-by. Let me know what you prefer?
>
> Also, looking through the patch, I don't see any issue. One thing is
> netdev_put() now happens before a grace period, instead of after. But I don't
> think that's an issue.

Normally the early netdev_put() is fine, because these netdev are
already fully RCU protected.

Sure, feel free to take this patch as is, thanks.
