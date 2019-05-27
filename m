Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499782BBA2
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfE0VLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:11:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:23653 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbfE0VLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:11:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 14:11:24 -0700
X-ExtLoop1: 1
Received: from rpedgeco-mobl.amr.corp.intel.com (HELO localhost.intel.com) ([10.251.0.167])
  by orsmga008.jf.intel.com with ESMTP; 27 May 2019 14:11:23 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        sparclinux@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, luto@kernel.org
Cc:     dave.hansen@intel.com, namit@vmware.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v5 0/2] Fix issues with vmalloc flush flag
Date:   Mon, 27 May 2019 14:10:56 -0700
Message-Id: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches address issues with the recently added
VM_FLUSH_RESET_PERMS vmalloc flag.

Patch 1 addresses an issue that could cause a crash after other
architectures besides x86 rely on this path.

Patch 2 addresses an issue where in a rare case strange arguments
could be provided to flush_tlb_kernel_range(). 

v4->v5:
 - Update commit messages with info that the first issue will actually
   not cause problems today
 - Avoid re-use of variable (PeterZ)

v3->v4:
 - Drop patch that switched vm_unmap_alias() calls to regular flush (Andy)
 - Add patch to address correctness previously fixed in dropped patch

v2->v3:
 - Split into two patches (Andy)

v1->v2:
 - Update commit message with more detail
 - Fix flush end range on !CONFIG_ARCH_HAS_SET_DIRECT_MAP case


Rick Edgecombe (2):
  vmalloc: Fix calculation of direct map addr range
  vmalloc: Avoid rare case of flushing tlb with weird arguments

 mm/vmalloc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 
2.20.1

