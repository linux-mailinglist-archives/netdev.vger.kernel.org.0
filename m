Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA693A7DAB
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFOL46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:56:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229869AbhFOL46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:56:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623758093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r9ZcD21ZX/ou29BDDRauVXqm9CpSppybq1/8AzdM/BE=;
        b=gG6V+WFX8+0Hrii7fxCmUn2gb58wWJMswXbgbRlDjF3gh+C4vJh5Ik++7mJyyUTlH4rKSo
        6MuO7SZXL+lJt4Kww/4BYuFOQk2LfEWhd07NiU+A8v2K3jgTwsmH3G7e3v9u/sTnZ8k41z
        yKJxSt/hYkwD9FsUtobVGgZUUCurhrw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-4a4qhcq_NQ-ZfcQOfifJig-1; Tue, 15 Jun 2021 07:54:52 -0400
X-MC-Unique: 4a4qhcq_NQ-ZfcQOfifJig-1
Received: by mail-ed1-f71.google.com with SMTP id y16-20020a0564024410b0290394293f6816so4688638eda.20
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 04:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=r9ZcD21ZX/ou29BDDRauVXqm9CpSppybq1/8AzdM/BE=;
        b=fsFCwlmgAHQt4C4w0u9PQWqwnUHkmNJatR4jSvZVCUePhvdJC1o7pVv0R+p+AL9ta6
         srNIWyvpQgwSaKoq61OLYGLvXy+6nP2GzjJ5Yv0aSVs/U4n0jyPvuHBnBP8iwU0FLj/V
         bgxxNjPWS59+bhV1GKqwXAYHv3+MRfuAJZVFv7Nw7ONYzptVIsrxa+BQZCtPuUCxgsyw
         OHModnqI8b0m+JfD8V653p//bLB3alUlVHIJX+NN/crElxkhdaafJEcpbZ+5nbdjzfck
         YG8HdGwpzIchKA4p71s859f04trFl8VtF9nFZOkQKomcbDXt1JfybOLc2Ie6UuyuOqWX
         wcWQ==
X-Gm-Message-State: AOAM530DfzBD6KvNJOpyS6Zk684o1dfjVlOu0Ytub8+r/akW2LlV7TJ4
        1G8K2Ga4vO7oHRCLso4teQIWHDMvOXL90Jm6QuMohpJoypkuFvAv7pmbEODFcpW4Gw/FgivHilS
        NBXOsKS7qLeaaiaWH
X-Received: by 2002:a05:6402:6c8:: with SMTP id n8mr22504752edy.180.1623758091271;
        Tue, 15 Jun 2021 04:54:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6VRfui25Fk7gETjn32Em0zrvcKKVgDXu79Wc1czwESYsDkvGpci2Q171qwd/tpWzV0WpyJA==
X-Received: by 2002:a05:6402:6c8:: with SMTP id n8mr22504720edy.180.1623758090925;
        Tue, 15 Jun 2021 04:54:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m18sm9988254ejx.56.2021.06.15.04.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 04:54:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6089A180734; Tue, 15 Jun 2021 13:54:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
In-Reply-To: <CAM_iQpW7ZAz5rLAanMRg7R52Pn55N=puVkvoHcHF618wq8uA1g@mail.gmail.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <CAM_iQpW7ZAz5rLAanMRg7R52Pn55N=puVkvoHcHF618wq8uA1g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Jun 2021 13:54:49 +0200
Message-ID: <877divs5py.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

>> > I offer two different views here:
>> >
>> > 1. If you view a TC filter as an instance as a netdev/qdisc/action, they
>> > are no different from this perspective. Maybe the fact that a TC filter
>> > resides in a qdisc makes a slight difference here, but like I mentioned, it
>> > actually makes sense to let TC filters be standalone, qdisc's just have to
>> > bind with them, like how we bind TC filters with standalone TC actions.
>>
>> You propose something different below IIUC, but I explained why I'm wary of
>> these unbound filters. They seem to add a step to classifier setup for no real
>> benefit to the user (except keeping track of one more object and cleaning it
>> up with the link when done).
>
> I am not even sure if unbound filters help your case at all, making
> them unbound merely changes their residence, not ownership.
> You are trying to pass the ownership from TC to bpf_link, which
> is what I am against.

So what do you propose instead?

bpf_link is solving a specific problem: ensuring automatic cleanup of
kernel resources held by a userspace application with a BPF component.
Not all applications work this way, but for the ones that do it's very
useful. But if the TC filter stays around after bpf_link detaches, that
kinda defeats the point of the automatic cleanup.

So I don't really see any way around transferring ownership somehow.
Unless you have some other idea that I'm missing?

-Toke

