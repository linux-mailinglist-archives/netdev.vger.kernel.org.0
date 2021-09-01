Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44C83FE448
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhIAUzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:55:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhIAUzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:55:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630529644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4uv1tLC03ICF5tGoJs0CQIvipf8IlKazsE3GScxLAjs=;
        b=JchLRTnnDlvxcFvz0ME+1G9nkY0lI8Yg6P1uBRBJNPCOAf1TWGG3AM3lEc9dOin4mHxLjy
        zCG/HKBmfqT0KPv7Vguhem6JTpqtpsFrOyIR8/LxLG4VC6Uz8/9oFSvJ0VAdtzgjfG5fpW
        bchGzdz0XqhrSa6P2btY6jeQOI9Q9bc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-gj5R4LFaNMKOIS9upMMPUA-1; Wed, 01 Sep 2021 16:54:02 -0400
X-MC-Unique: gj5R4LFaNMKOIS9upMMPUA-1
Received: by mail-ed1-f70.google.com with SMTP id d25-20020a056402517900b003c7225c36c2so296293ede.3
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4uv1tLC03ICF5tGoJs0CQIvipf8IlKazsE3GScxLAjs=;
        b=DWeqLd1S3Lh5hE9pBeoSLMqGaItdzp/YvalnW/CbIirJaAN6rv2+acKyjz5zu65qnF
         kw6KMQ292apDkfo0yNsGUJFFWtT3tkHg3M2e3fqYW8lbkxQL2btPJpQUw3e5C9Q5ax9p
         egXoyHhMNqOExosp+mdMAqz0f46jdaihD7hyzsbzzRcgs+H9jywwUU3sTxLgL0RI+t34
         7X+UOgtRVLj2cpiL/Pcc4T8wEGOxF8sVkyI6zs4yCiEyjmLk2dYF5spCfnI1QsuNCaiG
         147GD2+uvq6Lv/TQH20ZwFXNip/013GyF7e+HhUltMcnFufNuSchofEhjRA1wNKFdMlR
         lbnQ==
X-Gm-Message-State: AOAM530xblxPI+VOgUGQuQSMJKMlq2NK7JDgdSwlw5Xc0kB29tbotWgE
        LBhqd92mqGpKTeIPsYztPv8i/X17y0+FPGGkXF2yAaTH8X6/9eUog0RpZerh052iCkjRoeN99NI
        yjK6mXBFToNniYNUk
X-Received: by 2002:a05:6402:1e8e:: with SMTP id f14mr1529855edf.15.1630529641456;
        Wed, 01 Sep 2021 13:54:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/FHDA1SHVqPiECNxO14bFUaOkq1FHlhTvk7D/YBTiXwgAOiWkP93OGkZBrNwuSlGlnvb4Xw==
X-Received: by 2002:a05:6402:1e8e:: with SMTP id f14mr1529842edf.15.1630529641265;
        Wed, 01 Sep 2021 13:54:01 -0700 (PDT)
Received: from localhost (net-188-218-11-235.cust.vodafonedsl.it. [188.218.11.235])
        by smtp.gmail.com with ESMTPSA id n18sm375372ejg.36.2021.09.01.13.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:54:00 -0700 (PDT)
Date:   Wed, 1 Sep 2021 22:53:59 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATH net] net/sched: ets: fix crash when flipping from 'strict'
 to 'quantum'
Message-ID: <YS/oZ+f0Nr8eQkzH@dcaratti.users.ipa.redhat.com>
References: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
 <CAM_iQpUryQ8Q9cd9Oiv=hxAgpqfCz=j4E=c=hskbPE2+VB-ZvQ@mail.gmail.com>
 <YS38YB9JTSHeYgJG@dcaratti.users.ipa.redhat.com>
 <CAM_iQpUnR-DvMBSWnagCJg98JMT_nMWNbQ8Ea0kC4yCBcFFRqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUnR-DvMBSWnagCJg98JMT_nMWNbQ8Ea0kC4yCBcFFRqA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 11:16:44AM -0700, Cong Wang wrote:
> On Tue, Aug 31, 2021 at 2:54 AM Davide Caratti <dcaratti@redhat.com> wrote:
> >
> > hello Cong, thanks a lot for looking at this!
> >
> > On Mon, Aug 30, 2021 at 05:43:09PM -0700, Cong Wang wrote:
> > > On Tue, Aug 24, 2021 at 3:34 PM Davide Caratti <dcaratti@redhat.com> wrote:

[...]

> > > > Then, a call to ets_qdisc_reset() will attempt to
> > > > do list_del(&alist) with 'alist' filled with zero, hence the NULL pointer
> > > > dereference.
> > >
> > > I am confused about how we end up having NULL in list head.

[...]

> > So, I can probably send a patch (for net-next, when it reopens) that removes
> > this INIT_LIST_HEAD() line; anyway, its presence is harmless IMO. WDYT?
> 
> Actually I am thinking about the opposite, that is, always initializing the
> list head. ;) Unless we always use list_add*() before list_del(), initializing
> it unconditionally is a correct fix.

uh, maybe I get the point.

we can do a INIT_LIST_HEAD(&cl[i].alist) in ets_qdisc_init() with 'i' ranging
from 0 to TCQ_ETS_MAX_BANDS - 1, then the memset() in [1] needs to be
replaced with something that clears all members of struct ets_class except
'alist'. At this point, the INIT_LIST_HEAD() line in ets_qdisc_change() can be
removed. 

I can re-run the kseltest and eventually send a patch for that (targeting
net-next, no need to rush), is that ok for you?

thanks,

-- 
davide


[1] https://elixir.bootlin.com/linux/v5.14/source/net/sched/sch_ets.c#L690

