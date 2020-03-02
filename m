Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E2417512B
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 01:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgCBACa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 19:02:30 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:52396 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgCBAC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 19:02:29 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 48W0h32B1SzQl9q;
        Mon,  2 Mar 2020 01:02:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id CRyHWvhcn4Nq; Mon,  2 Mar 2020 01:02:24 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net, linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, jcliburn@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 2/2] ag71xx: Call phylink_disconnect_phy() in case ag71xx_hw_enable() fails
Date:   Mon,  2 Mar 2020 01:02:08 +0100
Message-Id: <20200302000208.18260-2-hauke@hauke-m.de>
In-Reply-To: <20200302000208.18260-1-hauke@hauke-m.de>
References: <20200302000208.18260-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ag71xx_rings_cleanup() should already be handled in the
ag71xx_hw_enable() in case it fails internally. In this function we
should call phylink_disconnect_phy() in case the ag71xx_hw_enable()
failed to get back into the old state.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
---

v2:
 * rebased onm top of "net: ag71xx: port to phylink"

 drivers/net/ethernet/atheros/ag71xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 38683224b70b..405db37c084f 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1313,7 +1313,7 @@ static int ag71xx_open(struct net_device *ndev)
 	return 0;
 
 err:
-	ag71xx_rings_cleanup(ag);
+	phylink_disconnect_phy(ag->phylink);
 	return ret;
 }
 
-- 
2.20.1

