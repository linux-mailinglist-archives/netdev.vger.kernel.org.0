Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E92651B05
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 07:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiLTG60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 01:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiLTG6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 01:58:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2869FEB
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671519459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PgjDO6YmPzI6EXFNoVsU/pqgee9rvpcuz0guJ0Z7ptM=;
        b=HyKq6TJtoDqKNvSt6m5NC6yPS5C+nB7ddXoVhHATWcwri50ATIbGMGYspTOG4rxzOxOOU5
        wluF5DcQPurNyhXjrTmxKIqCVCBmfid0auMVtkUnr0SjvhVTf2ZZ5S/piTQmZKKEEwqJGZ
        rTzzVGNPLqFAL20ngQfIYNJdbrdYCPY=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-391-R66Pu1Q4PWOKNFj2t-CoIw-1; Tue, 20 Dec 2022 01:57:38 -0500
X-MC-Unique: R66Pu1Q4PWOKNFj2t-CoIw-1
Received: by mail-ot1-f72.google.com with SMTP id s22-20020a9d7596000000b0066eb4e77127so6659515otk.13
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:57:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PgjDO6YmPzI6EXFNoVsU/pqgee9rvpcuz0guJ0Z7ptM=;
        b=nuSD6Jckf8tEtijRsjmGody7hXgFR5mkGk6RdWlxHdO67I8xZying3p33rqS2KorHc
         jiGj0cqXfgJcYkuCPGODlZVnsl+qVhiwMg8Hj0XvTWnvIK72aluelhvknDfBvw1UHHns
         4Z7JfhFUC3ZiDS8Vh8wB3wopKavBTAIScKXUJbY8vj/AUB2bkK6xyYHbx9VwBFFtDtq+
         g0d+C3MIe9TdN1ol8mX+yr6HhrAFSz7OBSFKPgAhs/0bKpRDblpn43jndyn0FsCpW+Xh
         PjwI3PHH/51L8tLnC0aEQVjNnhVSx0yf94WVKsTGhVOru1lwd0FaftM/F9uRp+RPer0x
         xQ0w==
X-Gm-Message-State: ANoB5pm+ZVyBsl5bVM9nyFrXMnDIBaP68Cg5elQwUe/1xICcCGOoh065
        JsbgbxYKovZ58YXY6H2s3Si5NbHOzUe6k8F4ez53hBn/1Bq2mBsmj6SMsMPGSC2TF8lpEk+GU66
        7BSrCk4WjZ+MhaId7
X-Received: by 2002:aca:d909:0:b0:35b:b20d:53e9 with SMTP id q9-20020acad909000000b0035bb20d53e9mr18301894oig.55.1671519457269;
        Mon, 19 Dec 2022 22:57:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7gU8wXwyG7y7JilikoaWDJ51dcAKEUNsDSYXNSc+a5O4RaE++39oKb2zSEmb0O24Awl74Xdw==
X-Received: by 2002:aca:d909:0:b0:35b:b20d:53e9 with SMTP id q9-20020acad909000000b0035bb20d53e9mr18301862oig.55.1671519456982;
        Mon, 19 Dec 2022 22:57:36 -0800 (PST)
Received: from ?IPv6:2804:431:c7ec:1f35:e7a0:7a03:cbfa:5430? ([2804:431:c7ec:1f35:e7a0:7a03:cbfa:5430])
        by smtp.gmail.com with ESMTPSA id bk22-20020a0568081a1600b003544822f725sm5196652oib.8.2022.12.19.22.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 22:57:36 -0800 (PST)
Message-ID: <c161b52f68adf9c6b3961991ba8fb2f6f96912af.camel@redhat.com>
Subject: Re: [PATCH v2 3/4] sched/isolation: Add HK_TYPE_WQ to
 isolcpus=domain
From:   Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
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
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        fweisbec@gmail.com
Date:   Tue, 20 Dec 2022 03:57:29 -0300
In-Reply-To: <20221129121051.GB1715045@lothringen>
References: <20221013184028.129486-1-leobras@redhat.com>
         <20221013184028.129486-4-leobras@redhat.com>
         <Y0kfgypRPdJYrvM3@hirez.programming.kicks-ass.net>
         <20221014132410.GA1108603@lothringen>
         <7249d33e5b3e7d63b1b2a0df2b43e7a6f2082cf9.camel@redhat.com>
         <20221129121051.GB1715045@lothringen>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-29 at 13:10 +0100, Frederic Weisbecker wrote:
