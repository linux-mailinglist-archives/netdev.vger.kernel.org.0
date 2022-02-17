Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBBF4BA3CB
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbiBQO4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:56:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiBQOzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:55:40 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9912B2C7B;
        Thu, 17 Feb 2022 06:55:24 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4JzyYQ5rB1z9sSZ;
        Thu, 17 Feb 2022 15:55:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TsOvGGPTaGjN; Thu, 17 Feb 2022 15:55:22 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4JzyYP59kZz9sSW;
        Thu, 17 Feb 2022 15:55:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A04598B77C;
        Thu, 17 Feb 2022 15:55:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id jCpsHyiEQc1l; Thu, 17 Feb 2022 15:55:21 +0100 (CET)
Received: from [192.168.6.239] (unknown [192.168.6.239])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 158D78B763;
        Thu, 17 Feb 2022 15:55:21 +0100 (CET)
Message-ID: <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu>
Date:   Thu, 17 Feb 2022 15:55:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Content-Language: fr-FR
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     David Laight <David.Laight@ACULAB.COM>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
 <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com>
 <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
In-Reply-To: <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 17/02/2022 à 15:50, Christophe Leroy a écrit :
> Adding Ingo, Andrew and Nick as they were involved in the subjet,
> 
> Le 17/02/2022 à 14:36, David Laight a écrit :
>> From: Christophe Leroy
>>> Sent: 17 February 2022 12:19
>>>
>>> All functions defined as static inline in net/checksum.h are
>>> meant to be inlined for performance reason.
>>>
>>> But since commit ac7c3e4ff401 ("compiler: enable
>>> CONFIG_OPTIMIZE_INLINING forcibly") the compiler is allowed to
>>> uninline functions when it wants.
>>>
>>> Fair enough in the general case, but for tiny performance critical
>>> checksum helpers that's counter-productive.
>>
>> There isn't a real justification for allowing the compiler
>> to 'not inline' functions in that commit.
> 
> Do you mean that the two following commits should be reverted:
> 
> - 889b3c1245de ("compiler: remove CONFIG_OPTIMIZE_INLINING entirely")
> - 4c4e276f6491 ("net: Force inlining of checksum functions in 
> net/checksum.h")

Of course not the above one (copy/paste error), but:
- ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING forcibly")


> 
>>
>> It rather seems backwards.
>> The kernel sources don't really have anything marked 'inline'
>> that shouldn't always be inlined.
>> If there are any such functions they are few and far between.
>>
>> I've had enough trouble (elsewhere) getting gcc to inline
>> static functions that are only called once.
>> I ended up using 'always_inline'.
>> (That is 4k of embedded object code that will be too slow
>> if it ever spills a register to stack.)
>>
> 
> I agree with you that that change is a nightmare with many small 
> functions that we really want inlined, and when we force inlining we 
> most of the time get a smaller binary.
> 
> And it becomes even more problematic when we start adding 
> instrumentation like stack protector.
> 
> According to the original commits however this was supposed to provide 
> real benefit:
> 
> - 60a3cdd06394 ("x86: add optimized inlining")
> - 9012d011660e ("compiler: allow all arches to enable 
> CONFIG_OPTIMIZE_INLINING")
> 
> But when I build ppc64le_defconfig + CONFIG_CC_OPTIMISE_FOR_SIZE I get:
>      112 times  queued_spin_unlock()
>      122 times  mmiowb_spin_unlock()
>      151 times  cpu_online()
>      225 times  __raw_spin_unlock()
> 
> 
> So I was wondering, would we have a way to force inlining of functions 
> marked inline in header files while leaving GCC handling the ones in C 
> files the way it wants ?
> 
> Christophe
