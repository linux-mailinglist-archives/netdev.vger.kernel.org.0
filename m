Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D044DEA0DA
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfJ3PzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:55:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36335 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfJ3Py7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:54:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id w18so2916448wrt.3
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 08:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FgmJFc69aJGBfN43Lu4UDpX3eu2jhzY+mRsGnXR2dN8=;
        b=YQ8JrjFkp6XLfBlPGUCLqHhaC6ro+clm5a1vsZRrj0w1wRsTIWAq0+OP/rWqhne4JZ
         rTzIjBLdfjYc+US6nnKjMu07xq0zXfLtC3COLWnr04KS/RUqUCWPmRdhPJ7K03Qub2LC
         wnVdo4PZcj2il8ZcWV8GQeSE4nT0O2MSgdAbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FgmJFc69aJGBfN43Lu4UDpX3eu2jhzY+mRsGnXR2dN8=;
        b=k8kBTDgaYaNjQdjet45HlEDCfwNt5PNxWBudCs/bWpZLSxMujESIyvlim+1YM9HJVZ
         WBYhE8nlmbPEQ6CQPZHaw3wc2MIbdSlrm7Q77IpKgWCbo/kAdeUusMXZv/32RCzAEIQ+
         GhfXjHAjp27GzHrDPIQgxGm+kT5PWUWb9hHF0w8LukXjOh9soyzHlZn2L1nJ4nqa8aVd
         ObRgZTgW4jItQf+z4vIwLrIdXz9YslhRpSrh9dDYHNNdRUatbTIufT0eSY9EFmAY7lDH
         wTmPZtK62nEZ5cl+POi+gEQRdvhjhW/Vk2oMtww0kUcDSeBVw7Ab/QtskpdFSGfW2oEs
         zKAA==
X-Gm-Message-State: APjAAAW2Mrhjl0ilB3W6wWmWdbxoW+9rEHdEXVO98Alh2A97e62D5jPg
        FlzrRhNlNqaCWs/IyxatfiJ3Iw==
X-Google-Smtp-Source: APXvYqw1WJjIbOmeus2GIdvdbFV9JrCvx3qonEXRRGFUrDLsS2mD90po6hHglU+cnBz+gj9F81bRmw==
X-Received: by 2002:adf:ed84:: with SMTP id c4mr482461wro.333.1572450896061;
        Wed, 30 Oct 2019 08:54:56 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g184sm499931wma.8.2019.10.30.08.54.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 30 Oct 2019 08:54:55 -0700 (PDT)
From:   Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Subject: [PATCH net-next V4 3/3] bnxt_en: Add support to collect crash dump via ethtool
Date:   Wed, 30 Oct 2019 21:24:24 +0530
Message-Id: <1572450864-16761-4-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572450864-16761-1-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1572450864-16761-1-git-send-email-sheetal.tigadoli@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Driver supports 2 types of core dumps.

1. Live dump - Firmware dump when system is up and running.
2. Crash dump - Dump which is collected during firmware crash
                that can be retrieved after recovery.
Crash dump is currently supported only on specific 58800 chips
which can be retrieved using OP-TEE API only, as firmware cannot
access this region directly.

User needs to set the dump flag using following command before
initiating the dump collection:

    $ ethtool -W|--set-dump eth0 N

Where N is "0" for live dump and "1" for crash dump

Command to collect the dump after setting the flag:

    $ ethtool -w eth0 data Filename

v3: Modify set_dump to support even when CONFIG_TEE_BNXT_FW=n.
Also change log message to netdev_info().

Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 37 ++++++++++++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 +
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 09437150f818..3e7d1fb1b0b1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1807,6 +1807,9 @@ struct bnxt {
 
 	u8			num_leds;
 	struct bnxt_led_info	leds[BNXT_MAX_LED];
+	u16			dump_flag;
+#define BNXT_DUMP_LIVE		0
+#define BNXT_DUMP_CRASH		1
 
 	struct bpf_prog		*xdp_prog;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 51c140476717..f2220b826d61 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3311,6 +3311,24 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 	return rc;
 }
 
+static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
+{
+	struct bnxt *bp = netdev_priv(dev);
+
+	if (dump->flag > BNXT_DUMP_CRASH) {
+		netdev_info(dev, "Supports only Live(0) and Crash(1) dumps.\n");
+		return -EINVAL;
+	}
+
+	if (!IS_ENABLED(CONFIG_TEE_BNXT_FW) && dump->flag == BNXT_DUMP_CRASH) {
+		netdev_info(dev, "Cannot collect crash dump as TEE_BNXT_FW config option is not enabled.\n");
+		return -EOPNOTSUPP;
+	}
+
+	bp->dump_flag = dump->flag;
+	return 0;
+}
+
 static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -3323,7 +3341,12 @@ static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
 			bp->ver_resp.hwrm_fw_bld_8b << 8 |
 			bp->ver_resp.hwrm_fw_rsvd_8b;
 
-	return bnxt_get_coredump(bp, NULL, &dump->len);
+	dump->flag = bp->dump_flag;
+	if (bp->dump_flag == BNXT_DUMP_CRASH)
+		dump->len = BNXT_CRASH_DUMP_LEN;
+	else
+		bnxt_get_coredump(bp, NULL, &dump->len);
+	return 0;
 }
 
 static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
@@ -3336,7 +3359,16 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 
 	memset(buf, 0, dump->len);
 
-	return bnxt_get_coredump(bp, buf, &dump->len);
+	dump->flag = bp->dump_flag;
+	if (dump->flag == BNXT_DUMP_CRASH) {
+#ifdef CONFIG_TEE_BNXT_FW
+		return tee_bnxt_copy_coredump(buf, 0, dump->len);
+#endif
+	} else {
+		return bnxt_get_coredump(bp, buf, &dump->len);
+	}
+
+	return 0;
 }
 
 void bnxt_ethtool_init(struct bnxt *bp)
@@ -3446,6 +3478,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.set_phys_id		= bnxt_set_phys_id,
 	.self_test		= bnxt_self_test,
 	.reset			= bnxt_reset,
+	.set_dump		= bnxt_set_dump,
 	.get_dump_flag		= bnxt_get_dump_flag,
 	.get_dump_data		= bnxt_get_dump_data,
 };
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index b5b65b3f8534..01de7e79d14f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -59,6 +59,8 @@ struct hwrm_dbg_cmn_output {
 	#define HWRM_DBG_CMN_FLAGS_MORE	1
 };
 
+#define BNXT_CRASH_DUMP_LEN	(8 << 20)
+
 #define BNXT_LED_DFLT_ENA				\
 	(PORT_LED_CFG_REQ_ENABLES_LED0_ID |		\
 	 PORT_LED_CFG_REQ_ENABLES_LED0_STATE |		\
-- 
2.17.1

