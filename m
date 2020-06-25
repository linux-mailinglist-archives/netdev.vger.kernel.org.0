Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F64720A251
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405940AbgFYPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:44:55 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:56893 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405908AbgFYPow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:44:52 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id CCA2A1BF211;
        Thu, 25 Jun 2020 15:44:49 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 3/8] net: phy: mscc: ptp: fix a smatch error
Date:   Thu, 25 Jun 2020 17:42:06 +0200
Message-Id: <20200625154211.606591-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following error was reported by smatch:
vsc85xx_ts_read_csr() error: uninitialized symbol 'blk_hw'.

In practice this is very unlikely, as all the block identifiers given to
this functions are handled and described in an enum. The smatch error is
fixed by doing what is already done in vsc85xx_ts_write_csr: using the
"PROCESSOR" block by default.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 17256d85cedf..030a56c9a06d 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -75,6 +75,7 @@ static u32 vsc85xx_ts_read_csr(struct phy_device *phydev, enum ts_blk blk,
 		blk_hw = base_port ? EGRESS_ENGINE_0 : EGRESS_ENGINE_1;
 		break;
 	case PROCESSOR:
+	default:
 		blk_hw = base_port ? PROCESSOR_0 : PROCESSOR_1;
 		break;
 	}
-- 
2.26.2

