Return-Path: <netdev+bounces-9164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B364727AB3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6E9281636
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C18946E;
	Thu,  8 Jun 2023 09:01:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3C78F77
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:01:28 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0992729
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 02:01:20 -0700 (PDT)
Received: from [10.10.2.69] (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id AD0BF40737A7;
	Thu,  8 Jun 2023 09:01:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru AD0BF40737A7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1686214875;
	bh=5cIS8YowCvMN9trqKxcNeiP3Gd9Xo1k7HbnwOEbs+Mo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fLemU8MzFc7SoqGR5AQ0KegwT/PgiD0r/hpw3lUzEYDDtOZN6kVjK5ca22La9k+2R
	 /XAl8xrjGx21GjiImmvXkGZuzQ5K8/7rQemYHTrv+oyf0uo+CJvFg1fjGSj8VP7Jyd
	 fOs0cXjPCmeku81S86W2Q+xhlS8mzKjw55x4yXmU=
Message-ID: <ff68da6a-8594-b218-c62b-4ae8e1ffae0a@ispras.ru>
Date: Thu, 8 Jun 2023 12:01:15 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed
 work
Content-Language: ru
To: "Keller, Jacob E" <jacob.e.keller@intel.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Wunderlich <sw@simonwunderlich.de>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>,
 "stable@kernel.org" <stable@kernel.org>, Sven Eckelmann <sven@narfation.org>
References: <20230607155515.548120-1-sw@simonwunderlich.de>
 <20230607155515.548120-2-sw@simonwunderlich.de>
 <20230607220126.26c6ee40@kernel.org>
 <CO1PR11MB5089F99A62265CE85CCB413CD650A@CO1PR11MB5089.namprd11.prod.outlook.com>
From: Vlad Efanov <vefanov@ispras.ru>
In-Reply-To: <CO1PR11MB5089F99A62265CE85CCB413CD650A@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As far as I found the synchronization is provided by delayed work 
subsystem. It is based on the WORK_STRUCT_PENDING_BIT in work->data field.

The cancel_delayed_work_sync() atomically sets this bit and 
queue_delayed_work() checks it before scheduling new delayed work.


The problem is caused by the INIT_DELAYED_WORK() call inside 
batadv_dat_start_timer(). This call happens before the 
queue_delayed_work() call and clears this bit.


Best regards,

Vlad


On 08.06.2023 08:24, Keller, Jacob E wrote:
>
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Wednesday, June 7, 2023 10:01 PM
>> To: Simon Wunderlich <sw@simonwunderlich.de>
>> Cc: davem@davemloft.net; netdev@vger.kernel.org; b.a.t.m.a.n@lists.open-
>> mesh.org; Vladislav Efanov <VEfanov@ispras.ru>; stable@kernel.org; Sven
>> Eckelmann <sven@narfation.org>
>> Subject: Re: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed
>> work
>>
>> On Wed,  7 Jun 2023 17:55:15 +0200 Simon Wunderlich wrote:
>>> The reason for these issues is the lack of synchronization. Delayed
>>> work (batadv_dat_purge) schedules new timer/work while the device
>>> is being deleted. As the result new timer/delayed work is set after
>>> cancel_delayed_work_sync() was called. So after the device is freed
>>> the timer list contains pointer to already freed memory.
>> I guess this is better than status quo but is the fix really complete?
>> We're still not preventing the timer / work from getting scheduled
>> and staying alive after the netdev has been freed, right?
> Yea, I would expect some synchronization mechanism to ensure that after cancel_delayed_work_sync() you can't queue the work again.
>
> I know for timers there is recently timer_shutdown_sync() which can be used to guarantee a timer can't re-arm at all, and its intended for some situations where there is a cyclic dependency...
>
> Thanks,
> Jake

