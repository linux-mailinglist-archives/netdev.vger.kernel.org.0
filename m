Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9701C5BA2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgEEPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:38:55 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:39771 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbgEEPiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:38:55 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MdNse-1iweps3DMG-00ZMLU; Tue, 05 May 2020 17:38:40 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] [net-next, v2] dsa: sja1105: dynamically allocate stats structure
Date:   Tue,  5 May 2020 17:38:19 +0200
Message-Id: <20200505153834.1437767-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Bh13PbOFLRcVbfsxdpNxOCz10zCbKaRSrYe3NBwEcgKKrMQUnXM
 N/7bKe6eyT4HrM6m/PTZy/7zyd+TkuTxsSMZcPxXAzZRMkMEEQo2Ah/bZMPlbeaBNG1J3ax
 PJfsPb84pa8r05m8l4MZeiOSQzgdUoWyCOCyaRf3hXLu3hW3VaHUDn/X1zy3DNsbr2hScYZ
 4BJQJr/OHk3mEG/Q+sCow==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oCYYc5N0GXI=:+vWtTkunBfUxKZhYKXfcYJ
 nP70/QVR6iB36EwCq+h9db2bUhRp2D0ardfof1Y4h5ghv8wYsjfnGcStKL3ktgHAw3HBg+rlL
 CAQDToKiPNmwZUGs7S1sQTTWZ2+86LR/WjpJgIwXfbwuzghzAVPAJ97jH12Dm4/n//5bzeMmQ
 /PxxGyw2o3Y6Y3cvAg1p6qawfWn3ZFa8hoZ3lxu4Kwr3xLpUIzS3UWORCn1mnFwQe7GLBswIW
 lAfr6SswAliaQor9f+MWyrUJ17YTvCwjJsDoUZScHoqPPpAHyO97R6PgvZOPf56OD/IOSTU2k
 drlS91I0um+S6ai4Vz5YmhYQzO0vb1zsHnYe/JdXeocEE/7LroDGA/V5MKlY12ET6yrDjSj9u
 sX8DQ8+4Z7UjSOJ5wH9cAx1yqBCn5/Hf+TTJhdTeXeA0qHBBotrZD3fDAFx23qXq/g+xNpCEh
 rBfzUhVDRfryd0YIbnn1bxpIscGScUqiHqQjUFcHriJ/zfkusIwsX7AttmVgybFNLruL7bUUl
 fEZj3AtCOizhLGbNZFDGc4E+Dh4VguNDoRcaMbZzdsz4rcc7uFkEfVnsjpk2tDuzWMWA7hlUw
 4RlJvXEBE/OXulf3Ntp4E8UUgI/xb4FqKwQAj7dZzCm+9Mp4D0z5o+WtfywqRhnTGQmn6PVvT
 zwwmQmwR/fMrFexrD4ybL/hZGEPrYUN+vzVxwv6GJsLvvFKeNKzS9zjrzg1iVR1RTRVbvdm5I
 yEUEsug04AsgHRPLkaRvB1v7yPgQip19h5gr0gEQHw+ZDqh+dWd9AlZ8/ECtmXIbmV+VOukPF
 mfycg7NmcFiJIOIVxeRnXNt9qpi3uXd0oUyIFpGnMTk1nu7p5A=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The addition of sja1105_port_status_ether structure into the
statistics causes the frame size to go over the warning limit:

drivers/net/dsa/sja1105/sja1105_ethtool.c:421:6: error: stack frame size of 1104 bytes in function 'sja1105_get_ethtool_stats' [-Werror,-Wframe-larger-than=]

Use dynamic allocation to avoid this.

Fixes: 336aa67bd027 ("net: dsa: sja1105: show more ethtool statistics counters for P/Q/R/S")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: remove extra ';'
    remove bogus include/linux/warnings.h change
---
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 144 +++++++++++-----------
 1 file changed, 74 insertions(+), 70 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index d742ffcbfce9..709f035055c5 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -421,92 +421,96 @@ static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
 void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port_status status;
+	struct sja1105_port_status *status;
 	int rc, i, k = 0;
 
