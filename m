Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1BA5F92BA
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiJIWuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiJIWta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:49:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D91F13E09;
        Sun,  9 Oct 2022 15:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C328E60C2C;
        Sun,  9 Oct 2022 22:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE23C433C1;
        Sun,  9 Oct 2022 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354211;
        bh=5JkOB+HsRfMjF6JdEuT30fBWd/b3+QMJryRmJUvtxG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awOJq9vpNGX94CnG8qd5gRyAlLSbSfeE5T61MY7sE2ZKzMQF9LDYT3YiEjwZot+Wd
         GpJo8flZinpOGgUEqYklRdpgfwhwSLQ70e9wbY69WqnlCDPUk6qp5gR88IAY00wx15
         b+hDehQeigsqeNUuwJR0vy9QZP3H7GwVr3WcvSsGdbcPPUdR1jxOl4ZNAxgmjeEw+T
         F10vaFJAR/HfU6RHA/fyy2mZ1vAbGqZawPxUP36EMZqa6SE3Z1A4ECLOLW8/GYUBIw
         +ORQx5YbNaXcDLCxtdiLtlV57xk5in47sd01x0T9MOoWEcP4zihN8faRt7j1c5S4Cn
         kdFkty6Tg308g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/29] net: ftmac100: fix endianness-related issues from 'sparse'
Date:   Sun,  9 Oct 2022 18:22:46 -0400
Message-Id: <20221009222304.1218873-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222304.1218873-1-sashal@kernel.org>
References: <20221009222304.1218873-1-sashal@kernel.org>
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

