Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2197C35DA24
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbhDMIdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhDMIdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:33:47 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52222C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 01:33:28 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso13489296otb.13
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 01:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vk4vlV8V3du8HChDSIGBEpjkT9c6LLzeaejA5GYigMs=;
        b=g59Lpi/GRSnIMmlPljHLhXcIXtyEt9KNlGeHEoTXLZ4MhgBzNxo/aK9hZe0rFhHAv3
         I6vQvJ/SllE1jYgpmfrOwLElgEsHoHOezMvsR0f4LbtfNgGQvKQaqntbU4XDxx4t3PD4
         n+sr3iom/Wlril1V7Ig9Oc1kc8Hjv67LIOrGClP4ShUkf9BV20yCe/NbXXBsf1IERwDJ
         2GWdy0YxoF+Uyd1+gATzuguiVWnSNFt6hzHoDnHdWcZeu7Eyi3eoKMzruZ+1w6f/CAa8
         e0Qfx2wjKwuMBAwQHvN4NmYgazcdoA5dCrEQQOExK/Gr3aL2Adg471KaJwT86mRk4/hf
         jDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vk4vlV8V3du8HChDSIGBEpjkT9c6LLzeaejA5GYigMs=;
        b=C/059ze9LTSEKiRqdKoWvObeqwAjK3dzoEhP1Nf8I8aiPzdTfglc0MuTKofwfqX+Vj
         /sFTsvN5wKTqDReHXrr4QylJn/RevF1TCscc1sEqERXqDe0kvSQagR2Pi9vapD7ddIpK
         VLLOuETRoz8eCDmkZPRs5bGo+tDVzcZ+3gJWvpcRMz//OjINe5myLNoEdkxWFqwpIglg
         XXwy+DjrTlnwrnIPg/mci0JuB3r5T8JqRA3f85By1DsXKO5iTjFxwP5UL2xLxcoNWLpn
         p+yAbGFe72Ia/xlf385gfZhMgcVO8v8x7CDoMitahhSs+sq2SN3x6nSDBKnjUGL6PP2H
         fcAA==
X-Gm-Message-State: AOAM532hZa5mPtbPROQe54cYgEC5XOWpD470y8+QdF1w94Qeg1AAFvYX
        lLlVi+fznqRIfm18QEgvZt3p5VmUviK+Og==
X-Google-Smtp-Source: ABdhPJz1wE1PZYxLOfWV8DXcTEP1BgDOyYEK9paVUTvqVOtAT7ZaXlRJ0BNtR7fy1kkMtVlLpKKx0w==
X-Received: by 2002:a9d:5ae:: with SMTP id 43mr152244otd.347.1618302807602;
        Tue, 13 Apr 2021 01:33:27 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:f46a:46e6:5a15:5a2c])
        by smtp.gmail.com with ESMTPSA id t22sm3379538otl.49.2021.04.13.01.33.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 01:33:27 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmvnic: correctly use dev_consume/free_skb_irq
Date:   Tue, 13 Apr 2021 03:33:25 -0500
Message-Id: <20210413083325.10533-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is more correct to use dev_kfree_skb_irq when packets are dropped,
and to use dev_consume_skb_irq when packets are consumed.

Fixes: 0d973388185d ("ibmvnic: Introduce xmit_more support using batched subCRQ hcalls")
Suggested-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9c6438d3b3a5..110a0d0eaabb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3204,9 +3204,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
-			if (next->tx_comp.rcs[i])
-				dev_err(dev, "tx error %x\n",
-					next->tx_comp.rcs[i]);
 			index = be32_to_cpu(next->tx_comp.correlators[i]);
 			if (index & IBMVNIC_TSO_POOL_MASK) {
 				tx_pool = &adapter->tso_pool[pool];
@@ -3220,7 +3217,13 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 			num_entries += txbuff->num_entries;
 			if (txbuff->skb) {
 				total_bytes += txbuff->skb->len;
-				dev_consume_skb_irq(txbuff->skb);
+				if (next->tx_comp.rcs[i]) {
+					dev_err(dev, "tx error %x\n",
+						next->tx_comp.rcs[i]);
+					dev_kfree_skb_irq(txbuff->skb);
+				} else {
+					dev_consume_skb_irq(txbuff->skb);
+				}
 				txbuff->skb = NULL;
 			} else {
 				netdev_warn(adapter->netdev,
-- 
2.23.0

