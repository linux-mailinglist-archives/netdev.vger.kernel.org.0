Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF8635B698
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 20:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhDKSjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 14:39:52 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:58499 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235559AbhDKSjv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 14:39:51 -0400
Received: from [192.168.0.2] (ip5f5aef24.dynamic.kabel-deutschland.de [95.90.239.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C953B20645D43;
        Sun, 11 Apr 2021 20:39:31 +0200 (CEST)
Subject: Re: sysctl: setting key "net.core.bpf_jit_enable": Invalid argument
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Cc:     it+linux-bpf@molgen.mpg.de, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <412d88b2-fa9a-149e-6f6e-3cfbce9edef0@molgen.mpg.de>
 <d880c38c-e410-0b69-0897-9cbf4b759045@csgroup.eu>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <1b1b8cae-b852-2c4f-0a67-d40768758be9@molgen.mpg.de>
Date:   Sun, 11 Apr 2021 20:39:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <d880c38c-e410-0b69-0897-9cbf4b759045@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Christophe,


Am 11.04.21 um 18:23 schrieb Christophe Leroy:

> Le 11/04/2021 à 13:09, Paul Menzel a écrit :

>> Related to * [CVE-2021-29154] Linux kernel incorrect computation of 
>> branch displacements in BPF JIT compiler can be abused to execute 
>> arbitrary code in Kernel mode* [1], on the POWER8 system IBM S822LC 
>> with self-built Linux 5.12.0-rc5+, I am unable to disable 
>> `bpf_jit_enable`.
>>
>>     $ /sbin/sysctl net.core.bpf_jit_enable
>>     net.core.bpf_jit_enable = 1
>>     $ sudo /sbin/sysctl -w net.core.bpf_jit_enable=0
>>     sysctl: setting key "net.core.bpf_jit_enable": Invalid argument
>>
>> It works on an x86 with Debian sid/unstable and Linux 5.10.26-1.
> 
> Maybe you have selected CONFIG_BPF_JIT_ALWAYS_ON in your self-built 
> kernel ?
> 
> config BPF_JIT_ALWAYS_ON
>      bool "Permanently enable BPF JIT and remove BPF interpreter"
>      depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
>      help
>        Enables BPF JIT and removes BPF interpreter to avoid
>        speculative execution of BPF instructions by the interpreter

Thank you. Indeed. In contrast to Debian, Ubuntu’s Linux configuration 
selects that option, and I copied that.

     $ grep _BPF_JIT /boot/config-5.8.0-49-generic
     /boot/config-5.8.0-49-generic:CONFIG_BPF_JIT_ALWAYS_ON=y
     /boot/config-5.8.0-49-generic:CONFIG_BPF_JIT_DEFAULT_ON=y
     /boot/config-5.8.0-49-generic:CONFIG_BPF_JIT=y

I wonder, if there is a way to better integrate that option into 
`/proc/sys`, so it’s clear, that it’s always enabled.


Kind regards,

Paul
