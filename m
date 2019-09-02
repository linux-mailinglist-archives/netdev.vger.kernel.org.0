Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31ED5A5B50
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfIBQ0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50938 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfIBQ0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id c10so3300422wmc.0
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HxVrGfZEhdmrDD8DRRB8CmAhRn3ew5PmJBv3GJJSzUY=;
        b=kAnHWsCN1/FKXfs772MpcbKHHCgLBPUHylg0QnFcVtymxPdadupPrOsjerZFuhVMcv
         uAuaULIxNRDRTkHM+viH1T8VC+HqvrPF4R2JxdxJmUIZf2eOlEuHU3uMphhF3WYBOVVz
         tfyZhX9djR1n1bw0ObeV4qHVWEfqS4Kmz0XQfubcCPO3TbRkVRy3f1hZaG5QdolaC2Lc
         8gs98B5KsqJAhek/fJTpQvF44xL9il/M3QJ3JvO0w+BbLJrDC1HoR2q1Hzqe1kpYxlcc
         sWk+qJIo6M8lss9BughIR9E8i/P2NO6nhL/nqBMBUT6w1rQ/9uzSVlTiWztIDra5/5Bu
         fpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HxVrGfZEhdmrDD8DRRB8CmAhRn3ew5PmJBv3GJJSzUY=;
        b=k2SgDzAkBRRR3HatZ4doZMSMIaJ0KuowECARyq2tFQinEg12iIsXEJVV0ykDR4JVW0
         QiZeq+7tWlWIxLJ2qt+kcgx8le6orApGDkD5NmXnb22Gw+ob6f/7r5nIhgPJJU+mQ2Ri
         Xutt/K334V9mfLinLQLA71dlHtpXmFAYFl1KxHescBBOfLqZd/MG6rdTV9wL9xzeuWh2
         D/SUGMP6Rmbhl4zT5RpVxPE5bkJ6wpYvTbQbY0Mix7njbbr6dcCHqIAc/fB3p+yM/wMO
         BeoEB0OXzR677ukT25U23CAZjIUdgZ7uk13HpMfKUq3EgGh04Hp2TQCSMP/sAn2O6qXB
         Vn6w==
X-Gm-Message-State: APjAAAWmOf9bBp6ECMc3l2aeYqUsJmzOSP3llQsUIRqLtKioAZxr1nNz
        uZFb9DYTch5SZjqg1c8q2kA=
X-Google-Smtp-Source: APXvYqz36Vvf2V+yNqQuXaFJ0UdDwZ4wF2s310ybjKtkcVGN519kKNgYM+rhkS1IR0cF7EXQmGuK2w==
X-Received: by 2002:a1c:2546:: with SMTP id l67mr5100173wml.10.1567441563995;
        Mon, 02 Sep 2019 09:26:03 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 01/15] net: dsa: sja1105: Change the PTP command access pattern
Date:   Mon,  2 Sep 2019 19:25:30 +0300
Message-Id: <20190902162544.24613-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTP command register contains enable bits for:
- Putting the 64-bit PTPCLKVAL register in add/subtract or write mode
- Taking timestamps off of the corrected vs free-running clock
- Starting/stopping the TTEthernet scheduling
- Starting/stopping PPS output
- Resetting the switch

When a command needs to be issued (e.g. "change the PTPCLKVAL from write
mode to add/subtract mode"), one cannot simply write to the command
register setting the PTPCLKADD bit to 1, because that would zeroize the
other settings. One also cannot do a read-modify-write (that would be
too easy for this hardware) because not all bits of the command register
are readable over SPI.

So this leaves us with the only option of keeping the value of the PTP
command register in the driver, and operating on that.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since RFC:
- None.

 drivers/net/dsa/sja1105/sja1105.h     | 5 +++++
 drivers/net/dsa/sja1105/sja1105_ptp.c | 6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 78094db32622..d8a92646e80a 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -50,6 +50,10 @@ struct sja1105_regs {
 	u64 qlevel[SJA1105_NUM_PORTS];
 };
 
+struct sja1105_ptp_cmd {
+	u64 resptp;		/* reset */
+};
+
 struct sja1105_info {
 	u64 device_id;
 	/* Needed for distinction between P and R, and between Q and S
@@ -89,6 +93,7 @@ struct sja1105_private {
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
+	struct sja1105_ptp_cmd ptp_cmd;
 	struct ptp_clock_info ptp_caps;
 	struct ptp_clock *clock;
 	/* The cycle counter translates the PTP timestamps (based on
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index d8e8dd59f3d1..07374ba6b9be 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -54,10 +54,6 @@
 #define cc_to_sja1105(d) container_of((d), struct sja1105_private, tstamp_cc)
 #define dw_to_sja1105(d) container_of((d), struct sja1105_private, refresh_work)
 
-struct sja1105_ptp_cmd {
-	u64 resptp;       /* reset */
-};
-
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *info)
 {
@@ -218,8 +214,8 @@ int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
 
 int sja1105_ptp_reset(struct sja1105_private *priv)
 {
+	struct sja1105_ptp_cmd cmd = priv->ptp_cmd;
 	struct dsa_switch *ds = priv->ds;
-	struct sja1105_ptp_cmd cmd = {0};
 	int rc;
 
 	mutex_lock(&priv->ptp_lock);
-- 
2.17.1

