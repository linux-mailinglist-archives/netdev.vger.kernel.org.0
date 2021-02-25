Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885AB325442
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhBYRBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:01:51 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:29924 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhBYRBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 12:01:31 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 29EFE7807C;
        Thu, 25 Feb 2021 20:00:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1614272441;
        bh=/aucgc2DX9LFwaXqoZnOT5lfaPvZGZ8Tlz/h3Ffm0VE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=2gFk2LRDxXqLQWLKSmmkiIE23AqJBf/vQ5PCHFqnKARjnvpaFjVJudVhstY/SaftM
         hk8qat394sBm090YSJagErX62b8plqplXGEsx/RLtiw5tC6Iaw8Qqy+d4BtF6Qf9Qu
         KKkVsUeHCHEOFuqbQLcERGb7HzXMkqJF12ktZEh8QRePCyyDBbeKsRVZcSQKdYtdot
         wE0F9VnRcpsf7iN/UxTlyQ4WtR+1YgElRmrK1XFChPf5A5ai7dKF/OheDhI3IEZ4Lp
         L0yumn2eeLK3xVpFqSUQhRwsyvyruUMfm2nPvPLCQcaWaD/6ATDZoLTwMTWCKx+g8o
         dAKBsc4D13QMg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 1682B7807E;
        Thu, 25 Feb 2021 20:00:40 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 25
 Feb 2021 20:00:39 +0300
Subject: Re: [RFC PATCH v5 04/19] af_vsock: implement SEQPACKET receive loop
To:     Jorgen Hansen <jhansen@vmware.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
 <20210218053719.1067237-1-arseny.krasnov@kaspersky.com>
 <125822F8-C6D5-4892-BD32-A7189578B3DE@vmware.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <3763ad62-8a03-8dba-25f3-82c1a83e0182@kaspersky.com>
Date:   Thu, 25 Feb 2021 20:00:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <125822F8-C6D5-4892-BD32-A7189578B3DE@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 02/25/2021 16:43:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162085 [Feb 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 429 429 b8387e624a66feb695608edbad2d54079eb31df3
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {Macro_CONTENT_PLAIN}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TEXT_PLAIN_OR_HTML}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_CHARSET_UTF_8}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_JAPANESE}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_RUS}
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
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/25/2021 16:47:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 25.02.2021 13:47:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/25 15:26:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/25 15:16:00 #16299632
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25.02.2021 19:27, Jorgen Hansen wrote:
> On 18 Feb 2021, at 06:37, Arseny Krasnov <arseny.krasnov@kaspersky.com> wrote:
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
>> include/net/af_vsock.h   |  5 +++
>> net/vmw_vsock/af_vsock.c | 97 +++++++++++++++++++++++++++++++++++++++-
>> 2 files changed, 101 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index b1c717286993..01563338cc03 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -135,6 +135,11 @@ struct vsock_transport {
>> 	bool (*stream_is_active)(struct vsock_sock *);
>> 	bool (*stream_allow)(u32 cid, u32 port);
>>
>> +	/* SEQ_PACKET. */
>> +	size_t (*seqpacket_seq_get_len)(struct vsock_sock *vsk);
>> +	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>> +				     int flags, bool *msg_ready);
>> +
>> 	/* Notification. */
>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index d277dc1cdbdf..b754927a556a 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1972,6 +1972,98 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>> 	return err;
>> }
>>
>> +static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
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
>> +		if (record_len == 0) {
>> +			record_len =
>> +				transport->seqpacket_seq_get_len(vsk);
>> +
>> +			if (record_len == 0)
>> +				continue;
>> +		}
>> +
>> +		err = transport->seqpacket_dequeue(vsk, msg,
>> +					flags, &msg_ready);
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
> So a question for my understanding of the flow here. SOCK_SEQPACKET is reliable, so
> what does it mean to drop the record? Is the transport supposed to roll back to the
> beginning of the current record? If the incoming data in the transport doesn’t follow
> the protocol, and packets need to be dropped, shouldn’t the socket be reset or similar?
> Maybe there is potential for simplifying the flow if that is the case.

As vhost transport could drop some packets(for example when kmalloc failed),

in this case user will see part of record(when RW packet was dropped), or it will

be impossible to distinguish two records(when END of first and BEGIN of second

were missed). So in this case user continues to sleep and such orphaned packets

will be dropped.


Yes, it will simplify logic a lot, if i'll just send connection reset when invalid

sequence of packets were detected.

>
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
>> @@ -2027,7 +2119,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
