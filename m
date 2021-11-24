Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A265E45B8DB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhKXLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:10:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhKXLKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:10:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637752034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZRGXHd96vqtDFzNUW34SlRfGeDLSxKeu/DIokJA+gB0=;
        b=AIQch9NixE1QF/kevCFwI+918/JfltwbrpgdrM0+YmZqhtMqIcNpd0Wr8f7zhv6Ww8b6vp
        w4gqeYefiQivIPLYbrXWbfz5vc/0bcTZBCNKfDUB6ZyeGaNP2AE5ioE3pfE5ypMxCeKKyc
        eqTY+9toPzOUC5HsWRBEl8AMAjFLPuM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-faYI2bp5M7qfXzYGhpKlCA-1; Wed, 24 Nov 2021 06:07:13 -0500
X-MC-Unique: faYI2bp5M7qfXzYGhpKlCA-1
Received: by mail-ed1-f72.google.com with SMTP id v22-20020a50a456000000b003e7cbfe3dfeso1970719edb.11
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:07:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZRGXHd96vqtDFzNUW34SlRfGeDLSxKeu/DIokJA+gB0=;
        b=k/7s6PCH7bXeR6X6vsNIQJaHv4NowofWeJ3r/UY5sSIaC2o9hmuXDvvGXt4rmKgEf/
         i4Uzoh+2elfaVcITG9S23JoZI53Xhe42konPEE7V84gcRnQ4B6U3QFy5M9m2J4axpTJt
         JSfk+OVex3bwCFqBESDxsFz2MG9GhL63gdJyqGlJPS9EnakhbhIGA6ToylwD87j/jblk
         llY2L85TmrjDCPEqbJNALsOn5v/BJEujGf1tNgz/kqT4Qdx09RYtI4A6twM7qsypjE6C
         e+YQIDOasRZIsWyFeObLPo9PM8QV6Y8jgdWbXvRVQWJFgiI/6Hz22D2qfL2I9zvtjBci
         ir3g==
X-Gm-Message-State: AOAM532D7MJMplnf43WLv0G92SfRr7a/txTQjS25bl8G11bB6PeORchU
        rwbgbho8F5LfimSez1dRIVHJiObkb+GdYb00ViladGQAGYk+lQpfbvg0/uzeAiu9BpolxrFWYvj
        Z3HoT+sFZr1rR8tYj
X-Received: by 2002:a17:906:eb8a:: with SMTP id mh10mr18403403ejb.198.1637752032236;
        Wed, 24 Nov 2021 03:07:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6Xw/kMLfGUKqgpcf/h8wxF5zPbG5UkU5p9H96fH+Ordo+nPX7k+VOZH48HaVE7abxOsN5ww==
X-Received: by 2002:a17:906:eb8a:: with SMTP id mh10mr18403359ejb.198.1637752031981;
        Wed, 24 Nov 2021 03:07:11 -0800 (PST)
Received: from localhost (net-188-218-25-126.cust.vodafonedsl.it. [188.218.25.126])
        by smtp.gmail.com with ESMTPSA id hd15sm6932086ejc.69.2021.11.24.03.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 03:07:11 -0800 (PST)
Date:   Wed, 24 Nov 2021 12:07:10 +0100
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net v2] net/sched: sch_ets: don't peek at classes beyond
 'nbands'
Message-ID: <YZ4c3kKc1gmRHam9@dcaratti.users.ipa.redhat.com>
References: <ed47959b3abc0d03cb98d65581ac2541fa27b16e.1637674769.git.dcaratti@redhat.com>
 <CAM_iQpWFx_LXCE7YSY4NZdjkyhuhCmngXRqrn1Rze82o5Ffb9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWFx_LXCE7YSY4NZdjkyhuhCmngXRqrn1Rze82o5Ffb9g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Cong, thanks for reviewing!

On Tue, Nov 23, 2021 at 04:44:46PM -0800, Cong Wang wrote:
> On Tue, Nov 23, 2021 at 5:54 AM Davide Caratti <dcaratti@redhat.com> wrote:
> >
> > when the number of DRR classes decreases, the round-robin active list can
> > contain elements that have already been freed in ets_qdisc_change(). As a
> > consequence, it's possible to see a NULL dereference crash, caused by the
> > attempt to call cl->qdisc->ops->peek(cl->qdisc) when cl->qdisc is NULL:
> 
> Where exactly is it set to NULL? In line 688?

yes. At least, yes with the test I'm running to reproduce the crash:

 # tc qdisc add dev ddd0 handle 10: parent 1: ets bands 8 strict 4 priomap 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
 # mausezahn ddd0  -A 10.10.10.1 -B 10.10.10.2 -c 0 -a own -b 00:c1:a0:c1:a0:00 -t udp &
 # tc qdisc change dev ddd0 handle 10: ets bands 4 strict 2 quanta 2500 2500 priomap 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3

> 
> 686         for (i = q->nbands; i < oldbands; i++) {
> 687                 qdisc_put(q->classes[i].qdisc);
> 688                 q->classes[i].qdisc = NULL;
> 689                 q->classes[i].quantum = 0;
> 690                 q->classes[i].deficit = 0;
> 691                 gnet_stats_basic_sync_init(&q->classes[i].bstats);
> 692                 memset(&q->classes[i].qstats, 0,
> sizeof(q->classes[i].qstats));
> 693         }
> 
> If so, your patch is not sufficient as the NULL assignment can happen
> after the check you add here?

I think you are right, thanks for noticing. Probably we can keep this
NULL assignment outside the sch_tree_lock() / sch_tree_unlock(), it's
here since the beginning and it's not harmful.
We can "heal" the active list in ets_qdisc_change() so that it does not
contain elements beyond 'nbands': this is probably better as it doesn't
need to add code to the traffic path.

I will send a v3 soon.
-- 
davide

