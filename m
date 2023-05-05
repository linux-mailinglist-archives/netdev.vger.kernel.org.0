Return-Path: <netdev+bounces-538-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DBD6F8012
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C9A01C21791
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170CE6FCD;
	Fri,  5 May 2023 09:35:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E55185F
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 09:35:46 +0000 (UTC)
X-Greylist: delayed 120 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 May 2023 02:35:44 PDT
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9192B10F3;
	Fri,  5 May 2023 02:35:44 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0d:3786:0:640:7c97:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 41FD55FE5C;
	Fri,  5 May 2023 12:32:22 +0300 (MSK)
Received: from [IPV6:2a02:6b8:8f:4:fa75:a4ff:fe7d:8480] (unknown [2a02:6b8:8f:4:fa75:a4ff:fe7d:8480])
	by mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KWM9p51Md4Y0-LrYvKBCj;
	Fri, 05 May 2023 12:32:21 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
	t=1683279141; bh=QOEfsKhD5CPZN7d5tMPdaF8K3hBxLOrIJmpgjjFuNw4=;
	h=In-Reply-To:Cc:Date:References:To:From:Subject:Message-ID;
	b=IJ3WH8Bz8JVjnw/Et8eXONYynxikWXNavKtgmsbBzoDCCFH75058GEsYneaLBWAeu
	 1OYVDp9niHxQcO2G6x58hESlO0ekQvqMPSoBFPelMzIf3axAS/dFpeNwojSkTHrt9e
	 FhY4NhF8oFrPeTObrIbqu2+WCJe/93WyMWsNsqcs=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <da46f02b-dbf1-5927-5d83-e44febcafe7c@yandex-team.ru>
Date: Fri, 5 May 2023 12:32:20 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net 1/2] net/ethernet/chelsio: fix cxgb4_getpgtccfg wrong
 memory access
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
To: Leon Romanovsky <leon@kernel.org>
Cc: rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, anish@chelsio.com,
 hariprasad@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230116152100.30094-1-davydov-max@yandex-team.ru>
 <20230116152100.30094-2-davydov-max@yandex-team.ru> <Y8ZonuQJn8gO9GX5@unreal>
 <e246efa2-7bc1-5413-32d0-c2927ebb001e@yandex-team.ru>
In-Reply-To: <e246efa2-7bc1-5413-32d0-c2927ebb001e@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Ping

To summarize:
*pgid can be 0xF, but valid values are 0-7. Whether *bw_per is set or
not set inside if-block, it will have valid value (it was set to zero
before)


On 1/18/23 11:29, Maksim Davydov wrote:
>
> On 1/17/23 12:21, Leon Romanovsky wrote:
>> On Mon, Jan 16, 2023 at 06:20:59PM +0300, Maksim Davydov wrote:
>>> *pgid can be in range 0 to 0xF (bitmask 0xF) but valid values for PGID
>>> are between 0 and 7. Also the size of pgrate is 8. Thus, we are needed
>>> additional check to make sure that this code doesn't have access to 
>>> tsa.
>>>
>>> Found by Linux Verification Center (linuxtesting.org) with the SVACE
>>> static analysis tool.
>>>
>>> Fixes: 76bcb31efc06 ("cxgb4 : Add DCBx support codebase and dcbnl_ops")
>>> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
>>> ---
>>>   drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c 
>>> b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
>>> index 7d5204834ee2..3aa65f0f335e 100644
>>> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
>>> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
>>> @@ -471,7 +471,10 @@ static void cxgb4_getpgtccfg(struct net_device 
>>> *dev, int tc,
>>>           return;
>>>       }
>>>   -    *bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];
>>> +    /* Valid values are: 0-7 */
>> How do you see it?
>>
>> There are lines below that assume something different.
>>     477         /* prio_type is link strict */
>>     478         if (*pgid != 0xF)
>>     479                 *prio_type = 0x2;
>>
> But if *pgid == 0xF we get value for *bw_per from pgrate.tsa, it seems 
> not correct
>
> Thanks for reviewing,
> Maksim Davydov
>>> +    if (*pgid <= 7)
>>> +        *bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];
>> Why do you think that it is valid simply do not set *bw_per?
>>
>> Thanks

-- 
Best regards,
Maksim Davydov


