Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C3B277558
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgIXPbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:31:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:59976 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgIXPbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:31:05 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLTD5-0007Ee-36; Thu, 24 Sep 2020 17:31:03 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLTD4-0002lR-RY; Thu, 24 Sep 2020 17:31:02 +0200
Subject: Re: [PATCH bpf-next v3 1/2] bpf: Add bpf_ktime_get_real_ns
To:     bimmy.pujari@intel.com, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        kafai@fb.com, maze@google.com, ashkan.nikravesh@intel.com,
        dsahern@gmail.com, andrii.nakryiko@gmail.com
References: <20200924022557.16561-1-bimmy.pujari@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d232b77c-da79-da1c-e564-e2a5cb64acb6@iogearbox.net>
Date:   Thu, 24 Sep 2020 17:31:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200924022557.16561-1-bimmy.pujari@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 4:25 AM, bimmy.pujari@intel.com wrote:
> From: Bimmy Pujari <bimmy.pujari@intel.com>
> 
> The existing bpf helper functions to get timestamp return the time
> elapsed since system boot. This timestamp is not particularly useful
> where epoch timestamp is required or more than one server is involved
> and time sync is required. Instead, you want to use CLOCK_REALTIME,
> which provides epoch timestamp.
> Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.

nit:        ^ typo

> 
> Signed-off-by: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
> ---
>   drivers/media/rc/bpf-lirc.c    |  2 ++
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/bpf.h       |  8 ++++++++
>   kernel/bpf/core.c              |  1 +
>   kernel/bpf/helpers.c           | 13 +++++++++++++
>   kernel/trace/bpf_trace.c       |  2 ++
>   tools/include/uapi/linux/bpf.h |  8 ++++++++
>   7 files changed, 35 insertions(+)
[...]
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fc5c901c7542..18c4fdce65c8 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1757,6 +1757,7 @@ extern const struct bpf_func_proto bpf_get_numa_node_id_proto;
>   extern const struct bpf_func_proto bpf_tail_call_proto;
>   extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
>   extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
> +extern const struct bpf_func_proto bpf_ktime_get_real_ns_proto;
>   extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
>   extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
>   extern const struct bpf_func_proto bpf_get_current_comm_proto;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a22812561064..198e69a6508d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3586,6 +3586,13 @@ union bpf_attr {
>    * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
>    * 	Return
>    * 		0 on success, or a negative error in case of failure.
> + *
> + * u64 bpf_ktime_get_real_ns(void)
> + *	Description
> + *		Return the real time in nanoseconds.
> + *		See: **clock_gettime**\ (**CLOCK_REALTIME**)

So from prior discussion with Andrii and David my impression was that the plan
was to at least properly document the clock and its limitations at minimum in
order to provide some basic guidance for users? Seems this was not yet addressed
here.

> + *	Return
> + *		Current *ktime*.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3737,6 +3744,7 @@ union bpf_attr {
>   	FN(inode_storage_delete),	\
>   	FN(d_path),			\
>   	FN(copy_from_user),		\
> +	FN(ktime_get_real_ns),		\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index c4811b139caa..0dbbda9b743b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2208,6 +2208,7 @@ const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
>   const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
>   const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
>   const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
> +const struct bpf_func_proto bpf_ktime_get_real_ns_proto __weak;
>   
>   const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
>   const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5cc7425ee476..300db9269996 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -166,6 +166,17 @@ const struct bpf_func_proto bpf_ktime_get_boot_ns_proto = {
>   	.gpl_only	= false,
>   	.ret_type	= RET_INTEGER,
>   };
> +BPF_CALL_0(bpf_ktime_get_real_ns)
> +{

nit: newline before BPF_CALL_0(...)

> +	/* NMI safe access to clock realtime */
> +	return ktime_get_real_fast_ns();
> +}
> +
> +const struct bpf_func_proto bpf_ktime_get_real_ns_proto = {
> +	.func		= bpf_ktime_get_real_ns,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +};
>   
>   BPF_CALL_0(bpf_get_current_pid_tgid)
>   {
[...]
