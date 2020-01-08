Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBC1134891
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgAHQyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:54:02 -0500
Received: from www62.your-server.de ([213.133.104.62]:36552 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729064AbgAHQyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:54:01 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipEad-0000ep-AJ; Wed, 08 Jan 2020 17:53:51 +0100
Date:   Wed, 8 Jan 2020 17:53:50 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Message-ID: <20200108165350.GA7014@linux-3.fritz.box>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
 <4ea486a8-61cf-3c2e-c72c-96bb4f69d006@iogearbox.net>
 <20200108015223.sdecaqnjeconwpgq@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108015223.sdecaqnjeconwpgq@kafai-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25688/Wed Jan  8 10:56:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 01:52:26AM +0000, Martin Lau wrote:
> On Wed, Jan 08, 2020 at 01:21:39AM +0100, Daniel Borkmann wrote:
> > On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
> > > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > > is a kernel struct with its func ptr implemented in bpf prog.
> > > This new map is the interface to register/unregister/introspect
> > > a bpf implemented kernel struct.
> > > 
> > > The kernel struct is actually embedded inside another new struct
> > > (or called the "value" struct in the code).  For example,
> > > "struct tcp_congestion_ops" is embbeded in:
> > > struct bpf_struct_ops_tcp_congestion_ops {
> > > 	refcount_t refcnt;
> > > 	enum bpf_struct_ops_state state;
> > > 	struct tcp_congestion_ops data;  /* <-- kernel subsystem struct here */
> > > }
> > > The map value is "struct bpf_struct_ops_tcp_congestion_ops".
> > > The "bpftool map dump" will then be able to show the
> > > state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.g.
> > > number of tcp_sock in the tcp_congestion_ops case).  This "value" struct
> > > is created automatically by a macro.  Having a separate "value" struct
> > > will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. adding
> > > "void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
> > > initialization works before registering the struct_ops to the kernel
> > > subsystem).  The libbpf will take care of finding and populating the
> > > "struct bpf_struct_ops_XYZ" from "struct XYZ".
> > > 
> > > Register a struct_ops to a kernel subsystem:
> > > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_id
> > >     set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of the
> > >     running kernel.
> > >     Instead of reusing the attr->btf_value_type_id,
> > >     btf_vmlinux_value_type_id s added such that attr->btf_fd can still be
> > >     used as the "user" btf which could store other useful sysadmin/debug
> > >     info that may be introduced in the furture,
> > >     e.g. creation-date/compiler-details/map-creator...etc.
> > > 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as described
> > >     in the running kernel btf.  Populate the value of this object.
> > >     The function ptr should be populated with the prog fds.
> > > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> > >     the map value.  The key is always "0".
> > > 
> > > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > > the specific struct_ops to do some final checks in "st_ops->init_member()"
> > > (e.g. ensure all mandatory func ptrs are implemented).
> > > If everything looks good, it will register this kernel struct
> > > to the kernel subsystem.  The map will not allow further update
> > > from this point.
> > 
> > Btw, did you have any thoughts on whether it would have made sense to add
> > a new core construct for BPF aside from progs or maps, e.g. BPF modules
> > which then resemble a collection of progs/ops (given this would not be limited
> > to tcp congestion control only). Given the possibilities, having a bit of second
> > thoughts on abusing BPF map interface this way which is not overly pretty. It's
> > not a map anymore at this point anyway, we're just reusing the syscall interface
> > since it's convenient though cannot be linked to any prog is just a single slot
> > etc, but technically some sort of BPF module registration would be nicer. Also in
> > terms of 'bpftool modules' then listing all such currently loaded modules which
> > need to be cleaned up this way through explicit removal (similar to insmod/
> > lsmod/rmmod); at least feels more natural conceptually than BPF maps and the way
> > you refcount them, and would perhaps also be a fit for BPF lib helpers for dynamic
> > linking to load that way. So essentially similar but more lightweight infrastructure
> > as with kernel modules. Thoughts?
> Inventing a new bpf obj type (vs adding new map type like in this patch) was
> one considered (and briefly-tried) option.
> 
> Once BTF was introduced to bpf map,  I see bpf map as an introspectible
> bpf obj that can store any blob described by BTF.  I don't think
> creating a new bpf obj type worth it while both of them are basically
> storing a value described by BTF.
> 
> I did try to create register/unregister interface and new bpf-cmd.
> At the end, it ends up very similar to update_elem() which is basically
> updating a blob of a struct described by BTF.  Hence, I tossed that and
> came back to the current approach.
> 
> Put aside the new bpf obj type needs kernel support like another idr,
> likely pin-able, fd, get_info...etc,  I suspect most users have already
> been used to do 'bpftool map dump' to introspect bpf obj that is storing
> a 'struct'.
> 
> The map type is enough to distinguish the map usage instead of creating
> another bpf obj type.  The 'bpftool modules' will work on the struct_ops
> map only.

Right, but under long-term I'd expect more users of this interface and given
we abuse the map only to keep other entities (here: bpf tcp congctl module)
'alive', but cannot do anything else with this map (as in: usage in the BPF
program), it feels that this begs for a better interface. Given we need an
explicit delete operation of the map slot in order to eventually unregister
the congctl module once no application is using it anymore, how are users
supposed to operate this considering the loader performs either only a load
or crashes before the map delete happens? If you had 'bpftool modules' like
cmdline interface with similar insmod/lsmod/rmmod type operation as we have
for kernel modules, it's pretty obvious and intuitive. Here, you'd need a
'bpftool map dump' to get to the concrete ops map, and then perform an
explicit delete operation for releasing the ops refcount and thus to unload
the set of progs. Such extension for bpftool should be done regardless, even
if we end up to keep abusing the map interface for this, but API wise feels
way cleaner to have a dedicated register/unregister interface.

Thanks,
Daniel
