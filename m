Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95471337E8
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 01:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgAHAVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 19:21:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:50370 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgAHAVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 19:21:46 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ioz6T-0004Ri-87; Wed, 08 Jan 2020 01:21:41 +0100
Received: from [178.197.249.51] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ioz6S-000MQf-Qe; Wed, 08 Jan 2020 01:21:41 +0100
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4ea486a8-61cf-3c2e-c72c-96bb4f69d006@iogearbox.net>
Date:   Wed, 8 Jan 2020 01:21:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191231062050.281712-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25687/Tue Jan  7 10:56:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
> The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> is a kernel struct with its func ptr implemented in bpf prog.
> This new map is the interface to register/unregister/introspect
> a bpf implemented kernel struct.
> 
> The kernel struct is actually embedded inside another new struct
> (or called the "value" struct in the code).  For example,
> "struct tcp_congestion_ops" is embbeded in:
> struct bpf_struct_ops_tcp_congestion_ops {
> 	refcount_t refcnt;
> 	enum bpf_struct_ops_state state;
> 	struct tcp_congestion_ops data;  /* <-- kernel subsystem struct here */
> }
> The map value is "struct bpf_struct_ops_tcp_congestion_ops".
> The "bpftool map dump" will then be able to show the
> state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.g.
> number of tcp_sock in the tcp_congestion_ops case).  This "value" struct
> is created automatically by a macro.  Having a separate "value" struct
> will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. adding
> "void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
> initialization works before registering the struct_ops to the kernel
> subsystem).  The libbpf will take care of finding and populating the
> "struct bpf_struct_ops_XYZ" from "struct XYZ".
> 
> Register a struct_ops to a kernel subsystem:
> 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_id
>     set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of the
>     running kernel.
>     Instead of reusing the attr->btf_value_type_id,
>     btf_vmlinux_value_type_id s added such that attr->btf_fd can still be
>     used as the "user" btf which could store other useful sysadmin/debug
>     info that may be introduced in the furture,
>     e.g. creation-date/compiler-details/map-creator...etc.
> 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as described
>     in the running kernel btf.  Populate the value of this object.
>     The function ptr should be populated with the prog fds.
> 4. Call BPF_MAP_UPDATE with the object created in (3) as
>     the map value.  The key is always "0".
> 
> During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> the specific struct_ops to do some final checks in "st_ops->init_member()"
> (e.g. ensure all mandatory func ptrs are implemented).
> If everything looks good, it will register this kernel struct
> to the kernel subsystem.  The map will not allow further update
> from this point.

Btw, did you have any thoughts on whether it would have made sense to add
a new core construct for BPF aside from progs or maps, e.g. BPF modules
which then resemble a collection of progs/ops (given this would not be limited
to tcp congestion control only). Given the possibilities, having a bit of second
thoughts on abusing BPF map interface this way which is not overly pretty. It's
not a map anymore at this point anyway, we're just reusing the syscall interface
since it's convenient though cannot be linked to any prog is just a single slot
etc, but technically some sort of BPF module registration would be nicer. Also in
terms of 'bpftool modules' then listing all such currently loaded modules which
need to be cleaned up this way through explicit removal (similar to insmod/
lsmod/rmmod); at least feels more natural conceptually than BPF maps and the way
you refcount them, and would perhaps also be a fit for BPF lib helpers for dynamic
linking to load that way. So essentially similar but more lightweight infrastructure
as with kernel modules. Thoughts?

Thanks,
Daniel
