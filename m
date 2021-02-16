Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30EC31C6A9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhBPG7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:59:55 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:36184 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhBPG7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 01:59:38 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 4CD275217A1;
        Tue, 16 Feb 2021 09:58:35 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613458715;
        bh=wmwBiYTPrK7zz9OJrQeNGWUnve2PBn7vVsv5s0RSxkM=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=lhfq4JGgmtR+00o/0qdxz3NacuGsKe/NQQkz1LfOkxVej/GwTHtQ+sZYfVCwPHonw
         eGKjMjKJMSeVARYdunTPCOHR4fK76U6K+8FLU2sHI8gsST5tUnJni8QyzBULeV6LjY
         oyyoxVMGqgpHOse+B2vqjGRb0CFclAxZCY+kwORkAk5ZkZOHjpEktnuVyU9TIWX/dR
         ALgBdB8EW3ghz1GDJS5N6JtHGtHcNHJapRJBiDQ3krRbksGY9EAhrHjkhTY13nZWgg
         yqIxuax0q1l4ZvM+5MkG11cPS/70x6eY7DYKQvnhqdypPML1g6IaYO1SV8g+CfIryr
         ROie+H2lTxvmg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6210D5217A4;
        Tue, 16 Feb 2021 09:58:34 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Tue, 16
 Feb 2021 09:58:33 +0300
Subject: Re: [RFC PATCH v4 02/17] af_vsock: separate wait data loop
To:     Jorgen Hansen <jhansen@vmware.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151451.804498-1-arseny.krasnov@kaspersky.com>
 <4094442C-C2A1-49D6-9901-7F3C73FABFC9@vmware.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <baa11cfd-2f12-fea0-3f5c-015f5d682334@kaspersky.com>
Date:   Tue, 16 Feb 2021 09:58:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4094442C-C2A1-49D6-9901-7F3C73FABFC9@vmware.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
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
X-KLMS-AntiPhishing: Clean, bases: 2021/02/16 06:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/16 04:41:00 #16244040
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11.02.2021 18:11, Jorgen Hansen wrote:
>> On 7 Feb 2021, at 16:14, Arseny Krasnov <arseny.krasnov@kaspersky.com> wrote:
>>
>> This moves wait loop for data to dedicated function, because later
>> it will be used by SEQPACKET data receive loop.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> net/vmw_vsock/af_vsock.c | 158 +++++++++++++++++++++------------------
>> 1 file changed, 86 insertions(+), 72 deletions(-)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index f4fabec50650..38927695786f 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1833,6 +1833,71 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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
>> +		if (sk->sk_err != 0 ||
>> +		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>> +		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
>> +			goto out;
>> +		}
>> +
>> +		/* Don't wait for non-blocking sockets. */
>> +		if (timeout == 0) {
>> +			err = -EAGAIN;
>> +			goto out;
>> +		}
>> +
>> +		if (recv_data) {
>> +			err = transport->notify_recv_pre_block(vsk, target, recv_data);
>> +			if (err < 0)
>> +				goto out;
>> +		}
>> +
>> +		release_sock(sk);
>> +		timeout = schedule_timeout(timeout);
>> +		lock_sock(sk);
>> +
>> +		if (signal_pending(current)) {
>> +			err = sock_intr_errno(timeout);
>> +			goto out;
>> +		} else if (timeout == 0) {
>> +			err = -EAGAIN;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	finish_wait(sk_sleep(sk), wait);
>> +
>> +	/* Invalid queue pair content. XXX This should
>> +	 * be changed to a connection reset in a later
>> +	 * change.
>> +	 */
> Since you are here, could you update this comment to something like:
>
> /* Internal transport error when checking for available
>  * data. XXX This should be changed to a connection
>  * reset in a later change.
>  */
>
>> +	if (data < 0)
>> +		return -ENOMEM;
>> +
>> +	/* Have some data, return. */
>> +	if (data)
>> +		return data;
>> +
>> +out:
>> +	finish_wait(sk_sleep(sk), wait);
>> +	return err;
>> +}
> I agree with Stefanos suggestion to get rid of the out: part  and just have the single finish_wait().
>
>> +
>> static int
>> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> 			  int flags)
>> @@ -1912,85 +1977,34 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>
>>
>> 	while (1) {
>> -		s64 ready;
>> +		ssize_t read;
>>
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
>> -
>> -			err = transport->notify_recv_pre_block(
>> -					vsk, target, &recv_data);
>> -			if (err < 0) {
>> -				finish_wait(sk_sleep(sk), &wait);
>> -				break;
>> -			}
>> -			release_sock(sk);
>> -			timeout = schedule_timeout(timeout);
>> -			lock_sock(sk);
>> -
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
>> +		err = vsock_wait_data(sk, &wait, timeout, &recv_data, target);
>> +		if (err <= 0)
>> +			break;
> There is a small change in the behaviour here if vsock_stream_has_data(vsk)
> returned something < 0. Since you just do a break, the err value can be updated
> if there is an sk->sk_err, a receive shutdown has been performed or data has
> already been copied. That should be ok, though.

May be i can add the following 'if' after while (1) loop:

There was:

if (sk->sk_err)
    err = -sk->sk->sk_err;
else if (sk->sk_shutdown & RCV_SHUTDOWN)
    err = 0;
if (copied > 0)
    err = copied;

Will be:

if (err == 0) {
    if (sk->sk_err)
        err = -sk->sk->sk_err;
     else if (sk->sk_shutdown & RCV_SHUTDOWN)
       err = 0;

    if (copied > 0)
        err = copied;

}

E.g. update 'err' only if it is clear. Don't touch otherwise


>
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
