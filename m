Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48794AEB8B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbiBIHyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiBIHyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:54:15 -0500
X-Greylist: delayed 42799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 23:54:18 PST
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB23C0613CA;
        Tue,  8 Feb 2022 23:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644393256;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=sCy+BFzraB5UPCDrJqayTu4U5x2Azckr0KW+I3kfiQc=;
    b=K9GgT2Gsq67ZGqFQdUZ6Ak/QSOAJogD90+bxmZUKtXDc9vR3k2qp07VDoEatKT9IwE
    9/3OfmHeRCFkXwD0dr8TGh3G/GbG9EkmsQ0H2JlqmCOwGN2Q7SFWomKasV8ZSlL0X82k
    CLciobQThGH4e9ehGnck7C/6iTqsAJZj+yWvQdr0eovdOcxLVQcstoqhqhZPmOuWbF/i
    FRVZAT3wb/hdmYXLFVDCLteMTDMs3HJUzOpfUmaB5AdSNs4tTqOTGqmf4v2G+JrX56pa
    gNmi2iDu1bP8M2Uecv4k/Xvb4iHhKNwVgyk8dykOaz+kcb0pstH1l88gmjStXW7ndRyF
    /bCQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy197sFNsZ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Feb 2022 08:54:15 +0100 (CET)
Message-ID: <b4be7878-e461-e2c3-2aaf-89598ac8a64f@hartkopp.net>
Date:   Wed, 9 Feb 2022 08:54:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
 <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
 <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
 <20220128080704.ns5fzbyn72wfoqmx@pengutronix.de>
 <72419ca8-b0cb-1e9d-3fcc-655defb662df@hartkopp.net>
 <20220128084603.jvrvapqf5dt57yiq@pengutronix.de>
 <07c69ccd-dbc0-5c74-c68e-8636ec9179ef@hartkopp.net>
 <20220207081123.sdmczptqffwr64al@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220207081123.sdmczptqffwr64al@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 07.02.22 09:11, Marc Kleine-Budde wrote:
> On 28.01.2022 15:48:05, Oliver Hartkopp wrote:
>> Hello Marc, hello William,
>>
>> On 28.01.22 09:46, Marc Kleine-Budde wrote:
>>> On 28.01.2022 09:32:40, Oliver Hartkopp wrote:
>>>>
>>>>
>>>> On 28.01.22 09:07, Marc Kleine-Budde wrote:
>>>>> On 28.01.2022 08:56:19, Oliver Hartkopp wrote:
>>>>>> I've seen the frame processing sometimes freezes for one second when
>>>>>> stressing the isotp_rcv() from multiple sources. This finally freezes
>>>>>> the entire softirq which is either not good and not needed as we only
>>>>>> need to fix this race for stress tests - and not for real world usage
>>>>>> that does not create this case.
>>>>>
>>>>> Hmmm, this doesn't sound good. Can you test with LOCKDEP enabled?
>>
>>
>>>> #
>>>> # Lock Debugging (spinlocks, mutexes, etc...)
>>>> #
>>>> CONFIG_LOCK_DEBUGGING_SUPPORT=y
>>>> # CONFIG_PROVE_LOCKING is not set
>>> CONFIG_PROVE_LOCKING=y
>>
>> Now enabled even more locking (seen relevant kernel config at the end).
>>
>> It turns out that there is no visible difference when using spin_lock() or
>> spin_trylock().
>>
>> I only got some of these kernel log entries
>>
>> Jan 28 11:13:14 silver kernel: [ 2396.323211] perf: interrupt took too long
>> (2549 > 2500), lowering kernel.perf_event_max_sample_rate to 78250
>> Jan 28 11:25:49 silver kernel: [ 3151.172773] perf: interrupt took too long
>> (3188 > 3186), lowering kernel.perf_event_max_sample_rate to 62500
>> Jan 28 11:45:24 silver kernel: [ 4325.583328] perf: interrupt took too long
>> (4009 > 3985), lowering kernel.perf_event_max_sample_rate to 49750
>> Jan 28 12:15:46 silver kernel: [ 6148.238246] perf: interrupt took too long
>> (5021 > 5011), lowering kernel.perf_event_max_sample_rate to 39750
>> Jan 28 13:01:45 silver kernel: [ 8907.303715] perf: interrupt took too long
>> (6285 > 6276), lowering kernel.perf_event_max_sample_rate to 31750
>>
>> But I get these sporadically anyway. No other LOCKDEP splat.
>>
>> At least the issue reported by William should be fixed now - but I'm still
>> unclear whether spin_lock() or spin_trylock() is the best approach here in
>> the NET_RX softirq?!?
> 
> With the !spin_trylock() -> return you are saying if something
> concurrent happens, drop it. This doesn't sound correct.

Yes, I had the same feeling and did some extensive load tests using both 
variants.

It turned out the standard spin_lock() works excellent to fix the issue.

Thanks for taking it for upstream here:
https://lore.kernel.org/linux-can/20220209074818.3ylfz4zmuhit7orc@pengutronix.de/T/#t

Best regards,
Oliver

