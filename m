Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C9D52BA00
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiERM2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbiERM2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:28:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4533E14CA3D;
        Wed, 18 May 2022 05:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68B17B81FB7;
        Wed, 18 May 2022 12:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F61C385AA;
        Wed, 18 May 2022 12:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876862;
        bh=v50uETX7g7YMrbL1KvaOCnvkl++jQQhG0ddga8Pvxtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sej3273q3Pqb4byT4jRiYe7Iwo6FuOWmcxfdKqbaAAT6ABNoVemo3Otae/sUleFqk
         MKfXPvMT/DEtYuIf1/AEgQpXcvSwJ+ryM/ix7+zBhEkMdid6F1G8a8hhw5n/dQ6EBB
         fRBVbFnzcDyPw4qCN9b0oeRcZw20vAA8Ejcid7l0BaQrHN5H8Dh5YyTbhXfZ6D35Uf
         jc+wxEMBSEcvvuEkSixxHQIPbIvxko6yB6MQiCiddbv5u18CtNSaI8fJvO0TCVf+e9
         2w6o08zGA3NoNgsDRooD6BxgIxl/qd2xfnDtlbgXs93iKSe1YNgmOMPD00BGAh+j6V
         ameZfU4VKtODA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Grundler <grundler@chromium.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 21/23] net: atlantic: verify hw_head_ lies within TX buffer ring
Date:   Wed, 18 May 2022 08:26:34 -0400
Message-Id: <20220518122641.342120-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>

[ Upstream commit 2120b7f4d128433ad8c5f503a9584deba0684901 ]

Bounds check hw_head index provided by NIC to verify it lies
within the TX buffer ring.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index d875ce3ec759..15ede7285fb5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -889,6 +889,13 @@ int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 		err = -ENXIO;
 		goto err_exit;
 	}
+
+	/* Validate that the new hw_head_ is reasonable. */
+	if (hw_head_ >= ring->size) {
+		err = -ENXIO;
+		goto err_exit;
+	}
+
 	ring->hw_head = hw_head_;
 	err = aq_hw_err_from_flags(self);
 
-- 
2.35.1

