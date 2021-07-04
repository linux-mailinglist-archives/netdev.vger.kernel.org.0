Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E753BAC6D
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 11:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhGDJZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 05:25:45 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:23483 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGDJZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 05:25:44 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id E560876E8A;
        Sun,  4 Jul 2021 12:23:06 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625390587;
        bh=o+Pyhh8IrgTRMoEQsSE1ouzcm6woOGaG9m4KK5wD9Qk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=AbkCn1gli6ONwiVfSL59cjAr8yQ2mJiBt2I3hj3PN/6FeoCz6PFQIBwHTYZBLoK4+
         OpOnyCyHXdK6lk/RTe2pEyBRpLrrLolPHhz2awC/qq7w4X7GEToKVPboaEAR5CgF2X
         /0xHqFMBT08FZiLBTleFmfRb5SCI3dICa100v4ZTLd1Nktet/A+d8AVGXY2DahHIIg
         Nalud5m5aJZqCcZPmStRtqYTMgqi57OaY38UqKeYfffDDNUgo+YfP7OGbpjVdAmo6w
         ylg1U3sLiJHQ01V7bU0NPol0hYRa5dxql6nCR2AzZbVxJdPfPCa89W64N9ey8iBhXM
         1FckERhw0gy6w==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 2A30676EB4;
        Sun,  4 Jul 2021 12:23:06 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Sun, 4
 Jul 2021 12:23:04 +0300
Subject: Re: [RFC PATCH v2 0/6] Improve SOCK_SEQPACKET receive logic
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
 <20210704042843-mutt-send-email-mst@kernel.org>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <b427dee7-5c1b-9686-9004-05fa05d45b28@kaspersky.com>
Date:   Sun, 4 Jul 2021 12:23:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210704042843-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/04/2021 09:10:22
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164820 [Jul 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/04/2021 09:12:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.07.2021 5:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/04 08:16:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/04 01:03:00 #16855183
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04.07.2021 11:30, Michael S. Tsirkin wrote:
> On Sun, Jul 04, 2021 at 11:08:13AM +0300, Arseny Krasnov wrote:
>> 	This patchset modifies receive logic for SOCK_SEQPACKET.
>> Difference between current implementation and this version is that
>> now reader is woken up when there is at least one RW packet in rx
>> queue of socket and data is copied to user's buffer, while merged
>> approach wake up user only when whole message is received and kept
>> in queue. New implementation has several advantages:
>>  1) There is no limit for message length. Merged approach requires
>>     that length must be smaller than 'peer_buf_alloc', otherwise
>>     transmission will stuck.
>>  2) There is no need to keep whole message in queue, thus no
>>     'kmalloc()' memory will be wasted until EOR is received.
>>
>>     Also new approach has some feature: as fragments of message
>> are copied until EOR is received, it is possible that part of
>> message will be already in user's buffer, while rest of message
>> still not received. And if user will be interrupted by signal or
>> timeout with part of message in buffer, it will exit receive loop,
>> leaving rest of message in queue. To solve this problem special
>> callback was added to transport: it is called when user was forced
>> to leave exit loop and tells transport to drop any packet until
>> EOR met.
> Sorry about commenting late in the game.  I'm a bit lost
>
>
> SOCK_SEQPACKET
> Provides sequenced, reliable, bidirectional, connection-mode transmission paths for records. A record can be sent using one or more output operations and received using one or more input operations, but a single operation never transfers part of more than one record. Record boundaries are visible to the receiver via the MSG_EOR flag.
>
> it's supposed to be reliable - how is it legal to drop packets?

Sorry, seems i need to rephrase description. "Packet" here means fragment of record(message) at transport

layer. As this is SEQPACKET mode, receiver could get only whole message or error, so if only several fragments

of message was copied (if signal received for example) we can't return it to user - it breaks SEQPACKET sense. I think,

in this case we can drop rest of record's fragments legally.


Thank You

>
>
>> When EOR is found, this mode is disabled and normal packet
>> processing started. Note, that when 'drop until EOR' mode is on,
>> incoming packets still inserted in queue, reader will be woken up,
>> tries to copy data, but nothing will be copied until EOR found.
>> It was possible to drain such unneeded packets it rx work without
>> kicking user, but implemented way is simplest. Anyway, i think
>> such cases are rare.
>
>>     New test also added - it tries to copy to invalid user's
>> buffer.
>>
>> Arseny Krasnov (16):
>>  af_vsock/virtio/vsock: change seqpacket receive logic
>>  af_vsock/virtio/vsock: remove 'seqpacket_has_data' callback
>>  virtio/vsock: remove 'msg_count' based logic
>>  af_vsock/virtio/vsock: add 'seqpacket_drop()' callback
>>  virtio/vsock: remove record size limit for SEQPACKET
>>  vsock_test: SEQPACKET read to broken buffer
>>
>>  drivers/vhost/vsock.c                   |   2 +-
>>  include/linux/virtio_vsock.h            |   7 +-
>>  include/net/af_vsock.h                  |   4 +-
>>  net/vmw_vsock/af_vsock.c                |  44 ++++----
>>  net/vmw_vsock/virtio_transport.c        |   2 +-
>>  net/vmw_vsock/virtio_transport_common.c | 103 ++++++++-----------
>>  net/vmw_vsock/vsock_loopback.c          |   2 +-
>>  tools/testing/vsock/vsock_test.c        | 120 ++++++++++++++++++++++
>>  8 files changed, 193 insertions(+), 91 deletions(-)
>>
>>  v1 -> v2:
>>  Patches reordered and reorganized.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>>  cv.txt | 0
>>  1 file changed, 0 insertions(+), 0 deletions(-)
>>  create mode 100644 cv.txt
>>
>> diff --git a/cv.txt b/cv.txt
>> new file mode 100644
>> index 000000000000..e69de29bb2d1
>> -- 
>> 2.25.1
>
