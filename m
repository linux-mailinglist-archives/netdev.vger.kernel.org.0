Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE6E34F8ED
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhCaGoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:44:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:14630 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233693AbhCaGn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 02:43:58 -0400
IronPort-SDR: rF0uF3r4GYH9CAKHdpfoUG7aCaReqt+bSXwaGbw8v45wAbxMhEQf0V4zHwHPbDqtrX9Cc5wg9J
 BiBsq4KvO5ww==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277111325"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="277111325"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 23:43:57 -0700
IronPort-SDR: jXuYTlROpZ8rTLnlx2ka6f4SNEfUpzvyKQQgI8DhY5W4+dSbaf93PB7CcwDjVscTD1cPeh5bvT
 VQrhhdJyTJkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="445523139"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2021 23:43:56 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        alexei.starovoitov@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v4 bpf 0/3] AF_XDP Socket Creation Fixes
Date:   Wed, 31 Mar 2021 06:12:15 +0000
Message-Id: <20210331061218.1647-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some issues around socket creation for AF_XDP.

Patch 1 fixes a potential NULL pointer dereference in
xsk_socket__create_shared.

Patch 2 ensures that the umem passed to xsk_socket__create(_shared)
remains unchanged in event of failure.

Patch 3 makes it possible for xsk_socket__create(_shared) to
succeed even if the rx and tx XDP rings have already been set up by
introducing a new fields to struct xsk_umem which represent the ring
setup status for the xsk which shares the fd with the umem.

v3->v4:
* Reduced nesting in xsk_put_ctx as suggested by Alexei.
* Use bools instead of a u8 and flags to represent the
  ring setup status as suggested by Björn.

v2->v3:
* Instead of ignoring the return values of the setsockopt calls, introduce
  a new flag to determine whether or not to call them based on the ring
  setup status as suggested by Alexei.

v1->v2:
* Simplified restoring the _save pointers as suggested by Magnus.
* Fixed the condition which determines whether to unmap umem rings
 when socket create fails.

This series applies on commit 861de02e5f3f2a104eecc5af1d248cb7bf8c5f75

Ciara Loftus (3):
  libbpf: ensure umem pointer is non-NULL before dereferencing
  libbpf: restore umem state after socket create failure
  libbpf: only create rx and tx XDP rings when necessary

 tools/lib/bpf/xsk.c | 57 +++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

-- 
2.17.1

