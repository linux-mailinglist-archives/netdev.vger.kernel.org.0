Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D094A615AF
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGGR3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:29:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45644 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbfGGR3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 13:29:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so14553514wre.12
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 10:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CH51aSesznl4kwGflBayqjxgdgAPJwL8UP0YMdZG+IM=;
        b=tKrD7hyGCw7lO8DIRMq/9Fb7ikPIqyt/8Bw5HDPbb/Dhs06r3eUlNSiQ3cOZQ9GxZ/
         XzvEl0pqMB+NxmqtMgiYHsYzbPSAyElNQJEqNTBflWaFmOGcl0yiJRWR+Ui4SBrY9NcA
         jBwnBbCKgJESkGc6LARx6X3MRSkvSlLFcbWuz02NaUP1HgQ4MZlXnFwPcxWb4AJedCj1
         058ZDAwotFZVcD6ZjarsRIMRMM99ucC4KQr3S6sqvRY7QbtXvsymvN+1D0hbP3YehPc1
         WXO04R404u/iWbnp2E3yeSGVNuKGyA0W1dRO1rm4wDhwWd9jt0QWS0Kxby9Gca1sCSd6
         QNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CH51aSesznl4kwGflBayqjxgdgAPJwL8UP0YMdZG+IM=;
        b=YWJNpuEKeCL//PMfrUn5HkwJQiqrp4SoeQwSYoMkoK0swqS7r1TBTqx96F50cYmB5m
         APrnf4FYL9Vk/ScvE5YY1LYzcHS+ws+blv8ayzWBUyS3Lj970wfDSX8lz9A/W79E9Jeg
         blpwbsbCV+N8SjLR70QphQXRwvsZYk8lOjfpY6w+yce1yCQ/uZn6xF3BaLNxjYE1gtNm
         Hw27DO2UXrWDD95prOcBk3/WNK1pEbyFZmAIkKHLTVPO1irYW16XlPa9B5W461Wz5XBX
         0fkiVzJx/m3Zq7ZK32xCLGodenZAVw5uBbUPO51I/wXCe+fTxiWKFP9xLLW7r/VZGYUA
         TlQg==
X-Gm-Message-State: APjAAAXmRRmcz0xWlKoPtx8VUohrS/0cZ1f1QijlNOu1/ehX/pqBeZew
        AC4edNgA9A6x4p1/vSlU+j0=
X-Google-Smtp-Source: APXvYqzXNLSd0u4Z12bR0rTTLZ1h38fUjEBOckd/xIWuvsFL/p6GKv27DJ9Xg7Ga1wU1Ssoammmr/g==
X-Received: by 2002:adf:eb51:: with SMTP id u17mr13848190wrn.257.1562520576700;
        Sun, 07 Jul 2019 10:29:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id g14sm14280463wro.11.2019.07.07.10.29.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 10:29:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 3/6] net: dsa: Pass tc-taprio offload to drivers
Date:   Sun,  7 Jul 2019 20:29:18 +0300
Message-Id: <20190707172921.17731-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190707172921.17731-1-olteanv@gmail.com>
References: <20190707172921.17731-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc-taprio is a qdisc based on the enhancements for scheduled traffic
specified in IEEE 802.1Qbv (later merged in 802.1Q).  This qdisc has
a software implementation and an optional offload through which
compatible Ethernet ports may configure their egress 802.1Qbv
schedulers.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h |  3 +++
 net/dsa/slave.c   | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1e8650fa8acc..e7ee6ac8ce6b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -152,6 +152,7 @@ struct dsa_mall_tc_entry {
 	};
 };
 
+struct tc_taprio_qopt_offload;
 
 struct dsa_port {
 	/* A CPU port is physically connected to a master device.
@@ -516,6 +517,8 @@ struct dsa_switch_ops {
 				   bool ingress);
 	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror);
+	int	(*port_setup_taprio)(struct dsa_switch *ds, int port,
+				     struct tc_taprio_qopt_offload *qopt);
 
 	/*
 	 * Cross-chip operations
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 99673f6b07f6..2bae33788708 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -965,12 +965,26 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 	}
 }
 
+static int dsa_slave_setup_tc_taprio(struct net_device *dev,
+				     struct tc_taprio_qopt_offload *f)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_setup_taprio)
+		return -EOPNOTSUPP;
+
+	return ds->ops->port_setup_taprio(ds, dp->index, f);
+}
+
 static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return dsa_slave_setup_tc_block(dev, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return dsa_slave_setup_tc_taprio(dev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

