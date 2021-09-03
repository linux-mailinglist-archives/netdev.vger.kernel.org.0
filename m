Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2623FFA29
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344508AbhICGPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:15:07 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:25017 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhICGPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 02:15:05 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 791DF5210F3;
        Fri,  3 Sep 2021 09:14:04 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1630649644;
        bh=eaFyXAtHgvusgE2gF7Bwy2o/KgRvSmEZUxGeY5Dp9+k=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=oYJp8WEIbdPnb/4bchkdZ8JaMtO6P9CgvbcVvrpfACIA73nT4UAW7kLtWfPB45q7o
         mD6z2/hqH9pZywn1+UxdvAkCh7YX2FTzMBn9jqyHsOiJJYF/tvUKbH79QCdK2THEv3
         ePyEzgGfrJYLK7RmOJiDDVGCDn5im6MCjVZ05nmRwf8ihBnOMesg094n0csrtkgw/k
         nu2lajr+IvOyCJztxIHe656z7FE+s4M/usLkAp8bPA40fxglRnAr+HbEQcUEXPMtx5
         rcaVc3ag2CGPdvWIEBErWO+MAWX5eTkDZ7OovpLz7xerjCe0bMDbz5JHtCRQlnJjHJ
         HyyWt5g4VBY0g==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id A05C9520FD1;
        Fri,  3 Sep 2021 09:14:03 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 3
 Sep 2021 09:14:02 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [PATCH net-next v4 0/6] virtio/vsock: introduce MSG_EOR flag for SEQPACKET
Date:   Fri, 3 Sep 2021 09:13:49 +0300
Message-ID: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/03/2021 05:49:39
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165946 [Sep 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 461 461 c95454ca24f64484bdf56c7842a96dd24416624e
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/03/2021 05:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 03.09.2021 4:06:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/09/03 04:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/09/03 02:56:00 #17151492
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
	Record has unlimited length, it consists of multiple message,
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

 Arseny Krasnov(6):
  virtio/vsock: rename 'EOR' to 'EOM' bit.
  virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
  vhost/vsock: support MSG_EOR bit processing
  virtio/vsock: support MSG_EOR bit processing
  af_vsock: rename variables in receive loop
  vsock_test: update message bounds test for MSG_EOR

 drivers/vhost/vsock.c                   | 28 +++++++++++++----------
 include/uapi/linux/virtio_vsock.h       |  3 ++-
 net/vmw_vsock/af_vsock.c                | 10 ++++----
 net/vmw_vsock/virtio_transport_common.c | 23 ++++++++++++-------
 tools/testing/vsock/vsock_test.c        |  8 ++++++-
 5 files changed, 45 insertions(+), 27 deletions(-)

 v3 -> v4:
 - 'sendXXX()' renamed to 'send*()' in 0002- commit msg.
 - Comment about bit restore updated in 0003-.
 - 'same' renamed to 'similar' in 0003- commit msg.
 - u32 used instead of uint32_t in 0003-.

 v2 -> v3:
 - 'virtio/vsock: rename 'EOR' to 'EOM' bit.' - commit message updated.
 - 'VIRTIO_VSOCK_SEQ_EOR' bit add moved to separate patch.
 - 'vhost/vsock: support MSG_EOR bit processing' - commit message
   updated.
 - 'vhost/vsock: support MSG_EOR bit processing' - removed unneeded
   'le32_to_cpu()', because input argument was already in CPU
   endianness.

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

