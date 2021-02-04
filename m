Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A7630F7A2
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbhBDQWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:22:24 -0500
Received: from novek.ru ([213.148.174.62]:60852 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237076AbhBDPLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 10:11:05 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id DC1BD503356;
        Thu,  4 Feb 2021 18:10:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru DC1BD503356
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612451418; bh=DZG7Aj/RwvEO3w+dP7epSHunV3aBlffxKrVr1EQMK+U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=iYgduv8+Bd0EONz4MkLdSKHesWnE6fJZK3vu/4K1E/GQPGpovwJ4Nmks32QNJv3aS
         lHeBWYO2ttIYidinhzw/MGkJ6fZ8O/QEN2mauKJvACWwyFZgmWXH2cYN92NBRKqRs4
         MzkUy0U6Eda8XdvkAztGdEsuZZbofkzuDy9Adm+0=
Subject: Re: [net] selftests: txtimestamp: fix compilation issue
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>
References: <1612385537-9076-1-git-send-email-vfedorenko@novek.ru>
 <CA+FuTSf4mrJG48od153gec9-xtpAPwx_-OTkD=cMRCJMXnupjg@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <6d6e929a-052c-04ff-2b97-084970c357b2@novek.ru>
Date:   Thu, 4 Feb 2021 15:10:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSf4mrJG48od153gec9-xtpAPwx_-OTkD=cMRCJMXnupjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.02.2021 13:34, Willem de Bruijn wrote:
> On Wed, Feb 3, 2021 at 4:11 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>
>> PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
>> test. But we cannot include it because we have definitions of struct and
>> including leads to redefinition error. So define PACKET_TX_TIMESTAMP too.
> 
> The conflicts are with <netpacket/packet.h>. I think it will build if
> you remove that.

Good point. I will try to replace the includes.

>> Fixes: 5ef5c90e3cb3 (selftests: move timestamping selftests to net folder)
> 
> This commit only moved the file. The file was moved twice. Even though
> it cannot really be applied easily before the move, this goes back to
> commit 8fe2f761cae9 ("net-timestamp: expand documentation").
Yeah, you are right. Didn't go so deep.

>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> 
> Do you also get the compiler warning about ambiguous control flow?
> 
>    tools/testing/selftests/net/txtimestamp.c:498:6: warning: suggest
> explicit braces to avoid ambiguous ‘else’ [-Wdangling-else]
> 
> When touching this file, might be good to also fix that up:
> 
> -               if (cfg_use_pf_packet || cfg_ipproto == IPPROTO_RAW)
> +               if (cfg_use_pf_packet || cfg_ipproto == IPPROTO_RAW) {
>                          if (family == PF_INET)
>                                  total_len += sizeof(struct iphdr);
>                          else
>                                  total_len += sizeof(struct ipv6hdr);
> +               }
> 

Yes, but skipped it because the main goal was to fix selftests/net build in 
general and forgot about it later. I will address this warning too.

Thanks Willem!
