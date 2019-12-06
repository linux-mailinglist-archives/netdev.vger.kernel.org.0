Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F23114D4A
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 09:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfLFILy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 03:11:54 -0500
Received: from mail.dlink.ru ([178.170.168.18]:47228 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbfLFILy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 03:11:54 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id D4A7B1B20153; Fri,  6 Dec 2019 11:11:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D4A7B1B20153
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1575619910; bh=za+GdP4j4RE1pd9atrwIHfrHFE+ujrS1ZdTfSPyF48Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=nrDzP7yd6HXSc1LtC8Gjwu8u+3kzSGnBldhMKb0ZZBXrSgaTE+SLavTEnnumW08b0
         HJ+PIXJJ7xvJsunyP4ArMuH2xlHoUKlLkbv9HpFrWofYFK//0PsHzgDu/1esHI4rqP
         YB9b+PTcGB5kVqh+OhS1RLgR/zaHOeDwGLGOTwe0=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 6B7ED1B20153;
        Fri,  6 Dec 2019 11:11:41 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 6B7ED1B20153
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id D1A151B22664;
        Fri,  6 Dec 2019 11:11:40 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri,  6 Dec 2019 11:11:40 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 06 Dec 2019 11:11:40 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Burton <paulburton@kernel.org>
Cc:     Paul Burton <paul.burton@mips.com>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: MIPS eBPF JIT support on pre-32R2
In-Reply-To: <647fa62c7111a27a2cc217cf06cbe355@dlink.ru>
References: <09d713a59665d745e21d021deeaebe0a@dlink.ru>
 <20191205184450.lbrkenmursz4zpdm@lantea.localdomain>
 <647fa62c7111a27a2cc217cf06cbe355@dlink.ru>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <cd821557a6540d4139a3b5be81b42adf@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin писал 06.12.2019 10:20:
> Paul Burton wrote 05.12.2019 21:44:
>> Hi Alexander,
> 
> Hi Paul!
> 
>> On Thu, Dec 05, 2019 at 03:45:27PM +0300, Alexander Lobakin wrote:
>>> Hey all,
>>> 
>>> I'm writing about lines arch/mips/net/ebpf_jit.c:1806-1807:
>>> 
>>> 	if (!prog->jit_requested || MIPS_ISA_REV < 2)
>>> 		return prog;
>>> 
>>> Do pre-32R2 architectures (32R1, maybe even R3000-like) actually 
>>> support
>>> this eBPF JIT code?
>> 
>> No, they don't; the eBPF JIT makes unconditional use of at least the
>> (d)ins & (d)ext instructions which were added in MIPSr2, so it would
>> result in reserved instruction exceptions & panics if enabled on
>> pre-MIPSr2 CPUs.
>> 
>>> If they do, then the condition 'MIPS_ISA_REV < 2'
>>> should be removed as it is always true for them and tells CC to 
>>> remove
>>> JIT completely.
>>> 
>>> If they don't support instructions from this JIT, then the line
>>> arch/mips/Kconfig:50:
>>> 
>>> 	select HAVE_EBPF_JIT if (!CPU_MICROMIPS)
>>> 
>>> should be changed to something like:
>>> 
>>> 	select HAVE_EBPF_JIT if !CPU_MICROMIPS && TARGET_ISA_REV >= 2
>>> 
>>> (and then the mentioned 'if' condition would become redundant)
>> 
>> Good spot; I agree entirely, this dependency should be reflected in
>> Kconfig.
>> 
>>> At the moment it is possible to build a kernel without both JIT and
>>> interpreter, but with CONFIG_BPF_SYSCALL=y (what should not be 
>>> allowed
>>> I suppose?) within the following configuration:
>>> 
>>> - select any pre-32R2 CPU (e.g. CONFIG_CPU_MIPS32_R1);
>>> - enable CONFIG_BPF_JIT (CONFIG_MIPS_EBPF_JIT will be autoselected);
>>> - enable CONFIG_BPF_JIT_ALWAYS_ON (this removes BPF interpreter from
>>>   the system).
>>> 
>>> I may prepare a proper patch by myself if needed (after 
>>> clarification).
>> 
>> That would be great, thanks!
> 
> Great, I'll send it in about ~2-3 hours.

Here we are: [1]
Yep, this will conflict with your patch restoring cBPF for MIPS32.
If you have any questions about my patch or I should change anything in
it, please let me know.
Thanks!

>> One thing to note is that I hope we'll restore the cBPF JIT with this
>> patch:
>> 
>> https://lore.kernel.org/linux-mips/20191205182318.2761605-1-paulburton@kernel.org/T/#u
>> 
>> The cBPF JIT looks like it should work on older pre-MIPSr2 CPUs, so 
>> the
>> only way this is relevant is that your patch might have a minor
>> conflict. But I thought I'd mention it anyway :)
> 
> Yes, I thought about this too. If pre-32R2 CPUs don't support our eBPF
> JIT, we'd better restore cBPF for them, so they could speed-up at least
> "classic" instructions. Glad you've decided to do that.
> 
>> Thanks,
>>     Paul
> 
> Regards,
> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

[1] 
https://lore.kernel.org/linux-mips/20191206080741.12306-1-alobakin@dlink.ru/

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
