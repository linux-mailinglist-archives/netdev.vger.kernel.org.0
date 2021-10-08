Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47DF42717C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 21:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhJHTkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 15:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhJHTkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 15:40:04 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CAFC061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 12:38:08 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s75so4058271pgs.5
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 12:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=7STzSQjiwVIZs2Ngrvi1ganqt+ZFxJfe+YH2Y2qnXk8=;
        b=DGC9JRuA3LUs3DBZRgy2pOuSm5sz+dkO9DJDgFq2ttNBzMc5bt0swjPhRO2zSXH5DK
         zkKoQtilKKl1sHWLG0fgAnQ56JJ3YDxWw+8mL235DaXn72c0DBOkdpB8Ly0dEzujXrfx
         CyCUBcLxYC9etR98zcQuszEmH5jXsf+lvYhNp/4BHfLuR1OMCMxNb8vLRXhMwmPgnHyP
         YDK602mArSpiSxUHRzfZnynMpOrtDaOBCJfjWugQyq/bsrmSt8xWUfbobCbMS6qv/9Kr
         veHkYfzGvCV6OSmZsk0ypnoJVz9BIasHhajrnDZ65S2WrTssTSU/5JnYmHm66m60leoY
         C7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7STzSQjiwVIZs2Ngrvi1ganqt+ZFxJfe+YH2Y2qnXk8=;
        b=GiLdh4NdAK8d7ktRvQcQxZJTz7hwmAySdc591L0UX3ceNnKETfRwoMAOPnC2Y4Ew3v
         X/Uo3oEMPOxjig+Obs9MC/LdbYy/wrSwqZ0iD7P5MTkFD9HhdrGQwLMWRDMP2ErQpbg9
         95EjaKyrky44nzJhvt2C6RAncyRfH+y/jUoAs8Sc2MwfbLj4CE+daZad+K1jYyQQ3E59
         LeCTVbVt+8vtgHASL9oTs5IzWRG1Q1x37sAtbb/7YJRRdhQog2rMhn/Z7RInoKdmpNaK
         eHnqSLOvzjtb7oWAf4wd9FHQC7Rcs5w0LIk8Y333G21cdktpww7Tn0giv5yP+9LDf/dE
         zZxQ==
X-Gm-Message-State: AOAM532u086zhLmFkqupLps0J6zjChgSFFHHIvTTAlfSD0Ba69gYWP6c
        22huzH0Jz1Eppl7pmWfrrc09mQ==
X-Google-Smtp-Source: ABdhPJwsOVR622PGORt1tOUllq26YCGnimdNWrl5Xnt6N/UtFKQTRgbSzFEgdDDa09RlzH5AuCmXYw==
X-Received: by 2002:a63:a504:: with SMTP id n4mr6224688pgf.264.1633721888392;
        Fri, 08 Oct 2021 12:38:08 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i125sm146658pfc.36.2021.10.08.12.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 12:38:08 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: don't remove netdev->dev_addr when syncing uc list
Date:   Fri,  8 Oct 2021 12:38:01 -0700
Message-Id: <20211008193801.41297-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bridging, and possibly other upper stack gizmos, adds the
lower device's netdev->dev_addr to its own uc list, and
then requests it be deleted when the upper bridge device is
removed.  This delete request also happens with the bridging
vlan_filtering is enabled and then disabled.

Bonding has a similar behavior with the uc list, but since it
also uses set_mac to manage netdev->dev_addr, it doesn't have
the same the failure case.

Because we store our netdev->dev_addr in our uc list, we need
to ignore the delete request from dev_uc_sync so as to not
lose the address and all hope of communicating.  Note that
ndo_set_mac_address is expressly changing netdev->dev_addr,
so no limitation is set there.

Fixes: 2a654540be10 ("ionic: Add Rx filter and rx_mode ndo support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ccf3ffcd3939..7f3322ce044c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1379,6 +1379,10 @@ static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
 
 static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
 {
+	/* Don't delete our own address from the uc list */
+	if (ether_addr_equal(addr, netdev->dev_addr))
+		return 0;
+
 	return ionic_lif_list_addr(netdev_priv(netdev), addr, DEL_ADDR);
 }
 
-- 
2.17.1

