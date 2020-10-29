Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8942629E45F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgJ2HiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbgJ2HYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:53 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454E1C0613BF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a200so1365384pfa.10
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FN+YKdDgSUjsd9TeDWmG2gdywodGyUIcs86hwY2qLts=;
        b=Em2TvenTc9L7OHlJeXtU+s4WVmVVJ6OTKTs/lzZIYxq1q3ZeHmEhuT8tiNB2mV1K3j
         51XC10BmOe9mH1kRNkK4DG3u7jk2WPLg6KRhtD/w5BSuSXHJCl6iqt3qAVOBlGuCEwE9
         YovNxXHCh3jS5OPS+COgAWIn9K4xjh2uP4wF0CHhnnGqIen8aDM+Pwzu2NC5LFqmLd7S
         LWFRr0ePp+2Xn00pQXyvXoti93ukNPakRgvVYf9E+/MleZCLbgq3VBZ/0kejqL2xvjlu
         HukZ7YWo/DlPjnLeWscEh7CXMmIjS9cr0fKttkuAikQ8IOTdTIpcFepkruIWrcsJgl0d
         iKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FN+YKdDgSUjsd9TeDWmG2gdywodGyUIcs86hwY2qLts=;
        b=XdolkKH2Bmpn8pcMkjVAzwPLoPvtNaI24tRpR9F1w2/J7fQSc60suc7MzsVQUkJryL
         heVBt8WNzEUCii0JefH8VchXTzTCs8+EfZ62iAZDh+1KkPHerd+qHtGufitgD8buvW0+
         ahLTMGrHA7WE+eGQYwlZ3bU1oyqLwbHbiElDPZiVvqohKLiq/zjoP+NFEn42qDdWlh54
         AqRXtg47LnAIXbDMPbuqph2ks91lbrustQH3gCP1o1VJEgzbinTeUb2BUWHq3IxAI24o
         n+s1eNhjzQ46TB2NPsxVrrHoKbGs5DuTd7AE29K5c4fKW7M4uSC1oCD0dLq2vK16MlBp
         rYaQ==
X-Gm-Message-State: AOAM5311mvEQJIdc50mk3xqTJPhi1SNIoYCdWTDMClZWBbZBw/M+5ZX2
        naUqak5FzjIWSM/DFJOy464=
X-Google-Smtp-Source: ABdhPJz2edm7N6wJSWV5nt/6KFIQgE+kXEkuooFiezwcJ4z0JuPphXu2uLjSMyfHpudufhjNsOaFxA==
X-Received: by 2002:a17:90a:7f81:: with SMTP id m1mr2543577pjl.197.1603948585906;
        Wed, 28 Oct 2020 22:16:25 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:25 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [v2 net-next PATCH 08/10] octeontx2-pf: Calculate LBK link instead of hardcoding
Date:   Thu, 29 Oct 2020 10:45:47 +0530
Message-Id: <1603948549-781-9-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

CGX links are followed by LBK links but number of
CGX and LBK links varies between platforms. Hence
get the number of links present in hardware from
AF and use it to calculate LBK link number.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 8 ++++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index d258109..fc765e8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -531,8 +531,10 @@ static int otx2_get_link(struct otx2_nic *pfvf)
 		link = 4 * ((map >> 8) & 0xF) + ((map >> 4) & 0xF);
 	}
 	/* LBK channel */
-	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE)
-		link = 12;
+	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE) {
+		map = pfvf->hw.tx_chan_base & 0x7FF;
+		link = pfvf->hw.cgx_links | ((map >> 8) & 0xF);
+	}
 
 	return link;
 }
@@ -1503,6 +1505,8 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.tx_chan_base = rsp->tx_chan_base;
 	pfvf->hw.lso_tsov4_idx = rsp->lso_tsov4_idx;
 	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
+	pfvf->hw.cgx_links = rsp->cgx_links;
+	pfvf->hw.lbk_links = rsp->lbk_links;
 }
 EXPORT_SYMBOL(mbox_handler_nix_lf_alloc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index d6253f2..386cb08 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -197,6 +197,8 @@ struct otx2_hw {
 	struct otx2_drv_stats	drv_stats;
 	u64			cgx_rx_stats[CGX_RX_STATS_COUNT];
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
+	u8			cgx_links;  /* No. of CGX links present in HW */
+	u8			lbk_links;  /* No. of LBK links present in HW */
 };
 
 struct otx2_vf_config {
-- 
2.7.4

