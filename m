Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D842E4923C
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfFQVRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:17:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:46284 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFQVRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:17:36 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hcz0F-0000yy-3p; Mon, 17 Jun 2019 23:17:23 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hcz0E-000GSN-UZ; Mon, 17 Jun 2019 23:17:22 +0200
Subject: Re: [PATCH v2 bpf-next 00/11] BTF-defined BPF map definitions
To:     Andrii Nakryiko <andriin@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com,
        jakub.kicinski@netronome.com, joe@wand.net.nz
Message-ID: <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
Date:   Mon, 17 Jun 2019 23:17:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190617192700.2313445-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25483/Mon Jun 17 09:56:00 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/17/2019 09:26 PM, Andrii Nakryiko wrote:
> This patch set implements initial version (as discussed at LSF/MM2019
> conference) of a new way to specify BPF maps, relying on BTF type information,
> which allows for easy extensibility, preserving forward and backward
> compatibility. See details and examples in description for patch #6.
> 
> [0] contains an outline of follow up extensions to be added after this basic
> set of features lands. They are useful by itself, but also allows to bring
> libbpf to feature-parity with iproute2 BPF loader. That should open a path
> forward for BPF loaders unification.
> 
> Patch #1 centralizes commonly used min/max macro in libbpf_internal.h.
> Patch #2 extracts .BTF and .BTF.ext loading loging from elf_collect().
> Patch #3 simplifies elf_collect() error-handling logic.
> Patch #4 refactors map initialization logic into user-provided maps and global
> data maps, in preparation to adding another way (BTF-defined maps).
> Patch #5 adds support for map definitions in multiple ELF sections and
> deprecates bpf_object__find_map_by_offset() API which doesn't appear to be
> used anymore and makes assumption that all map definitions reside in single
> ELF section.
> Patch #6 splits BTF intialization from sanitization/loading into kernel to
> preserve original BTF at the time of map initialization.
> Patch #7 adds support for BTF-defined maps.
> Patch #8 adds new test for BTF-defined map definition.
> Patches #9-11 convert test BPF map definitions to use BTF way.
> 
> [0] https://lore.kernel.org/bpf/CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntWAkJt47=FE+km+A@mail.gmail.com/

