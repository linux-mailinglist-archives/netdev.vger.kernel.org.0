Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E153F507D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhHWSmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:42:17 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:42060 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhHWSmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 14:42:08 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id D2EE25213E7;
        Mon, 23 Aug 2021 21:41:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1629744082;
        bh=E2ieoYqcBgWyY9M739h6cFNmiGdTmJ9xBON1T6ZnMOo=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=y9NFQnNbDlOLJ05tc/Lb6B6svo3LQLSsyHoVVtMlq3sgNjNglelYWTHc5Hwf5fljy
         1NO0x8dLFq9ldKfWAox7SwJUoieLKGUrZno6YFW98AeGM6D08EBasKaC+R+RxY+vP1
         5L6nITrj73DlBPREb+oV5GUTpXvRMmtjdSUqfCtMJo/pnULvkG4ex3Owa9dODep78J
         kuZWida/c56RAvy1imTU2iYmU9Z5km3s8jUxgcFANTNy9AiIvDAUQy7tOHGoJVPMrP
         f6UOaiAGxJqze3Mjo7Uo11LLiHAqy+4qwbpm+gsf19WA6VRJvK8FBd0lR4vpGUdjNF
         Eu28uAAVnnKIw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 096985213F9;
        Mon, 23 Aug 2021 21:41:22 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 23
 Aug 2021 21:41:21 +0300
Subject: Re: [RFC PATCH v3 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>, <oxffffaa@gmail.com>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <3f3fc268-10fc-1917-32c2-dc0e7737dc48@kaspersky.com>
Date:   Mon, 23 Aug 2021 21:41:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/23/2021 18:28:24
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165743 [Aug 23 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/23/2021 18:31:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.08.2021 16:49:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/23 16:16:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/23 16:49:00 #17087690
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, please ping :)


On 16.08.2021 11:50, Arseny Krasnov wrote:
> 	This patchset implements support of MSG_EOR bit for SEQPACKET
> AF_VSOCK sockets over virtio transport.
> 	First we need to define 'messages' and 'records' like this:
> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
> etc. It has fixed maximum length, and it bounds are visible using
> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
> Current implementation based on message definition above.
> 	Record has unlimited length, it consists of multiple message,
> and bounds of record are visible via MSG_EOR flag returned from
> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
> receiver will see MSG_EOR when corresponding message will be processed.
> 	Idea of patchset comes from POSIX: it says that SEQPACKET
> supports record boundaries which are visible for receiver using
> MSG_EOR bit. So, it looks like MSG_EOR is enough thing for SEQPACKET
> and we don't need to maintain boundaries of corresponding send -
> receive system calls. But, for 'sendXXX()' and 'recXXX()' POSIX says,
> that all these calls operates with messages, e.g. 'sendXXX()' sends
> message, while 'recXXX()' reads messages and for SEQPACKET, 'recXXX()'
> must read one entire message from socket, dropping all out of size
> bytes. Thus, both message boundaries and MSG_EOR bit must be supported
> to follow POSIX rules.
> 	To support MSG_EOR new bit was added along with existing
> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
> is used to mark 'MSG_EOR' bit passed from userspace.
> 	This patchset includes simple test for MSG_EOR.
>
>  Arseny Krasnov(6):
>   virtio/vsock: rename 'EOR' to 'EOM' bit.
>   virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
>   vhost/vsock: support MSG_EOR bit processing
>   virtio/vsock: support MSG_EOR bit processing
>   af_vsock: rename variables in receive loop
>   vsock_test: update message bounds test for MSG_EOR
>
>  drivers/vhost/vsock.c                   | 22 +++++++++++++---------
>  include/uapi/linux/virtio_vsock.h       |  3 ++-
>  net/vmw_vsock/af_vsock.c                | 10 +++++-----
>  net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++++++--------
>  tools/testing/vsock/vsock_test.c        |  8 +++++++-
>  5 files changed, 42 insertions(+), 24 deletions(-)
>
>  v2 -> v3:
>  - 'virtio/vsock: rename 'EOR' to 'EOM' bit.' - commit message updated.
>  - 'VIRTIO_VSOCK_SEQ_EOR' bit add moved to separate patch.
>  - 'vhost/vsock: support MSG_EOR bit processing' - commit message
>    updated.
>  - 'vhost/vsock: support MSG_EOR bit processing' - removed unneeded
>    'le32_to_cpu()', because input argument was already in CPU
>    endianness.
>
>  v1 -> v2:
>  - 'VIRTIO_VSOCK_SEQ_EOR' is renamed to 'VIRTIO_VSOCK_SEQ_EOM', to
>    support backward compatibility.
>  - use bitmask of flags to restore in vhost.c, instead of separated
>    bool variable for each flag.
>  - test for EAGAIN removed, as logically it is not part of this
>    patchset(will be sent separately).
>  - cover letter updated(added part with POSIX description).
>
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>
