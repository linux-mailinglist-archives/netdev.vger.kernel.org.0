Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3771821F50
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfEQVFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 17:05:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:33100 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbfEQVFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 17:05:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 14:05:09 -0700
X-ExtLoop1: 1
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by fmsmga004.fm.intel.com with ESMTP; 17 May 2019 14:05:09 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     peterz@infradead.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     dave.hansen@intel.com, namit@vmware.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 0/1] Fix for VM_FLUSH_RESET_PERMS on sparc
Date:   Fri, 17 May 2019 14:01:22 -0700
Message-Id: <20190517210123.5702-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meelis Roos reported issues with the new VM_FLUSH_RESET_PERMS flag on the sparc
architecture. When freeing many BPF JITs simultaneously, the vfree flush
operations can become stuck waiting as they each try to vm_unmap_aliases().

It also came up that using this flag is not needed for architectures like sparc
that already have normal kernel memory as executable. This patch fixes the usage
of this flag on sparc to also fix it in case the root cause is also an issue on
other architectures. Separately we can disable usage of VM_FLUSH_RESET_PERMS for
these architectures if desired.

Rick Edgecombe (1):
  vmalloc: Fix issues with flush flag

 mm/vmalloc.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

-- 
2.17.1

