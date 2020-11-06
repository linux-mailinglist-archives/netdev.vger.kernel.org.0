Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EB22A8F98
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgKFGoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:44:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgKFGoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 01:44:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8303F206B2;
        Fri,  6 Nov 2020 06:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604645042;
        bh=5IGSjBH7HAl45aU+KNIibXuTyAFDfpYcmKSrFXFQ8+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oKGzLAxgla3D4MsWG+C3Ncg3qm3pkgV0AQaARY78ra1q91bCYmDZgdw4NfZYbUNhC
         dOl5tsMTzCiIo9mlcRUFk1zlIVYEjZzNCI7bRvnV4ugOYIJlpmyWta8yxnDQTodyFh
         SsEShOcziiFd4WICIlJ2LN+wwrGp5o2m1GrGmVSw=
Date:   Fri, 6 Nov 2020 07:43:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org, jeyu@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH bpf-next 4/5] bpf: load and verify kernel module BTFs
Message-ID: <20201106064358.GA697514@kroah.com>
References: <20201106055111.3972047-1-andrii@kernel.org>
 <20201106055111.3972047-5-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106055111.3972047-5-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 09:51:09PM -0800, Andrii Nakryiko wrote:
> Add kernel module listener that will load/validate and unload module BTF.
> Module BTFs gets ID generated for them, which makes it possible to iterate
> them with existing BTF iteration API. They are given their respective module's
> names, which will get reported through GET_OBJ_INFO API. They are also marked
> as in-kernel BTFs for tooling to distinguish them from user-provided BTFs.
> 
> Also, similarly to vmlinux BTF, kernel module BTFs are exposed through
> sysfs as /sys/kernel/btf/<module-name>. This is convenient for user-space
> tools to inspect module BTF contents and dump their types with existing tools:
> 
> [vmuser@archvm bpf]$ ls -la /sys/kernel/btf
> total 0
> drwxr-xr-x  2 root root       0 Nov  4 19:46 .
> drwxr-xr-x 13 root root       0 Nov  4 19:46 ..
> 
> ...
> 
> -r--r--r--  1 root root     888 Nov  4 19:46 irqbypass
> -r--r--r--  1 root root  100225 Nov  4 19:46 kvm
> -r--r--r--  1 root root   35401 Nov  4 19:46 kvm_intel
> -r--r--r--  1 root root     120 Nov  4 19:46 pcspkr
> -r--r--r--  1 root root     399 Nov  4 19:46 serio_raw
> -r--r--r--  1 root root 4094095 Nov  4 19:46 vmlinux
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  Documentation/ABI/testing/sysfs-kernel-btf |   8 +
>  include/linux/bpf.h                        |   2 +
>  include/linux/module.h                     |   4 +
>  kernel/bpf/btf.c                           | 193 +++++++++++++++++++++
>  kernel/bpf/sysfs_btf.c                     |   2 +-
>  kernel/module.c                            |  32 ++++
>  6 files changed, 240 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-btf b/Documentation/ABI/testing/sysfs-kernel-btf
> index 2c9744b2cd59..fe96efdc9b6c 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-btf
> +++ b/Documentation/ABI/testing/sysfs-kernel-btf
> @@ -15,3 +15,11 @@ Description:
>  		information with description of all internal kernel types. See
>  		Documentation/bpf/btf.rst for detailed description of format
>  		itself.
> +
> +What:		/sys/kernel/btf/<module-name>
> +Date:		Nov 2020
> +KernelVersion:	5.11
> +Contact:	bpf@vger.kernel.org
> +Description:
> +		Read-only binary attribute exposing kernel module's BTF type
> +		information as an add-on to the kernel's BTF (/sys/kernel/btf/vmlinux).
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 2fffd30e13ac..3cb89cd7177b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -36,9 +36,11 @@ struct seq_operations;
>  struct bpf_iter_aux_info;
>  struct bpf_local_storage;
>  struct bpf_local_storage_map;
> +struct kobject;
>  
>  extern struct idr btf_idr;
>  extern spinlock_t btf_idr_lock;
> +extern struct kobject *btf_kobj;
>  
>  typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
>  					struct bpf_iter_aux_info *aux);
> diff --git a/include/linux/module.h b/include/linux/module.h
> index a29187f7c360..20fce258ffba 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -475,6 +475,10 @@ struct module {
>  	unsigned int num_bpf_raw_events;
>  	struct bpf_raw_event_map *bpf_raw_events;
>  #endif
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +	unsigned int btf_data_size;
> +	void *btf_data;
> +#endif
>  #ifdef CONFIG_JUMP_LABEL
>  	struct jump_entry *jump_entries;
>  	unsigned int num_jump_entries;
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 09f1483934d2..fe639ffae361 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -23,6 +23,8 @@
>  #include <linux/perf_event.h>
>  #include <linux/bsearch.h>
>  #include <linux/btf_ids.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
>  #include <net/sock.h>
>  
>  /* BTF (BPF Type Format) is the meta data format which describes
> @@ -4488,6 +4490,75 @@ struct btf *btf_parse_vmlinux(void)
>  	return ERR_PTR(err);
>  }
>  
> +static struct btf *btf_parse_module(const char *module_name, const void *data, unsigned int data_size)
> +{
> +	struct btf_verifier_env *env = NULL;
> +	struct bpf_verifier_log *log;
> +	struct btf *btf = NULL, *base_btf;
> +	int err;
> +
> +	base_btf = bpf_get_btf_vmlinux();
> +	if (IS_ERR(base_btf))
> +		return base_btf;
> +	if (!base_btf)
> +		return ERR_PTR(-EINVAL);
> +
> +	env = kzalloc(sizeof(*env), GFP_KERNEL | __GFP_NOWARN);
> +	if (!env)
> +		return ERR_PTR(-ENOMEM);
> +
> +	log = &env->log;
> +	log->level = BPF_LOG_KERNEL;
> +
> +	btf = kzalloc(sizeof(*btf), GFP_KERNEL | __GFP_NOWARN);
> +	if (!btf) {
> +		err = -ENOMEM;
> +		goto errout;
> +	}
> +	env->btf = btf;
> +
> +	btf->base_btf = base_btf;
> +	btf->start_id = base_btf->nr_types;
> +	btf->start_str_off = base_btf->hdr.str_len;
> +	btf->kernel_btf = true;
> +	snprintf(btf->name, sizeof(btf->name), "%s", module_name);
> +
> +	btf->data = kvmalloc(data_size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!btf->data) {
> +		err = -ENOMEM;
> +		goto errout;
> +	}
> +	memcpy(btf->data, data, data_size);
> +	btf->data_size = data_size;
> +
> +	err = btf_parse_hdr(env);
> +	if (err)
> +		goto errout;
> +
> +	btf->nohdr_data = btf->data + btf->hdr.hdr_len;
> +
> +	err = btf_parse_str_sec(env);
> +	if (err)
> +		goto errout;
> +
> +	err = btf_check_all_metas(env);
> +	if (err)
> +		goto errout;
> +
> +	btf_verifier_env_free(env);
> +	refcount_set(&btf->refcnt, 1);
> +	return btf;
> +
> +errout:
> +	btf_verifier_env_free(env);
> +	if (btf) {
> +		kvfree(btf->data);
> +		kvfree(btf->types);
> +		kfree(btf);
> +	}
> +	return ERR_PTR(err);
> +}
> +
>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
>  {
>  	struct bpf_prog *tgt_prog = prog->aux->dst_prog;
> @@ -5661,3 +5732,125 @@ bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
>  {
>  	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
>  }
> +
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +struct btf_module {
> +	struct list_head list;
> +	struct module *module;
> +	struct btf *btf;
> +	struct bin_attribute *sysfs_attr;
> +};
> +
> +static LIST_HEAD(btf_modules);
> +static DEFINE_MUTEX(btf_module_mutex);
> +
> +static ssize_t
> +btf_module_read(struct file *file, struct kobject *kobj,
> +		struct bin_attribute *bin_attr,
> +		char *buf, loff_t off, size_t len)
> +{
> +	const struct btf *btf = bin_attr->private;
> +
> +	memcpy(buf, btf->data + off, len);
> +	return len;
> +}
> +
> +static int btf_module_notify(struct notifier_block *nb, unsigned long op,
> +			     void *module)
> +{
> +	struct btf_module *btf_mod, *tmp;
> +	struct module *mod = module;
> +	struct btf *btf;
> +	int err = 0;
> +
> +	if (mod->btf_data_size == 0 ||
> +	    (op != MODULE_STATE_COMING && op != MODULE_STATE_GOING))
> +		goto out;
> +
> +	switch (op) {
> +	case MODULE_STATE_COMING:
> +		btf_mod = kzalloc(sizeof(*btf_mod), GFP_KERNEL);
> +		if (!btf_mod) {
> +			err = -ENOMEM;
> +			goto out;
> +		}
> +		btf = btf_parse_module(mod->name, mod->btf_data, mod->btf_data_size);
> +		if (IS_ERR(btf)) {
> +			kfree(btf_mod);
> +			err = PTR_ERR(btf);
> +			goto out;
> +		}
> +		err = btf_alloc_id(btf);
> +		if (err) {
> +			btf_free(btf);
> +			kfree(btf_mod);
> +			goto out;
> +		}
> +
> +		mutex_lock(&btf_module_mutex);
> +		btf_mod->module = module;
> +		btf_mod->btf = btf;
> +		list_add(&btf_mod->list, &btf_modules);
> +		mutex_unlock(&btf_module_mutex);
> +
> +		if (IS_ENABLED(CONFIG_SYSFS)) {
> +			struct bin_attribute *attr;
> +
> +			attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> +			if (!attr) {
> +				WARN(1, "failed to register module [%s] BTF in sysfs\n", mod->name);

kzalloc() will print errors on its own, no need to do this again.  Also,
for systems with panic-on-warn, you just crashed them, not nice :(

> +				goto out;
> +			}
> +
> +			attr->attr.name = btf->name;
> +			attr->attr.mode = 0444;
> +			attr->size = btf->data_size;
> +			attr->private = btf;
> +			attr->read = btf_module_read;
> +
> +			err = sysfs_create_bin_file(btf_kobj, attr);

You forgot to call sysfs_bin_attr_init() to initialize your binary sysfs
attribute.  You'll only notice if you turn lockdep on.


> +			if (err) {
> +				kfree(attr);
> +				WARN(1, "failed to register module [%s] BTF in sysfs: %d\n",
> +				     mod->name, err);

Again, just report the error and move on, don't crash systems.

Other than these minor things, looks good to me, nice work!

thanks,

greg k-h
