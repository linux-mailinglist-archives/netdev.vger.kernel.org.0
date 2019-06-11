Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD53C9D7
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389180AbfFKLQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:16:55 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:40286 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387519AbfFKLQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:16:55 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5BBGg0A111081;
        Tue, 11 Jun 2019 06:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1560251802;
        bh=ymb68AYJr6qOFYNX8+pGpasWhJJh3G+q893ggNbXIfs=;
        h=From:To:CC:Subject:Date;
        b=ieZyKDuEirJDSUPqZk+s9RPf0XuZbf/3ldOM3ZPQ37TjF6kTSnuKI2/qg9y5CA3P8
         bEeRcaY4IzLCI/wrF7VA1/24nnbRVQx1ts/2CO92ZlbOVaTWfH+Ug2zrzm++lYMZ/0
         wwNhWAxvQ9Rl/6hnW4/stGmL5zt1GSGagn9zYQHU=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5BBGg7F110971
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Jun 2019 06:16:42 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 11
 Jun 2019 06:16:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 11 Jun 2019 06:16:41 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5BBGesC057695;
        Tue, 11 Jun 2019 06:16:41 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <netdev@vger.kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-next@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RESEND PATCH net-next] net: ethernet: ti: cpts: fix build failure for powerpc
Date:   Tue, 11 Jun 2019 14:16:32 +0300
Message-ID: <20190611111632.9444-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dependency to TI CPTS from Common CLK framework COMMON_CLK to fix
allyesconfig build for Powerpc:

drivers/net/ethernet/ti/cpts.c: In function 'cpts_of_mux_clk_setup':
drivers/net/ethernet/ti/cpts.c:567:2: error: implicit declaration of function 'of_clk_parent_fill'; did you mean 'of_clk_get_parent_name'? [-Werror=implicit-function-declaration]
  of_clk_parent_fill(refclk_np, parent_names, num_parents);
  ^~~~~~~~~~~~~~~~~~
  of_clk_get_parent_name

Fixes: a3047a81ba13 ("net: ethernet: ti: cpts: add support for ext rftclk selection")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 Resending due to missed netdev@vger.kernel.org list in prev post.

 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index bd05a977ee7e..a800d3417411 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -60,6 +60,7 @@ config TI_CPSW
 config TI_CPTS
 	bool "TI Common Platform Time Sync (CPTS) Support"
 	depends on TI_CPSW || TI_KEYSTONE_NETCP || COMPILE_TEST
+	depends on COMMON_CLK
 	depends on POSIX_TIMERS
 	---help---
 	  This driver supports the Common Platform Time Sync unit of
-- 
2.17.1

