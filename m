Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A07C421B7A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhJEBNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230305AbhJEBNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:13:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6814E61108;
        Tue,  5 Oct 2021 01:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396278;
        bh=z9/HDmDh3kiEQB8drGl/jvICBvK8tVIKQS+5xtHyiog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lp3OtqS6trwvNxyI6IbkxSSXo2XqvyhGXjtPvFB+bA94hIY5aAqmT4rqi04taVP5E
         IkaYPmJ0vrp99++k97xD8FeXEWKD/3TLZbauwMij6fmv0XnavpU7+DNb+048yLG3pS
         y+KaSGovkTaGbG1xd+dnwLGoLx7vG7HFiXdq3YGqg7cZfRa2mTuMDbp8uCnTG1W682
         q+Q8tJrJDljegYWjQFz0dxctM6DjpgaErQk7maS4Gx+3hYh/aekj7FE84/ravkerD0
         u/aTgU6JYJxdOWaREAnJfrs7JKRD3Oz6PgXoOlWUjgSD46H1xwoSdWk5973w8LJ99i
         iQ02Pb/oj2Kww==
From:   Jakub Kicinski <kuba@kernel.org>
To:     sfr@canb.auug.org.au, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ethernet: ehea: add missing cast
Date:   Mon,  4 Oct 2021 18:11:14 -0700
Message-Id: <20211005011114.2906525-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005115637.3eacc45f@canb.auug.org.au>
References: <20211005115637.3eacc45f@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to cast the pointer, unlike memcpy() eth_hw_addr_set()
does not take void *. The driver already casts &port->mac_addr
to u8 * in other places.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 49e8de42af9a..bad94e4d50f4 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2986,7 +2986,7 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 	SET_NETDEV_DEV(dev, port_dev);
 
 	/* initialize net_device structure */
-	eth_hw_addr_set(dev, &port->mac_addr);
+	eth_hw_addr_set(dev, (u8 *)&port->mac_addr);
 
 	dev->netdev_ops = &ehea_netdev_ops;
 	ehea_set_ethtool_ops(dev);
-- 
2.31.1

