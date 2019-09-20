Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAE3B951A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 18:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393245AbfITQSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 12:18:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38863 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390271AbfITQSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 12:18:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so7352624wrx.5
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 09:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=T2QKJDpIOmawSFf6tca9IpxqBTArSSM0LaBRI17UbHQ=;
        b=E9LdMVpwlmwx7cdAUDZk6nTukGA3oQW1Xir6xPpnTCYX4PJASDhogdjs/h5OCdrDLP
         4TGAo/yqqF1iUzOyOElDweJ67dDGNG59DY7Bmoujsf7jG4Ue6BgQi22pBaHbMMP19KIG
         GcVifkqSe//xWo46KtZEoQw5vCm4m+CgI4uGUCKnR0IC4MriYe0ML6THsoa+1ef+PU5+
         0NalWo3jY2HiJl7Yi8xgnUWpvVmO7GttLPMMd7I7xNA7Ar8j/sh8casMR3DufJRUuN17
         ydZvDLgHdXwunlU1WfxOBCQh7MgQiwA41WlgskVVfUqxmwCz20p22EYxbSbZeTGzUQj9
         e6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T2QKJDpIOmawSFf6tca9IpxqBTArSSM0LaBRI17UbHQ=;
        b=KbTdEhnH9Bmcu1vsQAi+WsNAU5Y01dT2Ch1pGCTcMrwgoQrizKlptPJfUO8hKg1he3
         tn/Ui4Akzj+pfwrqVmc67o4FHimkAy9uCc7hebD2wL2Iznq48pNQs/sX5p3hQX/xnMXz
         aKpnRFANF4z3as5WBlstjZVYX6UAUQnhX/E9RKnvTtlmKh6utQWyJrLu1u6vgrj6vnJZ
         4I202oUH1xpCH2SxR2eR7ZJp8wygLrsAmi4oJ/zwkgZEf+Nbxg2IRPR80s5Y8VZLZYB7
         9XY4ZP8dMHY6NnshWUIbVMQbjcYENYRcAeXf/Pm+z5f8oNydkUXGFYj6ZBijhwUybOJw
         TXWg==
X-Gm-Message-State: APjAAAXsi2IDlQHR50BkbODbZP4bk0Czl4DEN7nwYfqJ0+NRiVW+kdfU
        W6TI/o4Ma3sUkER7DWLY1Lto7ezQtxqszQ==
X-Google-Smtp-Source: APXvYqxTs/hGtOwvcx3pUDuX7bFM4xXAhSSEfJtA/vfe3du+HSnfz//2ys5rwJTqphlfCFvDTtq30w==
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr12368800wrt.100.1568996311650;
        Fri, 20 Sep 2019 09:18:31 -0700 (PDT)
Received: from localhost.localdomain (lmontsouris-659-1-22-203.w81-250.abo.wanadoo.fr. [81.250.173.203])
        by smtp.gmail.com with ESMTPSA id b144sm2536069wmb.3.2019.09.20.09.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 09:18:30 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net] skge: fix checksum byte order
Date:   Fri, 20 Sep 2019 18:18:26 +0200
Message-Id: <20190920161826.15942-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

Running old skge driver on PowerPC causes checksum errors
because hardware reported 1's complement checksum is in little-endian
byte order.

Reported-by: Benoit <benoit.sansoni@gmail.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 drivers/net/ethernet/marvell/skge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 0a2ec387a482..095f6c71b4fa 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3108,7 +3108,7 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
 	skb_put(skb, len);
 
 	if (dev->features & NETIF_F_RXCSUM) {
-		skb->csum = csum;
+		skb->csum = le16_to_cpu(csum);
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
 
-- 
2.17.1

