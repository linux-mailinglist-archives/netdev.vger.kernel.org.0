Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA73025980
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfEUUxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:53:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:29665 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbfEUUxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 16:53:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 13:53:16 -0700
X-ExtLoop1: 1
Received: from rpedgeco-mobl.amr.corp.intel.com (HELO localhost.intel.com) ([10.254.91.116])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2019 13:53:16 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        sparclinux@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, luto@kernel.org
Cc:     dave.hansen@intel.com, namit@vmware.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v4 0/2] Fix issues with vmalloc flush flag
Date:   Tue, 21 May 2019 13:51:35 -0700
Message-Id: <20190521205137.22029-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches address issues with the recently added
VM_FLUSH_RESET_PERMS vmalloc flag.

Patch 1 is the most critical and addresses an issue that could cause a
crash on x86.

Patch 2 addresses an issue where in a rare case strange arguments
could be provided to flush_tlb_kernel_range(). Most arch's should be
fine with it, but some may not like them, so we should avoid doing
this.

v3->v4:
 - Drop patch that switched vm_unmap_alias() calls to regular flush
 - Add patch to address correctness previously fixed in dropped patch

v2->v3:
 - Split into two patches

v1->v2:
 - Update commit message with more detail
 - Fix flush end range on !CONFIG_ARCH_HAS_SET_DIRECT_MAP case

Rick Edgecombe (2):
  vmalloc: Fix calculation of direct map addr range
  vmalloc: Avoid rare case of flushing tlb with weird arguements

 mm/vmalloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.20.1

