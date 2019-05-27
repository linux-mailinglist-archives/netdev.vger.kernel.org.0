Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2882B387
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfE0LwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 07:52:19 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47489 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfE0LwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 07:52:19 -0400
X-Originating-IP: 90.88.147.134
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 694F6E000B;
        Mon, 27 May 2019 11:52:13 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: mvpp2: cls: Check RSS table index validity when creating a context
Date:   Mon, 27 May 2019 13:52:01 +0200
Message-Id: <20190527115201.12721-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we don't use an out-of-bound index for the per-port RSS
context array.

As of today, the global context creation in mvpp22_rss_context_create
will prevent us from reaching this case, but we should still make sure
we are using a sane value anyway.

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index cd0daad011ce..bd19a910dc90 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1466,6 +1466,9 @@ int mvpp22_port_rss_ctx_create(struct mvpp2_port *port, u32 *port_ctx)
 			break;
 	}
 
+	if (i == MVPP22_N_RSS_TABLES)
+		return -EINVAL;
+
 	port->rss_ctx[i] = rss_ctx;
 	*port_ctx = i;
 
-- 
2.20.1

