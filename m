Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB5738C7A0
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhEUNR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbhEUNRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:17:48 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D9DC0613ED
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:16:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lz27so30400079ejb.11
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YPXrkfGsdRF999/nD03SOdhcmJZJoMX+KTWz66+4rJ8=;
        b=BnKjIEt+sYeQSsWtuyv8lXhzoON6Bk0M0ZciY/N6THVw6UK+g4vZN86qGoNItw/QgN
         UM64R9F3jrWh39qPUeq/zjXnOIlGfmQbQLUDJ+s4ExlllzWmG3WaXlGxUlE+eA52cOX4
         72O5eOGxyv0cciQ3efZ6DIwgZvu0EFG1+NClhtiUcWSQ5ZpDPev0CGUlYRQxKhB5aaWS
         QHUsFo2zh83dZDk0kcBPdj7LaMa/0rS1ObtlIKSgJtJZ89EEuQOotXAh2XznKJojbOua
         ho0YCeTxhg7eAT1PNGXD9NS0ANe+8AXSeCoaDp8g3HckkT/+F2fgABV8Tq4pzQlSgHM5
         Uyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YPXrkfGsdRF999/nD03SOdhcmJZJoMX+KTWz66+4rJ8=;
        b=rlaJc0nPzonDLLQhx+QqZJhPJNB8Z7hfmBhGOPL8EiWs11w9+5Cim4imLrYoPYfPiE
         5wPx7e0xQgpctnyzzWeBxm8DTu/zaoPmNqHDoBKsNiwjVaj33XgLsrIxwfzOEasJOBv5
         Hq5G34V71GhS+AAX9QHyCYZ55lPJyoX3Dw0zgLFheMmAlOIbfsnSWhObQskFGbBkrrVQ
         18zkxbujTTsfd17x/njGigME+YRUm/r5VXnrNR4p7nMnWVpLBu+NK3YQ8Uln2JkJX/ag
         Es+s/uj+iH3RCWKXeAqYtQZbjVavRco8c4j/kwkB7cHI9yZ28FuiaSPAtzLaFiTSidRH
         NnoA==
X-Gm-Message-State: AOAM531NAEfzyQpck+kbG0ZReLUTJiCu0LBw7HGJse8E5SOHuBqAgpkX
        WuAZUjURhelgoflNNAbfKlg=
X-Google-Smtp-Source: ABdhPJzDKHF0El3xWFTRJcrzOat82T4IdvOMOvEUpS3Vu0fl4dKtB9h23ofloR4ttm3O9hnqo+sZhw==
X-Received: by 2002:a17:906:55c1:: with SMTP id z1mr10483007ejp.229.1621602982560;
        Fri, 21 May 2021 06:16:22 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id bm24sm3959310edb.45.2021.05.21.06.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 06:16:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net: dsa: sja1105: don't use burst SPI reads for port statistics
Date:   Fri, 21 May 2021 16:16:08 +0300
Message-Id: <20210521131608.4018058-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521131608.4018058-1-olteanv@gmail.com>
References: <20210521131608.4018058-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The current internal sja1105 driver API is optimized for retrieving many
statistics counters at once. But the switch does not do atomic snapshotting
for them anyway.

In case we start reporting the hardware port counters through
ndo_get_stats64 as well, not just ethtool, it would be good to be able
to read individual port counters and not all of them.

Additionally, since Arnd Bergmann's commit ae1804de93f6 ("dsa: sja1105:
dynamically allocate stats structure"), sja1105_get_ethtool_stats
allocates memory dynamically, since struct sja1105_port_status was
deemed to consume too much stack memory. That is not ideal.
The large structure is only needed because of the burst read.
If we read statistics one by one, we can consume less memory, and
we can avoid dynamic allocation.

