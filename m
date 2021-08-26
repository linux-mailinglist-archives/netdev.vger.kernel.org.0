Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E0E3F7FD0
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbhHZBZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbhHZBZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:25:58 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBFFC0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:11 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g14so1268785pfm.1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tAj0koGz+CBkr4aFveDFVG9Sqq9oJN7QmDG92Uvmwc0=;
        b=fR3TPHxAWQ5jUhNxyfieWrb6DjXz+QVfJ5aZUSFAqqFsOjuW1VDs+Lz4dUKCgCnEjU
         iuCeFrasA2N4tEG75/OmfevBiLGD/sBOGzC+7Ueopnwa3PsFMjhTLk/295bVp6teZzyz
         7viVCqlrwL8iTftJzN2YKKeLDvfdkh37N1OLK0eJKasYUqx0du4Y8SGrQCjeiL5D5Hej
         KwTH5QPj5rT78D/idu2BuEsPULXPp77SOFOigBcFgiRFnddU/De8GOSRTOt/aUrkPhbJ
         DmFJv5KgvRBG6p4VX03QoxPA9t/lDqWdJe4z0Qo7tp8VrnOYWEREa3vH8yh1npvmH0Tj
         q8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tAj0koGz+CBkr4aFveDFVG9Sqq9oJN7QmDG92Uvmwc0=;
        b=by+cugnzODMZX88krOnZ3ZEK31PBy/zTFUMz24rol3gvwqZuN7pfGoJRNg3AgDKnFV
         bnilKTd3mkf5K8NvdybdjtTLVMKeVq58BcfXsPy7pzp8j6P7quC5o6QY8zv3RtCwO1K8
         GnGSr9rxDKPeFi+hsWxA4+GFZmEk8FpGeAgMeWC9l5+CbSO2efWu1krWvLYvZGoDj443
         Fm3YKjbIs8QhkE18si+XfDfWuOc4UXXUJNqCx6iffrWNdUp7jPaCMZJKdJ0EurPlWo/t
         /Mu19/3672HIacar3c7sm+S0nsSna1TQcI1H2fGoTcjgtxvsJcf85nPVCdCGfbnuM5F0
         ISpQ==
X-Gm-Message-State: AOAM531JpZ8PmBoaTVvDahlCnbR78ljyNmmO6i/fZgbrvHoooZgCuzfw
        C7IJubVZhqfieONUcASiJemetA==
X-Google-Smtp-Source: ABdhPJyoKGdqfS05UUsDu5q+mfhN81uCN+3dV86fXgE1ksa+OXTLOG7tREdjkgbO1Y3hXZPuNry6Tg==
X-Received: by 2002:a63:d814:: with SMTP id b20mr1018453pgh.268.1629941111113;
        Wed, 25 Aug 2021 18:25:11 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h13sm1113458pgh.93.2021.08.25.18.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 18:25:10 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/5] ionic: refactor ionic_lif_addr to remove a layer
Date:   Wed, 25 Aug 2021 18:24:49 -0700
Message-Id: <20210826012451.54456-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210826012451.54456-1-snelson@pensando.io>
References: <20210826012451.54456-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The filter counting in ionic_lif_addr() really isn't useful,
and potentially misleading, especially when we're checking in
ionic_lif_rx_mode() to see if we need to go into PROMISC mode.
We can safely refactor this and remove a calling layer.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 41 +------------------
 1 file changed, 2 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7812991f4736..b248c2e97582 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1351,43 +1351,6 @@ int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	return 0;
 }
 
-static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add)
-{
-	unsigned int nmfilters;
-	unsigned int nufilters;
-
-	if (add) {
-		/* Do we have space for this filter?  We test the counters
-		 * here before checking the need for deferral so that we
-		 * can return an overflow error to the stack.
-		 */
-		nmfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
-		nufilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
-
-		if ((is_multicast_ether_addr(addr) && lif->nmcast < nmfilters))
-			lif->nmcast++;
-		else if (!is_multicast_ether_addr(addr) &&
-			 lif->nucast < nufilters)
-			lif->nucast++;
-		else
-			return -ENOSPC;
-	} else {
-		if (is_multicast_ether_addr(addr) && lif->nmcast)
-			lif->nmcast--;
-		else if (!is_multicast_ether_addr(addr) && lif->nucast)
-			lif->nucast--;
-	}
-
-	netdev_dbg(lif->netdev, "rx_filter %s %pM\n",
-		   add ? "add" : "del", addr);
-	if (add)
-		return ionic_lif_addr_add(lif, addr);
-	else
-		return ionic_lif_addr_del(lif, addr);
-
-	return 0;
-}
-
 static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
 {
 	return ionic_lif_list_addr(netdev_priv(netdev), addr, ADD_ADDR);
@@ -3234,7 +3197,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 */
 		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
 				      netdev->dev_addr))
-			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR);
+			ionic_lif_addr_add(lif, netdev->dev_addr);
 	} else {
 		/* Update the netdev mac with the device's mac */
 		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
@@ -3251,7 +3214,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 
 	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
 		   netdev->dev_addr);
-	ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR);
+	ionic_lif_addr_add(lif, netdev->dev_addr);
 
 	return 0;
 }
-- 
2.17.1

