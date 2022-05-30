Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517665381AC
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240970AbiE3OUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240927AbiE3OQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:16:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0541078A8;
        Mon, 30 May 2022 06:44:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7605860F14;
        Mon, 30 May 2022 13:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC410C385B8;
        Mon, 30 May 2022 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918218;
        bh=VH0lnEDL+ySeSCJhfAcOBhCdDPlruk92FAA23rKWlWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAb6vuUrDP0fIZFfyGLVbiiSuzp0xWf0OM5D/ymRB78s01GvYaX6lMJvPyYZ7zi8I
         7O4VehmMoba5XGLKn3one14XHduHT9LqQmN4z3JM1r6ZC3XtKIpWC3/hVy1xubXAO/
         S0MsgQpxZjVfOJt/i/zDMvEWlzEJM713fdn3axXSubApx+7hoj4mKn0t8ueG0O5eTC
         jsXHqc5WWqvNcSWqyOCUgEi+eSBJBklzNF2F8t74vJ9hyU48d5o5tFvMY1wns1cUx6
         gztLnE46t0Hqfz1q8pQlP5+9/o1v+dBUWw+Frf6rSK/HD3uEF67qbv8wsnh5sAZTNi
         Y9S1ZkmdTf9kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, elder@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 099/109] net: ipa: ignore endianness if there is no header
Date:   Mon, 30 May 2022 09:38:15 -0400
Message-Id: <20220530133825.1933431-99-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 332ef7c814bdd60f08d0d9013d0e1104798b2d23 ]

If we program an RX endpoint to have no header (header length is 0),
header-related endpoint configuration values are meaningless and are
ignored.

The only case we support that defines a header is QMAP endpoints.
In ipa_endpoint_init_hdr_ext() we set the endianness mask value
unconditionally, but it should not be done if there is no header
(meaning it is not configured for QMAP).

Set the endianness conditionally, and rearrange the logic in that
function slightly to avoid testing the qmap flag twice.

Delete an incorrect comment in ipa_endpoint_init_aggr().

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 87e42db1b61e..8e31c2ba5057 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -570,19 +570,23 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
-	val |= HDR_ENDIANNESS_FMASK;		/* big endian */
-
-	/* A QMAP header contains a 6 bit pad field at offset 0.  The RMNet
-	 * driver assumes this field is meaningful in packets it receives,
-	 * and assumes the header's payload length includes that padding.
-	 * The RMNet driver does *not* pad packets it sends, however, so
-	 * the pad field (although 0) should be ignored.
-	 */
-	if (endpoint->data->qmap && !endpoint->toward_ipa) {
-		val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
-		/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
-		val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
-		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+	if (endpoint->data->qmap) {
+		/* We have a header, so we must specify its endianness */
+		val |= HDR_ENDIANNESS_FMASK;	/* big endian */
+
+		/* A QMAP header contains a 6 bit pad field at offset 0.
+		 * The RMNet driver assumes this field is meaningful in
+		 * packets it receives, and assumes the header's payload
+		 * length includes that padding.  The RMNet driver does
+		 * *not* pad packets it sends, however, so the pad field
+		 * (although 0) should be ignored.
+		 */
+		if (!endpoint->toward_ipa) {
+			val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
+			/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
+			val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
+			/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+		}
 	}
 
 	/* HDR_PAYLOAD_LEN_INC_PADDING is 0 */
@@ -738,8 +742,6 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 			close_eof = endpoint->data->rx.aggr_close_eof;
 			val |= aggr_sw_eof_active_encoded(version, close_eof);
-
-			/* AGGR_HARD_BYTE_LIMIT_ENABLE is 0 */
 		} else {
 			val |= u32_encode_bits(IPA_ENABLE_DEAGGR,
 					       AGGR_EN_FMASK);
-- 
2.35.1

