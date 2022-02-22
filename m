Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068AC4C02D4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiBVUHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbiBVUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:07:43 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C119DB54D9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:07:17 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id b35so15817947ybi.13
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AjnaX+96lqe7LijU9Rl3ogEW4Pg0WWxDUtU2eg0y22Q=;
        b=QuoRQZ9xGDd3kLv1UUcnSJ9VydU7KPF/+yLCDpnbT/rhn9N5skeK0Uwk/vTAPcHOF6
         dggaAIrCWnQ+DQNgV/C0wa1ceLRh7yja3OlPfN2nFrH0aO9CoZh004ZvMl02D02FNWOx
         BQa7fX3eh+iN7b4FB+vR3WV8O91Shcs/uUeTws3cwD0GajmB7X9SBLxxVJMe33vwC2kS
         I9FMIr67qG4hJjpCnnk4V/YL6rb0sPZgceIt4EQdY7FQfV4fOlBsQu8B+d2CE6XHPIsn
         YKR9VGOaNlmQPb5V4m9O57OavxUaYnY9A8fQo4OpAO2jDVQhTrv8Eg/9sPuMCjKrNuMc
         E2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AjnaX+96lqe7LijU9Rl3ogEW4Pg0WWxDUtU2eg0y22Q=;
        b=MnWOBt536YxQyik+n0DsxesiPNQMZo+5TEaEZzY/LNFoqzDRSDQkAVq/K16c94V/KE
         OaG7TIPehMmuNjoNCcM5JfHsytBiwT21VcH1pJubsY1clTO32zCwM5p5QNUMln/X0T/J
         5uTWSegShOd7GEzaR+ZRyrYpQUIbzbONm/1wCVcyEI8/JUN3ilrgjZfu5gFws0jg6ZlV
         Q+GI36htivEZL84yOQTEQGt6PlRvmrEWhpmRODYqRz0iZ3c/BMQNFoEUsGPu1FAJbds0
         3+1ElnD2beu/+wz23lBKWOCCoP+MRKWznwmHW3m+dEAUQTAguzi4TJ7gIOtLNDwrxxG1
         qsBA==
X-Gm-Message-State: AOAM530EYqJQ1lhAJg2CZjZ8sqQColaFG3ChiTun+mNv3fa2Ok9jfdI9
        bS874YL/qgbCReBq7pJDwhVzBpfJb9kUL06SqA9ELg==
X-Google-Smtp-Source: ABdhPJwMkyFR0SUCG3KBZfZtk+rrGhU5lYfT5M5/nEf1SdaEERKaPV5W4dz9u31w/k5niv2/ZjHpFspIWGGLvAfupWs=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr25228544ybe.598.1645560436619; Tue, 22
 Feb 2022 12:07:16 -0800 (PST)
MIME-Version: 1.0
References: <20220222181331.811085-1-eric.dumazet@gmail.com> <20220222194605.GA28705@breakpoint.cc>
In-Reply-To: <20220222194605.GA28705@breakpoint.cc>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Feb 2022 12:07:05 -0800
Message-ID: <CANn89iLz4yML_RktHUadAkU966h9QCRJQ=cMPVzUDU7dHXg0sw@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
To:     Florian Westphal <fw@strlen.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
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

On Tue, Feb 22, 2022 at 11:46 AM Florian Westphal <fw@strlen.de> wrote:
>
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > While kfree_rcu(ptr) _is_ supported, it has some limitations.
> >
> > Given that 99.99% of kfree_rcu() users [1] use the legacy
> > two parameters variant, and @catchall objects do have an rcu head,
> > simply use it.
> >
> > Choice of kfree_rcu(ptr) variant was probably not intentional.
>
> In case someone wondered, this causes expensive
> sycnhronize_rcu + kfree for each removal operation.

This fallback to synchronize_rcu() only happens if kvfree_call_rcu() has been
unable to allocate a new block of memory.

But yes, I guess I would add a Fixes: tag, because we can easily avoid
this potential issue.

Pablo, if not too late:

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")

>
> Reviewed-by: Florian Westphal <fw@strlen.de>
>
