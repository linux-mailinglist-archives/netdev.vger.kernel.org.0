Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CAC1CFF03
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 22:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbgELUJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 16:09:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:54856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgELUJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 16:09:53 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYbDq-0007jJ-EM; Tue, 12 May 2020 22:09:50 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYbDq-000Pjy-2D; Tue, 12 May 2020 22:09:50 +0200
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <fcc61b50-16f7-4fc9-5cd4-7def57f37c35@iogearbox.net>
 <20200512182944.wzfs7nzgppqn23l6@ast-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <294922f0-2dab-8392-492a-ce0e04c03cee@iogearbox.net>
Date:   Tue, 12 May 2020 22:09:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200512182944.wzfs7nzgppqn23l6@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25810/Tue May 12 14:14:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/20 8:29 PM, Alexei Starovoitov wrote:
> On Tue, May 12, 2020 at 05:05:12PM +0200, Daniel Borkmann wrote:
>>> -	env->allow_ptr_leaks = is_priv;
>>> +	env->allow_ptr_leaks = perfmon_capable();
>>> +	env->bpf_capable = bpf_capable();
>>
>> Probably more of a detail, but it feels weird to tie perfmon_capable() into the BPF
>> core and use it in various places there. I would rather make this a proper bpf_*
>> prefixed helper and add a more descriptive name (what does it have to do with perf
>> or monitoring directly?). For example, all the main functionality could be under
>> `bpf_base_capable()` and everything with potential to leak pointers or mem to user
>> space as `bpf_leak_capable()`. Then inside include/linux/capability.h this can still
>> resolve under the hood to something like:
>>
>> static inline bool bpf_base_capable(void)
>> {
>> 	return capable(CAP_BPF) || capable(CAP_SYS_ADMIN);
>> }
> 
> I don't like the 'base' in the name, since 'base' implies common subset,
> but it's not the case. Also 'base' implies that something else is additive,
> but it's not the case either. The real base is unpriv. cap_bpf adds to it.
> So bpf_capable() in capability.h is the most appropriate.
> It also matches perfmon_capable() and other *_capable()

That's okay with me, naming is usually hardest. :)

>> static inline bool bpf_leak_capable(void)
>> {
>> 	return perfmon_capable();
>> }
> 
> This is ok, but not in capability.h. I can put it into bpf_verifier.h

Makes sense.
