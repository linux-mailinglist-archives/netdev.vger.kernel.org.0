Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3623C3A7E41
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFOMhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhFOMhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 08:37:18 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1710C061574;
        Tue, 15 Jun 2021 05:35:13 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4G477f1GRTz9sW6; Tue, 15 Jun 2021 22:35:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1623760510;
        bh=7KFvbFbAzZ/KiBKex4+L6XeZPvYKTbTsjpLGWY2fjo8=;
        h=From:To:Cc:Subject:Date:From;
        b=B5qH3Fyp9L7z8XKw9Q6liWDUnL0/ouV/i3DbvCd8lBR8qtjikqdeQAM7zBFCEZycB
         hnKeuNHyC47xVQ3fqYfkxCPDLT3/BU89tt6EddgGE/ALpieCsq08aYrlR2UGB/tCdc
         c8GyE5xOl+XJinrDneTL1wqVJud1zV+/VZw1FDvBPi5cLWtduUUbfa69Q6R5GV5a+y
         W/tiJFoEaII10GaeU4T8VOwDvwAxCSgE9FWYQ41zB4EwS1Uqn5q/vlrVTe57TSzKcC
         WuBf114RpppT756EZXKNI2Rt6K4MwIfyY57yfN4+YuDg0ZjYow5k2+vLZvL7LKEvlH
         VtTaIpnXgxugA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pv-drivers@vmware.com, doshir@vmware.com,
        christophe.leroy@csgroup.eu
Subject: [PATCH] vmxnet3: prevent building with 256K pages
Date:   Tue, 15 Jun 2021 22:35:04 +1000
Message-Id: <20210615123504.547106-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver assigns PAGE_SIZE to a u16, which can't work when the page
size is 256K. As reported by lkp:

 drivers/net/vmxnet3/vmxnet3_drv.c: In function 'vmxnet3_rq_init':
 arch/powerpc/include/asm/page.h:24:20: warning: conversion from 'long unsigned int' to 'u16' changes value from '262144' to '0'
 drivers/net/vmxnet3/vmxnet3_drv.c:1784:29: note: in expansion of macro 'PAGE_SIZE'
  1784 |    rq->buf_info[0][i].len = PAGE_SIZE;
                                     ^~~~~~~~~

Simliar to what was done previously in commit fbdf0e28d061 ("vmxnet3:
prevent building with 64K pages"), prevent the driver from building when
256K pages are enabled.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 74dc8e249faa..da46898f060a 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -549,7 +549,7 @@ config VMXNET3
 	depends on PCI && INET
 	depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
 		     IA64_PAGE_SIZE_64KB || MICROBLAZE_64K_PAGES || \
-		     PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES)
+		     PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES || PPC_256K_PAGES)
 	help
 	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
 	  To compile this driver as a module, choose M here: the
-- 
2.25.1

