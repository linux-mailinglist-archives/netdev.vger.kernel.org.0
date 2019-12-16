Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4312085E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfLPOQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:16:13 -0500
Received: from www62.your-server.de ([213.133.104.62]:37798 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbfLPOQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:16:12 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igrAO-0006vu-Vq; Mon, 16 Dec 2019 15:16:09 +0100
Date:   Mon, 16 Dec 2019 15:16:08 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191216141608.GE14887@linux.fritz.box>
References: <20191210011438.4182911-1-andriin@fb.com>
 <20191210011438.4182911-12-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210011438.4182911-12-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 05:14:34PM -0800, Andrii Nakryiko wrote:
> Add `bpftool gen skeleton` command, which takes in compiled BPF .o object file
> and dumps a BPF skeleton struct and related code to work with that skeleton.
> Skeleton itself is tailored to a specific structure of provided BPF object
> file, containing accessors (just plain struct fields) for every map and
> program, as well as dedicated space for bpf_links. If BPF program is using
> global variables, corresponding structure definitions of compatible memory
> layout are emitted as well, making it possible to initialize and subsequently
> read/update global variables values using simple and clear C syntax for
> accessing fields. This skeleton majorly improves usability of
> opening/loading/attaching of BPF object, as well as interacting with it
> throughout the lifetime of loaded BPF object.
> 
> Generated skeleton struct has the following structure:
> 
> struct <object-name> {
> 	/* used by libbpf's skeleton API */
> 	struct bpf_object_skeleton *skeleton;
> 	/* bpf_object for libbpf APIs */
> 	struct bpf_object *obj;
> 	struct {
> 		/* for every defined map in BPF object: */
> 		struct bpf_map *<map-name>;
> 	} maps;
> 	struct {
> 		/* for every program in BPF object: */
> 		struct bpf_program *<program-name>;
> 	} progs;
> 	struct {
> 		/* for every program in BPF object: */
> 		struct bpf_link *<program-name>;
> 	} links;
> 	/* for every present global data section: */
> 	struct <object-name>__<one of bss, data, or rodata> {
> 		/* memory layout of corresponding data section,
> 		 * with every defined variable represented as a struct field
> 		 * with exactly the same type, but without const/volatile
> 		 * modifiers, e.g.:
> 		 */
> 		 int *my_var_1;
> 		 ...
> 	} *<one of bss, data, or rodata>;
> };
> 
> This provides great usability improvements:
> - no need to look up maps and programs by name, instead just
>   my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
>   bpf_map/bpf_program pointers, which user can pass to existing libbpf APIs;
> - pre-defined places for bpf_links, which will be automatically populated for
>   program types that libbpf knows how to attach automatically (currently
>   tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
>   tearing down skeleton, all active bpf_links will be destroyed (meaning BPF
>   programs will be detached, if they are attached). For cases in which libbpf
>   doesn't know how to auto-attach BPF program, user can manually create link
>   after loading skeleton and they will be auto-detached on skeleton
>   destruction:
> 
> 	my_obj->links.my_fancy_prog = bpf_program__attach_cgroup_whatever(
> 		my_obj->progs.my_fancy_prog, <whatever extra param);
> 
> - it's extremely easy and convenient to work with global data from userspace
>   now. Both for read-only and read/write variables, it's possible to
>   pre-initialize them before skeleton is loaded:
> 
> 	skel = my_obj__open(raw_embed_data);
> 	my_obj->rodata->my_var = 123;
> 	my_obj__load(skel); /* 123 will be initialization value for my_var */
> 
>   After load, if kernel supports mmap() for BPF arrays, user can still read
>   (and write for .bss and .data) variables values, but at that point it will
>   be directly mmap()-ed to BPF array, backing global variables. This allows to
>   seamlessly exchange data with BPF side. From userspace program's POV, all
>   the pointers and memory contents stay the same, but mapped kernel memory
>   changes to point to created map.
>   If kernel doesn't yet support mmap() for BPF arrays, it's still possible to
>   use those data section structs to pre-initialize .bss, .data, and .rodata,
>   but after load their pointers will be reset to NULL, allowing user code to
>   gracefully handle this condition, if necessary.
> 
> Given a big surface area, skeleton is kept as an experimental non-public
> API for now, until more feedback and real-world experience is collected.

Can you elaborate on the plan here? This is until v5.6 is out and hence a new
bpftool release implicitly where this becomes frozen / non-experimental?

There is also tools/bpf/bpftool/Documentation/bpftool-gen.rst missing. Given
you aim to collect more feedback (?), it would be appropriate to document
everything in there so users have a clue how to use it for getting started.

Also, I think at least some more clarification is needed in such document on
the following topics:

- libbpf and bpftool is both 'GPL-2.0-only' or 'BSD-2-Clause'. Given this
  is a code generator, what license is the `bpftool gen skeleton` result?
  In any case, should there also be a header comment emitted via do_skeleton()?

- Clear statement that this codegen is an alternative to regular libbpf
  API usage but that both are always kept feature-complete and hence not
  disadvantaged in one way or another (to rule out any uncertainties for
  users e.g. whether they now need to start rewriting their existing code
  etc); with purpose of the former (codgen) to simplify loader interaction.

Thanks,
Daniel
