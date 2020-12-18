Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B592DEB4B
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgLRVvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgLRVvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:51:13 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713B0C0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:50:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lb18so2022892pjb.5
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Xpp+Y9Uumbw+jjw882lCZSf+MOwL37YfCxqNHW7Qt78=;
        b=CUK/KbbCYNLDz4gKhRaORj/PJBmW/fkgwi3N+5cpnQA3D6L0Df6UJMnyYgOs2S3lwT
         vRjjBH+pIQ1RF9GRRtnQmCtArDtlTxKLayvcvqpqZjDHu3Q9lefi6m43NUiZzXzswU/r
         Btf3J7wyYZwpby3NKCFkB2UYR+qEQNvFB72X493ThTNcIeeV5tiFz2Oxw5Pzha+2+V8x
         PA+bJGTyjsd04LEnBrlfW1qrWvotBS+vAtnijXbhFyTE+ngmH1lUOAdZwxcy9huj/AET
         fjJeWKjXhVCstlYMqnU/NKgpAIthFq2az5G/j/Pfsq8z7MNAP4RkbALdqh5vny2pv7TB
         5Eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Xpp+Y9Uumbw+jjw882lCZSf+MOwL37YfCxqNHW7Qt78=;
        b=TtfSeWNaO81swjwpcMtm00vKeld37CEgW+V10DpI9c86zzsa/cQnmGMZ7BVuRqi0dd
         MgGBr90YmtHp6/511mPnKAr6C8YVfVonK5Zht2mXTJcYMBp/d3Y+FnKZ/PpDLO/+G1eH
         ymu1PvBo0FUfziCrwh7Am6v4x0Oy/7WPYbOdu4xV3WPIzLlIijJ6DBk/1IUMPb7ngcCz
         rnuh3hSV/XARtOBLhBcLik+j5/dMfIDr4s8M1pEQMX+O6zZx7dEqx/o16Ugcnncbkj6m
         vNa1JDpzPO96iurIQn+dKL6fpPUsGXQtxcszG6VU50l7fJAQz4ChhZuxTHE/ZC07wYGX
         DWCQ==
X-Gm-Message-State: AOAM530kCILtC0DkMvOMOLiuEqAf97dqGRAnuFAEw1CgnwjsrpYKA/AN
        +Mt7ok68I4OLDKlTCYofwMKJE6bwVB6PhA==
X-Google-Smtp-Source: ABdhPJxBkfJWHcsUSB9U/KHVTpOc82YZM6cSKpICnv1KTx3BJN86S2XqzlDiNoMwo7mSHN/R5q0Mog==
X-Received: by 2002:a17:902:bc49:b029:db:eb10:c5a1 with SMTP id t9-20020a170902bc49b02900dbeb10c5a1mr5961242plz.11.1608328232722;
        Fri, 18 Dec 2020 13:50:32 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id x12sm9606778pgf.13.2020.12.18.13.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 13:50:32 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: account for vlan tag len in rx buffer len
Date:   Fri, 18 Dec 2020 13:50:01 -0800
Message-Id: <20201218215001.64696-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the FW know we have enough receive buffer space for the
vlan tag if it isn't stripped.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 9156c9825a16..ac4cd5d82e69 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -337,7 +337,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 	unsigned int i, j;
 	unsigned int len;
 
-	len = netdev->mtu + ETH_HLEN;
+	len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
 	nfrags = round_up(len, PAGE_SIZE) / PAGE_SIZE;
 
 	for (i = ionic_q_space_avail(q); i; i--) {
-- 
2.17.1

