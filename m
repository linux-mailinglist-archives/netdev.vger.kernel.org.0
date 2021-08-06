Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF93E2AF1
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343852AbhHFMua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:50:30 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:55206
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343844AbhHFMtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 08:49:50 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id B1A773F0A3;
        Fri,  6 Aug 2021 12:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628254172;
        bh=xLL7KcCcVibNluvYyGE+ueFwARuKpLLEcqYrSzigE5U=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=bR2M1qwA5Xf9NWVVRqMjdx479fRGFjSBBNtoK/YxI+/nG9o1IsuGZtlC4mZZhzfXT
         q60WXROLI6xZVd1ic6CJjaeCmniyGpRcsLxR1ggJV+UlLky4Ipj8Yk9oTFOXE8SYi+
         QfEtekE0XHlXrd1wveJG9lI4RxFsm2dOt1EDNzHUYGwANgTl/kibrINvzNzgtbgL0k
         RpVM1dOMQC4lM8dv15Eq8IIYA0frxt2Q+rre02I4DKTIRXj74t/748WmRUE3CKjeci
         NLtPKAb40OFbww9PuZL47PXo0w7WeLSDsZKjCd1fokppFTiJEEuqj0QTIRnqavS3Js
         WQw7DHKveDrpg==
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tulip: Remove deadcode on startup true condition
Date:   Fri,  6 Aug 2021 13:49:32 +0100
Message-Id: <20210806124932.14981-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The true check on the variable startable in the ternary operator
is always false because the previous if statement handles the true
condition for startable. Hence the ternary check is dead code and
can be removed.

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/dec/tulip/media.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/media.c b/drivers/net/ethernet/dec/tulip/media.c
index 011604787b8e..55d6fc99f40b 100644
--- a/drivers/net/ethernet/dec/tulip/media.c
+++ b/drivers/net/ethernet/dec/tulip/media.c
@@ -355,21 +355,21 @@ void tulip_select_media(struct net_device *dev, int startup)
 		} else if (startup) {
 			/* Start with 10mbps to do autonegotiation. */
 			iowrite32(0x32, ioaddr + CSR12);
 			new_csr6 = 0x00420000;
 			iowrite32(0x0001B078, ioaddr + 0xB8);
 			iowrite32(0x0201B078, ioaddr + 0xB8);
 		} else if (dev->if_port == 3  ||  dev->if_port == 5) {
 			iowrite32(0x33, ioaddr + CSR12);
 			new_csr6 = 0x01860000;
 			/* Trigger autonegotiation. */
-			iowrite32(startup ? 0x0201F868 : 0x0001F868, ioaddr + 0xB8);
+			iowrite32(0x0001F868, ioaddr + 0xB8);
 		} else {
 			iowrite32(0x32, ioaddr + CSR12);
 			new_csr6 = 0x00420000;
 			iowrite32(0x1F078, ioaddr + 0xB8);
 		}
 	} else {					/* Unknown chip type with no media table. */
 		if (tp->default_port == 0)
 			dev->if_port = tp->mii_cnt ? 11 : 3;
 		if (tulip_media_cap[dev->if_port] & MediaIsMII) {
 			new_csr6 = 0x020E0000;
-- 
2.31.1

