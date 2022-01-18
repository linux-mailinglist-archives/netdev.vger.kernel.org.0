Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF6491787
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245697AbiARCmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345287AbiARCik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:38:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABF0C06175D;
        Mon, 17 Jan 2022 18:35:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F27C2B81252;
        Tue, 18 Jan 2022 02:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E72DC36AEF;
        Tue, 18 Jan 2022 02:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473308;
        bh=dkmUFr49CybcD04y+WFJD6jn5JBcCH1bqnANrKf9inE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIDJi+aXoe+aq5jIRglbxdA9GHyduCMhhKYAKjgVPcmXHrO0L77QzCi9spQbS3IQ6
         DAjl6Q/fLPytyY5y26PooUlPcZV8yGfIyYIkw7qcGP0qppnVhNaOiFYIaIEEgmyM7a
         +88virpnYSWOb8jWZeS0eNnNQehkhnLTtV1Y9hiTe7jhlgzjUk46+QfEPO7/Ms7eZC
         +48VgvV9su05aAReGb19ViKz3dyEKdblgaMdH8peXOstz5aSleoCvZ9sq1yWwuKYo6
         nsfI3vLMrzZ+RFzdvxDu3LoTfOBW2RIXST8wAzcEUwitGgtXXzO8KauBuaRtTX/xGr
         RV/8WFjX/xDXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        rtl8821cerfe2 <rtl8821cerfe2@protonmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, tony0620emma@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 063/188] rtw88: add quirk to disable pci caps on HP 250 G7 Notebook PC
Date:   Mon, 17 Jan 2022 21:29:47 -0500
Message-Id: <20220118023152.1948105-63-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit c81edb8dddaa36c4defa26240cc19127f147283f ]

8821CE causes random freezes on HP 250 G7 Notebook PC. Add a quirk
to disable pci ASPM capability.

Reported-by: rtl8821cerfe2 <rtl8821cerfe2@protonmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211119052437.8671-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a7a6ebfaa203c..3b367c9085eba 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1738,6 +1738,15 @@ static const struct dmi_system_id rtw88_pci_quirks[] = {
 		},
 		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
 	},
+	{
+		.callback = disable_pci_caps,
+		.ident = "HP HP 250 G7 Notebook PC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 250 G7 Notebook PC"),
+		},
+		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
+	},
 	{}
 };
 
-- 
2.34.1

