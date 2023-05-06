Return-Path: <netdev+bounces-689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA72A6F90AE
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A68AB1C21A6C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 08:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDCE1FBA;
	Sat,  6 May 2023 08:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17627C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 08:56:45 +0000 (UTC)
Received: from out28-100.mail.aliyun.com (out28-100.mail.aliyun.com [115.124.28.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645C78A45;
	Sat,  6 May 2023 01:56:43 -0700 (PDT)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07761823|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0977971-0.00181422-0.900389;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=chenh@yusur.tech;NM=1;PH=DS;RN=12;RT=12;SR=0;TI=SMTPD_---.SZt-zKM_1683363395;
Received: from 10.2.24.238(mailfrom:chenh@yusur.tech fp:SMTPD_---.SZt-zKM_1683363395)
          by smtp.aliyun-inc.com;
          Sat, 06 May 2023 16:56:37 +0800
Message-ID: <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
Date: Sat, 6 May 2023 16:56:35 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum
 MTU' bigger than 1500
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: huangml@yusur.tech, zy@yusur.tech, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 "open list:VIRTIO CORE AND NET DRIVERS"
 <virtualization@lists.linux-foundation.org>,
 "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20230506021529.396812-1-chenh@yusur.tech>
 <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
From: Hao Chen <chenh@yusur.tech>
In-Reply-To: <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



在 2023/5/6 10:50, Xuan Zhuo 写道:
> On Sat,  6 May 2023 10:15:29 +0800, Hao Chen <chenh@yusur.tech> wrote:
>> When VIRTIO_NET_F_MTU(3) Device maximum MTU reporting is supported.
>> If offered by the device, device advises driver about the value of its
>> maximum MTU. If negotiated, the driver uses mtu as the maximum
>> MTU value. But there the driver also uses it as default mtu,
>> some devices may have a maximum MTU greater than 1500, this may
>> cause some large packages to be discarded,
> 
> You mean tx packet?
Yes.
> 
> If yes, I do not think this is the problem of driver.
> 
> Maybe you should give more details about the discard.
> 
In the current code, if the maximum MTU supported by the virtio net 
hardware is 9000, the default MTU of the virtio net driver will also be 
set to 9000. When sending packets through "ping -s 5000", if the peer 
router does not support negotiating a path MTU through ICMP packets, the 
packets will be discarded. If the peer router supports negotiating path 
mtu through ICMP packets, the host side will perform packet sharding 
processing based on the negotiated path mtu, which is generally within 1500.
This is not a bugfix patch, I think setting the default mtu to within 
1500 would be more suitable here.Thanks.
>> so I changed the MTU to a more
>> general 1500 when 'Device maximum MTU' bigger than 1500.
>>
>> Signed-off-by: Hao Chen <chenh@yusur.tech>
>> ---
>>   drivers/net/virtio_net.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 8d8038538fc4..e71c7d1b5f29 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -4040,7 +4040,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>>   			goto free;
>>   		}
>>
>> -		dev->mtu = mtu;
>> +		if (mtu > 1500)
> 
> s/1500/ETH_DATA_LEN/
> 
> Thanks.
> 
>> +			dev->mtu = 1500;
>> +		else
>> +			dev->mtu = mtu;
>>   		dev->max_mtu = mtu;
>>   	}
>>
>> --
>> 2.27.0
>>

