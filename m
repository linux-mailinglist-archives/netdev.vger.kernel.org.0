Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138452A1905
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgJaRkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:40:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgJaRkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 13:40:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYurm-004X5u-Tv; Sat, 31 Oct 2020 18:40:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] drivers: net: sky2: Fix -Wstringop-truncation with W=1
Date:   Sat, 31 Oct 2020 18:40:28 +0100
Message-Id: <20201031174028.1080476-1-andrew@lunn.ch>
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
issue, but reduce the length of the buffer size by one to avoid the
warning.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 25981a7a43b5..35b0ec5afe13 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4900,7 +4900,7 @@ static const char *sky2_name(u8 chipid, char *buf, int sz)
 	};
 
 	if (chipid >= CHIP_ID_YUKON_XL && chipid <= CHIP_ID_YUKON_OP_2)
-		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
+		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz - 1);
 	else
 		snprintf(buf, sz, "(chip %#x)", chipid);
 	return buf;
-- 
2.28.0

