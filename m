Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADB835EEB6
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349698AbhDNHqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349656AbhDNHql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:46:41 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B398C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:21 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso4473527otm.4
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yB2GGPDSNhfxT0xSY1Kgyrf/E9Kc81aasNbjs8RhMUk=;
        b=GGoMCH0Z3bb1ofvykJT9sM/4QuB7t/do1P3w1WHQP3sNCOnURm5x0Xv1+q3r3ZZm0g
         nNHU98mZRr+ot2n3DXMLMzLreMNBI8tiPhmQg7sH9XAayWcywSB/C0Sq6eayCslhJHaf
         VNJ4OzzAtNI0Ud9ketj28dRuDoPoyZHmj+EcNatEnY8Hx4wZeXCVu+KPfOsXGJvsPVFT
         1nm5W4cKqLsCTN8o80LAMxR+ympKEgus9rEFx0f0p6dVHVt87rue8kRWlsaAKmfTvQRO
         S8z28vs7Sxi8icqv2207LcyPgCVj2gsMdQsr7tqY4B2HzimHYV1b/3jHLko1xmKnyDQ0
         nyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yB2GGPDSNhfxT0xSY1Kgyrf/E9Kc81aasNbjs8RhMUk=;
        b=Q4/qU4OWeKi7/WojQIa1PGQCByyBA20VV/RW/5inpoq5VxFpZ8A1eJsEH/oHEHZHSA
         zkPyiWOz0RUXIzw9jsr2uyD2Ak5HSLXfyFwG6leZZKl45kTMC9/2MY5jK6qlwvCw0qtd
         zwAspG1QaYtk5ORL4loeLckWes6LoNMZLWg+711KTLhrjYxmXOaZivqCTXKyc513pJ5r
         4b5jz1QqGQF26q79Yo4P1nwSqyulKEZVjCxwew2PjGRK4dvMF1EQqgdAvR/cpf5pYRZt
         oF/D7fvIn++aLB64QVlVlK2JaNWKy252d7gDS7AXdrX0UBkV+9VExNgwU2Gu+C8oY2tX
         SHvQ==
X-Gm-Message-State: AOAM533rftA9LxJ7N+R1Iet9r5t2G9rZHyUJjmISKprnEJwBgdvqBrCz
        UV/vbOwFQ/mZ0ixGHndz6Cmwk3ovC+BNYg==
X-Google-Smtp-Source: ABdhPJzU7UcEWuoLCQ3yHSKLZ125hVagnehAZXHiz1cHjs+FUZSTozNyEYM0Q8+ntuv0bFvU3bgyDQ==
X-Received: by 2002:a9d:17e7:: with SMTP id j94mr32427140otj.41.1618386380360;
        Wed, 14 Apr 2021 00:46:20 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:7124:9f6b:8552:7fdf])
        by smtp.gmail.com with ESMTPSA id w3sm2833015otg.78.2021.04.14.00.46.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Apr 2021 00:46:20 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net 2/3] ibmvnic: remove duplicate napi_schedule call in do_reset function
Date:   Wed, 14 Apr 2021 02:46:15 -0500
Message-Id: <20210414074616.11299-3-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210414074616.11299-1-lijunp213@gmail.com>
References: <20210414074616.11299-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During adapter reset, do_reset/do_hard_reset calls ibmvnic_open(),
which will calls napi_schedule if previous state is VNIC_CLOSED
(i.e, the reset case, and "ifconfig down" case). So there is no need
for do_reset to call napi_schedule again at the end of the function
though napi_schedule will neglect the request if napi is already
scheduled.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2d27f8aa0d4b..f4bd63216672 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1921,7 +1921,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	u64 old_num_rx_queues, old_num_tx_queues;
 	u64 old_num_rx_slots, old_num_tx_slots;
 	struct net_device *netdev = adapter->netdev;
-	int i, rc;
+	int rc;
 
 	netdev_dbg(adapter->netdev,
 		   "[S:%d FOP:%d] Reset reason %d, reset_state %d\n",
@@ -2110,10 +2110,6 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	/* refresh device's multicast list */
 	ibmvnic_set_multi(netdev);
 
-	/* kick napi */
-	for (i = 0; i < adapter->req_rx_queues; i++)
-		napi_schedule(&adapter->napi[i]);
-
 	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
 	    adapter->reset_reason == VNIC_RESET_MOBILITY)
 		__netdev_notify_peers(netdev);
-- 
2.23.0

