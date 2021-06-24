Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048E53B3244
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhFXPJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:09:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:40620 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbhFXPJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:09:04 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwQwA-000Ecy-3N; Thu, 24 Jun 2021 17:06:38 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwQw9-000Cue-Ro; Thu, 24 Jun 2021 17:06:37 +0200
Subject: Re: [PATCH bpf-next] libbpf: Introduce 'custom_btf_path' to
 'bpf_obj_open_opts'.
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1624507409-114522-1-git-send-email-chengshuyi@linux.alibaba.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8ca15bab-ec66-657d-570a-278deff0b1a3@iogearbox.net>
Date:   Thu, 24 Jun 2021 17:06:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1624507409-114522-1-git-send-email-chengshuyi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26211/Thu Jun 24 13:04:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/21 6:03 AM, Shuyi Cheng wrote:
> In order to enable the older kernel to use the CO-RE feature, load the
> vmlinux btf of the specified path.
> 
> Learn from Andrii's comments in [0], add the custom_btf_path parameter
> to bpf_obj_open_opts, you can directly use the skeleton's
> <objname>_bpf__open_opts function to pass in the custom_btf_path
> parameter.
> 
> Prior to this, there was also a developer who provided a patch with
> similar functions. It is a pity that the follow-up did not continue to
> advance. See [1].
> 
> 	[0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
> 	[1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/
> 
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
>   tools/lib/bpf/libbpf.c | 23 ++++++++++++++++++++---
>   tools/lib/bpf/libbpf.h |  6 +++++-
>   2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e04ce7..518b19f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -509,6 +509,8 @@ struct bpf_object {
>   	void *priv;
>   	bpf_object_clear_priv_t clear_priv;
>   
> +	char *custom_btf_path;
> +

nit: This should rather go to the 'Parse and load BTF vmlinux if any of [...]'
section of struct bpf_object, and for consistency, I'd keep the btf_ prefix,
like: char *btf_custom_path

>   	char path[];
>   };
>   #define obj_elf_valid(o)	((o)->efile.elf)
> @@ -2679,8 +2681,15 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
>   	if (!force && !obj_needs_vmlinux_btf(obj))
>   		return 0;
>   
> -	obj->btf_vmlinux = libbpf_find_kernel_btf();
> -	err = libbpf_get_error(obj->btf_vmlinux);
> +	if (obj->custom_btf_path) {
> +		obj->btf_vmlinux = btf__parse(obj->custom_btf_path, NULL);
> +		err = libbpf_get_error(obj->btf_vmlinux);
> +		pr_debug("loading custom vmlinux BTF '%s': %d\n", obj->custom_btf_path, err);
> +	} else {
> +		obj->btf_vmlinux = libbpf_find_kernel_btf();
> +		err = libbpf_get_error(obj->btf_vmlinux);
> +	}

Couldn't we do something like (only compile-tested):

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index b46760b93bb4..5b88ce3e483c 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4394,7 +4394,7 @@ static int btf_dedup_remap_types(struct btf_dedup *d)
   * Probe few well-known locations for vmlinux kernel image and try to load BTF
   * data out of it to use for target BTF.
   */
-struct btf *libbpf_find_kernel_btf(void)
+static struct btf *__libbpf_find_kernel_btf(char *btf_custom_path)
  {
  	struct {
  		const char *path_fmt;
@@ -4402,6 +4402,8 @@ struct btf *libbpf_find_kernel_btf(void)
  	} locations[] = {
  		/* try canonical vmlinux BTF through sysfs first */
  		{ "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
+		/* try user defined vmlinux ELF if a path was specified */
+		{ btf_custom_path },
  		/* fall back to trying to find vmlinux ELF on disk otherwise */
  		{ "/boot/vmlinux-%1$s" },
  		{ "/lib/modules/%1$s/vmlinux-%1$s" },
@@ -4419,11 +4421,11 @@ struct btf *libbpf_find_kernel_btf(void)
  	uname(&buf);

  	for (i = 0; i < ARRAY_SIZE(locations); i++) {
+		if (!locations[i].path_fmt)
+			continue;
  		snprintf(path, PATH_MAX, locations[i].path_fmt, buf.release);
-
  		if (access(path, R_OK))
  			continue;
-
  		if (locations[i].raw_btf)
  			btf = btf__parse_raw(path);
  		else
@@ -4440,6 +4442,11 @@ struct btf *libbpf_find_kernel_btf(void)
  	return libbpf_err_ptr(-ESRCH);
  }

+struct btf *libbpf_find_kernel_btf(void)
+{
+	return __libbpf_find_kernel_btf(NULL);
+}
+
  int btf_type_visit_type_ids(struct btf_type *t, type_id_visit_fn visit, void *ctx)
  {
  	int i, n, err;

And then you just call it as:

	obj->btf_vmlinux = __libbpf_find_kernel_btf(obj->btf_custom_path);
	err = libbpf_get_error(obj->btf_vmlinux);

>   	if (err) {
>   		pr_warn("Error loading vmlinux BTF: %d\n", err);
>   		obj->btf_vmlinux = NULL;
> @@ -7554,7 +7563,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>   __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>   		   const struct bpf_object_open_opts *opts)
>   {
> -	const char *obj_name, *kconfig;
> +	const char *obj_name, *kconfig, *tmp_btf_path;
>   	struct bpf_program *prog;
>   	struct bpf_object *obj;
>   	char tmp_name[64];
> @@ -7584,6 +7593,13 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>   	obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
>   	if (IS_ERR(obj))
>   		return obj;
> +
> +	tmp_btf_path = OPTS_GET(opts, custom_btf_path, NULL);
> +	if (tmp_btf_path && strlen(tmp_btf_path) < PATH_MAX) {
> +		obj->custom_btf_path = strdup(tmp_btf_path);
> +		if (!obj->custom_btf_path)
> +			return ERR_PTR(-ENOMEM);
> +	}
>   
>   	kconfig = OPTS_GET(opts, kconfig, NULL);
>   	if (kconfig) {
> @@ -8702,6 +8718,7 @@ void bpf_object__close(struct bpf_object *obj)
>   	for (i = 0; i < obj->nr_maps; i++)
>   		bpf_map__destroy(&obj->maps[i]);
>   
> +	zfree(&obj->custom_btf_path);
>   	zfree(&obj->kconfig);
>   	zfree(&obj->externs);
>   	obj->nr_extern = 0;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 6e61342..16e0f01 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -94,8 +94,12 @@ struct bpf_object_open_opts {
>   	 * system Kconfig for CONFIG_xxx externs.
>   	 */
>   	const char *kconfig;
> +	/* Specify the path of vmlinux btf to facilitate the use of CO-RE features
> +	 * in the old kernel.
> +	 */
> +	char *custom_btf_path;
>   };
> -#define bpf_object_open_opts__last_field kconfig
> +#define bpf_object_open_opts__last_field custom_btf_path
>   
>   LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>   LIBBPF_API struct bpf_object *
> 

