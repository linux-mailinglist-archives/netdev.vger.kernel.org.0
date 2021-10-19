Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA1A43397E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhJSPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhJSPCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C67E61360;
        Tue, 19 Oct 2021 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655618;
        bh=u5f0XdMl8DWLN+sZ2CSMH3v8/Nnt44mrRoX5bFn1bR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7H28Hqr3OtXrrlMpJ0L463ihYUSHy/GzI9N1+7OHXQbGvSipXYpDE48s3IGjXZjR
         nVYFx/o9HzDPvamGJMyXgMevzUan4MtYvzJkaHxfHgMjvOkusZD70RSk3OkunCOSXn
         6vPc3o6/JhcApDcbyPHvC2yHWueL7pC7ltf/4K8lf86zklFT6lAMyIr+HtyfUTogtz
         7+5eQDYbRNH0R/DsPgQ6fsOqXjokDru7NBUV0PHHNrHMVBF3G7YPtwiwIR4C4X32t4
         rDdG9rWn1SgOTdKThpm6poPCgcuufbGOK0YSn8wnegtX47KKYV4rtmEkSdKvs1/q30
         YHvo+Dc96XMKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        andy@greyhouse.net
Subject: [PATCH net-next 3/6] ethernet: tehuti: use eth_hw_addr_set()
Date:   Tue, 19 Oct 2021 08:00:08 -0700
Message-Id: <20211019150011.1355755-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019150011.1355755-1-kuba@kernel.org>
References: <20211019150011.1355755-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Break the address up into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: andy@greyhouse.net
---
 drivers/net/ethernet/tehuti/tehuti.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 3e8a3fde8302..0775a5542f2f 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -840,6 +840,7 @@ static int bdx_set_mac(struct net_device *ndev, void *p)
 static int bdx_read_mac(struct bdx_priv *priv)
 {
 	u16 macAddress[3], i;
+	u8 addr[ETH_ALEN];
 	ENTER;
 
 	macAddress[2] = READ_REG(priv, regUNC_MAC0_A);
@@ -849,9 +850,10 @@ static int bdx_read_mac(struct bdx_priv *priv)
 	macAddress[0] = READ_REG(priv, regUNC_MAC2_A);
 	macAddress[0] = READ_REG(priv, regUNC_MAC2_A);
 	for (i = 0; i < 3; i++) {
-		priv->ndev->dev_addr[i * 2 + 1] = macAddress[i];
-		priv->ndev->dev_addr[i * 2] = macAddress[i] >> 8;
+		addr[i * 2 + 1] = macAddress[i];
+		addr[i * 2] = macAddress[i] >> 8;
 	}
+	eth_hw_addr_set(priv->ndev, addr);
 	RET(0);
 }
 
-- 
2.31.1