-	memset(&status, 0, sizeof(status));
+	status = kzalloc(sizeof(*status), GFP_KERNEL);
+	if (!status)
+		goto out;
 
-	rc = sja1105_port_status_get(priv, &status, port);
+	rc = sja1105_port_status_get(priv, status, port);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to read port %d counters: %d\n",
 			port, rc);
-		return;
+		goto out;
 	}
 	memset(data, 0, ARRAY_SIZE(sja1105_port_stats) * sizeof(u64));
-	data[k++] = status.mac.n_runt;
-	data[k++] = status.mac.n_soferr;
-	data[k++] = status.mac.n_alignerr;
-	data[k++] = status.mac.n_miierr;
-	data[k++] = status.mac.typeerr;
-	data[k++] = status.mac.sizeerr;
-	data[k++] = status.mac.tctimeout;
-	data[k++] = status.mac.priorerr;
-	data[k++] = status.mac.nomaster;
-	data[k++] = status.mac.memov;
-	data[k++] = status.mac.memerr;
-	data[k++] = status.mac.invtyp;
-	data[k++] = status.mac.intcyov;
-	data[k++] = status.mac.domerr;
-	data[k++] = status.mac.pcfbagdrop;
-	data[k++] = status.mac.spcprior;
-	data[k++] = status.mac.ageprior;
-	data[k++] = status.mac.portdrop;
-	data[k++] = status.mac.lendrop;
-	data[k++] = status.mac.bagdrop;
-	data[k++] = status.mac.policeerr;
-	data[k++] = status.mac.drpnona664err;
-	data[k++] = status.mac.spcerr;
-	data[k++] = status.mac.agedrp;
-	data[k++] = status.hl1.n_n664err;
-	data[k++] = status.hl1.n_vlanerr;
-	data[k++] = status.hl1.n_unreleased;
-	data[k++] = status.hl1.n_sizeerr;
-	data[k++] = status.hl1.n_crcerr;
-	data[k++] = status.hl1.n_vlnotfound;
-	data[k++] = status.hl1.n_ctpolerr;
-	data[k++] = status.hl1.n_polerr;
-	data[k++] = status.hl1.n_rxfrm;
-	data[k++] = status.hl1.n_rxbyte;
-	data[k++] = status.hl1.n_txfrm;
-	data[k++] = status.hl1.n_txbyte;
-	data[k++] = status.hl2.n_qfull;
-	data[k++] = status.hl2.n_part_drop;
-	data[k++] = status.hl2.n_egr_disabled;
-	data[k++] = status.hl2.n_not_reach;
+	data[k++] = status->mac.n_runt;
+	data[k++] = status->mac.n_soferr;
+	data[k++] = status->mac.n_alignerr;
+	data[k++] = status->mac.n_miierr;
+	data[k++] = status->mac.typeerr;
+	data[k++] = status->mac.sizeerr;
+	data[k++] = status->mac.tctimeout;
+	data[k++] = status->mac.priorerr;
+	data[k++] = status->mac.nomaster;
+	data[k++] = status->mac.memov;
+	data[k++] = status->mac.memerr;
+	data[k++] = status->mac.invtyp;
+	data[k++] = status->mac.intcyov;
+	data[k++] = status->mac.domerr;
+	data[k++] = status->mac.pcfbagdrop;
+	data[k++] = status->mac.spcprior;
+	data[k++] = status->mac.ageprior;
+	data[k++] = status->mac.portdrop;
+	data[k++] = status->mac.lendrop;
+	data[k++] = status->mac.bagdrop;
+	data[k++] = status->mac.policeerr;
+	data[k++] = status->mac.drpnona664err;
+	data[k++] = status->mac.spcerr;
+	data[k++] = status->mac.agedrp;
+	data[k++] = status->hl1.n_n664err;
+	data[k++] = status->hl1.n_vlanerr;
+	data[k++] = status->hl1.n_unreleased;
+	data[k++] = status->hl1.n_sizeerr;
+	data[k++] = status->hl1.n_crcerr;
+	data[k++] = status->hl1.n_vlnotfound;
+	data[k++] = status->hl1.n_ctpolerr;
+	data[k++] = status->hl1.n_polerr;
+	data[k++] = status->hl1.n_rxfrm;
+	data[k++] = status->hl1.n_rxbyte;
+	data[k++] = status->hl1.n_txfrm;
+	data[k++] = status->hl1.n_txbyte;
+	data[k++] = status->hl2.n_qfull;
+	data[k++] = status->hl2.n_part_drop;
+	data[k++] = status->hl2.n_egr_disabled;
+	data[k++] = status->hl2.n_not_reach;
 
 	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
 	    priv->info->device_id == SJA1105T_DEVICE_ID)
