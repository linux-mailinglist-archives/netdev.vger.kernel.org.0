Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDE0325448
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhBYRDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:03:43 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:54102 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbhBYRCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 12:02:39 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id B3D4C5212AF;
        Thu, 25 Feb 2021 20:01:27 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1614272487;
        bh=wNLCnLl7TigvkUHtMRwfFUZlMnTi162r6I3dUu9xC84=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=bKJ99QjXYpro2myiW32G284F2Fe9fC+dB/gliBcHponXIqAIhyQTgdvRvc/OeDXtc
         aQtyR2Fm08rIzyorubIsXbwQSY+YBqHTFY2QpQnTB8G3EfQJibxTHMdoVk02AkBkq2
         tt+E87QVESUMnD14vF1gzA5cBJaStubVdvPMPlgsw34TeoWJmwlUkXj6C8e9287WGg
         CAoA8escDAmCpYEnTopDGxQyC8hdkpoIz3rA6ej08gu+HempbeRjSFY1zMFivoJANF
         zMgPh3DdJQoQMWnPHcfGbuUTtIHNtzynQ3yZYgt5fvN8Rafh+TTNU1l7dpHTiKPPtL
         oYthnc8N4OIcA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id C4B5C5210C2;
        Thu, 25 Feb 2021 20:01:26 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 25
 Feb 2021 20:01:25 +0300
Subject: Re: [RFC PATCH v5 02/19] af_vsock: separate wait data loop
To:     Jorgen Hansen <jhansen@vmware.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053637.1066959-1-arseny.krasnov@kaspersky.com>
 <E5526501-3A87-4349-8D7F-61782AA1F513@vmware.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <932445e9-ba6c-9063-60dd-5c23ee1117eb@kaspersky.com>
Date:   Thu, 25 Feb 2021 20:01:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <E5526501-3A87-4349-8D7F-61782AA1F513@vmware.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
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
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
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
X-KSE-Antivirus-Info: Clean, bases: 25.02.2021 15:16:00
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


