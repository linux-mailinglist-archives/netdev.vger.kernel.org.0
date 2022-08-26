Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30AA5A1F54
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbiHZDLk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Aug 2022 23:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiHZDLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:11:06 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4445642CC;
        Thu, 25 Aug 2022 20:11:04 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id D57AF1008B388;
        Fri, 26 Aug 2022 11:11:02 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id C7C2C37C894;
        Fri, 26 Aug 2022 11:11:02 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fYuVOdzGwl62; Fri, 26 Aug 2022 11:11:02 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 9E48B37C893;
        Fri, 26 Aug 2022 11:11:02 +0800 (CST)
Date:   Fri, 26 Aug 2022 11:11:02 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1901174467.9092625.1661483462548.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <13f97c76-bc8b-1509-d854-89d0d62138fa@redhat.com>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-4-qtxuning1999@sjtu.edu.cn> <13f97c76-bc8b-1509-d854-89d0d62138fa@redhat.com>
Subject: Re: [RFC v2 3/7] vsock: batch buffers in tx
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.166.246.247]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC104 (Mac)/8.8.15_GA_3928)
Thread-Topic: vsock: batch buffers in tx
Thread-Index: 8SBCN+82rZHA3Ql/zv7BqGe0x2TrwA==
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
> Sent: Thursday, August 25, 2022 3:08:58 PM
> Subject: Re: [RFC v2 3/7] vsock: batch buffers in tx

> ÔÚ 2022/8/17 21:57, Guo Zhi Ð´µÀ:
>> Vsock uses buffers in order, and for tx driver doesn't have to
>> know the length of the buffer. So we can do a batch for vsock if
>> in order negotiated, only write one used ring for a batch of buffers
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/vhost/vsock.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 368330417bde..b0108009c39a 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -500,6 +500,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work
>> *work)
>>   	int head, pkts = 0, total_len = 0;
>>   	unsigned int out, in;
>>   	bool added = false;
>> +	int last_head = -1;
>>   
>>   	mutex_lock(&vq->mutex);
>>   
>> @@ -551,10 +552,16 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work
>> *work)
>>   		else
>>   			virtio_transport_free_pkt(pkt);
>>   
>> -		vhost_add_used(vq, head, 0);
>> +		if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER))
>> +			vhost_add_used(vq, head, 0);
>> +		else
>> +			last_head = head;
>>   		added = true;
>>   	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>>   
>> +	/* If in order feature negotiaged, we can do a batch to increase performance
>> */
>> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && last_head != -1)
>> +		vhost_add_used(vq, last_head, 0);
> 
> 
> I may miss something but spec said "The device then skips forward in the
> ring according to the size of the batch. ".
> 
> I don't see how it is done here.
> 
> Thanks
> 

It can skip them in __vhost_add_used_n if _F_IN_ORDER is negotiated.
last_used_idx will be added by size of the batch.

> 
>>   no_more_replies:
>>   	if (added)
>>   		vhost_signal(&vsock->dev, vq);
