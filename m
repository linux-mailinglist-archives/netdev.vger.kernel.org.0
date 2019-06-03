Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8033B6D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFCWeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:34:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43209 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFCWeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:34:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so4347744qtj.10;
        Mon, 03 Jun 2019 15:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hUDi3LpJDfbh5JFvsyRAzGmS70LuLctJXOtDXn0LQ2Q=;
        b=D7qJebudrGZeM1gOmc8jtIR6aIIHgpsJ8sYSHcLSX593cDg/MLokBdWE3Dc/4yxJLW
         TEAgKcBdl1OU2WlLxZ8ImKNN8dwvRe2vQDf83zOTc59Ydzpqv7nINiUw10YWeIHBjPM9
         WUigYO2x0AfogSKwADhhcVGPkBZQlSZhAj9G1cunBakpKr4zn8uTZBvG+HyKAzXIy/tc
         ci07EH8yK3KtgJT0AQ+D4MIXpU7xPmwXT5F/FUbgZL4qHx5gOA5/DzZeYjJELHdj1LWD
         VfzNfmMRNVrnpcf7Kb1YLgYdhtBV683/zHPcjCUVHqCZwmzTPWtqn1qeU0Bcw9i6cs+R
         y0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hUDi3LpJDfbh5JFvsyRAzGmS70LuLctJXOtDXn0LQ2Q=;
        b=g+uR6a6NS6U+EApyaRmIeRXLDDoLu1xaigD0UxXmUxnudVvx/9VoU1IO16opVodtnW
         prx/S/gn5jR7UB3cpLwaO16bR5ntTRzpqp3ld38TG/PIS2S4WH3Gv74eb2QsU8enC5Vc
         Bz9r1Ga2J8XyiIf4dd7NeDZjYVU0KU7NkZ+voKg1q6kh1iPcKxBjcLLhMg9zRQeuMmip
         1RPUCXq8hcbsxSPsbfVYmr/XyM5oekyBQZxUg85Itp7p5e26MAHAPctSE5m7sVo+PDkM
         PhJF4LHzwdUM+W2e+7iVArDokGU83GAAGUDa+FY0Ht0F6TD/yZjk+kWEmkAbg3tD3pCT
         0M2g==
X-Gm-Message-State: APjAAAUvbb5RdsbBfhfHc7YsSrKdv0jPLO1kQVR8yY2sgfpdji92p3yh
        Ab8j2tUFioDP+OcdVroDdYutcYuu5FnjDHIHZDn2rZTxWQE=
X-Google-Smtp-Source: APXvYqzRDhbCUq4oamjTp7IFBzoFqATLRDyx7vn9DWCXD+P/G7Mm39rg8ZHzRHYYYBY9yKRu+AczaS5kivZNODkB7ew=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr5360414qtl.117.1559601258098;
 Mon, 03 Jun 2019 15:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
In-Reply-To: <20190531202132.379386-7-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Jun 2019 15:34:06 -0700
Message-ID: <CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntWAkJt47=FE+km+A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 1:21 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch adds support for a new way to define BPF maps. It relies on
> BTF to describe mandatory and optional attributes of a map, as well as
> captures type information of key and value naturally. This eliminates
> the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> always in sync with the key/value type.
>
> Relying on BTF, this approach allows for both forward and backward
> compatibility w.r.t. extending supported map definition features. Old
> libbpf implementation will ignore fields it doesn't recognize, while new
> implementations will parse and recognize new optional attributes.
>
> The outline of the new map definition (short, BTF-defined maps) is as follows:
> 1. All the maps should be defined in .maps ELF section. It's possible to
>    have both "legacy" map definitions in `maps` sections and BTF-defined
>    maps in .maps sections. Everything will still work transparently.
> 2. The map declaration and initialization is done through
>    a global/static variable of a struct type with few mandatory and
>    extra optional fields:
>    - type field is mandatory and specified type of BPF map;
>    - key/value fields are mandatory and capture key/value type/size information;
>    - max_entries attribute is optional; if max_entries is not specified or
>      initialized, it has to be provided in runtime through libbpf API
>      before loading bpf_object;
>    - map_flags is optional and if not defined, will be assumed to be 0.
> 3. Key/value fields should be **a pointer** to a type describing
>    key/value. The pointee type is assumed (and will be recorded as such
>    and used for size determination) to be a type describing key/value of
>    the map. This is done to save excessive amounts of space allocated in
>    corresponding ELF sections for key/value of big size.
> 4. As some maps disallow having BTF type ID associated with key/value,
>    it's possible to specify key/value size explicitly without
>    associating BTF type ID with it. Use key_size and value_size fields
>    to do that (see example below).
>
> Here's an example of simple ARRAY map defintion:
>
> struct my_value { int x, y, z; };
>
> struct {
>         int type;
>         int max_entries;
>         int *key;
>         struct my_value *value;
> } btf_map SEC(".maps") = {
>         .type = BPF_MAP_TYPE_ARRAY,
>         .max_entries = 16,
> };
>
> This will define BPF ARRAY map 'btf_map' with 16 elements. The key will
> be of type int and thus key size will be 4 bytes. The value is struct
> my_value of size 12 bytes. This map can be used from C code exactly the
> same as with existing maps defined through struct bpf_map_def.
>
> Here's an example of STACKMAP definition (which currently disallows BTF type
> IDs for key/value):
>
> struct {
>         __u32 type;
>         __u32 max_entries;
>         __u32 map_flags;
>         __u32 key_size;
>         __u32 value_size;
> } stackmap SEC(".maps") = {
>         .type = BPF_MAP_TYPE_STACK_TRACE,
>         .max_entries = 128,
>         .map_flags = BPF_F_STACK_BUILD_ID,
>         .key_size = sizeof(__u32),
>         .value_size = PERF_MAX_STACK_DEPTH * sizeof(struct bpf_stack_build_id),
> };
>
> This approach is naturally extended to support map-in-map, by making a value
> field to be another struct that describes inner map. This feature is not
> implemented yet. It's also possible to incrementally add features like pinning
> with full backwards and forward compatibility.

