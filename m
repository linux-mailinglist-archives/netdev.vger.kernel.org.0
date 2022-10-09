Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1E65F93BF
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 01:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiJIXol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 19:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiJIXoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 19:44:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF731D645;
        Sun,  9 Oct 2022 16:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 762C9B80DE0;
        Sun,  9 Oct 2022 22:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21812C433D6;
        Sun,  9 Oct 2022 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354299;
        bh=jOzHCP97sZyhEDT8ZW1Nzd4MxF091vhwcQ8VD4o8qqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnwCMbEFql3Y14Gs79fpnQ06yjj/Y2arJtD4InQ3RGSBhRugfFjTrzRcfQaKqQ3Pn
         h4HEPAdkH37c1QYtaMwY1MNiWVqfd3COXHpEDC/F+Z3WDmOnWVHC3+E50GXK7LtTsq
         DICaliFUPPbtpC9SXyDSLSDDZ3UKKsZxczcSBOVciwCZAhL8BiRRxzS4Tp1M32CS7J
         l+ftDD0u/WSA2HUrykgZQLTHdqUeSzt3wbHCGfiPN75XxS7g9qs5kgX/itKPhs9xHc
         2kP07MrIvDC7TlCDc9GjaGnnkTN2S/Z9t+8F7eF4TMwyK7E5XhmUm4T5bmcuxVKhuA
         gucFRfQfg5nYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/25] net: ftmac100: fix endianness-related issues from 'sparse'
Date:   Sun,  9 Oct 2022 18:24:14 -0400
Message-Id: <20221009222436.1219411-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222436.1219411-1-sashal@kernel.org>
References: <20221009222436.1219411-1-sashal@kernel.org>
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
index 46a0c47b1ee1..0731d65e856c 100644
--- a/drivers/net/ethernet/faraday/ftmac100.h
+++ b/drivers/net/ethernet/faraday/ftmac100.h
@@ -135,9 +135,9 @@
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
 
@@ -156,9 +156,9 @@ struct ftmac100_txdes {
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

