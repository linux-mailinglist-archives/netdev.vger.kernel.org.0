Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA5735A71F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhDIT2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbhDIT2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 15:28:32 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66615C061762
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 12:28:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q5so4872063pfh.10
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 12:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAlolb+nFukIX488vAQ2j0brufOL/+wIC7BRfRzHTcA=;
        b=AcmphFtOvrg8CdaHRDwYrUGhquSdMfoSoM51rnnMYSw6JxkfZINePMVKYMnuhzxowi
         53dbqTfktKhXAnOIbzc+UUgeOwqnlYrEoz7liwBD3GtADYcm2WJzI85KbUOzTrYYjcKU
         m6YN00JZHACelNWYjfUwbHJbNmlIWGy228jE7hfMjHdoPntXB7BwjD0TCO7kT18hQYF9
         TQvuXMuRoHfzzxGjIo7uIbs+HlExTeVBtipivuvq4ysFLCgt/O5+ai35otVZN3XCfJNt
         9lH2U+cWL5xfCu3pZTISatUbnndBT6mMbNnUZ7z4roEy8dgMXaHbY2SNt1uADFu21i/S
         /Bfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAlolb+nFukIX488vAQ2j0brufOL/+wIC7BRfRzHTcA=;
        b=YriOea1pjgPsjDFTAeAWocLmbufWv3ETJAc4jnzUFrCrHdNfanKN1d6QVInBzGlkfv
         7tZl3b0cNqwcscid2dP/uiNjGcsplSmG0nyApj1urFAImWoXUOqWKNoNCQ43ch0S8PgY
         dDzWgncRvoGzh7sdMMa7EZ/2JYAB3FSAxIdjo1pf8WujgK+ykN1T7cqsyePhS3OjWSKl
         5/OKSOTdVgBjTjh42TlWIbwogop6Baijf+NTAwWplYCECpiq1L1cachA4v19APYMJw6H
         QcjmcrzALcK9vTymMqB4eN8E/K8wnP94tG2vtBPqc/wbIhh8cDDDiiQv+I444skwuydF
         Cklg==
X-Gm-Message-State: AOAM530ld0bb3Mn25qMLKrO/3RbyEs9gGeYj9cfkkroPjKGkHG+vnv8D
        nHfgEzoi5Ulbsiu9RNFuC0QOvZEIORViuw==
X-Google-Smtp-Source: ABdhPJzZhfKAl8F0P7ohajP9qAMeOdcMMBMPY8LU5t08t0QEdJWpuCXA4KLZBFigle5GNoY64VRWzg==
X-Received: by 2002:a62:5fc6:0:b029:244:2464:d416 with SMTP id t189-20020a625fc60000b02902442464d416mr9637523pfb.22.1617996498852;
        Fri, 09 Apr 2021 12:28:18 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l10sm2966715pfc.125.2021.04.09.12.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 12:28:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: enetc: fix TX ring interrupt storm
Date:   Fri,  9 Apr 2021 22:27:59 +0300
Message-Id: <20210409192759.3895104-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The blamed commit introduced a bit in the TX software buffer descriptor
structure for determining whether a BD is final or not; we rearm the TX
interrupt vector for every frame (hence final BD) transmitted.

But there is a problem with the patch: it replaced a condition whose
expression is a bool which was evaluated at the beginning of the "while"
loop with a bool expression that is evaluated on the spot: tx_swbd->is_eof.

The problem with the latter expression is that the tx_swbd has already
been incremented at that stage, so the tx_swbd->is_eof check is in fact
with the _next_ software BD. Which is _not_ final.

The effect is that the CPU is in 100% load with ksoftirqd because it
does not acknowledge the TX interrupt, so the handler keeps getting
called again and again.

The fix is to restore the code structure, and keep the local bool is_eof
variable, just to assign it the tx_swbd->is_eof value instead of
!!tx_swbd->skb.

Fixes: d504498d2eb3 ("net: enetc: add a dedicated is_eof bit in the TX software BD")
Reported-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 57049ae97201..65f7f63c9bad 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -406,6 +406,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
 		struct xdp_frame *xdp_frame = enetc_tx_swbd_get_xdp_frame(tx_swbd);
 		struct sk_buff *skb = enetc_tx_swbd_get_skb(tx_swbd);
+		bool is_eof = tx_swbd->is_eof;
 
 		if (unlikely(tx_swbd->check_wb)) {
 			struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -453,7 +454,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		}
 
 		/* BD iteration loop end */
-		if (tx_swbd->is_eof) {
+		if (is_eof) {
 			tx_frm_cnt++;
 			/* re-arm interrupt source */
 			enetc_wr_reg_hot(tx_ring->idr, BIT(tx_ring->index) |
-- 
2.25.1

