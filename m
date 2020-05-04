Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A65E1C3B57
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEDNeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:34:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:32040 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgEDNeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:34:07 -0400
IronPort-SDR: UsMMBP7PguiH55XuLP7lePmEB0tq4gm83peyjIm0bk8t+ilRqW+VQZVyVgUSG8tM7kxDhFKWJI
 blodn8Mtet2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 06:34:06 -0700
IronPort-SDR: MtK17wFX62p4N74fZ3wvBuVOJprcv1yXNFJxq6adkwISRUH7pbnqnpoK09kgd6dpBwJPci+eP0
 mkkiuwiHrihg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="406478291"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.47.50])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2020 06:34:03 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 2/2] xsk: remove unnecessary member in xdp_umem
Date:   Mon,  4 May 2020 15:33:52 +0200
Message-Id: <1588599232-24897-3-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
References: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unnecessary member of address in struct xdp_umem as it is
only used during the umem registration. No need to carry this around
as it is not used during run-time nor when unregistering the umem.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h | 1 -
 net/xdp/xdp_umem.c     | 7 +++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index b72f1f4..67191cc 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -50,7 +50,6 @@ struct xdp_umem {
 	u32 headroom;
 	u32 chunk_size_nohr;
 	struct user_struct *user;
-	unsigned long address;
 	refcount_t users;
 	struct work_struct work;
 	struct page **pgs;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 7211f45..37ace3b 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -279,7 +279,7 @@ void xdp_put_umem(struct xdp_umem *umem)
 	}
 }
 
-static int xdp_umem_pin_pages(struct xdp_umem *umem)
+static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 {
 	unsigned int gup_flags = FOLL_WRITE;
 	long npgs;
@@ -291,7 +291,7 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem)
 		return -ENOMEM;
 
 	down_read(&current->mm->mmap_sem);
-	npgs = pin_user_pages(umem->address, umem->npgs,
+	npgs = pin_user_pages(address, umem->npgs,
 			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
 	up_read(&current->mm->mmap_sem);
 
@@ -385,7 +385,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;
 
-	umem->address = (unsigned long)addr;
 	umem->chunk_mask = unaligned_chunks ? XSK_UNALIGNED_BUF_ADDR_MASK
 					    : ~((u64)chunk_size - 1);
 	umem->size = size;
@@ -404,7 +403,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (err)
 		return err;
 
-	err = xdp_umem_pin_pages(umem);
+	err = xdp_umem_pin_pages(umem, (unsigned long)addr);
 	if (err)
 		goto out_account;
 
-- 
2.7.4

