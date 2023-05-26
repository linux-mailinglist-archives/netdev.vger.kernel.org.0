Return-Path: <netdev+bounces-5685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F0297126FF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59A85281836
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7C618AFB;
	Fri, 26 May 2023 12:53:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AF1171BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:53:36 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6997D199;
	Fri, 26 May 2023 05:53:33 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id C36BA5FD59;
	Fri, 26 May 2023 15:32:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685104365;
	bh=vjpgmyB3fJ0fvSTA01eeG607ZmMDcAUYXBQfuZPLoF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	b=ZAH9YvkPcF3G645UtXIYD3gHXqTq5Npnk0hASpHi68u/q9x6+B35D+aeSGzLj+ImW
	 gbJw+8oopgj/4YnPddqrrPCDJAF5tNrZSLaXzKXWfhICmJPjUemtPTkNxMAUmIik7n
	 XD82VIIiZeb6dM1aoR7rUwtX5vA7V2ZYbVhNjFHq0f0SLKdu3+QOUXZoxQU7FJghW8
	 R60OHEycv2S1875uJz3tAeLjM4hfB3sg81+lwxCoj5xgrqIg6rw4R8hAzKeiVEH1gN
	 w5eIi0OX5bckbk84NPT8T5VrwpFYqGZmjezWsUC0okh3cRCZhK+MJqJ3+HPftOFMH5
	 Vxisk4TJQj0ww==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Fri, 26 May 2023 15:32:41 +0300 (MSK)
Message-ID: <85f50bf8-8b92-c0f8-d994-24b86be9de5b@sberdevices.ru>
Date: Fri, 26 May 2023 15:28:13 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 00/17] vsock: MSG_ZEROCOPY flag support
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
 <y5tgyj5awrd4hvlrsxsvrern6pd2sby2mdtskah2qp5hemmo2a@72nhcpilg7v2>
 <4baf786b-afe5-371d-9bc4-90226e5df3af@sberdevices.ru>
 <sdm43ibxqzdylwxaai4mjj2ucqpduc74ucyg3yrn75dxu2kix5@jynppv7kxyjz>
From: Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <sdm43ibxqzdylwxaai4mjj2ucqpduc74ucyg3yrn75dxu2kix5@jynppv7kxyjz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/26 06:32:00 #21351256
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 26.05.2023 15:23, Stefano Garzarella wrote:
> On Fri, May 26, 2023 at 02:36:17PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 26.05.2023 13:30, Stefano Garzarella wrote:
>>> On Thu, May 25, 2023 at 06:56:42PM +0300, Arseniy Krasnov wrote:
>>>>
>>>>
>>>> On 22.05.2023 10:39, Arseniy Krasnov wrote:
>>>>
>>>> This patchset is unstable with SOCK_SEQPACKET. I'll fix it.
>>>
>>> Thanks for let us know!
>>>
>>> I'm thinking if we should start split this series in two, because it
>>> becomes too big.
>>>
>>> But let keep this for RFC, we can decide later. An idea is to send
>>> the first 7 patches with a preparation series, and the next ones with a
>>> second series.
>>
>> Hello, ok! So i'll split patchset in the following way:
>> 1) Patches which adds new fields/flags and checks. But all of this is not used,
>>   as it is preparation.
>> 2) Second part starts to use it and also carries tests.
> 
> As long as they're RFCs, maybe you can keep them together if they're
> related, possibly specifying in the cover letter where you'd like to
> split them. When we agree that we are in good shape, we can split it.

Sure! I'll add this information in cover letter of v4

Thanks, Arseniy

> > Thanks,
> Stefano
> 

