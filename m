Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA626CCE3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgIPUuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgIPUuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:50:13 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E18BC06174A;
        Wed, 16 Sep 2020 13:50:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k18so4375995wmj.5;
        Wed, 16 Sep 2020 13:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TVdlmRRpxaOmJp0wpVVEjEPcXY/5kO+TQCDCCLVJ6hg=;
        b=G7Qd/LcqX6GnUw4HwAETsZJC3kfYWCGoq88416Zk1MSfG7rWo/v7qEKxRG+cTU4wPW
         CqFZDKDK3+BvEwALubLpQ2zYb8mJnl5Jo2e/2k4YRx2EB1d1sAx1K12STM9pjqpyEad9
         RppDA3yh5l5I9VaDWylWdso3bnBfYWcoYHdf79CnqWojt9u71DuQQ8gsW+Gps7y4XxjY
         u+NocKWfdGXAm+mhCAvVTtVE3Fytl//yoSvXDta0rCzv6rUvNqtzfZbxieHdeK/KN0xC
         hhBVcitoo/1hOeeUN2YxtPHIYcBWjuYEADSNFm2Z1kF89SzbJN89YON3HQSc2Hd7hJ0Q
         SB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TVdlmRRpxaOmJp0wpVVEjEPcXY/5kO+TQCDCCLVJ6hg=;
        b=gf9WmnYi4lqlyXBr82uH3iHUSg+46TshZBFzQE0JHXm/NO2I1GekptcsfIPKPW0A0B
         u2YSGW2oAzdfSZ8hBlnyRT4Icm6KFRkTCjBQqeXNlL4N1QkIvbeW4y7kwJyau3aYwu7p
         wwDi++mjwrnHD4g2AXRyX2fcomOXGcUJTX0okQMHFf8hAuJvvSnpXM3XRDMgjh/8Ybg5
         GMnzYOGgu8Pza1zYE9GcLH0BA76K3CGJsexY2MaYfKxiL38AcvT/L/KNLBXgfiXkb/PK
         XE38zxdKLBiJsMNCuXKcwN7Zkv9TwQ9F43l0wSrAkh3gWzKjyltUGZ26Y6Z0YeE4mWJl
         nGTA==
X-Gm-Message-State: AOAM5333eLzUrkAg880J3SJ4P+s7ZzNlxz1xug6oHXG9NnDPXXxsorMJ
        MJR44upG3/NJLydlBbyYgnQ=
X-Google-Smtp-Source: ABdhPJxRPEz6cLPrGaaD3Q9jTaxwljb6VA9QWbvZQVPXsnVMm7Zkyqz9HkM8Q8wHaWQKhjFcp6Jivg==
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr6167718wml.147.1600289411985;
        Wed, 16 Sep 2020 13:50:11 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id z7sm34879619wrw.93.2020.09.16.13.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 13:50:11 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i40e: Fix use of uninitialized variable
Date:   Wed, 16 Sep 2020 21:49:42 +0100
Message-Id: <20200916204943.41017-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In i40e_clean_rx_irq_zc(), the variable failure is only set when a
condition is met, but then its value is used unconditionally. Fix this.

Addresses-Coverity: 1496986 ("Uninitialized value")
Fixes: 8cbf74149903 ("i40e, xsk: move buffer allocation out of the Rx processing loop")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 6acede0acdca..18c05d23e15e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -364,8 +364,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		napi_gro_receive(&rx_ring->q_vector->napi, skb);
 	}
 
-	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
-		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
+	failure = (cleaned_count >= I40E_RX_BUFFER_WRITE) &&
+		  !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
 
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
-- 
2.28.0

