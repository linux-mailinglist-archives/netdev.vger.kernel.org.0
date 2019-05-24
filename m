Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8712929711
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391010AbfEXLWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390772AbfEXLWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 07:22:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7CD8181112;
        Fri, 24 May 2019 11:22:22 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F702691B1;
        Fri, 24 May 2019 11:22:17 +0000 (UTC)
Date:   Fri, 24 May 2019 13:22:15 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add bpf_object__load_xattr()
 API function to pass log_level
Message-ID: <20190524132215.4113ff08@carbon>
In-Reply-To: <20190524103648.15669-3-quentin.monnet@netronome.com>
References: <20190524103648.15669-1-quentin.monnet@netronome.com>
        <20190524103648.15669-3-quentin.monnet@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 24 May 2019 11:22:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 11:36:47 +0100
Quentin Monnet <quentin.monnet@netronome.com> wrote:

> libbpf was recently made aware of the log_level attribute for programs,
> used to specify the level of information expected to be dumped by the
> verifier. Function bpf_prog_load_xattr() got support for this log_level
> parameter.
> 
> But some applications using libbpf rely on another function to load
> programs, bpf_object__load(), which does accept any parameter for log
> level. Create an API function based on bpf_object__load(), but accepting
> an "attr" object as a parameter. Then add a log_level field to that
> object, so that applications calling the new bpf_object__load_xattr()
> can pick the desired log level.

Does this allow us to extend struct bpf_object_load_attr later?

> v3:
> - Rewrite commit log.
> 
> v2:
> - We are in a new cycle, bump libbpf extraversion number.
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  tools/lib/bpf/Makefile   |  2 +-
>  tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
>  tools/lib/bpf/libbpf.h   |  6 ++++++
>  tools/lib/bpf/libbpf.map |  5 +++++
>  4 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index a2aceadf68db..9312066a1ae3 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -3,7 +3,7 @@
>  
>  BPF_VERSION = 0
>  BPF_PATCHLEVEL = 0
> -BPF_EXTRAVERSION = 3
> +BPF_EXTRAVERSION = 4
>  
>  MAKEFLAGS += --no-print-directory
>  
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 197b574406b3..1c6fb7a3201e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2222,7 +2222,7 @@ static bool bpf_program__is_function_storage(struct bpf_program *prog,
>  }
>  
>  static int
> -bpf_object__load_progs(struct bpf_object *obj)
> +bpf_object__load_progs(struct bpf_object *obj, int log_level)
>  {
>  	size_t i;
>  	int err;
> @@ -2230,6 +2230,7 @@ bpf_object__load_progs(struct bpf_object *obj)
>  	for (i = 0; i < obj->nr_programs; i++) {
>  		if (bpf_program__is_function_storage(&obj->programs[i], obj))
>  			continue;
> +		obj->programs[i].log_level = log_level;
>  		err = bpf_program__load(&obj->programs[i],
>  					obj->license,
>  					obj->kern_version);
> @@ -2381,10 +2382,14 @@ int bpf_object__unload(struct bpf_object *obj)
>  	return 0;
>  }
>  
> -int bpf_object__load(struct bpf_object *obj)
> +int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>  {
> +	struct bpf_object *obj;
>  	int err;
>  
> +	if (!attr)
> +		return -EINVAL;
> +	obj = attr->obj;
>  	if (!obj)
>  		return -EINVAL;
>  
> @@ -2397,7 +2402,7 @@ int bpf_object__load(struct bpf_object *obj)
>  
>  	CHECK_ERR(bpf_object__create_maps(obj), err, out);
>  	CHECK_ERR(bpf_object__relocate(obj), err, out);
> -	CHECK_ERR(bpf_object__load_progs(obj), err, out);
> +	CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out);
>  
>  	return 0;
>  out:
> @@ -2406,6 +2411,15 @@ int bpf_object__load(struct bpf_object *obj)
>  	return err;
>  }
>  
> +int bpf_object__load(struct bpf_object *obj)
> +{
> +	struct bpf_object_load_attr attr = {
> +		.obj = obj,
> +	};
> +
> +	return bpf_object__load_xattr(&attr);
> +}
> +
>  static int check_path(const char *path)
>  {
>  	char *cp, errmsg[STRERR_BUFSIZE];
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index c5ff00515ce7..e1c748db44f6 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -89,8 +89,14 @@ LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
>  LIBBPF_API int bpf_object__pin(struct bpf_object *object, const char *path);
>  LIBBPF_API void bpf_object__close(struct bpf_object *object);
>  
> +struct bpf_object_load_attr {
> +	struct bpf_object *obj;
> +	int log_level;
> +};

Can this be extended later?

>  /* Load/unload object into/from kernel */
>  LIBBPF_API int bpf_object__load(struct bpf_object *obj);
> +LIBBPF_API int bpf_object__load_xattr(struct bpf_object_load_attr *attr);
>  LIBBPF_API int bpf_object__unload(struct bpf_object *obj);
>  LIBBPF_API const char *bpf_object__name(struct bpf_object *obj);
>  LIBBPF_API unsigned int bpf_object__kversion(struct bpf_object *obj);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 673001787cba..6ce61fa0baf3 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -164,3 +164,8 @@ LIBBPF_0.0.3 {
>  		bpf_map_freeze;
>  		btf__finalize_data;
>  } LIBBPF_0.0.2;
> +
> +LIBBPF_0.0.4 {
> +	global:
> +		bpf_object__load_xattr;
> +} LIBBPF_0.0.3;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
