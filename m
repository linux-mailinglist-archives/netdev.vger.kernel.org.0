Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC3A50BD2B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449729AbiDVQff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389617AbiDVQfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:35:34 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DE95F24A;
        Fri, 22 Apr 2022 09:32:41 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhwCv-0001kP-Ev; Fri, 22 Apr 2022 18:32:33 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhwCv-000C8l-5l; Fri, 22 Apr 2022 18:32:33 +0200
Subject: Re: [PATCH bpf-next] libbpf: also check /sys/kernel/tracing for
 tracefs files
To:     Connor O'Brien <connoro@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220421201125.13907-1-connoro@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <407ab3dd-cee1-a043-585b-1b2886c6f7fd@iogearbox.net>
Date:   Fri, 22 Apr 2022 18:32:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220421201125.13907-1-connoro@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26520/Fri Apr 22 10:30:17 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 10:11 PM, Connor O'Brien wrote:
> libbpf looks for tracefs files only under debugfs, but tracefs may be
> mounted even if debugfs is not. When /sys/kernel/debug/tracing is
> absent, try looking under /sys/kernel/tracing instead.
> 
> Signed-off-by: Connor O'Brien <connoro@google.com>
> ---
>   tools/lib/bpf/libbpf.c | 26 +++++++++++++++++++-------
>   1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 68cc134d070d..6ef587329eb2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10140,10 +10140,16 @@ static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
>   		 __sync_fetch_and_add(&index, 1));
>   }
>   
> +static bool debugfs_available(void)
> +{
> +	return !access("/sys/kernel/debug/tracing", F_OK);

Should this be a one-time probe, so on subsequent debugfs_available() calls
we return the initially cached result?

> +}
> +
>   static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
>   				   const char *kfunc_name, size_t offset)
>   {
> -	const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> +	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/kprobe_events" :
> +		"/sys/kernel/tracing/kprobe_events";
>   
>   	return append_to_file(file, "%c:%s/%s %s+0x%zx",
>   			      retprobe ? 'r' : 'p',
> @@ -10153,7 +10159,8 @@ static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
>   
>   static int remove_kprobe_event_legacy(const char *probe_name, bool retprobe)
>   {
> -	const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> +	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/kprobe_events" :
> +		"/sys/kernel/tracing/kprobe_events";
>   
>   	return append_to_file(file, "-:%s/%s", retprobe ? "kretprobes" : "kprobes", probe_name);
>   }
> @@ -10163,7 +10170,8 @@ static int determine_kprobe_perf_type_legacy(const char *probe_name, bool retpro
>   	char file[256];
>   
>   	snprintf(file, sizeof(file),
> -		 "/sys/kernel/debug/tracing/events/%s/%s/id",
> +		 debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
> +		 "/sys/kernel/tracing/events/%s/%s/id",
>   		 retprobe ? "kretprobes" : "kprobes", probe_name);
>   
>   	return parse_uint_from_file(file, "%d\n");
> @@ -10493,7 +10501,8 @@ static void gen_uprobe_legacy_event_name(char *buf, size_t buf_sz,
>   static inline int add_uprobe_event_legacy(const char *probe_name, bool retprobe,
>   					  const char *binary_path, size_t offset)
>   {
> -	const char *file = "/sys/kernel/debug/tracing/uprobe_events";
> +	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/uprobe_events" :
> +		"/sys/kernel/tracing/uprobe_events";
>   
>   	return append_to_file(file, "%c:%s/%s %s:0x%zx",
>   			      retprobe ? 'r' : 'p',
> @@ -10503,7 +10512,8 @@ static inline int add_uprobe_event_legacy(const char *probe_name, bool retprobe,
>   
>   static inline int remove_uprobe_event_legacy(const char *probe_name, bool retprobe)
>   {
> -	const char *file = "/sys/kernel/debug/tracing/uprobe_events";
> +	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/uprobe_events" :
> +		"/sys/kernel/tracing/uprobe_events";
>   
>   	return append_to_file(file, "-:%s/%s", retprobe ? "uretprobes" : "uprobes", probe_name);
>   }
> @@ -10513,7 +10523,8 @@ static int determine_uprobe_perf_type_legacy(const char *probe_name, bool retpro
>   	char file[512];
>   
>   	snprintf(file, sizeof(file),
> -		 "/sys/kernel/debug/tracing/events/%s/%s/id",
> +		 debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
> +		 "/sys/kernel/tracing/events/%s/%s/id",
>   		 retprobe ? "uretprobes" : "uprobes", probe_name);
>   
>   	return parse_uint_from_file(file, "%d\n");
> @@ -11071,7 +11082,8 @@ static int determine_tracepoint_id(const char *tp_category,
>   	int ret;
>   
>   	ret = snprintf(file, sizeof(file),
> -		       "/sys/kernel/debug/tracing/events/%s/%s/id",
> +		       debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
> +		       "/sys/kernel/tracing/events/%s/%s/id",
>   		       tp_category, tp_name);
>   	if (ret < 0)
>   		return -errno;
> 

