Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9B92F2876
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbhALGnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387756AbhALGnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:43:50 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8F4C0617A2
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:10 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id x13so1327091oic.5
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFkfyhtA/p6JxBeO3XIMrxsFQEkcBYrraZE4qffCy84=;
        b=rBuH3viQRqXQdNchiP0UZZv9ePfmomwGqFxUVwkyZOko22stO4dPdsu9GTKsUR9ioS
         iLJCzG08ka0dmw0x1FoezulJYd/U3TtYLRTVh5TsKVrY1R/GDWARg4sdXGExOklIUR9o
         32so3DVmyj6vOx9ZEc5EXVju3MyARuVloKH8rZy1MqVcNAYauhFo6tPCbQQ8zmQNfaUh
         Jdv54z4FnK6BTFuY2Jpm1w8/Odfj3wUVe0bpXLJ+4g7Z6cKdW0PrIkkPnxkPwLFzEZuV
         AKnGQa+gllan+rrBV2E7xDeSmz/UnRjLw8aeScwPv15UW+fnKCUI5S4x1GOcC+WGXLMG
         ThdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFkfyhtA/p6JxBeO3XIMrxsFQEkcBYrraZE4qffCy84=;
        b=rsz8KbgxweBAWdDbxc/t8cmCo57KD9WRaH9gfn8Jo5CSbgLcYM8DHivP4YnLQnooJH
         +qI7SUipxYSAb8ivoxkSOyaQvKyH/pGQE0GnzlEeXXqECqpHrZ0mAbQuNnIrFIx/k4J8
         0S9f119P0uLLALQEW7GaSSSSCpMx8FJbn05WTM/tuXMRM7QtwwO1I94+zQSsOuWAbani
         HB0TWDNTZAUq47K+rznhkqONPCLAl4tS/y2VjIc9K2rh0qALczKl/ICx+8K3SmTgp55F
         JhOXpgnYVp5PpgrgNQw31ixwl0Kzbfeka9QG2Lr6fRtUpUUXl5zqDsMwgRZwUZlou6AH
         E5Uw==
X-Gm-Message-State: AOAM533hcuc3wbWpUtm663MI34UM+ARuDQVXwQJsbjt3bXP3NTmzFzDt
        VR8ubyHP8qmOhqcyodo2YLCFGY3ijBC4AA==
X-Google-Smtp-Source: ABdhPJzVIVOuheKA3/icRsLkwl6EUkq/f2yCjDkf3skaVyHAa0C1urqojA9UdP/1A9fyJJySG6InEg==
X-Received: by 2002:aca:5196:: with SMTP id f144mr1206954oib.51.1610433789939;
        Mon, 11 Jan 2021 22:43:09 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:09 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 4/7] ibmvnic: avoid multiple line dereference
Date:   Tue, 12 Jan 2021 00:43:02 -0600
Message-Id: <20210112064305.31606-5-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warning:
WARNING: Avoid multiple line dereference

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index eb3ab0e6156f..30add8a8a3dc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2447,9 +2447,8 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		 */
 		dma_rmb();
 		next = ibmvnic_next_scrq(adapter, rx_scrq);
-		rx_buff =
-		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
-							  rx_comp.correlator);
+		rx_buff = (struct ibmvnic_rx_buff *)
+			  be64_to_cpu(next->rx_comp.correlator);
 		/* do error checking */
 		if (next->rx_comp.rc) {
 			netdev_dbg(netdev, "rx buffer returned with rc %x\n",
@@ -3865,15 +3864,15 @@ static int send_login(struct ibmvnic_adapter *adapter)
 
 	for (i = 0; i < adapter->req_tx_queues; i++) {
 		if (adapter->tx_scrq[i]) {
-			tx_list_p[i] = cpu_to_be64(adapter->tx_scrq[i]->
-						   crq_num);
+			tx_list_p[i] =
+				cpu_to_be64(adapter->tx_scrq[i]->crq_num);
 		}
 	}
 
 	for (i = 0; i < adapter->req_rx_queues; i++) {
 		if (adapter->rx_scrq[i]) {
-			rx_list_p[i] = cpu_to_be64(adapter->rx_scrq[i]->
-						   crq_num);
+			rx_list_p[i] =
+				cpu_to_be64(adapter->rx_scrq[i]->crq_num);
 		}
 	}
 
@@ -4416,8 +4415,8 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 	case PARTIALSUCCESS:
 		dev_info(dev, "req=%lld, rsp=%ld in %s queue, retrying.\n",
 			 *req_value,
-			 (long)be64_to_cpu(crq->request_capability_rsp.
-					       number), name);
+			 (long)be64_to_cpu(crq->request_capability_rsp.number),
+			 name);
 
 		if (be16_to_cpu(crq->request_capability_rsp.capability) ==
 		    REQ_MTU) {
-- 
2.23.0

