Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACED1326C50
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 10:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhB0I7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 03:59:35 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:42665 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhB0I7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 03:59:31 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 8E90776A96;
        Sat, 27 Feb 2021 11:58:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1614416324;
        bh=AVyFfmfJoAQmTuiJpqTyV2TE09MQjIK5uGscXfrqD4s=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=rGafInjklV1aAsgwillOLm+5l2hYxhLZdAU19+xKPvWuXoL5hQiEFXzXzNLFwZLvu
         v8C8HqRWQ9WAA5Nib2h2xf0cEJKK1NP44YP0hSWYHWC4yssYAyepQzRkzv/cNYulIy
         yFrlt+EMB/pWtiw7fNumQ/0bw3nuZmiHlscmQTi+eDSnUb//NNdTaPpqOBqOifoZE7
         e2aW7FPZOPpz/gY2cSPok0s1/wPYBzI1MntDqcm3nB1EFnQbuPfY7T61APpLI+Wpvc
         WSe9XgCur5wHaiOJ1AbHZCwfGduMv0JlwfzdaBoRGwbNMA0lgaVzavty2NOQyLT1Vb
         ccxWQ2WGCNafA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 80EA776429;
        Sat, 27 Feb 2021 11:58:43 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sat, 27
 Feb 2021 11:58:42 +0300
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
 <661fd81f-daf5-a3eb-6946-8f4e83d1ee54@kaspersky.com>
 <20210224002315-mutt-send-email-mst@kernel.org>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <7d324a9b-f918-6929-6db8-52637909e344@kaspersky.com>
