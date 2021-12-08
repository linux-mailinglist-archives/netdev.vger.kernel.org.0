Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA1C46CDBA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbhLHGb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:31:27 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:57542 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbhLHGb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:31:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=cU7a7l2hUokyjWAVxGR44X/SZoxT7Ra+h9paRR3oMk8=;
        b=RKz31+dhMlqjVtbHKq3Wkm+rsoOCTedN2hh2w6Qt4IhHNEr6zJ4KHdfbEUaJsmYOojf+
        to0u/CCPVNkrJi/kdWANeS1x955qFm3Vlk9Hg6wMcF8qEsVbWXkuIULi5VZAtu9NRVqyiW
        tggNCt5IwMAcCYVHLl7+p6scR/jkuXuLQq09zKDSJXEWO/nci3WQOgIFn+wdh2znidhkBP
        bR4XfEttWxX1euFO9z2M1uVeyhEa86C+EX5Qj9dqJhgIF/XpIZQGupd3mwRosTXutUKVJk
        r2Md0Rezyn9kkKBit6Ab09CUouGUwQ88dGJYQBSGLvxYN5S9Rfu3af0A66TpLP8Q==
Received: by filterdrecv-7bc86b958d-n76s9 with SMTP id filterdrecv-7bc86b958d-n76s9-1-61B0506A-31
        2021-12-08 06:27:55.052284633 +0000 UTC m=+8410090.793158700
Received: from pearl.egauge.net (unknown)
        by ismtpd0057p1las1.sendgrid.net (SG) with ESMTP
        id NpgNFnvoT5aqygQKbqhhUA
        Wed, 08 Dec 2021 06:27:54.773 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id CE68E700371; Tue,  7 Dec 2021 23:27:53 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH] wilc1000: Fix spurious "FW not responding" error
Date:   Wed, 08 Dec 2021 06:27:55 +0000 (UTC)
Message-Id: <20211208062747.3405221-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLjPqF1dYkzQ4i9aT?=
 =?us-ascii?Q?AfhF9bpA1AGHFo=2FBAzRPqqedO32QpdHnxgt4WSB?=
 =?us-ascii?Q?QT0BdUhpMaN3ttCdobzcgqUTuy7Crfe7UyASBI7?=
 =?us-ascii?Q?1BXGUCX7ltvi5ApyCgekO1OeXym0mdAu0jDfDfJ?=
 =?us-ascii?Q?r1rbCd=2F8dslT5FE48iyIgStHOs46Ql7j190Qcy?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When deinitializing the driver, one or more "FW not responding" error
appears on the console.  This appears to be due to wilc_wlan_stop()
disabling host/WILC1000 communication, but then right afterwards, it
tries to release the bus with chip-sleep enabled.  The problem is
enabling the chip-sleep cannot success once host/WILC1000
communication is disabled.  Fix by only releasing the bus.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index f1e4ac3a2ad5..5d7f5b52f6de 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1224,7 +1224,8 @@ int wilc_wlan_stop(struct wilc *wilc, struct wilc_vif *vif)
 
 	ret = 0;
 release:
-	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
+	/* host comm is disabled - we can't issue sleep command anymore: */
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 
 	return ret;
 }
-- 
2.25.1