> On Fri, Oct 14, 2022 at 01:27:25PM -0300, Leonardo Br=C3=A1s wrote:
> > Hello Frederic,
> >=20
> > So, IIUC you are removing all flags composing nohz_full=3D parameter in=
 favor of a
> > unified NOHZ_FULL flag.=20
> >=20
> > I am very new to the code, and I am probably missing the whole picture,=
 but I
> > actually think it's a good approach to keep them split for a couple rea=
sons:
> > 1 - They are easier to understand in code (IMHO):=C2=A0
> > "This cpu should not do this, because it's not able to do WQ housekeepi=
ng" looks
> > better than "because it's not in DOMAIN or NOHZ_FULL housekeeping"
>=20
> A comment above each site may solve that.

Sure, but not having to leave comments would be better. Or am I missing
something?

>=20
> >=20
> > 2 - They are simpler for using:=C2=A0
> > Suppose we have this function that should run at a WQ, but we want to k=
eep them
> > out of the isolated cpus. If we have the unified flags, we need to comb=
ine both
> > DOMAIN and NOHZ_FULL bitmasks, and then combine it again with something=
 like
> > cpu_online_mask. It usually means allocating a new cpumask_t, and also =
freeing
> > it afterwards.
> > If we have a single WQ flag, we can avoid the allocation altogether by =
using
> > for_each_cpu_and(), making the code much simpler.
>=20
> I guess having a specific function for workqueues would arrange for it.

You mean keeping a WQ housekeeping bitmap? This could be a solution, but it
would affect only the WQ example.

>=20
> >=20
> > 3 - It makes easier to compose new isolation modes:
> > In case the future requires a new isolation mode that also uses the typ=
es of
> > isolation we currently have implemented, it would be much easier to jus=
t compose
> > it with the current HK flags, instead of having to go through all usage=
s and do
> > a cpumask_and() there. Also, new isolation modes would make (2) worse.
>=20
> Actually having a new feature merged in HK_NOHZ_FULL would make it easier=
 to
> handle as it avoids spreading cpumasks. I'm not sure I understand what yo=
u
> mean.

IIUC, your queued patch merges the housekeeping types HK_TYPE_TIMER,
HK_TYPE_RCU, HK_TYPE_MISC, HK_TYPE_TICK, HK_TYPE_WQ and HK_TYPE_KTHREAD in =
a
single HK_TYPE_NOHZ_FULL.

Suppose in future we need a new isolation feature in cmdline, say=C2=A0
isol_new=3D<cpulist>, and it works exactly like nohz_full=3D<cpulist>, but =
also
needs to isolate cpulist against something else, say doing X.

How would this get implemented? IIUC, following the same pattern:
- A new type HK_TYPE_ISOL_NEW would be created together with a cpumask,
- The new cpumask would be used to keep cpulist from doing X
- All places that use HK_TYPE_NOHZ_FULL bitmap for isolation would need to =
also
bitmask_and() the new cpumask. (sometimes needing a local cpumask_t)

Ok, there may be shortcuts for this, like keeping an intermediary bitmap, b=
ut
that can become tricky.

Other more complex example: New isolation feature isol_new2=3D<cpulist> beh=
aves
like nohz_full=3D<cpulist>, keeps cpulist from doing X, but allows unbound =
RCU
work. Now it's even harder to have shortcuts from previous implementation.

What I am trying to defend here is that keeping the HK_type with the idea o=
f
"things to get cpulist isolated from" works better for future implementatio=
ns
than a single flag with a lot of responsibilities:
- A new type HK_TYPE_X would be created together with a cpumask,
- The new cpumask would be used to keep cpulist from doing X
- isol_new=3D<cpulist> is composed with the flags for what cpulist is getti=
ng
isolated.
- (No need to touch already implemented isolations.)

In fact, I propose that it works better for current implementations also:
The current patch (3/4) takes the WQ isolation responsibility from
HK_TYPE_DOMAIN and focus it in HK_TYPE_WQ, adding it to isolcpus=3D<cpulist=
>
flags. This avoids some cpumask_and()s, and a cpumask_t kzalloc, and makes =
the
code less complex to implement when we need to put isolation in further par=
ts of
the code. (patch 4/4)

I am not sure if I am missing some important point here.=C2=A0
Please let me know if it's the case.=20

>=20
> Thanks.
>=20

Thank you for replying!
Leo

