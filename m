Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554B84C2073
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245196AbiBXANL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiBXAMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F283A5F4DD
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94F1AB80E9F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D61C340EB;
        Thu, 24 Feb 2022 00:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661543;
        bh=CiXXtAHx3NcFJ+ECjVFrIEdbVIYyibRMSEoVmg7cjpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6b58J/d3024aOEVIA/WTheHnn1/I14WW1m2VBKzgDcQSP/JBG/h8AdawciO2XGEs
         OF/D0B7ZJCTBVaVnds9hMsb5rMS4U5pKXr+tGEw2vKNU+9yNphEiP1/OKU23x3pv3t
         U3wf9u8N4fLtjkYv8CGzBNKAchBoXL8jJ+NMJTAA25kU9GnSspqv4fGDR+FLnCzUlU
         Gr9zcAbYGggski5dDTcZIewxx5fy25lPc3hxTHnIxr0YvvPxAmUinRhZmr2O0gwg/f
         tNT+RWMtxYNk1xrrOLiRMLLUxQ7XA9sXm3XwLoNMbh6l+WWEpT63dKzuGDIqmoxFGX
         up/BIUScrkDYQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 11/19] net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets
Date:   Wed, 23 Feb 2022 16:11:15 -0800
Message-Id: <20220224001123.365265-12-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

For RX TLS device-offloaded packets, the HW spec guarantees checksum
validation for the offloaded packets, but does not define whether the
CQE.checksum field matches the original packet (ciphertext) or
the decrypted one (plaintext). This latitude allows architetctural
improvements between generations of chips, resulting in different decisions
regarding the value type of CQE.checksum.

Hence, for these packets, the device driver should not make use of this CQE
field. Here we block CHECKSUM_COMPLETE usage for RX TLS device-offloaded
packets, and use CHECKSUM_UNNECESSARY instead.

Value of the packet's tcp_hdr.csum is not modified by the HW, and it always
matches the original ciphertext.

Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ee0a8f5206e3..6530d7bd5045 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1349,7 +1349,8 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 	}
 
 	/* True when explicitly set via priv flag, or XDP prog is loaded */
-	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state))
+	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state) ||
+	    get_cqe_tls_offload(cqe))
 		goto csum_unnecessary;
 
 	/* CQE csum doesn't cover padding octets in short ethernet
-- 
2.35.1

