Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8683D3D63D3
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbhGZPv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:51:59 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:30779 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhGZPvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 11:51:55 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id D670F76F1F;
        Mon, 26 Jul 2021 19:32:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1627317140;
        bh=1nfwqB6HCexuAjnK/ArPrVqt48gRoNbKKsoOEwcBINA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=nMmqMhOVMFL1WdvJzV6oVhOiCgjjprAfuF8CImjhSJRTdQpc7l/JlZa2/UxrJxEIA
         CKVsjKMnhnQUfHvIhBKT6LKZlsjUP/k+IWB1ZJQl54B5a+XFRLF0Jc7OsGRx9t0BzD
         3wi8ADdWLSim6A+5slCDQNPeHpuxAld3Q/R2k70w7oqb8WQFZHDNue7G/C4a/tnMbF
         vUQYTVqsVNrMB7x2rZdAY7iFa7oY1Dn6juzMU7K+4z0LtuxYWj7AxCuzyTWLq2jpyt
         PowyLCYGs9WW2FrLBqUDB+Tq2DCQGanCPWaqu22X6iZHJrpgBRhVOQaHOaadijce5y
         DY7KJTn+Wokmw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id CC34376F3D;
        Mon, 26 Jul 2021 19:32:19 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 26
 Jul 2021 19:32:19 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 0/7] virtio/vsock: introduce MSG_EOR flag for SEQPACKET
Date:   Mon, 26 Jul 2021 19:31:33 +0300
Message-ID: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 16:13:33
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165254 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 16:15:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 26.07.2021 14:57:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/26 14:52:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/26 14:01:00 #16958312
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	This patchset implements support of MSG_EOR bit for SEQPACKET
AF_VSOCK sockets over virtio transport.
	Idea is to distinguish concepts of 'messages' and 'records'.
Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
etc. It has fixed maximum length, and it bounds are visible using
return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
Current implementation based on message definition above.
	Record has unlimited length, it consists of multiple message,
and bounds of record are visible via MSG_EOR flag returned from
'recvmsg()' call. Sender passes MSG_EOR to sending system call and
receiver will see MSG_EOR when corresponding message will be processed.
	To support MSG_EOR new bit was added along with existing
'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
is used to mark 'MSG_EOR' bit passed from userspace.
	This patchset includes simple test for MSG_EOR.
 	Also i've added new vsock test for '-EAGAIN' receive result.

 Arseny Krasnov(7):
  virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOM' bit
  vsock: rename implementation from 'record' to 'message'
  vhost/vsock: support MSG_EOR bit processing
  virito/vsock: support MSG_EOR bit processing
  af_vsock: rename variables in receive loop
  vsock_test: update message bounds test for MSG_EOR
  vsock_test: 'SO_RCVTIMEO' test for SEQPACKET

 drivers/vhost/vsock.c                   | 28 +++++++----
 include/uapi/linux/virtio_vsock.h       |  1 +
 net/vmw_vsock/af_vsock.c                | 10 ++--
 net/vmw_vsock/virtio_transport_common.c | 23 +++++----
 tools/testing/vsock/vsock_test.c        | 57 ++++++++++++++++++++++-
 5 files changed, 96 insertions(+), 23 deletions(-)

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>

-- 
2.25.1

