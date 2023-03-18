Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8136BFC17
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 19:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCRSFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 14:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCRSFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 14:05:16 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7156629E30;
        Sat, 18 Mar 2023 11:05:14 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id E55A45FD02;
        Sat, 18 Mar 2023 21:05:11 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679162711;
        bh=RK17QzVXykYBnYoqQh++O3MjjBZp9+6b1s3viHZyeFA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=c+c4Lo7vsROAfqJod5stuKa05wHrrpH2/2JCMUJVp1rr/dh30rqmChFPY6hKPB4R0
         hbfK/2vclR8+KyVNNg/9uVc53O8x19oiBbgNEn3ulzAnV2ru6Z4vL18wa+y+aPlfHd
         JmTuHNMwzqkZ0VhAdkY1u4eKSBtyhJ/DqIQo+WXSTgGmcDBcKUXAuG3L705Ryz8jUX
         jXwWq8SqZl5zN8LHnFiWA+S6bkC/AAPa/dFozWwUC2t4yKO9p3NBWkI3kIBEiaVY22
         D8IeUR+xDD2EyYrjiggPVoldKUD1KjsTWUaMtubI7Hbo2EOaqTDC0iWVk9mIxqKiao
         ijAZOUMw/Gmpg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat, 18 Mar 2023 21:05:07 +0300 (MSK)
Message-ID: <07f4fb07-6a3b-4916-4e55-20ca7a866a8f@sberdevices.ru>
Date:   Sat, 18 Mar 2023 21:01:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1] virtio/vsock: allocate multiple skbuffs on tx
Content-Language: en-US
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
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <ZBThOG/nISvqbllq@bullseye>
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



On 18.03.2023 00:52, Bobby Eshleman wrote:
> On Fri, Mar 17, 2023 at 01:38:39PM +0300, Arseniy Krasnov wrote:
>> This adds small optimization for tx path: instead of allocating single
>> skbuff on every call to transport, allocate multiple skbuffs until
>> credit space allows, thus trying to send as much as possible data without
>> return to af_vsock.c.
> 
> Hey Arseniy, I really like this optimization. I have a few
> questions/comments below.
> 
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>>  net/vmw_vsock/virtio_transport_common.c | 45 +++++++++++++++++--------
>>  1 file changed, 31 insertions(+), 14 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 6564192e7f20..cda587196475 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>  	const struct virtio_transport *t_ops;
>>  	struct virtio_vsock_sock *vvs;
>>  	u32 pkt_len = info->pkt_len;
>> -	struct sk_buff *skb;
>> +	u32 rest_len;
>> +	int ret;
>>  
>>  	info->type = virtio_transport_get_type(sk_vsock(vsk));
>>  
>> @@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>  
>>  	vvs = vsk->trans;
>>  
>> -	/* we can send less than pkt_len bytes */
>> -	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>> -		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>> -
>>  	/* virtio_transport_get_credit might return less than pkt_len credit */
>>  	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>>  
>> @@ -227,17 +224,37 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>  	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>>  		return pkt_len;
>>  
>> -	skb = virtio_transport_alloc_skb(info, pkt_len,
>> -					 src_cid, src_port,
>> -					 dst_cid, dst_port);
>> -	if (!skb) {
>> -		virtio_transport_put_credit(vvs, pkt_len);
>> -		return -ENOMEM;
>> -	}
>> +	rest_len = pkt_len;
>>  
>> -	virtio_transport_inc_tx_pkt(vvs, skb);
>> +	do {
>> +		struct sk_buff *skb;
>> +		size_t skb_len;
>> +
>> +		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>> +
>> +		skb = virtio_transport_alloc_skb(info, skb_len,
>> +						 src_cid, src_port,
>> +						 dst_cid, dst_port);
>> +		if (!skb) {
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
> 
> In this case, if a previous round of the loop succeeded with send_pkt(),
> I think that we may still want to return the number of bytes that have
> successfully been sent so far?
> 
Hello! Thanks for review!

Yes, You are right, seems this patch breaks partial send return value. For example for the
following iov (suppose each '.iov_len' is 64Kb, e.g. max packet length):

[0] = { .iov_base = ptr0, .iov_len = len0 },
[1] = { .iov_base = NULL, .iov_len = len1 },
[2] = { .iov_base = ptr2, .iov_len = len2 }

transport callback will send element 0, but NULL iov_base of element 1 will cause tx failure.
Transport callback returns error (no information about transmitted skbuffs), but element 0 was
already passed to virtio/vhost path.

Current logic will return length of element 0 (it will be accounted to return from send syscall),
then calls transport again with invalid element 1 which triggers error.

I'm not sure that it is correct (at least in this single patch) to return number of bytes sent,
because tx loop in af_vsock.c compares length of user's buffer and number of bytes sent to break
tx loop (or loop is terminated when transport returns error). For above iov, we return length of
element 0 without length of invalid element 1, but not error (so loop exit condition never won't
be true). Moreover, with this approach only first failed to tx skbuff will return error. For second,
third, etc. skbuffs we get only number of bytes.

I think may be we can use socket's 'sk_err' field here: when tx callback failed to send data(no
matter it is first byte or last byte of middle byte), it returns number of bytes sent (it will be
0 if first skbuff was failed to sent) and sets 'sk_err'. Good thing here is that tx loop in af_vsock.c
already has check for 'sk_err' value and break loop if error occurred. This way looks like 'errno'
concept a little bit: transport returns number of bytes, 'sk_err' contains error. So in current
patch it will look like this: instead of setting 'ret' with error, i set 'sk_err' with error,
but callback returns number of bytes transmitted.

May be we need review from some more experienced guy, Stefano Garzarella, what do You think?

Thanks, Arseniy
>>  
>> -	return t_ops->send_pkt(skb);
>> +		virtio_transport_inc_tx_pkt(vvs, skb);
>> +
>> +		ret = t_ops->send_pkt(skb);
>> +
>> +		if (ret < 0)
>> +			goto out;
> 
> Ditto here.
> 
>> +
>> +		rest_len -= skb_len;
>> +	} while (rest_len);
>> +
>> +	return pkt_len;
>> +
>> +out:
>> +	virtio_transport_put_credit(vvs, rest_len);
>> +	return ret;
>>  }
>>  
>>  static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>> -- 
>> 2.25.1
