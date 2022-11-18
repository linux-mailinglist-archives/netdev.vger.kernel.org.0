Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814FE62EA2B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiKRAYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiKRAYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:24:03 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED4167F68
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:24:01 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id a27so2230868qtw.10
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQALVvBpG9Tgm4QJd1bZefWDruQZ7+FZQSohOhIfB6E=;
        b=WdVSFjUXoLnDIwsaQd/YCFQYOfKxlJH+t+28yswVvhFD8+/5OsWHv3c1mXajHuV7TN
         FB8/dQlrzdu9V/hdN5EfH52HdApuaiULyJCJHTWp/BL0H8/WaFqlz1coGPm6H+qr8P8h
         qgR+O7JetxtHeRm8yq7fn2IdswK27/UJQM/LQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQALVvBpG9Tgm4QJd1bZefWDruQZ7+FZQSohOhIfB6E=;
        b=wNZApNN6tzrP2ymA/cydIXYiVqvinitscE3Xo6+GIHLiSnkHZ1iR1uLRmDAsI0rkg1
         /xQbBEmxdOCqV0axm2Aud6rFfZhgipjD8i89DaesvXBzxqeGjZqaDpLEsNa4hKqJQ8IF
         +dqzfnQgb5Szy2DJa1TeA6ScrKBiRZOcaEy75dvPaMRoAlFhBqleWOKpIvIRac/sUo5f
         HHbLih1+Zac4NvwxnboU9rDgkuUD2uWme0mNHXo3nTHl8RzJAStWvxshZK9/OE621Xf+
         1mna39J3gc0m7DhugYsVB8mNBlmWSxN2rSasO/iqYWr6gKheLFyPZjrVa1J6EkHOpO4b
         z7qA==
X-Gm-Message-State: ANoB5pnuAvcNB091mQtFO0jGXwqoq4Bg+XGEy0JO6oSF5x6KaqNfzIfB
        kPCPet/m/Vwg3aMadN0ogCx9ZA==
X-Google-Smtp-Source: AA0mqf5+rcoA5TgBVpqXybDxHbeal+yxGKYtKjh3sTqi9/GyE+4DuAC4zmbWbWOTZCcBVwClObMadA==
X-Received: by 2002:a05:622a:428e:b0:3a5:5a43:b36b with SMTP id cr14-20020a05622a428e00b003a55a43b36bmr4654919qtb.407.1668731040558;
        Thu, 17 Nov 2022 16:24:00 -0800 (PST)
Received: from localhost (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id i15-20020a05620a248f00b006fa9d101775sm1476838qkn.33.2022.11.17.16.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 16:23:59 -0800 (PST)
Date:   Fri, 18 Nov 2022 00:23:59 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH rcu/dev 1/3] net: Use call_rcu_flush() for qdisc_free_cb
Message-ID: <Y3bQn3o1A4KFp7qV@google.com>
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <CANn89iJuy=PuAiwrjF3qZY0M+86eRQ=o_x-m-eoxOdyAM8yoSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJuy=PuAiwrjF3qZY0M+86eRQ=o_x-m-eoxOdyAM8yoSg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 01:44:12PM -0800, Eric Dumazet wrote:
> On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
> >
> > In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> > causes a networking test to fail in the teardown phase.
> >
> > The failure happens during: ip netns del <name>
> >
> > Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> > call_rcu_flush() to revert to the old behavior. With that, the test passes.
> >
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> >  net/sched/sch_generic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> > index a9aadc4e6858..63fbf640d3b2 100644
> > --- a/net/sched/sch_generic.c
> > +++ b/net/sched/sch_generic.c
> > @@ -1067,7 +1067,7 @@ static void qdisc_destroy(struct Qdisc *qdisc)
> >
> >         trace_qdisc_destroy(qdisc);
> >
> > -       call_rcu(&qdisc->rcu, qdisc_free_cb);
> > +       call_rcu_flush(&qdisc->rcu, qdisc_free_cb);
> >  }
> 
> I took a look at this one.
> 
> qdisc_free_cb() is essentially freeing : Some per-cpu memory, and the
> 'struct Qdisc'
> 
> I do not see why we need to force a flush for this (small ?) piece of memory.

Indeed! Just tested and dropping this one still makes the test pass.

I believe this patch was papering over the issues fixed by the other
patches, so it stuck.

I will drop this one and move over to trying your suggestions for 2/3.

Thanks for taking a look,

 - Joel

