Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2DA2B99
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfH3Aqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:46:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53175 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfH3Aqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:46:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id t17so5496032wmi.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o7Uoqn7wDIBSyY2TE0cNLF6RFruoF5TerjP42Rz6Uf4=;
        b=Qd/4PsDPeUv+dZoCdFelmiLjsz4fZBtLpCF4Cx8mddPP8OJlO1+t+2mI6FpYSG9dvA
         VcQbaxpA7XLHmURfpXADD9ja5O5q8twqsKPgqD2iESZk2CVm3eWnPb1WJ9dTbRgUaQNb
         pLSZ6YEEB1iBp9H6hGD6XdbRY+lMeCUfeIDVXZBqbTMB4alF9DR4nt00XaGDCUGKm5f8
         j0TM2wcR8F3WChBifpm7CWV0BljZsxKbbKnGCtAAhKCjezX6qEQMVMD7vbXdL4BNV/Yt
         yeVipeYoSQuQ2GyvoluBcydDebpov2BKWNt5l39ysqep1cdxkEESQg/3VCIIanBuWWO6
         RswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o7Uoqn7wDIBSyY2TE0cNLF6RFruoF5TerjP42Rz6Uf4=;
        b=UsJf8g0XyADGgc54ltNeGorNsn3lW6U/NcMs5hz2RCBIiMj24IzBq+SOqrN5hsxDDs
         vQbhsB478kfMH1aUdDVAoBNt/ge6OBNpEfuFakmgVT6KxiDQ/uHuBpnuPf7AxHjBtD9F
         N3mFGhUpWu7s2eM2lp271QCHn6Ka8bkb8hzCd2i5tUxfADMwydlWfN8DfsU5O496AgqL
         TezRQNUrWlS9CjomCqlx52mSe6oCZpPTkTzBAboi1O5EFHKu6ICVEOVhYbhOliMBSD4s
         qBksF9sjbdUc7T57HJPFhhIuuv6WJDxDJwAM8uyo7NyQreiS6AcTeSw8u6z7/Gmkhcvu
         Lp1Q==
X-Gm-Message-State: APjAAAUG0crtIhTYHh00KPHBfaBjjiCFb1ILtXw7eRs5UlrNq96LgFGu
        rAP/wxlgkXqi+Z/yIOvvjkQUC5mqtY8=
X-Google-Smtp-Source: APXvYqysdOparD2kENGOGXSA8kdq19pIrnIq4kh0f0O+IMv9vcs9MsVNTERnjLCgVZtiCpjI8bAW2Q==
X-Received: by 2002:a1c:eb06:: with SMTP id j6mr15356522wmh.76.1567126009275;
        Thu, 29 Aug 2019 17:46:49 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 01/15] net: dsa: sja1105: Change the PTP command access pattern
Date:   Fri, 30 Aug 2019 03:46:21 +0300
Message-Id: <20190830004635.24863-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
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

