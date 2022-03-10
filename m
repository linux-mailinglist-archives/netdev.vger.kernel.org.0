Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E224D4F91
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbiCJQp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiCJQp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:45:58 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DE015A209
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:44:57 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id j2so12152076ybu.0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8cLOGnKW3QWZtUXAjkSLOTcNrzj7enkyf7LmBO93iz0=;
        b=HUyOCKVlHW/6iY04xF87uC60FAJFJ74lzob+MnYm7K5X8a9Fqdh85RNPyltFgozRFQ
         oQNh3WMYWDn6OVVwnovyRp4nu1ZrcV6j506QFDzXkttFMozruew7FPnAquBftLLw+8G9
         5mwAUKxp9nSwgGzgCTYkReBaBoFONRFTschhF0WIzuL9b0TXndZocvzO+s6wYTVFiUZI
         FGpa0wb4WS79Gy6wE1mGCkQW903o+x9d+GPuWr+5K+kDj7ETtFqZYsNRkF9fp4vUHnwK
         URyLREX4K61M7JF+w5QXBDLdPDi2UmQkP/WF6uD7y7MLh7o91cIumOi3SV7wHgnL1DFv
         qlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8cLOGnKW3QWZtUXAjkSLOTcNrzj7enkyf7LmBO93iz0=;
        b=m81608QqLZ8o6coVxyFbH2izl/jur4niDF0Hcx84XIn5D2UcuWPtqm21WX9FTTzGid
         4VXEZVZGA6xbu0Ai4zTOOnh0yJN9USNup7sOgxlfuGmuBcPbjvfqlWReIsBpk+TsLpyb
         96R9NK2te31hMEkS5oWC+783MxKazwPuLw8SUNzKgFGNuq7rcI5EtLQBnx3KFM/b/mnU
         pTEN3wZnpikbZxzdEtJlfY8lqJhW0GEC92OUzKJ4dr8LPMLQHPOzWNqcsa+cH8TdiiB0
         qbC4RQT7xi53tUTqjCYJDVV9sxlcLgYMjJx5KI2IQ0cBCAGVQNoXIuc9aj0zeLzr7flH
         sDag==
X-Gm-Message-State: AOAM530jkklTBnh72/CqcW2s5LfyYNceQzMrFxd9O65g/NiT3xro9p9X
        yn4obSX5y39E/wFD2TZrre+HtBEeAAOV9SCNTq3DOQ==
X-Google-Smtp-Source: ABdhPJwYeKNVRfVgewOBzfJeNN2EfFdrp1IE6sYW/ZvedXswDpLtHxdK6ENHjXNxBEXxEaC5llFcalfjc4+czK5BC84=
X-Received: by 2002:a25:f45:0:b0:628:b4c9:7a9f with SMTP id
 66-20020a250f45000000b00628b4c97a9fmr4569320ybp.55.1646930695799; Thu, 10 Mar
 2022 08:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20220310004603.543196-1-eric.dumazet@gmail.com> <813acfa36558d355e6b56b17bd6bce1c67f77296.camel@redhat.com>
In-Reply-To: <813acfa36558d355e6b56b17bd6bce1c67f77296.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Mar 2022 08:44:44 -0800
Message-ID: <CANn89iL0ygQh3=P22x49-kPsAmMSs4uRRqbGFpk4PFo2GKBPtA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: add per-cpu storage and net->core_stats
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>
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

On Thu, Mar 10, 2022 at 1:26 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Wed, 2022-03-09 at 16:46 -0800, Eric Dumazet wrote:
> > @@ -10282,6 +10282,24 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
> >  }
> >  EXPORT_SYMBOL(netdev_stats_to_stats64);
> >
> > +struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev)
> > +{
> > +     struct net_device_core_stats __percpu *p;
> > +
> > +     p = alloc_percpu_gfp(struct net_device_core_stats,
> > +                          GFP_ATOMIC | __GFP_NOWARN);
> > +
> > +     if (p && cmpxchg(&dev->core_stats, NULL, p))
> > +             free_percpu(p);
> > +
> > +     p = dev->core_stats;
>
> Don't we need a READ_ONCE() here? if the allocation fails (!p) there is
> no memory barrier.

I guess you are right, thanks.
