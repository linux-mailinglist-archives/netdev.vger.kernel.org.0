Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F841C57A4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgEEN7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:59:10 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:37555 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgEEN7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 09:59:09 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MDhpZ-1jOVz83s9v-00AkWg; Tue, 05 May 2020 15:58:54 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] [net-next] dsa: sja1105: dynamically allocate stats structure
Date:   Tue,  5 May 2020 15:58:26 +0200
Message-Id: <20200505135848.180753-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:VtJvDtSOHScQ9cJ4aBfIpXn6GuG4OnnuRks7px9SQloMrVCCckt
 2O4bEsr4cAwtyo2nvEX39bliFdlSS2nIs/cBexh3UpC03lLCX/kTyNhM4PfAzKB3JDpW6St
 nf5h0Ar8u5ntraY9MwMkpX1t34R2DzbGhGToNWT8TF62QDhKk5qhwBgcBAQU4QDufn2Bzmp
 Qd4Iy/IdsW6TRqPPETx1Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZGSBD1MSwg4=:Ef8u6FYRWR3cSKY+7pe/hk
 0OwZ0ysva7sPeFhvwFW1zuKjxuCvSnq5z5MJRRGReM7aiWUsnax7l/egMC+LpO2fAXN/0ibXq
 xc68HAS0j6aubEZQRDG99fG1X39PAkw9/+zljLTNhe3e/EO+Uffmbl/xKxC++dADXE39R1zwK
 pyYpzL/SIySuUvol3PctktikW59DCfXWO4/xdnrmhm4Cyty0EcIm6m+wmf4+V15czFOSrRdCZ
 xpY+JzW/bR0z8/dGR7atn6+YrWi9uGufsZPO8F6/ZEgg/ZieIiVIvWrqAhEzZUVNeNvLWav6d
 CYafB5DDofOAuPNbQ2pnRkAhuo7wna6Q7xZFRkg6uLYSaN86gQhmevWexSkyaqq8mroAJWQtI
 XwRKXhFxg4r6wFIAxqDCVZ6l2FMBF5Oz0uNdJMmwLz1EgW24R4zoJrkvrd+6UB9uh8MTSZ/6u
 ivWKvMDYZQzXEjCq4iLWq2+2cecRhnVGLZOsM90i/M/jbo/xSQr/ESS0nCPDg+TY+jiog5ynD
 1kgMNngopnrNdf6Mx0xQvbkFoeMYy8XZVRxd4OkNhbw5ibmhRyW49b7tVsU7oF00NJY/HpoSn
 C4EEfxlptlQ485k2qYJhCNTEylIRbP8oUTu3la0aEIrQSixzsEbTUsud+nhf6ax5eVa02b4ev
 OUu5/3hJ7SuAyYTijVrTLbolcQHDp0Tx53xt3u031Q5+2856MfzI2lKsPxuxkQuhhRp+iLUlT
 uJaMRVWjchWyIiywasnYRuKsAfTyXhTT+2d/+6EcFCnpmDjI47gCpRYTQQxXz9xQtX8RJwE3m
 PybUo/IXzNXzfERmQ29MvETVkKh8sJxVz6YrEO04zkdPWOnJ/8=
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
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 144 +++++++++++-----------
 include/linux/warnings.h                  |   4 +-
 2 files changed, 76 insertions(+), 72 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index d742ffcbfce9..1f8bd4f2c004 100644
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
+		goto out;;
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
diff --git a/include/linux/warnings.h b/include/linux/warnings.h
index c02563d62d5a..3d77f710df24 100644
--- a/include/linux/warnings.h
+++ b/include/linux/warnings.h
@@ -136,7 +136,7 @@ KBUILD_WARN(0, CLANG_8, "-Warc-repeated-use-of-weak")
 KBUILD_WARN(0, CLANG_8, "-Warc-maybe-repeated-use-of-weak")
 KBUILD_WARN(0, CLANG_8, "-Warray-bounds")
 KBUILD_WARN(0, CLANG_8, "-Wasm")
-//KBUILD_WARN(0, CLANG_8, "-Wasm-ignored-qualifier")
+KBUILD_WARN(0, CLANG_8, "-Wasm-ignored-qualifier")
 KBUILD_WARN(0, CLANG_8, "-Wasm-operand-widths")
 KBUILD_WARN(0, CLANG_8, "-Watimport-in-framework-header")
 KBUILD_WARN(0, CLANG_8, "-Wattributes")
@@ -169,7 +169,7 @@ KBUILD_WARN(0, CLANG_8, "-Wextra-tokens")
 KBUILD_WARN(0, CLANG_8, "-Wenum-compare")
 KBUILD_WARN(0, CLANG_8, "-Wenum-compare-switch")
 KBUILD_WARN(0, CLANG_8, "-Wenum-too-large")
-//KBUILD_WARN(0, CLANG_8, "-Wexperimental-isel")
+KBUILD_WARN(0, CLANG_8, "-Wexperimental-isel")
 KBUILD_WARN(0, CLANG_8, "-Wexplicit-initialize-call")
 KBUILD_WARN(0, CLANG_8, "-Wfallback")
 KBUILD_WARN(0, CLANG_8, "-Wflag-enum")
-- 
2.26.0

