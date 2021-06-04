Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D0339BF37
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFDSCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:02:07 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:49727 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhFDSCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:02:06 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 248D57712C;
        Fri,  4 Jun 2021 21:00:16 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1622829616;
        bh=GlAlFxfeAXuBUcp/w+RaSFJFlzxTdFTTuWlccMQnnX4=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=GI2wUHNDZfGK8gtpXwXHfRLnJ4WxBSG9ckHn/1tQv+POLeDozeIIz+WHA5PWjDeLk
         nNFucxrbFSi+xFhy02F8z0OWhHEGVAv6xlcW1wPNGI0jFuc+YO6LP2U8LBdEeEjhke
         D8HT/VYdbk7bBXm7XlvxPJeZkwABylhpe+hog71VOBJY0O8jUl9+X9ZVMCZjIYsRud
         pBafXOOpkOSYWYC4PPjnlAXxj45C9Dp+w9SE9yb93Jwz2Zcyjgk8JruBjFlQVApUGQ
         7VJXBGG2+/VZx+SZMtrop4U4oJN2S9d6Ku7mHa0m1KyKxvDenCOtzdwo6lg+g22Ogz
         SbPNDOD32spHQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 50F4577135;
        Fri,  4 Jun 2021 21:00:15 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 4
 Jun 2021 21:00:14 +0300
Subject: Re: [MASSMAIL KLMS] Re: [PATCH v10 04/18] af_vsock: implement
 SEQPACKET receive loop
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
 <20210604150638.rmx262k4wjmp2zob@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <93254e99-1cf9-3135-f1c8-d60336bf41b5@kaspersky.com>
Date:   Fri, 4 Jun 2021 21:00:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210604150638.rmx262k4wjmp2zob@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/04/2021 17:41:00
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164135 [Jun 04 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/04/2021 17:43:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.06.2021 14:19:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/04 17:28:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/04 14:19:00 #16700241
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04.06.2021 18:06, Stefano Garzarella wrote:
> On Thu, May 20, 2021 at 10:16:08PM +0300, Arseny Krasnov wrote:
>> Add receive loop for SEQPACKET. It looks like receive loop for
>> STREAM, but there are differences:
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
>> v9 -> v10:
>> 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>>
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
>> index c4f6bfa1e381..aede474343d1 100644
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
> Why we report that nothing was copied?
>
> What happen to the bytes already copied in `msg`?
Seems i need to return result of vsock_wait_data()...
>
>
>> +			break;
>> +		}
>> +
>> +		fragment_len = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);
>> +
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
>> +			err = len - msg_data_left(msg);
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
