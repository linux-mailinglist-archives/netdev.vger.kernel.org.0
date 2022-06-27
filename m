Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E151B55DA95
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiF0JZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 05:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiF0JZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 05:25:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DD132DE4;
        Mon, 27 Jun 2022 02:25:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4B141758;
        Mon, 27 Jun 2022 02:25:51 -0700 (PDT)
Received: from [192.168.4.21] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BC583F792;
        Mon, 27 Jun 2022 02:25:47 -0700 (PDT)
Message-ID: <4e4b9e1a-778e-9ca1-5c15-65e45a532790@arm.com>
Date:   Mon, 27 Jun 2022 10:25:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 1/4] time64.h: define PSEC_PER_NSEC and use it in
 tc-taprio
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
 <20220626120505.2369600-2-vladimir.oltean@nxp.com>
 <5db4e640-8165-d7bf-c6b6-192ea7edfafd@arm.com>
 <20220627085101.jw55y3fakqcw7zgi@skbuf>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
In-Reply-To: <20220627085101.jw55y3fakqcw7zgi@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 6/27/22 09:51, Vladimir Oltean wrote:
> Hi Vincenzo,
> 
> On Mon, Jun 27, 2022 at 08:52:51AM +0100, Vincenzo Frascino wrote:
>> Hi Vladimir,
>>
>> On 6/26/22 13:05, Vladimir Oltean wrote:
>>> Time-sensitive networking code needs to work with PTP times expressed in
>>> nanoseconds, and with packet transmission times expressed in
>>> picoseconds, since those would be fractional at higher than gigabit
>>> speed when expressed in nanoseconds.
>>>
>>> Convert the existing uses in tc-taprio to a PSEC_PER_NSEC macro.
>>>
>>> Cc: Andy Lutomirski <luto@kernel.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>>  include/vdso/time64.h  | 1 +
>>>  net/sched/sch_taprio.c | 4 ++--
>>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/vdso/time64.h b/include/vdso/time64.h
>>> index b40cfa2aa33c..f1c2d02474ae 100644
>>> --- a/include/vdso/time64.h
>>> +++ b/include/vdso/time64.h
>>> @@ -6,6 +6,7 @@
>>>  #define MSEC_PER_SEC	1000L
>>>  #define USEC_PER_MSEC	1000L
>>>  #define NSEC_PER_USEC	1000L
>>> +#define PSEC_PER_NSEC	1000L
>>
>> Are you planning to use this definition in the vdso library code? If not, you
>> should define PSEC_PER_NSEC in "include/linux/time64.h". The vdso namespace
>> should contain only the definitions shared by the implementations of the kernel
>> and of the vdso library.
> 
> I am not. I thought it would be ok to preserve the locality of
> definitions by placing this near the others of its kind, since a macro
> doesn't affect the compiled vDSO code in any way. But if you prefer, I
> can create a new mini-section in linux/time64.h. Any preference on where
> exactly to place that definition within the file?

I do not have a strong opinion on where to put it. But I think that if you put a
section above TIME64_MAX should work.

-- 
Regards,
Vincenzo
