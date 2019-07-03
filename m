Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A755DBEE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfGCCS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbfGCCSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 22:18:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F195218A0;
        Wed,  3 Jul 2019 02:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120304;
        bh=NrNrLPrjbBVDH5J11hyHUnSZxxKaCToBkjZk5A0ooqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2c0XXZMwBLQFD3l/FUCp+MiX5ZRGgBM68/V7k1PN+36uhq958zLxFCH7Dr/p2K9ZO
         bQs7IkREpDvLgxLxihpY4uOrIf7PmgghMGVZxCm1CJP3rBhvi7gXzk5T3GwW8cTzvu
         HRoamR9p+qmU3hRQO8AeCxDhD5duIZFzIrkOulEE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roland Hii <roland.king.guan.hii@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/13] net: stmmac: fixed new system time seconds value calculation
Date:   Tue,  2 Jul 2019 22:18:08 -0400
Message-Id: <20190703021814.18385-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021814.18385-1-sashal@kernel.org>
References: <20190703021814.18385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roland Hii <roland.king.guan.hii@intel.com>

[ Upstream commit a1e5388b4d5fc78688e5e9ee6641f779721d6291 ]

When ADDSUB bit is set, the system time seconds field is calculated as
the complement of the seconds part of the update value.

For example, if 3.000000001 seconds need to be subtracted from the
system time, this field is calculated as
2^32 - 3 = 4294967296 - 3 = 0x100000000 - 3 = 0xFFFFFFFD

Previously, the 0x100000000 is mistakenly written as 100000000.

This is further simplified from
  sec = (0x100000000ULL - sec);
to
  sec = -sec;

Fixes: ba1ffd74df74 ("stmmac: fix PTP support for GMAC4")
Signed-off-by: Roland Hii <roland.king.guan.hii@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 08c19ebd5306..41d528fbebb4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -121,7 +121,7 @@ static int stmmac_adjust_systime(void __iomem *ioaddr, u32 sec, u32 nsec,
 		 * programmed with (2^32 – <new_sec_value>)
 		 */
 		if (gmac4)
-			sec = (100000000ULL - sec);
+			sec = -sec;
 
 		value = readl(ioaddr + PTP_TCR);
 		if (value & PTP_TCR_TSCTRLSSR)
-- 
2.20.1

