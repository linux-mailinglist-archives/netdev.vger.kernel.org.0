Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDC53771CC
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 14:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhEHMij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 08:38:39 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59497 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhEHMia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 08:38:30 -0400
Received: from localhost.localdomain ([37.4.249.151]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MgNtR-1l2T5r0vyp-00hrox; Sat, 08 May 2021 14:37:20 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 2/3 net-next] net: qca_spi: Avoid re-sync for single signature error
Date:   Sat,  8 May 2021 14:36:34 +0200
Message-Id: <1620477395-12740-3-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
References: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:JDMHD3Xez64dGDNUkMvgbFgWaO4iuZrpEx4rD20kyA+1sVWWcFc
 5IvGOlETLrCuO21fxSXuUnvHYRKlig6fRX2S9/9y1ndmHxodv+0mAW6i5RdCV5vNV4Zh/3y
 FwqBIrP523riHRSseIS/ax6qxGHUeLVmixu9bs/ozXT6BKOOlJ59gD5fvLumGqGUuC0bGys
 /838T1AOOgB9/Av5C8jaA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XDS+GkRFnyk=:V2Clxys2Id65tkJUZzPhPs
 HXt8rvLniUv6SezGrFbCWWc57I3DcHrs1VCkOkR97R9NkaOx1IkwlVouXfv5CCjYkok0taxyC
 0cDaWUvNsIVm4BJhlEmR9zKCr8JRpexf93Z1IexaYLMfjksmgfHwOCtCxOE262gIwbpG5puH7
 CPbnhieDQ9gnGk9UaAf9C+GsQxXMCAbkTiv8vcEd4mgRJteAAnTJvX+/AfUs3mlg0P/DaemyM
 9T9lfZJ7cKt+L5EKTDIrsS15NxB8MjDEdTL0wsv3kWLMcfsCt9hRetJ61pHPa4uReUaNR58md
 zmB3Turx6o0fkhVfbPlu1bEPn/NE8oGOrcOm6IyGnKeBozijanBCReJe8ju8ZjOH0ZCGVvNE6
 QA12uSmc6nKaNriz3TtobPMYheWVIQ+Ttg1eItkEG+u2uThu/tPp2cYSGkL6TT6S+v6kNcj4V
 ldIsS7rfnLcCya2iOuqR4P+WalvPZmoYAL4Adz0krmlfGcDT/WN2eCKNpx+g37PmwbHEUc45B
 RZCzMTSB5+hy8YZ/HJVl0g=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting a new network key would cause a reset of the QCA7000. Usually
the driver only notice the SPI interrupt and a single signature error.
So avoid the whole re-sync process (possible packet loss, transmit queue
stop and no carrier for at least 1 second) in this case.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 3e2a54c..0937ceb 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -524,8 +524,11 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 
 	switch (qca->sync) {
 	case QCASPI_SYNC_READY:
-		/* Read signature, if not valid go to unknown state. */
+		/* Check signature twice, if not valid go to unknown state. */
 		qcaspi_read_register(qca, SPI_REG_SIGNATURE, &signature);
+		if (signature != QCASPI_GOOD_SIGNATURE)
+			qcaspi_read_register(qca, SPI_REG_SIGNATURE, &signature);
+
 		if (signature != QCASPI_GOOD_SIGNATURE) {
 			qca->sync = QCASPI_SYNC_UNKNOWN;
 			netdev_dbg(qca->net_dev, "sync: bad signature, restart\n");
-- 
2.7.4

