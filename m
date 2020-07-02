Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3AB212816
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgGBPhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgGBPhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:37:50 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6ABC08C5C1;
        Thu,  2 Jul 2020 08:37:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w2so12838949pgg.10;
        Thu, 02 Jul 2020 08:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m1fTPOms7HfNTYc8QafSCZasiJ/Gyb5Jn/b+AGL8eyI=;
        b=JtDEB+H5kQ3MV2/5t5nfLpbDJFYrh5Onf+piei00axIsFy3f2QI6X0uCqjYdcgGx7b
         6FM+4TAhZLlE1gy29Zay9BcHlgc75sobkhoa7twO0yg76WaihpSDR02l+a92EVCRdA+J
         QslusQFJN0yXlC/DZpgJ01NCyiENJUVstNCTW5juFbQS7XZ0PCAnoS5JSwKHqfLNL8YE
         2G3qgKvPYZA074XB9aGgIFwiIToSrfbYxJyBONDzg57rigb5Wa+XEZVjskZJWykJknsQ
         oC2QF4CNS15Eg4Wsmb50oSTuPw2UDramYjL97FB9Ap1T4ajx7J5De3e3YbHnFlXZOuc8
         NQuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m1fTPOms7HfNTYc8QafSCZasiJ/Gyb5Jn/b+AGL8eyI=;
        b=E2j3NTVkWJnT0xK7NshNYyUaFPe30aCySuq2oJlwPZe0ecJHFByz32h/r4VD2qk9Im
         HIfD79vITeBikSNqT2+UtxkgM+JSxA+jGUynb6wZ2FU2WpxoxlFzndwClNYADZJ/0q5y
         HurVg67vtrHzDZnwFI9mYI7G+EAm77YdA0Kyeqfb3Iq1dhPhLyElYS56OrnDoEhJ+IsF
         9c1qshI0zLPYwjj0wqwlIZJLDlPRvyWU2sxGUtfm1wOpWvS67eeohpwMNJe7Na48w2o3
         zGv42umuP4K/ZI1Rc0572BTN+RnO67kPu1gc2dMywD5kqzgNMHegOBICzNgPYwAKAS9Q
         4ySQ==
X-Gm-Message-State: AOAM530WJh1hvqnd7UlSEL4V0Epkq7soybL1QIRhRcclwM8YYgmiJf7S
        LRDbHiHsg8n5lsVEtf5/2Co=
X-Google-Smtp-Source: ABdhPJxDLBb6iDqdP109wdVQ5Ck5yUF6UL5pu5Rb6KHGe8evc0pz4Dx+bhqsXsNNpqx6q529EC3W5A==
X-Received: by 2002:a63:3603:: with SMTP id d3mr22361536pga.200.1593704270379;
        Thu, 02 Jul 2020 08:37:50 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id r6sm552651pgn.65.2020.07.02.08.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 08:37:49 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 3/4] i40e, xsk: increase budget for AF_XDP path
Date:   Thu,  2 Jul 2020 17:37:29 +0200
Message-Id: <20200702153730.575738-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702153730.575738-1-bjorn.topel@gmail.com>
References: <20200702153730.575738-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The napi_budget, meaning the number of received packets that are
allowed to be processed for each napi invocation, takes into
consideration that each received packet is aimed for the kernel
networking stack.

That is not the case for the AF_XDP receive path, where the cost of
each packet is significantly less. Therefore, this commit disregards
the napi budget and increases it to 256. Processing 256 packets
targeted for AF_XDP is still less work than 64 (napi budget) packets
going to the kernel networking stack.

The performance for the rx_drop scenario is up 7%.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 1f2dd591dbf1..99f4afdc403d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -265,6 +265,8 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
 	rx_ring->next_to_clean = ntc;
 }
 
+#define I40E_XSK_CLEAN_RX_BUDGET 256U
+
 /**
  * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
  * @rx_ring: Rx ring
@@ -280,7 +282,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	bool failure = false;
 	struct sk_buff *skb;
 
-	while (likely(total_rx_packets < (unsigned int)budget)) {
+	while (likely(total_rx_packets < I40E_XSK_CLEAN_RX_BUDGET)) {
 		union i40e_rx_desc *rx_desc;
 		struct xdp_buff **bi;
 		unsigned int size;
-- 
2.25.1

