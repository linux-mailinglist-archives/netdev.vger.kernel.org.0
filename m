Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B53318C7
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhCHUmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhCHUl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 15:41:59 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849D6C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 12:41:59 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id l7so112541qtq.7
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 12:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=N1vxx7bSOX3ktk6FlyseMJiz5RVz3VbHu7ezGR0lIG8=;
        b=W2brxf3rsPSUmueCeV3+6QwF4oBwh4V4AiJR8+uZliQyh5GArcoM225q2uV/Nc5uME
         vFXuEnq/f/h6O7+hIWZAD5kJXfJGDjW5NDKG6WO/UiKrIqwmIF+Bie66R1X3WgG9T5Y/
         LPxATVoSMNTc9EGYJysplERRyxO5a6Yj7caeOo3prxaQl/PmKOc0tSrCEFnlc91frf71
         8XNrrLbQ34tM1zO48t7LqOd3lsL2kqnq+afinMCQGdJryBbfBZSRRQL5K+ftYUhXN16k
         drlkBLH68od8jPT/I2NpeLTush2TshMvxZQ4GBKqPZIs6KbCJe/Rt2ak6R+ySkOW6YrQ
         KxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=N1vxx7bSOX3ktk6FlyseMJiz5RVz3VbHu7ezGR0lIG8=;
        b=m38NmMjZPq42qnW/6vUgbaRTDNTPtXPpHQmL1rjuCDXf1nCXYu4c2HY+x31l3bHLt/
         LpDqjs0NtYCLPhqso0WyodrM84BjIDfpO7ivSqEQ5h1qtZopAkCahTREyoFNF9J1F7Jl
         w8OAqV2P/bfKmRGch7ZRn8heZJwVch2wftuJngu/5SyIxIS/if7UJ7wtIs0Ru8vhUYfN
         NOc/Yh0j+if0R58zicw4srMSszD/auyjD5vYEM9cPPkEhWU2gqq3sJ26n3HGbBcd2chG
         E3iMr9gZOt1c5Gx3PcV6Kgp2NYA37JZF7MDWJYUjmoZlpjbI/5JgQM78CucIlFWhzhrh
         jMbA==
X-Gm-Message-State: AOAM532oqjbp/BNfFhiITOLZE6Q/ej4a0aN0FgJNpWgNF4izExqW/zFr
        P9hEj7RDk9j8MUaBendm+HmmuadbHLirhw==
X-Google-Smtp-Source: ABdhPJzbIw3+O2srn6pbCnJk8PDVnPMNC4sNrSlkm2cxYsgn16O56UUPFqfpH7QG1ZPIefDNeGFUDQ==
X-Received: by 2002:aed:3001:: with SMTP id 1mr17834911qte.125.1615236118418;
        Mon, 08 Mar 2021 12:41:58 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id g18sm4862265qtp.43.2021.03.08.12.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:41:58 -0800 (PST)
Subject: [net PATCH] ixgbe: Fix NULL pointer dereference in ethtool loopback
 test
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org
Date:   Mon, 08 Mar 2021 12:41:56 -0800
Message-ID: <161523611656.36376.3641992659589167121.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

The ixgbe driver currently generates a NULL pointer dereference when
performing the ethtool loopback test. This is due to the fact that there
isn't a q_vector associated with the test ring when it is setup as
interrupts are not normally added to the test rings.

To address this I have added code that will check for a q_vector before
returning a napi_id value. If a q_vector is not present it will return a
value of 0.

Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index fae84202d870..724cdd669957 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6534,6 +6534,13 @@ static int ixgbe_setup_all_tx_resources(struct ixgbe_adapter *adapter)
 	return err;
 }
 
+static int ixgbe_rx_napi_id(struct ixgbe_ring *rx_ring)
+{
+	struct ixgbe_q_vector *q_vector = rx_ring->q_vector;
+
+	return q_vector ? q_vector->napi.napi_id : 0;
+}
+
 /**
  * ixgbe_setup_rx_resources - allocate Rx resources (Descriptors)
  * @adapter: pointer to ixgbe_adapter
@@ -6582,7 +6589,7 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 
 	/* XDP RX-queue info */
 	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-			     rx_ring->queue_index, rx_ring->q_vector->napi.napi_id) < 0)
+			     rx_ring->queue_index, ixgbe_rx_napi_id(rx_ring)) < 0)
 		goto err;
 
 	rx_ring->xdp_prog = adapter->xdp_prog;


