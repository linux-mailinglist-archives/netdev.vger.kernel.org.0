Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D505843106
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388658AbfFLUeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:34:11 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:48475 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388338AbfFLUeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:34:10 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x5CKY4Ie026184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 14:34:05 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x5CKY4H6055619
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 12 Jun 2019 14:34:04 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net] net: dsa: microchip: Don't try to read stats for unused ports
Date:   Wed, 12 Jun 2019 14:33:32 -0600
Message-Id: <1560371612-31848-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If some of the switch ports were not listed in the device tree, due to
being unused, the ksz_mib_read_work function ended up accessing a NULL
dp->slave pointer and causing an oops. Skip checking statistics for any
unused ports.

Fixes: 7c6ff470aa867f53 ("net: dsa: microchip: add MIB counter reading
support")
Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 39dace8..f46086f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -83,6 +83,9 @@ static void ksz_mib_read_work(struct work_struct *work)
 	int i;
 
 	for (i = 0; i < dev->mib_port_cnt; i++) {
+		if (dsa_is_unused_port(dev->ds, i))
+			continue;
+
 		p = &dev->ports[i];
 		mib = &p->mib;
 		mutex_lock(&mib->cnt_mutex);
-- 
1.8.3.1

