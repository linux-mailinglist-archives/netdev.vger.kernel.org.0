Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6642B375D07
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 23:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhEFV6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 17:58:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:43308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhEFV6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 17:58:11 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lelzb-000ASc-Fw; Thu, 06 May 2021 23:57:11 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lelzb-000Wpm-6N; Thu, 06 May 2021 23:57:11 +0200
Subject: Re: [PATCH bpf-next v6 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
References: <20210504005023.1240974-1-memxor@gmail.com>
 <20210504005023.1240974-3-memxor@gmail.com>
 <eb6aada2-0de8-3adf-4b69-898a1c31c4e6@iogearbox.net>
 <20210506023753.7hkzo3xxrqighcm2@apollo>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <70213fce-858e-5384-1614-919c4eced8ba@iogearbox.net>
Date:   Thu, 6 May 2021 23:57:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210506023753.7hkzo3xxrqighcm2@apollo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26162/Thu May  6 13:11:07 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 4:37 AM, Kumar Kartikeya Dwivedi wrote:
> On Thu, May 06, 2021 at 03:12:01AM IST, Daniel Borkmann wrote:
>> On 5/4/21 2:50 AM, Kumar Kartikeya Dwivedi wrote:
>>> This adds functions that wrap the netlink API used for adding,
>>> manipulating, and removing traffic control filters.
>>>
>>> An API summary:
>>
>> Looks better, few minor comments below:
>>
>>> A bpf_tc_hook represents a location where a TC-BPF filter can be
>>> attached. This means that creating a hook leads to creation of the
>>> backing qdisc, while destruction either removes all filters attached to
>>> a hook, or destroys qdisc if requested explicitly (as discussed below).
>>>
>>> The TC-BPF API functions operate on this bpf_tc_hook to attach, replace,
>>> query, and detach tc filters.
>>>
>>> All functions return 0 on success, and a negative error code on failure.
>>>
>>> bpf_tc_hook_create - Create a hook
>>> Parameters:
>>> 	@hook - Cannot be NULL, ifindex > 0, attach_point must be set to
>>> 		proper enum constant. Note that parent must be unset when
>>> 		attach_point is one of BPF_TC_INGRESS or BPF_TC_EGRESS. Note
>>> 		that as an exception BPF_TC_INGRESS|BPF_TC_EGRESS is also a
>>> 		valid value for attach_point.
>>>
>>> 		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
>>>
>>> 		hook's flags member can be BPF_TC_F_REPLACE, which
>>> 		creates qdisc in non-exclusive mode (i.e. an existing
>>> 		qdisc will be replaced instead of this function failing
>>> 		with -EEXIST).
>>
>> Why supporting BPF_TC_F_REPLACE here? It's not changing any qdisc parameters
>> given clsact doesn't have any, no? Iow, what effect are you expecting on this
>> with BPF_TC_F_REPLACE & why supporting it? I'd probably just require flags to
>> be 0 here, and if hook exists return sth like -EEXIST.
> 
> Ok, will change.
> 
>>> bpf_tc_hook_destroy - Destroy the hook
>>> Parameters:
>>>           @hook - Cannot be NULL. The behaviour depends on value of
>>> 		attach_point.
>>>
>>> 		If BPF_TC_INGRESS, all filters attached to the ingress
>>> 		hook will be detached.
>>> 		If BPF_TC_EGRESS, all filters attached to the egress hook
>>> 		will be detached.
>>> 		If BPF_TC_INGRESS|BPF_TC_EGRESS, the clsact qdisc will be
>>> 		deleted, also detaching all filters.
>>>
>>> 		As before, parent must be unset for these attach_points,
>>> 		and set for BPF_TC_CUSTOM. flags must also be unset.
>>>
>>> 		It is advised that if the qdisc is operated on by many programs,
>>> 		then the program at least check that there are no other existing
>>> 		filters before deleting the clsact qdisc. An example is shown
>>> 		below:
>>>
>>> 		DECLARE_LIBBPF_OPTS(bpf_tc_hook, .ifindex = if_nametoindex("lo"),
>>> 				    .attach_point = BPF_TC_INGRESS);
>>> 		/* set opts as NULL, as we're not really interested in
>>> 		 * getting any info for a particular filter, but just
>>> 	 	 * detecting its presence.
>>> 		 */
>>> 		r = bpf_tc_query(&hook, NULL);
>>> 		if (r == -ENOENT) {
>>> 			/* no filters */
>>> 			hook.attach_point = BPF_TC_INGRESS|BPF_TC_EGREESS;
>>> 			return bpf_tc_hook_destroy(&hook);
>>> 		} else {
>>> 			/* failed or r == 0, the latter means filters do exist */
>>> 			return r;
>>> 		}
>>>
>>> 		Note that there is a small race between checking for no
>>> 		filters and deleting the qdisc. This is currently unavoidable.
>>>
>>> 		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
>>>
>>> bpf_tc_attach - Attach a filter to a hook
>>> Parameters:
>>> 	@hook - Cannot be NULL. Represents the hook the filter will be
>>> 		attached to. Requirements for ifindex and attach_point are
>>> 		same as described in bpf_tc_hook_create, but BPF_TC_CUSTOM
>>> 		is also supported.  In that case, parent must be set to the
>>> 		handle where the filter will be attached (using TC_H_MAKE).
>>> 		flags member must be unset.
>>>
>>> 		E.g. To set parent to 1:16 like in tc command line,
>>> 		     the equivalent would be TC_H_MAKE(1 << 16, 16)
>>
>> Small nit: I wonder whether from libbpf side we should just support a more
>> user friendly TC_H_MAKE, so you'd have: BPF_TC_CUSTOM + BPF_TC_PARENT(1, 16).
> 
> Something like this was there in v1. I'll add this macro again (I guess the most surprising part of
> TC_H_MAKE is that it won't shift the major number).

Agree, weird one. :)

