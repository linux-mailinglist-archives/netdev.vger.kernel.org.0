Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE22A1F9E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfH2Prf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:47:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:33992 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfH2Prf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 11:47:35 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3Mdy-0000Y7-Ps; Thu, 29 Aug 2019 17:47:26 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3Mdy-0005lU-Fk; Thu, 29 Aug 2019 17:47:26 +0200
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
To:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net
Cc:     davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
References: <20190829051253.1927291-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <536636ad-0baf-31e9-85fe-2591b65068df@iogearbox.net>
Date:   Thu, 29 Aug 2019 17:47:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25556/Thu Aug 29 10:25:39 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 7:12 AM, Alexei Starovoitov wrote:
[...]
>   
> +/*
> + * CAP_BPF allows the following BPF operations:
> + * - Loading all types of BPF programs
> + * - Creating all types of BPF maps except:
> + *    - stackmap that needs CAP_TRACING
> + *    - devmap that needs CAP_NET_ADMIN
> + *    - cpumap that needs CAP_SYS_ADMIN
> + * - Advanced verifier features
> + *   - Indirect variable access
> + *   - Bounded loops
> + *   - BPF to BPF function calls
> + *   - Scalar precision tracking
> + *   - Larger complexity limits
> + *   - Dead code elimination
> + *   - And potentially other features
> + * - Use of pointer-to-integer conversions in BPF programs
> + * - Bypassing of speculation attack hardening measures
> + * - Loading BPF Type Format (BTF) data
> + * - Iterate system wide loaded programs, maps, BTF objects
> + * - Retrieve xlated and JITed code of BPF programs
> + * - Access maps and programs via id
> + * - Use bpf_spin_lock() helper

This is still very wide. Consider following example: app has CAP_BPF +
CAP_NET_ADMIN. Why can't we in this case *only* allow loading networking
related [plus generic] maps and programs? If it doesn't have CAP_TRACING,
what would be a reason to allow loading it? Same vice versa. There are
some misc program types like the infraread stuff, but they could continue
to live under [CAP_BPF +] CAP_SYS_ADMIN as fallback. I think categorizing
a specific list of prog and map types might be more clear than disallowing
some helpers like below (e.g. why choice of bpf_probe_read() but not
bpf_probe_write_user() etc).

> + * CAP_BPF and CAP_TRACING together allow the following:
> + * - bpf_probe_read to read arbitrary kernel memory
> + * - bpf_trace_printk to print data to ftrace ring buffer
> + * - Attach to raw_tracepoint
> + * - Query association between kprobe/tracepoint and bpf program
> + *
> + * CAP_BPF and CAP_NET_ADMIN together allow the following:
> + * - Attach to cgroup-bpf hooks and query
> + * - skb, xdp, flow_dissector test_run command
> + *
> + * CAP_NET_ADMIN allows:
> + * - Attach networking bpf programs to xdp, tc, lwt, flow dissector
> + */
> +#define CAP_BPF			38
> +
> +/*
> + * CAP_TRACING allows:
> + * - Full use of perf_event_open(), similarly to the effect of
> + *   kernel.perf_event_paranoid == -1
> + * - Full use of tracefs
> + * - Creation of [ku][ret]probe
> + * - Accessing arbitrary kernel memory via kprobe + probe_kernel_read
> + * - Attach tracing bpf programs to perf events
> + * - Access to kallsyms
> + */
> +#define CAP_TRACING		39
>   
> -#define CAP_LAST_CAP         CAP_AUDIT_READ
> +#define CAP_LAST_CAP         CAP_TRACING
>   
>   #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>   
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 201f7e588a29..0b364e245163 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -26,9 +26,9 @@
>   	    "audit_control", "setfcap"
>   
>   #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
> -		"wake_alarm", "block_suspend", "audit_read"
> +		"wake_alarm", "block_suspend", "audit_read", "bpf", "tracing"
>   
> -#if CAP_LAST_CAP > CAP_AUDIT_READ
> +#if CAP_LAST_CAP > CAP_TRACING
>   #error New capability defined, please update COMMON_CAP2_PERMS.
>   #endif
>   
> 

