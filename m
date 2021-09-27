Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE71E4193F1
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhI0MSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234162AbhI0MRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E18C61002;
        Mon, 27 Sep 2021 12:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632744975;
        bh=VLo/T7QE7PzxvCAvdD1Dx6SHSPfV7VXt+9sxJ8jwEdY=;
        h=From:To:Cc:Subject:Date:From;
        b=jiflBaFmGv0Wu3oK+iueZyRJ55VwwX9vyZeFt788/RY4FibsFj3Yfcniw3mRgn1P1
         UPMUkcJ7N1KhwNeKeZHurdBjEnRW87BgiNbPsaUsjsQlQspNEOSkczWnKN9X/nx3TN
         KKPoLgkhTZIquV2ZWTSG4ICRDfSd4EE9f42ibgPrrICx684BTza2m3gefFvx64yFUT
         l71jotSFZ6RWl1Wm8tShtCYyU3FacgteXG2MF1G3Tb4kApaFsXxmGDEVTXp9FkMBqX
         hyaJe9mOfWyuDo931hyPKiSoNnTtBUI/yic3oyy2qZejhhXNt7skFkwjvZfH3CvIKr
         xV/d30/DIRj8A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] cxgb: avoid open-coded offsetof()
Date:   Mon, 27 Sep 2021 14:16:04 +0200
Message-Id: <20210927121611.940046-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang-14 does not like the custom offsetof() macro in vsc7326:

drivers/net/ethernet/chelsio/cxgb/vsc7326.c:597:3: error: performing pointer subtraction with a null pointer has undefined behavior [-Werror,-Wnull-pointer-subtraction]
                HW_STAT(RxUnicast, RxUnicastFramesOK),
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/cxgb/vsc7326.c:594:56: note: expanded from macro 'HW_STAT'
        { reg, (&((struct cmac_statistics *)NULL)->stat_name) - (u64 *)NULL }

Rewrite this to use the version provided by the kernel.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/chelsio/cxgb/vsc7326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/vsc7326.c b/drivers/net/ethernet/chelsio/cxgb/vsc7326.c
index 873c1c7b4ca0..a19284bdb80e 100644
--- a/drivers/net/ethernet/chelsio/cxgb/vsc7326.c
+++ b/drivers/net/ethernet/chelsio/cxgb/vsc7326.c
@@ -591,7 +591,7 @@ static void port_stats_update(struct cmac *mac)
 	} hw_stats[] = {
 
 #define HW_STAT(reg, stat_name) \
-	{ reg, (&((struct cmac_statistics *)NULL)->stat_name) - (u64 *)NULL }
+	{ reg, offsetof(struct cmac_statistics, stat_name) / sizeof(u64) }
 
 		/* Rx stats */
 		HW_STAT(RxUnicast, RxUnicastFramesOK),
-- 
2.29.2

