Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6A214F65
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgGEUgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:36:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgGEUgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 16:36:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsBNP-003k2O-T8; Sun, 05 Jul 2020 22:36:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/3] dsa: bmc_sf2: Pass GENMASK() signed bits
Date:   Sun,  5 Jul 2020 22:36:25 +0200
Message-Id: <20200705203625.891900-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705203625.891900-1-andrew@lunn.ch>
References: <20200705203625.891900-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oddly, GENMASK() requires signed bit numbers, so that it can compare
them for < 0. If passed an unsigned type, we get warnings about the
test never being true. There is no danger of overflow here, udf is
always a u8, so there is plenty of space when expanding to an int.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index b54339477853..d82cee5d9202 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -128,12 +128,12 @@ static inline unsigned int bcm_sf2_get_num_udf_slices(const u8 *layout)
 	return count;
 }
 
-static inline u32 udf_upper_bits(unsigned int num_udf)
+static inline u32 udf_upper_bits(int num_udf)
 {
 	return GENMASK(num_udf - 1, 0) >> (UDFS_PER_SLICE - 1);
 }
 
-static inline u32 udf_lower_bits(unsigned int num_udf)
+static inline u32 udf_lower_bits(int num_udf)
 {
 	return (u8)GENMASK(num_udf - 1, 0);
 }
-- 
2.27.0.rc2