Quoting above in here for some clarifications on the approach. Basically for
iproute2, we would add libbpf library support on top of the current loader,
this means existing object files keep working as-is, and users would have to
decide whether they want to go with the new format or stick to the old one;
incentive for the new format would be to get all the other libbpf features
from upstream automatically. Though it means that once they switch there is
no object file compatibility with older iproute2 versions anymore. For the
case of Cilium, the container image ships with its own iproute2 version as
we don't want to rely on distros that they keep iproute2<->kernel release in
sync (some really don't). Switch should be fine in our case. For people
upgrading, the 'external' behavior (e.g. bpf fs interaction etc) would need
to stay the same to not run into any service disruption when switching versions.

>1. Pinning. This one is simple:
>  - add pinning attribute, that will either be "no pinning", "global
>pinning", "object-scope pinning".
>  - by default pinning root will be "/sys/fs/bpf", but one will be
>able to override this per-object using extra options (so that
>"/sys/fs/bpf/tc" can be specified).

I would just drop the object-scope pinning. We avoided using it and I'm not
aware if anyone else make use. It also has the ugly side-effect that this
relies on AF_ALG which e.g. on some cloud provider shipped kernels is disabled.
The pinning attribute should be part of the standard set of map attributes for
libbpf though as it's generally useful for networking applications.

>2. Map-in-map declaration:
>
>As outlined at LSF/MM, we can extend value type to be another map
>definition, specifying a prototype for inner map:
>
>struct {
>        int type;
>        int max_entries;
>        struct outer_key *key;
>        struct { /* this is definition of inner map */
>               int type;
>               int max_entries;
>               struct inner_key *key;
>               struct inner_value *value;
>        } value;
>} my_hash_of_arrays BPF_MAP = {
>        .type = BPF_MAP_TYPE_HASH_OF_MAPS,
>        .max_entries = 1024,
>        .value = {
>                .type = BPF_MAP_TYPE_ARRAY,
>                .max_entries = 64,
>        },
>};
>
>This would declare a hash_of_maps, where inner maps are arrays of 64
>elements each. Notice, that struct defining inner map can be declared
>outside and shared with other maps:
>
>struct inner_map_t {
>        int type;
>        int max_entries;
>        struct inner_key *key;
>        struct inner_value *value;
>};
>
>struct {
>        int type;
>        int max_entries;
>        struct outer_key *key;
>        struct inner_map_t value;
>} my_hash_of_arrays BPF_MAP = {
>        .type = BPF_MAP_TYPE_HASH_OF_MAPS,
>        .max_entries = 1024,
>        .value = {
>                .type = BPF_MAP_TYPE_ARRAY,
>                .max_entries = 64,
>        },
>};

This one feels a bit weird to me. My expectation would have been something
around the following to make this work:

  struct my_inner_map {
         int type;
         int max_entries;
         int *key;
         struct my_value *value;
  } btf_inner SEC(".maps") = {
         .type = BPF_MAP_TYPE_ARRAY,
         .max_entries = 16,
  };

And:

  struct {
         int type;
         int max_entries;
         int *key;
         struct my_inner_map *value;
  } btf_outer SEC(".maps") = {
         .type = BPF_MAP_TYPE_ARRAY,
         .max_entries = 16,
         .value = &btf_inner,
  };

And the loader should figure this out and combine everything in the background.
Otherwise above 'struct inner_map_t value' would be mixing convention of using
pointer vs non-pointer which may be even more confusing.

>3. Initialization of prog array. Iproute2 supports a convention-driven
>initialization of BPF_MAP_TYPE_PROG_ARRAY using special section names
>(wrapped into __section_tail(ID, IDX)):
>
>struct bpf_elf_map SEC("maps") POLICY_CALL_MAP = {
>        .type = BPF_MAP_TYPE_PROG_ARRAY,
>        .id = MAP_ID,
>        .size_key = sizeof(__u32),
>        .size_value = sizeof(__u32),
>        .max_elem = 16,
>};
>
>__section_tail(MAP_ID, MAP_IDX) int handle_policy(struct __sk_buff *skb)
>{
>        ...
>}
>
>For each such program, iproute2 will put its FD (for later
>tail-calling) into a corresponding MAP with id == MAP_ID at index
>MAP_IDX.
>
>Here's how I see this supported in BTF-defined maps case.
>
>typedef int (* skbuff_tailcall_fn)(struct __sk_buff *);
>
>struct {
>        int type;
>        int max_entries;
>        int *key;
>        skbuff_tailcall_fb value[];
>} POLICY_CALL_MAP SEC(".maps") = {
>        .type = BPF_MAP_TYPE_PROG_ARRAY,
>        .max_entries = 16,
>        .value = {
>                &handle_policy,
>                NULL,
>                &handle_some_other_policy,
>        },
>};
>
>libbpf loader will greate BPF_MAP_TYPE_PROG_ARRAY map with 16 elements
>and will initialize first and third entries with FDs of handle_policy
>and handle_some_other_policy programs. As an added nice bonus,
>compiler should also warn on signature mismatch. ;)

Seems okay, I guess the explicit initialization could lead people to think
that /after/ loading completed the NULL entries really won't have anything in
that tail call slot. In our case, we share some of the tail call maps for different
programs and each a different __section_tail(, idx), but in the end it's just a
matter of initialization by index for the above. iproute2 today fetches the map
from bpf fs if present, and only updates slots with __section_tail() present in
the object file. Invocation would again be via index I presume (tail_call(skb,
&policy_map, skb->mark), for example). For the __section_tail(MAP_ID, MAP_IDX),
we do dynamically generate the MAP_IDX define in some cases, but that MAP_IDX
would then simply be used in above POLICY_CALL_MAP instead; seems fine.

>4. We can extend this idea into ARRAY_OF_MAPS initialization. This is
>currently implemented in iproute2 using .id, .inner_id, and .inner_idx
>fields.
>
>struct inner_map_t {
>        int type;
>        int max_entries;
>        struct inner_key *key;
>        struct inner_value *value;
>};
>
>struct inner_map_t map1 = {...};
>struct inner_map_t map2 = {...};
>
>struct {
>        int type;
>        int max_entries;
>        struct outer_key *key;
>        struct inner_map_t value[];
>} my_hash_of_arrays BPF_MAP = {
>        .type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
>        .max_entries = 2,
>        .value = {
>                &map1,
>                &map2,
>        },
>};

Yeah, agree.

