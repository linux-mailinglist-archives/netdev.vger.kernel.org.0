Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B919212818
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgGBPhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgGBPhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:37:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CB0C08C5C1;
        Thu,  2 Jul 2020 08:37:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so13640945pgk.4;
        Thu, 02 Jul 2020 08:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EJHzwQeUZ0xuP9kyR3NwUw0Jve9REFyd3K7jc8FI3Bo=;
        b=RiZkdC0vVS7MQJeL5PA8mQtv7EUP1A8hDG0JB4gU5F7mEzMUnHeQ8KRwN84yRwIuIW
         tHm1ImIKVGSxH5ESVFregzj1EJ2BW6h1Y6DgMJ6xVXklSv3T8q28G106WOWnFhe4wLlk
         PPFNbSje1TsHkPOr/2OjiLL88JENwnfuRFhvLfSVQIxf9Mi3emWVJimcy+KJ6eCprIBW
         Y1+zdhw/hqj+u+zD2xO99UCNdZVSRKf5sj1pSyjYFj/samEe+KTMajs5dzf0VSyVTjGz
         RqRtMA3y0dKsOAY5aszcN43NsrlksKBkwY0YeSCvr0v7TccLytaMnBvRFahK14v4J6w6
         zxbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJHzwQeUZ0xuP9kyR3NwUw0Jve9REFyd3K7jc8FI3Bo=;
        b=V309J/IdWR4qCN5rsCISAY3o1NDM+dXIJZiC/GY23jHlC6/4zhn/LQnxGwKU0Z/Tvk
         f7vCHWVZ0W8lJl/qQMgUgYr+TpztOkEmM2oA7M1XYIELdQe23ciYzg2KkLG3QbMrEDX5
         A6gU5u0MGn8qFQqSvT2lXOt1lOaP+dDD04j5eFEWYJINKgU9rcx2J19EcGTUFp2kb+bQ
         e9ADy1puG6OSDrcA4gek+uMUuMt3KCVnugyWDPg8aANRbw8I4nIJejoRD+bTlgWJ+vbd
         TGGuocZUhNzKhHlp478/+c9eznRC+Fx83pckCw2edYPo8oXOYO53yTwzWPzDs+JPZ9Dy
         nWEw==
X-Gm-Message-State: AOAM532i+hnV60zA2bJmfsWFYQYyKOko1baaESWYEROn9tC5/pvtxp2u
        WqFLMmhs3WbgEraZm8tNtMY=
X-Google-Smtp-Source: ABdhPJxfUhs77muGJZnmT3DE+a9bBDaHjPbF2RxuxikhCFnuvalySp2UztdkfYP1I8hPQLj0h29TOA==
X-Received: by 2002:a63:2b91:: with SMTP id r139mr26333348pgr.61.1593704273094;
        Thu, 02 Jul 2020 08:37:53 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id r6sm552651pgn.65.2020.07.02.08.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 08:37:52 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 4/4] i40e, xsk: move buffer allocation out of the Rx processing loop
Date:   Thu,  2 Jul 2020 17:37:30 +0200
Message-Id: <20200702153730.575738-5-bjorn.topel@gmail.com>
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

Instead of checking in each iteration of the Rx packet processing
loop, move the allocation out of the loop and do it once for each napi
activation.

For AF_XDP the rx_drop benchmark was improved by 6%.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 99f4afdc403d..91aee16fbe72 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -279,8 +279,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	unsigned int xdp_res, xdp_xmit = 0;
-	bool failure = false;
 	struct sk_buff *skb;
+	bool failure;
 
 	while (likely(total_rx_packets < I40E_XSK_CLEAN_RX_BUDGET)) {
 		union i40e_rx_desc *rx_desc;
@@ -288,13 +288,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		unsigned int size;
 		u64 qword;
 
-		if (cleaned_count >= I40E_RX_BUFFER_WRITE) {
-			failure = failure ||
-				  !i40e_alloc_rx_buffers_zc(rx_ring,
-							    cleaned_count);
-			cleaned_count = 0;
-		}
-
 		rx_desc = I40E_RX_DESC(rx_ring, rx_ring->next_to_clean);
 		qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
 
@@ -369,6 +362,9 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		napi_gro_receive(&rx_ring->q_vector->napi, skb);
 	}
 
+	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
+		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
+
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
-- 
2.25.1

