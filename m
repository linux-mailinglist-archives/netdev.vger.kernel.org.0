Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9774250E29D
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbiDYOGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiDYOGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:06:51 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F97DB6D23;
        Mon, 25 Apr 2022 07:03:47 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizJU-0007MQ-QB; Mon, 25 Apr 2022 16:03:40 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizJU-000Dgb-Gi; Mon, 25 Apr 2022 16:03:40 +0200
Subject: Re: [PATCH bpf-next 4/4] bpftool: Generate helpers for pinning prog
 through bpf object skeleton
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220423140058.54414-1-laoar.shao@gmail.com>
 <20220423140058.54414-5-laoar.shao@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <33e5314f-8546-3945-c73b-25ee13d1b368@iogearbox.net>
Date:   Mon, 25 Apr 2022 16:03:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220423140058.54414-5-laoar.shao@gmail.com>
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
> After this change, with command 'bpftool gen skeleton XXX.bpf.o', the
> helpers for pinning BPF prog will be generated in BPF object skeleton. It
> could simplify userspace code which wants to pin bpf progs in bpffs.
> 
> The new helpers are named with __{pin, unpin}_prog, because it only pins
> bpf progs. If the user also wants to pin bpf maps in bpffs, he can use
> LIBBPF_PIN_BY_NAME.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>   tools/bpf/bpftool/gen.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 8f76d8d9996c..1d06ebde723b 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1087,6 +1087,8 @@ static int do_skeleton(int argc, char **argv)
>   			static inline int load(struct %1$s *skel);	    \n\
>   			static inline int attach(struct %1$s *skel);	    \n\
>   			static inline void detach(struct %1$s *skel);	    \n\
> +			static inline int pin_prog(struct %1$s *skel, const char *path);\n\
> +			static inline void unpin_prog(struct %1$s *skel);   \n\
>   			static inline void destroy(struct %1$s *skel);	    \n\
>   			static inline const void *elf_bytes(size_t *sz);    \n\
>   		#endif /* __cplusplus */				    \n\
> @@ -1172,6 +1174,18 @@ static int do_skeleton(int argc, char **argv)
>   		%1$s__detach(struct %1$s *obj)				    \n\
>   		{							    \n\
>   			bpf_object__detach_skeleton(obj->skeleton);	    \n\
> +		}							    \n\
> +									    \n\
> +		static inline int					    \n\
> +		%1$s__pin_prog(struct %1$s *obj, const char *path)	    \n\
> +		{							    \n\
> +			return bpf_object__pin_skeleton_prog(obj->skeleton, path);\n\
> +		}							    \n\
> +									    \n\
> +		static inline void					    \n\
> +		%1$s__unpin_prog(struct %1$s *obj)			    \n\
> +		{							    \n\
> +			bpf_object__unpin_skeleton_prog(obj->skeleton);	    \n\
>   		}							    \n\

(This should also have BPF selftest code as in-tree user.)

>   		",
>   		obj_name
> @@ -1237,6 +1251,8 @@ static int do_skeleton(int argc, char **argv)
>   		int %1$s::load(struct %1$s *skel) { return %1$s__load(skel); }		\n\
>   		int %1$s::attach(struct %1$s *skel) { return %1$s__attach(skel); }	\n\
>   		void %1$s::detach(struct %1$s *skel) { %1$s__detach(skel); }		\n\
> +		int %1$s::pin_prog(struct %1$s *skel, const char *path) { return %1$s__pin_prog(skel, path); }\n\
> +		void %1$s::unpin_prog(struct %1$s *skel) { %1$s__unpin_prog(skel); }	\n\
>   		void %1$s::destroy(struct %1$s *skel) { %1$s__destroy(skel); }		\n\
>   		const void *%1$s::elf_bytes(size_t *sz) { return %1$s__elf_bytes(sz); } \n\
>   		#endif /* __cplusplus */				    \n\
> 

