Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E1E3B87F8
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhF3RuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:50:17 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:39736 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbhF3RuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:50:16 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id B86865212CD;
        Wed, 30 Jun 2021 20:47:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625075265;
        bh=uKBwrvAXKZ/CEhLHzFQqAcnEH5UCuNrjuIzo4nDcjDQ=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=C7o+kwd2uFCkKv04J4G05bQfZCfQxlpXTmCEDTIM08xis4HotkCihQAUGNn1ggJtB
         VYlwEJK5eBMyUn2peEi7rTzaPXvN6Jb8/cwk8tWBFZd+gHs/NUZLOGuCJNV5cvUeYy
         U9ciodGcRnL42S6bXhMpA6WMH+Y7jGY6AHe5jdWBZdenaHtqddu+5P+BaXZH05WjPC
         HM6OH7+ysadOjusTCqqmAipbDWzHbKKnw3RETkUFj0VRQOu9p5DVQpKD8NvSvtH+Re
         6xEwXBLEbYto9auCmZ63tKgvs56iFdTbEZaZKnQ505Q909/g5q3KS5rBJbd9rBleTk
         gflMmbXMisXtQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 775755212CB;
        Wed, 30 Jun 2021 20:47:45 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Wed, 30
 Jun 2021 20:47:45 +0300
Subject: Re: [RFC PATCH v1 07/16] virtio/vsock: don't count EORs on receive
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100318.570947-1-arseny.krasnov@kaspersky.com>
 <CAGxU2F7SsxvCht2HbDb7dKsM_auHoxvHirgWwNMObjxOci=5nA@mail.gmail.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <11d22d50-d15d-43ef-166c-7d11d0205cda@kaspersky.com>
Date:   Wed, 30 Jun 2021 20:47:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F7SsxvCht2HbDb7dKsM_auHoxvHirgWwNMObjxOci=5nA@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
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


On 30.06.2021 15:11, Stefano Garzarella wrote:
> On Mon, Jun 28, 2021 at 01:03:15PM +0300, Arseny Krasnov wrote:
>> There is no sense to count EORs, because 'rx_bytes' is
>> used to check data presence on socket.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 3 ---
>> 1 file changed, 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 84431d7a87a5..319c3345f3e0 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1005,9 +1005,6 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>>               goto out;
>>       }
>>
>> -      if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>> -              vvs->msg_count++;
>> -
> Same here, please remove it when you don't need it, and also remove from
> the struct virtio_vsock_sock.
>
> Thanks,
> Stefano
Ack
>
>>       /* Try to copy small packets into the buffer of last packet queued,
>>        * to avoid wasting memory queueing the entire buffer with a small
>>        * payload.
>> --
>> 2.25.1
>>
>
