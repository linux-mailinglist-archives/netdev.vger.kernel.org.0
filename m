Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6772ACB28
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgKJCdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:33:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbgKJCdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 21:33:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJT2-006CsX-4N; Tue, 10 Nov 2020 03:33:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next v2] drivers: net: sky2: Fix -Wstringop-truncation with W=1
Date:   Tue, 10 Nov 2020 03:32:22 +0100
Message-Id: <20201110023222.1479398-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function ‘strncpy’,
    inlined from ‘sky2_name’ at drivers/net/ethernet/marvell/sky2.c:4903:3,
    inlined from ‘sky2_probe’ at drivers/net/ethernet/marvell/sky2.c:5049:2:
./include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ specified bound 16 equals destination size [-Wstringop-truncation]

None of the device names are 16 characters long, so it was never an
issue. But replace the strncpy with an snprintf() to prevent the
theoretical overflow.

Suggested-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 25981a7a43b5..ebe1406c6e64 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4900,7 +4900,7 @@ static const char *sky2_name(u8 chipid, char *buf, int sz)
 	};
 
 	if (chipid >= CHIP_ID_YUKON_XL && chipid <= CHIP_ID_YUKON_OP_2)
-		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
+		snprintf(buf, sz, "%s", name[chipid - CHIP_ID_YUKON_XL]);
 	else
 		snprintf(buf, sz, "(chip %#x)", chipid);
 	return buf;
-- 
2.29.2

