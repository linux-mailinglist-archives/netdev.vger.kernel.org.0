Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665D31BFB6D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgD3N7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgD3NyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24B4624959;
        Thu, 30 Apr 2020 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254864;
        bh=Z/2kThsrIUdaBeMiovI4HEPKPp2VcWA9SpoOHsJnMiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwcOqPeInug2PzDN4qHDpBjRLUtSu6jNaIlr6xvwoVNTcA6JzGA4mAx0m/3VCHEMv
         jVlDVMKcgogfhrpdBQb28K7DhIWGz+Gm1eg9duFeJ9TuFevGHLasTSizcayiQ8EPvD
         l8CKKFfVEsJW7SY2Vwr1X5GdphhsxHWaty0wbFE4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/27] net: dsa: b53: Fix ARL register definitions
Date:   Thu, 30 Apr 2020 09:53:55 -0400
Message-Id: <20200430135402.20994-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135402.20994-1-sashal@kernel.org>
References: <20200430135402.20994-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c2e77a18a7ed65eb48f6e389b6a59a0fd753646a ]

The ARL {MAC,VID} tuple and the forward entry were off by 0x10 bytes,
which means that when we read/wrote from/to ARL bin index 0, we were
actually accessing the ARLA_RWCTRL register.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index e5c86d44667af..1b2a337d673dd 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -294,7 +294,7 @@
  *
  * BCM5325 and BCM5365 share most definitions below
  */
-#define B53_ARLTBL_MAC_VID_ENTRY(n)	(0x10 * (n))
+#define B53_ARLTBL_MAC_VID_ENTRY(n)	((0x10 * (n)) + 0x10)
 #define   ARLTBL_MAC_MASK		0xffffffffffffULL
 #define   ARLTBL_VID_S			48
 #define   ARLTBL_VID_MASK_25		0xff
@@ -306,7 +306,7 @@
 #define   ARLTBL_VALID_25		BIT(63)
 
 /* ARL Table Data Entry N Registers (32 bit) */
-#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x08)
+#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x18)
 #define   ARLTBL_DATA_PORT_ID_MASK	0x1ff
 #define   ARLTBL_TC(tc)			((3 & tc) << 11)
 #define   ARLTBL_AGE			BIT(14)
-- 
2.20.1

