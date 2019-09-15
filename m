Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2C3B2DB6
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 04:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfIOCAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 22:00:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33525 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfIOCAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 22:00:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id r17so4612399wme.0
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 19:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ILZ3lugDmKn09GfZoOkEbtjBpM/LlLYwrlzqqe1k6kk=;
        b=Cvaa0FusfatXDlgWccWDRKuwKbdIjTJTJzrhqlr2m3ZhB7U3mTDyPk0ACMWmOHPDuz
         WwsdkYhBOSA9I0E0K0j/nnkP2ZkSAWw7Dow0eBuSeCnvAjUayYP9aL62oHhSWTqSLGMD
         sXImog1gZTE1sFxSgYY/XieBXYglZDtK1yjzp8BfS9nE1R01URugNqLHXBrkteSSSdI5
         qmlBW+5xqxNRjD8pgTyqUK2ythcLpcqfSldCseaCRDV4jgAubjbJV6ZELzLznvHL5yrB
         Sy84uj7mbNbzEgiTlbb97pmsf7sPzNL04PORK6315LXlL9DPkmzhuyLFe08vFfO2/3R7
         bnmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ILZ3lugDmKn09GfZoOkEbtjBpM/LlLYwrlzqqe1k6kk=;
        b=NNqL+7/k683djVw3UIl2HnIiRiOh58OW9ewhMtrKivdJCo9URA83FEGZj+sKceTr7y
         PECFoPdiD61G/xSYaFePfToX/w3DHxiFM4oMgI21YrlC0VdB5al7vsMif2dkxFOu9I32
         kPzgmvt1gKk21jrrwZSIO1ZPdts12Jhkw9zT/3xs+o9V9BHvlDg2H4jHwtvNlPWiVxbB
         wY0NJ2qZa4nVdJuHgHDSU0VqzcoHIqlBUdcHL3J13LLA1Z+zK3HEtozp/h37auniz6x/
         5dvjmMbnue7mERDfb8T90PKynAs29mjdF0uXNgJnvgqUK5cnOVRLXSy7vbpa+H6vn4BX
         2YRQ==
X-Gm-Message-State: APjAAAWuqOE6/7wUSRmEPgWqeWyifFiwiw7at9ZwT/6uVt+z8/qwXtNL
        dwcSDCd/HbvDH6A00QfPnDM=
X-Google-Smtp-Source: APXvYqzFPx0Y9FLby0nmV9K6yMYZPgLeTWWogaJDzRRIa6Ym8h0Hf5045/RvtPVrGeNxsZ9s5ElgIg==
X-Received: by 2002:a7b:c844:: with SMTP id c4mr9088163wml.7.1568512811991;
        Sat, 14 Sep 2019 19:00:11 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id q15sm7216333wmb.28.2019.09.14.19.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 19:00:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        jose.abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 2/6] net: dsa: Pass ndo_setup_tc slave callback to drivers
Date:   Sun, 15 Sep 2019 04:59:59 +0300
Message-Id: <20190915020003.27926-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915020003.27926-1-olteanv@gmail.com>
References: <20190915020003.27926-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA currently handles shared block filters (for the classifier-action
qdisc) in the core due to what I believe are simply pragmatic reasons -
hiding the complexity from drivers and offerring a simple API for port
mirroring.

Extend the dsa_slave_setup_tc function by passing all other qdisc
offloads to the driver layer, where the driver may choose what it
implements and how. DSA is simply a pass-through in this case.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes since v2:
- Added Florian Fainelli's Reviewed-by.

Changes since v1:
- Added Kurt Kanzenbach's Acked-by.

Changes since RFC:
- Removed the unused declaration of struct tc_taprio_qopt_offload.

 include/net/dsa.h |  2 ++
 net/dsa/slave.c   | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96acb14ec1a8..541fb514e31d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -515,6 +515,8 @@ struct dsa_switch_ops {
 				   bool ingress);
 	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror);
+	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type, void *type_data);
 
 	/*
 	 * Cross-chip operations
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9a88035517a6..75d58229a4bd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1035,12 +1035,16 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
-	switch (type) {
-	case TC_SETUP_BLOCK:
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (type == TC_SETUP_BLOCK)
 		return dsa_slave_setup_tc_block(dev, type_data);
-	default:
+
+	if (!ds->ops->port_setup_tc)
 		return -EOPNOTSUPP;
-	}
+
+	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
 }
 
 static void dsa_slave_get_stats64(struct net_device *dev,
-- 
2.17.1

