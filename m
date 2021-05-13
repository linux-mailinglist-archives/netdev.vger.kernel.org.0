Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE8C37F9D7
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhEMOml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:42:41 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:16822 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbhEMOmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:42:37 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 222767680C;
        Thu, 13 May 2021 17:41:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620916877;
        bh=8eyOE8BkPdFNsTYf0/6ETb9GDgGGDZJqemFpISKnhFI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=f46iYk8aTi5S5SDoOETgulm6FQExZsfX3ONfTf7fXsLCTXiXTkLrr5kYIJA2jFsqL
         tiC46NN+K8pOQt3fumImYdo4P1l6M/ME3HHaKqmL0YHsv+KWOZDgtuU/JkTnq52oJT
         U4h1iJUuhxwtaN9ujzM6exL9nhLz7aw/boRxQTkoMowrKcnEz//73hwn1WVhf3hwVM
         Kcpj9mmZSA1ddTz9GVaaTz61JxaRpSw4XBnlcZpepsW5v55PIxKVCuJZZ1vwZwwPHW
         bf8oLL2fFfX1GAajmzkIl2B4U/blT+o+itY/EpNC8DR5FJsCzIpbeXRqPE4uehf22u
         UFOXM56VILh6Q==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 25E8B76387;
        Thu, 13 May 2021 17:41:14 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:41:13 +0300
Subject: Re: [RFC PATCH v9 04/19] af_vsock: implement SEQPACKET receive loop
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163317.3431119-1-arseny.krasnov@kaspersky.com>
 <20210513113716.admtjzo5nt2y63qi@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <671fcc57-5288-804a-ac9a-c23a79cf3125@kaspersky.com>
Date:   Thu, 13 May 2021 17:41:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513113716.admtjzo5nt2y63qi@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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


On 13.05.2021 14:37, Stefano Garzarella wrote:
> On Sat, May 08, 2021 at 07:33:14PM +0300, Arseny Krasnov wrote:
>> This adds receive loop for SEQPACKET. It looks like receive loop for
>> STREAM, but there is a little bit difference:
>> 1) It doesn't call notify callbacks.
>> 2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>>   there is no sense for these values in SEQPACKET case.
>> 3) It waits until whole record is received or error is found during
>>   receiving.
>> 4) It processes and sets 'MSG_TRUNC' flag.
>>
>> So to avoid extra conditions for two types of socket inside one loop, two
>> independent functions were created.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v8 -> v9:
>> 1) 'tmp_record_len' renamed to 'fragment_len'.
>> 2) MSG_TRUNC handled in af_vsock.c instead of transport.
>> 3) 'flags' still passed to transport for MSG_PEEK support.
> Ah, right I see, sorry for the wrong suggestion to remove it.
>
>> include/net/af_vsock.h   |  4 +++
>> net/vmw_vsock/af_vsock.c | 72 +++++++++++++++++++++++++++++++++++++++-
>> 2 files changed, 75 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index b1c717286993..5175f5a52ce1 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -135,6 +135,10 @@ struct vsock_transport {
>> 	bool (*stream_is_active)(struct vsock_sock *);
>> 	bool (*stream_allow)(u32 cid, u32 port);
>>
>> +	/* SEQ_PACKET. */
>> +	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>> +				     int flags, bool *msg_ready);
>> +
>> 	/* Notification. */
>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index c4f6bfa1e381..78b9af545ca8 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1974,6 +1974,73 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>> 	return err;
>> }
>>
>> +static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>> +				     size_t len, int flags)
>> +{
>> +	const struct vsock_transport *transport;
>> +	bool msg_ready;
>> +	struct vsock_sock *vsk;
>> +	ssize_t record_len;
>> +	long timeout;
>> +	int err = 0;
>> +	DEFINE_WAIT(wait);
>> +
>> +	vsk = vsock_sk(sk);
>> +	transport = vsk->transport;
>> +
>> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>> +	msg_ready = false;
>> +	record_len = 0;
>> +
>> +	while (1) {
>> +		ssize_t fragment_len;
>> +
>> +		if (vsock_wait_data(sk, &wait, timeout, NULL, 0) <= 0) {
>> +			/* In case of any loop break(timeout, signal
>> +			 * interrupt or shutdown), we report user that
>> +			 * nothing was copied.
>> +			 */
>> +			err = 0;
>> +			break;
>> +		}
>> +
>> +		fragment_len = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);
>> +
> So, IIUC, seqpacket_dequeue() must return the real length,
> and not the bytes copied, right?
>
> I'm not sure virtio_transport_seqpacket_do_dequeue() is doing that.
> I'll post a comment on that patch.
Ok, i'll check it
>
>> +		if (fragment_len < 0) {
>> +			err = -ENOMEM;
>> +			break;
>> +		}
>> +
>> +		record_len += fragment_len;
>> +
>> +		if (msg_ready)
>> +			break;
>> +	}
>> +
>> +	if (sk->sk_err)
>> +		err = -sk->sk_err;
>> +	else if (sk->sk_shutdown & RCV_SHUTDOWN)
>> +		err = 0;
>> +
>> +	if (msg_ready && err == 0) {
>> +		/* User sets MSG_TRUNC, so return real length of
>> +		 * packet.
>> +		 */
>> +		if (flags & MSG_TRUNC)
>> +			err = record_len;
>> +		else
>> +			err = len - msg->msg_iter.count;
> I think is better to use msg_data_left(msg) instead of accessing fields.
Ack
>
>> +
>> +		/* Always set MSG_TRUNC if real length of packet is
>> +		 * bigger than user's buffer.
>> +		 */
>> +		if (record_len > len)
>> +			msg->msg_flags |= MSG_TRUNC;
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> static int
>> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> 			  int flags)
>> @@ -2029,7 +2096,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> 		goto out;
>> 	}
>>
>> -	err = __vsock_stream_recvmsg(sk, msg, len, flags);
>> +	if (sk->sk_type == SOCK_STREAM)
>> +		err = __vsock_stream_recvmsg(sk, msg, len, flags);
>> +	else
>> +		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
>>
>> out:
>> 	release_sock(sk);
>> -- 
>> 2.25.1
>>
>
