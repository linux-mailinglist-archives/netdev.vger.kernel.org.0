Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F5E568D72
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiGFPfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiGFPfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:35:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D367E2A43B;
        Wed,  6 Jul 2022 08:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4213EB81D97;
        Wed,  6 Jul 2022 15:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F62C341CA;
        Wed,  6 Jul 2022 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121591;
        bh=xGghK/000nkzlwE1Ow+hHRRrqU5Gk5XuDqiFw+ahnJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBd7NheMp9ckJdnloWwK4eMBHfpIOk4gCkw4wk6ocZg35Ech2sKQA277KXxRLrw7u
         8z1MZdD6KS0KbC5srgeUYxC1hQa7XcHS21mp3ovhc0zTwbg1M4sPJnY8I0HvU35B5y
         Kb5265SmVv+lqDtOUwMKKiOjy2choReURELk/Yub72jwC99eyOb1N13EKphnHbmod7
         vzWQ65d7IzBDSObBUIwtNNcz1Gi18TwwikAuTL8Kypb2+ngqfGfdBM/80mqXfeov6Q
         f5jLvR2/upYJL9fuN740ZGCPevtFGD+gtz+tZI09aHbUKc6Y6Nw7dT8wSIuIZ4HBQk
         13+YFF/5lECiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/11] NFC: nxp-nci: don't print header length mismatch on i2c error
Date:   Wed,  6 Jul 2022 11:32:53 -0400
Message-Id: <20220706153256.1598411-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153256.1598411-1-sashal@kernel.org>
References: <20220706153256.1598411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 9577fc5fdc8b07b891709af6453545db405e24ad ]

Don't print a misleading header length mismatch error if the i2c call
returns an error. Instead just return the error code without any error
message.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/i2c.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 9f60e4dc5a90..a45064b3389c 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -122,7 +122,9 @@ static int nxp_nci_i2c_fw_read(struct nxp_nci_i2c_phy *phy,
 	skb_put_data(*skb, &header, NXP_NCI_FW_HDR_LEN);
 
 	r = i2c_master_recv(client, skb_put(*skb, frame_len), frame_len);
-	if (r != frame_len) {
+	if (r < 0) {
+		goto fw_read_exit_free_skb;
+	} else if (r != frame_len) {
 		nfc_err(&client->dev,
 			"Invalid frame length: %u (expected %zu)\n",
 			r, frame_len);
@@ -163,7 +165,9 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
 	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
 
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
-	if (r != header.plen) {
+	if (r < 0) {
+		goto nci_read_exit_free_skb;
+	} else if (r != header.plen) {
 		nfc_err(&client->dev,
 			"Invalid frame payload length: %u (expected %u)\n",
 			r, header.plen);
-- 
2.35.1

