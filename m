Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA2710DD53
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 10:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfK3JwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 04:52:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:42476 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfK3JwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 04:52:21 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iazQH-0002Qv-7E; Sat, 30 Nov 2019 10:52:17 +0100
Received: from [178.197.249.29] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iazQG-0009iv-TR; Sat, 30 Nov 2019 10:52:16 +0100
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when
 prog is jited
To:     Eric Dumazet <eric.dumazet@gmail.com>, alexei.starovoitov@gmail.com
Cc:     peterz@infradead.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20191129222911.3710-1-daniel@iogearbox.net>
 <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
Date:   Sat, 30 Nov 2019 10:52:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25648/Fri Nov 29 10:44:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/19 2:37 AM, Eric Dumazet wrote:
> On 11/29/19 2:29 PM, Daniel Borkmann wrote:
>> For the case where the interpreter is compiled out or when the prog is jited
>> it is completely unnecessary to set the BPF insn pages as read-only. In fact,
>> on frequent churn of BPF programs, it could lead to performance degradation of
>> the system over time since it would break the direct map down to 4k pages when
>> calling set_memory_ro() for the insn buffer on x86-64 / arm64 and there is no
>> reverse operation. Thus, avoid breaking up large pages for data maps, and only
>> limit this to the module range used by the JIT where it is necessary to set
>> the image read-only and executable.
> 
> Interesting... But why the non JIT case would need RO protection ?

It was done for interpreter around 5 years ago mainly due to concerns from security
folks that the BPF insn image could get corrupted (through some other bug in the
kernel) in post-verifier stage by an attacker and then there's nothing really that
would provide any sort of protection guarantees; pretty much the same reasons why
e.g. modules are set to read-only in the kernel.

> Do you have any performance measures to share ?

No numbers, and I'm also not aware of any reports from users, but it was recently
brought to our attention from mm folks during discussion of a different set:

https://lore.kernel.org/lkml/1572171452-7958-2-git-send-email-rppt@kernel.org/T/

Thanks,
Daniel
