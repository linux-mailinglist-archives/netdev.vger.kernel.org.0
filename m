Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BD1365B24
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhDTO3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhDTO3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:29:01 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F301C06174A;
        Tue, 20 Apr 2021 07:28:29 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3FEB522249;
        Tue, 20 Apr 2021 16:28:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618928907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ibe24inMuVO9lJAvtKMCx1ojcEUWp8ObwKIzv3V+/Xg=;
        b=gXH7N//k5F0zrkQMZ6FZilKdrjfprLKfMuGaUwQes3gb3bcHvD8xKgQcsCXi1htfe0OpUG
        NziSw8kzaj2DFUm3/ZnxRz3COMH5MAoX6DZX6WBd6Mh/OvIyYgJjV9Y8s5+4XFx+sBMIKL
        yRI99FzWD+BhYDMJtYvLYgjh+Zz3plQ=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: enetc: automatically select IERB module
Date:   Tue, 20 Apr 2021 16:28:21 +0200
Message-Id: <20210420142821.22645-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that enetc supports flow control we have to make sure the settings in
the IERB are correct. Therefore, we actually depend on the enetc-ierb
module. Previously it was possible that this module was disabled while the
enetc was enabled. Fix it by automatically select the enetc-ierb module.

Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index d88f60c2bb82..cdc0ff89388a 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -2,7 +2,7 @@
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI && PCI_MSI
-	depends on FSL_ENETC_IERB || FSL_ENETC_IERB=n
+	select FSL_ENETC_IERB
 	select FSL_ENETC_MDIO
 	select PHYLINK
 	select PCS_LYNX
-- 
2.20.1

