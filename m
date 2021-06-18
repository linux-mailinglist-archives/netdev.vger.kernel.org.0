Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2D3ACE18
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhFRPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbhFRPAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 11:00:21 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E02BC061574;
        Fri, 18 Jun 2021 07:58:07 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id d13so14371400ljg.12;
        Fri, 18 Jun 2021 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/qj/DCC40E5M+kCTzyQzmzT+i3lfMX82yvvAMuTPy2U=;
        b=cFQE0qieACEbE3MXNtJXVtJVIphvFTDMgjWLhBis+vgXG8x+Y/vg4nO6n3EwvTDbdR
         4Fwv9v+8wdFgt6+AxGYaUqdOQ3R9OVVVrSNOmrVOX0UZUFvdARQKN7iNEnjhmulBOlni
         XrwHdjkEwUQEceZdgzKr0PX+adT6Dk9GHXw4T0dN6WRWy4q1Zs2g5klt1JzAYq+g5XQa
         jz2PbbN34JJDr3k0Kphhh6oG4WPl27bMQbqdg6xxuPR89grUFzs9UF44USt7Z2Q5ltpi
         C1xc9MHMk36XQmF6atHscxja8Wqm7ZCTbNYlPKrhrdtkraG9RTueD1dyLyEnOFcn2bWb
         yB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/qj/DCC40E5M+kCTzyQzmzT+i3lfMX82yvvAMuTPy2U=;
        b=GzvT8GcWDJpinien+FPt9c5UZeLyYsVKrfkp39Q3hCK1bzSakkUYER7MDJes2Mu2iq
         UqmXgstNRnkKfW+pidzFEdM+Eclw8NrUCixSRnwSI8sbuMuEyq4bUCzm4RMmnjuvTbiH
         UNWGyXbw1gXpDfpu9mpEQHhrstgkZByw1SPVNBeiDyr+OavQRGYEc5ywZ0ICphYpwrZ8
         Y7S+ctCOeEPzNHLh6lSzegxlzlqwFcqdIT7/evE51XbXIw3Bi10oxTymJDXR0zVR489P
         xGKe+2pqyY25nG88ltV7PfBNcFN7B7r+dBLUSxkuUDgQ+oWZMbPXpom8/OFFWHltYVuS
         O3vQ==
X-Gm-Message-State: AOAM5307ViAmb0estaDBiMDZmMfggRAeXUTpRZYTdiyYJDFwJ2E0jjP1
        ea3fucwGW+vgqL/6UjNQ2rSASwrUa1ZHAg==
X-Google-Smtp-Source: ABdhPJw7f+3Y9SP91OWBd+PShL4pBiEpOayUISaL5/8ItN1P8uUmgIFeUG4tv7ywNIQjXVfXdSWK3w==
X-Received: by 2002:a2e:a7c9:: with SMTP id x9mr10076282ljp.333.1624028284877;
        Fri, 18 Jun 2021 07:58:04 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id b16sm1020471lff.210.2021.06.18.07.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 07:58:04 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     andreas@gaisler.com, davem@davemloft.net, kuba@kernel.org,
        kristoffer@gaisler.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: ethernet: aeroflex: fix UAF in greth_of_remove
Date:   Fri, 18 Jun 2021 17:57:31 +0300
Message-Id: <20210618145731.32194-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

static int greth_of_remove(struct platform_device *of_dev)
{
...
	struct greth_private *greth = netdev_priv(ndev);
...
	unregister_netdev(ndev);
	free_netdev(ndev);

	of_iounmap(&of_dev->resource[0], greth->regs, resource_size(&of_dev->resource[0]));
...
}

greth is netdev private data, but it is used
after free_netdev(). It can cause use-after-free when accessing greth
pointer. So, fix it by moving free_netdev() after of_iounmap()
call.

Fixes: d4c41139df6e ("net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/aeroflex/greth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index d77fafbc1530..c560ad06f0be 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1539,10 +1539,11 @@ static int greth_of_remove(struct platform_device *of_dev)
 	mdiobus_unregister(greth->mdio);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 
 	of_iounmap(&of_dev->resource[0], greth->regs, resource_size(&of_dev->resource[0]));
 
+	free_netdev(ndev);
+
 	return 0;
 }
 
-- 
2.32.0

