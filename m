Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731CB1D1145
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 13:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgEML0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 07:26:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:39762 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEML0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 07:26:14 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYpWc-0006Ul-TW; Wed, 13 May 2020 13:26:10 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYpWc-000CrE-Lm; Wed, 13 May 2020 13:26:10 +0200
Subject: Re: [PATCH bpf-next] bpf, bpftool: Allow probing for CONFIG_HZ from
 kernel config
To:     Quentin Monnet <quentin@isovalent.com>,
        alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>
References: <20200513075849.20868-1-daniel@iogearbox.net>
 <4cc2a445-5d38-8b9c-71b1-bb5c69ac2553@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <531f4e9f-8fd5-75a1-675a-488c15c50906@iogearbox.net>
Date:   Wed, 13 May 2020 13:26:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4cc2a445-5d38-8b9c-71b1-bb5c69ac2553@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25810/Tue May 12 14:14:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 12:42 PM, Quentin Monnet wrote:
> 2020-05-13 09:58 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
>> In Cilium we've recently switched to make use of bpf_jiffies64() for
>> parts of our tc and XDP datapath since bpf_ktime_get_ns() is more
>> expensive and high-precision is not needed for our timeouts we have
>> anyway. Our agent has a probe manager which picks up the json of
>> bpftool's feature probe and we also use the macro output in our C
>> programs e.g. to have workarounds when helpers are not available on
>> older kernels.
>>
>> Extend the kernel config info dump to also include the kernel's
>> CONFIG_HZ, and rework the probe_kernel_image_config() for allowing a
>> macro dump such that CONFIG_HZ can be propagated to BPF C code as a
>> simple define if available via config. Latter allows to have _compile-
>> time_ resolution of jiffies <-> sec conversion in our code since all
>> are propagated as known constants.
>>
>> Given we cannot generally assume availability of kconfig everywhere,
>> we also have a kernel hz probe [0] as a fallback. Potentially, bpftool
>> could have an integrated probe fallback as well, although to derive it,
>> we might need to place it under 'bpftool feature probe full' or similar
>> given it would slow down the probing process overall. Yet 'full' doesn't
>> fit either for us since we don't want to pollute the kernel log with
>> warning messages from bpf_probe_write_user() and bpf_trace_printk() on
>> agent startup; I've left it out for the time being.
>>
>>    [0] https://github.com/cilium/cilium/blob/master/bpf/cilium-probe-kernel-hz.c
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Martin KaFai Lau <kafai@fb.com>
> 
> Looks good to me, thanks!
> 
> I think at the time the "bpftool feature probe" was added we didn't
> settle on a particular format for dumping the CONFIG_* as part as the C
> macro output, but other than that I can see no specific reason why not
> to have them, so we could even list them all and avoid the macro_dump
> bool. But I'm fine either way, other CONFIG_* can still be added to C
> macro output at a later time if someone needs them anyway.

Right, I initially thought about listing them all, but then my thinking
was that we should really only dump those CONFIG_* as defines that actually
have a real-world use case in a BPF prog somewhere. This also helps to
better understand what is useful and why and avoids unrelated noise e.g.
in the bpf_features.h dump we have in Cilium as part of the agent bootstrap.

> Regarding a fallback for the jiffies, not sure what would be best. I
> agree with you for the "full" keyword, so we would need another word I
> suppose. But adding new keyword for fallbacks for probing features not
> directly related to BPF might be going a bit beyond bpftool's scope? I
> don't know. Anyway, for the current patch:

Agree, had the same thought.

> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks!
Daniel
