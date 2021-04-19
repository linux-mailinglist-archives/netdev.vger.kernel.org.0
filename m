Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9BD364D40
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhDSVns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:43:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhDSVnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 17:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618868597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NCUSF0NODUQGqVEalI8EqwtjFOpvGAIM6Wv/bT2GNjA=;
        b=V0K4Qf1JRQAO36/1mqeFjFnpV8hV9+DD2uFv8a1hXowZOy+sCgz0jPrQ57DQkg84FxFqj/
        0Z4Ka/SCa7FvcWmJqeSxyUIuvB07u7ZAKNZa8IvhNjV1l8TUKn/dyUTRi6AfxyGeQQKTE3
        xR6I8F8LNeTzw7SVvx5pwer2e3/J7pQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-AGq9z-wSPnmBzo2H2rw5Aw-1; Mon, 19 Apr 2021 17:43:15 -0400
X-MC-Unique: AGq9z-wSPnmBzo2H2rw5Aw-1
Received: by mail-ed1-f70.google.com with SMTP id bf25-20020a0564021a59b0290385169cebf8so4492098edb.8
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 14:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NCUSF0NODUQGqVEalI8EqwtjFOpvGAIM6Wv/bT2GNjA=;
        b=ambF40r5XjUCRR9CPjOsVmo+lELDCOhrhq6Z/1uwZbjS/OF0N/B0sBnGC8/38dRYCM
         rtz9sTHDJ/FXODFqbh+A66W3q0oFoNpSzBNZWai6w5P/KxrqKEY1l4zW8Xd3MPA78o9V
         p7LEg2ZVzfzODcZmbO0AM+dq8v43fz1aN8u1/VGd8RhVwm9o15v9+YR97CK4CMVYRA3Y
         HDM2hUCsh3HFrzghlIoSrwLBHKfNQXG8F5tgIQYVa7n5cctZoXozIJZuiIN89YsQvO0o
         o36+B+urvqEPjJkkgbEs7IAFZj4VeKKOd6swDJJSZY+iCcTsDwv+YUMhfPuflnOAnz/Y
         Bsew==
X-Gm-Message-State: AOAM5307dpjevjj46FT3g3EosS/tYSH2DeF9hqKz+AFvbLMznVKAO8AQ
        E+RXO8FqCpfEjyanWWLP+gP2YCxpP7WoLYb5YxcZ+VrIjJ4NWExfe9pWRlz4ZTaaNSaVfYFgJml
        KxB7q4KTVdp8Ekl5x
X-Received: by 2002:a17:906:747:: with SMTP id z7mr24640870ejb.192.1618868594142;
        Mon, 19 Apr 2021 14:43:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiEFjfwoNlDAxzRphGFpVnyEOhSnRuyXBQvwLogx9tcq03XTiPwaXPzthBdCAUpJKUmtRbKA==
X-Received: by 2002:a17:906:747:: with SMTP id z7mr24640852ejb.192.1618868593816;
        Mon, 19 Apr 2021 14:43:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x7sm13586562eds.67.2021.04.19.14.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 14:43:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8EADE180092; Mon, 19 Apr 2021 23:43:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: add low level TC-BPF API
In-Reply-To: <6e8b744c-e012-c76b-b55f-7ddc8b7483db@iogearbox.net>
References: <20210419121811.117400-1-memxor@gmail.com>
 <20210419121811.117400-4-memxor@gmail.com>
 <6e8b744c-e012-c76b-b55f-7ddc8b7483db@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 19 Apr 2021 23:43:12 +0200
