Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6484C64F7B3
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 06:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLQFFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 00:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiLQFFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 00:05:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C73C680B9
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 21:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671253455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5U9JSWe0Cb7QSDp7wHEROQEZPSJHdB4ZZYbZ5fNUQg=;
        b=Ih1xEFx5FLepq/1zolwCpkV2BP7C0WJtOL6Xd1AjLhoAeJQcv39ChZNdrMwbfHrockXSiD
        TnBtktEN65QBV+XwMQxIe3izvHgMwYIb0SRAzwuW0etyi/Lp5B1AWAydQEfqNGOeQkIiZm
        RxehtO2mXYRnnKjCySUSHhuVWlP2PDc=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-536-1Jw5xZ3HMW2yaAKhdnSB-Q-1; Sat, 17 Dec 2022 00:04:13 -0500
X-MC-Unique: 1Jw5xZ3HMW2yaAKhdnSB-Q-1
Received: by mail-oo1-f71.google.com with SMTP id x20-20020a4a6214000000b004a36ed7679eso2095717ooc.15
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 21:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U5U9JSWe0Cb7QSDp7wHEROQEZPSJHdB4ZZYbZ5fNUQg=;
        b=v12jY7OVVB3OqnqgfoyQkSHbda/jo/A3+gGcGAsMZB5Clqs2EEIMYPec1kfhEfCLJH
         hMVz90nWaQBguxFA7IMMb1Kh0Zw6Ai2G1IcyCkXdY87JCErI3RXVWYM5YXTYV9mnx56d
         UJsMykfDPZuKl250qAaNbFyckm60SDfY0jR4vQcK/3ciuib/zWowQDbU2DIExUhe3HCN
         ZOlwAGWAGYMAcEAAzkb7dgcs6S632LAzB5aDLAQc9DLx/nvJtiq1+/g3oLEOSNlLn2JU
         UIABKnGhmHBirTtl5fnoAfU3Ufv6AJ5emL/FPiDBFgwQjDbyVuG8Cm4eNKxxJybj5Qc2
         j45Q==
X-Gm-Message-State: ANoB5pkyd6OgcQKTVkluIaTfvHVTQgVi/cvQPPy0iH05+FyDHJ0kDuCz
        E1fi4g30yWXvM42sTFPgSOznEFuKqyionjFfDo77u+RkEXLS01Efc8i3bJUVG+xj0AbooYAiuSd
        6F2qaP8BHf8/8w403
X-Received: by 2002:a05:6830:26c3:b0:670:6c81:6e55 with SMTP id m3-20020a05683026c300b006706c816e55mr17070804otu.3.1671253452560;
        Fri, 16 Dec 2022 21:04:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7OcKfeIWpJo8DQSSLbUY371A1pSB8JS42w8afRBefYfX8GfTKt9XdbGTUa3+d37ndPA7Huog==
X-Received: by 2002:a05:6830:26c3:b0:670:6c81:6e55 with SMTP id m3-20020a05683026c300b006706c816e55mr17070784otu.3.1671253452251;
        Fri, 16 Dec 2022 21:04:12 -0800 (PST)
Received: from ?IPv6:2804:1b3:a803:128a:7e6a:b702:e62d:3eea? ([2804:1b3:a803:128a:7e6a:b702:e62d:3eea])
        by smtp.gmail.com with ESMTPSA id g17-20020a9d6b11000000b00660e833baddsm1768808otp.29.2022.12.16.21.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 21:04:11 -0800 (PST)
Message-ID: <5bf73d21c03d4a642eb81de35544a4d6cfa9294c.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] sched/isolation: Improve documentation
From:   Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Date:   Sat, 17 Dec 2022 02:04:03 -0300
In-Reply-To: <20221129115439.GA1715045@lothringen>
References: <20221013184028.129486-1-leobras@redhat.com>
         <20221013184028.129486-3-leobras@redhat.com>
         <20221129115439.GA1715045@lothringen>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-29 at 12:54 +0100, Frederic Weisbecker wrote:
> On Thu, Oct 13, 2022 at 03:40:27PM -0300, Leonardo Bras wrote:
> > Improve documentation on housekeeping types and what to expect from
> > housekeeping functions.
> >=20
> > Signed-off-by: Leonardo Bras <leobras@redhat.com>
> > ---
> >  include/linux/sched/isolation.h | 25 ++++++++++++++++---------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isol=
ation.h
> > index 762701f295d1c..9333c28153a7a 100644
> > --- a/include/linux/sched/isolation.h
> > +++ b/include/linux/sched/isolation.h
> > @@ -7,18 +7,25 @@
> >  #include <linux/tick.h>
> > =20
> >  enum hk_type {
> > -	HK_TYPE_TIMER,
> > -	HK_TYPE_RCU,
> > -	HK_TYPE_MISC,
> > -	HK_TYPE_SCHED,
> > -	HK_TYPE_TICK,
> > -	HK_TYPE_DOMAIN,
> > -	HK_TYPE_WQ,
> > -	HK_TYPE_MANAGED_IRQ,
> > -	HK_TYPE_KTHREAD,
> > +	HK_TYPE_TIMER,		/* Timer interrupt, watchdogs */
>=20
> More precisely:
>=20
>      /* Unbound timer callbacks */
>=20
> > +	HK_TYPE_RCU,		/* RCU callbacks */
>=20
> More generally, because it's more than just about callbacks:
>=20
>      /* Unbound RCU work */

Both updated, thanks!

Out of curiosity, what does 'Unbound' means in this context?

>=20
> > +	HK_TYPE_MISC,		/* Minor housekeeping categories */
> > +	HK_TYPE_SCHED,		/* Scheduling and idle load balancing */
> > +	HK_TYPE_TICK,		/* See isolcpus=3Dnohz boot parameter */
>=20
> Yes or nohz_full=3D
>=20
> > +	HK_TYPE_DOMAIN,		/* See isolcpus=3Ddomain boot parameter*/
> > +	HK_TYPE_WQ,		/* Work Queues*/
>=20
>   /* Unbound workqueues */
>=20
> > +	HK_TYPE_MANAGED_IRQ,	/* See isolcpus=3Dmanaged_irq boot parameter */
> > +	HK_TYPE_KTHREAD,	/* kernel threads */
>=20
>   /* Unbound kernel threads */
>=20
>=20
> >  	HK_TYPE_MAX
> >  };
> > =20
> > +/* Kernel parameters like nohz_full and isolcpus allow passing cpu num=
bers
> > + * for disabling housekeeping types.
> > + *
> > + * The functions bellow work the opposite way, by referencing which cp=
us
> > + * are able to perform the housekeeping type in parameter.
> > + */
>=20
> *below
>=20
> Thanks!

Done, done, done, done.
Thanks a lot for reviewing!

Best regards,
Leo

>=20
> > +
> >  #ifdef CONFIG_CPU_ISOLATION
> >  DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
> >  int housekeeping_any_cpu(enum hk_type type);
> > --=20
> > 2.38.0
> >=20
>=20

