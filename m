Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DEB5B1759
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiIHIlc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Sep 2022 04:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiIHIlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:41:25 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E08112E40;
        Thu,  8 Sep 2022 01:41:22 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 8A1CD1008B392;
        Thu,  8 Sep 2022 16:41:17 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 6D88F37C894;
        Thu,  8 Sep 2022 16:41:17 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 771Iyg8o78vt; Thu,  8 Sep 2022 16:41:17 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 3D69837C893;
        Thu,  8 Sep 2022 16:41:17 +0800 (CST)
Date:   Thu, 8 Sep 2022 16:41:14 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1010358496.165709.1662626474492.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <ff96c12e-95cb-be57-9b5b-2da08b0630c6@redhat.com>
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn> <20220901055434.824-4-qtxuning1999@sjtu.edu.cn> <ff96c12e-95cb-be57-9b5b-2da08b0630c6@redhat.com>
Subject: Re: [RFC v3 3/7] vsock: batch buffers in tx
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.162.206.161]
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - GC104 (Mac)/8.8.15_GA_3928)
Thread-Topic: vsock: batch buffers in tx
Thread-Index: fUZ9bL4X165odfACHKzUbr6LjWRV9Q==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "jasowang" <jasowang@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "eperezma" <eperezma@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael
> Tsirkin" <mst@redhat.com>
> Cc: "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Wednesday, September 7, 2022 12:27:40 PM
> Subject: Re: [RFC v3 3/7] vsock: batch buffers in tx

> ÔÚ 2022/9/1 13:54, Guo Zhi Ð´µÀ:
>> Vsock uses buffers in order, and for tx driver doesn't have to
>> know the length of the buffer. So we can do a batch for vsock if
>> in order negotiated, only write one used ring for a batch of buffers
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/vhost/vsock.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 368330417bde..e08fbbb5439e 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -497,7 +497,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work
>> *work)
>>   	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
>>   						 dev);
>>   	struct virtio_vsock_pkt *pkt;
>> -	int head, pkts = 0, total_len = 0;
>> +	int head, pkts = 0, total_len = 0, add = 0;
>>   	unsigned int out, in;
>>   	bool added = false;
>>   
>> @@ -551,10 +551,18 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work
>> *work)
>>   		else
>>   			virtio_transport_free_pkt(pkt);
>>   
>> -		vhost_add_used(vq, head, 0);
>> +		if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>> +			vhost_add_used(vq, head, 0);
> 
> 
> I'd do this step by step.
> 
> 1) switch to use vhost_add_used_n() for vsock, less copy_to_user()
> better performance
> 2) do in-order on top
> 
> 
LGTM!, I think it is the correct way.

>> +		} else {
>> +			vq->heads[add].id = head;
>> +			vq->heads[add++].len = 0;
> 
> 
> How can we guarantee that we are in the boundary of the heads array?
> 
> Btw in the case of in-order we don't need to record the heads, instead
> we just need to know the head of the last buffer, it reduces the stress
> on the cache.
> 
> Thanks
> 
Yeah, I will change this and only copy last head for in order feature.

Thanks
> 
>> +		}
>>   		added = true;
>>   	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>>   
>> +	/* If in order feature negotiaged, we can do a batch to increase performance
>> */
>> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && added)
>> +		vhost_add_used_n(vq, vq->heads, add);
>>   no_more_replies:
>>   	if (added)
>>   		vhost_signal(&vsock->dev, vq);
