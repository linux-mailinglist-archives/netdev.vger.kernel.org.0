Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F315F52E3
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiJEKu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiJEKu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:50:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B4E3206B
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 03:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664967025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oFerFBpu3zyWi8AgGq9KLXwjFZX5iV1UxIObpSC5yY4=;
        b=NXHyO30mlduYgVDyWFAUPLTv759pAsNnstRSiMo3uRtAAyYdP7ci7kWPV6ZLYOxXy5Kqw1
        hv20H7B5Ems563t3zPTPG3oGOdjnCmg5nF/P9pauMcLEgkNmkKzdJr8TWYX7JDQvauJq90
        pxHfpzYm4+BFXfuokKO9YD4E5Q8plBk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-484-Tyjz0J7-M3OKbffesiv34w-1; Wed, 05 Oct 2022 06:50:16 -0400
X-MC-Unique: Tyjz0J7-M3OKbffesiv34w-1
Received: by mail-ej1-f71.google.com with SMTP id dt13-20020a170907728d00b007825956d979so6343555ejc.15
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 03:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=oFerFBpu3zyWi8AgGq9KLXwjFZX5iV1UxIObpSC5yY4=;
        b=QbY4/JRmNvKQ2Daztb4jGU2mJT1gowHZPdtdg/U/wK1QdD2Mb3jT9un9itHWTfor3b
         NOwSBDG2eO4KYuTqKH1daPUjhHQAPH5ntQ3vCKRdywvFSeEDBZZiMzknE6tGQ6i9rUic
         5qQbhu85fMeMbSWD2BPGTrS+2gPIcEKeOnbhdHwseRRdh3j1I0otrXTCs+Z5OvnJoAMU
         +DaO9ZXWrSXAZfjfRfcrHqptAswcN9ZXisnL7cWQvpPevu+zJ2+TpYm8qj6bb9HBYYmv
         Axt5OeH69IQo3N1YqpfVUET3hBegX8G7YlkuCtZ9WcF3PzfKonI5bBXGOFKCXoam/+zU
         OheQ==
X-Gm-Message-State: ACrzQf1sNNwAo0SpcJnMv2MFSucBZSmwqVkN7jk2y2+Efp0WIbNQoBA8
        A56VUYGGOgPT0vrNChvn8BJMVtarCnaJhNqnJt/pZA3Ox1efbiOHlcXuVaTmzTI59oa3LN2Oqn7
        9UrUPM4gAcefK4G2K
X-Received: by 2002:a05:6402:42d0:b0:457:d16e:283d with SMTP id i16-20020a05640242d000b00457d16e283dmr27795528edc.395.1664967015362;
        Wed, 05 Oct 2022 03:50:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5upJ27hR9QUed4F3KdHMtkYbEQG19fYKKcP/aFBy5d7N4mlSHVnW+ff5VYCPSPsG6tI6oGJw==
X-Received: by 2002:a05:6402:42d0:b0:457:d16e:283d with SMTP id i16-20020a05640242d000b00457d16e283dmr27795505edc.395.1664967014970;
        Wed, 05 Oct 2022 03:50:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a17-20020a056402169100b00457607603f9sm3476418edv.67.2022.10.05.03.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 03:50:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AA86364EB83; Wed,  5 Oct 2022 12:50:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     sdf@google.com, Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, joe@cilium.io,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
In-Reply-To: <YzzWDqAmN5DRTupQ@google.com>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <YzzWDqAmN5DRTupQ@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 05 Oct 2022 12:50:13 +0200
Message-ID: <878rluily2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdf@google.com writes:

>>   	struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
>> -		__u32		target_fd;	/* container object to attach to */
>> +		union {
>> +			__u32	target_fd;	/* container object to attach to */
>> +			__u32	target_ifindex; /* target ifindex */
>> +		};
>>   		__u32		attach_bpf_fd;	/* eBPF program to attach */
>>   		__u32		attach_type;
>>   		__u32		attach_flags;
>> -		__u32		replace_bpf_fd;	/* previously attached eBPF
>
> [..]
>
>> +		union {
>> +			__u32	attach_priority;
>> +			__u32	replace_bpf_fd;	/* previously attached eBPF
>>   						 * program to replace if
>>   						 * BPF_F_REPLACE is used
>>   						 */
>> +		};
>
> The series looks exciting, haven't had a chance to look deeply, will try
> to find some time this week.
>
> We've chatted briefly about priority during the talk, let's maybe discuss
> it here more?
>
> I, as a user, still really have no clue about what priority to use.
> We have this problem at tc, and we'll seemingly have the same problem
> here? I guess it's even more relevant in k8s because internally at G we
> can control the users.
>
> Is it worth at least trying to provide some default bands / guidance?
>
> For example, having SEC('tc/ingress') receive attach_priority=124 by
> default? Maybe we can even have something like 'tc/ingress_first' get
> attach_priority=1 and 'tc/ingress_last' with attach_priority=254?
> (the names are arbitrary, we can do something better)
>
> ingress_first/ingress_last can be used by some monitoring jobs. The rest
> can use default 124. If somebody really needs a custom priority, then they
> can manually use something around 124/2 if they need to trigger before the
> 'default' priority or 124+124/2 if they want to trigger after?
>
> Thoughts? Is it worth it? Do we care?

I think we should care :)

Having "better" defaults are probably a good idea (so not everything
just ends up at priority 1 by default). However, I think ultimately the
only robust solution is to make the priority override-able. Users are
going to want to combine BPF programs in ways that their authors didn't
anticipate, so the actual priority the programs run at should not be the
sole choice of the program author.

To use the example that Daniel presented at LPC: Running datadog and
cilium at the same time broke cilium because datadog took over the
prio-1 hook point. With the bpf_link API what would change is that (a)
it would be obvious that something breaks (that is good), and (b) it
would be datadog that breaks instead of cilium (because it can no longer
just take over the hook, it'll get an error instead). However, (b) means
that the user still hasn't gotten what they wanted: the ability to run
datadog and cilium at the same time. To do this, they will need to be
able to change the priorities of one or both applications.

I know cilium at least has a configuration option to change this
somewhere, but I don't think relying on every BPF-using application to
expose this (each in their own way) is a good solution. I think of
priorities more like daemon startup at boot: this is system policy,
decided by the equivalent of the init system (and in this analogy we are
currently at the 'rc.d' stage of init system design, with the hook
priorities).

One way to resolve this is to have a central daemon that implements the
policy and does all the program loading on behalf of the users. I think
multiple such daemons exist already in more or less public and/or
complete states. However, getting everyone to agree on one is also hard,
so maybe the kernel needs to expose a mechanism for doing the actual
overriding, and then whatever daemon people run can hook into that?

Not sure what that mechanism would be? A(nother) BPF hook for overriding
priority on load? An LSM hook that rewrites the system call? (can it
already do that?) Something else?

Oh, and also, in the case of TC there's also the additional issue that
execution only chains to the next program if the current one returns
TC_ACT_UNSPEC; this should probably also be overridable somehow, for the
same reasons...

-Toke

