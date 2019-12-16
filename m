Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3B212038D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 12:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfLPLRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 06:17:40 -0500
Received: from www62.your-server.de ([213.133.104.62]:43368 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfLPLRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 06:17:39 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igoNc-0007qp-Ox; Mon, 16 Dec 2019 12:17:36 +0100
Date:   Mon, 16 Dec 2019 12:17:36 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
Message-ID: <20191216111736.GA14887@linux.fritz.box>
References: <20191214014710.3449601-1-andriin@fb.com>
 <20191214014710.3449601-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214014710.3449601-3-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:47:08PM -0800, Andrii Nakryiko wrote:
> Add support for extern variables, provided to BPF program by libbpf. Currently
> the following extern variables are supported:
>   - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
>     executing, follows KERNEL_VERSION() macro convention, can be 4- and 8-byte
>     long;
>   - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
>     boolean, strings, and integer values are supported.
> 
[...]
> 
> All detected extern variables, are put into a separate .extern internal map.
> It, similarly to .rodata map, is marked as read-only from BPF program side, as
> well as is frozen on load. This allows BPF verifier to track extern values as
> constants and perform enhanced branch prediction and dead code elimination.
> This can be relied upon for doing kernel version/feature detection and using
> potentially unsupported field relocations or BPF helpers in a CO-RE-based BPF
> program, while still having a single version of BPF program running on old and
> new kernels. Selftests are validating this explicitly for unexisting BPF
> helper.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
[...]
> +static int bpf_object__resolve_externs(struct bpf_object *obj,
> +				       const char *config_path)
> +{
> +	bool need_config = false;
> +	struct extern_desc *ext;
> +	int err, i;
> +	void *data;
> +
> +	if (obj->nr_extern == 0)
> +		return 0;
> +
> +	data = obj->maps[obj->extern_map_idx].mmaped;
> +
> +	for (i = 0; i < obj->nr_extern; i++) {
> +		ext = &obj->externs[i];
> +
> +		if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
> +			void *ext_val = data + ext->data_off;
> +			__u32 kver = get_kernel_version();
> +
> +			if (!kver) {
> +				pr_warn("failed to get kernel version\n");
> +				return -EINVAL;
> +			}
> +			err = set_ext_value_num(ext, ext_val, kver);
> +			if (err)
> +				return err;
> +			pr_debug("extern %s=0x%x\n", ext->name, kver);
> +		} else if (strncmp(ext->name, "CONFIG_", 7) == 0) {
> +			need_config = true;
> +		} else {
> +			pr_warn("unrecognized extern '%s'\n", ext->name);
> +			return -EINVAL;
> +		}

I don't quite like that this is (mainly) tracing-only specific, and that
for everything else we just bail out - there is much more potential than
just completing above vars. But also, there is also no way to opt-out
for application developers of /this specific/ semi-magic auto-completion
of externs.

bpf_object__resolve_externs() should be changed instead to invoke a
callback obj->resolve_externs(). Former can be passed by the application
developer to allow them to take care of extern resolution all by themself,
and if no callback has been passed, then we default to the one above
being set as obj->resolve_externs.

> +	}
> +	if (need_config) {
> +		err = bpf_object__read_kernel_config(obj, config_path, data);
> +		if (err)
> +			return -EINVAL;
> +	}
> +	for (i = 0; i < obj->nr_extern; i++) {
> +		ext = &obj->externs[i];
> +
> +		if (!ext->is_set && !ext->is_weak) {
> +			pr_warn("extern %s (strong) not resolved\n", ext->name);
> +			return -ESRCH;
> +		} else if (!ext->is_set) {
> +			pr_debug("extern %s (weak) not resolved, defaulting to zero\n",
> +				 ext->name);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>  {
>  	struct bpf_object *obj;
> @@ -4126,6 +4753,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>  	obj->loaded = true;
>  
>  	err = bpf_object__probe_caps(obj);
> +	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig_path);
>  	err = err ? : bpf_object__sanitize_and_load_btf(obj);
>  	err = err ? : bpf_object__sanitize_maps(obj);
>  	err = err ? : bpf_object__create_maps(obj);
[...]
