Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334EA278F33
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgIYQ5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgIYQ5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 12:57:53 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB2A208B6;
        Fri, 25 Sep 2020 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601053072;
        bh=7dNt/8FQKvUj5BjdWGO36+5DnvecefTSUeRuVhPdjrw=;
        h=Date:From:To:Cc:Subject:From;
        b=lX1mHURY1ELTf01OULb8EsoXdHRZxC0fobcDbot6ZDfwQulaDdUl2+K/Su/s+HHlC
         hXG4HLsonS4+BhgLc0vBDve05ITWET0v6SpFiKXhXa2tJDuzNBs7Y2OXBIeGRL3v5a
         XS4fp6Dqeb7WfqimftRUztcElVjP6CkDZypuUn0A=
Date:   Fri, 25 Sep 2020 12:03:23 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] dpaa2-mac: Fix potential null pointer dereference
Message-ID: <20200925170323.GA20546@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a null-check for _pcs_, but it is being dereferenced
prior to this null-check. So, if _pcs_ can actually be null,
then there is a potential null pointer dereference that should
be fixed by null-checking _pcs_ before being dereferenced.

Addresses-Coverity-ID: 1497159 ("Dereference before null check")
Fixes: 94ae899b2096 ("dpaa2-mac: add PCS support through the Lynx module")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 6ff64dd1cf27..283c5b1dbaad 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -291,9 +291,9 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 {
 	struct lynx_pcs *pcs = mac->pcs;
-	struct device *dev = &pcs->mdio->dev;
 
 	if (pcs) {
+		struct device *dev = &pcs->mdio->dev;
 		lynx_pcs_destroy(pcs);
 		put_device(dev);
 		mac->pcs = NULL;
-- 
2.27.0

