Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854A6366E7C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243661AbhDUOvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:51:07 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:26297 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbhDUOvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 10:51:06 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 8BEC475E79;
        Wed, 21 Apr 2021 17:50:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1619016631;
        bh=L1DdxYJL/E28deui1V8GgdZVffxo8Xh2hzFRTtPCYvo=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=54dbnBkG+e/oqgHhwDN8W3lRg3PHO/kSZt3tbMguq2hQtWUH0kx/K9QjU3oM9dqfB
         e1y4snj/esV0Iv8eo7+c4CoVGYP3WnJDKlKExO7ZRp0CxJgRf/ouqf966PeKDOjRbv
         GKrM5tn5BkHOoxWyPWZAdXnSBzejB+cgGU/cxtWtII0GFtpv06eE2KL9Av9WUVYCXj
         6dSMGmmRXeD9ZFJ4YAoJrSAuPJE2T9UWY1orqGyYXt7Q8Ruq0LmnRlZcP2MjnEmofv
         Rcdv7w+ezcHosIPNs1Ki5CRMsyZYh3ZV+fzChHxV+/9HLYZ/Q7dZo7a+7+dWp1Bayd
         TZSaHw5OARgEw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 543D575D7A;
        Wed, 21 Apr 2021 17:50:31 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 21
 Apr 2021 17:50:30 +0300
Subject: Re: [RFC PATCH v8 13/19] virtio/vsock: rest of SOCK_SEQPACKET support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        stsp <stsp2@yandex.ru>, Krasnov Arseniy <oxffffaa@gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124528.3404287-1-arseny.krasnov@kaspersky.com>
 <CAGxU2F6A3-pY5We-pC7-k-3v-tOdKnFvHEAs7eGo4bHnD=sM5Q@mail.gmail.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <ef33f997-3ba0-0367-e943-16bf832d2859@kaspersky.com>
Date:   Wed, 21 Apr 2021 17:50:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F6A3-pY5We-pC7-k-3v-tOdKnFvHEAs7eGo4bHnD=sM5Q@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/21/2021 14:29:29
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163270 [Apr 21 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/21/2021 14:32:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 21.04.2021 11:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/21 13:40:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/21 11:31:00 #16604789
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21.04.2021 12:12, Stefano Garzarella wrote:
> On Tue, Apr 13, 2021 at 03:45:25PM +0300, Arseny Krasnov wrote:
>> This adds rest of logic for SEQPACKET:
>> 1) Send SHUTDOWN on socket close for SEQPACKET type.
>> 2) Set SEQPACKET packet type during send.
>> 3) 'seqpacket_allow' flag to virtio transport.
>> 4) Set 'VIRTIO_VSOCK_SEQ_EOR' bit in flags for last
>>   packet of message.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v7 -> v8:
>> - MSG_EOR handling is removed, i didn't found exact description about
>>   how it works in POSIX.
>> - SEQ_BEGIN, SEQ_END, etc. now removed.
>>
>> include/linux/virtio_vsock.h            |  6 ++++++
>> net/vmw_vsock/virtio_transport_common.c | 16 ++++++++++++++--
>> 2 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index 02acf6e9ae04..f00a01bfdd7e 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -68,6 +68,8 @@ struct virtio_transport {
>>
>>       /* Takes ownership of the packet */
>>       int (*send_pkt)(struct virtio_vsock_pkt *pkt);
>> +
>> +      bool seqpacket_allow;
>> };
>>
>> ssize_t
>> @@ -80,6 +82,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>                              struct msghdr *msg,
>>                              size_t len, int flags);
>>
>> +int
>> +virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>> +                                 struct msghdr *msg,
>> +                                 size_t len);
>> ssize_t
>> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>                                  struct msghdr *msg,
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 572869fef832..4c5b63601308 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -74,6 +74,9 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>>               err = memcpy_from_msg(pkt->buf, info->msg, len);
>>               if (err)
>>                       goto out;
>> +
>> +              if (info->msg->msg_iter.count == 0)
>> +                      pkt->hdr.flags |= VIRTIO_VSOCK_SEQ_EOR;
> We should set the flag in info->flags and assign it using cpu_to_le32() 
> or just the following:
> 			pkt->hdr.flags = cpu_to_le32(info->flags |
> 						VIRTIO_VSOCK_SEQ_EOR);
Ack
>
>
>>       }
>>
>>       trace_virtio_transport_alloc_pkt(src_cid, src_port,
>> @@ -187,7 +190,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>       struct virtio_vsock_pkt *pkt;
>>       u32 pkt_len = info->pkt_len;
>>
>> -      info->type = VIRTIO_VSOCK_TYPE_STREAM;
>> +      info->type = virtio_transport_get_type(sk_vsock(vsk));
>>
>>       t_ops = virtio_transport_get_ops(vsk);
>>       if (unlikely(!t_ops))
>> @@ -486,6 +489,15 @@ virtio_transport_seqpacket_dequeue(struct 
>> vsock_sock *vsk,
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>>
>> +int
>> +virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>> +                                 struct msghdr *msg,
>> +                                 size_t len)
>> +{
>> +      return virtio_transport_stream_enqueue(vsk, msg, len);
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
>> +
>> int
>> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>                              struct msghdr *msg,
>> @@ -905,7 +917,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
>>       struct sock *sk = &vsk->sk;
>>       bool remove_sock = true;
>>
>> -      if (sk->sk_type == SOCK_STREAM)
>> +      if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
>>               remove_sock = virtio_transport_close(vsk);
>>
>>       list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
>> --
>> 2.25.1
>>
>