Message-ID: <874kg2gdcf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/19/21 2:18 PM, Kumar Kartikeya Dwivedi wrote:
>> This adds functions that wrap the netlink API used for adding,
>> manipulating, and removing traffic control filters. These functions
>> operate directly on the loaded prog's fd, and return a handle to the
>> filter using an out parameter named id.
>> 
>> The basic featureset is covered to allow for attaching, manipulation of
>> properties, and removal of filters. Some additional features like
>> TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
>> added on top later by extending the bpf_tc_cls_opts struct.
>> 
>> Support for binding actions directly to a classifier by passing them in
>> during filter creation has also been omitted for now. These actions have
>> an auto clean up property because their lifetime is bound to the filter
>> they are attached to. This can be added later, but was omitted for now
>> as direct action mode is a better alternative to it, which is enabled by
>> default.
>> 
>> An API summary:
>> 
>> bpf_tc_act_{attach, change, replace} may be used to attach, change, and
>
> typo on bpf_tc_act_{...} ?
>                 ^^^
>> replace SCHED_CLS bpf classifier. The protocol field can be set as 0, in
>> which case it is subsitituted as ETH_P_ALL by default.
>
> Do you have an actual user that needs anything other than ETH_P_ALL? Why is it
> even needed? Why not stick to just ETH_P_ALL?
>
>> The behavior of the three functions is as follows:
>> 
>> attach = create filter if it does not exist, fail otherwise
>> change = change properties of the classifier of existing filter
>> replace = create filter, and replace any existing filter
>
> This touches on tc oddities quite a bit. Why do we need to expose them? Can't we
> simplify/abstract this e.g. i) create or update instance, ii) delete instance,
> iii) get instance ? What concrete use case do you have that you need those three
> above?
>
>> bpf_tc_cls_detach may be used to detach existing SCHED_CLS
>> filter. The bpf_tc_cls_attach_id object filled in during attach,
>> change, or replace must be passed in to the detach functions for them to
>> remove the filter and its attached classififer correctly.
>> 
>> bpf_tc_cls_get_info is a helper that can be used to obtain attributes
>> for the filter and classififer. The opts structure may be used to
>> choose the granularity of search, such that info for a specific filter
>> corresponding to the same loaded bpf program can be obtained. By
>> default, the first match is returned to the user.
>> 
>> Examples:
>> 
>> 	struct bpf_tc_cls_attach_id id = {};
>> 	struct bpf_object *obj;
>> 	struct bpf_program *p;
>> 	int fd, r;
>> 
>> 	obj = bpf_object_open("foo.o");
>> 	if (IS_ERR_OR_NULL(obj))
>> 		return PTR_ERR(obj);
>> 
>> 	p = bpf_object__find_program_by_title(obj, "classifier");
>> 	if (IS_ERR_OR_NULL(p))
>> 		return PTR_ERR(p);
>> 
>> 	if (bpf_object__load(obj) < 0)
>> 		return -1;
>> 
>> 	fd = bpf_program__fd(p);
>> 
>> 	r = bpf_tc_cls_attach(fd, if_nametoindex("lo"),
>> 			      BPF_TC_CLSACT_INGRESS,
>> 			      NULL, &id);
>> 	if (r < 0)
>> 		return r;
>> 
>> ... which is roughly equivalent to (after clsact qdisc setup):
>>    # tc filter add dev lo ingress bpf obj foo.o sec classifier da
>> 
>> ... as direct action mode is always enabled.
>> 
>> If a user wishes to modify existing options on an attached classifier,
>> bpf_tc_cls_change API may be used.
>> 
>> Only parameters class_id can be modified, the rest are filled in to
>> identify the correct filter. protocol can be left out if it was not
>> chosen explicitly (defaulting to ETH_P_ALL).
>> 
>> Example:
>> 
>> 	/* Optional parameters necessary to select the right filter */
>> 	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
>> 			    .handle = id.handle,
>> 			    .priority = id.priority,
>> 			    .chain_index = id.chain_index)
>
> Why do we need chain_index as part of the basic API?
>
>> 	opts.class_id = TC_H_MAKE(1UL << 16, 12);
>> 	r = bpf_tc_cls_change(fd, if_nametoindex("lo"),
>> 			      BPF_TC_CLSACT_INGRESS,
>> 			      &opts, &id);
>
> Also, I'm not sure whether the prefix should even be named  bpf_tc_cls_*() tbh,
> yes, despite being "low level" api. I think in the context of bpf we should stop
> regarding this as 'classifier' and 'action' objects since it's really just a
> single entity and not separate ones. It's weird enough to explain this concept
> to new users and if a libbpf based api could cleanly abstract it, I would be all
> for it. I don't think we need to map 1:1 the old tc legacy even in the low level
> api, tbh, as it feels backwards. I think the 'handle' & 'priority' bits are okay,
> but I would remove the others.

Hmm, I'm OK with dropping the TC oddities (including the cls_ in the
name), but I think we should be documenting it so that users that do
come from TC will not be completely lost :)

-Toke

