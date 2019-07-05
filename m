Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DD560D40
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 23:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfGEVow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 17:44:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:49732 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfGEVow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 17:44:52 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjW0b-0002eV-FV; Fri, 05 Jul 2019 23:44:45 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjW0b-0000iX-6b; Fri, 05 Jul 2019 23:44:45 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf, libbpf: add a new API
 bpf_object__reuse_maps()
To:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, andriin@fb.com
References: <cover.1562359091.git.a.s.protopopov@gmail.com>
 <e183c0af99056f8ea4de06acb358ace7f3a3d6ae.1562359091.git.a.s.protopopov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <734dd45a-95b0-a7fd-9e1d-0535ef4d3e12@iogearbox.net>
Date:   Fri, 5 Jul 2019 23:44:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <e183c0af99056f8ea4de06acb358ace7f3a3d6ae.1562359091.git.a.s.protopopov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2019 10:44 PM, Anton Protopopov wrote:
> Add a new API bpf_object__reuse_maps() which can be used to replace all maps in
> an object by maps pinned to a directory provided in the path argument.  Namely,
> each map M in the object will be replaced by a map pinned to path/M.name.
> 
> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c   | 34 ++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 37 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4907997289e9..84c9e8f7bfd3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3144,6 +3144,40 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>  	return 0;
>  }
>  
> +int bpf_object__reuse_maps(struct bpf_object *obj, const char *path)
> +{
> +	struct bpf_map *map;
> +
> +	if (!obj)
> +		return -ENOENT;
> +
> +	if (!path)
> +		return -EINVAL;
> +
> +	bpf_object__for_each_map(map, obj) {
> +		int len, err;
> +		int pinned_map_fd;
> +		char buf[PATH_MAX];

We'd need to skip the case of bpf_map__is_internal(map) since they are always
recreated for the given object.

> +		len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
> +		if (len < 0) {
> +			return -EINVAL;
> +		} else if (len >= PATH_MAX) {
> +			return -ENAMETOOLONG;
> +		}
> +
> +		pinned_map_fd = bpf_obj_get(buf);
> +		if (pinned_map_fd < 0)
> +			return pinned_map_fd;

Should we rather have a new map definition attribute that tells to reuse
the map if it's pinned in bpf fs, and if not, we create it and later on
pin it? This is what iproute2 is doing and which we're making use of heavily.
In bpf_object__reuse_maps() bailing out if bpf_obj_get() fails is perhaps
too limiting for a generic API as new version of an object file may contain
new maps which are not yet present in bpf fs at that point.

> +		err = bpf_map__reuse_fd(map, pinned_map_fd);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
>  int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>  {
>  	struct bpf_program *prog;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index d639f47e3110..7fe465a1be76 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -82,6 +82,8 @@ int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
>  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
>  LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
>  				      const char *path);
> +LIBBPF_API int bpf_object__reuse_maps(struct bpf_object *obj,
> +				      const char *path);
>  LIBBPF_API int bpf_object__pin_programs(struct bpf_object *obj,
>  					const char *path);
>  LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 2c6d835620d2..66a30be6696c 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -172,5 +172,6 @@ LIBBPF_0.0.4 {
>  		btf_dump__new;
>  		btf__parse_elf;
>  		bpf_object__load_xattr;
> +		bpf_object__reuse_maps;
>  		libbpf_num_possible_cpus;
>  } LIBBPF_0.0.3;
> 

