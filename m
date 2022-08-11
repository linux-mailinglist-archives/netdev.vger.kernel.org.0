Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124D958F8D4
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiHKIHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiHKIHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:07:32 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DD090186
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:07:29 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 04F6C7F4F5;
        Thu, 11 Aug 2022 10:07:27 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5CA334064;
        Thu, 11 Aug 2022 10:07:26 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC7CE3405A;
        Thu, 11 Aug 2022 10:07:26 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu, 11 Aug 2022 10:07:26 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id A129A7F4F5;
        Thu, 11 Aug 2022 10:07:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660205246; bh=cWyqlT+JCwjd6Y7gqECvYiA53jRQfyFDngYd1di2DI0=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=G4KczGK5KeA05GmngcT7eJ1VImnc64xqskT7WvB4KVlXH75FKBb7Q0MERZ1ENw8eo
         XToEB8/RVciP+7uQ+MUuMXlFvobW4ZdKX5oN1C+wtVSucyr9TVe7BqPdJYCWInUk77
         CpbOLPhgu5qxuFncbD3HNsoxTWWtm6sHZLsSgEkaKN9BhjahSUgNaSzNBLQ7MhxljO
         thV+HS6GFA2xYFJtY3Vrqy+KswQxmG7TjMZ+M/hFpIOKvi9cUhuMBfM4wXjsi5jnlk
         34kH+RceOSYAFsX8JwfbBKGZ0GHQYQe6dkoN2ZG8VF4w+B1zIR5bDP9IzXsy9w33ul
         PQnCOygea7tXQ==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.9; Thu, 11
 Aug 2022 10:07:25 +0200
Message-ID: <dd6e3a60-cb5f-9c3c-2608-637ceb8de09c@prolan.hu>
Date:   Thu, 11 Aug 2022 10:07:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] fec: Restart PPS after link state change
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, Fugang Duan <fugang.duan@nxp.com>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch> <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
 <YvRH06S/7E6J8RY0@lunn.ch> <YvRdTwRM4JBc5RuV@hoboy.vegasvil.org>
 <YvRjzwMsMWv3AG1H@lunn.ch>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <YvRjzwMsMWv3AG1H@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456617362
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022. 08. 11. 4:05, Andrew Lunn wrote:
> On Wed, Aug 10, 2022 at 06:37:19PM -0700, Richard Cochran wrote:
>> On Thu, Aug 11, 2022 at 02:05:39AM +0200, Andrew Lunn wrote:
>>>> Yes. We use PPS to synchronize devices on a common backplane. We use PTP to
>>>> sync this PPS to a master clock. But if PTP sync drops out, we wouldn't want
>>>> the backplane-level synchronization to fail. The PPS needs to stay on as
>>>> long as userspace *explicitly* disables it, regardless of what happens to
>>>> the link.
>>>
>>> We need the PTP Maintainers view on that. I don't know if that is
>>> normal or not.
>>
>> IMO the least surprising behavior is that once enabled, a feature
>> stays on until explicitly disabled.
> 
> O.K, thanks for the response.
> 
> Your answer is a bit surprising to me. To me, an interface which is
> administratively down is completely inactive. The action to down it
> should disable everything.

I think you are confusing two states here. This patch addresses the bug 
thatcauses the PPS to drop when the Ethernet link goes away. The 
interface remainsUP the whole time.

> 
> So your answer also implies PPS can be used before the interface is
> set administratively up?

The PPS can already be used before the first link-up, but once it has 
acquired a link once, PPS no longer works without a link.

> 
> 	Andrew
