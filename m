Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4805C39910A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFBREX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhFBREW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:04:22 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AD0C061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 10:02:25 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id v13-20020a4ac00d0000b029020b43b918eeso709410oop.9
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 10:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8eXIXsiyDuFNJesSFaHSyWarlGbS/8XfDyl7g5cf8OE=;
        b=EjM3bO/ZLNjM+kNXsWvsFtNCg9zrTeqcJn5PgFP9y/D+IvGRwuJ7WITIcMYz6ofrhh
         76RMw3/P/jbhaVc7iRcFAOQG3dqGjWlA7jCb0kRd+jHW9a+hzzm2ojmqFzWePp6Z/9Md
         Ao+dOBY2TSK1tvKWmxuugp3NEyyO9yaOQiBGyJbdnMe9IV6stK5Py0+qOw95fShwesd9
         qC8BGiZdhfR7+KkGDdVuoFSEaLDlTCSXlAtuqn2JWLKujV79doqEjZR9fqGyYgIaYyKq
         ixyGtNgx4O4hlUiue/d6UsTMAY9XbkCUF3jJNuY9Nu1VhV6iMSQfCIdGUgoY0uUcBjra
         v1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8eXIXsiyDuFNJesSFaHSyWarlGbS/8XfDyl7g5cf8OE=;
        b=F0uqGfkSa/ntrrQWX6SVE+vXpccS78Bjt1obbSFMSP2H4XkbVjEBoVGp8Q/4Y1wGeI
         Bi43ToV2A2wivUWu1EmUEg1cFgNc1YDD2GJrpyRttBNeBMLBo2b79KHhVsbQCBJd+DFi
         qwo70yaKmclEvyrmKX5WXZZbmSXg7V7ZSsLSiTjtBkH+B9XHpTTCHOmVQiBPNXIiCCQE
         NaruNKAF+ygG0j7USm6jLIcTqMHtvwVT9DSR01z08KfbmwYd4c42xBaGYrq1odUlcwTo
         rL77zOOrrDRSNzNomaoAE09JTljpKewF9FIoPOfCp7QDAKQqi1LAtfPSiMoKnSWPi0YI
         Mejg==
X-Gm-Message-State: AOAM530pW8Z81IBx23+cmAyAtTd2VX2Plt2WUjiTyewtZLZWAr2wW0wg
        H+sYiEhP7vxrh6kNdCcSauWKu6eURE3aeQ==
X-Google-Smtp-Source: ABdhPJyjX267gZK+Ev67d15oljy8KITsheckM5TbX/MY7Iagahq8HwPHmdgxDtu2rVkH/SzzDZFybg==
X-Received: by 2002:a4a:b202:: with SMTP id d2mr25471663ooo.13.1622653344331;
        Wed, 02 Jun 2021 10:02:24 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:c833:45c4:b8d7:9287])
        by smtp.gmail.com with ESMTPSA id e83sm91443oia.40.2021.06.02.10.02.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jun 2021 10:02:24 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next] net: ibm: replenish rx pool and poll less frequently
Date:   Wed,  2 Jun 2021 12:01:56 -0500
Message-Id: <20210602170156.41643-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old mechanism replenishes rx pool even only one frames is processed in
the poll function, which causes lots of overheads. The old mechanism
restarts polling until processed frames reaches the budget, which can
cause the poll function to loop into restart_poll 63 times at most and to
call replenish_rx_poll 63 times at most. This will cause soft lockup very
easily. So, don't replenish too often, and don't goto restart_poll in each
poll function. If there are pending descriptors, fetch them in the next
poll instance.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ffb2a91750c7..fae1eaa39dd0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2435,7 +2435,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 	frames_processed = 0;
 	rx_scrq = adapter->rx_scrq[scrq_num];
 
-restart_poll:
 	while (frames_processed < budget) {
 		struct sk_buff *skb;
 		struct ibmvnic_rx_buff *rx_buff;
@@ -2512,20 +2511,12 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 	}
 
 	if (adapter->state != VNIC_CLOSING &&
-	    ((atomic_read(&adapter->rx_pool[scrq_num].available) <
-	      adapter->req_rx_add_entries_per_subcrq / 2) ||
-	      frames_processed < budget))
+	    (atomic_read(&adapter->rx_pool[scrq_num].available) <
+	      adapter->req_rx_add_entries_per_subcrq / 2))
 		replenish_rx_pool(adapter, &adapter->rx_pool[scrq_num]);
 	if (frames_processed < budget) {
-		if (napi_complete_done(napi, frames_processed)) {
+		if (napi_complete_done(napi, frames_processed))
 			enable_scrq_irq(adapter, rx_scrq);
-			if (pending_scrq(adapter, rx_scrq)) {
-				if (napi_reschedule(napi)) {
-					disable_scrq_irq(adapter, rx_scrq);
-					goto restart_poll;
-				}
-			}
-		}
 	}
 	return frames_processed;
 }
-- 
2.23.0