> v1->v2:
> - more BTF-sanity checks in parsing map definitions (Song);
> - removed confusing usage of "attribute", switched to "field;
> - split off elf_collect() refactor from btf loading refactor (Song);
> - split selftests conversion into 3 patches (Stanislav):
>   1. test already relying on BTF;
>   2. tests w/ custom types as key/value (so benefiting from BTF);
>   3. all the rest tests (integers as key/value, special maps w/o BTF support).
> - smaller code improvements (Song);
> 
> rfc->v1:
> - error out on unknown field by default (Stanislav, Jakub, Lorenz);
>  
> Andrii Nakryiko (11):
>   libbpf: add common min/max macro to libbpf_internal.h
>   libbpf: extract BTF loading logic
>   libbpf: streamline ELF parsing error-handling
>   libbpf: refactor map initialization
>   libbpf: identify maps by section index in addition to offset
>   libbpf: split initialization and loading of BTF
>   libbpf: allow specifying map definitions using BTF
>   selftests/bpf: add test for BTF-defined maps
>   selftests/bpf: switch BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
>   selftests/bpf: convert tests w/ custom values to BTF-defined maps
>   selftests/bpf: convert remaining selftests to BTF-defined maps
> 
>  tools/lib/bpf/bpf.c                           |   7 +-
>  tools/lib/bpf/bpf_prog_linfo.c                |   5 +-
>  tools/lib/bpf/btf.c                           |   3 -
>  tools/lib/bpf/btf.h                           |   1 +
>  tools/lib/bpf/btf_dump.c                      |   3 -
>  tools/lib/bpf/libbpf.c                        | 781 +++++++++++++-----
>  tools/lib/bpf/libbpf_internal.h               |   7 +
>  tools/testing/selftests/bpf/progs/bpf_flow.c  |  18 +-
>  .../selftests/bpf/progs/get_cgroup_id_kern.c  |  18 +-
>  .../testing/selftests/bpf/progs/netcnt_prog.c |  22 +-
>  .../selftests/bpf/progs/sample_map_ret0.c     |  18 +-
>  .../selftests/bpf/progs/socket_cookie_prog.c  |  11 +-
>  .../bpf/progs/sockmap_verdict_prog.c          |  36 +-
>  .../selftests/bpf/progs/test_btf_newkv.c      |  73 ++
>  .../bpf/progs/test_get_stack_rawtp.c          |  27 +-
>  .../selftests/bpf/progs/test_global_data.c    |  27 +-
>  tools/testing/selftests/bpf/progs/test_l4lb.c |  45 +-
>  .../selftests/bpf/progs/test_l4lb_noinline.c  |  45 +-
>  .../selftests/bpf/progs/test_map_in_map.c     |  20 +-
>  .../selftests/bpf/progs/test_map_lock.c       |  22 +-
>  .../testing/selftests/bpf/progs/test_obj_id.c |   9 +-
>  .../bpf/progs/test_select_reuseport_kern.c    |  45 +-
>  .../bpf/progs/test_send_signal_kern.c         |  22 +-
>  .../bpf/progs/test_skb_cgroup_id_kern.c       |   9 +-
>  .../bpf/progs/test_sock_fields_kern.c         |  60 +-
>  .../selftests/bpf/progs/test_spin_lock.c      |  33 +-
>  .../bpf/progs/test_stacktrace_build_id.c      |  44 +-
>  .../selftests/bpf/progs/test_stacktrace_map.c |  40 +-
>  .../testing/selftests/bpf/progs/test_tc_edt.c |   9 +-
>  .../bpf/progs/test_tcp_check_syncookie_kern.c |   9 +-
>  .../selftests/bpf/progs/test_tcp_estats.c     |   9 +-
>  .../selftests/bpf/progs/test_tcpbpf_kern.c    |  18 +-
>  .../selftests/bpf/progs/test_tcpnotify_kern.c |  18 +-
>  tools/testing/selftests/bpf/progs/test_xdp.c  |  18 +-
>  .../selftests/bpf/progs/test_xdp_noinline.c   |  60 +-
>  tools/testing/selftests/bpf/test_btf.c        |  10 +-
>  .../selftests/bpf/test_queue_stack_map.h      |  20 +-
>  .../testing/selftests/bpf/test_sockmap_kern.h |  72 +-
>  38 files changed, 1199 insertions(+), 495 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_btf_newkv.c
> 

