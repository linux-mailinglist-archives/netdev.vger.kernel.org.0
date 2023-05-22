Return-Path: <netdev+bounces-4304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08CFF70BF80
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C66551C20A07
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAD613AD7;
	Mon, 22 May 2023 13:19:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222FF134C8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:19:50 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4886C6;
	Mon, 22 May 2023 06:19:48 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 1E6555FD53;
	Mon, 22 May 2023 16:19:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1684761587;
	bh=tu8OvW/hOdbLzHtNqpM5/g+Q4tXiEO+oUgB0ugzeF90=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	b=Kccp1ubWuvXAt6dCkxHCle71V8nDO5PQvKzVtzv2YVentBS5XkE0YEcT7E5qSZi/U
	 v/WM6BiAmanabfGusRfiZrognc21NnELM+agu3LaDqdzm9aOtnWpRQOr++SRVMKf6E
	 zArW0uIvknSwZmZnDx7U4rJpsaS40EC65NMr3rZ+Xf4WYN7bDDVm550AE0ffsyj5pU
	 JTFUAmktEB8TD1YEFRlY6q2+cExVCp4a8F6GctLRMdRl9fv80XRxvgx9W82Vr734xl
	 +9JMBGzTsXRZEuvmz9Y8FFw4dFencnlFh2ypUUkk7KP39rEBmG0tRxqXldo7UCYYD0
	 9suqELoCDZIMw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Mon, 22 May 2023 16:19:46 +0300 (MSK)
Message-ID: <e7005e49-54fd-92c7-d6a5-7b69bccbc254@sberdevices.ru>
Date: Mon, 22 May 2023 16:15:26 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 04/17] vsock/virtio: non-linear skb handling for
 tap
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <20230522073950.3574171-5-AVKrasnov@sberdevices.ru>
 <ZGtqijZSCbAsS5D3@corigine.com>
From: Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <ZGtqijZSCbAsS5D3@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/22 08:14:00 #21365129
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 22.05.2023 16:13, Simon Horman wrote:
> On Mon, May 22, 2023 at 10:39:37AM +0300, Arseniy Krasnov wrote:
>> For tap device new skb is created and data from the current skb is
>> copied to it. This adds copying data from non-linear skb to new
>> the skb.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>>  net/vmw_vsock/virtio_transport_common.c | 31 ++++++++++++++++++++++---
>>  1 file changed, 28 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 16effa8d55d2..9854f48a0544 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -106,6 +106,27 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>>  	return NULL;
>>  }
>>  
>> +static void virtio_transport_copy_nonlinear_skb(struct sk_buff *skb,
>> +						void *dst,
>> +						size_t len)
>> +{
>> +	struct iov_iter iov_iter = { 0 };
>> +	struct iovec iovec;
>> +	size_t to_copy;
>> +
>> +	iovec.iov_base = dst;
> 
> Hi Arseniy,
> 
> Sparse seems unhappy about this.
> Though, TBH, I'm unsure what should be done about it.
> 
> .../virtio_transport_common.c:117:24: warning: incorrect type in assignment (different address spaces)
> .../virtio_transport_common.c:117:24:    expected void [noderef] __user *iov_base
> .../virtio_transport_common.c:117:24:    got void *dst
> 
Got it, i'll check how to resolve this problem!

Thanks!
> 
> ...

