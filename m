Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B7147941D
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbhLQS3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:29:16 -0500
Received: from mx1.riseup.net ([198.252.153.129]:33546 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhLQS3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:29:16 -0500
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4JFyDq2S4DzF401
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1639765755; bh=PvW7WXSzZRK50KagEhAMyH1j8FddxHMiHn/oWYMEdLg=;
        h=From:To:Cc:Subject:Date:From;
        b=HbGpbAENHSzjroHx5T7OWWbbtJga+u32iPCM95c1LkxnR3xjwBhPumViRfhu50ZCX
         +DZi5fjwS7mJUTEJJcWzXXQ94mu016btoYJMo0i8wB2DFnF3AokRuxwL0K+z3XRxLP
         ArlPEJfYMWMQ+LtBlIrix42n+4Ry7Y08dBmH6qVA=
X-Riseup-User-ID: E304E8EC45C676F1BB3F6A3917F875EE2B9D3EB4702392DB1A81DA92439AB844
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4JFyDp42RPz5vfh;
        Fri, 17 Dec 2021 10:29:14 -0800 (PST)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netdev@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH net] bonding: fix ad_actor_system option setting to default
Date:   Fri, 17 Dec 2021 19:28:46 +0100
Message-Id: <20211217182846.6910-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 802.3ad bond mode is configured the ad_actor_system option is set
to "00:00:00:00:00:00". But when trying to set the default value
manually it was failing with EINVAL.

A zero ethernet address is valid, only multicast addresses are not valid
values.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 drivers/net/bonding/bond_options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a8fde3bc458f..b93337b5a721 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1526,7 +1526,7 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 		mac = (u8 *)&newval->value;
 	}
 
-	if (!is_valid_ether_addr(mac))
+	if (is_multicast_ether_addr(mac))
 		goto err;
 
 	netdev_dbg(bond->dev, "Setting ad_actor_system to %pM\n", mac);
-- 
2.30.2

