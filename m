Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3FA5B5F
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfIBQ0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44924 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfIBQ0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id 30so3657678wrk.11
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lZCN1B5no/aN8gZppbsxHGrB12VxVY09ikZ3ghVxx6k=;
        b=eCuLQuvwfU3Nmme/1BK1811sefNmQR+AO2gGo87LBpTajMILQU5LClLupF83IGZSQk
         7k9I9YsBSozM+qcTxMPhQ1fbEA7/VKp1SUKTKkztvq95f/CE3yoZ2DeMIwKse6n5cnbW
         HR6mY1oWAmWyOrcTrmzzjY0xUg5PkZpH0n/TvvN3+ovNzeMLrj6bFuvd/aGepB0PR8/m
         xK7PDYQpEtEMdqJ3xJHnXpTMtYxfSSYHg0EDgOw4spTnBvS+smrEb3JaKYtBmJdFDo3F
         XTKxMTXy5IQQrCjMv5VM3kRNi4wC9jXd0mDNbB8tspD3ND5JJQ5koWPJw2LsUmhO+49U
         9LdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lZCN1B5no/aN8gZppbsxHGrB12VxVY09ikZ3ghVxx6k=;
        b=dbBa/XvHEV1koD64UCjyGrzfx2+byHsO/zZ76RhC07/2RZHI9VG1OaQTigtIAKJYyF
         0CXVZn8PV/mYyWrc6GFE/JbwNBFVX1DCYKYdgStWvevKrIHyFCAeihGZp8fvv2TSDj6K
         j2ev0odK7uYcqKccBPELYziScOoVo7NNBerI9xFEZid8N+8YGiOaB1svde15KRw76FG8
         b/GvAmv+aKIKeG5IkwhfE5E+SNdICJFJyBKd8MgdULDQ7NDa+vNY9Ir8OK1vg1R3tYGo
         bp4KqkajyW7n/CcwVqCjgMUkU90Fba4oFTQSCJKjn7pEUw0GbTeL2PfZoA1elZRaTPPG
         niSA==
X-Gm-Message-State: APjAAAVgAQVyOmRV2hEeqpqBjkkXzZmRb9GPj1qhOFnG9zAXW3mlcq2g
        myveKOHDx3vRteJ/cywoma0=
X-Google-Smtp-Source: APXvYqz3I8TPMWQAkZdOM2QNPNTAAcW16Mv/UbUyfNXE8bezytdM0ftjNNn0iM/gKlfhV/W9IR3ztw==
X-Received: by 2002:adf:a415:: with SMTP id d21mr3728614wra.94.1567441577509;
        Mon, 02 Sep 2019 09:26:17 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 10/15] net: dsa: Pass ndo_setup_tc slave callback to drivers
Date:   Mon,  2 Sep 2019 19:25:39 +0300
Message-Id: <20190902162544.24613-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
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
---
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

