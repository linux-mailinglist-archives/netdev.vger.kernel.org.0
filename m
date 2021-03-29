Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B24534D020
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhC2Mcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:32:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230525AbhC2McX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617021142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GD9jR8caEzP+19c9pN1aTSDBAL/jQfepjFuZgZ5AJQg=;
        b=OlqAyFQDrPBEReRSlmX2jQU61VY9orGF6TZYI6UGC2smvI+Rk/Na31043USNClCDxJ2rET
        w3Ftmm1TkEhYts02tQPl/J7I6Kj6VF4xX4lEfK9shH3DrjRX8JHcipYvIUOPQ+l8vGq+Id
        BYNC9PSQ2E4a4xQikf+cxt1SxrtIhAg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-swsH8o4kOFC2jWu_184SFA-1; Mon, 29 Mar 2021 08:32:18 -0400
X-MC-Unique: swsH8o4kOFC2jWu_184SFA-1
Received: by mail-ed1-f69.google.com with SMTP id r6so5032116edh.7
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GD9jR8caEzP+19c9pN1aTSDBAL/jQfepjFuZgZ5AJQg=;
        b=NQCZajnW2zt2bYT4nj9xBUSll75rbB5AbMEm613yghDf7gRL1yXVZb3rHEK6VfH0AF
         9ur1YoHz9bIZ5VtTLauUHbFi18tgpOcK4EWMAqobj+OJaQ+UWd3KcKJsjqIoLvch2/jD
         TiuBJ8ZCoxDsbmbjm7AHCbJ5yLV2jXVl5D1N3BA6f9LkZGDKWDq+yb1BRcAmJ9COw1yf
         VUFr0AhyQ2wpuuvXgjpIDX2idCiCHJG+jdK3LJlhl/I+bG5rqF007oD0e+eXCHdfLOEX
         2nFm5HmMQ/JCqopUL9ylNXd2VukuxtmBw9ID589EYlRktWQiZ2NY6qrl/qpCtdtLw7o6
         LQSw==
X-Gm-Message-State: AOAM5333h8vrJ5xrewGgwba0oZxHF6rojsPv44BO4zV4dC42tLxKvN9E
        BIZ/1MCZtxnGPRgHzPii6gfyvTyOwsopP9Gr+GlEOeEhpgTmKwhSKjY+MSVP/aGCRsvDLdWd/ZV
        XpqisAinggFVGdEnZ
X-Received: by 2002:aa7:c7c5:: with SMTP id o5mr27815376eds.31.1617021137529;
        Mon, 29 Mar 2021 05:32:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB6FtmWkTT1pDy9lNZ/oJD/8n2X2GcodTMfUAO+YgTpSdBjEi/lflWuIuFFQOFO79csJA6Eg==
X-Received: by 2002:aa7:c7c5:: with SMTP id o5mr27815365eds.31.1617021137301;
        Mon, 29 Mar 2021 05:32:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w24sm8791315edt.44.2021.03.29.05.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:32:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2925B180293; Mon, 29 Mar 2021 14:32:16 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Vlad Buslov <vladbu@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
In-Reply-To: <ygnhh7kugp1t.fsf@nvidia.com>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com> <ygnhh7kugp1t.fsf@nvidia.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Mar 2021 14:32:16 +0200
Message-ID: <87ft0eta27.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlad Buslov <vladbu@nvidia.com> writes:

