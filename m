Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D43B87FF
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhF3Ruu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:50:50 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:46113 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhF3Rut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:50:49 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 01CC4765AD;
        Wed, 30 Jun 2021 20:48:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625075298;
        bh=wTjYsDYdCcl2wrFdgyR1LeTjMj8BoNMgmgdB77KybX0=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=gH/bjQ3UvZjDSAuc/Kso5NipdhqKXyRj9Pnr3XQ3OMj0gKMOCHkbQWQHs4VghlUJq
         rpbs7ZdePbN7Pl0lxad1m0vnDt1g0LowORIMn6KUjo4wAmBTsfOEFHHj9T6z5CatJT
         pH1JUonRMZ2tqgPDz/oIG2rgmZ/3J4Hc/3rS6+BoCME1TC4+IUrhObpxwYHlHoPRfK
         40ycfG7nMW0sLZTsO3Lf+kAdPtylQkQL/p/F3Z3OTPUwvkq8+36aK5KbUsiradRK8g
         RCM7OYIm7ZzQyvYC8531PY+q3gJeM3oOc3CdukUhKYuoiVUrsagVbkm6WTREAMFn2p
         A2Zu65Zq/dFew==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 735AE765EE;
        Wed, 30 Jun 2021 20:48:16 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Wed, 30
 Jun 2021 20:48:16 +0300
Subject: Re: [RFC PATCH v1 11/16] afvsock: add 'seqpacket_drop()'
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100415.571391-1-arseny.krasnov@kaspersky.com>
 <CAGxU2F4mX5khjA+a_LQEfZYg1rjEmccXce-ab0DVyEJEX-kYcw@mail.gmail.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <bb4ef19f-6a49-9486-b420-f2ce55edc265@kaspersky.com>
Date:   Wed, 30 Jun 2021 20:48:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F4mX5khjA+a_LQEfZYg1rjEmccXce-ab0DVyEJEX-kYcw@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/30/2021 17:34:42
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164748 [Jun 30 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/30/2021 17:37:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 30.06.2021 11:32:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/30 16:18:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/30 08:30:00 #16841989
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30.06.2021 15:12, Stefano Garzarella wrote:
> On Mon, Jun 28, 2021 at 01:04:12PM +0300, Arseny Krasnov wrote:
>> Add special callback for SEQPACKET socket which is called when
>> we need to drop current in-progress record: part of record was
>> copied successfully, reader wait rest of record, but signal
>> interrupts it and reader leaves it's loop, leaving packets of
>> current record still in queue. So to avoid copy of "orphaned"
>> record, we tell transport to drop every packet until EOR will
>> be found.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> include/net/af_vsock.h   | 1 +
>> net/vmw_vsock/af_vsock.c | 1 +
>> 2 files changed, 2 insertions(+)
> And also for this change, I think you can merge with patches 12, 13, 14, 
> 15, otherwise if we bisect and we build at this patch, the 
> seqpacket_drop pointer is not valid.
>
> Thanks,
> Stefano
Ack
>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index 1747c0b564ef..356878aabbd4 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -141,6 +141,7 @@ struct vsock_transport {
>>       int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
>>                                size_t len);
>>       bool (*seqpacket_allow)(u32 remote_cid);
>> +      void (*seqpacket_drop)(struct vsock_sock *vsk);
>>
>>       /* Notification. */
>>       int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index ec54e4222cbf..27fa38090e13 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -2024,6 +2024,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>               intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>>               if (intr_err <= 0) {
>>                       err = intr_err;
>> +                      transport->seqpacket_drop(vsk);
>>                       break;
>>               }
>>
>> --
>> 2.25.1
>>
>
