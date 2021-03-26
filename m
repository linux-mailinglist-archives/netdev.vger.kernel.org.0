Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58C934AACB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCZPCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:02:22 -0400
Received: from mga14.intel.com ([192.55.52.115]:38760 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCZPBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 11:01:45 -0400
IronPort-SDR: GpNRukFeWwIq3xziefinuJiHRwPJxk4HsVRcTSzljUfRk2t6T/wP4tbcPh3EO/0QktMKQQqik4
 yShAlKXMLJAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190602879"
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="190602879"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 08:01:16 -0700
IronPort-SDR: JTrU6yK2TrvtqcKrjegulx+hmrWVgIkBmj8DX5Q7Nexn6zbp4M73c4yHEkiKchkVcaGn6WtP+C
 rxCh2yuaGfYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="382668256"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2021 08:01:14 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        magnus.karlsson@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v2 bpf 0/3] AF_XDP Socket Creation Fixes
Date:   Fri, 26 Mar 2021 14:29:43 +0000
Message-Id: <20210326142946.5263-1-ciara.loftus@intel.com>
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
succeed even if the rx and tx XDP rings have already been set up, by
ignoring the return value of the XDP_RX_RING/XDP_TX_RING setsockopt.
This removes a limitation which existed whereby a user could not retry
socket creation after a previous failed attempt.

It was chosen to solve the problem by ignoring the return values in
libbpf instead of modifying the setsockopt handling code in the kernel
in order to make it possible for the solution to be available across
all kernels, provided a new enough libbpf is available.

v1->v2:
* Simplified restoring the _save pointers as suggested by Magnus
  Karlsson.
* Fixed the condition which determines whether to unmap umem rings
  when socket create fails.

This series applies on commit 6032ebb54c60cae24329f6aba3ce0c1ca8ad6abe


Ciara Loftus (3):
  libbpf: ensure umem pointer is non-NULL before dereferencing
  libbpf: restore umem state after socket create failure
  libbpf: ignore return values of setsockopt for XDP rings.

 tools/lib/bpf/xsk.c | 66 ++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

-- 
2.17.1

