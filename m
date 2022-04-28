Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10166513819
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349048AbiD1PV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349146AbiD1PVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:21:13 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC7BB36AA;
        Thu, 28 Apr 2022 08:17:51 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nk5tl-0007Y6-IA; Thu, 28 Apr 2022 17:17:41 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nk5tl-000VU1-8h; Thu, 28 Apr 2022 17:17:41 +0200
Subject: Re: [PATCH RESEND bpf-next] bpftool: Use sysfs vmlinux when dumping
 BTF by ID
To:     Larysa Zaremba <larysa.zaremba@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220428111442.111805-1-larysa.zaremba@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b464eae7-2f4d-bb5e-f229-6c95dab774fb@iogearbox.net>
Date:   Thu, 28 Apr 2022 17:17:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220428111442.111805-1-larysa.zaremba@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26526/Thu Apr 28 10:21:25 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 1:14 PM, Larysa Zaremba wrote:
> Currently, dumping almost all BTFs specified by id requires
> using the -B option to pass the base BTF. For most cases
> the vmlinux BTF sysfs path should work.
> 
> This patch simplifies dumping by ID usage by attempting to
> use vmlinux BTF from sysfs, if the first try of loading BTF by ID
> fails with certain conditions.
> 
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>   tools/bpf/bpftool/btf.c | 35 ++++++++++++++++++++++++++---------
>   1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index a2c665beda87..557f65e2de5c 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -459,6 +459,22 @@ static int dump_btf_c(const struct btf *btf,
>   	return err;
>   }
>   
> +static const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
> +
> +static struct btf *get_vmlinux_btf_from_sysfs(void)
> +{
> +	struct btf *base;
> +
> +	base = btf__parse(sysfs_vmlinux, NULL);
> +	if (libbpf_get_error(base)) {
> +		p_err("failed to parse vmlinux BTF at '%s': %ld\n",
> +		      sysfs_vmlinux, libbpf_get_error(base));
> +		base = NULL;
> +	}

Could we reuse libbpf's btf__load_vmlinux_btf() which probes well-known
locations?

> +	return base;
> +}
> +
>   static int do_dump(int argc, char **argv)
>   {
>   	struct btf *btf = NULL, *base = NULL;
> @@ -536,18 +552,11 @@ static int do_dump(int argc, char **argv)
>   		NEXT_ARG();
>   	} else if (is_prefix(src, "file")) {
>   		const char sysfs_prefix[] = "/sys/kernel/btf/";
> -		const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
>   
>   		if (!base_btf &&
>   		    strncmp(*argv, sysfs_prefix, sizeof(sysfs_prefix) - 1) == 0 &&
> -		    strcmp(*argv, sysfs_vmlinux) != 0) {
> -			base = btf__parse(sysfs_vmlinux, NULL);
> -			if (libbpf_get_error(base)) {
> -				p_err("failed to parse vmlinux BTF at '%s': %ld\n",
> -				      sysfs_vmlinux, libbpf_get_error(base));
> -				base = NULL;
> -			}
> -		}
> +		    strcmp(*argv, sysfs_vmlinux))
> +			base = get_vmlinux_btf_from_sysfs();
>   
>   		btf = btf__parse_split(*argv, base ?: base_btf);
>   		err = libbpf_get_error(btf);
> @@ -593,6 +602,14 @@ static int do_dump(int argc, char **argv)
>   	if (!btf) {
>   		btf = btf__load_from_kernel_by_id_split(btf_id, base_btf);
>   		err = libbpf_get_error(btf);
> +		if (err == -EINVAL && !base_btf) {
> +			btf__free(base);
> +			base = get_vmlinux_btf_from_sysfs();
> +			p_info("Warning: valid base BTF was not specified with -B option, falling back on standard base BTF (sysfs vmlinux)");
> +			btf = btf__load_from_kernel_by_id_split(btf_id, base);
> +			err = libbpf_get_error(btf);
> +		}
> +
>   		if (err) {
>   			p_err("get btf by id (%u): %s", btf_id, strerror(err));
>   			goto done;
> 

