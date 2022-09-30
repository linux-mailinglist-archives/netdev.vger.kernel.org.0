Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939F75F01DF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiI3Aoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiI3Aod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:44:33 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FA120289F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 17:44:31 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 802D650063A;
        Fri, 30 Sep 2022 03:41:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 802D650063A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1664498473; bh=IKmY21h5OrvguuYYLz96dTUw8xn1QX0VYUyl0XW/lzA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hMg9F1nncGC/ck+wiHEfKeongMcIeVadHLe8h0SRsasMGLmf4+1a7SHMEy0cbh5Kb
         ago09fJcpOYVTtrNA+1EYYT3fUAosnUdtf6O1P2SoWi3I1ZefdE7jd3t7om48jzovL
         AphWGEjpAJkzS8MvHJF9y0kpAEVtd/ppZkDqbfgg=
Message-ID: <6b80b6c8-29fd-4c2a-e963-1f273d866f12@novek.ru>
Date:   Fri, 30 Sep 2022 01:44:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <YzWESUXPwcCo67LP@nanopsycho>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <YzWESUXPwcCo67LP@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.09.2022 12:40, Jiri Pirko wrote:
> Sun, Jun 26, 2022 at 09:24:41PM CEST, vfedorenko@novek.ru wrote:
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> Implement common API for clock/DPLL configuration and status reporting.
>> The API utilises netlink interface as transport for commands and event
>> notifications. This API aim to extend current pin configuration and
>> make it flexible and easy to cover special configurations.
> 
> Do you have the userspace part somewhere?
> It is very nice to add example outputs of user cmdline of such tool to
> the patch description/cover letter.

Sorry, but we don't have any user-space part for now. It's still WIP and there 
are too many changes in the protocol to implement anything useful on top of it. 
Once we will get to a kind of "stable" proto, I will implement a library to use it.

> 
> Also, did you consider usage of sysfs? Why it isn't a better fit than
> netlink?

We already have sysfs implemented in the ptp_ocp driver. But it looks like more 
hardware is going to be available soon with almost the same functions, so it 
would be great to have common protocol to configure such devices.
> 
> Regarding the naming, is "dpll" the correct one. Forgive me for being a
> syncE greenie, but isn't dpll just one algo to achieve syntonous
> clocks? Perhaps "dco" as for "Digitally Controlled Oscillator" would be
> somewhat better fit?
> 

We will discuss the naming too, thanks!

> 
>>
>> v1 -> v2:
>> * implement returning supported input/output types
>> * ptp_ocp: follow suggestions from Jonathan
>> * add linux-clk mailing list
>> v0 -> v1:
>> * fix code style and errors
>> * add linux-arm mailing list
>>
>>
>> Vadim Fedorenko (3):
>>   dpll: Add DPLL framework base functions
>>   dpll: add netlink events
>>   ptp_ocp: implement DPLL ops
>>
>> MAINTAINERS                 |   8 +
>> drivers/Kconfig             |   2 +
>> drivers/Makefile            |   1 +
>> drivers/dpll/Kconfig        |   7 +
>> drivers/dpll/Makefile       |   7 +
>> drivers/dpll/dpll_core.c    | 161 ++++++++++
>> drivers/dpll/dpll_core.h    |  40 +++
>> drivers/dpll/dpll_netlink.c | 595 ++++++++++++++++++++++++++++++++++++
>> drivers/dpll/dpll_netlink.h |  14 +
>> drivers/ptp/Kconfig         |   1 +
>> drivers/ptp/ptp_ocp.c       | 169 +++++++---
>> include/linux/dpll.h        |  29 ++
>> include/uapi/linux/dpll.h   |  81 +++++
>> 13 files changed, 1079 insertions(+), 36 deletions(-)
>> create mode 100644 drivers/dpll/Kconfig
>> create mode 100644 drivers/dpll/Makefile
>> create mode 100644 drivers/dpll/dpll_core.c
>> create mode 100644 drivers/dpll/dpll_core.h
>> create mode 100644 drivers/dpll/dpll_netlink.c
>> create mode 100644 drivers/dpll/dpll_netlink.h
>> create mode 100644 include/linux/dpll.h
>> create mode 100644 include/uapi/linux/dpll.h
>>
>> -- 
>> 2.27.0
>>

