Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5363E5937
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhHJLjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:39:39 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:11522 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbhHJLji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:39:38 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 176DB520FC9;
        Tue, 10 Aug 2021 14:39:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1628595550;
        bh=fcTuEZHg+IIEcNiez+mECaMj+YtI21GiDfchP2O/dNk=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=2PkSX1WF1/qolv0L35H/CzoRiB/0tIZcHx8YGoeBnhv/24IqQ86XUCm9cWP0RAPMj
         6CMU5cqWIUmgxN8UwOesHc8ClS/KUtN4aMpAuVG3fpP3jtqyvkZbSzKIsj7WtI8yPp
         2qCM64fXCMGuUgNAqpB8qnNuGTgEVMHS7eHwxKVMrZkkfsLM3IRcauensR5gSf/6jh
         6dA9HMR2c+ialQv+98XKXOrMxi5SYDXTU2G2if+WlAheqk7jePOUm8A4GKBHuzMh5n
         cyeSa/2L1sOogjwqeWMzMvqiyMFWRmD08TnXGybzKFvQ20X8QuQILr/cf0SR+cmwg8
         Vqft+uFmLXkFQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 52576520FD6;
        Tue, 10 Aug 2021 14:39:09 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 10
 Aug 2021 14:39:08 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 0/5] virtio/vsock: introduce MSG_EOR flag for SEQPACKET
Date:   Tue, 10 Aug 2021 14:38:58 +0300
Message-ID: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/10/2021 11:22:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165493 [Aug 10 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/10/2021 11:24:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10.08.2021 6:55:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/10 08:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/10 05:40:00 #17007547
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	This patchset implements support of MSG_EOR bit for SEQPACKET
AF_VSOCK sockets over virtio transport.
	First we need to define 'messages' and 'records' like this:
Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
etc. It has fixed maximum length, and it bounds are visible using
return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
Current implementation based on message definition above.
	Record has unlimited length, it consists of multiple messages,
and bounds of record are visible via MSG_EOR flag returned from
'recvmsg()' call. Sender passes MSG_EOR to sending system call and
receiver will see MSG_EOR when corresponding message will be processed.
	Idea of patchset comes from POSIX: it says that SEQPACKET
supports record boundaries which are visible for receiver using
MSG_EOR bit. So, it looks like MSG_EOR is enough thing for SEQPACKET
and we don't need to maintain boundaries of corresponding send -
receive system calls. But, for 'sendXXX()' and 'recXXX()' POSIX says,
that all these calls operates with messages, e.g. 'sendXXX()' sends
message, while 'recXXX()' reads messages and for SEQPACKET, 'recXXX()'
must read one entire message from socket, dropping all out of size
bytes. Thus, both message boundaries and MSG_EOR bit must be supported
to follow POSIX rules.
	To support MSG_EOR new bit was added along with existing
'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
is used to mark 'MSG_EOR' bit passed from userspace.
	This patchset includes simple test for MSG_EOR.

 Arseny Krasnov(5):
  virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOM' bit
  vhost/vsock: support MSG_EOR bit processing
  virito/vsock: support MSG_EOR bit processing
  af_vsock: rename variables in receive loop
  vsock_test: update message bounds test for MSG_EOR

 drivers/vhost/vsock.c                   | 22 +++++++++++++---------
 include/uapi/linux/virtio_vsock.h       |  3 ++-
 net/vmw_vsock/af_vsock.c                | 10 +++++-----
 net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++++++--------
 tools/testing/vsock/vsock_test.c        |  8 +++++++-
 5 files changed, 42 insertions(+), 24 deletions(-)

 v1 -> v2:
 - 'VIRTIO_VSOCK_SEQ_EOR' is renamed to 'VIRTIO_VSOCK_SEQ_EOM', to
   support backward compatibility.
 - use bitmask of flags to restore in vhost.c, instead of separated
   bool variable for each flag.
 - test for EAGAIN removed, as logically it is not part of this
   patchset(will be sent separately).
 - cover letter updated(added part with POSIX description).

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>

-- 
2.25.1

