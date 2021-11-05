Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5175F44615F
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 10:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhKEJck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 05:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhKEJch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 05:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CF96124D;
        Fri,  5 Nov 2021 09:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636104598;
        bh=tKBD+RLlfhE7VeZpMQSfNhzCQ40GPzXQUm0WWaajWiU=;
        h=From:To:Cc:Subject:Date:From;
        b=blJrmjedEf9wRzkN712Vm/D1FqePc61/3vF+cXYJKBSfZCTddSND6bALdvpydjdKo
         RI5oSKdgT1erbLNBISzhoa7HHvu+yBRvFy610vDyVbkx7Gaws+rguc/Q406/F1AFcQ
         pjcwctC8aYrrND2/H6UdqQLleGkNZwDFZ7dmMizBFFrFthQUDAqnAihEBztLDkOTVQ
         7cYMtVopEIxUMkaCA2VMyTVAjUvffSsf0gvrsiVQlybU7xOaUOoyICkOM20KwiG4PR
         BBx6aFsWNwdOS1iXDmsFM++bcN88JwyK+kgqNMmqYHPobbAbENNrVfgIy7Dc0JqNci
         ihr5aq3iCrZ0w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ax88796c: fix ioctl callback
Date:   Fri,  5 Nov 2021 10:29:39 +0100
Message-Id: <20211105092954.1771974-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The timestamp ioctls are now handled by the ndo_eth_ioctl() callback,
not the old ndo_do_ioctl(), but oax88796 introduced the
function for the old way.

Move it over to ndo_eth_ioctl() to actually allow calling it from
user space.

Fixes: a97c69ba4f30 ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver")
Fixes: a76053707dbf ("dev_ioctl: split out ndo_eth_ioctl")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
It would be best to completely remove the .ndo_do_ioctl() callback
to avoid this problem in the future, but I'm still unsure whether
we want to just remove the ancient wireless and localtalk drivers
instead of fixing them.
---
 drivers/net/ethernet/asix/ax88796c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 4b0c5a09fd57..8994f2322268 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -934,7 +934,7 @@ static const struct net_device_ops ax88796c_netdev_ops = {
 	.ndo_stop		= ax88796c_close,
 	.ndo_start_xmit		= ax88796c_start_xmit,
 	.ndo_get_stats64	= ax88796c_get_stats64,
-	.ndo_do_ioctl		= ax88796c_ioctl,
+	.ndo_eth_ioctl		= ax88796c_ioctl,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_set_features	= ax88796c_set_features,
 };
-- 
2.29.2

