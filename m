Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E81050E281
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242280AbiDYOAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242309AbiDYOAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:00:33 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BBD7B124;
        Mon, 25 Apr 2022 06:57:21 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizDH-0006ck-SA; Mon, 25 Apr 2022 15:57:15 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizDH-0009jR-CR; Mon, 25 Apr 2022 15:57:15 +0200
Subject: Re: [PATCH bpf-next 2/4] libbpf: Add helpers for pinning bpf prog
 through bpf object skeleton
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220423140058.54414-1-laoar.shao@gmail.com>
 <20220423140058.54414-3-laoar.shao@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <29b077a7-1e99-9436-bd5a-4277651e09db@iogearbox.net>
Date:   Mon, 25 Apr 2022 15:57:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220423140058.54414-3-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/22 4:00 PM, Yafang Shao wrote:
> Currently there're helpers for allowing to open/load/attach BPF object
> through BPF object skeleton. Let's also add helpers for pinning through
> BPF object skeleton. It could simplify BPF userspace code which wants to
> pin the progs into bpffs.

Please elaborate some more on your use case/rationale for the commit message,
do you have orchestration code that will rely on these specifically?

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>   tools/lib/bpf/libbpf.c   | 59 ++++++++++++++++++++++++++++++++++++++++
>   tools/lib/bpf/libbpf.h   |  4 +++
>   tools/lib/bpf/libbpf.map |  2 ++
>   3 files changed, 65 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 13fcf91e9e0e..e7ed6c53c525 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -12726,6 +12726,65 @@ void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
>   	}
>   }
>   
> +int bpf_object__pin_skeleton_prog(struct bpf_object_skeleton *s,
> +				  const char *path)

These pin the link, not the prog itself, so the func name is a bit misleading? Also,
what if is this needs to be more customized in future? It doesn't seem very generic.

> +{
> +	struct bpf_link *link;
> +	int err;
> +	int i;
> +
> +	if (!s->prog_cnt)
> +		return libbpf_err(-EINVAL);
> +
> +	if (!path)
> +		path = DEFAULT_BPFFS;
> +
> +	for (i = 0; i < s->prog_cnt; i++) {
> +		char buf[PATH_MAX];
> +		int len;
> +
> +		len = snprintf(buf, PATH_MAX, "%s/%s", path, s->progs[i].name);
> +		if (len < 0) {
> +			err = -EINVAL;
> +			goto err_unpin_prog;
> +		} else if (len >= PATH_MAX) {
> +			err = -ENAMETOOLONG;
> +			goto err_unpin_prog;
> +		}
> +
> +		link = *s->progs[i].link;
> +		if (!link) {
> +			err = -EINVAL;
> +			goto err_unpin_prog;
> +		}
> +
> +		err = bpf_link__pin(link, buf);
> +		if (err)
> +			goto err_unpin_prog;
> +	}
> +
> +	return 0;
> +
> +err_unpin_prog:
> +	bpf_object__unpin_skeleton_prog(s);
> +
> +	return libbpf_err(err);
> +}
> +
> +void bpf_object__unpin_skeleton_prog(struct bpf_object_skeleton *s)
> +{
> +	struct bpf_link *link;
> +	int i;
> +
> +	for (i = 0; i < s->prog_cnt; i++) {
> +		link = *s->progs[i].link;
> +		if (!link || !link->pin_path)
> +			continue;
> +
> +		bpf_link__unpin(link);
> +	}
> +}
> +
>   void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
>   {
>   	if (!s)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 3784867811a4..af44b0968cca 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -1427,6 +1427,10 @@ bpf_object__open_skeleton(struct bpf_object_skeleton *s,
>   LIBBPF_API int bpf_object__load_skeleton(struct bpf_object_skeleton *s);
>   LIBBPF_API int bpf_object__attach_skeleton(struct bpf_object_skeleton *s);
>   LIBBPF_API void bpf_object__detach_skeleton(struct bpf_object_skeleton *s);
> +LIBBPF_API int
> +bpf_object__pin_skeleton_prog(struct bpf_object_skeleton *s, const char *path);
> +LIBBPF_API void
> +bpf_object__unpin_skeleton_prog(struct bpf_object_skeleton *s);
>   LIBBPF_API void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s);

Please also add API documentation.

>   struct bpf_var_skeleton {
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 82f6d62176dd..4e3e37b84b3a 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -55,6 +55,8 @@ LIBBPF_0.0.1 {
>   		bpf_object__unload;
>   		bpf_object__unpin_maps;
>   		bpf_object__unpin_programs;
> +		bpf_object__pin_skeleton_prog;
> +		bpf_object__unpin_skeleton_prog;

This would have to go under LIBBPF_0.8.0 if so.

>   		bpf_perf_event_read_simple;
>   		bpf_prog_attach;
>   		bpf_prog_detach;
> 