[...]
>>> bpf_tc_detach
>>> Parameters:
>>> 	@hook: Cannot be NULL. Represents the hook the filter will be
>>> 		detached from. Requirements are same as described above
>>> 		in bpf_tc_attach.
>>>
>>> 	@opts:	Cannot be NULL.
>>>
>>> 		The following opts must be set:
>>> 			handle
>>> 			priority
>>> 		The following opts must be unset:
>>> 			prog_fd
>>> 			prog_id
>>> 			flags
>>>
>>> bpf_tc_query
>>> Parameters:
>>> 	@hook: Cannot be NULL. Represents the hook where the filter
>>> 	       lookup will be performed. Requires are same as described
>>> 	       above in bpf_tc_attach.
>>>
>>> 	@opts: Can be NULL.
>>
>> Shouldn't it be: Cannot be NULL?
> 
> This allows you to check the existence of a filter. If set to NULL we skip writing anything to opts,

You mean in this case s/filter/hook/, right?

> but we still return -ENOENT or 0 depending on whether atleast one filter exists (based on the
> default attributes that we choose). This is used in multiple places in the test, to determine
> whether no filters exists.

In other words, it's same as bpf_tc_hook_create() which would return -EEXIST just that
we do /not/ create the hook if it does not exist, right?

>>> 	       The following opts are optional:
>>> 			handle
>>> 			priority
>>> 			prog_fd
>>> 			prog_id
>>
>> What is the use case to set prog_fd here?
> 
> It allows you to search with the prog_id of the program represented by fd. It's just a convenience
> thing, we end up doing a call to get the prog_id for you, and since the parameter is already there,
> it seemed ok to support this.

I would drop that part and have prog_fd forced to 0, given libbpf already has other means to
retrieve it from fd, and if non-convenient, then lets add a simple/generic libbpf API.

>>> 	       The following opts must be unset:
>>> 			flags
>>>
>>> 	       However, only one of prog_fd and prog_id must be
>>> 	       set. Setting both leads to an error. Setting none is
>>> 	       allowed.
>>>
>>> 	       The following fields will be filled by bpf_tc_query on a
>>> 	       successful lookup if they are unset:
>>> 			handle
>>> 			priority
>>> 			prog_id
>>>
>>> 	       Based on the specified optional parameters, the matching
>>> 	       data for the first matching filter is filled in and 0 is
>>> 	       returned. When setting prog_fd, the prog_id will be
>>> 	       matched against prog_id of the loaded SCHED_CLS prog
>>> 	       represented by prog_fd.
>>>
>>> 	       To uniquely identify a filter, e.g. to detect its presence,
>>> 	       it is recommended to set both handle and priority fields.
>>
>> What if prog_id is not unique, but part of multiple instances? Do we need
>> to support this case?
> 
> We return the first filter that matches on the prog_id. I think it is worthwhile to support this, as
> long as the kernel's sequence of returning filters is stable (which it is), we keep returning the
> same filter's handle/priority, so you can essentially pop filters attached to a hook one by one by
> passing in unset opts and getting its details (or setting one of the parameters and making the
> lookup domain smaller).
> 
> In simple words, setting one of the parameters that will be filled leads to only returning an entry
> that matches them. This is similar to what tc filter show's dump allows you to do.

I think this is rather a bit weird/hacky/unintuitive. If we need such API, then lets add a
proper one which returns all handle/priority combinations that match for a given prog_id
for the provided hook, but I don't think this needs to be in the initial set; could be done
as follow-up. (*)

>> Why not just bpf_tc_query() with non-NULL hook and non-NULL opts where
>> handle and priority is required to be set, and rest must be 0?
> 
> There is also a usecase for us where we need to query the existing filter on a hook without knowing
> its handle/priority. Shaun also mentioned something similar, where they then go on to check the tag
> they get from the returned prog_id to determine what to do next.

See (*).

>>> Some usage examples (using bpf skeleton infrastructure):
>>>
>>> BPF program (test_tc_bpf.c):
>>>
>>> 	#include <linux/bpf.h>
>>> 	#include <bpf/bpf_helpers.h>
>>>
>>> 	SEC("classifier")
>>> 	int cls(struct __sk_buff *skb)
>>> 	{
>>> 		return 0;
>>> 	}
>>>
>>> Userspace loader:
>>>
>>> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, 0);
>>> 	struct test_tc_bpf *skel = NULL;
>>> 	int fd, r;
>>>
>>> 	skel = test_tc_bpf__open_and_load();
>>> 	if (!skel)
>>> 		return -ENOMEM;
>>>
>>> 	fd = bpf_program__fd(skel->progs.cls);
>>>
>>> 	DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =
>>> 			    if_nametoindex("lo"), .attach_point =
>>> 			    BPF_TC_INGRESS);
>>> 	/* Create clsact qdisc */
>>> 	r = bpf_tc_hook_create(&hook);
>>> 	if (r < 0)
>>> 		goto end;
>>>
>>> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .prog_fd = fd);
>>
>> Given we had DECLARE_LIBBPF_OPTS earlier, can't we just set:
>> opts.prog_fd = fd here?
> 
> Right, will fix.
> 
>>
>>> 	r = bpf_tc_attach(&hook, &opts);
>>> 	if (r < 0)
>>> 		goto end;
>>> 	/* Print the auto allocated handle and priority */
>>> 	printf("Handle=%u", opts.handle);
>>> 	printf("Priority=%u", opts.priority);
>>>
>>> 	opts.prog_fd = opts.prog_id = 0;
>>> 	bpf_tc_detach(&hook, &opts);
>>

Thanks,
Daniel
