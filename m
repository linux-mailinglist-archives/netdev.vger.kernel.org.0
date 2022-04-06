Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B9B4F603C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbiDFNxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiDFNwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:52:51 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0DF57A89E;
        Wed,  6 Apr 2022 04:40:26 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2369iAKI124025;
        Wed, 6 Apr 2022 04:44:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649238250;
        bh=4Z/SWcBdgq7gJXZF6aYCxpS+F1uJ0waLtD4QLHJH0F4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=qzDoZRJGYv4ZT2wUdA1kWyW0e7Cd2oVKOZwUtvd4g2dpM7HWa0DsG6FiMyRytmQyf
         UYyQoh3tJKe5hespHNrqNkbNByZC2pEUOC2Arw8qqIO1sylO0ytm+q8MsDl6s/2r+o
         muZ++ndTfBNz3sBmoC+Z57XILV6anPN1xD7ZNW+g=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2369iAJ6069701
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Apr 2022 04:44:10 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Apr 2022 04:44:10 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Apr 2022 04:44:10 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2369i86x107588;
        Wed, 6 Apr 2022 04:44:09 -0500
From:   Puranjay Mohan <p-mohan@ti.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <bjorn.andersson@linaro.org>, <mathieu.poirier@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>,
        <linux-remoteproc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nm@ti.com>, <ssantosh@kernel.org>, <s-anna@ti.com>,
        <p-mohan@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <vigneshr@ti.com>, <kishon@ti.com>
Subject: [RFC 03/13] remoteproc: pru: Make sysfs entries read-only for PRU client driven boots
Date:   Wed, 6 Apr 2022 15:13:48 +0530
Message-ID: <20220406094358.7895-4-p-mohan@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406094358.7895-1-p-mohan@ti.com>
References: <20220406094358.7895-1-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The PRU remoteproc driver is not configured for 'auto-boot' by default,
and allows to be booted either by in-kernel PRU client drivers or by
userspace using the generic remoteproc sysfs interfaces. The sysfs
interfaces should not be permitted to change the remoteproc firmwares
or states when a PRU is being managed by an in-kernel client driver.
Use the newly introduced remoteproc generic 'sysfs_read_only' flag to
provide these restrictions by setting and clearing it appropriately
during the PRU acquire and release steps.

Signed-off-by: Suman Anna <s-anna@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
---
 drivers/remoteproc/pru_rproc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index 7a35b400287a..9fed3e0372d3 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -231,6 +231,7 @@ struct rproc *pru_rproc_get(struct device_node *np, int index,
 	}
 
 	pru->client_np = np;
+	rproc->sysfs_read_only = true;
 
 	mutex_unlock(&pru->lock);
 
@@ -265,6 +266,7 @@ void pru_rproc_put(struct rproc *rproc)
 	}
 
 	pru->client_np = NULL;
+	rproc->sysfs_read_only = false;
 	mutex_unlock(&pru->lock);
 
 	put_device(&rproc->dev);
-- 
2.17.1