Date:   Sat, 27 Feb 2021 11:58:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210224002315-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 02/27/2021 08:42:41
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162122 [Feb 27 2021]
X-KSE-AntiSpam-Info: LuaCore: 429 429 b8387e624a66feb695608edbad2d54079eb31df3
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_c_tr_enc, eight_bit}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {Macro_CONTENT_PLAIN}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TEXT_PLAIN_OR_HTML}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_8_BIT_WITH_7_BIT_C_TRANSFER_ENCODING}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_JAPANESE}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_RUS}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_INCORRECT_BIT_FOR_C_TRANSFER_ENCODING}
X-KSE-AntiSpam-Info: {Macro_DATE_MOSCOW}
X-KSE-AntiSpam-Info: {Macro_FROM_DOUBLE_ENG_NAME}
X-KSE-AntiSpam-Info: {Macro_FROM_LOWCAPS_DOUBLE_ENG_NAME_IN_EMAIL}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RU}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RUS_CHARSET}
X-KSE-AntiSpam-Info: {Macro_FROM_REAL_NAME_MATCHES_ALL_USERNAME_PROB}
X-KSE-AntiSpam-Info: {Macro_HEADERS_NOT_LIST}
X-KSE-AntiSpam-Info: {Macro_MAILER_THUNDERBIRD}
X-KSE-AntiSpam-Info: {Macro_MISC_X_PRIORITY_MISSED}
X-KSE-AntiSpam-Info: {Macro_MSGID_LOWHEX_8_4_4_4_12}
X-KSE-AntiSpam-Info: {Macro_NO_DKIM}
X-KSE-AntiSpam-Info: {Macro_REPLY_TO_MISSED}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_AT_LEAST_2_WORDS}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_ENG_UPPERCASE_BEGINNING}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_LONG_TEXT}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_WITH_FWD_OR_RE}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/27/2021 08:45:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 27.02.2021 7:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/27 07:07:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/27 03:18:00 #16291868
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24.02.2021 09:41, Michael S. Tsirkin wrote:
> On Wed, Feb 24, 2021 at 08:07:48AM +0300, Arseny Krasnov wrote:
>> On 23.02.2021 17:17, Michael S. Tsirkin wrote:
>>> On Thu, Feb 18, 2021 at 08:39:37AM +0300, Arseny Krasnov wrote:
>>>> This adds transport callback and it's logic for SEQPACKET dequeue.
>>>> Callback fetches RW packets from rx queue of socket until whole record
>>>> is copied(if user's buffer is full, user is not woken up). This is done
>>>> to not stall sender, because if we wake up user and it leaves syscall,
>>>> nobody will send credit update for rest of record, and sender will wait
>>>> for next enter of read syscall at receiver's side. So if user buffer is
>>>> full, we just send credit update and drop data. If during copy SEQ_BEGIN
>>>> was found(and not all data was copied), copying is restarted by reset
>>>> user's iov iterator(previous unfinished data is dropped).
>>>>
>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>> ---
>>>>  include/linux/virtio_vsock.h            |  10 +++
>>>>  include/uapi/linux/virtio_vsock.h       |  16 ++++
>>>>  net/vmw_vsock/virtio_transport_common.c | 114 ++++++++++++++++++++++++
>>>>  3 files changed, 140 insertions(+)
>>>>
>>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>>> index dc636b727179..003d06ae4a85 100644
>>>> --- a/include/linux/virtio_vsock.h
>>>> +++ b/include/linux/virtio_vsock.h
>>>> @@ -36,6 +36,11 @@ struct virtio_vsock_sock {
>>>>  	u32 rx_bytes;
>>>>  	u32 buf_alloc;
>>>>  	struct list_head rx_queue;
>>>> +
>>>> +	/* For SOCK_SEQPACKET */
>>>> +	u32 user_read_seq_len;
>>>> +	u32 user_read_copied;
>>>> +	u32 curr_rx_msg_cnt;
>>> wrap these in a struct to make it's clearer they
>>> are related?
>> Ack
>>>>  };
>>>>  
>>>>  struct virtio_vsock_pkt {
>>>> @@ -80,6 +85,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>>>>  			       struct msghdr *msg,
>>>>  			       size_t len, int flags);
>>>>  
>>>> +int
>>>> +virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>>> +				   struct msghdr *msg,
>>>> +				   int flags,
>>>> +				   bool *msg_ready);
>>>>  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
>>>>  s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>>>>  
>>>> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>>>> index 1d57ed3d84d2..cf9c165e5cca 100644
>>>> --- a/include/uapi/linux/virtio_vsock.h
>>>> +++ b/include/uapi/linux/virtio_vsock.h
>>>> @@ -63,8 +63,14 @@ struct virtio_vsock_hdr {
>>>>  	__le32	fwd_cnt;
>>>>  } __attribute__((packed));
>>>>  
>>>> +struct virtio_vsock_seq_hdr {
>>>> +	__le32  msg_cnt;
>>>> +	__le32  msg_len;
>>>> +} __attribute__((packed));
>>>> +
>>>>  enum virtio_vsock_type {
>>>>  	VIRTIO_VSOCK_TYPE_STREAM = 1,
>>>> +	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
>>>>  };
>>>>  
>>>>  enum virtio_vsock_op {
>>>> @@ -83,6 +89,11 @@ enum virtio_vsock_op {
>>>>  	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
>>>>  	/* Request the peer to send the credit info to us */
>>>>  	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
>>>> +
>>>> +	/* Record begin for SOCK_SEQPACKET */
>>>> +	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
>>>> +	/* Record end for SOCK_SEQPACKET */
>>>> +	VIRTIO_VSOCK_OP_SEQ_END = 9,
>>>>  };
>>>>  
>>>>  /* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
>>>> @@ -91,4 +102,9 @@ enum virtio_vsock_shutdown {
>>>>  	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
>>>>  };
>>>>  
>>>> +/* VIRTIO_VSOCK_OP_RW flags values */
>>>> +enum virtio_vsock_rw {
>>>> +	VIRTIO_VSOCK_RW_EOR = 1,
>>>> +};
>>>> +
>>>>  #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>>> Probably a good idea to also have a feature bit gating
>>> this functionality.
>> IIUC this also requires some qemu patch, because in current
>>
>> implementation of vsock device in qemu, there is no 'set_features'
>>
>> callback for such device. This callback will handle guest's write
>>
>> to feature register, by calling vhost kernel backend, where this
>>
>> bit will be processed by host.
> Well patching userspace to make use of a kernel feature
> is par for the course, isn't it?
>
>> IMHO I'm not sure that SEQPACKET support needs feature
>>
>> bit - it is just two new ops for virtio vsock protocol, and from point
>>
>> of view of virtio device it is same as STREAM. May be it is needed
>>
>> for cases when client tries to connect to server which doesn't support
>>
>> SEQPACKET, so without bit result will be "Connection reset by peer",
>>
>> and with such bit client will know that server doesn't support it and
>>
>> 'socket(SOCK_SEQPACKET)' will return error?
> Yes, a better error handling would be one reason to do it like this.

May be it will be better to add special flag to OP_RST. When someone

tries to connect to server which doesn't support such socket type(seqpacket

or dgram), connection reset is sent. This reset carries special flag which

indicates, that such socket type is not supported. Thus client will distinguish

cases when port listener is missed and socket type is not supported.


It will be easy to implement and qemu patch not needed.

>
