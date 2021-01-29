Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520833088BB
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 13:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhA2L7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 06:59:24 -0500
Received: from novek.ru ([213.148.174.62]:45536 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbhA2L5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 06:57:11 -0500
Received: from [172.23.108.4] (unknown [88.151.187.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 517F0500192;
        Fri, 29 Jan 2021 14:08:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 517F0500192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611918497; bh=UvfrlA78qNTKkjJoC1+caRnP/3X0ZLqGK4dX2vHMjcU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jc6WvddcFpM94/iVl8ExWlkuWVUCYpAsg4bI+04jDD8NBXFOgZQsObc2PmdFDOLyq
         rZR1mautfdxrPVhbK12YXMoYRz4aeJvYNxsHQLXbxqCl8yDGmpYEB6E6K3rQRGYwkn
         SIb1RgueeNIclYt03pMJt1sp9X0Hpck6CjFYeajQ=
Subject: Re: [net v2] net: ip_tunnel: fix mtu calculation
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
References: <1611882159-17421-1-git-send-email-vfedorenko@novek.ru>
 <CAF=yD-Lmk+nuUWKK+HcoALyPY_xr9rMU_+AsfgAAB0+vCOijRw@mail.gmail.com>
 <CAF=yD-K2sjoMVWo0rV-3O8oPbQ-TF6bsCMVSOAx1tYjPJzi=rQ@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <12b5849e-2637-aa1f-e3ca-81f3c28ce377@novek.ru>
Date:   Fri, 29 Jan 2021 11:06:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-K2sjoMVWo0rV-3O8oPbQ-TF6bsCMVSOAx1tYjPJzi=rQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2021 02:38, Willem de Bruijn wrote:
> On Thu, Jan 28, 2021 at 9:21 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>
>> On Thu, Jan 28, 2021 at 8:02 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>>
>>> dev->hard_header_len for tunnel interface is set only when header_ops
>>> are set too and already contains full overhead of any tunnel encapsulation.
>>> That's why there is not need to use this overhead twice in mtu calc.
>>>
>>> Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
>>> Reported-by: Slava Bacherikov <mail@slava.cc>
>>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>>
>> Acked-by: Willem de Bruijn <willemb@google.com>
>>
>> It is easy to verify that if hard_header_len is zero the calculation
>> does not change. And as discussed, ip_gre is the only ip_tunnel
>> user that sometimes has it non-zero (for legacy reasons that
>> we cannot revert now). In that case it is equivalent to tun->hlen +
>> sizeof(struct iphdr). LGTM. Thanks!
> 
> Actually, following that reasoning, we can just remove
> dev->hard_header_len from these calculations, no need for branching.

Shouldn't we rely on what users provide? I mean for the future changes.
But yeah, maybe you are right. All users should set tun->hlen correctly and in 
this case ip_tunnel should simply add it's own overhead (sizeof(struct iphdr)) 
to calculate the MTU-related values. Going to eliminate branching?

>> Btw, ip6_gre might need the same after commit 832ba596494b
>> ("net: ip6_gre: set dev->hard_header_len when using header_ops")

Sure, will make it too after clarifying situation with ip_tunnel.
