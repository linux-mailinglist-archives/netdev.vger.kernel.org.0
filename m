Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B23B4B6044
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 02:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiBOByt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 20:54:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiBOByr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 20:54:47 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BD4140746
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 17:54:39 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id c6so51679346ybk.3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 17:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vFYaDdkIjhMO7rBTFVS90E5N1k4Co67hfKj4tLMNWu4=;
        b=gMRV+b5HkSMpAzELYBlO64eH33J72kNUYWJPU7n4ar46Ch8CweSi+WT9ix21FjI5LL
         U8sce0kkLS8vnAtWKmCSyIKtUMEtxNxfpyiBDT9QG5XQrD9ynts8t8gw4xYoMPmRgMPA
         Gv2lLj4gTvriyrnVZeiKSqMxwp6zNblXHsBlm36Qk/vse7t2mHvkxNC+qCnt2EYedFNs
         4dm3oiEgoQ9biVUuPtXDFGs5xcEAa1aKJCNvvLKqFYlaIkjvXoUw1asntunQTZxoB/Dv
         n/r7N9FiZe0ZL+KI2yp4FJIYwoe7jiDrY2Lgm9gj+1vCtv4Egv0XqZPGWvAOcCvykzT3
         tZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vFYaDdkIjhMO7rBTFVS90E5N1k4Co67hfKj4tLMNWu4=;
        b=xcNLI3zlVCP1sgpK1gMZe1g41L+KQNeJ+xITkxEr+2JWuY30olOoIugyUNHQGyvC0T
         k4BWHxUOYWh4q2iXTsHDM+tVUPDgHMSH5FhbEvUh+27jJ6zm6EO1FXibJ0c60lTAL1vy
         R/TsnqQC4TZurBMGgOxX/kFbot5p8MlvNehQY+EPPsQcnOio4mVKJtXCcxe0dS9xo7KK
         W2sr1SZirY4lrWKbvY+qsfv8OyLkW2/QvJ3/bHrBNX4dd7v+I7Co/1/0KYQy2AMXxPd/
         Vy47CFVlOP0EDIP4wQzOuVYJg/v59tohSuqBj8EjiHasLJxV2c7ih3U32BRM6BPBTecD
         Z1rQ==
X-Gm-Message-State: AOAM530BIe5g/+6eKx/O9Se6ekkAk9gZ5z8seUiwN3J1ECRHowLutBwB
        Ll0NQ7xxC5DT67Yey4aHSoskQnyrMFPGyb9SKWuEdw==
X-Google-Smtp-Source: ABdhPJwak8rK/4vx5AH8HW/kN2ZPGka3kBcybd57bQud8oKAOWATyt9qB0AaKTgTLSYIzxLBeNaKIjOo/Y0MH8FU8Ik=
X-Received: by 2002:a25:508b:: with SMTP id e133mr1815788ybb.293.1644890078077;
 Mon, 14 Feb 2022 17:54:38 -0800 (PST)
MIME-Version: 1.0
References: <20220214203434.838623-1-eric.dumazet@gmail.com> <YgsE30gfoQkruTYS@pop-os.localdomain>
In-Reply-To: <YgsE30gfoQkruTYS@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 14 Feb 2022 17:54:27 -0800
Message-ID: <CANn89i+2KYH+DKrNPttbmrvx992P+ufgo=QWyvr1Ku6b=1BY0Q@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: limit TC_ACT_REPEAT loops
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        syzbot <syzkaller@googlegroups.com>
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

On Mon, Feb 14, 2022 at 5:41 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Feb 14, 2022 at 12:34:34PM -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > index 32563cef85bfa29679f3790599b9d34ebd504b5c..b1fb395ca7c1e12945dc70219608eb166e661203 100644
> > --- a/net/sched/act_api.c
> > +++ b/net/sched/act_api.c
> > @@ -1037,6 +1037,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
> >  restart_act_graph:
> >       for (i = 0; i < nr_actions; i++) {
> >               const struct tc_action *a = actions[i];
> > +             int repeat_ttl;
> >
> >               if (jmp_prgcnt > 0) {
> >                       jmp_prgcnt -= 1;
> > @@ -1045,11 +1046,17 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
> >
> >               if (tc_act_skip_sw(a->tcfa_flags))
> >                       continue;
> > +
> > +             repeat_ttl = 10;
>
> Not sure if there is any use case of repeat action with 10+ repeats...
> Use a sufficiently larger one to be 100% safe?

I have no idea of what the practical limit would be ?

100, 1000, time limit ?


>
> >  repeat:
> >               ret = a->ops->act(skb, a, res);
> > -             if (ret == TC_ACT_REPEAT)
> > -                     goto repeat;    /* we need a ttl - JHS */
> > -
> > +             if (unlikely(ret == TC_ACT_REPEAT)) {
> > +                     if (--repeat_ttl != 0)
> > +                             goto repeat;
> > +                     /* suspicious opcode, stop pipeline */
>
> This comment looks not match and unnecessary?

This is copied from the comments found in the following lines.

/* faulty opcode, stop pipeline */
and
else /* faulty graph, stop pipeline */

To me it is not clear why we return TC_ACT_OK and not TC_ACT_SHOT for
' faulty opcode/graph '


>
> > +                     pr_err_once("TC_ACT_REPEAT abuse ?\n");
>
> Usually we use net_warn_ratelimited().

Yep
