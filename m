Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45537DF03
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbfHAPZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfHAPZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:25:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB92272683;
        Thu,  1 Aug 2019 15:25:47 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4F636A762;
        Thu,  1 Aug 2019 15:25:42 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/11] VSOCK: add vsock_test test suite
Date:   Thu,  1 Aug 2019 17:25:30 +0200
Message-Id: <20190801152541.245833-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 01 Aug 2019 15:25:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vsock_diag.ko module already has a test suite but the core AF_VSOCK
functionality has no tests.  This patch series adds several test cases that
exercise AF_VSOCK SOCK_STREAM socket semantics (send/recv, connect/accept,
half-closed connections, simultaneous connections).

Stefan: Do you think we should have a single application or is better to
split it in single tests (e.g. vsock_test_send_recv, vsock_test_half_close,
vsock_test_multiconnection, etc.)?

Jorgen: Please test the VMCI transport and let me know if the fixes work.
I added the '--transport' parameter to skip the read() on the half-closed
connection test.

Dexuan: Do you think can be useful to test HyperV?

The v1 of this series was originally sent by Stefan. I rebased on master
and tried to fix some issues reported by Jorgen.

v2:
- Patch 1 added by Stefan to fix header include in vsock_diag_test.
- Patch 2 added by Stefan to add SPDX identifiers. I modified it to be
  aligned with SPDX currently used on master.
- Patch 3:
  * fixed SPDX [Stefano].
- Patch 7:
  * Drop unnecessary includes [Stefan]
  * Fixed SPDX [Stefano]
  * Set MULTICONN_NFDS to 100 [Stefano]
  * Changed (i % 1) in (i % 2) in the 'multiconn' test [Stefano]
- Patches 8,9,10 added to skip read after close in test_stream*close tests
  on a VMCI host.
- Patch 11 added to wait for the remote to close the connection, before
  check if a send returns -EPIPE.

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
  VSOCK: add vsock_get_local_cid() test utility
  vsock_test: add --transport parameter
  vsock_test: skip read() in test_stream*close tests on a VMCI host
  vsock_test: wait for the remote to close the connection

 tools/testing/vsock/.gitignore        |   1 +
 tools/testing/vsock/Makefile          |   9 +-
 tools/testing/vsock/README            |   3 +-
 tools/testing/vsock/control.h         |   1 +
 tools/testing/vsock/timeout.h         |   1 +
 tools/testing/vsock/util.c            | 342 ++++++++++++++++++++++++
 tools/testing/vsock/util.h            |  54 ++++
 tools/testing/vsock/vsock_diag_test.c | 170 ++----------
 tools/testing/vsock/vsock_test.c      | 362 ++++++++++++++++++++++++++
 9 files changed, 793 insertions(+), 150 deletions(-)
 create mode 100644 tools/testing/vsock/util.c
 create mode 100644 tools/testing/vsock/util.h
 create mode 100644 tools/testing/vsock/vsock_test.c

-- 
2.20.1

