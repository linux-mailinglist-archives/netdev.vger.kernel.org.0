Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576DD5F9243
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiJIWrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiJIWqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:46:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C888837FBE;
        Sun,  9 Oct 2022 15:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5C0CB80DCD;
        Sun,  9 Oct 2022 22:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AD6C433C1;
        Sun,  9 Oct 2022 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354124;
        bh=5JkOB+HsRfMjF6JdEuT30fBWd/b3+QMJryRmJUvtxG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Of8GgwzT9ko6fsFF/j6CdnCT51Sj7oO8qsCEw0BhbN/JZSxS2edDmIxz+Ec7On/21
         IKpK1+olv/m30xfkrxzXDiA41UqVdHUwKLJjKhq7k3CxtTQ8lJVqAuJOYdp+SPhVmz
         29m/Ip4EIQ5KMEW62HucUzX2wW+Ixekj0tDUcN/prM77Rzli6wI1tFcxzU/J2AAzux
         Fte62Y6l8zAOm36Fw+NHmCGw3M1ANnkShpIasPaau1mET2tH86FkXJ+TpVhJGttX6O
         E6p3AR9oMQk1VbFDYrop+LSkhHefxWohfJAW5WHHIVIwH69dLIDOdj9dGppE41HfTf
         Q/Qes6lf7dzqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/34] net: ftmac100: fix endianness-related issues from 'sparse'
Date:   Sun,  9 Oct 2022 18:21:06 -0400
Message-Id: <20221009222129.1218277-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>

[ Upstream commit 9df696b3b3a4c96c3219eb87c7bf03fb50e490b8 ]

Sparse found a number of endianness-related issues of these kinds:

.../ftmac100.c:192:32: warning: restricted __le32 degrades to integer

.../ftmac100.c:208:23: warning: incorrect type in assignment (different base types)
.../ftmac100.c:208:23:    expected unsigned int rxdes0
.../ftmac100.c:208:23:    got restricted __le32 [usertype]

.../ftmac100.c:249:23: warning: invalid assignment: &=
.../ftmac100.c:249:23:    left side has type unsigned int
.../ftmac100.c:249:23:    right side has type restricted __le32

.../ftmac100.c:527:16: warning: cast to restricted __le32

Change type of some fields from 'unsigned int' to '__le32' to fix it.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220902113749.1408562-1-saproj@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftmac100.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.h b/drivers/net/ethernet/faraday/ftmac100.h
index fe986f1673fc..8af32f9070f4 100644
--- a/drivers/net/ethernet/faraday/ftmac100.h
+++ b/drivers/net/ethernet/faraday/ftmac100.h
@@ -122,9 +122,9 @@
  * Transmit descriptor, aligned to 16 bytes
  */
 struct ftmac100_txdes {
-	unsigned int	txdes0;
-	unsigned int	txdes1;
-	unsigned int	txdes2;	/* TXBUF_BADR */
+	__le32		txdes0;
+	__le32		txdes1;
+	__le32		txdes2;	/* TXBUF_BADR */
 	unsigned int	txdes3;	/* not used by HW */
 } __attribute__ ((aligned(16)));
 
@@ -143,9 +143,9 @@ struct ftmac100_txdes {
  * Receive descriptor, aligned to 16 bytes
  */
 struct ftmac100_rxdes {
-	unsigned int	rxdes0;
-	unsigned int	rxdes1;
-	unsigned int	rxdes2;	/* RXBUF_BADR */
+	__le32		rxdes0;
+	__le32		rxdes1;
+	__le32		rxdes2;	/* RXBUF_BADR */
 	unsigned int	rxdes3;	/* not used by HW */
 } __attribute__ ((aligned(16)));
 
-- 
2.35.1

