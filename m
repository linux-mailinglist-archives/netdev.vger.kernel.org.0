Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52F437F9E6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhEMOpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:45:07 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:15055 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbhEMOog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:44:36 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 254A4521A73;
        Thu, 13 May 2021 17:43:23 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620917003;
        bh=/8a5Z0p9nQST8jO6KKjMcK7hj60wbV1FUvRA+mUhtHE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=zc30FkJYX0cLOGLrAcg4eOZoBecRbaHg1RLWL2f3YhN06+H9wwQ8wvmW8P+dtEMtE
         Wx7/1ZQbg47jv4tSTvFI78jdp43UxmkNcox3J/VoMTFkVak7lP1jtCgPSwky95tWOp
         RxyPZ1q+GcthMkJr0NqTMu2Qhbu4q4Iaz4E+YWsQyFywN8Zq5wOd2IwstQi3KdVVRv
         XkPa5tQLQ3la1CRJe9LQPqmM7bMJaf6aEI2qvp+12d/FZDQjaV/eYseGgy5ga7DNzv
         Xzu0RhPT+PfMQYhPo3J2UHPFLX7vQDgkBxJ2bUfc/IyRcpZOg1aZq9tW/nqKW1CkzO
         ipQnOUbig1Vdg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id D4F245219BA;
        Thu, 13 May 2021 17:43:22 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:43:22 +0300
Subject: Re: [RFC PATCH v9 12/19] virtio/vsock: add SEQPACKET receive logic
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163544.3432132-1-arseny.krasnov@kaspersky.com>
 <20210513121400.7u7kectkxwame76b@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <e1fbcc54-9c5a-d23a-b5c8-02f1ec5b5065@kaspersky.com>
Date:   Thu, 13 May 2021 17:43:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513121400.7u7kectkxwame76b@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/13/2021 14:30:02
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163644 [May 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/13/2021 14:33:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.05.2021 13:39:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/13 13:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/13 10:44:00 #16575454
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13.05.2021 15:14, Stefano Garzarella wrote:
> On Sat, May 08, 2021 at 07:35:40PM +0300, Arseny Krasnov wrote:
>> This modifies current receive logic for SEQPACKET support:
>> 1) Inserts 'RW' packet to socket's rx queue, but without merging with
>>   buffer of last packet in queue.
> This is not true anymore, right?
>
>> 2) Performs check for packet and socket types on receive(if mismatch,
>>   then reset connection).
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Also this patch is changed :-)
>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 28 +++++++++++++++++++++++--
>> 1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index f649a21dd23b..7fea0a2192f7 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -165,6 +165,14 @@ void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
>>
>> +static u16 virtio_transport_get_type(struct sock *sk)
>> +{
>> +	if (sk->sk_type == SOCK_STREAM)
>> +		return VIRTIO_VSOCK_TYPE_STREAM;
>> +	else
>> +		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>> +}
>> +
>> /* This function can only be used on connecting/connected sockets,
>>  * since a socket assigned to a transport is required.
>>  *
>> @@ -980,11 +988,15 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>> 		/* If there is space in the last packet queued, we copy the
>> 		 * new packet in its buffer.
>> 		 */
>> -		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>> +		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
>> +		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
> Maybe we should update the comment above.
>
>> 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
>> 			       pkt->len);
>> 			last_pkt->len += pkt->len;
>> 			free_pkt = true;
>> +
>> +			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>> +				last_pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
> What about doing the following in any case?
>
> 			last_pkt->hdr.flags |= pkt->hdr.flags;
Ack
>
>> 			goto out;
>> 		}
>> 	}
>
