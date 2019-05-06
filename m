Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB752146A2
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEFInv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:43:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:57706 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfEFInv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:43:51 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNZDs-0003jm-NP; Mon, 06 May 2019 10:43:44 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNZDs-000Hdy-GP; Mon, 06 May 2019 10:43:44 +0200
Subject: Re: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
To:     David Laight <David.Laight@ACULAB.COM>,
        'Josh Elsasser' <jelsasser@appneta.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
 <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
 <6C3E4204-AABF-45AD-B32D-62CB50391D89@appneta.com>
 <4b9338513f16457ea167da651c8b997b@AcuMS.aculab.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <14dd60c5-0fb7-1fc5-9bf6-4cb1510a1abc@iogearbox.net>
Date:   Mon, 6 May 2019 10:43:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <4b9338513f16457ea167da651c8b997b@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25440/Sun May  5 10:04:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/30/2019 12:42 PM, David Laight wrote:
> From: Josh Elsasser
>> Sent: 29 April 2019 21:02
>> On Apr 29, 2019, at 12:16 PM, Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
>>
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> GCC will generate jump tables for switch-statements with more than 5
>>> case statements. An entry into the jump table is an indirect call,
>>> which means that for CONFIG_RETPOLINE builds, this is rather
>>> expensive.
>>>
>>> This commit replaces the switch-statement that acts on the XDP program
>>> result with an if-clause.
>>
>> Apologies for the noise, but is this patch still required after the
>> recent threshold bump[0] and later removal[1] of switch-case jump
>> table generation when building with CONFIG_RETPOLINE?
>>
>> [0]: https://lore.kernel.org/patchwork/patch/1044863/
>> [1]: https://lore.kernel.org/patchwork/patch/1054472/
>>
>> If nothing else the commit message no longer seems accurate.
> 
> Looking at those two patches, the second one seems wrong:
> 
>    # Additionally, avoid generating expensive indirect jumps which
>    # are subject to retpolines for small number of switch cases.
>    # clang turns off jump table generation by default when under
> -  # retpoline builds, however, gcc does not for x86.
> -  KBUILD_CFLAGS += $(call cc-option,--param=case-values-threshold=20)
> +  # retpoline builds, however, gcc does not for x86. This has
> +  # only been fixed starting from gcc stable version 8.4.0 and
> +  # onwards, but not for older ones. See gcc bug #86952.
> +  ifndef CONFIG_CC_IS_CLANG
> +    KBUILD_CFLAGS += $(call cc-option,-fno-jump-tables)
> +  endif
> 
> If -fno-jump-tables isn't supported then --param=case-values-threshold=20
> needs to be set (if supported).

Nope, not really, -fno-jump-tables support predates the latter, and
both are supported for gcc versions the kernel cares about.
