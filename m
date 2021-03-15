Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6946033AC89
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhCOHuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:50:04 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:26466 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhCOHty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 03:49:54 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 41CE776FB3;
        Mon, 15 Mar 2021 10:49:52 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615794592;
        bh=enNbwy+3T0hgRoXNQ+lIA3wEG7UHRI6OK/k1GsKbyxA=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=wuOI30UVppWPT6I8uSqF1i4Ec/Eea6P6JhMhr+FCQTAlOcO7sbwHPm5TjwuhDMMlR
         6HFsyLqPVngkJRI69OYN5U0Pkc1gJg/9M67kwphg/Vmk5Es+YeDo6JJ8zOp5O2LNNt
         pdJT7h+CQmOfYd32AVvW+N94j3uFHbhVLhV1uDNgNY+gkFEfmQ/wrGelras1wM66zF
         dqwSIypePLnt3nbDOO1c0RdkGq6fJI2/bTffcVw4qqIu4Ctr3CjWY+8D14+5spLY5o
         +wJpxVXczOX/vtyUxzL31lCmKuDdCr+YVydeYaxuL1oSoi7AQwM4LYR0mWe+HfNAso
         c1TuRKxQT2HoQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 06BDF76FE2;
        Mon, 15 Mar 2021 10:49:52 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 15
 Mar 2021 10:49:51 +0300
Subject: Re: [RFC PATCH v6 06/22] af_vsock: implement send logic for SEQPACKET
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180030.3465161-1-arseny.krasnov@kaspersky.com>
 <20210312151027.kamodty37ftspkmc@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <47b8a0a6-652e-8168-43c0-79dba382c4d6@kaspersky.com>
Date:   Mon, 15 Mar 2021 10:49:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210312151027.kamodty37ftspkmc@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/15/2021 07:14:43
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162370 [Mar 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 436 436 4977b9bfeabc3816a6da3614ba6703afbb88002c
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/15/2021 07:18:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.03.2021 2:57:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/15 05:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/15 06:48:00 #16425473
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12.03.2021 18:10, Stefano Garzarella wrote:
> On Sun, Mar 07, 2021 at 09:00:26PM +0300, Arseny Krasnov wrote:
>> This adds some logic to current stream enqueue function for SEQPACKET
>> support:
>> 1) Use transport's seqpacket enqueue callback.
>> 2) Return value from enqueue function is whole record length or error
>>   for SOCK_SEQPACKET.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> include/net/af_vsock.h   |  2 ++
>> net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++------
>> 2 files changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index a8c4039e40cf..aed306292ab3 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -139,6 +139,8 @@ struct vsock_transport {
>> 	size_t (*seqpacket_seq_get_len)(struct vsock_sock *vsk);
>> 	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>> 				 int flags, bool *msg_ready);
>> +	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
>> +				 int flags, size_t len);
>>
>> 	/* Notification. */
>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 5bf64a3e678a..a031f165494d 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1830,9 +1830,14 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>> 		 * responsibility to check how many bytes we were able to send.
>> 		 */
>>
>> -		written = transport->stream_enqueue(
>> -				vsk, msg,
>> -				len - total_written);
>> +		if (sk->sk_type == SOCK_SEQPACKET) {
>> +			written = transport->seqpacket_enqueue(vsk,
>> +						msg, msg->msg_flags,
> I think we can avoid to pass 'msg->msg_flags', since the transport can 
> access it through the 'msg' pointer, right?
Ack
>
>> +						len - total_written);
>> +		} else {
>> +			written = transport->stream_enqueue(vsk,
>> +					msg, len - total_written);
>> +		}
>> 		if (written < 0) {
>> 			err = -ENOMEM;
>> 			goto out_err;
>> @@ -1844,12 +1849,17 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>> 				vsk, written, &send_data);
>> 		if (err < 0)
>> 			goto out_err;
>> -
>> 	}
>>
>> out_err:
>> -	if (total_written > 0)
>> -		err = total_written;
>> +	if (total_written > 0) {
>> +		/* Return number of written bytes only if:
>> +		 * 1) SOCK_STREAM socket.
>> +		 * 2) SOCK_SEQPACKET socket when whole buffer is sent.
>> +		 */
>> +		if (sk->sk_type == SOCK_STREAM || total_written == len)
>> +			err = total_written;
>> +	}
>> out:
>> 	release_sock(sk);
>> 	return err;
>> -- 
>> 2.25.1
>>
>
