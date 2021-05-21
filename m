Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839DE38C8FE
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhEUON5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhEUON4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:13:56 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B566C061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:12:30 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id et19so23646006ejc.4
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L5CFu4dn3XA+N/2fKcNWB5RgzmG66Vx0Z8Z+ktKJ6Ss=;
        b=rQfqiVIZLp1vRCVQ+UDgKZCHZfY37tVCGNUSSF5hw3RjKAQ0/f7RJN1RhFuk+BpvDW
         7L0ChPMYEfVv93qtWV6H8sr4avoFWvGrG5Z/dCH2q85CqY9b2rg/2oJV25FlSvfVmIuM
         bTBgsQmk3vFuYiMWldEPjAV5tZIpiAk3EfPNFasexsWkpjfP1EYPBLHAO4yakKTmU7KS
         zSvcyW9nfpCR0xb3HcP44RO5TAy+74iEFUzyxAKSoqc3YiOSC/+7vZTlKDBJn/8XR6CW
         jXtZzwrerQE+gkXmTcPQQBk7l8Z+KQ80CelrfaVeRCQqB0bNmiyqCt0hw0xQm9iqX8ZS
         LxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L5CFu4dn3XA+N/2fKcNWB5RgzmG66Vx0Z8Z+ktKJ6Ss=;
        b=PqNFmxNEmFpqw2za03eDe8iZnljCUdPFMVYe/kawo0G8oWgc5wwfcXaG7+P8aAtVSb
         8fBM15778HjvoUsUZbHTHSdm0fuRnvLCoQd60eS2XPrPH6f2d8uzBoIqy4xAZZucIaZs
         WXD1vQW0M2zKUtpvGSQY94QavRf1XOyNBXBJ8WMyj8KrWTGWxZYVjylG9hWIcl9VNWhv
         C224qOnOmVDgmVuaMSvxbFlG08ZTeVVudP/Gi9Ty/3VRTmaK36knTWNXzQEltQJOtexl
         s39519KaJ1OXhNAPwoNOaFISbLVQ2jVitYowbG+jCF+FTpr3X1VdNTEKre/HcOpwnUrm
         Cusw==
X-Gm-Message-State: AOAM531E0utyIEGa9W1H5fFrGWWOKiZCVvF9i7xF1rAvhrSOrCIOAob+
        zBnJCgBuRbXL2MbYXIjtRaw=
X-Google-Smtp-Source: ABdhPJyjU8eNj7dNM/FMcPgcaVi6qfUbquqmhNSnA9r03n+SFkyahVEr7wzcbLZs/JDNJeqQfQc1fg==
X-Received: by 2002:a17:906:15c2:: with SMTP id l2mr10621639ejd.348.1621606348830;
        Fri, 21 May 2021 07:12:28 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m10sm4040335edp.48.2021.05.21.07.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 07:12:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] dpaa2-eth: don't print error from dpaa2_mac_connect if that's EPROBE_DEFER
Date:   Fri, 21 May 2021 17:12:20 +0300
Message-Id: <20210521141220.4057221-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When booting a board with DPAA2 interfaces defined statically via DPL
(as opposed to creating them dynamically using restool), the driver will
print an unspecific error message.

This change adds the error code to the message, and avoids printing
altogether if the error code is EPROBE_DEFER, because that is not a
cause of alarm.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index e0c3c58e2ac7..8433aa730c42 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4164,10 +4164,11 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 	if (dpaa2_eth_is_type_phy(priv)) {
 		err = dpaa2_mac_connect(mac);
-		if (err) {
-			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
+		if (err && err != -EPROBE_DEFER)
+			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint: %pe",
+				   ERR_PTR(err));
+		if (err)
 			goto err_close_mac;
-		}
 	}
 
 	return 0;
-- 
2.25.1

