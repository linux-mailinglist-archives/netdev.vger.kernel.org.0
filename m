Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816ED48C26D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbiALKj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbiALKj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:39:26 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7C2C06173F;
        Wed, 12 Jan 2022 02:39:26 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so11113063pjj.2;
        Wed, 12 Jan 2022 02:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K0NIo8G/E2+/V1jL9Lj5TwJL8NcpWczVrZhrPFDYFZA=;
        b=HkWSohSwSyaJD7xgaRXAJJE2pMxoDYXEB58fUFFN8Ek103V6Tx+BMKUMko5Vx7mF7T
         rKCqsM349KcmQUit0eT/8/ME/kagr/ngTMZsPJqga7Pl5meFy+xyYPk7QBNCFC9NSY9t
         vXeAdE6WW7tiMtHgz4vifeTelArgoXHD3FvoqyXeAxrCC4kmxgj7PxNyfrZy2vrzojsX
         fCcJBvqBs3cw+A/7XZ4/HO0VdWtuKre6F6nLncCb9PbRBcga94/Am2ePcvXvi4ZeCTSd
         DSCk8CF8CXD2fLbAY6iHQ2nrL9j8m8tauFNo0hD3cW497NO2jWMFD5w79Z9ZXaW5CK1C
         ve7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K0NIo8G/E2+/V1jL9Lj5TwJL8NcpWczVrZhrPFDYFZA=;
        b=g1llqE5VylPK8Z8PsO2YmJX9n9g79JjjgN1Hh8xKmBd2PcljlopAUnPFevnP+XWkk/
         3S6qbRFczrJqql53n3UxzZ6ZKqYTw/VWIw+q4Vt331MEEwhy3PH/52p1nXR6YuoKLZPI
         5gZW4nqeF5+FhDEPG6azL33rN6ecWKHa8OLCcigL2pbWLj3Cx9hHwnAYFoeUyvmcfcRt
         utMcF8lwpmzl7gy+FDZf3mhhExgBN2g3IxBEQONCWiivEUY/PQGqUzQd6xvNnoawwOTY
         OxYDjuMlFm4TazSCS8YP0HOfaOFv25fEAoqO3V0xN7qLicufW0PKMnBZibecHEo248t7
         ByFw==
X-Gm-Message-State: AOAM5317prR9lxsVkhqkO4QvLzbKv6Hf7nPxSbk1GRCUzlcZ0/TT22cI
        R4Ps/fejQcS1stvLsSsOOqpk7HG4oc+IxdI50SQ=
X-Google-Smtp-Source: ABdhPJyeujfw+oZxx87prKcw2MKmxB6OtZ0Gilakf5vZ9fMukxrpAWqqKJMIYF1ztwqLJb1uMo8OyQ==
X-Received: by 2002:a17:90b:388d:: with SMTP id mu13mr8131343pjb.86.1641983965894;
        Wed, 12 Jan 2022 02:39:25 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id q9sm4960097pjg.1.2022.01.12.02.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 02:39:25 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, linmq006@gmail.com,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        liuyonglong@huawei.com, mbrugger@suse.com, netdev@vger.kernel.org,
        salil.mehta@huawei.com, shenyang39@huawei.com,
        yisen.zhuang@huawei.com
Subject: [PATCH v2] net: hns: Fix missing put_device() call in hns_mac_register_phy
Date:   Wed, 12 Jan 2022 10:39:19 +0000
Message-Id: <20220112103919.28894-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220111203333.507ec4f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220111203333.507ec4f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to drop the reference taken by hns_dsaf_find_platform_device
Missing put_device() may cause refcount leak.

Fixes: 804ffe5c6197 ("net: hns: support deferred probe when no mdio")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
Changes in v2:
- add put_device when hns_mac_register_phydev fails.
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 7edf8569514c..cba9d92e057e 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -764,13 +764,16 @@ static int hns_mac_register_phy(struct hns_mac_cb *mac_cb)
 		dev_err(mac_cb->dev,
 			"mac%d mdio is NULL, dsaf will probe again later\n",
 			mac_cb->mac_id);
+		put_device(&pdev->dev);
 		return -EPROBE_DEFER;
 	}
 
 	rc = hns_mac_register_phydev(mii_bus, mac_cb, addr);
-	if (!rc)
+	if (!rc) {
 		dev_dbg(mac_cb->dev, "mac%d register phy addr:%d\n",
 			mac_cb->mac_id, addr);
+		put_device(&pdev->dev);
+	}
 
 	return rc;
 }
-- 
2.17.1

