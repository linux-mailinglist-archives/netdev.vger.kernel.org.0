Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C0298A95
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770230AbgJZKmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:42:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:43390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1737087AbgJZKmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 06:42:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5D071ABBE;
        Mon, 26 Oct 2020 10:42:30 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>, netdev@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cris Forno <cforno12@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] ibmveth: Fix use of ibmveth in a bridge.
Date:   Mon, 26 Oct 2020 11:42:21 +0100
Message-Id: <20201026104221.26570-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

The check for src mac address in ibmveth_is_packet_unsupported is wrong.
Commit 6f2275433a2f wanted to shut down messages for loopback packets,
but now suppresses bridged frames, which are accepted by the hypervisor
otherwise bridging won't work at all.

Fixes: 6f2275433a2f ("ibmveth: Detect unsupported packets before sending to the hypervisor")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
ms: added commit message
---
 drivers/net/ethernet/ibm/ibmveth.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7ef3369953b6..c3ec9ceed833 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1031,12 +1031,6 @@ static int ibmveth_is_packet_unsupported(struct sk_buff *skb,
 		ret = -EOPNOTSUPP;
 	}
 
-	if (!ether_addr_equal(ether_header->h_source, netdev->dev_addr)) {
-		netdev_dbg(netdev, "source packet MAC address does not match veth device's, dropping packet.\n");
-		netdev->stats.tx_dropped++;
-		ret = -EOPNOTSUPP;
-	}
-
 	return ret;
 }
 
-- 
2.28.0

