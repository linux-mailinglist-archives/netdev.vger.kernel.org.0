Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B6D349644
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhCYQB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:01:59 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:34910 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCYQBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:01:40 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 7F83A774AF;
        Thu, 25 Mar 2021 19:01:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616688091;
        bh=GaY4v6SLTMWQV0TO/GqAJWo5gYlwZP1bauQplvh/hnY=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=ntpbRg4nlFVgOFjRTcmH1LjMSKt8w1JnL008KmxJsgZjhUtWm28BE0Dqq8SdZVb81
         e7qvh4HOoOMytrcO4ufuN58NeV+JfO+85gay4KkbtU5NOYUdzLdTVhTmotWbZqNgAp
         6ilRnefsklDqTuCSuDwNE6NzAO4BBjO/+UazWC6L3Hc3btZnpFW1jNhXHEeCUz4YOh
         WpkJEyCo0wi+oFSh2VZUrcMiCb2gH6YY6htx314y1CX1BcVbf6FQIAS4lhEKKBICgx
         YG6V3gzSpUWSUu9aSGsr1VoKjgADXuIyR44SSG3fQwNYhHRP8Cuz15ev4LfWGf5Oen
         LlMgmn8qazO7A==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 4C9EA7749C;
        Thu, 25 Mar 2021 19:01:30 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 25
 Mar 2021 19:01:28 +0300
Subject: Re: [RFC PATCH v7 04/22] af_vsock: implement SEQPACKET receive loop
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131006.2460058-1-arseny.krasnov@kaspersky.com>
 <20210325093415.mpysybt5vfnsl7fg@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <c38d8987-5813-d160-3266-d6c2eadbd816@kaspersky.com>
Date:   Thu, 25 Mar 2021 19:01:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325093415.mpysybt5vfnsl7fg@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/25/2021 15:37:01
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162675 [Mar 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 438 438 e169a60cee0e977a975a890ed8ef829a2851344a
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/25/2021 15:40:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 25.03.2021 15:18:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/25 14:47:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/25 13:43:00 #16496755
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25.03.2021 12:34, Stefano Garzarella wrote:
> On Tue, Mar 23, 2021 at 04:10:03PM +0300, Arseny Krasnov wrote:
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
>> v6 -> v7:
>> 'seqpacket_get_len' callback now removed, length of message is returned
>>  by 'seqpacket_dequeue' callback.
>>
>> include/net/af_vsock.h   |  4 ++
>> net/vmw_vsock/af_vsock.c | 88 +++++++++++++++++++++++++++++++++++++++-
>> 2 files changed, 91 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index b1c717286993..74ac8a4c4168 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -135,6 +135,10 @@ struct vsock_transport {
>> 	bool (*stream_is_active)(struct vsock_sock *);
>> 	bool (*stream_allow)(u32 cid, u32 port);
>>
>> +	/* SEQ_PACKET. */
>> +	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>> +				 int flags, bool *msg_ready, size_t *record_len);
>> +
> Why not using ssize_t as return value and return the length or a 
> negative value in case of error?
>
> In this way we can remove the 'record_len' parameter.
Ok, i think it is possible
>
>> 	/* Notification. */
>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 0bc661e54262..fa0c37f97330 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1973,6 +1973,89 @@ static int __vsock_stream_recvmsg(struct sock 
>> *sk, struct msghdr *msg,
>> 	return err;
>> }
>>
>> +static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr 
>> *msg,
>> +				     size_t len, int flags)
>> +{
>> +	const struct vsock_transport *transport;
>> +	const struct iovec *orig_iov;
>> +	unsigned long orig_nr_segs;
>> +	bool msg_ready;
>> +	struct vsock_sock *vsk;
>> +	size_t record_len;
>> +	long timeout;
>> +	int err = 0;
>> +	DEFINE_WAIT(wait);
>> +
>> +	vsk = vsock_sk(sk);
>> +	transport = vsk->transport;
>> +
>> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>> +	orig_nr_segs = msg->msg_iter.nr_segs;
>> +	orig_iov = msg->msg_iter.iov;
>> +	msg_ready = false;
>> +	record_len = 0;
>> +
>> +	while (1) {
>> +		err = vsock_wait_data(sk, &wait, timeout, NULL, 0);
>> +
>> +		if (err <= 0) {
>> +			/* In case of any loop break(timeout, signal
>> +			 * interrupt or shutdown), we report user that
>> +			 * nothing was copied.
>> +			 */
>> +			err = 0;
>> +			break;
>> +		}
>> +
>> +		err = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready, &record_len);
>> +
>> +		if (err < 0) {
>> +			if (err == -EAGAIN) {
>> +				iov_iter_init(&msg->msg_iter, READ,
>> +					      orig_iov, orig_nr_segs,
>> +					      len);
>> +				/* Clear 'MSG_EOR' here, because dequeue
>> +				 * callback above set it again if it was
>> +				 * set by sender. This 'MSG_EOR' is from
>> +				 * dropped record.
>> +				 */
>> +				msg->msg_flags &= ~MSG_EOR;
>> +				record_len = 0;
>> +				continue;
>> +			}
>> +
>> +			err = -ENOMEM;
>> +			break;
>> +		}
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
>> +	if (msg_ready) {
> If 'err' is not 0, should we skip this branch?
Ack
>
>> +		/* User sets MSG_TRUNC, so return real length of
>> +		 * packet.
>> +		 */
>> +		if (flags & MSG_TRUNC)
>> +			err = record_len;
>> +		else
>> +			err = len - msg->msg_iter.count;
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
>> @@ -2028,7 +2111,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
