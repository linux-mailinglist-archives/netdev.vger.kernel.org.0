Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8373B87FC
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhF3Ruc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:50:32 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:39873 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbhF3Ru3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:50:29 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 044CC5212B8;
        Wed, 30 Jun 2021 20:47:58 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625075278;
        bh=os+BkFctfMAbcaoBq1Fr50yLvnUAXFHjkvEs1uGP1FM=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=iFvyjDmvaM8va5ketsgEEirTy+Ni6noDAj0qwDqZat9jYBnkbPqdhyWFHwRpjgIHB
         v+2LSZIewkOyXo4raHO1dM4iRyHanNn+pj1+VzaT5p6PDHIPnX/psxnAhbcXkQqOnt
         LRi0Gvjru7sE7enl5CTGo9jnO1AkpajTFJ1jTFNlNpMzIPoJZ51LpuMQmxs57FXeqM
         uKkVp2puHmTYyJQvzw3sT7k3a9RuJFmIiqW26b9niASA88904YwOC0fqaPTArRn4p8
         daHglldxfoXTYghxHM1SXTylxh9poUKwHUwuhS4QElNpmn+hnblpNOjvPS6yPV6aYK
         xuhTTFFtKBdTA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id AAD6E5212CD;
        Wed, 30 Jun 2021 20:47:57 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Wed, 30
 Jun 2021 20:47:57 +0300
Subject: Re: [RFC PATCH v1 08/16] af_vsock: change SEQPACKET receive loop
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
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100331.571056-1-arseny.krasnov@kaspersky.com>
 <CAGxU2F5XtfKJ9cnK=J-gz4uW0AR9FsMc1Dq2jQx=dPGLRC+NTQ@mail.gmail.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <8769f306-1b95-6cda-828a-68c298093ad3@kaspersky.com>
Date:   Wed, 30 Jun 2021 20:47:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F5XtfKJ9cnK=J-gz4uW0AR9FsMc1Dq2jQx=dPGLRC+NTQ@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
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
> On Mon, Jun 28, 2021 at 01:03:28PM +0300, Arseny Krasnov wrote:
>> Receive "loop" now really loop: it reads fragments one by
>> one, sleeping if queue is empty.
>>
>> NOTE: 'msg_ready' pointer is not passed to 'seqpacket_dequeue()'
>> here - it change callback interface, so it is moved to next patch.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> net/vmw_vsock/af_vsock.c | 31 ++++++++++++++++++++++---------
>> 1 file changed, 22 insertions(+), 9 deletions(-)
> I think you can merge patches 8, 9, and 10 together since we
> are touching the seqpacket_dequeue() behaviour.
>
> Then you can remove in separate patches the unneeded parts (e.g.
> seqpacket_has_data, msg_count, etc.).
>
> Thanks,
> Stefano
Ack
>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 59ce35da2e5b..9552f05119f2 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -2003,6 +2003,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>                                    size_t len, int flags)
>> {
>>       const struct vsock_transport *transport;
>> +      bool msg_ready;
>>       struct vsock_sock *vsk;
>>       ssize_t record_len;
>>       long timeout;
>> @@ -2013,23 +2014,36 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>       transport = vsk->transport;
>>
>>       timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>> +      msg_ready = false;
>> +      record_len = 0;
>>
>> -      err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>> -      if (err <= 0)
>> -              goto out;
>> +      while (!msg_ready) {
>> +              ssize_t fragment_len;
>> +              int intr_err;
>>
>> -      record_len = transport->seqpacket_dequeue(vsk, msg, flags);
>> +              intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>> +              if (intr_err <= 0) {
>> +                      err = intr_err;
>> +                      break;
>> +              }
>>
>> -      if (record_len < 0) {
>> -              err = -ENOMEM;
>> -              goto out;
>> +              fragment_len = transport->seqpacket_dequeue(vsk, msg, flags);
>> +
>> +              if (fragment_len < 0) {
>> +                      err = -ENOMEM;
>> +                      break;
>> +              }
>> +
>> +              record_len += fragment_len;
>>       }
>>
>>       if (sk->sk_err) {
>>               err = -sk->sk_err;
>>       } else if (sk->sk_shutdown & RCV_SHUTDOWN) {
>>               err = 0;
>> -      } else {
>> +      }
>> +
>> +      if (msg_ready && !err) {
>>               /* User sets MSG_TRUNC, so return real length of
>>                * packet.
>>                */
>> @@ -2045,7 +2059,6 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>                       msg->msg_flags |= MSG_TRUNC;
>>       }
>>
>> -out:
>>       return err;
>> }
>>
>> --
>> 2.25.1
>>
>
