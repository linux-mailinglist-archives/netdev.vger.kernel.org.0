Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE531B63E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBOJMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:12:46 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:26078 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhBOJMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 04:12:41 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id D167C521847;
        Mon, 15 Feb 2021 12:11:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613380315;
        bh=wl5bInwndQYHnhr0/slUsUtb2bYyEjBdhWRXtViAFy8=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=xWtSehnCkFk9xqGuSFItfDrxBQgvhHALiWpaEwIZRxU8sXfePDQpBakQjOntylZSc
         jEl9a6L2XjswWTE4Mj16OvE+CtVPbT3W74FjO9I4Jxm2+doJG4kO5ToXxbiAm5Pn8g
         viTnlH5AgAk00rpPGXgG59ibt22G0lX9xXHWVCT0p7BD4sP7yjT+T8JXfRzpVblwCJ
         aPP3XQFEIOkVFs2RmqF/F5pVXtJCbk4b1qnh4fwlsAgdYm5nwjV/3fMbA/zrK3n93b
         uN6LMfN8opGq3fcgvO9lZRU8o2Ransa6+MLxxOpW4S/GeLeZ4/mMhFzJslQj0aJFkg
         4jI1kom4g2bLg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 02721521853;
        Mon, 15 Feb 2021 12:11:55 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 15
 Feb 2021 12:11:54 +0300
Subject: Re: [RFC PATCH v4 07/17] af_vsock: rest of SEQPACKET support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151615.805115-1-arseny.krasnov@kaspersky.com>
 <20210211122714.rqiwg3qp3kuprktb@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <53525ac0-1632-1a49-5c80-9ed2aa0012e0@kaspersky.com>
Date:   Mon, 15 Feb 2021 12:11:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210211122714.rqiwg3qp3kuprktb@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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
X-KLMS-AntiPhishing: Clean, bases: 2021/02/15 08:17:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/15 05:13:00 #16229789
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11.02.2021 15:27, Stefano Garzarella wrote:
> On Sun, Feb 07, 2021 at 06:16:12PM +0300, Arseny Krasnov wrote:
>> This does rest of SOCK_SEQPACKET support:
>> 1) Adds socket ops for SEQPACKET type.
>> 2) Allows to create socket with SEQPACKET type.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> net/vmw_vsock/af_vsock.c | 37 ++++++++++++++++++++++++++++++++++++-
>> 1 file changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index a033d3340ac4..c77998a14018 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -452,6 +452,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>> 		new_transport = transport_dgram;
>> 		break;
>> 	case SOCK_STREAM:
>> +	case SOCK_SEQPACKET:
>> 		if (vsock_use_local_transport(remote_cid))
>> 			new_transport = transport_local;
>> 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
>> @@ -459,6 +460,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>> 			new_transport = transport_g2h;
>> 		else
>> 			new_transport = transport_h2g;
>> +
>> +		if (sk->sk_type == SOCK_SEQPACKET) {
>> +			if (!new_transport ||
>> +			    !new_transport->seqpacket_seq_send_len ||
>> +			    !new_transport->seqpacket_seq_send_eor ||
>> +			    !new_transport->seqpacket_seq_get_len ||
>> +			    !new_transport->seqpacket_dequeue)
>> +				return -ESOCKTNOSUPPORT;
>> +		}
> Maybe we should move this check after the try_module_get() call, since 
> the memory pointed by 'new_transport' pointer can be deallocated in the 
> meantime.
>
> Also, if the socket had a transport before, we should deassign it before 
> returning an error.

I think previous transport is deassigned immediately after this

'switch()' on sk->sk_type:

if (vsk->transport) {

    ...

    vsock_deassign_transport(vsk);

}


Ok, check will be moved after 'try_module_get()'.

>
>> 		break;
>> 	default:
>> 		return -ESOCKTNOSUPPORT;
>> @@ -684,6 +694,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
>>
>> 	switch (sk->sk_socket->type) {
>> 	case SOCK_STREAM:
>> +	case SOCK_SEQPACKET:
>> 		spin_lock_bh(&vsock_table_lock);
>> 		retval = __vsock_bind_connectible(vsk, addr);
>> 		spin_unlock_bh(&vsock_table_lock);
>> @@ -769,7 +780,7 @@ static struct sock *__vsock_create(struct net *net,
>>
>> static bool sock_type_connectible(u16 type)
>> {
>> -	return type == SOCK_STREAM;
>> +	return (type == SOCK_STREAM) || (type == SOCK_SEQPACKET);
>> }
>>
>> static void __vsock_release(struct sock *sk, int level)
>> @@ -2199,6 +2210,27 @@ static const struct proto_ops vsock_stream_ops = {
>> 	.sendpage = sock_no_sendpage,
>> };
>>
>> +static const struct proto_ops vsock_seqpacket_ops = {
>> +	.family = PF_VSOCK,
>> +	.owner = THIS_MODULE,
>> +	.release = vsock_release,
>> +	.bind = vsock_bind,
>> +	.connect = vsock_connect,
>> +	.socketpair = sock_no_socketpair,
>> +	.accept = vsock_accept,
>> +	.getname = vsock_getname,
>> +	.poll = vsock_poll,
>> +	.ioctl = sock_no_ioctl,
>> +	.listen = vsock_listen,
>> +	.shutdown = vsock_shutdown,
>> +	.setsockopt = vsock_connectible_setsockopt,
>> +	.getsockopt = vsock_connectible_getsockopt,
>> +	.sendmsg = vsock_connectible_sendmsg,
>> +	.recvmsg = vsock_connectible_recvmsg,
>> +	.mmap = sock_no_mmap,
>> +	.sendpage = sock_no_sendpage,
>> +};
>> +
>> static int vsock_create(struct net *net, struct socket *sock,
>> 			int protocol, int kern)
>> {
>> @@ -2219,6 +2251,9 @@ static int vsock_create(struct net *net, struct socket *sock,
>> 	case SOCK_STREAM:
>> 		sock->ops = &vsock_stream_ops;
>> 		break;
>> +	case SOCK_SEQPACKET:
>> +		sock->ops = &vsock_seqpacket_ops;
>> +		break;
>> 	default:
>> 		return -ESOCKTNOSUPPORT;
>> 	}
>> -- 
>> 2.25.1
>>
>
