Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD2C37F9EE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhEMOr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:47:29 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:18480 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbhEMOqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:46:52 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id E4A937680C;
        Thu, 13 May 2021 17:45:25 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620917126;
        bh=McEsc7Kk7nJ48FFPAYsW2g0OO/80OpvqTHLARkhd+9Y=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=KpJHTbWtB4cdriBaeIeWFAIIoTCX52/VAZ0rzgEGTJQut7VCpZ8rVAiFB6XqVMPXC
         HXt9RIbLEV3afO2HxDfLzAZdSxcxG9IyQYIbu+5ddQLt8xhTHSh10q1wg36McBZ+5M
         GNliymidTetZVi+Um0MbD0d8bkXGl4f9bNQ+mG/O74OSNOGFTFd0c5xsma+tGWIBjz
         WtjZmLitaX2CWdrRDMR4cFzT9v9rEilPMu8W3sJSs01YZiedBsrpMiffTyK+iRtQ5O
         ZHyU+3YWJN1BMZKljWmWjI/z5oEU6197DEnuy+2rdOj0C+w9YUy72AyaCq4hkvbPAi
         WaE8lNyS5Yqkw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id A124276803;
        Thu, 13 May 2021 17:45:25 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:45:25 +0300
Subject: Re: [RFC PATCH v9 19/19] af_vsock: serialize writes to shared socket
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
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
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163738.3432975-1-arseny.krasnov@kaspersky.com>
 <20210513140150.ugw6foy742fxan4w@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <6fb3a13f-ef14-dc0b-4453-ca1fa94b1907@kaspersky.com>
Date:   Thu, 13 May 2021 17:45:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513140150.ugw6foy742fxan4w@steredhat>
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
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
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


On 13.05.2021 17:01, Stefano Garzarella wrote:
> On Sat, May 08, 2021 at 07:37:35PM +0300, Arseny Krasnov wrote:
>> This add logic, that serializes write access to single socket
>> by multiple threads. It is implemented be adding field with TID
>> of current writer. When writer tries to send something, it checks
>> that field is -1(free), else it sleep in the same way as waiting
>> for free space at peers' side.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> include/net/af_vsock.h   |  1 +
>> net/vmw_vsock/af_vsock.c | 10 +++++++++-
>> 2 files changed, 10 insertions(+), 1 deletion(-)
> I think you forgot to move this patch at the beginning of the series.
> It's important because in this way we can backport to stable branches 
> easily.
>
> About the implementation, can't we just add a mutex that we hold until 
> we have sent all the payload?
>
> I need to check other implementations like TCP.
Ok, i'll prepare this as separate patch
>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index 1747c0b564ef..413343f18e99 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -69,6 +69,7 @@ struct vsock_sock {
>> 	u64 buffer_size;
>> 	u64 buffer_min_size;
>> 	u64 buffer_max_size;
>> +	pid_t tid_owner;
>>
>> 	/* Private to transport. */
>> 	void *trans;
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 7790728465f4..1fb4a1860f6d 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -757,6 +757,7 @@ static struct sock *__vsock_create(struct net *net,
>> 	vsk->peer_shutdown = 0;
>> 	INIT_DELAYED_WORK(&vsk->connect_work, vsock_connect_timeout);
>> 	INIT_DELAYED_WORK(&vsk->pending_work, vsock_pending_work);
>> +	vsk->tid_owner = -1;
>>
>> 	psk = parent ? vsock_sk(parent) : NULL;
>> 	if (parent) {
>> @@ -1765,7 +1766,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>> 		ssize_t written;
>>
>> 		add_wait_queue(sk_sleep(sk), &wait);
>> -		while (vsock_stream_has_space(vsk) == 0 &&
>> +		while ((vsock_stream_has_space(vsk) == 0 ||
>> +			(vsk->tid_owner != current->pid &&
>> +			 vsk->tid_owner != -1)) &&
>> 		       sk->sk_err == 0 &&
>> 		       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
>> 		       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
>> @@ -1796,6 +1799,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>> 				goto out_err;
>> 			}
>> 		}
>> +
>> +		vsk->tid_owner = current->pid;
>> 		remove_wait_queue(sk_sleep(sk), &wait);
>>
>> 		/* These checks occur both as part of and after the loop
>> @@ -1852,7 +1857,10 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>> 			err = total_written;
>> 	}
>> out:
>> +	vsk->tid_owner = -1;
>> 	release_sock(sk);
>> +	sk->sk_write_space(sk);
>> +
> Is this change related? Can you explain in the commit message why it is 
> needed?
>
>> 	return err;
>> }
>>
>> -- 
>> 2.25.1
>>
>
