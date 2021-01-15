Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921AC2F7241
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbhAOFhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:37:35 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:44727 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729948AbhAOFhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:37:33 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 7B4D352116F;
        Fri, 15 Jan 2021 08:36:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610689008;
        bh=d1C9LPm5LAzmiTpkTjxAIHdop1GWcTlE4FAGAdIkrRM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=saTY2gsmg7bb7K0SHdKQNO9Tz47bAf3UBsbEAusgClnCh5ZCAXOrAAFibQKcxYqjW
         n4tK0N1J3pv8ErgrkHLlEwi61TPK7CwF7Zx5D9KQsEcynSQ4OBJCLKPOW1ABGyzbb/
         4LmcKcZwgf3rTMFWHU4fUgXV/QTXIegz22Tljp/A=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 99404520ED7;
        Fri, 15 Jan 2021 08:36:47 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 15
 Jan 2021 08:36:47 +0300
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
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 00/13] virtio/vsock: introduce SOCK_SEQPACKET support.
Date:   Fri, 15 Jan 2021 08:35:50 +0300
Message-ID: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/15/2021 05:18:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161159 [Jan 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 420 420 0b339e70b2b1bb108f53ec9b40aa316bba18ceea
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/15/2021 05:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.01.2021 2:12:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/15 05:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/15 02:12:00 #16041563
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	This patchset impelements support of SOCK_SEQPACKET for virtio
transport.
	As SOCK_SEQPACKET guarantees to save record boundaries, so to
do it, new packet operation was added: it marks start of record (with
record length in header), such packet doesn't carry any data.  To send
record, packet with start marker is sent first, then all data is sent
as usual 'RW' packets. On receiver's side, length of record is known
from packet with start record marker. Now as  packets of one socket
are not reordered neither on vsock nor on vhost transport layers, such
marker allows to restore original record on receiver's side. If user's
buffer is smaller that record length, when all out of size data is
dropped.
	Maximum length of datagram is not limited as in stream socket,
because same credit logic is used. Difference with stream socket is
that user is not woken up until whole record is received or error
occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
	Tests also implemented.

 Arseny Krasnov (13):
  af_vsock: implement 'vsock_wait_data()'.
  af_vsock: separate rx loops for STREAM/SEQPACKET.
  af_vsock: implement rx loops entry point
  af_vsock: replace previous stream rx loop.
  af_vsock: implement send logic for SOCK_SEQPACKET
  af_vsock: general support of SOCK_SEQPACKET type.
  af_vsock: update comments for stream sockets.
  virtio/vsock: dequeue callback for SOCK_SEQPACKET.
  virtio/vsock: implement fetch of record length
  virtio/vsock: update receive logic
  virtio/vsock: rest of SOCK_SEQPACKET support
  vhost/vsock: support for SOCK_SEQPACKET socket.
  vsock_test: add SOCK_SEQPACKET tests.

 drivers/vhost/vsock.c                   |   7 +-
 include/linux/virtio_vsock.h            |  12 +
 include/net/af_vsock.h                  |   6 +
 include/uapi/linux/virtio_vsock.h       |   9 +
 net/vmw_vsock/af_vsock.c                | 483 ++++++++++++++++------
 net/vmw_vsock/virtio_transport.c        |   4 +
 net/vmw_vsock/virtio_transport_common.c | 294 +++++++++++--
 tools/testing/vsock/util.c              |  32 +-
 tools/testing/vsock/util.h              |   3 +
 tools/testing/vsock/vsock_test.c        | 126 ++++++
 10 files changed, 824 insertions(+), 152 deletions(-)

 v1 -> v2:
 - patches reordered: af_vsock.c changes now before virtio vsock
 - patches reorganized: more small patches, where +/- are not mixed
 - tests for SOCK_SEQPACKET added
 - all commit messages updated
 - af_vsock.c: 'vsock_pre_recv_check()' inlined to
   'vsock_connectible_recvmsg()'
 - af_vsock.c: 'vsock_assign_transport()' returns ENODEV if transport
   was not found
 - virtio_transport_common.c: transport callback for seqpacket dequeue
 - virtio_transport_common.c: simplified
   'virtio_transport_recv_connected()'
 - virtio_transport_common.c: send reset on socket and packet type
			      mismatch.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>

-- 
2.25.1