-		return;
+		goto out;;
 
 	memset(data + k, 0, ARRAY_SIZE(sja1105pqrs_extra_port_stats) *
 			sizeof(u64));
 	for (i = 0; i < 8; i++) {
-		data[k++] = status.hl2.qlevel_hwm[i];
-		data[k++] = status.hl2.qlevel[i];
+		data[k++] = status->hl2.qlevel_hwm[i];
+		data[k++] = status->hl2.qlevel[i];
 	}
-	data[k++] = status.ether.n_drops_nolearn;
-	data[k++] = status.ether.n_drops_noroute;
-	data[k++] = status.ether.n_drops_ill_dtag;
-	data[k++] = status.ether.n_drops_dtag;
-	data[k++] = status.ether.n_drops_sotag;
-	data[k++] = status.ether.n_drops_sitag;
-	data[k++] = status.ether.n_drops_utag;
-	data[k++] = status.ether.n_tx_bytes_1024_2047;
-	data[k++] = status.ether.n_tx_bytes_512_1023;
-	data[k++] = status.ether.n_tx_bytes_256_511;
-	data[k++] = status.ether.n_tx_bytes_128_255;
-	data[k++] = status.ether.n_tx_bytes_65_127;
-	data[k++] = status.ether.n_tx_bytes_64;
-	data[k++] = status.ether.n_tx_mcast;
-	data[k++] = status.ether.n_tx_bcast;
-	data[k++] = status.ether.n_rx_bytes_1024_2047;
-	data[k++] = status.ether.n_rx_bytes_512_1023;
-	data[k++] = status.ether.n_rx_bytes_256_511;
-	data[k++] = status.ether.n_rx_bytes_128_255;
-	data[k++] = status.ether.n_rx_bytes_65_127;
-	data[k++] = status.ether.n_rx_bytes_64;
-	data[k++] = status.ether.n_rx_mcast;
-	data[k++] = status.ether.n_rx_bcast;
+	data[k++] = status->ether.n_drops_nolearn;
+	data[k++] = status->ether.n_drops_noroute;
+	data[k++] = status->ether.n_drops_ill_dtag;
+	data[k++] = status->ether.n_drops_dtag;
+	data[k++] = status->ether.n_drops_sotag;
+	data[k++] = status->ether.n_drops_sitag;
+	data[k++] = status->ether.n_drops_utag;
+	data[k++] = status->ether.n_tx_bytes_1024_2047;
+	data[k++] = status->ether.n_tx_bytes_512_1023;
+	data[k++] = status->ether.n_tx_bytes_256_511;
+	data[k++] = status->ether.n_tx_bytes_128_255;
+	data[k++] = status->ether.n_tx_bytes_65_127;
+	data[k++] = status->ether.n_tx_bytes_64;
+	data[k++] = status->ether.n_tx_mcast;
+	data[k++] = status->ether.n_tx_bcast;
+	data[k++] = status->ether.n_rx_bytes_1024_2047;
+	data[k++] = status->ether.n_rx_bytes_512_1023;
+	data[k++] = status->ether.n_rx_bytes_256_511;
+	data[k++] = status->ether.n_rx_bytes_128_255;
+	data[k++] = status->ether.n_rx_bytes_65_127;
+	data[k++] = status->ether.n_rx_bytes_64;
+	data[k++] = status->ether.n_rx_mcast;
+	data[k++] = status->ether.n_rx_bcast;
+out:
+	kfree(status);
 }
 
 void sja1105_get_strings(struct dsa_switch *ds, int port,
-- 
2.26.0