So I wanted to elaborate a bit more on what I'm planning to add, once
we agree on the approach. Those are the features that are currently
supported by iproute2 loader and here's how I was thinking to support
them with BTF-defined maps. Once all this is implemented, there should
be just a mechanical field rename to switch BPF apps relying on
iproute2 loader (size_key -> key_size, size_value -> value_size,
max_elem -> max_entries) for most maps. For more complicated cases
described below, I hope we can agree it's easy to migrate and end
result might even look better (because more explicit).

1. Pinning. This one is simple:
  - add pinning attribute, that will either be "no pinning", "global
pinning", "object-scope pinning".
  - by default pinning root will be "/sys/fs/bpf", but one will be
able to override this per-object using extra options (so that
"/sys/fs/bpf/tc" can be specified).

2. Map-in-map declaration:

As outlined at LSF/MM, we can extend value type to be another map
definition, specifying a prototype for inner map:

struct {
        int type;
        int max_entries;
        struct outer_key *key;
        struct { /* this is definition of inner map */
               int type;
               int max_entries;
               struct inner_key *key;
               struct inner_value *value;
        } value;
} my_hash_of_arrays BPF_MAP = {
        .type = BPF_MAP_TYPE_HASH_OF_MAPS,
        .max_entries = 1024,
        .value = {
                .type = BPF_MAP_TYPE_ARRAY,
                .max_entries = 64,
        },
};

This would declare a hash_of_maps, where inner maps are arrays of 64
elements each. Notice, that struct defining inner map can be declared
outside and shared with other maps:

struct inner_map_t {
        int type;
        int max_entries;
        struct inner_key *key;
        struct inner_value *value;
};

struct {
        int type;
        int max_entries;
        struct outer_key *key;
        struct inner_map_t value;
} my_hash_of_arrays BPF_MAP = {
        .type = BPF_MAP_TYPE_HASH_OF_MAPS,
        .max_entries = 1024,
        .value = {
                .type = BPF_MAP_TYPE_ARRAY,
                .max_entries = 64,
        },
};


3. Initialization of prog array. Iproute2 supports a convention-driven
initialization of BPF_MAP_TYPE_PROG_ARRAY using special section names
(wrapped into __section_tail(ID, IDX)):

struct bpf_elf_map SEC("maps") POLICY_CALL_MAP = {
        .type = BPF_MAP_TYPE_PROG_ARRAY,
        .id = MAP_ID,
        .size_key = sizeof(__u32),
        .size_value = sizeof(__u32),
        .max_elem = 16,
};

__section_tail(MAP_ID, MAP_IDX) int handle_policy(struct __sk_buff *skb)
{
        ...
}

For each such program, iproute2 will put its FD (for later
tail-calling) into a corresponding MAP with id == MAP_ID at index
MAP_IDX.

Here's how I see this supported in BTF-defined maps case.

typedef int (* skbuff_tailcall_fn)(struct __sk_buff *);

struct {
        int type;
        int max_entries;
        int *key;
        skbuff_tailcall_fb value[];
} POLICY_CALL_MAP SEC(".maps") = {
        .type = BPF_MAP_TYPE_PROG_ARRAY,
        .max_entries = 16,
        .value = {
                &handle_policy,
                NULL,
                &handle_some_other_policy,
        },
};

libbpf loader will greate BPF_MAP_TYPE_PROG_ARRAY map with 16 elements
and will initialize first and third entries with FDs of handle_policy
and handle_some_other_policy programs. As an added nice bonus,
compiler should also warn on signature mismatch. ;)


4. We can extend this idea into ARRAY_OF_MAPS initialization. This is
currently implemented in iproute2 using .id, .inner_id, and .inner_idx
fields.

struct inner_map_t {
        int type;
        int max_entries;
        struct inner_key *key;
        struct inner_value *value;
};

struct inner_map_t map1 = {...};
struct inner_map_t map2 = {...};

struct {
        int type;
        int max_entries;
        struct outer_key *key;
        struct inner_map_t value[];
} my_hash_of_arrays BPF_MAP = {
        .type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
        .max_entries = 2,
        .value = {
                &map1,
                &map2,
        },
};


There are a bunch of slight variations we might consider (e.g., value
vs values, when there is inline initialization, is it an array of
structs or an array of pointers to structs, etc), but the overall idea
stays the same.

So when all this is implemented and supported, from looking at Cilium,
it seems like conversion of iproute2 to libbpf should be rather simple
and painless. I'd be curious to hear what Cilium folks are thinking
about that.



>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
