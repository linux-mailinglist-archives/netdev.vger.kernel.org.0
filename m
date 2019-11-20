Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1A9103108
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfKTBPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:15:02 -0500
Received: from ozlabs.org ([203.11.71.1]:48151 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbfKTBPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 20:15:02 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47Hl9F1zQwz9sPW; Wed, 20 Nov 2019 12:14:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1574212497;
        bh=LsELJmCEH+NKbFlJOW2HIaU1dLS5CTN3LAfLHJrRp2M=;
        h=From:To:Cc:Subject:Date:From;
        b=TK4FU2ZS28s8JR8kdTv+V/MJZt0OSyR8/XkbK0R5J1TCOCNnr8lJPdR4YSt48b2qt
         yd9HSQTeVgwf7vwN4LcDTrPIE3l0jMjaGbi0hYk9yMFXpVvxjH83WjEIwsC+mU/Hsm
         r9WsuHLCP/BDVy6PpS3dr4XIXc2+TSSuDK48hxwiXBq9ucB+b7FgMGBtMCoP/keChM
         bh9KTgf/2eYbZLoHnrD0z3MYLYWCdSDEehl+WM1mbdrBCoJpbxUx/FRDMg7sizXqAb
         v9Dgr5BznEMQ9x0HYraW+Y5Ow2a8Qp1F8R8A5kQp6wgkSdD7d62ivv6Bom14nDRghM
         2Ek0HwtDxMTAw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org
Subject: [PATCH v2] powerpc: Add const qual to local_read() parameter
Date:   Wed, 20 Nov 2019 12:14:51 +1100
Message-Id: <20191120011451.28168-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

A patch in net-next triggered a compile error on powerpc:

  include/linux/u64_stats_sync.h: In function 'u64_stats_read':
  include/asm-generic/local64.h:30:37: warning: passing argument 1 of 'local_read' discards 'const' qualifier from pointer target type

This seems reasonable to relax powerpc local_read() requirements.

Fixes: 316580b69d0a ("u64_stats: provide u64_stats_t type")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: mpe: Update change log with compiler warning, resend to netdev so it appears
in the netdev patchwork.

Dave can you take this in the net tree so the window of the breakage is as small
as possible please?

diff --git a/arch/powerpc/include/asm/local.h b/arch/powerpc/include/asm/local.h
index fdd00939270b..bc4bd19b7fc2 100644
--- a/arch/powerpc/include/asm/local.h
+++ b/arch/powerpc/include/asm/local.h
@@ -17,7 +17,7 @@ typedef struct
 
 #define LOCAL_INIT(i)	{ (i) }
 
-static __inline__ long local_read(local_t *l)
+static __inline__ long local_read(const local_t *l)
 {
 	return READ_ONCE(l->v);
 }
-- 
2.21.0

