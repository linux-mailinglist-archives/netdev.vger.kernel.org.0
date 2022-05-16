Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B64528CD9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbiEPSYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbiEPSYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:24:53 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0418B31935
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:24:53 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2f863469afbso163719827b3.0
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=caY/ESKWlGVtNQPJy/5dJUbX22RpacxqkhwusktZ+V8=;
        b=P3/DA/KTNzr+fgDnUfvlWYFzbHia2d2fUFxweX0ReD+g0+wKSgux+350fOJKscyilm
         7NFlEXsAgKH/MQ0W8S6X6rmxi5hDuLuaADXEni3Jmph0GmTIKCV1foBhAPR/RG6sS3nq
         XL5R9oUBZwmDklcgN8NVi0iqmiaNlFK4qtBwGP0bZkUM726BoFsuMvv5Fn/B0LbVdbpE
         yJTprMDCdmndYRyHAK1rsgoAi0E5cGvlkwDq+TNaeQs8/ukd56zg9MPHKQFwpp9Ez4tn
         J6dp5Vfnepz77goAVD0VHMCva1xb4nNUGdU3KUeKqqWf+610I/qL/HsL+IGYu2qB1cWk
         5Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=caY/ESKWlGVtNQPJy/5dJUbX22RpacxqkhwusktZ+V8=;
        b=1GZ6rcKHNvRFwynfQDnaF8NOc37RD/byXp1/3ry7u9DhPoslUueuOTOpzLjI6ypa4f
         KgrsXgES1C8wWv7dZINGuBpNPzFFlPAKMCib/w/LzOPGItpqvABrPCm1IXUBADMHl1ef
         MywJsfTWUfYrhrvjvGMMAudb9UUragMNfRJGgxH88E2943CjgxQ1JEZbCqfGVTQcKzZF
         z+Rt7DONKPCb4J3ChxG+oTaDrG//TbaV6+5jSLonMXVVQqQGXjaF3/B5hOrH8pWkwLA4
         +fV93UDo5J2U+r+sXiafyEFQjRZMbAJpGSRJNuauPOVbpyhquJ7xc5pLYb58BQt/qSD7
         598g==
X-Gm-Message-State: AOAM532FksNaQEdiWwwujLUEYAG1He4OMDDMM0E+C7u6tbYtfFz/E+N2
        lxZdW0MJ5NmRhzZZyV+bjIEb9Z2UR//tTMSElNw+DrtynBYVBUGT
X-Google-Smtp-Source: ABdhPJw3GVMoIxJSi2cE7Am+mriYIsiLzTkuMrmXhnsdZriBgB3KphGFpYBQ2kT/TbL1Z7G7m8mr5XFjaYY9+NP7hgo=
X-Received: by 2002:a81:6d0a:0:b0:2ff:22d1:d049 with SMTP id
 i10-20020a816d0a000000b002ff22d1d049mr440064ywc.55.1652725491942; Mon, 16 May
 2022 11:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
 <20220516042456.3014395-2-eric.dumazet@gmail.com> <20220516111554.5585a6b5@kernel.org>
In-Reply-To: <20220516111554.5585a6b5@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 May 2022 11:24:40 -0700
Message-ID: <CANn89iJnS5Yyofudjbr7ZO5okRF67w1FRebQ71h3Bg75CA_L+Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: fix possible race in skb_attempt_defer_free()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
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

On Mon, May 16, 2022 at 11:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 15 May 2022 21:24:53 -0700 Eric Dumazet wrote:
> > A cpu can observe sd->defer_count reaching 128,
> > and call smp_call_function_single_async()
> >
> > Problem is that the remote CPU can clear sd->defer_count
> > before the IPI is run/acknowledged.
> >
> > Other cpus can queue more packets and also decide
> > to call smp_call_function_single_async() while the pending
> > IPI was not yet delivered.
> >
> > This is a common issue with smp_call_function_single_async().
> > Callers must ensure correct synchronization and serialization.
> >
> > I triggered this issue while experimenting smaller threshold.
> > Performing the call to smp_call_function_single_async()
> > under sd->defer_lock protection did not solve the problem.
> >
> > Commit 5a18ceca6350 ("smp: Allow smp_call_function_single_async()
> > to insert locked csd") replaced an informative WARN_ON_ONCE()
> > with a return of -EBUSY, which is often ignored.
> > Test of CSD_FLAG_LOCK presence is racy anyway.
>
> If I'm reading this right this is useful for backports but in net-next
> it really is a noop? The -EBUSY would be perfectly safe to ignore?
> Just checking.

Not sure I understand the question.

trigger_rx_softirq() and friends were only in net-next, so there is no
backport needed.

Are you talking of calls from net_rps_send_ipi() ?
These are fine, because we own an atomic bit (NAPI_STATE_SCHED).
