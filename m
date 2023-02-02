Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3FC687EBF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjBBNeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjBBNd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:33:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26741A962
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675344791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JW2l3Xkmr+SXpxgs6dhNgIWsAPA61tpPxWYF/gqOInU=;
        b=RM46jy6h1TI1l5SpeXUfno4pd61IQ3HWuAydXcaWH4gbHKaVMSpVAclkYW3DPveF/WHV6k
        gid4EAykMvoQBZNA0HgX4HNODiSucq54QUBpEEw6ULVz4+pz4bUzfoObMwphtWkkyGZqNK
        ThATEGtI3sTyUvIrlouDBu7erG6KP9Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-449-ZdjOGkiBOaS7bDZnf8yJgA-1; Thu, 02 Feb 2023 08:33:09 -0500
X-MC-Unique: ZdjOGkiBOaS7bDZnf8yJgA-1
Received: by mail-ej1-f71.google.com with SMTP id gz8-20020a170907a04800b0087bd94a505fso1540864ejc.16
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 05:33:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JW2l3Xkmr+SXpxgs6dhNgIWsAPA61tpPxWYF/gqOInU=;
        b=T5R1GutcTz98AuKFhIsLqqXvnVZY3Kk5gr1gHktCPRn6FYeIkX7sN3OL0Ikvin3+IJ
         6PvMh4nc54lSaiZN2XsoOKxIAeEqUkHoQsuquvrqwvaiC/up1jNjGU0hqS+Gdkv1eGZk
         m+0uwpQKw8OrMh5GgUhcVpnMbu6PwhCNF2xJGqVGJLu/xyHligu10JzbWHuQ3nf5E9Xm
         54YW6wX0BdFyNVMR9bwp8MCRXGqzegi7jhZUxH6hBJ+Y6FDK/ncg+GG8KlT8H/G+Tg1G
         3rFyWtUYKzbAZRHYyvzfdlbBmVyf54Ykb0fzZHol2zMzGY7SLT4z2hYYXvj/4mO/H89z
         fnlQ==
X-Gm-Message-State: AO0yUKW+UzFs7G9JVmhfkeSXDuuP7RWsjcKvbkrzK32XyxR1Dc2w9cQF
        EtTUK2bZyb+7HPNP2aigEPwjXU/nNTypK7rX/YjmvuH5ZfHEID9b1jGFIWlk/brKi8JxEdSrVT2
        Bl/xIBZyS9uAgNjGx
X-Received: by 2002:a17:906:4fc7:b0:87b:1be:a8c2 with SMTP id i7-20020a1709064fc700b0087b01bea8c2mr7061934ejw.73.1675344788482;
        Thu, 02 Feb 2023 05:33:08 -0800 (PST)
X-Google-Smtp-Source: AK7set8haZKpnZh1fvKavrZjCqHNzCim4qXT2LuDL914MQ9+7IGhV6t4aAjeoLfRVtPp5HPsJ2AryA==
X-Received: by 2002:a17:906:4fc7:b0:87b:1be:a8c2 with SMTP id i7-20020a1709064fc700b0087b01bea8c2mr7061908ejw.73.1675344788215;
        Thu, 02 Feb 2023 05:33:08 -0800 (PST)
Received: from [10.39.192.164] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id my31-20020a1709065a5f00b0088cf92eb0e1sm3512464ejc.150.2023.02.02.05.33.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Feb 2023 05:33:06 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     =?utf-8?b?6Zm2IOe8mA==?= <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH net-next v3 1/1] net:openvswitch:reduce
 cpu_used_mask memory
Date:   Thu, 02 Feb 2023 14:33:06 +0100
X-Mailer: MailMate (1.14r5939)
Message-ID: <C31998DE-E4B5-4736-9134-8ABBA7F97A31@redhat.com>
In-Reply-To: <OS3P286MB2295485449967D11E7A86A0DF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <OS3P286MB2295FA2701BCE468E367607AF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <561547E5-D4C2-4FD6-9B25-100719D4D379@redhat.com>
 <OS3P286MB22951B162C8A486E39F250BFF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <B3DA2461-65EC-4EDB-8775-C8051CDD5043@redhat.com>
 <OS3P286MB2295485449967D11E7A86A0DF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Feb 2023, at 13:40, =E9=99=B6 =E7=BC=98 wrote:

> Hi, Eelco:
>
>        I have a query regarding to the style check.
> Though the './scripts/checkpatch.pl' emit no warning/error, the 'netdev=
/checkpatch' still has one warning "WARNING: line length of 82 exceeds 80=
 columns"
