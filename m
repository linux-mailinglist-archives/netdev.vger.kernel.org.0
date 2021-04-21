Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92954366EAC
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243769AbhDUPDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:03:11 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:50315 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbhDUPDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 11:03:09 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id DAD58521D1C;
        Wed, 21 Apr 2021 18:02:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1619017353;
        bh=6MtB4/cuUX//WR/APOKr5hUq+cMDCHQAteXiphTHwJc=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=dQ0FFqmdfBy+dwngwquxv3zl1nU8ilcoKAfiMVrP/EIv8XmZriZkFWX7r78O7dqQw
         pGnj7jefCefXL+C9+nxjT6A42PcLxX8vuM/c+mA8ChccGk2NDG9nE/FX5nHau46bvt
         Rpwyl7EHnwnA09JM8Naz1ohAGqv90NRE3Vso78W7mJx8vunRpRmH6Yhfl7xArDmQlC
         3QvvNiJAtuiFATuIPAsOiMF119u8ZutBaQjeSJJ61h3mkzDNzyXFgjYNuC84IL5Pu3
         inSVqUdH6ie+qoXMfJgCJmhL5XnGgAGqsfSKzb5kLtagIPGoiXoK642I9lctCJDEi2
         XI4N8AatogCpQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6B92F521D14;
        Wed, 21 Apr 2021 18:02:32 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 21
 Apr 2021 18:02:31 +0300
Subject: Re: [RFC PATCH v8 19/19] af_vsock: serialize writes to shared socket
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124739.3408031-1-arseny.krasnov@kaspersky.com>
 <7d433ed9-8d4c-707a-9149-ff0e65d7f943@kaspersky.com>
 <20210421093851.36yazy5vp4uwimd6@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <99ada1d4-3d03-3d0b-877f-176f7b83bc76@kaspersky.com>
Date:   Wed, 21 Apr 2021 18:02:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210421093851.36yazy5vp4uwimd6@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/21/2021 14:49:38
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163272 [Apr 21 2021]
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
X-KSE-Antiphishing-Bases: 04/21/2021 14:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 21.04.2021 14:07:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/21 14:24:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/21 11:31:00 #16604789
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21.04.2021 12:38, Stefano Garzarella wrote:
> On Wed, Apr 14, 2021 at 01:51:17PM +0300, Arseny Krasnov wrote:
>> On 13.04.2021 15:47, Arseny Krasnov wrote:
>>> This add logic, that serializes write access to single socket
>>> by multiple threads. It is implemented be adding field with TID
>>> of current writer. When writer tries to send something, it checks
>>> that field is -1(free), else it sleep in the same way as waiting
>>> for free space at peers' side.
>>>
>>> This implementation is PoC and not related to SEQPACKET close, so
>>> i've placed it after whole patchset.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>>  include/net/af_vsock.h   |  1 +
>>>  net/vmw_vsock/af_vsock.c | 10 +++++++++-
>>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>> index 53d3f33dbdbf..786df80b9fc3 100644
>>> --- a/include/net/af_vsock.h
>>> +++ b/include/net/af_vsock.h
>>> @@ -69,6 +69,7 @@ struct vsock_sock {
>>>  	u64 buffer_size;
>>>  	u64 buffer_min_size;
>>>  	u64 buffer_max_size;
>>> +	pid_t tid_owner;
>>>
>>>  	/* Private to transport. */
>>>  	void *trans;
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index 54bee7e643f4..d00f8c07a9d3 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1765,7 +1765,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>  		ssize_t written;
>>>
>>>  		add_wait_queue(sk_sleep(sk), &wait);
>>> -		while (vsock_stream_has_space(vsk) == 0 &&
>>> +		while ((vsock_stream_has_space(vsk) == 0 ||
>>> +			(vsk->tid_owner != current->pid &&
>>> +			 vsk->tid_owner != -1)) &&
>>>  		       sk->sk_err == 0 &&
>>>  		       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
>>>  		       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
>>> @@ -1796,6 +1798,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>  				goto out_err;
>>>  			}
>>>  		}
>>> +
>>> +		vsk->tid_owner = current->pid;
>>>  		remove_wait_queue(sk_sleep(sk), &wait);
>>>
>>>  		/* These checks occur both as part of and after the loop
>>> @@ -1852,7 +1856,10 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>  			err = total_written;
>>>  	}
>>>  out:
>>> +	vsk->tid_owner = -1;
>>>  	release_sock(sk);
>>> +	sk->sk_write_space(sk);
>>> +
>>>  	return err;
>>>  }
>>>
>>> @@ -2199,6 +2206,7 @@ static int vsock_create(struct net *net, struct socket *sock,
>>>  		return -ENOMEM;
>>>
>>>  	vsk = vsock_sk(sk);
>>> +	vsk->tid_owner = -1;
>> This must be moved to '__vsock_create()'
> Okay, I'll review the next version.
>
> In order to backport this fix to stable branches I think is better to 
> move at the beginning of this series or even out as a separate patch.

Ok, i'll put it as first patch of patchset. I don't like to prepare it as

separate patch, because SEQPACKET will use this fix.

>
> Thanks,
> Stefano
>
>>>  	if (sock->type == SOCK_DGRAM) {
>>>  		ret = vsock_assign_transport(vsk, NULL);
>
