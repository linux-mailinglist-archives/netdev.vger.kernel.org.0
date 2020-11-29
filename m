Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A11F2C7850
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 08:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgK2HJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 02:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgK2HJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 02:09:40 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EDEC0613D1;
        Sat, 28 Nov 2020 23:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/VfyYMSWkCiTjH/4fgwEeNSmCGIBTTRwuFF3f5NLpso=; b=yqx1DtQBYmuvECtUrLL0tUYXtF
        Lk0XtAmVa9wYSzXsGzJlwf47/4xo5QIkKNh4PIKjvkMOtpr0RaubSUwqeqHvMXQOytf8GNO9C499Q
        oLr21dbrt3sOwuro//XxPv8G1GKGSm1heoHROn6ANfKkVAdKAwtklymXQosrhNRv1JpJWvjdilJbh
        3iGt+utRLPXV58h8Jrs4oUCo4gjnqOshM3lrtlaIYveT4niSJbOo18sTGvgCOF6oBizt8wEkkpKf7
        m6qdlhMUBXjKTxkLipQqbsU8Qet8LwhzuDseMx12DOwo+a9MpiEYBAheZRMV1dccsLlAHnP1+dC/3
        /2lVJGKw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjGpG-0000LW-O0; Sun, 29 Nov 2020 07:08:51 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: broadcom CNIC: requires MMU
Date:   Sat, 28 Nov 2020 23:08:43 -0800
Message-Id: <20201129070843.3859-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CNIC kconfig symbol selects UIO and UIO depends on MMU.
Since 'select' does not follow dependency chains, add the same MMU
dependency to CNIC.

Quietens this kconfig warning:

WARNING: unmet direct dependencies detected for UIO
  Depends on [n]: MMU [=n]
  Selected by [m]:
  - CNIC [=m] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=m] || IPV6 [=m]=n)

Fixes: adfc5217e9db ("broadcom: Move the Broadcom drivers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Rasesh Mody <rmody@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
This isn't really the correct Fixes: tag, but I don't know how to go
backwards in git history to find it. :(

 drivers/net/ethernet/broadcom/Kconfig |    1 +
 1 file changed, 1 insertions(+)

--- linux-next-20201125.orig/drivers/net/ethernet/broadcom/Kconfig
+++ linux-next-20201125/drivers/net/ethernet/broadcom/Kconfig
@@ -88,6 +88,7 @@ config BNX2
 config CNIC
 	tristate "QLogic CNIC support"
 	depends on PCI && (IPV6 || IPV6=n)
+	depends on MMU
 	select BNX2
 	select UIO
 	help