> I went through the patch line by line and could not find any changed li=
ne exceeding the 80 character limit.
>
> I am afraid that the netdev/checkpatch takes counts on the removed line=
(old removed line has length exceeding 80 and i have revised that in the =
patch already
>
> Is there any known issue regarding to the netdev/checkpatch?

Not sure which netdev/checkpatch you are referring to. I always you the g=
eneral kernel one in /script/checkpatch.pl.


Your patch looks good to me with /script/checkpatch.pl --strict.

> Best regards
>
> eddy
>
> ________________________________
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Eelco Chaudron <echaudro@redhat.com>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2023=E5=B9=B42=E6=9C=882=E6=97=A5=
 11:44
> =E6=94=B6=E4=BB=B6=E4=BA=BA: =E9=99=B6 =E7=BC=98 <taoyuan_eddy@hotmail.=
com>
> =E6=8A=84=E9=80=81: netdev@vger.kernel.org <netdev@vger.kernel.org>; de=
v@openvswitch.org <dev@openvswitch.org>; linux-kernel@vger.kernel.org <li=
nux-kernel@vger.kernel.org>; Eric Dumazet <edumazet@google.com>; Jakub Ki=
cinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Mille=
r <davem@davemloft.net>
> =E4=B8=BB=E9=A2=98: Re: [ovs-dev] [PATCH net-next v3 1/1] net:openvswit=
ch:reduce cpu_used_mask memory
>
>
>
> On 2 Feb 2023, at 12:26, =E9=99=B6 =E7=BC=98 wrote:
>
>> Hi, Eelco:
>>
>>       Thanks for your time going through the detail.
>> The thing is: sizeof(struct cpumask), with default CONFIG_NR_CPUS 8192=
, has a size of 1024 bytes even on a system with only 4 cpus.
>> While in practice the cpumask APIs like cpumask_next and cpumask_set_c=
pu never access more than cpumask_size() of bytes in the bitmap
>> My change used cpumask_size() (in above example, consume 8 bytes after=
 alignement for the cpumask, it saved 1016 bytes for every flow.
>
> I looked at the wrong nr_cpumask_bits definition, so thanks for this ed=
ucation :)
>
>> Your question reminded me to revisit the description "as well as the i=
teration of bits in cpu_used_mask", after a second think, this statement =
is not valid and should be removed.
>> since the iteration API will not access the number of bytes decided by=
 nr_cpu_ids(running CPUs)
>>
>> I will remove this statement after solving a final style issue in the =
next submission.
>
> Thanks!
>
>
>> Thanks
>> eddy
>> ________________________________
>> =E5=8F=91=E4=BB=B6=E4=BA=BA: Eelco Chaudron <echaudro@redhat.com>
>> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2023=E5=B9=B42=E6=9C=882=E6=97=A5=
 11:05
>> =E6=94=B6=E4=BB=B6=E4=BA=BA: Eddy Tao <taoyuan_eddy@hotmail.com>
>> =E6=8A=84=E9=80=81: netdev@vger.kernel.org <netdev@vger.kernel.org>; d=
ev@openvswitch.org <dev@openvswitch.org>; linux-kernel@vger.kernel.org <l=
inux-kernel@vger.kernel.org>; Eric Dumazet <edumazet@google.com>; Jakub K=
icinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Mill=
er <davem@davemloft.net>
>> =E4=B8=BB=E9=A2=98: Re: [ovs-dev] [PATCH net-next v3 1/1] net:openvswi=
tch:reduce cpu_used_mask memory
>>
>>
>>
>> On 2 Feb 2023, at 11:32, Eddy Tao wrote:
>>
>>> Use actual CPU number instead of hardcoded value to decide the size
>>> of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
>>>
>>> 'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
>>> Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
>>> 8192 by default, it costs memory and slows down ovs_flow_alloc
>>> as well as the iteration of bits in cpu_used_mask when handling
>>> netlink message from ofproto
>>
>> I=E2=80=99m trying to understand how this will decrease memory usage. =
The size of the flow_cache stayed the same (actually it=E2=80=99s large d=
ue to the extra pointer).
>>
>> Also do not understand why the iteration is less, as the mask is initi=
alized the same.
>>
>> Cheers,
>>
>> Eelco
>>
>>> To address this, redefine cpu_used_mask to pointer
>>> append cpumask_size() bytes after 'stat' to hold cpumask
>>>
>>> cpumask APIs like cpumask_next and cpumask_set_cpu never access
>>> bits beyond cpu count, cpumask_size() bytes of memory is enough
>>>
>>> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
>>> ---
>>>  net/openvswitch/flow.c       | 8 +++++---
>>>  net/openvswitch/flow.h       | 2 +-
>>>  net/openvswitch/flow_table.c | 8 +++++---
>>>  3 files changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
>>> index e20d1a973417..0109a5f86f6a 100644
>>> --- a/net/openvswitch/flow.c
>>> +++ b/net/openvswitch/flow.c
>>> @@ -107,7 +107,7 @@ void ovs_flow_stats_update(struct sw_flow *flow, =
__be16 tcp_flags,
>>>
>>>                                        rcu_assign_pointer(flow->stats=
[cpu],
>>>                                                           new_stats);=

>>> -                                     cpumask_set_cpu(cpu, &flow->cpu=
_used_mask);
>>> +                                     cpumask_set_cpu(cpu, flow->cpu_=
used_mask);
>>>                                        goto unlock;
>>>                                }
>>>                        }
>>> @@ -135,7 +135,8 @@ void ovs_flow_stats_get(const struct sw_flow *flo=
w,
>>>        memset(ovs_stats, 0, sizeof(*ovs_stats));
>>>
>>>        /* We open code this to make sure cpu 0 is always considered *=
/
>>> -     for (cpu =3D 0; cpu < nr_cpu_ids; cpu =3D cpumask_next(cpu, &fl=
ow->cpu_used_mask)) {
>>> +     for (cpu =3D 0; cpu < nr_cpu_ids;
>>> +          cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>>>                struct sw_flow_stats *stats =3D rcu_dereference_ovsl(f=
low->stats[cpu]);
>>>
>>>                if (stats) {
>>> @@ -159,7 +160,8 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
>>>        int cpu;
>>>
>>>        /* We open code this to make sure cpu 0 is always considered *=
/
>>> -     for (cpu =3D 0; cpu < nr_cpu_ids; cpu =3D cpumask_next(cpu, &fl=
ow->cpu_used_mask)) {
>>> +     for (cpu =3D 0; cpu < nr_cpu_ids;
>>> +          cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>>>                struct sw_flow_stats *stats =3D ovsl_dereference(flow-=
>stats[cpu]);
>>>
>>>                if (stats) {
>>> diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
>>> index 073ab73ffeaa..b5711aff6e76 100644
>>> --- a/net/openvswitch/flow.h
>>> +++ b/net/openvswitch/flow.h
>>> @@ -229,7 +229,7 @@ struct sw_flow {
>>>                                         */
>>>        struct sw_flow_key key;
>>>        struct sw_flow_id id;
>>> -     struct cpumask cpu_used_mask;
>>> +     struct cpumask *cpu_used_mask;
>>>        struct sw_flow_mask *mask;
>>>        struct sw_flow_actions __rcu *sf_acts;
>>>        struct sw_flow_stats __rcu *stats[]; /* One for each CPU.  Fir=
st one
>>> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_tabl=
e.c
>>> index 0a0e4c283f02..dc6a174c3194 100644
>>> --- a/net/openvswitch/flow_table.c
>>> +++ b/net/openvswitch/flow_table.c
>>> @@ -87,11 +87,12 @@ struct sw_flow *ovs_flow_alloc(void)
>>>        if (!stats)
>>>                goto err;
>>>
>>> +     flow->cpu_used_mask =3D (struct cpumask *)&flow->stats[nr_cpu_i=
ds];
>>>        spin_lock_init(&stats->lock);
>>>
>>>        RCU_INIT_POINTER(flow->stats[0], stats);
>>>
>>> -     cpumask_set_cpu(0, &flow->cpu_used_mask);
>>> +     cpumask_set_cpu(0, flow->cpu_used_mask);
>>>
>>>        return flow;
>>>  err:
>>> @@ -115,7 +116,7 @@ static void flow_free(struct sw_flow *flow)
>>>                                          flow->sf_acts);
>>>        /* We open code this to make sure cpu 0 is always considered *=
/
>>>        for (cpu =3D 0; cpu < nr_cpu_ids;
>>> -          cpu =3D cpumask_next(cpu, &flow->cpu_used_mask)) {
>>> +          cpu =3D cpumask_next(cpu, flow->cpu_used_mask)) {
>>>                if (flow->stats[cpu])
>>>                        kmem_cache_free(flow_stats_cache,
>>>                                        (struct sw_flow_stats __force =
*)flow->stats[cpu]);
>>> @@ -1196,7 +1197,8 @@ int ovs_flow_init(void)
>>>
>>>        flow_cache =3D kmem_cache_create("sw_flow", sizeof(struct sw_f=
low)
>>>                                       + (nr_cpu_ids
>>> -                                       * sizeof(struct sw_flow_stats=
 *)),
>>> +                                       * sizeof(struct sw_flow_stats=
 *))
>>> +                                    + cpumask_size(),
>>>                                       0, 0, NULL);
>>>        if (flow_cache =3D=3D NULL)
>>>                return -ENOMEM;
>>> --
>>> 2.27.0
>>>
>>> _______________________________________________
>>> dev mailing list
>>> dev@openvswitch.org
>>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

