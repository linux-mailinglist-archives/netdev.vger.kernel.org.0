Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E506D474E00
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhLNWnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhLNWnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:43:07 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2782AC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:07 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q17so14734340plr.11
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8Ll/megliBvnHirIhlfhf9sv9I4xbL9uGA2hDg8OW1A=;
        b=oArXG4XItRxuvjy9gbxOQHZcIDmwjotDa55nsFktI/Ns7HH590LpkhKUwUsvi3G4CW
         xqEgzueXDhJEmj/gpQ8vz6zQcCUt03dZ4Ql20t1R0F00j/NYxxshodzKFMBOz0i/AHsF
         qwXQhAD+FPKOHYLXBqDrqWL7MTCns+COl+PIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8Ll/megliBvnHirIhlfhf9sv9I4xbL9uGA2hDg8OW1A=;
        b=S2xblo0Okhl7Sok6ZnLnJS0N03Gc3b7acGB/27xVLNwTHj2sE5ZcupkIWCZbmJJYVN
         z3hI+aNkWKSa+IuA6xLL1pzy67uLnsDAXqt2hje6iLEk/up8ihU05UpDR+YyziGWjn7Y
         midG7pP92r0wb/rcRGtRiEFxi7iWDPl3hp8TSeO/4/fofKgSnRK05Z1P1QH5ptcfeTi9
         W6iHFMn1BhdiO/5QvIvRDBFM3ZHoux8V4dv7KVLMsOKM0K8b1xCwvkxyxCqiDIKbVLFq
         R57KLsOvcVXg1M5fPcOfe0pyyEgS27KNrqiZzuCf+2NOm6DpVbCbvkR5UzTkX93n+rO4
         awoQ==
X-Gm-Message-State: AOAM532hLlGHD0JhesEjOXO5H0Cvg/kAD9St/Wrl1IfK8kN1X1IxK6fY
        sPtDGRYCIb3wdF4aXQEkWC6axw==
X-Google-Smtp-Source: ABdhPJxJHXV4YY3O2ob0ztz1/iKHz1y8Srlj7Vm61kglf3JYUPm93vWiYBIjWXwz1gRDUbvDFsvIZg==
X-Received: by 2002:a17:90b:1c8d:: with SMTP id oo13mr8634212pjb.139.1639521786702;
        Tue, 14 Dec 2021 14:43:06 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id mg12sm3448012pjb.10.2021.12.14.14.43.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:43:06 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [net-queue PATCH 1/5] i40e: Remove rx page reuse double count.
Date:   Tue, 14 Dec 2021 14:42:06 -0800
Message-Id: <1639521730-57226-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
References: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Page reuse was being tracked from two locations:
  - i40e_reuse_rx_page (via 40e_clean_rx_irq), and
  - i40e_alloc_mapped_page

Remove the double count and only count reuse from i40e_alloc_mapped_page
when the page is about to be reused.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 10a83e5..8b3ffb7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1382,8 +1382,6 @@ static void i40e_reuse_rx_page(struct i40e_ring *rx_ring,
 	new_buff->page_offset	= old_buff->page_offset;
 	new_buff->pagecnt_bias	= old_buff->pagecnt_bias;
 
-	rx_ring->rx_stats.page_reuse_count++;
-
 	/* clear contents of buffer_info */
 	old_buff->page = NULL;
 }
-- 
2.7.4

