Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33004599ACE
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348559AbiHSLE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348528AbiHSLEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:04:15 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABE9B6D72;
        Fri, 19 Aug 2022 04:04:03 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 84AD210087D60;
        Fri, 19 Aug 2022 19:04:00 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 1330937C83F;
        Fri, 19 Aug 2022 19:04:00 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fCjb5bGfrY6w; Fri, 19 Aug 2022 19:04:00 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id D5BC437C83E;
        Fri, 19 Aug 2022 19:03:59 +0800 (CST)
Date:   Fri, 19 Aug 2022 19:03:59 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma <eperezma@redhat.com>
Cc:     jasowang <jasowang@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1521324274.8446358.1660907039791.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <CAJaqyWeCYHvKShyQu0JEfLi=N+TLXdHQtt-VJR-4eVyU0MzT+w@mail.gmail.com>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-4-qtxuning1999@sjtu.edu.cn> <CAJaqyWeCYHvKShyQu0JEfLi=N+TLXdHQtt-VJR-4eVyU0MzT+w@mail.gmail.com>
Subject: Re: [RFC v2 3/7] vsock: batch buffers in tx
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [113.222.45.197]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: vsock: batch buffers in tx
Thread-Index: pT3n1m/+8XxooxgOVsVDTRQKbP5O4Q==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "eperezma" <eperezma@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> Cc: "jasowang" <jasowang@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin" <mst@redhat.com>, "netdev"
> <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Thursday, August 18, 2022 2:19:29 PM
> Subject: Re: [RFC v2 3/7] vsock: batch buffers in tx

> On Wed, Aug 17, 2022 at 3:58 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>>
>> Vsock uses buffers in order, and for tx driver doesn't have to
>> know the length of the buffer. So we can do a batch for vsock if
>> in order negotiated, only write one used ring for a batch of buffers
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>  drivers/vhost/vsock.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 368330417bde..b0108009c39a 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -500,6 +500,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work
>> *work)
>>         int head, pkts = 0, total_len = 0;
>>         unsigned int out, in;
>>         bool added = false;
>> +       int last_head = -1;
>>
>>         mutex_lock(&vq->mutex);
>>
>> @@ -551,10 +552,16 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work
>> *work)
>>                 else
>>                         virtio_transport_free_pkt(pkt);
>>
>> -               vhost_add_used(vq, head, 0);
>> +               if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER))
>> +                       vhost_add_used(vq, head, 0);
>> +               else
>> +                       last_head = head;
>>                 added = true;
>>         } while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>>
>> +       /* If in order feature negotiaged, we can do a batch to increase
>> performance */
>> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && last_head != -1)
>> +               vhost_add_used(vq, last_head, 0);
> 
> Expanding my previous mail on patch 1, you can also use this in vsock
> tx queue code. This way, no modifications to vhost.c functions are
> needed.
> 
> Thanks!

As replied in patch 1, no modification to vhost is not feasible.

Thanks!

> 
>>  no_more_replies:
>>         if (added)
>>                 vhost_signal(&vsock->dev, vq);
>> --
>> 2.17.1
>>
