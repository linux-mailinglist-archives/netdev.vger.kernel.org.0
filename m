Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A21B10A367
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfKZRhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:37:00 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:36160 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfKZRhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:37:00 -0500
Received: from [192.168.43.60] (unknown [172.58.46.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 9644C13C359;
        Tue, 26 Nov 2019 09:36:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 9644C13C359
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1574789819;
        bh=+RDqtkWk+ct6oz2ZAEMFKMYr8bDLjdzGYnCoOy3UJP8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ebB15UiK3IoypVs9rktT6HW7z7QmRjMETcy90EEgQXkeRAgJxJpWZbNaNpXmb4xkE
         Wbl3QYYfEfF5TrWVd5pEjXZpBRgu8HulS9l7MePZkor84sVQF98f4Q2iLXrpjwnrnc
         BqnCkYOnJxorFxmOJAZjTtxK8x6rEXiv6ku4rTEw=
Message-ID: <5DDD62B9.3070909@candelatech.com>
Date:   Tue, 26 Nov 2019 09:36:57 -0800
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com> <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com> <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com> <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com> <ffbeb74f-09d5-e854-190e-5362cc703a10@candelatech.com> <fb74534d-f5e8-7b9b-b8c0-b6d6e718a275@gmail.com> <3daeee00-317a-1f82-648e-80ec14cfed22@candelatech.com> <b64cb1b5-f9be-27ab-76e8-4fe84b947114@gmail.com>
In-Reply-To: <b64cb1b5-f9be-27ab-76e8-4fe84b947114@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/2019 12:53 PM, David Ahern wrote:
> On 11/25/19 10:35 AM, Ben Greear wrote:
>>>> And surely 'ip' could output a better error than just 'permission
>>>> denied' for
>>>> this error case?  Or even something that would show up in dmesg to give
>>>> a clue?
>>>
>>> That error comes from the bpf syscall:
>>>
>>> bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=6,
>>> insns=0x7ffc8e5d1e00, license="GPL", log_level=1, log_size=262144,
>>> log_buf="", kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
>>> prog_name="", prog_ifindex=0,
>>> expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0,
>>> func_info_rec_size=0, func_info=NULL, func_info_cnt=0,
>>> line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 112) = -1 EPERM
>>> (Operation not permitted)
>>
>> So, we can change iproute/lib/bpf.c to print a suggestion to increase
>> locked memory
>> if this returns EPERM?
>>
>
> looks like SYS_ADMIN and locked memory are the -EPERM failures.
>
> I do not see any API that returns user->locked_vm, only per-task
> locked_vm. Knowing that number would help a lot in understanding proper
> system settings.
>
> Running 'perf record' while trying to do 'ip vrf exec' is an easy way to
> hit the locked memory exceeded error. We could add a hint to iproute2.
> Something like:
>
> diff --git a/ip/ipvrf.c b/ip/ipvrf.c
> index b9a43675cbd6..15637924f31a 100644
> --- a/ip/ipvrf.c
> +++ b/ip/ipvrf.c
> @@ -281,9 +281,16 @@ static int vrf_configure_cgroup(const char *path,
> int ifindex)
>                  fprintf(stderr, "Failed to load BPF prog: '%s'\n",
>                          strerror(errno));
>
> -               if (errno != EPERM) {
> +               if (errno == EPERM) {
> +                       if (geteuid() != 0)
> +                               fprintf(stderr,
> +                                       "Hint: Must run as root to set
> VRF.\n");
> +                       else
> +                               fprintf(stderr,
> +                                       "Hint: Most likely locked memory
> threshold exceeded. Increase 'ulimit -l'\n");

I think I would suggest 'ulimit -l 1024'.  Advanced users can try different
values if they care or have super tight memory constraints, but most users could
probably get benefit from the suggestion.

Thanks,
Ben

> +               } else {
>                          fprintf(stderr,
> -                               "Kernel compiled with CGROUP_BPF
> enabled?\n");
> +                               "Hint: Kernel compiled with CGROUP_BPF
> enabled?\n");
>                  }
>                  goto out;
>          }
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

