Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09EE125056
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfLRSIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:08:46 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727346AbfLRSH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nmdGUwTvoHp9zBzsfUh31MNBzW9ZhcHvi1/dZfx3TSc=;
        b=alv/XHTQ1KgJFx03lzHymIYJVHBWkdQ98n1X09YzyJFuLots2ClgFqAn7CuxEHljqTJpSs
        HrMrh6g+ltr7IUvQyMWmd8rK09CcYuMPE0oTFEgXom3py2mg+MSLPX/oMD9nn10iudFwBg
        dTQc84cctCtCe2vXvILN+xJyncAuYNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-bjYQnByeNymkKKOVYrH73A-1; Wed, 18 Dec 2019 13:07:17 -0500
X-MC-Unique: bjYQnByeNymkKKOVYrH73A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1626E1088381;
        Wed, 18 Dec 2019 18:07:16 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1592E5D9E2;
        Wed, 18 Dec 2019 18:07:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 00/11] VSOCK: add vsock_test test suite
Date:   Wed, 18 Dec 2019 19:06:57 +0100
Message-Id: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vsock_diag.ko module already has a test suite but the core AF_VSOCK
functionality has no tests. This patch series adds several test cases tha=
t
exercise AF_VSOCK SOCK_STREAM socket semantics (send/recv, connect/accept=
,
half-closed connections, simultaneous connections).

The v1 of this series was originally sent by Stefan.

v3:
- Patch 6:
  * check the byte received in the recv_byte()
  * use send(2)/recv(2) instead of write(2)/read(2) to test also flags
    (e.g. MSG_PEEK)
- Patch 8:
  * removed unnecessary control_expectln("CLOSED") [Stefan].
- removed patches 9,10,11 added in the v2
- new Patch 9 add parameters to list and skip tests (e.g. useful for vmci
  that doesn't support half-closed socket in the host)
- new Patch 10 prints a list of options in the help
- new Patch 11 tests MSG_PEEK flags of recv(2)

v2: https://patchwork.ozlabs.org/cover/1140538/
v1: https://patchwork.ozlabs.org/cover/847998/

Stefan Hajnoczi (7):
  VSOCK: fix header include in vsock_diag_test
  VSOCK: add SPDX identifiers to vsock tests
  VSOCK: extract utility functions from vsock_diag_test.c
  VSOCK: extract connect/accept functions from vsock_diag_test.c
  VSOCK: add full barrier between test cases
  VSOCK: add send_byte()/recv_byte() test utilities
  VSOCK: add AF_VSOCK test cases

Stefano Garzarella (4):
  vsock_test: wait for the remote to close the connection
  testing/vsock: add parameters to list and skip tests
  testing/vsock: print list of options and description
  vsock_test: add SOCK_STREAM MSG_PEEK test

 tools/testing/vsock/.gitignore        |   1 +
 tools/testing/vsock/Makefile          |   9 +-
 tools/testing/vsock/README            |   3 +-
 tools/testing/vsock/control.c         |  15 +-
 tools/testing/vsock/control.h         |   2 +
 tools/testing/vsock/timeout.h         |   1 +
 tools/testing/vsock/util.c            | 376 +++++++++++++++++++++++++
 tools/testing/vsock/util.h            |  49 ++++
 tools/testing/vsock/vsock_diag_test.c | 202 ++++----------
 tools/testing/vsock/vsock_test.c      | 379 ++++++++++++++++++++++++++
 10 files changed, 883 insertions(+), 154 deletions(-)
 create mode 100644 tools/testing/vsock/util.c
 create mode 100644 tools/testing/vsock/util.h
 create mode 100644 tools/testing/vsock/vsock_test.c

--=20
2.24.1

