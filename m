Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130AE10E4EA
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 04:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfLBDpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 22:45:16 -0500
Received: from terminus.zytor.com ([198.137.202.136]:52761 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfLBDpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 22:45:16 -0500
Received: from [IPv6:2601:646:8600:3281:ad1f:fd74:80df:7eb5] ([IPv6:2601:646:8600:3281:ad1f:fd74:80df:7eb5])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id xB23ild5941514
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Sun, 1 Dec 2019 19:44:49 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com xB23ild5941514
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019111901; t=1575258290;
        bh=r9ToDsFCnt2xkGs1bQs22MxbKA0z6g+7BcFNxXPoCXY=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=QRulXa+W4B6nxkSpwbUBJdz83aLLQtyefosnqfjtvVHQOiTR+3arV4rYQNmbkRt7m
         wYYCTUGiVvVvoIUTqxmusfJJm98uE3RYL3PKx28o6iZkG8Nww9bJpEU2JHeycTgmF/
         bwZsLIG9eMoehdNJvaxvkZie8g2maYv8QcN1xNdHeKwCBJkTwt/XsEJbdRSy/ty6NU
         RR9XPzdKuQVEPjf4Y2gZ7+3KDNAfClDsmMaxkHjCSjotStZzMaOz+0DAIyZXtJZSMR
         NicNlCBDGwKpAVkH57u+en51uGnVwiVaLrrV5gPQdYHnVNAsTthYeqMThyOYfP4hG0
         iJyMH1uf7g70Q==
Date:   Sun, 01 Dec 2019 19:44:39 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
References: <20191129222911.3710-1-daniel@iogearbox.net> <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com> <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net> <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when prog is jited
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        alexei.starovoitov@gmail.com
CC:     peterz@infradead.org, netdev@vger.kernel.org, bpf@vger.kernel.org
From:   hpa@zytor.com
Message-ID: <E02AAB2B-987E-497C-B241-6E86472CC529@zytor.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On December 1, 2019 6:49:32 PM PST, Eric Dumazet <eric=2Edumazet@gmail=2Eco=
m> wrote:
>
>
>On 11/30/19 1:52 AM, Daniel Borkmann wrote:
>> On 11/30/19 2:37 AM, Eric Dumazet wrote:
>>> On 11/29/19 2:29 PM, Daniel Borkmann wrote:
>>>> For the case where the interpreter is compiled out or when the prog
>is jited
>>>> it is completely unnecessary to set the BPF insn pages as
>read-only=2E In fact,
>>>> on frequent churn of BPF programs, it could lead to performance
>degradation of
>>>> the system over time since it would break the direct map down to 4k
>pages when
>>>> calling set_memory_ro() for the insn buffer on x86-64 / arm64 and
>there is no
>>>> reverse operation=2E Thus, avoid breaking up large pages for data
>maps, and only
>>>> limit this to the module range used by the JIT where it is
>necessary to set
>>>> the image read-only and executable=2E
>>>
>>> Interesting=2E=2E=2E But why the non JIT case would need RO protection=
 ?
>>=20
>> It was done for interpreter around 5 years ago mainly due to concerns
>from security
>> folks that the BPF insn image could get corrupted (through some other
>bug in the
>> kernel) in post-verifier stage by an attacker and then there's
>nothing really that
>> would provide any sort of protection guarantees; pretty much the same
>reasons why
>> e=2Eg=2E modules are set to read-only in the kernel=2E
>>=20
>>> Do you have any performance measures to share ?
>>=20
>> No numbers, and I'm also not aware of any reports from users, but it
>was recently
>> brought to our attention from mm folks during discussion of a
>different set:
>>=20
>>
>https://lore=2Ekernel=2Eorg/lkml/1572171452-7958-2-git-send-email-rppt@ke=
rnel=2Eorg/T/
>>=20
>
>Thanks for the link !
>
>Having RO protection as a debug feature would be useful=2E
>
>I believe we have CONFIG_STRICT_MODULE_RWX (and
>CONFIG_STRICT_KERNEL_RWX) for that already=2E
>
>Or are we saying we also want to get rid of them ?

The notion is that for security there should never been a page which is bo=
th writable and executable at the same time=2E This makes it harder to inje=
ct code=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
