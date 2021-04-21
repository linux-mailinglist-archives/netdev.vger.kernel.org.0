Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFD0366E72
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhDUOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:48:52 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:42716 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240756AbhDUOst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 10:48:49 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 8E09E521A47;
        Wed, 21 Apr 2021 17:48:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1619016492;
        bh=x+9RxR3vKP07vYouFMjF6QLuIKPb9SP7CqKKIgJzpuo=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=yLwDFDV8BAsUKrwaWdnPbIqoOi2dJYgzUqItSgOHNN8docs/CJL4M9beg75Ivz3ax
         FGdEh+uiNdQwYLqpFzDNBjzBm05ADMfJzNV4hGFkRqJ2P+HUKtzpYC2q5wPZ3jekZE
         yo50jsPwrTB2Giy/o18AEOmPJl+L79G7rpNz9pY6If+hmD+LLI6d9KoGccM6HHSKfw
         Ep0V1avYCzBi4FkWyT7kcaZ2bXd/LLnC6TDPHWkTRAfycwPjnmFOzzTUty4H2XXLWL
         QcOgkbQboHMeA1Ghqsk7FzzUgddKzfs22WOSI7fZKDgtDZbSEuu+FTZ0A4e2lKfAN0
         57Mms4sJ2U0vg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 4E90E5217A2;
        Wed, 21 Apr 2021 17:48:11 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 21
 Apr 2021 17:47:50 +0300
Subject: Re: [RFC PATCH v8 04/19] af_vsock: implement SEQPACKET receive loop
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124250.3400313-1-arseny.krasnov@kaspersky.com>
 <20210421083732.hxlilatddifcokjx@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <9c391b66-84e4-6ead-55fa-1cf42e1e7306@kaspersky.com>
Date:   Wed, 21 Apr 2021 17:47:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210421083732.hxlilatddifcokjx@steredhat>
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


On 21.04.2021 11:37, Stefano Garzarella wrote:
> On Tue, Apr 13, 2021 at 03:42:47PM +0300, Arseny Krasnov wrote:
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
>> v7 -> v8:
>> - Length of message is now not returned by callback, it returns only
>>   length of data read by each call.
>> - Previous case, when EAGAIN is return and dequeue loop restarted now
>>   removed(in this simplified version we consider that message could not
>>   be corrupted).
>> - MSG_TRUNC in input flags is now handled by callback.
>>
>> include/net/af_vsock.h   |  4 +++
>> net/vmw_vsock/af_vsock.c | 66 +++++++++++++++++++++++++++++++++++++++-
>> 2 files changed, 69 insertions(+), 1 deletion(-)
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
>> index c4f6bfa1e381..d9fb4f9a3063 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1974,6 +1974,67 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
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
>> +		ssize_t tmp_record_len;
> Maybe better a name like `partial_len`, `fragment_len`, or just `read`.
Ack
>
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
>> +		tmp_record_len = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);
> I think we can avoid to pass 'flags' down to the transports.
>
> We can require that seqpacket_dequeue() should always return the real 
> size of the packet received, and then check below if 'MSG_TRUNC' was 
> set...
Ack
>
>> +
>> +		if (tmp_record_len < 0) {
>> +			err = -ENOMEM;
>> +			break;
>> +		}
>> +
>> +		record_len += tmp_record_len;
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
>> +		err = record_len;
>> +
>> +		/* Always set MSG_TRUNC if real length of packet is
>> +		 * bigger than user's buffer.
>> +		 */
> ...here:
> 		if (flags & MSG_TRUNC && record_len > len)
>
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
>> @@ -2029,7 +2090,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
>> -- )
>> 2.25.1
>>
>
