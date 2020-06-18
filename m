Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6048A1FE5C7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbgFRC23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgFRBQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7E021D7E;
        Thu, 18 Jun 2020 01:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442983;
        bh=ayq39hrcp+i5cy2enrcPygmAlrz8ZDw5GbJFABnlySw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuOGbGsM2+Fx1ya1LFDlcb3yUIlji37CmzxORk1bVHSmagNe/nNdNUvNFdJKF48th
         4JgQ7SZFPrvmlT9KGK2bxg1lNcNS3PtDejgjqx3PQLTOidD3kSUkEs0K7tOWJYxejk
         sTXRzXmxU5a2z28lZNbTnlnMDgZXTO47kBMrdqBM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 384/388] net: ipa: program upper nibbles of sequencer type
Date:   Wed, 17 Jun 2020 21:08:01 -0400
Message-Id: <20200618010805.600873-384-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 636edeaad5577b6023f0de2b98a010d1cea73607 ]

The upper two nibbles of the sequencer type were not used for
SDM845, and were assumed to be 0.  But for SC7180 they are used, and
so they must be programmed by ipa_endpoint_init_seq().  Fix this bug.

IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP doesn't have a descriptive
comment, so add one.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 6 ++++--
 drivers/net/ipa/ipa_reg.h      | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a21534f1462f..1d823ac0f6d6 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -669,10 +669,12 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	u32 seq_type = endpoint->seq_type;
 	u32 val = 0;
 
+	/* Sequencer type is made up of four nibbles */
 	val |= u32_encode_bits(seq_type & 0xf, HPS_SEQ_TYPE_FMASK);
 	val |= u32_encode_bits((seq_type >> 4) & 0xf, DPS_SEQ_TYPE_FMASK);
-	/* HPS_REP_SEQ_TYPE is 0 */
-	/* DPS_REP_SEQ_TYPE is 0 */
+	/* The second two apply to replicated packets */
+	val |= u32_encode_bits((seq_type >> 8) & 0xf, HPS_REP_SEQ_TYPE_FMASK);
+	val |= u32_encode_bits((seq_type >> 12) & 0xf, DPS_REP_SEQ_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 3b8106aa277a..0a688d8c1d7c 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -455,6 +455,8 @@ enum ipa_mode {
  *	second packet processing pass + no decipher + microcontroller
  * @IPA_SEQ_DMA_DEC:		DMA + cipher/decipher
  * @IPA_SEQ_DMA_COMP_DECOMP:	DMA + compression/decompression
+ * @IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP:
+ *	packet processing + no decipher + no uCP + HPS REP DMA parser
  * @IPA_SEQ_INVALID:		invalid sequencer type
  *
  * The values defined here are broken into 4-bit nibbles that are written
-- 
2.25.1

