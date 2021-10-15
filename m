Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F3F42FDFF
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbhJOWTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238817AbhJOWTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADFEB6120E;
        Fri, 15 Oct 2021 22:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336222;
        bh=M3gQVPI7KcuY7TO9EODNRVHgRkr1U1nqyCsxcbrZFO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTQI5fzoSWfoD3TGk/ONAWHTPN2eCadeSn41fiHni5VHL1HXg3kupqOPxCptgIMm8
         gRiG8o+WNSMMhtoHezLVnbZvNuioikwsVBY1JSC0RnwkBSKLiGOTwtj+pPa/8pvBmN
         2oB8o+O7Cg34ugp+lKw2r11s5A4XqhqM1q4P+3oqYUbW0s05/4cTi9/Q5BtalK8D27
         p7W3AVeHqsZxIjdAvqjs0QCNekI0QyZER8/hVTgfULw7UkUeQjKFdZsLg9vbGWXDEQ
         uhpEYF+Dgvv9TsU+TEk/h1ikEUOjgHCUZSLdmKna9W1DDzazO1UxuHzW7mgmvVLu5a
         jRWtWPGw1PW4g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        benve@cisco.com, _govind@gmx.com
Subject: [PATCH net-next 08/12] ethernet: enic: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:48 -0700
Message-Id: <20211015221652.827253-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Use a zero'ed array on the stack, then call eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: benve@cisco.com
CC: _govind@gmx.com
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 66348cc3aaaf..aacf141986d5 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1098,6 +1098,7 @@ static int enic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 static int enic_set_vf_port(struct net_device *netdev, int vf,
 	struct nlattr *port[])
 {
+	static const u8 zero_addr[ETH_ALEN] = {};
 	struct enic *enic = netdev_priv(netdev);
 	struct enic_port_profile prev_pp;
 	struct enic_port_profile *pp;
@@ -1162,7 +1163,7 @@ static int enic_set_vf_port(struct net_device *netdev, int vf,
 		} else {
 			memset(pp, 0, sizeof(*pp));
 			if (vf == PORT_SELF_VF)
-				eth_zero_addr(netdev->dev_addr);
+				eth_hw_addr_set(netdev, zero_addr);
 		}
 	} else {
 		/* Set flag to indicate that the port assoc/disassoc
@@ -1174,7 +1175,7 @@ static int enic_set_vf_port(struct net_device *netdev, int vf,
 		if (pp->request == PORT_REQUEST_DISASSOCIATE) {
 			eth_zero_addr(pp->mac_addr);
 			if (vf == PORT_SELF_VF)
-				eth_zero_addr(netdev->dev_addr);
+				eth_hw_addr_set(netdev, zero_addr);
 		}
 	}
 
-- 
2.31.1

