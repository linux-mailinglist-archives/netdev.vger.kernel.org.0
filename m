Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81C194BB4
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfHSR2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:28:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33836 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfHSR2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:28:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id s18so9574160wrn.1;
        Mon, 19 Aug 2019 10:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fJRlmlBru4RfFVqA4+d8k80FcuTjsj2jSzcYsHbb4+E=;
        b=QbDyngL9zFtAGjC3x/6yoI+ngXX8zIZ3g6f5LhhPKjeQdbJC75iUjIdPIUAbvw0mBv
         HL+0wx345agETAqUx2DeDyaquj38vWycdhR6saGG+aSa3BhSmtFrJRUj8wr2++u3V6Tk
         WRkF6pXeL8/lH71s42tKpCJmlaHaxmPankWNN6rtt/OsOpVmRlO/VjHWsCRVlP8ZPquS
         4BROHWZXLCgwCefYfVvPLjNM9/G+T7AFnyUIqfjEqL+HWCnSw2MGIVurgYLxSlNpy/R1
         Qulv+PE2MZgkkPexJdJ7fM1TRlvNGjVLhC1KggfQ+e+7iYsxG/YM7bzElSD7dDgEuR7g
         fPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fJRlmlBru4RfFVqA4+d8k80FcuTjsj2jSzcYsHbb4+E=;
        b=qzdGQpVMJXkio0c4+yABEnmerIkTIK1qHNVs+tVWOezIaWlLuGqElKPhRVYygy4WSj
         Bv15NeqENpjM60FSNpxXd81AfT8OBGsMOcmhW4NBf6aVBWhknl8wU9c+wamSYWUNeEBg
         2R2gqUxKMTCZGNHLyA5bmKxmgc2pO2oYqaW3HFzHtinb+x3CWv+I7loJn+3mLd+evPBm
         8/4EQAGw1k82c7ZE2qRTu82CkR2JGQ9rLYukM2ft7sG1NwjiZTp5yCugrOWYrJC32JmK
         adrlG0pFrplUE7mH+5CGXoxDM1hf1lULE43uFfUSVMCXOlBHKzpzQ/2vN7WuQfveX19T
         k3gA==
X-Gm-Message-State: APjAAAVTnso4F8BnMnaF2yJamq+IbwcFnYQAUa+ImXcQBRGSnx8uTnRs
        GIj8ooDnGn3oy17Ewq+wlrLWZK9VYTw=
X-Google-Smtp-Source: APXvYqyGcAbp2p9pu3cM4D4KXc1lUmVtuwAh5z92aZ4jI0xDyQT9LJUXyKjjhR+D+jEDg5+H1OExhQ==
X-Received: by 2002:adf:ea08:: with SMTP id q8mr5731752wrm.188.1566235720807;
        Mon, 19 Aug 2019 10:28:40 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c15sm41983879wrb.80.2019.08.19.10.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:28:40 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 2/4] net: mdio: add PTP offset compensation to mdiobus_write_sts
Date:   Mon, 19 Aug 2019 19:28:25 +0200
Message-Id: <20190819172827.9550-3-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190819172827.9550-1-hubert.feurstein@vahle.at>
References: <20190819172827.9550-1-hubert.feurstein@vahle.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

The slow MDIO access introduces quite a big offset (~13us) to the PTP
system time synchronisation. With this patch the driver has the possibility
to set the correct offset which can then be compensated.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 12 ++++++++++++
 include/linux/phy.h        |  8 ++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 4dba2714495e..50a37cf46f96 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -739,6 +739,18 @@ int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
 	if (!(bus->flags & MII_BUS_F_PTP_STS_SUPPORTED))
 		ptp_read_system_postts(sts);
 
+	/* PTP offset compensation:
+	 * After the MDIO access is completed (from the chip perspective), the
+	 * switch chip will snapshot the PHC timestamp. To make sure our system
+	 * timestamp corresponds to the PHC timestamp, we have to add the
+	 * duration of this MDIO access to sts->post_ts. Linuxptp's phc2sys
+	 * takes the average of pre_ts and post_ts to calculate the final
+	 * system timestamp. With this in mind, we have to add ptp_sts_offset
+	 * twice to post_ts, in order to not introduce an constant time offset.
+	 */
+	if (sts)
+		timespec64_add_ns(&sts->post_ts, 2 * bus->ptp_sts_offset);
+
 	return retval;
 }
 EXPORT_SYMBOL(__mdiobus_write_sts);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0b33662e0320..615df9c7f2c3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -283,8 +283,16 @@ struct mii_bus {
 	 * The ptp_read_system_*ts functions already check the ptp_sts pointer.
 	 * The MII_BUS_F_PTP_STS_SUPPORTED-bit must be set in flags, when the
 	 * MDIO bus driver takes the timestamps as described above.
+	 *
+	 * @ptp_sts_offset: This is the compensation offset for the system
+	 * timestamp which is introduced by the slow MDIO access duration. An
+	 * MDIO access consists of 32 clock cycles. Usually the MDIO bus runs
+	 * at ~2.5MHz, so we have to compensate ~12800ns offset.
+	 * Set the ptp_sts_offset to the exact duration of one MDIO frame
+	 * (= 32 * clock-period) in nano-seconds.
 	 */
 	struct ptp_system_timestamp *ptp_sts;
+	u32 ptp_sts_offset;
 };
 
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
-- 
2.22.1

