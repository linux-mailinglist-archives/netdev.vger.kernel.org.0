Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2086613CE38
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgAOUsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:48:23 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:32963 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgAOUsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:48:23 -0500
X-Originating-IP: 79.86.19.127
Received: from [192.168.0.12] (127.19.86.79.rev.sfr.net [79.86.19.127])
        (Authenticated sender: alexandre@ghiti.fr)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 161D1240002;
        Wed, 15 Jan 2020 20:48:18 +0000 (UTC)
From:   Alexandre Ghiti <alexandre@ghiti.fr>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Zong Li <zong.li@sifive.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <a367af4d-7267-2e94-74dc-2a2aac204080@ghiti.fr>
 <20191018105657.4584ec67@canb.auug.org.au>
 <20191028110257.6d6dba6e@canb.auug.org.au>
 <mhng-0daa1a90-2bed-4b2e-833e-02cd9c0aa73f@palmerdabbelt-glaptop>
 <d5d59f54-e391-3659-d4c0-eada50f88187@ghiti.fr>
 <CANXhq0pn+Nq6T5dNyJiB6xvmqTnPSzo8sVfqHhGyWUURY+1ydg@mail.gmail.com>
 <CAADnVQ+kbxpw7fxRZodTtE7AmEmRDgO9fcmMD8kKRssS8WJizA@mail.gmail.com>
Message-ID: <6c03d212-775c-cddb-b0d0-d7b00571694b@ghiti.fr>
Date:   Wed, 15 Jan 2020 15:48:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+kbxpw7fxRZodTtE7AmEmRDgO9fcmMD8kKRssS8WJizA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/20 6:23 AM, Alexei Starovoitov wrote:
> On Sun, Jan 12, 2020 at 8:33 PM Zong Li<zong.li@sifive.com>  wrote:
>> I'm not quite familiar with btf, so I have no idea why there are two
>> weak symbols be added in 8580ac9404f6 ("bpf: Process in-kernel BTF")
> I can explain what these weak symbols are for, but that won't change
> the fact that compiler or linker are buggy. The weak symbols should work
> in all cases and compiler should pick correct relocation.
> In this case it sounds that compiler picked relative relocation and failed
> to reach zero from that address.

Sorry for the response delay: I now agree that there is nothing weird 
about those
relocations. All compiler/linker I took a look at (arm64, ppc64 and 
riscv64) correctly
emit an absolute relocation to the address 0 in case of a weak 
unresolved symbol,
so there's no buggy compiler/linker.

And regarding ppc warning, the kernel being compiled as -pie, the 
scripts looks
for absolute relocations which it considers as "bad", except for one 
that is known
to be weak and that is ignored: I have just sent a patch to fix this 
script so that weak
undefined symbol relocations are not considered as bad.

Thanks,

Alex


