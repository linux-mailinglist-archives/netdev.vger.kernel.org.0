Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624A73E1F08
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241963AbhHEW4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:56:01 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44808 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhHEWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:55:59 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175MtdWk121510;
        Thu, 5 Aug 2021 17:55:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628204139;
        bh=zw7SYCOSmmLpwKH4Ks2vmlsA6rUtnEAfmXrrSsmXdos=;
        h=From:To:CC:Subject:Date;
        b=Vohx3b1VmqFx0O0N7DkJ5OwhAg09yFyt5ubE+QvwUe/E3uSI1KTcZ77HvafNt8KdB
         1M1Eaj/WCZXo9a/F9wC4pop4B/4BPJzBjMxItKnIC5Do+nJY2bD9KJ2/zBakXSuzLc
         RpcRJNZXp3hO2PXsvfy/7pvAjPt4A12zzXX+yHXA=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175MtdaZ087192
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 17:55:39 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 17:55:39 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 17:55:39 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175MtcXE007154;
        Thu, 5 Aug 2021 17:55:39 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 0/2] net: ethernet: ti: am65-cpsw: use napi_complete_done() in TX completion
Date:   Fri, 6 Aug 2021 01:55:30 +0300
Message-ID: <20210805225532.2667-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi

The intention of this series is to fully enable hard irqs deferral feature
(hrtimers based HW IRQ coalescing) from Eric Dumazet [1] for TI K3 CPSW driver
by using napi_complete_done() in TX completion path, so the combination of
parameters (/sys/class/net/ethX/):
 napi_defer_hard_irqs 
 gro_flush_timeout
can be used for hard irqs deferral.

The Patch 1 is required before enabling hard irqs deferral feature to avoid
"Unbalanced enable" issue if gro_flush_timeout is configured while
(napi_defer_hard_irqs == 0).

It's a bit sad that it can not be configured per RX/TX separately.

[1] https://lore.kernel.org/netdev/20200422161329.56026-1-edumazet@google.com/
Grygorii Strashko (1):
  net: ethernet: ti: am65-cpsw: use napi_complete_done() in TX
    completion

Vignesh Raghavendra (1):
  net: ti: am65-cpsw-nuss: fix RX IRQ state after .ndo_stop()

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 23 ++++++++++++++++-------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 ++
 2 files changed, 18 insertions(+), 7 deletions(-)

-- 
2.17.1

