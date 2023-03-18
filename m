Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1816BFCEE
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 22:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjCRV0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 17:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCRV0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 17:26:30 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828104ECA;
        Sat, 18 Mar 2023 14:26:27 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 39ADF5FD24;
        Sun, 19 Mar 2023 00:26:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679174784;
        bh=dWSa4bwyQemtEean8HgIJ6sjw1ffk6G9m2buRd3i+9I=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
        b=IAYG1oXlYtgV3NLSqotsng9Pno2jOEcHhYv1MbPU7R+EI2Ldrs3olxyfbr9BNpnq/
         jB33Vi5NBjL5pP32V7HPV2t6lWvwYT6upNzEmzRBwMeu8Is97epbynJY/IEzcQE0+8
         pSHYxFF8M6bExF+o+BkIWiwEMFM+Wo2B6KzWmQhbmIokI0jCuKt4Weu4eX6sfEyqI0
         fctHXvCPfxLs0FtbnUgGz56TaPbh3XTmEpWRK31Mg6F9eBoI4PjMCn8boBAf5DPfrF
         KPa+7EIUvX2ZZFKDVnadcE20rXeA/FpJIqquSMx0b27HeTYNmw8m7R0f5jFhbv2/L4
         Qym3NsAlM34YA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 19 Mar 2023 00:26:20 +0300 (MSK)
Message-ID: <64b44879-11ae-b5c5-3a1a-cb51de00c304@sberdevices.ru>
Date:   Sun, 19 Mar 2023 00:23:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1] virtio/vsock: allocate multiple skbuffs on tx
Content-Language: en-US
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru>
 <ZBThOG/nISvqbllq@bullseye>
 <07f4fb07-6a3b-4916-4e55-20ca7a866a8f@sberdevices.ru>
In-Reply-To: <07f4fb07-6a3b-4916-4e55-20ca7a866a8f@sberdevices.ru>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/18 14:21:00 #20969333
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.03.2023 21:01, Arseniy Krasnov wrote:
> 
> 
> On 18.03.2023 00:52, Bobby Eshleman wrote:
>> On Fri, Mar 17, 2023 at 01:38:39PM +0300, Arseniy Krasnov wrote:
>>> This adds small optimization for tx path: instead of allocating single
>>> skbuff on every call to transport, allocate multiple skbuffs until
>>> credit space allows, thus trying to send as much as possible data without
>>> return to af_vsock.c.
>>
>> Hey Arseniy, I really like this optimization. I have a few
>> questions/comments below.
>>
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>>  net/vmw_vsock/virtio_transport_common.c | 45 +++++++++++++++++--------
>>>  1 file changed, 31 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 6564192e7f20..cda587196475 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>  	const struct virtio_transport *t_ops;
>>>  	struct virtio_vsock_sock *vvs;
>>>  	u32 pkt_len = info->pkt_len;
>>> -	struct sk_buff *skb;
>>> +	u32 rest_len;
>>> +	int ret;
>>>  
>>>  	info->type = virtio_transport_get_type(sk_vsock(vsk));
>>>  
>>> @@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>  
>>>  	vvs = vsk->trans;
>>>  
>>> -	/* we can send less than pkt_len bytes */
>>> -	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>>> -		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>>> -
>>>  	/* virtio_transport_get_credit might return less than pkt_len credit */
>>>  	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>>>  
>>> @@ -227,17 +224,37 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>  	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>>>  		return pkt_len;
>>>  
>>> -	skb = virtio_transport_alloc_skb(info, pkt_len,
>>> -					 src_cid, src_port,
>>> -					 dst_cid, dst_port);
>>> -	if (!skb) {
>>> -		virtio_transport_put_credit(vvs, pkt_len);
>>> -		return -ENOMEM;
>>> -	}
>>> +	rest_len = pkt_len;
>>>  
>>> -	virtio_transport_inc_tx_pkt(vvs, skb);
>>> +	do {
>>> +		struct sk_buff *skb;
>>> +		size_t skb_len;
>>> +
>>> +		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>>> +
>>> +		skb = virtio_transport_alloc_skb(info, skb_len,
>>> +						 src_cid, src_port,
>>> +						 dst_cid, dst_port);
>>> +		if (!skb) {
>>> +			ret = -ENOMEM;
>>> +			goto out;
>>> +		}
>>
>> In this case, if a previous round of the loop succeeded with send_pkt(),
>> I think that we may still want to return the number of bytes that have
>> successfully been sent so far?
>>
> Hello! Thanks for review!
> 
> Yes, You are right, seems this patch breaks partial send return value. For example for the
> following iov (suppose each '.iov_len' is 64Kb, e.g. max packet length):
> 
> [0] = { .iov_base = ptr0, .iov_len = len0 },
> [1] = { .iov_base = NULL, .iov_len = len1 },
> [2] = { .iov_base = ptr2, .iov_len = len2 }
> 
> transport callback will send element 0, but NULL iov_base of element 1 will cause tx failure.
> Transport callback returns error (no information about transmitted skbuffs), but element 0 was
> already passed to virtio/vhost path.
> 
> Current logic will return length of element 0 (it will be accounted to return from send syscall),
> then calls transport again with invalid element 1 which triggers error.
> 
> I'm not sure that it is correct (at least in this single patch) to return number of bytes sent,
> because tx loop in af_vsock.c compares length of user's buffer and number of bytes sent to break
> tx loop (or loop is terminated when transport returns error). For above iov, we return length of
> element 0 without length of invalid element 1, but not error (so loop exit condition never won't
> be true). Moreover, with this approach only first failed to tx skbuff will return error. For second,
> third, etc. skbuffs we get only number of bytes.
> 
> I think may be we can use socket's 'sk_err' field here: when tx callback failed to send data(no
> matter it is first byte or last byte of middle byte), it returns number of bytes sent (it will be
> 0 if first skbuff was failed to sent) and sets 'sk_err'. Good thing here is that tx loop in af_vsock.c
> already has check for 'sk_err' value and break loop if error occurred. This way looks like 'errno'
> concept a little bit: transport returns number of bytes, 'sk_err' contains error. So in current
> patch it will look like this: instead of setting 'ret' with error, i set 'sk_err' with error,
> but callback returns number of bytes transmitted.
> 
> May be we need review from some more experienced guy, Stefano Garzarella, what do You think?

Ahhhh, i see, sorry, my misunderstanding. Don't read long text above :) I can return error if nothing
was sent, otherwise return number of bytes. I'll prepare v2.

Thanks, Arseniy
> 
> Thanks, Arseniy
>>>  
>>> -	return t_ops->send_pkt(skb);
>>> +		virtio_transport_inc_tx_pkt(vvs, skb);
>>> +
>>> +		ret = t_ops->send_pkt(skb);
>>> +
>>> +		if (ret < 0)
>>> +			goto out;
>>
>> Ditto here.
>>
>>> +
>>> +		rest_len -= skb_len;
>>> +	} while (rest_len);
>>> +
>>> +	return pkt_len;
>>> +
>>> +out:
>>> +	virtio_transport_put_credit(vvs, rest_len);
>>> +	return ret;
>>>  }
>>>  
>>>  static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>>> -- 
>>> 2.25.1
