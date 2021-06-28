Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425B43B5BE7
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhF1KD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:03:27 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:19630 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhF1KDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:03:24 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 6FCFA77F61;
        Mon, 28 Jun 2021 13:00:57 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874457;
        bh=UMC86vtcZLtdkB0xX//h0oHfvby2pTa1TH5ZBf6lJes=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=l/QhcMYtLxR0k2pLlQpyUxdREC57wlKFhQjMFmLFbOxhlVU5VTbIr2AgiaHYXVhrO
         1pMNyDITLCxIV5WsHRiSWSWKZdy/trRnL13ytDNqPwSVHEbQE/Npw2BWvS+IS1LJsp
         XgUfQeDhPbsuY5KyI1CsvKp2SkEDlvc5Y9YBVco2bDEfQ9eTwGnQO2TzWRoeWEN27W
         1XS79jQE/1vTNzffPW58Tc/69wNxF7PtN38Pj0doVRHKQ3xTreiOnUKhwpGFnLM54e
         M9KQbVywXLoGrhDASoVmpaNIyDPdfdkkgmvuVutsOpmqS/8TgUZBlTLFbPJPC4HC1Z
         TpmirbheLajHw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 2B38477F59;
        Mon, 28 Jun 2021 13:00:56 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:00:55 +0300
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
Subject: [RFC PATCH v1 00/16] Improve SOCK_SEQPACKET receive logic
Date:   Mon, 28 Jun 2021 12:59:54 +0300
Message-ID: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/28/2021 09:47:58
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164664 [Jun 28 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/28/2021 09:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 28.06.2021 5:59:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/28 08:23:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/28 05:40:00 #16806866
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	This patchset modifies receive logic for SOCK_SEQPACKET.
Difference between current implementation and this version is that
now reader is woken up when there is at least one RW packet in rx
queue of socket and data is copied to user's buffer, while merged
approach wake up user only when whole message is received and kept
in queue. New implementation has several advantages:
 1) There is no limit for message length. Merged approach requires
    that length must be smaller than 'peer_buf_alloc', otherwise
    transmission will stuck.
 2) There is no need to keep whole message in queue, thus no
    'kmalloc()' memory will be wasted until EOR is received.

    Also new approach has some feature: as fragments of message
are copied until EOR is received, it is possible that part of
message will be already in user's buffer, while rest of message
still not received. And if user will be interrupted by signal or
timeout with part of message in buffer, it will exit receive loop,
leaving rest of message in queue. To solve this problem special
callback was added to transport: it is called when user was forced
to leave exit loop and tells transport to drop any packet until
EOR met. When EOR is found, this mode is disabled and normal packet
processing started. Note, that when 'drop until EOR' mode is on,
incoming packets still inserted in queue, reader will be woken up,
tries to copy data, but nothing will be copied until EOR found.
It was possible to drain such unneeded packets it rx work without
kicking user, but implemented way is simplest. Anyway, i think
such cases are rare.

    New test also added - it tries to copy to invalid user's
buffer.

Arseny Krasnov (16):
 vhost/vsock: don't set 'seqpacket_has_data()' callback
 vsock/loopback: don't set 'seqpacket_has_data()' callback
 virtio/vsock: don't set 'seqpacket_has_data()' callback
 virtio/vsock: remove 'virtio_transport_seqpacket_has_data'
 af_vsock: use SOCK_STREAM function to check data
 vsock/virtio: remove record size limit for SEQPACKET
 virtio/vsock: don't count EORs on receive
 af_vsock: change SEQPACKET receive loop
 af_vsock/virtio: update dequeue callback interface
 virtio/vsock: update SEQPACKET dequeue logic
 afvsock: add 'seqpacket_drop()'
 virtio/vsock: add 'drop until EOR' logic
 vhost/vsock: enable 'seqpacket_drop' callback in transport
 virtio/vsock: enable 'seqpacket_drop' callback in transport
 vsock/loopback: enable 'seqpacket_drop' callback in transport
 vsock_test: SEQPACKET read to broken buffer

 drivers/vhost/vsock.c                   |   2 +-
 include/linux/virtio_vsock.h            |   7 +-
 include/net/af_vsock.h                  |   4 +-
 net/vmw_vsock/af_vsock.c                |  44 ++++----
 net/vmw_vsock/virtio_transport.c        |   2 +-
 net/vmw_vsock/virtio_transport_common.c | 103 +++++++-----------
 net/vmw_vsock/vsock_loopback.c          |   2 +-
 tools/testing/vsock/vsock_test.c        | 121 ++++++++++++++++++++++
 8 files changed, 194 insertions(+), 91 deletions(-)

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>

-- 
2.25.1

