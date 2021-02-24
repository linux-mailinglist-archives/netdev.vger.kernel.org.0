Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF98323695
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 06:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbhBXFIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 00:08:40 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:24929 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBXFIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 00:08:37 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 2DDF476246;
        Wed, 24 Feb 2021 08:07:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1614143270;
        bh=ffiR2tRKE4jqGeI3iVzfId3D3oVlMxLBBvNJx+JLL9k=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=KmpWw2SYyXJDjq82IlPubVQgGQRJkRGD07aQCqhHABWc7NeMUGim8ef7vdSpHMzfD
         sruy9H8Zbex4lV3e5auZm4lZO2in2SD5/cOw7LQGBu6ym3DrtPAMG81gG25xVVUW2I
         yUsWZSESTVfNzTNsDrykfxEXo9dXzRy+FMh0DtDau/UfbppBarOPLwt1z3WyATL9yD
         Ksh7EkLnoNS92d7eclcCk+0jSsxSGlo7N/Myg5bf/HamQPNVs5QV6QzoNE24rKg4h/
         +/u5qM/H9EbUXZBVPjQ0Rsj1+pwgY7jDn6UUz7TId7nXXh+SOr/KnT58dNoHa9s+nO
         ZdC1LZXkpZ7EQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id AB98D76279;
        Wed, 24 Feb 2021 08:07:48 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Wed, 24
 Feb 2021 08:07:48 +0300
Subject: Re: [RFC PATCH v5 11/19] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053940.1068164-1-arseny.krasnov@kaspersky.com>
 <20210223091536-mutt-send-email-mst@kernel.org>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <661fd81f-daf5-a3eb-6946-8f4e83d1ee54@kaspersky.com>
Date:   Wed, 24 Feb 2021 08:07:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210223091536-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/06/2021 23:52:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 161679 [Feb 06 2021]
X-KSE-AntiSpam-Info: LuaCore: 422 422 763e61bea9fcfcd94e075081cb96e065bc0509b4
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_c_tr_enc, eight_bit}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2021 23:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 06.02.2021 21:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/24 03:43:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/24 02:14:00 #16328803
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23.02.2021 17:17, Michael S. Tsirkin wrote:
> On Thu, Feb 18, 2021 at 08:39:37AM +0300, Arseny Krasnov wrote:
>> This adds transport callback and it's logic for SEQPACKET dequeue.
>> Callback fetches RW packets from rx queue of socket until whole record
>> is copied(if user's buffer is full, user is not woken up). This is done
>> to not stall sender, because if we wake up user and it leaves syscall,
>> nobody will send credit update for rest of record, and sender will wait
>> for next enter of read syscall at receiver's side. So if user buffer is
>> full, we just send credit update and drop data. If during copy SEQ_BEGIN
>> was found(and not all data was copied), copying is restarted by reset
>> user's iov iterator(previous unfinished data is dropped).
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>>  include/linux/virtio_vsock.h            |  10 +++
>>  include/uapi/linux/virtio_vsock.h       |  16 ++++
>>  net/vmw_vsock/virtio_transport_common.c | 114 ++++++++++++++++++++++++
>>  3 files changed, 140 insertions(+)
>>
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index dc636b727179..003d06ae4a85 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -36,6 +36,11 @@ struct virtio_vsock_sock {
>>  	u32 rx_bytes;
>>  	u32 buf_alloc;
>>  	struct list_head rx_queue;
>> +
>> +	/* For SOCK_SEQPACKET */
>> +	u32 user_read_seq_len;
>> +	u32 user_read_copied;
>> +	u32 curr_rx_msg_cnt;
>
> wrap these in a struct to make it's clearer they
> are related?
Ack
>
>>  };
>>  
>>  struct virtio_vsock_pkt {
>> @@ -80,6 +85,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>  			       struct msghdr *msg,
>>  			       size_t len, int flags);
>>  
>> +int
>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>> +				   struct msghdr *msg,
>> +				   int flags,
>> +				   bool *msg_ready);
>>  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>  s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>  
>> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>> index 1d57ed3d84d2..cf9c165e5cca 100644
>> --- a/include/uapi/linux/virtio_vsock.h
>> +++ b/include/uapi/linux/virtio_vsock.h
>> @@ -63,8 +63,14 @@ struct virtio_vsock_hdr {
>>  	__le32	fwd_cnt;
>>  } __attribute__((packed));
>>  
>> +struct virtio_vsock_seq_hdr {
>> +	__le32  msg_cnt;
>> +	__le32  msg_len;
>> +} __attribute__((packed));
>> +
>>  enum virtio_vsock_type {
>>  	VIRTIO_VSOCK_TYPE_STREAM = 1,
>> +	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
>>  };
>>  
>>  enum virtio_vsock_op {
>> @@ -83,6 +89,11 @@ enum virtio_vsock_op {
>>  	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
>>  	/* Request the peer to send the credit info to us */
>>  	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
>> +
>> +	/* Record begin for SOCK_SEQPACKET */
>> +	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
>> +	/* Record end for SOCK_SEQPACKET */
>> +	VIRTIO_VSOCK_OP_SEQ_END = 9,
>>  };
>>  
>>  /* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
>> @@ -91,4 +102,9 @@ enum virtio_vsock_shutdown {
>>  	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
>>  };
>>  
>> +/* VIRTIO_VSOCK_OP_RW flags values */
>> +enum virtio_vsock_rw {
>> +	VIRTIO_VSOCK_RW_EOR = 1,
>> +};
>> +
>>  #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
> Probably a good idea to also have a feature bit gating
> this functionality.

IIUC this also requires some qemu patch, because in current

implementation of vsock device in qemu, there is no 'set_features'

callback for such device. This callback will handle guest's write

to feature register, by calling vhost kernel backend, where this

bit will be processed by host.


IMHO I'm not sure that SEQPACKET support needs feature

bit - it is just two new ops for virtio vsock protocol, and from point

of view of virtio device it is same as STREAM. May be it is needed

for cases when client tries to connect to server which doesn't support

SEQPACKET, so without bit result will be "Connection reset by peer",

and with such bit client will know that server doesn't support it and

'socket(SOCK_SEQPACKET)' will return error?

>
