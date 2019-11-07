Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA30F361E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389772AbfKGRrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:47:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:33463 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730400AbfKGRrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 12:47:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 09:47:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,278,1569308400"; 
   d="scan'208";a="353858399"
Received: from unknown (HELO VM.jf.intel.com) ([10.78.3.78])
  by orsmga004.jf.intel.com with ESMTP; 07 Nov 2019 09:47:52 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, u9012063@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/5] Extend libbpf to support shared umems and Rx|Tx-only sockets
Date:   Thu,  7 Nov 2019 18:47:35 +0100
Message-Id: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set extends libbpf and the xdpsock sample program to
demonstrate the shared umem mode (XDP_SHARED_UMEM) as well as Rx-only
and Tx-only sockets. This in order for users to have an example to use
as a blue print and also so that these modes will be exercised more
frequently.

Note that the user needs to supply an XDP program with the
XDP_SHARED_UMEM mode that distributes the packets over the sockets
according to some policy. There is an example supplied with the
xdpsock program, but there is no default one in libbpf similarly to
when XDP_SHARED_UMEM is not used. The reason for this is that I felt
that supplying one that would work for all users in this mode is
futile. There are just tons of ways to distribute packets, so whatever
I come up with and build into libbpf would be wrong in most cases.

This patch has been applied against commit 30ee348c1267 ("Merge branch 'bpf-libbpf-fixes'")

Structure of the patch set:

Patch 1: Adds shared umem support to libbpf
Patch 2: Shared umem support and example XPD program added to xdpsock sample
Patch 3: Adds Rx-only and Tx-only support to libbpf
Patch 4: Uses Rx-only sockets for rxdrop and Tx-only sockets for txpush in
         the xdpsock sample
Patch 5: Add documentation entries for these two features

Thanks: Magnus

Magnus Karlsson (5):
  libbpf: support XDP_SHARED_UMEM with external XDP program
  samples/bpf: add XDP_SHARED_UMEM support to xdpsock
  libbpf: allow for creating Rx or Tx only AF_XDP sockets
  samples/bpf: use Rx-only and Tx-only sockets in xdpsock
  xsk: extend documentation for Rx|Tx-only sockets and shared umems

 Documentation/networking/af_xdp.rst |  28 +++++--
 samples/bpf/Makefile                |   1 +
 samples/bpf/xdpsock.h               |  11 +++
 samples/bpf/xdpsock_kern.c          |  24 ++++++
 samples/bpf/xdpsock_user.c          | 158 ++++++++++++++++++++++++++----------
 tools/lib/bpf/xsk.c                 |  32 +++++---
 6 files changed, 195 insertions(+), 59 deletions(-)
 create mode 100644 samples/bpf/xdpsock.h
 create mode 100644 samples/bpf/xdpsock_kern.c

--
2.7.4
