Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5594C69EE
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiB1LOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiB1LNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:13:05 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71367710F3;
        Mon, 28 Feb 2022 03:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646046605; x=1677582605;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pPM+/dJeHfzqF2MwScC0enTLh1mKtTcaV6SSL4S9rYU=;
  b=SO6gfJgmLRTjC80MWQvROvwlmmqq015dS5cjNekgYmZJmvFNSutkr9E3
   WGjs9xhTdJj6OqvbiownYD1PB5fdconUUePm2JpuFJS1aSSUqUc7ylQtK
   GUV1RsCwSubrDp0FzUJbXXj+ykLkpWxWGLF3BnUmGe4QJD6gxPLA5jvbQ
   Uc2ijL/as8b93GuwKW380ARlvtaqK72keAJ9YYdO4u0jVtJK4fMBJGzHG
   QNCPh1jwH1fnmKLv5x8FzqAm9+bhnZst/1TOUwadi2b7NgaQ5lQKBbxND
   ZTNZu4e8VYhyZ61Se+Qt7o/NHlmlHWTRarz4UP/Im5iHWhNGCImKgh2G/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="252588367"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="252588367"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 03:09:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="640854617"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 28 Feb 2022 03:09:40 -0800
Received: from P12HL01TMIN.png.intel.com (P12HL01TMIN.png.intel.com [10.158.65.75])
        by linux.intel.com (Postfix) with ESMTP id 6D3E85805A3;
        Mon, 28 Feb 2022 03:09:37 -0800 (PST)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pei.lee.ling@intel.com
Subject: [PATCH net 1/1] net: stmmac: Resolve poor line rate after switching from TSO off to TSO on
Date:   Mon, 28 Feb 2022 19:15:58 +0800
Message-Id: <20220228111558.3825974-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ling Pei Lee <pei.lee.ling@intel.com>

Sequential execution of these steps:
i) TSO ON – iperf3 execution,
ii) TSO OFF – iperf3 execution,
iii) TSO ON – iperf3 execution, it leads to iperf3 0 bytes transfer.

Example of mentioned Issue happened:
root@TGLA:~# iperf3 -c 169.254.168.191
Connecting to host 169.254.168.191, port 5201
[  5] local 169.254.50.108 port 45846 connected to 169.254.168.191
port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   113 MBytes   947 Mbits/sec    0    378 KBytes
[  5]   1.00-2.00   sec   111 MBytes   933 Mbits/sec    0    378 KBytes
[  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec    0    378 KBytes
[  5]   3.00-4.00   sec   111 MBytes   929 Mbits/sec    0    378 KBytes
[  5]   4.00-5.00   sec   111 MBytes   934 Mbits/sec    0    378 KBytes
[  5]   5.00-6.00   sec   111 MBytes   932 Mbits/sec    0    378 KBytes
[  5]   6.00-7.00   sec   111 MBytes   932 Mbits/sec    0    378 KBytes
[  5]   7.00-8.00   sec   111 MBytes   932 Mbits/sec    0    378 KBytes
[  5]   8.00-9.00   sec   111 MBytes   931 Mbits/sec    0    378 KBytes
[  5]   9.00-10.00  sec   111 MBytes   932 Mbits/sec    0    378 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   933 Mbits/sec    0    sender
[  5]   0.00-10.00  sec  1.09 GBytes   932 Mbits/sec         receiver

iperf Done.
root@TGLA:~# ethtool -K enp0s30f4 tso off
root@TGLA:~# iperf3 -c 169.254.168.191
Connecting to host 169.254.168.191, port 5201
[  5] local 169.254.50.108 port 45854 connected to 169.254.168.191
port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   104 MBytes   870 Mbits/sec    0    352 KBytes
[  5]   1.00-2.00   sec   101 MBytes   850 Mbits/sec    0    369 KBytes
[  5]   2.00-3.00   sec   102 MBytes   860 Mbits/sec    0    369 KBytes
[  5]   3.00-4.00   sec   102 MBytes   853 Mbits/sec    0    369 KBytes
[  5]   4.00-5.00   sec   102 MBytes   855 Mbits/sec    0    369 KBytes
[  5]   5.00-6.00   sec   101 MBytes   849 Mbits/sec    0    369 KBytes
[  5]   6.00-7.00   sec   102 MBytes   860 Mbits/sec    0    369 KBytes
[  5]   7.00-8.00   sec   102 MBytes   853 Mbits/sec    0    369 KBytes
[  5]   8.00-9.00   sec   101 MBytes   851 Mbits/sec    0    369 KBytes
[  5]   9.00-10.00  sec   102 MBytes   856 Mbits/sec    0    369 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1020 MBytes   856 Mbits/sec    0    sender
[  5]   0.00-10.00  sec  1019 MBytes   854 Mbits/sec         receiver

iperf Done.
root@TGLA:~# ethtool -K enp0s30f4 tso on
root@TGLA:~# iperf3 -c 169.254.168.191
Connecting to host 169.254.168.191, port 5201
[  5] local 169.254.50.108 port 45860 connected to 169.254.168.191
port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   107 KBytes   879 Kbits/sec    0   1.41 KBytes
[  5]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
[  5]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
[  5]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
[  5]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
[  5]   5.00-6.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
[  5]   6.00-7.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
[  5]   7.00-8.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes

Clear mss in TDES and call stmmac_enable_tso() to indicate
a new TSO transmission when it is enabled from TSO off using
ethtool command

Fixes: f748be531d70 ("stmmac: support new GMAC4")
Signed-off-by: Ling Pei Lee <pei.lee.ling@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b745d624b2cb..9e2ea0e0bd68 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5460,6 +5460,8 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 					     netdev_features_t features)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	u32 tx_cnt = priv->plat->tx_queues_to_use;
+	u32 chan;
 
 	if (priv->plat->rx_coe == STMMAC_RX_COE_NONE)
 		features &= ~NETIF_F_RXCSUM;
@@ -5483,6 +5485,16 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 			priv->tso = false;
 	}
 
+	for (chan = 0; chan < tx_cnt; chan++) {
+		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+
+		/* TSO and TBS cannot co-exist */
+		if (tx_q->tbs & STMMAC_TBS_AVAIL)
+			continue;
+
+		tx_q->mss = 0;
+		stmmac_enable_tso(priv, priv->ioaddr, priv->tso, chan);
+	}
 	return features;
 }
 
-- 
2.25.1

