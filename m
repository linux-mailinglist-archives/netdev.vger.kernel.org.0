Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C213771C9
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 14:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhEHMif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 08:38:35 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:34957 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhEHMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 08:38:28 -0400
Received: from localhost.localdomain ([37.4.249.151]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1Mt7st-1lQAfW44in-00tUmb; Sat, 08 May 2021 14:37:20 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 1/3 net-next] net: qca_spi: Avoid reading signature three times in a row
Date:   Sat,  8 May 2021 14:36:33 +0200
Message-Id: <1620477395-12740-2-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
References: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:Ei53HZbPR2Of5JrXcoi6GIAT9nXpfTGZXSwI0OaBC2M0etMyT3j
 Wx19OQt6ZkZ2U4iWjOpmd5m59YHY6jXE31ME156q5ToRSHpdcpsaMsm3Rnkbzr5AoQoVabL
 8XvJaQVPOdf0Tp4qjdjun507RBtRoPWkSqAVuBtKb8fmMXU0XvWC3gz6VAQz4P/NbuQNH1C
 q6EqlvI5WVW5VWrWzLHqA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:95OEBbwDT6w=:jqZXOPsGiQimWZ/Pln/1mK
 RifMA4ePIvNoQ/GpPPEQ2Ji04D6RAwJNXNmEID0T/L1R0Z082El26xCjk11k+8tBWIgJZSLQP
 N7K7chPnAFFs8OTgtMHd58Aavl6/8M6yPG6uKL3Q8mGmiXMPjw6ftn0rIIFK2l/wLf+FAD5cw
 9QcoOnZ7Obr2d2WTagTrVCECdcyTyUJ+Blczzpuu+e0IRVl/7ns9SHHgUfRQ8r7FmnkZ61d6v
 GJd+EXBv/wrPtd4Myb8+E4BmUbFKvYYcChd8ScYsq+duq/urHb+NWvnq4pgdlDq8YMaj1wxL6
 +ZGaDfr5bFL06DHNkH6qZ2uaVODZOUHaRyF9dmbx/rjJUspVjcMjFYjJRPBDEfoBz6y2qCxZ5
 bgmj2PAfmMp3w2AisxnGY8J8ahgdl3BSNBnZY1nqTooMW7Zj/ES83Eg92uJh/uOPwT/gFYoia
 f2BOiAy/gisXvl0a/6NtLgxDBSwgF9leGVk37EdNlbq7V9I2J9JpaAXUWgXmpejsahTIKdtmN
 eeYbAmzG+NPDsewVjZTPRc=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to read the signature three times. So bail out
in case the second check failed.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index ab9b025..3e2a54c 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -506,6 +506,7 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 		if (signature != QCASPI_GOOD_SIGNATURE) {
 			qca->sync = QCASPI_SYNC_UNKNOWN;
 			netdev_dbg(qca->net_dev, "sync: got CPU on, but signature was invalid, restart\n");
+			return;
 		} else {
 			/* ensure that the WRBUF is empty */
 			qcaspi_read_register(qca, SPI_REG_WRBUF_SPC_AVA,
-- 
2.7.4

