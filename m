Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D973A411D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFKLTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:19:06 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:38739 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhFKLTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:19:05 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id E473C75A1B;
        Fri, 11 Jun 2021 14:17:05 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623410226;
        bh=7dTdVoAs47bdd/ldMIXRzqVdmrQUtsux+qRhAfmVXMc=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=MrS84vABZ6RhsZ1hiItseTKd37IVC0ZE86nfm/hRalvDkosQZ6Nf074EqAVFHYgr0
         iO1C+Ofm7VtuPzLMkSc+8/9BguQr4ku6AiL8DSXdH36NE5hwWvKdy3emAVJrAuo2Ki
         lWAu3x06B/AoDgUCBi4ZM4UnlH74FIWFxEnDvlEqJE4CSfARhnz3QduSGewOLEHpbX
         1xExxgYwf9fSyrPWi2Uy2PYPVMA9bK87Cmd0uJPj+AYOHiLGFEwcfJb96Zkg1nw4yc
         L59TrBYy8+hQBxEyqGZbRXTPVNvJdBmve7tGMALximVZBtYNjVlu3oXGp7tuRAz+3Q
         xkeBNQKu1ORXA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 9BF7275A1E;
        Fri, 11 Jun 2021 14:17:05 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:17:05 +0300
Subject: Re: [PATCH v11 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <59b720a8-154f-ad29-e7a9-b86b69408078@kaspersky.com>
Date:   Fri, 11 Jun 2021 14:17:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/11/2021 10:44:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164266 [Jun 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/11/2021 10:48:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.06.2021 5:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/11 09:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/10 21:54:00 #16707142
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11.06.2021 14:07, Arseny Krasnov wrote:
> 	This patchset implements support of SOCK_SEQPACKET for virtio
> transport.
> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
> do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
> set to 1 in last RW packet of message.
> 	Now as  packets of one socket are not reordered neither on vsock
> nor on vhost transport layers, such bit allows to restore original
> message on receiver's side. If user's buffer is smaller than message
> length, when all out of size data is dropped.
> 	Maximum length of datagram is limited by 'peer_buf_alloc' value.
> 	Implementation also supports 'MSG_TRUNC' flags.
> 	Tests also implemented.
>
> 	Thanks to stsp2@yandex.ru for encouragements and initial design
> recommendations.
>
>  Arseny Krasnov (18):
>   af_vsock: update functions for connectible socket
>   af_vsock: separate wait data loop
>   af_vsock: separate receive data loop
>   af_vsock: implement SEQPACKET receive loop
>   af_vsock: implement send logic for SEQPACKET
>   af_vsock: rest of SEQPACKET support
>   af_vsock: update comments for stream sockets
>   virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>   virtio/vsock: simplify credit update function API
>   virtio/vsock: defines and constants for SEQPACKET
>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>   virtio/vsock: add SEQPACKET receive logic
>   virtio/vsock: rest of SOCK_SEQPACKET support
>   virtio/vsock: enable SEQPACKET for transport
>   vhost/vsock: enable SEQPACKET for transport
>   vsock/loopback: enable SEQPACKET for transport
>   vsock_test: add SOCK_SEQPACKET tests
>   virtio/vsock: update trace event for SEQPACKET
>
>  drivers/vhost/vsock.c                              |  56 ++-
>  include/linux/virtio_vsock.h                       |  10 +
>  include/net/af_vsock.h                             |   8 +
>  .../trace/events/vsock_virtio_transport_common.h   |   5 +-
>  include/uapi/linux/virtio_vsock.h                  |   9 +
>  net/vmw_vsock/af_vsock.c                           | 464 ++++++++++++------
>  net/vmw_vsock/virtio_transport.c                   |  26 ++
>  net/vmw_vsock/virtio_transport_common.c            | 179 +++++++-
>  net/vmw_vsock/vsock_loopback.c                     |  12 +
>  tools/testing/vsock/util.c                         |  32 +-
>  tools/testing/vsock/util.h                         |   3 +
>  tools/testing/vsock/vsock_test.c                   | 116 ++++++
>  12 files changed, 730 insertions(+), 190 deletions(-)
>
>  v10 -> v11:
>  General changelog:
>   - now data is copied to user's buffer only when
>     whole message is received.
>   - reader is woken up when EOR packet is received.
>   - if read syscall was interrupted by signal or
>     timeout, error is returned(not 0).
>
>  Per patch changelog:
>   see every patch after '---' line.
So here is new version for review with updates discussed earlier :)
>
>  v9 -> v10:
>  General changelog:
>  - patch for write serialization removed from patchset.
>  - commit messages rephrased
>
>  Per patch changelog:
>   see every patch after '---' line.
>
>  v8 -> v9:
>  General changelog:
>  - see per patch change log.
>
>  Per patch changelog:
>   see every patch after '---' line.
>
>  v7 -> v8:
>  General changelog:
>  - whole idea is simplified: channel now considered reliable,
>    so SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id' were removed.
>    Only thing that is used to mark end of message is bit in
>    'flags' field of packet header: VIRTIO_VSOCK_SEQ_EOR. Packet
>    with such bit set to 1 means, that this is last packet of
>    message.
>
>  - POSIX MSG_EOR support is removed, as there is no exact
>    description how it works.
>
>  - all changes to 'include/uapi/linux/virtio_vsock.h' moved
>    to dedicated patch, as these changes linked with patch to
>    spec.
>
>  - patch 'virtio/vsock: SEQPACKET feature bit support' now merged
>    to 'virtio/vsock: setup SEQPACKET ops for transport'.
>
>  - patch 'vhost/vsock: SEQPACKET feature bit support' now merged
>    to 'vhost/vsock: setup SEQPACKET ops for transport'.
>
>  Per patch changelog:
>   see every patch after '---' line.
>
>  v6 -> v7:
>  General changelog:
>  - virtio transport callback for message length now removed
>    from transport. Length of record is returned by dequeue
>    callback.
>
>  - function which tries to get message length now returns 0
>    when rx queue is empty. Also length of current message in
>    progress is set to 0, when message processed or error
>    happens.
>
>  - patches for virtio feature bit moved after patches with
>    transport ops.
>
>  Per patch changelog:
>   see every patch after '---' line.
>
>  v5 -> v6:
>  General changelog:
>  - virtio transport specific callbacks which send SEQ_BEGIN or
>    SEQ_END now hidden inside virtio transport. Only enqueue,
>    dequeue and record length callbacks are provided by transport.
>
>  - virtio feature bit for SEQPACKET socket support introduced:
>    VIRTIO_VSOCK_F_SEQPACKET.
>
>  - 'msg_cnt' field in 'struct virtio_vsock_seq_hdr' renamed to
>    'msg_id' and used as id.
>
>  Per patch changelog:
>  - 'af_vsock: separate wait data loop':
>     1) Commit message updated.
>     2) 'prepare_to_wait()' moved inside while loop(thanks to
>       Jorgen Hansen).
>     Marked 'Reviewed-by' with 1), but as 2) I removed R-b.
>
>  - 'af_vsock: separate receive data loop': commit message
>     updated.
>     Marked 'Reviewed-by' with that fix.
>
>  - 'af_vsock: implement SEQPACKET receive loop': style fixes.
>
>  - 'af_vsock: rest of SEQPACKET support':
>     1) 'module_put()' added when transport callback check failed.
>     2) Now only 'seqpacket_allow()' callback called to check
>        support of SEQPACKET by transport.
>
>  - 'af_vsock: update comments for stream sockets': commit message
>     updated.
>     Marked 'Reviewed-by' with that fix.
>
>  - 'virtio/vsock: set packet's type in send':
>     1) Commit message updated.
>     2) Parameter 'type' from 'virtio_transport_send_credit_update()'
>        also removed in this patch instead of in next.
>
>  - 'virtio/vsock: dequeue callback for SOCK_SEQPACKET': SEQPACKET
>     related state wrapped to special struct.
>
>  - 'virtio/vsock: update trace event for SEQPACKET': format strings
>     now not broken by new lines.
>
>  v4 -> v5:
>  - patches reorganized:
>    1) Setting of packet's type in 'virtio_transport_send_pkt_info()'
>       is moved to separate patch.
>    2) Simplifying of 'virtio_transport_send_credit_update()' is
>       moved to separate patch and before main virtio/vsock patches.
>  - style problem fixed
>  - in 'af_vsock: separate receive data loop' extra 'release_sock()'
>    removed
>  - added trace event fields for SEQPACKET
>  - in 'af_vsock: separate wait data loop':
>    1) 'vsock_wait_data()' removed 'goto out;'
>    2) Comment for invalid data amount is changed.
>  - in 'af_vsock: rest of SEQPACKET support', 'new_transport' pointer
>    check is moved after 'try_module_get()'
>  - in 'af_vsock: update comments for stream sockets', 'connect-oriented'
>    replaced with 'connection-oriented'
>  - in 'loopback/vsock: setup SEQPACKET ops for transport',
>    'loopback/vsock' replaced with 'vsock/loopback'
>
>  v3 -> v4:
>  - SEQPACKET specific metadata moved from packet header to payload
>    and called 'virtio_vsock_seq_hdr'
>  - record integrity check:
>    1) SEQ_END operation was added, which marks end of record.
>    2) Both SEQ_BEGIN and SEQ_END carries counter which is incremented
>       on every marker send.
>  - af_vsock.c: socket operations for STREAM and SEQPACKET call same
>    functions instead of having own "gates" differs only by names:
>    'vsock_seqpacket/stream_getsockopt()' now replaced with
>    'vsock_connectible_getsockopt()'.
>  - af_vsock.c: 'seqpacket_dequeue' callback returns error and flag that
>    record ready. There is no need to return number of copied bytes,
>    because case when record received successfully is checked at virtio
>    transport layer, when SEQ_END is processed. Also user doesn't need
>    number of copied bytes, because 'recv()' from SEQPACKET could return
>    error, length of users's buffer or length of whole record(both are
>    known in af_vsock.c).
>  - af_vsock.c: both wait loops in af_vsock.c(for data and space) moved
>    to separate functions because now both called from several places.
>  - af_vsock.c: 'vsock_assign_transport()' checks that 'new_transport'
>    pointer is not NULL and returns 'ESOCKTNOSUPPORT' instead of 'ENODEV'
>    if failed to use transport.
>  - tools/testing/vsock/vsock_test.c: rename tests
>
>  v2 -> v3:
>  - patches reorganized: split for prepare and implementation patches
>  - local variables are declared in "Reverse Christmas tree" manner
>  - virtio_transport_common.c: valid leXX_to_cpu() for vsock header
>    fields access
>  - af_vsock.c: 'vsock_connectible_*sockopt()' added as shared code
>    between stream and seqpacket sockets.
>  - af_vsock.c: loops in '__vsock_*_recvmsg()' refactored.
>  - af_vsock.c: 'vsock_wait_data()' refactored.
>
>  v1 -> v2:
>  - patches reordered: af_vsock.c related changes now before virtio vsock
>  - patches reorganized: more small patches, where +/- are not mixed
>  - tests for SOCK_SEQPACKET added
>  - all commit messages updated
>  - af_vsock.c: 'vsock_pre_recv_check()' inlined to
>    'vsock_connectible_recvmsg()'
>  - af_vsock.c: 'vsock_assign_transport()' returns ENODEV if transport
>    was not found
>  - virtio_transport_common.c: transport callback for seqpacket dequeue
>  - virtio_transport_common.c: simplified
>    'virtio_transport_recv_connected()'
>  - virtio_transport_common.c: send reset on socket and packet type
> 			      mismatch.
>
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>
