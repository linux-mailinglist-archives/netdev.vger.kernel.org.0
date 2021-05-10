Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A113780FE
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 12:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhEJKPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 06:15:36 -0400
Received: from fgw21-7.mail.saunalahti.fi ([62.142.5.82]:10714 "EHLO
        fgw21-7.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230002AbhEJKP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 06:15:28 -0400
X-Greylist: delayed 968 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2021 06:15:27 EDT
Received: from localhost (88-115-248-186.elisa-laajakaista.fi [88.115.248.186])
        by fgw21.mail.saunalahti.fi (Halon) with ESMTP
        id 3a5dda2a-b176-11eb-9eb8-005056bdd08f;
        Mon, 10 May 2021 12:58:11 +0300 (EEST)
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net-next v1 1/4] net: mvpp2: Put fwnode in error case during ->probe()
Date:   Mon, 10 May 2021 12:58:05 +0300
Message-Id: <20210510095808.3302997-1-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In each iteration fwnode_for_each_available_child_node() bumps a reference
counting of a loop variable followed by dropping in on a next iteration,

Since in error case the loop is broken, we have to drop a reference count
by ourselves. Do it for port_fwnode in error case during ->probe().

Fixes: 248122212f68 ("net: mvpp2: use device_*/fwnode_* APIs instead of of_*")
Cc: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ec706d614cac..b48c08829a31 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7552,6 +7552,8 @@ static int mvpp2_probe(struct platform_device *pdev)
 	return 0;
 
 err_port_probe:
+	fwnode_handle_put(port_fwnode);
+
 	i = 0;
 	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
 		if (priv->port_list[i])
-- 
2.31.1

