Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFBEF5FB8
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 16:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfKIPPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 10:15:48 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:39440 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfKIPPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 10:15:44 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA9FFbpo066989;
        Sat, 9 Nov 2019 09:15:37 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573312537;
        bh=Adn9YCxB93/dkCBHMnDfzFbMC9kwY9M8O9KGdNuZYdY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=HD/bpT6cvZAyiVEDyvqfSlhxsh5QVsZUoso2P5Jg4IWQQ6kR2j4Qv+qT8VNdN54mZ
         hoPA0+CauaK9DOwXndpax0ZxYqOoFh2LnhVsWfpsTxqKXBVTzDaR9oSFNjOdrnJJzn
         oIQfWG+nv9Gd7W4UjrK2MHx04zOYv5WT4MeXktvA=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA9FFbAn128742
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 9 Nov 2019 09:15:37 -0600
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 9 Nov
 2019 09:15:37 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 9 Nov 2019 09:15:21 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA9FFaH0024134;
        Sat, 9 Nov 2019 09:15:36 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v6 net-next 01/13] net: ethernet: ti: ale: clean ale tbl on init and intf restart
Date:   Sat, 9 Nov 2019 17:15:13 +0200
Message-ID: <20191109151525.18651-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109151525.18651-1-grygorii.strashko@ti.com>
References: <20191109151525.18651-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean CPSW ALE on init and intf restart (up/down) to avoid reading obsolete
or garbage entries from ALE table.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 84025dcc78d5..e7c24396933e 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -779,6 +779,7 @@ void cpsw_ale_start(struct cpsw_ale *ale)
 void cpsw_ale_stop(struct cpsw_ale *ale)
 {
 	del_timer_sync(&ale->timer);
+	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 	cpsw_ale_control_set(ale, 0, ALE_ENABLE, 0);
 }
 
@@ -862,6 +863,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 					ALE_UNKNOWNVLAN_FORCE_UNTAG_EGRESS;
 	}
 
+	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 	return ale;
 }
 
-- 
2.17.1

