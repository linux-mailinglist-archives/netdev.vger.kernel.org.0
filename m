Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1934B55A766
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiFYFsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbiFYFsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:48:18 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A171E205DD;
        Fri, 24 Jun 2022 22:48:17 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-fb6b4da1dfso6505201fac.4;
        Fri, 24 Jun 2022 22:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IfTILB5eXlDVPgIJdz9bz3GF6bYR+K+qjiBY2DrpT28=;
        b=FMtMByBRhEeA6z4IgZ2QYocc2mM7IA0qRZt3haGjxsZRhulnUDhs8XgvO0vW7rRNqo
         lt8BnqtjbNLHEkEvBefK011Is8LdkZXz6keQ6n53UM1o1yd6omTMWY3xapSAUMeZKHhv
         sNtmQCr5atKnqX9CYOUmS1v+3N86swIvStNwrnIj9L1SlwDxDcpz/t2iM0Ri1rare7/S
         gGQu73aF+tW5eFJ5VaS8Qv173iCWWbrkEZKGw4jag/exQl8iNUiGe+WchSXW/NBVR2om
         6mBnEfH9vn3KMUw7RISSIgolw36vhsFBvGxcVtLBPNqRt3NwgcHP2b4U5n0ohMUl09u8
         ZD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IfTILB5eXlDVPgIJdz9bz3GF6bYR+K+qjiBY2DrpT28=;
        b=Uslf5RoAWSWSyOp98+//Itic3bVzUR2L00S++BDcb4QE8Ce6Puuh2zeDC9RAj4m//J
         Q4WjFT0daMyBUTl+KB10MJhqJ4g5IK2GDRgZNt2OFLbIYj0BHnsIUnP/yRdF3uL+UPoP
         rd/XTfvtEaW6ld1j/5LZh2ZGVtZox1EzXGS54gxhAGnIfm0tzktyV6gN/S7k8kbMAWOS
         vxdJgdFxKnUJhBzsDW6Ck8WwVU/mgs0upFZF6yjnVR6wfzfXKFxciFquQ/LSc0ncp2iU
         DbsIaqr9bvrMzF2NSBmHLPMkVAxei3QKdWObEMEqV6dl6j24yOd7ZntTSL/I8XuGRKl2
         T8ug==
X-Gm-Message-State: AJIora8JbkvQT3U5EH4w1gRoQSHr2V3r6e5cP3Aa9NDcXzMgPZ9H+cEk
        PA9CspnKUPwdRkf+ahaN3wYyABgCUfgkBsTzIPw=
X-Google-Smtp-Source: AGRyM1t46n1N/R96oZMiwsy+lj1hF+OXTMt6pNIqCGQoHtjIP9Xik43ybKXp2Cb+Smogmt+IYFfxEpKJDFWri9wo86M=
X-Received: by 2002:a05:6870:f618:b0:f3:cb8:91b with SMTP id
 ek24-20020a056870f61800b000f30cb8091bmr4092815oab.265.1656136096965; Fri, 24
 Jun 2022 22:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220624081254.1251316-1-zys.zljxml@gmail.com> <ad7673eb-ff0d-ce39-e05d-6af3be5ac68c@kernel.org>
In-Reply-To: <ad7673eb-ff0d-ce39-e05d-6af3be5ac68c@kernel.org>
From:   Katrin Jo <zys.zljxml@gmail.com>
Date:   Sat, 25 Jun 2022 13:48:06 +0800
Message-ID: <CAOaDN_S=TyNPTcVrcx9SLLtqrMLbkV31TRQJB4GKKyQCFReKOQ@mail.gmail.com>
Subject: Re: [PATCH] ipv6/sit: fix ipip6_tunnel_get_prl when memory allocation fails
To:     David Ahern <dsahern@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>, eric.dumazet@gmail.com,
        pabeni@redhat.com, katrinzhou <katrinzhou@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 11:12 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 6/24/22 2:12 AM, zys.zljxml@gmail.com wrote:
> > diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> > index c0b138c20992..4fb84c0b30be 100644
> > --- a/net/ipv6/sit.c
> > +++ b/net/ipv6/sit.c
> > @@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
> >               kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
> >               NULL;
> >
> > -     rcu_read_lock();
> > -
> >       ca = min(t->prl_count, cmax);
> >
> >       if (!kp) {
> > @@ -337,11 +335,12 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
> >                                             __GFP_NOWARN);
> >               if (!kp) {
> >                       ret = -ENOMEM;
> > -                     goto out;
> > +                     goto err;
> >               }
> >       }
> >
> >       c = 0;
> > +     rcu_read_lock();
> >       for_each_prl_rcu(t->prl) {
> >               if (c >= cmax)
> >                       break;
> > @@ -362,7 +361,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
> >               ret = -EFAULT;
> >
> >       kfree(kp);
> > -
> > +err:
> >       return ret;
> >  }
> >
>
> 'out' label is no longer used and should be removed.

Thanks for reviewing! I sent the V2 patch, modified according to your
suggestion.
The label is removed, and I still use the label "out" instead of "err".

Best Regards,
Katrin
