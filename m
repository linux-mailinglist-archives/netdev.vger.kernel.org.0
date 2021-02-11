Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDECD3191AB
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 18:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhBKR4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 12:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbhBKRyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 12:54:20 -0500
Received: from relay04.th.seeweb.it (relay04.th.seeweb.it [IPv6:2001:4b7a:2000:18::165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EF3C061788
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 09:54:05 -0800 (PST)
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id EFE811F881;
        Thu, 11 Feb 2021 18:50:17 +0100 (CET)
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
To:     elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Subject: [PATCH v1 2/7] net: ipa: endpoint: Don't read unexistant register on IPAv3.1
Date:   Thu, 11 Feb 2021 18:50:10 +0100
Message-Id: <20210211175015.200772-3-angelogioacchino.delregno@somainline.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On IPAv3.1 there is no such FLAVOR_0 register so it is impossible
to read tx/rx channel masks and we have to rely on the correctness
on the provided configuration.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
---
 drivers/net/ipa/ipa_endpoint.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 06d8aa34276e..10c477e1bb90 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1659,6 +1659,15 @@ int ipa_endpoint_config(struct ipa *ipa)
 	u32 max;
 	u32 val;
 
+	/* Some IPA versions don't provide a FLAVOR register and we cannot
+	 * check the rx/tx masks hence we have to rely on the correctness
+	 * of the provided configuration.
+	 */
+	if (ipa->version == IPA_VERSION_3_1) {
+		ipa->available = U32_MAX;
+		return 0;
+	}
+
 	/* Find out about the endpoints supplied by the hardware, and ensure
 	 * the highest one doesn't exceed the number we support.
 	 */
-- 
2.30.0