> On Thu 25 Mar 2021 at 14:00, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>> This adds functions that wrap the netlink API used for adding,
>> manipulating, and removing filters and actions. These functions operate
>> directly on the loaded prog's fd, and return a handle to the filter and
>> action using an out parameter (id for tc_cls, and index for tc_act).
>>
>> The basic featureset is covered to allow for attaching, manipulation of
>> properties, and removal of filters and actions. Some additional features
>> like TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
>> added on top later by extending the bpf_tc_cls_opts struct.
>>
>> Support for binding actions directly to a classifier by passing them in
>> during filter creation has also been omitted for now. These actions
>> have an auto clean up property because their lifetime is bound to the
>> filter they are attached to. This can be added later, but was omitted
>> for now as direct action mode is a better alternative to it.
>>
>> An API summary:
>>
>> The BPF TC-CLS API
>>
>> bpf_tc_act_{attach, change, replace}_{dev, block} may be used to attach,
>> change, and replace SCHED_CLS bpf classifiers. Separate set of functions
>> are provided for network interfaces and shared filter blocks.
>>
>> bpf_tc_cls_detach_{dev, block} may be used to detach existing SCHED_CLS
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
>> 	r = bpf_tc_cls_attach_dev(fd, if_nametoindex("lo"),
>> 				  BPF_TC_CLSACT_INGRESS, ETH_P_IP,
>> 				  NULL, &id);
>> 	if (r < 0)
>> 		return r;
>>
>> ... which is roughly equivalent to (after clsact qdisc setup):
>>   # tc filter add dev lo ingress bpf obj /home/kkd/foo.o sec classifier
>>
>> If a user wishes to modify existing options on an attached filter, the
>> bpf_tc_cls_change_{dev, block} API may be used. Parameters like
>> chain_index, priority, and handle are ignored in the bpf_tc_cls_opts
>> struct as they cannot be modified after attaching a filter.
>>
>> Example:
>>
>> 	/* Optional parameters necessary to select the right filter */
>> 	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
>> 			    .handle = id.handle,
>> 			    .priority = id.priority,
>> 			    .chain_index = id.chain_index)
>> 	/* Turn on direct action mode */
>> 	opts.direct_action = true;
>> 	r = bpf_tc_cls_change_dev(fd, id.ifindex, id.parent_id,
>> 			          id.protocol, &opts, &id);
>> 	if (r < 0)
>> 		return r;
>>
>> 	/* Verify that the direct action mode has been set */
>> 	struct bpf_tc_cls_info info = {};
>> 	r = bpf_tc_cls_get_info_dev(fd, id.ifindex, id.parent_id,
>> 			            id.protocol, &opts, &info);
>> 	if (r < 0)
>> 		return r;
>>
>> 	assert(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT);
>>
>> This would be roughly equivalent to doing:
>>   # tc filter change dev lo egress prio <p> handle <h> bpf obj /home/kkd/foo.o section classifier da
>>
>> ... except a new bpf program will be loaded and replace existing one.
>>
>> If a user wishes to either replace an existing filter, or create a new
>> one with the same properties, they can use bpf_tc_cls_replace_dev. The
>> benefit of bpf_tc_cls_change is that it fails if no matching filter
>> exists.
>>
>> The BPF TC-ACT API
>>
>> bpf_tc_act_{attach, replace} may be used to attach and replace already
>> attached SCHED_ACT actions. Passing an index of 0 has special meaning,
>> in that an index will be automatically chosen by the kernel. The index
>> chosen by the kernel is the return value of these functions in case of
>> success.
>>
>> bpf_tc_act_detach may be used to detach a SCHED_ACT action prog
>> identified by the index parameter. The index 0 again has a special
>> meaning, in that passing it will flush all existing SCHED_ACT actions
>> loaded using the ACT API.
>>
>> bpf_tc_act_get_info is a helper to get the required attributes of a
>> loaded program to be able to manipulate it futher, by passing them
>> into the aforementioned functions.
>>
>> Example:
>>
>> 	struct bpf_object *obj;
>> 	struct bpf_program *p;
>> 	__u32 index;
>> 	int fd, r;
>>
>> 	obj = bpf_object_open("foo.o");
>> 	if (IS_ERR_OR_NULL(obj))
>> 		return PTR_ERR(obj);
>>
>> 	p = bpf_object__find_program_by_title(obj, "action");
>> 	if (IS_ERR_OR_NULL(p))
>> 		return PTR_ERR(p);
>>
>> 	if (bpf_object__load(obj) < 0)
>> 		return -1;
>>
>> 	fd = bpf_program__fd(p);
>>
>> 	r = bpf_tc_act_attach(fd, NULL, &index);
>> 	if (r < 0)
>> 		return r;
>>
>> 	if (bpf_tc_act_detach(index))
>> 		return -1;
>>
>> ... which is equivalent to the following sequence:
>> 	tc action add action bpf obj /home/kkd/foo.o sec action
>> 	tc action del action bpf index <idx>
>
> How do you handle the locking here? Please note that while
> RTM_{NEW|GET|DEL}FILTER API has been refactored to handle its own
> locking internally (and registered with RTNL_FLAG_DOIT_UNLOCKED flag),
> RTM_{NEW|GET|DEL}ACTION API still expects to be called with rtnl lock
> taken.

Huh, locking? This is all userspace code that uses the netlink API...

-Toke

