Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCDC13F241
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407089AbgAPSeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391795AbgAPRYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4802467E;
        Thu, 16 Jan 2020 17:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195479;
        bh=54xeeJt3oi2IZTScEVdGI/xjrie/0xH7YLIooRyhRns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzNkKlrajAXHm292GoHwes/J+3sWQU6raqG2BXm1P5y1VnJJ+0KX3zpPIIRNe0gVG
         sNNAXrx2F51TuZ6VQh1yKCKEIL5h+NaPfcaJ8mTM7TtZUF+MrbhORRRllp0EpSmPpZ
         NATObyyMeleMhrH+sRU1I8PAa4aNm3O+YtNlAQrE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moritz Fischer <mdf@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 084/371] net: phy: fixed_phy: Fix fixed_phy not checking GPIO
Date:   Thu, 16 Jan 2020 12:19:16 -0500
Message-Id: <20200116172403.18149-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>

[ Upstream commit 8f289805616e81f7c1690931aa8a586c76f4fa88 ]

Fix fixed_phy not checking GPIO if no link_update callback
is registered.

In the original version all users registered a link_update
callback so the issue was masked.

Fixes: a5597008dbc2 ("phy: fixed_phy: Add gpio to determine link up/down.")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/fixed_phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index eb5167210681..3ab2eb677a59 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -67,11 +67,11 @@ static int fixed_mdio_read(struct mii_bus *bus, int phy_addr, int reg_num)
 			do {
 				s = read_seqcount_begin(&fp->seqcount);
 				/* Issue callback if user registered it. */
-				if (fp->link_update) {
+				if (fp->link_update)
 					fp->link_update(fp->phydev->attached_dev,
 							&fp->status);
-					fixed_phy_update(fp);
-				}
+				/* Check the GPIO for change in status */
+				fixed_phy_update(fp);
 				state = fp->status;
 			} while (read_seqcount_retry(&fp->seqcount, s));
 
-- 
2.20.1

