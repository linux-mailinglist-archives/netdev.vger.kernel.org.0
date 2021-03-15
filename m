Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9B33AC87
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCOHuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:50:03 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:26345 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhCOHtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 03:49:35 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 9A75776FD0;
        Mon, 15 Mar 2021 10:49:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615794573;
        bh=TVahkI2L3r/Rm/TUiGwxPtreCFIrXGRLr7pufFvHTmE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=OhH3IqZeoFgpqin0iEAaZttzpFNgdm4CUU78L8raPrj8Z1RZz+oEma5AIMHjVkLGZ
         LxKX4qSkqXyvEooqaE9retbvqVd2YvhCRfoS8k77zZqHtUiYRfVEw0UOSNEp/S53Uj
         9ih+UNc2xTzLrjdmdEjjf43DMMfdOyd00RUdhh3r0v+a+3/8ZTyWpEP6Hq1tDnv57r
         w4SWZYkFonhiitVv5WptHvHhIKWMxtSxff2Bf3BCECLfbhk/Sge0s5YQu1DHOhmAVy
         FFbBYr/dCO4M2huokO7gU00oonLsuA6kccPXOfAwcCmzRiHNrj/MQkPZamPN/w+yAa
         fsb5cTKS6OyRg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 66BFE76FD5;
        Mon, 15 Mar 2021 10:49:33 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 15
 Mar 2021 10:49:32 +0300
Subject: Re: [RFC PATCH v6 04/22] af_vsock: implement SEQPACKET receive loop
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
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307175948.3464885-1-arseny.krasnov@kaspersky.com>
 <20210312151747.quk37sezpcwwq4id@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <c5061006-e219-d8fe-69aa-6cceacedf3a8@kaspersky.com>
Date:   Mon, 15 Mar 2021 10:49:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210312151747.quk37sezpcwwq4id@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
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


On 12.03.2021 18:17, Stefano Garzarella wrote:
> On Sun, Mar 07, 2021 at 08:59:45PM +0300, Arseny Krasnov wrote:
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
>> net/vmw_vsock/af_vsock.c | 95 +++++++++++++++++++++++++++++++++++++++-
>> 2 files changed, 99 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index b1c717286993..5ad7ee7f78fd 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -135,6 +135,11 @@ struct vsock_transport {
>> 	bool (*stream_is_active)(struct vsock_sock *);
>> 	bool (*stream_allow)(u32 cid, u32 port);
>>
>> +	/* SEQ_PACKET. */
>> +	size_t (*seqpacket_seq_get_len)(struct vsock_sock *vsk);
>> +	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>> +				 int flags, bool *msg_ready);
>> +
>> 	/* Notification. */
>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 0bc661e54262..ac2f69362f2e 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1973,6 +1973,96 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
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
>> +		err = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);
> In order to simplify the transport interface, can we do the work of 
> seqpacket_seq_get_len() at the beginning of seqpacket_dequeue()?
>
> So in this way seqpacket_dequeue() can return the 'record_len' or an 
> error.
Ack
>
>