On 25.02.2021 17:24, Jorgen Hansen wrote:
>> On 18 Feb 2021, at 06:36, Arseny Krasnov <arseny.krasnov@kaspersky.com> wrote:
>>
>> This moves wait loop for data to dedicated function, because later
>> it will be used by SEQPACKET data receive loop.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> net/vmw_vsock/af_vsock.c | 155 +++++++++++++++++++++------------------
>> 1 file changed, 83 insertions(+), 72 deletions(-)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 656370e11707..6cf7bb977aa1 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1832,6 +1832,68 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>> 	return err;
>> }
>>
>> +static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
>> +			   long timeout,
>> +			   struct vsock_transport_recv_notify_data *recv_data,
>> +			   size_t target)
>> +{
>> +	const struct vsock_transport *transport;
>> +	struct vsock_sock *vsk;
>> +	s64 data;
>> +	int err;
>> +
>> +	vsk = vsock_sk(sk);
>> +	err = 0;
>> +	transport = vsk->transport;
>> +	prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>> +
>> +	while ((data = vsock_stream_has_data(vsk)) == 0) {
> In the original code, the prepare_to_wait() is called for each iteration of the while loop. In this
> version, it is only called once. So if we do multiple iterations, the thread would be in the
> TASK_RUNNING state, and subsequent schedule_timeout() will return immediately. So
> looks like the prepare_to_wait() should be move here, in case we have a spurious wake_up.
Thank you, i'll fix it
>
>> +		if (sk->sk_err != 0 ||
>> +		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>> +		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>> +			break;
>> +		}
>> +
>> +		/* Don't wait for non-blocking sockets. */
>> +		if (timeout == 0) {
>> +			err = -EAGAIN;
>> +			break;
>> +		}
>> +
>> +		if (recv_data) {
>> +			err = transport->notify_recv_pre_block(vsk, target, recv_data);
>> +			if (err < 0)
>> +				break;
>> +		}
>> +
>> +		release_sock(sk);
>> +		timeout = schedule_timeout(timeout);
>> +		lock_sock(sk);
>> +
>> +		if (signal_pending(current)) {
>> +			err = sock_intr_errno(timeout);
>> +			break;
>> +		} else if (timeout == 0) {
>> +			err = -EAGAIN;
>> +			break;
>> +		}
>> +	}
>> +
>> +	finish_wait(sk_sleep(sk), wait);
>> +
>> +	if (err)
>> +		return err;
>> +
>> +	/* Internal transport error when checking for available
>> +	 * data. XXX This should be changed to a connection
>> +	 * reset in a later change.
>> +	 */
>> +	if (data < 0)
>> +		return -ENOMEM;
>> +
>> +	return data;
>> +}
>> +
>> static int
>> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> 			  int flags)
>> @@ -1911,85 +1973,34 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>
>>
>> 	while (1) {
>> -		s64 ready;
>> -
>> -		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>> -		ready = vsock_stream_has_data(vsk);
>> -
>> -		if (ready == 0) {
>> -			if (sk->sk_err != 0 ||
>> -			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>> -			    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>> -				finish_wait(sk_sleep(sk), &wait);
>> -				break;
>> -			}
>> -			/* Don't wait for non-blocking sockets. */
>> -			if (timeout == 0) {
>> -				err = -EAGAIN;
>> -				finish_wait(sk_sleep(sk), &wait);
>> -				break;
>> -			}
>> +		ssize_t read;
>>
>> -			err = transport->notify_recv_pre_block(
>> -					vsk, target, &recv_data);
>> -			if (err < 0) {
>> -				finish_wait(sk_sleep(sk), &wait);
>> -				break;
>> -			}
>> -			release_sock(sk);
>> -			timeout = schedule_timeout(timeout);
>> -			lock_sock(sk);
>> +		err = vsock_wait_data(sk, &wait, timeout, &recv_data, target);
>> +		if (err <= 0)
>> +			break;
>>
>> -			if (signal_pending(current)) {
>> -				err = sock_intr_errno(timeout);
>> -				finish_wait(sk_sleep(sk), &wait);
>> -				break;
>> -			} else if (timeout == 0) {
>> -				err = -EAGAIN;
>> -				finish_wait(sk_sleep(sk), &wait);
>> -				break;
>> -			}
>> -		} else {
>> -			ssize_t read;
>> -
>> -			finish_wait(sk_sleep(sk), &wait);
>> -
>> -			if (ready < 0) {
>> -				/* Invalid queue pair content. XXX This should
>> -				* be changed to a connection reset in a later
>> -				* change.
>> -				*/
>> -
>> -				err = -ENOMEM;
>> -				goto out;
>> -			}
>> -
>> -			err = transport->notify_recv_pre_dequeue(
>> -					vsk, target, &recv_data);
>> -			if (err < 0)
>> -				break;
>> +		err = transport->notify_recv_pre_dequeue(vsk, target,
>> +							 &recv_data);
>> +		if (err < 0)
>> +			break;
>>
>> -			read = transport->stream_dequeue(
>> -					vsk, msg,
>> -					len - copied, flags);
>> -			if (read < 0) {
>> -				err = -ENOMEM;
>> -				break;
>> -			}
>> +		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>> +		if (read < 0) {
>> +			err = -ENOMEM;
>> +			break;
>> +		}
>>
>> -			copied += read;
>> +		copied += read;
>>
>> -			err = transport->notify_recv_post_dequeue(
>> -					vsk, target, read,
>> -					!(flags & MSG_PEEK), &recv_data);
>> -			if (err < 0)
>> -				goto out;
>> +		err = transport->notify_recv_post_dequeue(vsk, target, read,
>> +						!(flags & MSG_PEEK), &recv_data);
>> +		if (err < 0)
>> +			goto out;
>>
>> -			if (read >= target || flags & MSG_PEEK)
>> -				break;
>> +		if (read >= target || flags & MSG_PEEK)
>> +			break;
>>
>> -			target -= read;
>> -		}
>> +		target -= read;
>> 	}
>>
>> 	if (sk->sk_err)
>> -- 
>> 2.25.1
>>
>
