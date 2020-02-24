Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3627F16A670
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgBXMvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:51:13 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:48490 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgBXMvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 07:51:12 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1j6DCV-0005cj-GO; Mon, 24 Feb 2020 12:51:07 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1j6DCT-0007nS-51; Mon, 24 Feb 2020 12:51:07 +0000
Subject: Re: [PATCH v2] virtio: Work around frames incorrectly marked as gso
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org, jasowang@redhat.com,
        eric.dumazet@gmail.com
References: <20200224101912.14074-1-anton.ivanov@cambridgegreys.com>
 <20200224074516-mutt-send-email-mst@kernel.org>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <ca0ca1b6-b453-cba0-adb0-42a9517743e9@cambridgegreys.com>
Date:   Mon, 24 Feb 2020 12:51:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224074516-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.7
X-Spam-Score: -0.7
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/02/2020 12:46, Michael S. Tsirkin wrote:
> On Mon, Feb 24, 2020 at 10:19:12AM +0000, anton.ivanov@cambridgegreys.com wrote:
>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>
>> Some of the locally generated frames marked as GSO which
>> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
>> fragments (data_len = 0) and length significantly shorter
>> than the MTU (752 in my experiments).
>>
>> This is observed on raw sockets reading off vEth interfaces
>> in all 4.x and 5.x kernels I tested.
> 
> A bit more info on how to reproduce couldn't hurt here.

Will do, a v3 will follow shortly.

> 
>>
>> These frames are reported as invalid while they are in fact
>> gso-less frames.
>>
>> This patch marks the vnet header as no-GSO for them instead
>> of reporting it as invalid.
>>
>> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Eric - as you looked at this in the past, would you mind acking please?
> 
>> ---
>>   include/linux/virtio_net.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>> index 0d1fe9297ac6..94fb78c3a2ab 100644
>> --- a/include/linux/virtio_net.h
>> +++ b/include/linux/virtio_net.h
>> @@ -100,8 +100,8 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
>>   {
>>   	memset(hdr, 0, sizeof(*hdr));   /* no info leak */
>>   
>> -	if (skb_is_gso(skb)) {
>> -		struct skb_shared_info *sinfo = skb_shinfo(skb);
>> +	struct skb_shared_info *sinfo = skb_shinfo(skb);

I need to move this a few lines up - the kernel build robot is quite rightfully complaining.

>> +	if (skb_is_gso(skb) && sinfo->gso_type) {
>>   
>>   		/* This is a hint as to how much should be linear. */
>>   		hdr->hdr_len = __cpu_to_virtio16(little_endian,
>> -- 
>> 2.20.1
> 
> 

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
