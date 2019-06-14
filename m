Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA7346993
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfFNUa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbfFNUa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:27 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A87D2184E;
        Fri, 14 Jun 2019 20:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544226;
        bh=jeaNWuI05inyN5HcOjRsqx9ljew0ue6FHMDc9e2tx5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0pwmIQNT3CzqFtKGN8xdafC6XIcyiwo72h7t22+CC7CL6bw9rLer1ggF69unDqaw
         eIbP1h5cg9u8bkhoM5fJgTtrGm3I6oxX5iXmivBKkElp22Yq04cn9JGNohOE/fczLq
         1F0nLqfs0kHOLwRq2jzUaENQ+Ys7sQwBoWrHaoJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/27] net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0
Date:   Fri, 14 Jun 2019 16:30:01 -0400
Message-Id: <20190614203018.27686-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203018.27686-1-sashal@kernel.org>
References: <20190614203018.27686-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit 62394708f3e01c9f2be6be74eb6305bae1ed924f ]

When non-bridged, non-vlan'ed mv88e6xxx port is moving down, error
message is logged:

failed to kill vid 0081/0 for device eth_cu_1000_4

This is caused by call from __vlan_vid_del() with vin set to zero, over
call chain this results into _mv88e6xxx_port_vlan_del() called with
vid=0, and mv88e6xxx_vtu_get() called from there returns -EINVAL.

On symmetric path moving port up, call goes through
mv88e6xxx_port_vlan_prepare() that calls mv88e6xxx_port_check_hw_vlan()
that returns -EOPNOTSUPP for zero vid.

This patch changes mv88e6xxx_vtu_get() to also return -EOPNOTSUPP for
zero vid, then this error code is explicitly cleared in
dsa_slave_vlan_rx_kill_vid() and error message is no longer logged.

Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 172b13012e10..086603de1859 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1075,7 +1075,7 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	int err;
 
 	if (!vid)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	entry->vid = vid - 1;
 	entry->valid = false;
-- 
2.20.1