Additionally, latency-sensitive interfaces such as PTP operations (for
phc2sys) might suffer if the SPI mutex is being held for too long, which
happens in the case of SPI burst reads. By reading counters one by one,
we give a chance for higher priority processes to preempt and take the
SPI bus mutex for accessing the PTP clock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h         |   13 +-
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 1039 ++++++++++++---------
 drivers/net/dsa/sja1105/sja1105_spi.c     |   14 +-
 3 files changed, 598 insertions(+), 468 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 6749dc21b589..10fc6b54f9f6 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -30,6 +30,14 @@ typedef enum {
 #include "sja1105_tas.h"
 #include "sja1105_ptp.h"
 
+enum sja1105_stats_area {
+	MAC,
+	HL1,
+	HL2,
+	ETHER,
+	__MAX_SJA1105_STATS_AREA,
+};
+
 /* Keeps the different addresses between E/T and P/Q/R/S */
 struct sja1105_regs {
 	u64 device_id;
@@ -61,10 +69,7 @@ struct sja1105_regs {
 	u64 rgmii_tx_clk[SJA1105_NUM_PORTS];
 	u64 rmii_ref_clk[SJA1105_NUM_PORTS];
 	u64 rmii_ext_tx_clk[SJA1105_NUM_PORTS];
-	u64 mac[SJA1105_NUM_PORTS];
-	u64 mac_hl1[SJA1105_NUM_PORTS];
-	u64 mac_hl2[SJA1105_NUM_PORTS];
-	u64 ether_stats[SJA1105_NUM_PORTS];
+	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_NUM_PORTS];
 };
 
 struct sja1105_info {
diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index 2d8e5399f698..decc6c931dc1 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -3,502 +3,627 @@
  */
 #include "sja1105.h"
 
-#define SJA1105_SIZE_MAC_AREA		(0x02 * 4)
-#define SJA1105_SIZE_HL1_AREA		(0x10 * 4)
-#define SJA1105_SIZE_HL2_AREA		(0x4 * 4)
-#define SJA1105_SIZE_ETHER_AREA		(0x17 * 4)
-
-struct sja1105_port_status_mac {
-	u64 n_runt;
-	u64 n_soferr;
-	u64 n_alignerr;
-	u64 n_miierr;
-	u64 typeerr;
-	u64 sizeerr;
-	u64 tctimeout;
-	u64 priorerr;
-	u64 nomaster;
-	u64 memov;
-	u64 memerr;
-	u64 invtyp;
-	u64 intcyov;
-	u64 domerr;
-	u64 pcfbagdrop;
-	u64 spcprior;
-	u64 ageprior;
-	u64 portdrop;
-	u64 lendrop;
-	u64 bagdrop;
-	u64 policeerr;
-	u64 drpnona664err;
-	u64 spcerr;
-	u64 agedrp;
-};
-
-struct sja1105_port_status_hl1 {
-	u64 n_n664err;
-	u64 n_vlanerr;
-	u64 n_unreleased;
-	u64 n_sizeerr;
-	u64 n_crcerr;
-	u64 n_vlnotfound;
-	u64 n_ctpolerr;
-	u64 n_polerr;
-	u64 n_rxfrmsh;
-	u64 n_rxfrm;
-	u64 n_rxbytesh;
-	u64 n_rxbyte;
-	u64 n_txfrmsh;
-	u64 n_txfrm;
-	u64 n_txbytesh;
-	u64 n_txbyte;
+enum sja1105_counter_index {
+	__SJA1105_COUNTER_UNUSED,
+	/* MAC */
+	N_RUNT,
+	N_SOFERR,
+	N_ALIGNERR,
+	N_MIIERR,
+	TYPEERR,
+	SIZEERR,
+	TCTIMEOUT,
+	PRIORERR,
+	NOMASTER,
+	MEMOV,
+	MEMERR,
+	INVTYP,
+	INTCYOV,
+	DOMERR,
+	PCFBAGDROP,
+	SPCPRIOR,
+	AGEPRIOR,
+	PORTDROP,
+	LENDROP,
+	BAGDROP,
+	POLICEERR,
+	DRPNONA664ERR,
+	SPCERR,
+	AGEDRP,
+	/* HL1 */
+	N_N664ERR,
+	N_VLANERR,
+	N_UNRELEASED,
+	N_SIZEERR,
+	N_CRCERR,
+	N_VLNOTFOUND,
+	N_CTPOLERR,
+	N_POLERR,
+	N_RXFRM,
+	N_RXBYTE,
+	N_TXFRM,
+	N_TXBYTE,
+	/* HL2 */
+	N_QFULL,
+	N_PART_DROP,
+	N_EGR_DISABLED,
+	N_NOT_REACH,
+	__MAX_SJA1105ET_PORT_COUNTER,
+	/* P/Q/R/S only */
+	/* ETHER */
+	N_DROPS_NOLEARN = __MAX_SJA1105ET_PORT_COUNTER,
+	N_DROPS_NOROUTE,
+	N_DROPS_ILL_DTAG,
+	N_DROPS_DTAG,
+	N_DROPS_SOTAG,
+	N_DROPS_SITAG,
+	N_DROPS_UTAG,
+	N_TX_BYTES_1024_2047,
+	N_TX_BYTES_512_1023,
+	N_TX_BYTES_256_511,
+	N_TX_BYTES_128_255,
+	N_TX_BYTES_65_127,
+	N_TX_BYTES_64,
+	N_TX_MCAST,
+	N_TX_BCAST,
+	N_RX_BYTES_1024_2047,
+	N_RX_BYTES_512_1023,
+	N_RX_BYTES_256_511,
+	N_RX_BYTES_128_255,
+	N_RX_BYTES_65_127,
+	N_RX_BYTES_64,
+	N_RX_MCAST,
+	N_RX_BCAST,
+	__MAX_SJA1105PQRS_PORT_COUNTER,
 };
 
-struct sja1105_port_status_hl2 {
-	u64 n_qfull;
-	u64 n_part_drop;
-	u64 n_egr_disabled;
-	u64 n_not_reach;
+struct sja1105_port_counter {
+	enum sja1105_stats_area area;
+	const char name[ETH_GSTRING_LEN];
+	int offset;
+	int start;
+	int end;
+	bool is_64bit;
 };
 
-struct sja1105_port_status_ether {
-	u64 n_drops_nolearn;
-	u64 n_drops_noroute;
-	u64 n_drops_ill_dtag;
-	u64 n_drops_dtag;
-	u64 n_drops_sotag;
-	u64 n_drops_sitag;
-	u64 n_drops_utag;
-	u64 n_tx_bytes_1024_2047;
-	u64 n_tx_bytes_512_1023;
-	u64 n_tx_bytes_256_511;
-	u64 n_tx_bytes_128_255;
-	u64 n_tx_bytes_65_127;
-	u64 n_tx_bytes_64;
-	u64 n_tx_mcast;
-	u64 n_tx_bcast;
-	u64 n_rx_bytes_1024_2047;
-	u64 n_rx_bytes_512_1023;
-	u64 n_rx_bytes_256_511;
-	u64 n_rx_bytes_128_255;
-	u64 n_rx_bytes_65_127;
-	u64 n_rx_bytes_64;
-	u64 n_rx_mcast;
-	u64 n_rx_bcast;
-};
-
-struct sja1105_port_status {
-	struct sja1105_port_status_mac mac;
-	struct sja1105_port_status_hl1 hl1;
-	struct sja1105_port_status_hl2 hl2;
-	struct sja1105_port_status_ether ether;
+static const struct sja1105_port_counter sja1105_port_counters[] = {
+	/* MAC-Level Diagnostic Counters */
+	[N_RUNT] = {
+		.area = MAC,
+		.name = "n_runt",
+		.offset = 0,
+		.start = 31,
+		.end = 24,
+	},
+	[N_SOFERR] = {
+		.area = MAC,
+		.name = "n_soferr",
+		.offset = 0x0,
+		.start = 23,
+		.end = 16,
+	},
+	[N_ALIGNERR] = {
+		.area = MAC,
+		.name = "n_alignerr",
+		.offset = 0x0,
+		.start = 15,
+		.end = 8,
+	},
+	[N_MIIERR] = {
+		.area = MAC,
+		.name = "n_miierr",
+		.offset = 0x0,
+		.start = 7,
+		.end = 0,
+	},
+	/* MAC-Level Diagnostic Flags */
+	[TYPEERR] = {
+		.area = MAC,
+		.name = "typeerr",
+		.offset = 0x1,
+		.start = 27,
+		.end = 27,
+	},
+	[SIZEERR] = {
+		.area = MAC,
+		.name = "sizeerr",
+		.offset = 0x1,
+		.start = 26,
+		.end = 26,
+	},
+	[TCTIMEOUT] = {
+		.area = MAC,
+		.name = "tctimeout",
+		.offset = 0x1,
+		.start = 25,
+		.end = 25,
+	},
+	[PRIORERR] = {
+		.area = MAC,
+		.name = "priorerr",
+		.offset = 0x1,
+		.start = 24,
+		.end = 24,
+	},
+	[NOMASTER] = {
+		.area = MAC,
+		.name = "nomaster",
+		.offset = 0x1,
+		.start = 23,
+		.end = 23,
+	},
+	[MEMOV] = {
+		.area = MAC,
+		.name = "memov",
+		.offset = 0x1,
+		.start = 22,
+		.end = 22,
+	},
+	[MEMERR] = {
+		.area = MAC,
+		.name = "memerr",
+		.offset = 0x1,
+		.start = 21,
+		.end = 21,
+	},
+	[INVTYP] = {
+		.area = MAC,
+		.name = "invtyp",
+		.offset = 0x1,
+		.start = 19,
+		.end = 19,
+	},
+	[INTCYOV] = {
+		.area = MAC,
+		.name = "intcyov",
+		.offset = 0x1,
+		.start = 18,
+		.end = 18,
+	},
+	[DOMERR] = {
+		.area = MAC,
+		.name = "domerr",
+		.offset = 0x1,
+		.start = 17,
+		.end = 17,
+	},
+	[PCFBAGDROP] = {
+		.area = MAC,
+		.name = "pcfbagdrop",
+		.offset = 0x1,
+		.start = 16,
+		.end = 16,
+	},
+	[SPCPRIOR] = {
+		.area = MAC,
+		.name = "spcprior",
+		.offset = 0x1,
+		.start = 15,
+		.end = 12,
+	},
+	[AGEPRIOR] = {
+		.area = MAC,
+		.name = "ageprior",
+		.offset = 0x1,
+		.start = 11,
+		.end = 8,
+	},
+	[PORTDROP] = {
+		.area = MAC,
+		.name = "portdrop",
+		.offset = 0x1,
+		.start = 6,
+		.end = 6,
+	},
+	[LENDROP] = {
+		.area = MAC,
+		.name = "lendrop",
+		.offset = 0x1,
+		.start = 5,
+		.end = 5,
+	},
+	[BAGDROP] = {
+		.area = MAC,
+		.name = "bagdrop",
+		.offset = 0x1,
+		.start = 4,
+		.end = 4,
+	},
+	[POLICEERR] = {
+		.area = MAC,
+		.name = "policeerr",
+		.offset = 0x1,
+		.start = 3,
+		.end = 3,
+	},
+	[DRPNONA664ERR] = {
+		.area = MAC,
+		.name = "drpnona664err",
+		.offset = 0x1,
+		.start = 2,
+		.end = 2,
+	},
+	[SPCERR] = {
+		.area = MAC,
+		.name = "spcerr",
+		.offset = 0x1,
+		.start = 1,
+		.end = 1,
+	},
+	[AGEDRP] = {
+		.area = MAC,
+		.name = "agedrp",
+		.offset = 0x1,
+		.start = 0,
+		.end = 0,
+	},
+	/* High-Level Diagnostic Counters */
+	[N_N664ERR] = {
+		.area = HL1,
+		.name = "n_n664err",
+		.offset = 0xF,
+		.start = 31,
+		.end = 0,
+	},
+	[N_VLANERR] = {
+		.area = HL1,
+		.name = "n_vlanerr",
+		.offset = 0xE,
+		.start = 31,
+		.end = 0,
+	},
+	[N_UNRELEASED] = {
+		.area = HL1,
+		.name = "n_unreleased",
+		.offset = 0xD,
+		.start = 31,
+		.end = 0,
+	},
+	[N_SIZEERR] = {
+		.area = HL1,
+		.name = "n_sizeerr",
+		.offset = 0xC,
+		.start = 31,
+		.end = 0,
+	},
+	[N_CRCERR] = {
+		.area = HL1,
+		.name = "n_crcerr",
+		.offset = 0xB,
+		.start = 31,
+		.end = 0,
+	},
+	[N_VLNOTFOUND] = {
+		.area = HL1,
+		.name = "n_vlnotfound",
+		.offset = 0xA,
+		.start = 31,
+		.end = 0,
+	},
+	[N_CTPOLERR] = {
+		.area = HL1,
+		.name = "n_ctpolerr",
+		.offset = 0x9,
+		.start = 31,
+		.end = 0,
+	},
+	[N_POLERR] = {
+		.area = HL1,
+		.name = "n_polerr",
+		.offset = 0x8,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RXFRM] = {
+		.area = HL1,
+		.name = "n_rxfrm",
+		.offset = 0x6,
+		.start = 31,
+		.end = 0,
+		.is_64bit = true,
+	},
+	[N_RXBYTE] = {
+		.area = HL1,
+		.name = "n_rxbyte",
+		.offset = 0x4,
+		.start = 31,
+		.end = 0,
+		.is_64bit = true,
+	},
+	[N_TXFRM] = {
+		.area = HL1,
+		.name = "n_txfrm",
+		.offset = 0x2,
+		.start = 31,
+		.end = 0,
+		.is_64bit = true,
+	},
+	[N_TXBYTE] = {
+		.area = HL1,
+		.name = "n_txbyte",
+		.offset = 0x0,
+		.start = 31,
+		.end = 0,
+		.is_64bit = true,
+	},
+	[N_QFULL] = {
+		.area = HL2,
+		.name = "n_qfull",
+		.offset = 0x3,
+		.start = 31,
+		.end = 0,
+	},
+	[N_PART_DROP] = {
+		.area = HL2,
+		.name = "n_part_drop",
+		.offset = 0x2,
+		.start = 31,
+		.end = 0,
+	},
+	[N_EGR_DISABLED] = {
+		.area = HL2,
+		.name = "n_egr_disabled",
+		.offset = 0x1,
+		.start = 31,
+		.end = 0,
+	},
+	[N_NOT_REACH] = {
+		.area = HL2,
+		.name = "n_not_reach",
+		.offset = 0x0,
+		.start = 31,
+		.end = 0,
+	},
+	/* Ether Stats */
+	[N_DROPS_NOLEARN] = {
+		.area = ETHER,
+		.name = "n_drops_nolearn",
+		.offset = 0x16,
+		.start = 31,
+		.end = 0,
+	},
+	[N_DROPS_NOROUTE] = {
+		.area = ETHER,
+		.name = "n_drops_noroute",
+		.offset = 0x15,
+		.start = 31,
+		.end = 0,
+	},
+	[N_DROPS_ILL_DTAG] = {
+		.area = ETHER,
+		.name = "n_drops_ill_dtag",
+		.offset = 0x14,
+		.start = 31,
+		.end = 0,
+	},
+	[N_DROPS_DTAG] = {
+		.area = ETHER,
+		.name = "n_drops_dtag",
+		.offset = 0x13,
+		.start = 31,
+		.end = 0,
+	},
+	[N_DROPS_SOTAG] = {
+		.area = ETHER,
+		.name = "n_drops_sotag",
+		.offset = 0x12,
+		.start = 31,
+		.end = 0,
+	},
+	[N_DROPS_SITAG] = {
+		.area = ETHER,
+		.name = "n_drops_sitag",
+		.offset = 0x11,
+		.start = 31,
+		.end = 0,
+	},
+	[N_DROPS_UTAG] = {
+		.area = ETHER,
+		.name = "n_drops_utag",
+		.offset = 0x10,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_BYTES_1024_2047] = {
+		.area = ETHER,
+		.name = "n_tx_bytes_1024_2047",
+		.offset = 0x0F,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_BYTES_512_1023] = {
+		.area = ETHER,
+		.name = "n_tx_bytes_512_1023",
+		.offset = 0x0E,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_BYTES_256_511] = {
+		.area = ETHER,
+		.name = "n_tx_bytes_256_511",
+		.offset = 0x0D,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_BYTES_128_255] = {
+		.area = ETHER,
+		.name = "n_tx_bytes_128_255",
+		.offset = 0x0C,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_BYTES_65_127] = {
+		.area = ETHER,
+		.name = "n_tx_bytes_65_127",
+		.offset = 0x0B,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_BYTES_64] = {
+		.area = ETHER,
+		.name = "n_tx_bytes_64",
+		.offset = 0x0A,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_MCAST] = {
+		.area = ETHER,
+		.name = "n_tx_mcast",
+		.offset = 0x09,
+		.start = 31,
+		.end = 0,
+	},
+	[N_TX_BCAST] = {
+		.area = ETHER,
+		.name = "n_tx_bcast",
+		.offset = 0x08,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_BYTES_1024_2047] = {
+		.area = ETHER,
+		.name = "n_rx_bytes_1024_2047",
+		.offset = 0x07,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_BYTES_512_1023] = {
+		.area = ETHER,
+		.name = "n_rx_bytes_512_1023",
+		.offset = 0x06,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_BYTES_256_511] = {
+		.area = ETHER,
+		.name = "n_rx_bytes_256_511",
+		.offset = 0x05,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_BYTES_128_255] = {
+		.area = ETHER,
+		.name = "n_rx_bytes_128_255",
+		.offset = 0x04,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_BYTES_65_127] = {
+		.area = ETHER,
+		.name = "n_rx_bytes_65_127",
+		.offset = 0x03,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_BYTES_64] = {
+		.area = ETHER,
+		.name = "n_rx_bytes_64",
+		.offset = 0x02,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_MCAST] = {
+		.area = ETHER,
+		.name = "n_rx_mcast",
+		.offset = 0x01,
+		.start = 31,
+		.end = 0,
+	},
+	[N_RX_BCAST] = {
+		.area = ETHER,
+		.name = "n_rx_bcast",
+		.offset = 0x00,
+		.start = 31,
+		.end = 0,
+	},
 };
 
-static void
-sja1105_port_status_mac_unpack(void *buf,
-			       struct sja1105_port_status_mac *status)
-{
-	/* Make pointer arithmetic work on 4 bytes */
-	u32 *p = buf;
-
-	sja1105_unpack(p + 0x0, &status->n_runt,       31, 24, 4);
-	sja1105_unpack(p + 0x0, &status->n_soferr,     23, 16, 4);
-	sja1105_unpack(p + 0x0, &status->n_alignerr,   15,  8, 4);
-	sja1105_unpack(p + 0x0, &status->n_miierr,      7,  0, 4);
-	sja1105_unpack(p + 0x1, &status->typeerr,      27, 27, 4);
-	sja1105_unpack(p + 0x1, &status->sizeerr,      26, 26, 4);
-	sja1105_unpack(p + 0x1, &status->tctimeout,    25, 25, 4);
-	sja1105_unpack(p + 0x1, &status->priorerr,     24, 24, 4);
-	sja1105_unpack(p + 0x1, &status->nomaster,     23, 23, 4);
-	sja1105_unpack(p + 0x1, &status->memov,        22, 22, 4);
-	sja1105_unpack(p + 0x1, &status->memerr,       21, 21, 4);
-	sja1105_unpack(p + 0x1, &status->invtyp,       19, 19, 4);
-	sja1105_unpack(p + 0x1, &status->intcyov,      18, 18, 4);
-	sja1105_unpack(p + 0x1, &status->domerr,       17, 17, 4);
-	sja1105_unpack(p + 0x1, &status->pcfbagdrop,   16, 16, 4);
-	sja1105_unpack(p + 0x1, &status->spcprior,     15, 12, 4);
-	sja1105_unpack(p + 0x1, &status->ageprior,     11,  8, 4);
-	sja1105_unpack(p + 0x1, &status->portdrop,      6,  6, 4);
-	sja1105_unpack(p + 0x1, &status->lendrop,       5,  5, 4);
-	sja1105_unpack(p + 0x1, &status->bagdrop,       4,  4, 4);
-	sja1105_unpack(p + 0x1, &status->policeerr,     3,  3, 4);
-	sja1105_unpack(p + 0x1, &status->drpnona664err, 2,  2, 4);
-	sja1105_unpack(p + 0x1, &status->spcerr,        1,  1, 4);
-	sja1105_unpack(p + 0x1, &status->agedrp,        0,  0, 4);
-}
-
-static void
-sja1105_port_status_hl1_unpack(void *buf,
-			       struct sja1105_port_status_hl1 *status)
-{
-	/* Make pointer arithmetic work on 4 bytes */
-	u32 *p = buf;
-
-	sja1105_unpack(p + 0xF, &status->n_n664err,    31,  0, 4);
-	sja1105_unpack(p + 0xE, &status->n_vlanerr,    31,  0, 4);
-	sja1105_unpack(p + 0xD, &status->n_unreleased, 31,  0, 4);
-	sja1105_unpack(p + 0xC, &status->n_sizeerr,    31,  0, 4);
-	sja1105_unpack(p + 0xB, &status->n_crcerr,     31,  0, 4);
-	sja1105_unpack(p + 0xA, &status->n_vlnotfound, 31,  0, 4);
-	sja1105_unpack(p + 0x9, &status->n_ctpolerr,   31,  0, 4);
-	sja1105_unpack(p + 0x8, &status->n_polerr,     31,  0, 4);
-	sja1105_unpack(p + 0x7, &status->n_rxfrmsh,    31,  0, 4);
-	sja1105_unpack(p + 0x6, &status->n_rxfrm,      31,  0, 4);
-	sja1105_unpack(p + 0x5, &status->n_rxbytesh,   31,  0, 4);
-	sja1105_unpack(p + 0x4, &status->n_rxbyte,     31,  0, 4);
-	sja1105_unpack(p + 0x3, &status->n_txfrmsh,    31,  0, 4);
-	sja1105_unpack(p + 0x2, &status->n_txfrm,      31,  0, 4);
-	sja1105_unpack(p + 0x1, &status->n_txbytesh,   31,  0, 4);
-	sja1105_unpack(p + 0x0, &status->n_txbyte,     31,  0, 4);
-	status->n_rxfrm  += status->n_rxfrmsh  << 32;
-	status->n_rxbyte += status->n_rxbytesh << 32;
-	status->n_txfrm  += status->n_txfrmsh  << 32;
-	status->n_txbyte += status->n_txbytesh << 32;
-}
-
-static void
-sja1105_port_status_hl2_unpack(void *buf,
-			       struct sja1105_port_status_hl2 *status)
-{
-	/* Make pointer arithmetic work on 4 bytes */
-	u32 *p = buf;
-
-	sja1105_unpack(p + 0x3, &status->n_qfull,        31,  0, 4);
-	sja1105_unpack(p + 0x2, &status->n_part_drop,    31,  0, 4);
-	sja1105_unpack(p + 0x1, &status->n_egr_disabled, 31,  0, 4);
-	sja1105_unpack(p + 0x0, &status->n_not_reach,    31,  0, 4);
-}
-
-static void
-sja1105pqrs_port_status_ether_unpack(void *buf,
-				     struct sja1105_port_status_ether *status)
-{
-	/* Make pointer arithmetic work on 4 bytes */
-	u32 *p = buf;
-
-	sja1105_unpack(p + 0x16, &status->n_drops_nolearn,      31, 0, 4);
-	sja1105_unpack(p + 0x15, &status->n_drops_noroute,      31, 0, 4);
-	sja1105_unpack(p + 0x14, &status->n_drops_ill_dtag,     31, 0, 4);
-	sja1105_unpack(p + 0x13, &status->n_drops_dtag,         31, 0, 4);
-	sja1105_unpack(p + 0x12, &status->n_drops_sotag,        31, 0, 4);
-	sja1105_unpack(p + 0x11, &status->n_drops_sitag,        31, 0, 4);
-	sja1105_unpack(p + 0x10, &status->n_drops_utag,         31, 0, 4);
-	sja1105_unpack(p + 0x0F, &status->n_tx_bytes_1024_2047, 31, 0, 4);
-	sja1105_unpack(p + 0x0E, &status->n_tx_bytes_512_1023,  31, 0, 4);
-	sja1105_unpack(p + 0x0D, &status->n_tx_bytes_256_511,   31, 0, 4);
-	sja1105_unpack(p + 0x0C, &status->n_tx_bytes_128_255,   31, 0, 4);
-	sja1105_unpack(p + 0x0B, &status->n_tx_bytes_65_127,    31, 0, 4);
-	sja1105_unpack(p + 0x0A, &status->n_tx_bytes_64,        31, 0, 4);
-	sja1105_unpack(p + 0x09, &status->n_tx_mcast,           31, 0, 4);
-	sja1105_unpack(p + 0x08, &status->n_tx_bcast,           31, 0, 4);
-	sja1105_unpack(p + 0x07, &status->n_rx_bytes_1024_2047, 31, 0, 4);
-	sja1105_unpack(p + 0x06, &status->n_rx_bytes_512_1023,  31, 0, 4);
-	sja1105_unpack(p + 0x05, &status->n_rx_bytes_256_511,   31, 0, 4);
-	sja1105_unpack(p + 0x04, &status->n_rx_bytes_128_255,   31, 0, 4);
-	sja1105_unpack(p + 0x03, &status->n_rx_bytes_65_127,    31, 0, 4);
-	sja1105_unpack(p + 0x02, &status->n_rx_bytes_64,        31, 0, 4);
-	sja1105_unpack(p + 0x01, &status->n_rx_mcast,           31, 0, 4);
-	sja1105_unpack(p + 0x00, &status->n_rx_bcast,           31, 0, 4);
-}
-
-static int
-sja1105pqrs_port_status_get_ether(struct sja1105_private *priv,
-				  struct sja1105_port_status_ether *ether,
-				  int port)
-{
-	const struct sja1105_regs *regs = priv->info->regs;
-	u8 packed_buf[SJA1105_SIZE_ETHER_AREA] = {0};
-	int rc;
-
-	/* Ethernet statistics area */
-	rc = sja1105_xfer_buf(priv, SPI_READ, regs->ether_stats[port],
-			      packed_buf, SJA1105_SIZE_ETHER_AREA);
-	if (rc < 0)
-		return rc;
-
-	sja1105pqrs_port_status_ether_unpack(packed_buf, ether);
-
-	return 0;
-}
-
-static int sja1105_port_status_get_mac(struct sja1105_private *priv,
-				       struct sja1105_port_status_mac *status,
-				       int port)
+static int sja1105_port_counter_read(struct sja1105_private *priv, int port,
+				     enum sja1105_counter_index idx, u64 *ctr)
 {
-	const struct sja1105_regs *regs = priv->info->regs;
-	u8 packed_buf[SJA1105_SIZE_MAC_AREA] = {0};
+	const struct sja1105_port_counter *c = &sja1105_port_counters[idx];
+	size_t size = c->is_64bit ? 8 : 4;
+	u8 buf[8] = {0};
+	u64 regs;
 	int rc;
 
-	/* MAC area */
-	rc = sja1105_xfer_buf(priv, SPI_READ, regs->mac[port], packed_buf,
-			      SJA1105_SIZE_MAC_AREA);
-	if (rc < 0)
-		return rc;
-
-	sja1105_port_status_mac_unpack(packed_buf, status);
-
-	return 0;
-}
-
-static int sja1105_port_status_get_hl1(struct sja1105_private *priv,
-				       struct sja1105_port_status_hl1 *status,
-				       int port)
-{
-	const struct sja1105_regs *regs = priv->info->regs;
-	u8 packed_buf[SJA1105_SIZE_HL1_AREA] = {0};
-	int rc;
-
-	rc = sja1105_xfer_buf(priv, SPI_READ, regs->mac_hl1[port], packed_buf,
-			      SJA1105_SIZE_HL1_AREA);
-	if (rc < 0)
-		return rc;
-
-	sja1105_port_status_hl1_unpack(packed_buf, status);
-
-	return 0;
-}
+	regs = priv->info->regs->stats[c->area][port];
 
-static int sja1105_port_status_get_hl2(struct sja1105_private *priv,
-				       struct sja1105_port_status_hl2 *status,
-				       int port)
-{
-	const struct sja1105_regs *regs = priv->info->regs;
-	u8 packed_buf[SJA1105_SIZE_HL2_AREA] = {0};
-	int rc;
-
-	rc = sja1105_xfer_buf(priv, SPI_READ, regs->mac_hl2[port], packed_buf,
-			      SJA1105_SIZE_HL2_AREA);
-	if (rc < 0)
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs + c->offset, buf, size);
+	if (rc)
 		return rc;
 
-	sja1105_port_status_hl2_unpack(packed_buf, status);
+	sja1105_unpack(buf, ctr, c->start, c->end, size);
 
 	return 0;
 }
 
-static int sja1105_port_status_get(struct sja1105_private *priv,
-				   struct sja1105_port_status *status,
-				   int port)
-{
-	int rc;
-
-	rc = sja1105_port_status_get_mac(priv, &status->mac, port);
-	if (rc < 0)
-		return rc;
-	rc = sja1105_port_status_get_hl1(priv, &status->hl1, port);
-	if (rc < 0)
-		return rc;
-	rc = sja1105_port_status_get_hl2(priv, &status->hl2, port);
-	if (rc < 0)
-		return rc;
-
-	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
-	    priv->info->device_id == SJA1105T_DEVICE_ID)
-		return 0;
-
-	return sja1105pqrs_port_status_get_ether(priv, &status->ether, port);
-}
-
-static char sja1105_port_stats[][ETH_GSTRING_LEN] = {
-	/* MAC-Level Diagnostic Counters */
-	"n_runt",
-	"n_soferr",
-	"n_alignerr",
-	"n_miierr",
-	/* MAC-Level Diagnostic Flags */
-	"typeerr",
-	"sizeerr",
-	"tctimeout",
-	"priorerr",
-	"nomaster",
-	"memov",
-	"memerr",
-	"invtyp",
-	"intcyov",
-	"domerr",
-	"pcfbagdrop",
-	"spcprior",
-	"ageprior",
-	"portdrop",
-	"lendrop",
-	"bagdrop",
-	"policeerr",
-	"drpnona664err",
-	"spcerr",
-	"agedrp",
-	/* High-Level Diagnostic Counters */
-	"n_n664err",
-	"n_vlanerr",
-	"n_unreleased",
-	"n_sizeerr",
-	"n_crcerr",
-	"n_vlnotfound",
-	"n_ctpolerr",
-	"n_polerr",
-	"n_rxfrm",
-	"n_rxbyte",
-	"n_txfrm",
-	"n_txbyte",
-	"n_qfull",
-	"n_part_drop",
-	"n_egr_disabled",
-	"n_not_reach",
-};
-
-static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
-	/* Ether Stats */
-	"n_drops_nolearn",
-	"n_drops_noroute",
-	"n_drops_ill_dtag",
-	"n_drops_dtag",
-	"n_drops_sotag",
-	"n_drops_sitag",
-	"n_drops_utag",
-	"n_tx_bytes_1024_2047",
-	"n_tx_bytes_512_1023",
-	"n_tx_bytes_256_511",
-	"n_tx_bytes_128_255",
-	"n_tx_bytes_65_127",
-	"n_tx_bytes_64",
-	"n_tx_mcast",
-	"n_tx_bcast",
-	"n_rx_bytes_1024_2047",
-	"n_rx_bytes_512_1023",
-	"n_rx_bytes_256_511",
-	"n_rx_bytes_128_255",
-	"n_rx_bytes_65_127",
-	"n_rx_bytes_64",
-	"n_rx_mcast",
-	"n_rx_bcast",
-};
-
 void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port_status *status;
+	enum sja1105_counter_index max_ctr, i;
 	int rc, k = 0;
 
-	status = kzalloc(sizeof(*status), GFP_KERNEL);
-	if (!status)
-		goto out;
-
-	rc = sja1105_port_status_get(priv, status, port);
-	if (rc < 0) {
-		dev_err(ds->dev, "Failed to read port %d counters: %d\n",
-			port, rc);
-		goto out;
-	}
-	memset(data, 0, ARRAY_SIZE(sja1105_port_stats) * sizeof(u64));
-	data[k++] = status->mac.n_runt;
-	data[k++] = status->mac.n_soferr;
-	data[k++] = status->mac.n_alignerr;
-	data[k++] = status->mac.n_miierr;
-	data[k++] = status->mac.typeerr;
-	data[k++] = status->mac.sizeerr;
-	data[k++] = status->mac.tctimeout;
-	data[k++] = status->mac.priorerr;
-	data[k++] = status->mac.nomaster;
-	data[k++] = status->mac.memov;
-	data[k++] = status->mac.memerr;
-	data[k++] = status->mac.invtyp;
-	data[k++] = status->mac.intcyov;
-	data[k++] = status->mac.domerr;
-	data[k++] = status->mac.pcfbagdrop;
-	data[k++] = status->mac.spcprior;
-	data[k++] = status->mac.ageprior;
-	data[k++] = status->mac.portdrop;
-	data[k++] = status->mac.lendrop;
-	data[k++] = status->mac.bagdrop;
-	data[k++] = status->mac.policeerr;
-	data[k++] = status->mac.drpnona664err;
-	data[k++] = status->mac.spcerr;
-	data[k++] = status->mac.agedrp;
-	data[k++] = status->hl1.n_n664err;
-	data[k++] = status->hl1.n_vlanerr;
-	data[k++] = status->hl1.n_unreleased;
-	data[k++] = status->hl1.n_sizeerr;
-	data[k++] = status->hl1.n_crcerr;
-	data[k++] = status->hl1.n_vlnotfound;
-	data[k++] = status->hl1.n_ctpolerr;
-	data[k++] = status->hl1.n_polerr;
-	data[k++] = status->hl1.n_rxfrm;
-	data[k++] = status->hl1.n_rxbyte;
-	data[k++] = status->hl1.n_txfrm;
-	data[k++] = status->hl1.n_txbyte;
-	data[k++] = status->hl2.n_qfull;
-	data[k++] = status->hl2.n_part_drop;
-	data[k++] = status->hl2.n_egr_disabled;
-	data[k++] = status->hl2.n_not_reach;
-
 	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
 	    priv->info->device_id == SJA1105T_DEVICE_ID)
-		goto out;
-
-	memset(data + k, 0, ARRAY_SIZE(sja1105pqrs_extra_port_stats) *
-			sizeof(u64));
-	data[k++] = status->ether.n_drops_nolearn;
-	data[k++] = status->ether.n_drops_noroute;
-	data[k++] = status->ether.n_drops_ill_dtag;
-	data[k++] = status->ether.n_drops_dtag;
-	data[k++] = status->ether.n_drops_sotag;
-	data[k++] = status->ether.n_drops_sitag;
-	data[k++] = status->ether.n_drops_utag;
-	data[k++] = status->ether.n_tx_bytes_1024_2047;
-	data[k++] = status->ether.n_tx_bytes_512_1023;
-	data[k++] = status->ether.n_tx_bytes_256_511;
-	data[k++] = status->ether.n_tx_bytes_128_255;
-	data[k++] = status->ether.n_tx_bytes_65_127;
-	data[k++] = status->ether.n_tx_bytes_64;
-	data[k++] = status->ether.n_tx_mcast;
-	data[k++] = status->ether.n_tx_bcast;
-	data[k++] = status->ether.n_rx_bytes_1024_2047;
-	data[k++] = status->ether.n_rx_bytes_512_1023;
-	data[k++] = status->ether.n_rx_bytes_256_511;
-	data[k++] = status->ether.n_rx_bytes_128_255;
-	data[k++] = status->ether.n_rx_bytes_65_127;
-	data[k++] = status->ether.n_rx_bytes_64;
-	data[k++] = status->ether.n_rx_mcast;
-	data[k++] = status->ether.n_rx_bcast;
-out:
-	kfree(status);
+		max_ctr = __MAX_SJA1105ET_PORT_COUNTER;
+	else
+		max_ctr = __MAX_SJA1105PQRS_PORT_COUNTER;
+
+	for (i = 0; i < max_ctr; i++) {
+		rc = sja1105_port_counter_read(priv, port, i, &data[k++]);
+		if (rc) {
+			dev_err(ds->dev,
+				"Failed to read port %d counters: %d\n",
+				port, rc);
+			break;
+		}
+	}
 }
 
 void sja1105_get_strings(struct dsa_switch *ds, int port,
 			 u32 stringset, u8 *data)
 {
 	struct sja1105_private *priv = ds->priv;
-	u8 *p = data;
-	int i;
+	enum sja1105_counter_index max_ctr, i;
+	char *p = data;
 
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_SIZE(sja1105_port_stats); i++) {
-			strlcpy(p, sja1105_port_stats[i], ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-		if (priv->info->device_id == SJA1105E_DEVICE_ID ||
-		    priv->info->device_id == SJA1105T_DEVICE_ID)
-			return;
-		for (i = 0; i < ARRAY_SIZE(sja1105pqrs_extra_port_stats); i++) {
-			strlcpy(p, sja1105pqrs_extra_port_stats[i],
-				ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-		break;
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+	    priv->info->device_id == SJA1105T_DEVICE_ID)
+		max_ctr = __MAX_SJA1105ET_PORT_COUNTER;
+	else
+		max_ctr = __MAX_SJA1105PQRS_PORT_COUNTER;
+
+	for (i = 0; i < max_ctr; i++) {
+		strscpy(p, sja1105_port_counters[i].name, ETH_GSTRING_LEN);
+		p += ETH_GSTRING_LEN;
 	}
 }
 
 int sja1105_get_sset_count(struct dsa_switch *ds, int port, int sset)
 {
-	int count = ARRAY_SIZE(sja1105_port_stats);
 	struct sja1105_private *priv = ds->priv;
+	enum sja1105_counter_index max_ctr, i;
+	int sset_count = 0;
 
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
 
-	if (priv->info->device_id == SJA1105PR_DEVICE_ID ||
-	    priv->info->device_id == SJA1105QS_DEVICE_ID)
-		count += ARRAY_SIZE(sja1105pqrs_extra_port_stats);
+	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+	    priv->info->device_id == SJA1105T_DEVICE_ID)
+		max_ctr = __MAX_SJA1105ET_PORT_COUNTER;
+	else
+		max_ctr = __MAX_SJA1105PQRS_PORT_COUNTER;
+
+	for (i = 0; i < max_ctr; i++) {
+		if (!strlen(sja1105_port_counters[i].name))
+			continue;
+
+		sset_count++;
+	}
 
-	return count;
+	return sset_count;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 52d53e737c68..df3a780e9dcc 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -416,9 +416,9 @@ static struct sja1105_regs sja1105et_regs = {
 	.pad_mii_rx = {0x100801, 0x100803, 0x100805, 0x100807, 0x100809},
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
-	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
-	.mac_hl1 = {0x400, 0x410, 0x420, 0x430, 0x440},
-	.mac_hl2 = {0x600, 0x610, 0x620, 0x630, 0x640},
+	.stats[MAC] = {0x200, 0x202, 0x204, 0x206, 0x208},
+	.stats[HL1] = {0x400, 0x410, 0x420, 0x430, 0x440},
+	.stats[HL2] = {0x600, 0x610, 0x620, 0x630, 0x640},
 	/* UM10944.pdf, Table 78, CGU Register overview */
 	.mii_tx_clk = {0x100013, 0x10001A, 0x100021, 0x100028, 0x10002F},
 	.mii_rx_clk = {0x100014, 0x10001B, 0x100022, 0x100029, 0x100030},
@@ -452,10 +452,10 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.sgmii = 0x1F0000,
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
-	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
-	.mac_hl1 = {0x400, 0x410, 0x420, 0x430, 0x440},
-	.mac_hl2 = {0x600, 0x610, 0x620, 0x630, 0x640},
-	.ether_stats = {0x1400, 0x1418, 0x1430, 0x1448, 0x1460},
+	.stats[MAC] = {0x200, 0x202, 0x204, 0x206, 0x208},
+	.stats[HL1] = {0x400, 0x410, 0x420, 0x430, 0x440},
+	.stats[HL2] = {0x600, 0x610, 0x620, 0x630, 0x640},
+	.stats[ETHER] = {0x1400, 0x1418, 0x1430, 0x1448, 0x1460},
 	/* UM11040.pdf, Table 114 */
 	.mii_tx_clk = {0x100013, 0x100019, 0x10001F, 0x100025, 0x10002B},
 	.mii_rx_clk = {0x100014, 0x10001A, 0x100020, 0x100026, 0x10002C},
-- 
2.25.1

