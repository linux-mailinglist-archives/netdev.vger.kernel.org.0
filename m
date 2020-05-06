Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D855B1C6A88
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgEFHx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:53:58 -0400
Received: from inva021.nxp.com ([92.121.34.21]:49758 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728551AbgEFHx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 03:53:56 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 573E3200B0F;
        Wed,  6 May 2020 09:53:54 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2C63F200B2E;
        Wed,  6 May 2020 09:53:45 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4E7AA402C7;
        Wed,  6 May 2020 15:53:33 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v1 net-next 3/6] net: mscc: ocelot: change vcap to be compatible with full and quad entry
Date:   Wed,  6 May 2020 15:48:57 +0800
Message-Id: <20200506074900.28529-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
References: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calculating vcap data offset, the function only supports half key
entry. This patch modify vcap_data_offset_get function to calculate a
correct data offset when setting VCAP Type-Group to VCAP_TG_FULL or
VCAP_TG_QUARTER.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 8a9c4515bb3b..29d61b89b73a 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -175,8 +175,8 @@ static void vcap_data_offset_get(const struct vcap_props *vcap,
 	u32 i, col, offset, count, cnt, base;
 	u32 width = vcap->tg_width;
 
-	count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
-	col = (ix % 2);
+	count = (1 << (data->tg_sw - 1));
+	col = (ix % count);
 	cnt = (vcap->sw_count / count);
 	base = (vcap->sw_count - col * cnt - cnt);
 	data->tg_value = 0;
-- 
2.17.1

