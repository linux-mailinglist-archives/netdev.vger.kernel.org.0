Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC5131BE3
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgAFWza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:55:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:45756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFWz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:55:29 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iobHT-0004Xi-8H; Mon, 06 Jan 2020 23:55:27 +0100
Received: from [178.197.249.51] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iobHS-000TMk-Se; Mon, 06 Jan 2020 23:55:26 +0100
Subject: Re: [PATCH bpf-next 2/2] bpftool: Add misc secion and probe for large
 INSN limit
To:     Michal Rostecki <mrostecki@suse.de>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191227110605.1757-1-mrostecki@suse.de>
 <20191227110605.1757-3-mrostecki@suse.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <afbb24f9-a31a-7a19-c09d-114c7221a413@iogearbox.net>
Date:   Mon, 6 Jan 2020 23:55:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191227110605.1757-3-mrostecki@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25686/Mon Jan  6 10:55:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/19 12:06 PM, Michal Rostecki wrote:
> Introduce a new probe section (misc) for probes not related to concrete
> map types, program types, functions or kernel configuration. Introduce a
> probe for large INSN limit as the first one in that section.
> 
> Signed-off-by: Michal Rostecki <mrostecki@suse.de>
> ---
>   tools/bpf/bpftool/feature.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 03bdc5b3ac49..4a7359b9a427 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -572,6 +572,18 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
>   		printf("\n");
>   }
>   
> +static void
> +probe_large_insn_limit(const char *define_prefix, __u32 ifindex)
> +{
> +	bool res;
> +
> +	res = bpf_probe_large_insn_limit(ifindex);
> +	print_bool_feature("have_large_insn_limit",
> +			   "Large complexity limit and maximum program size (1M)",
> +			   "HAVE_LARGE_INSN_LIMIT",

HAVE_LARGE_INSN_LIMIT is good, but official description should not explicitly
state the 1M limit since this could be subject to change. Perhaps just stating
"Large complexity and program size limit" is better suited here.

> +			   res, define_prefix);
> +}
> +
>   static int do_probe(int argc, char **argv)
>   {
>   	enum probe_component target = COMPONENT_UNSPEC;
> @@ -724,6 +736,12 @@ static int do_probe(int argc, char **argv)
>   		probe_helpers_for_progtype(i, supported_types[i],
>   					   define_prefix, ifindex);
>   
> +	print_end_then_start_section("misc",
> +				     "Scanning miscellaneous eBPF features...",
> +				     "/*** eBPF misc features ***/",
> +				     define_prefix);
> +	probe_large_insn_limit(define_prefix, ifindex);
> +
>   exit_close_json:
>   	if (json_output) {
>   		/* End current "section" of probes */
> 

