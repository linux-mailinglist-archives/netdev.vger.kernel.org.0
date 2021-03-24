Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9936347CEE
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbhCXPpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 11:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236575AbhCXPpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 11:45:07 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20934C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:45:07 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w3so33667690ejc.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLF9/T9mkPW+SfBx7lQUOj7k/f+2p+3Z4GNj0XsfqnA=;
        b=mDK/GcE4HPWi9hSPv/MiCgP4+pQG+9H7FKcZYYIZ6KGH81Or6u65QgTbFieSzE//RS
         VO2nm6HdUIYqr7DFc4bgul7mnMKUFWgu8i7Ur+LRLLlOyoh3nV4JonzV5ZYfyMdA47NS
         cTdgQ+uiQxAwd7EsAkKYP7s87BBoEvCohUmUUUMv/1V+fiejf4nm9cnWiu5o6Cy1V1Oo
         wUQd8pnsP5pRRdmrm4zg6ShCAihsVbnErSiGdnFm+5GwSJxRqep4f81sFvnl3hMCSa13
         oRJIIpCbKO1y9nx3x81tTwvPqFsnCFEH2TXOLJb7GyKOw4+0sVGOgQBrQl4ApGMiLXUA
         zQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLF9/T9mkPW+SfBx7lQUOj7k/f+2p+3Z4GNj0XsfqnA=;
        b=tsLDxyo71WDF92PoqXS50iJoRNwFLVV8V5lqTEMg9rHOZ/xDVSPvzN6+H5BHryJ5b0
         ETFPNHbpnwx+DvJfrhpZIpSRLON3kjXNGDXvt1yibgaSocHtGN5lzZNeVfax3ibnVYzm
         0ueE5AXnX3nnH6QE1X3pRWtGsyIWt85itltzgrGPy+KcxaRgL6sEK8v0oA09pkmv3J2o
         yRdqMIkLP3EQds7pNfwyqq1WCP5FG2EZrJZRjOZYVs+79BZHkoL3DFS/D0lyYkg+fc3A
         iBen1QiJVHNtfrBV+03gIvc/NVkPp24LGP3lKD1YIsTxIhu7gIZKTzy3CZWGPlrqEMEq
         lTNg==
X-Gm-Message-State: AOAM531U46m3z19b/CJ4Ho0dRLMlYF3aNJnh4OhQtBmKyaFdMiApIzb2
        AJiiXrmEL7LVTZ0ER1qgfo+H07Mr3c8=
X-Google-Smtp-Source: ABdhPJyTnT69b+6HKHTfWqRQ5BUGTr05lO7QiFcgLUyzsP3bR1aOlvsJd94wieZ9NMnd3Q8AojpC+w==
X-Received: by 2002:a17:906:489b:: with SMTP id v27mr4363722ejq.1.1616600705815;
        Wed, 24 Mar 2021 08:45:05 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w24sm1317542edt.44.2021.03.24.08.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 08:45:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net: enetc: don't depend on system endianness in enetc_set_vlan_ht_filter
Date:   Wed, 24 Mar 2021 17:44:54 +0200
Message-Id: <20210324154455.1899941-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ENETC has a 64-entry hash table for VLAN RX filtering per Station
Interface, which is accessed through two 32-bit registers: VHFR0 holding
the low portion, and VHFR1 holding the high portion.

The enetc_set_vlan_ht_filter function looks at the pf->vlan_ht_filter
bitmap, which is fundamentally an unsigned long variable, and casts it
to a u32 array of two elements. It puts the first u32 element into VHFR0
and the second u32 element into VHFR1.

It is easy to imagine that this will not work on big endian systems
(although, yes, we have bigger problems, because currently enetc assumes
that the CPU endianness is equal to the controller endianness, aka
little endian - but let's assume that we could add a cpu_to_le32 in
enetc_wd_reg and a le32_to_cpu in enetc_rd_reg).

Let's use lower_32_bits and upper_32_bits which are designed to work
regardless of endianness.

Tested that both the old and the new method produce the same results:

$ ethtool -K eth1 rx-vlan-filter on
$ ip link add link eth1 name eth1.100 type vlan id 100
enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x0 VHFR1 0x20
enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x0 VHFR1 0x20
$ ip link add link eth1 name eth1.101 type vlan id 101
enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x0 VHFR1 0x30
enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x0 VHFR1 0x30
$ ip link add link eth1 name eth1.34 type vlan id 34
enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x0 VHFR1 0x34
enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x0 VHFR1 0x34
$ ip link add link eth1 name eth1.1024 type vlan id 1024
enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x1 VHFR1 0x34
enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x1 VHFR1 0x34

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 3a7a9102eccb..9c69ca516192 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -248,10 +248,10 @@ static void enetc_pf_set_rx_mode(struct net_device *ndev)
 }
 
 static void enetc_set_vlan_ht_filter(struct enetc_hw *hw, int si_idx,
-				     u32 *hash)
+				     unsigned long hash)
 {
-	enetc_port_wr(hw, ENETC_PSIVHFR0(si_idx), *hash);
-	enetc_port_wr(hw, ENETC_PSIVHFR1(si_idx), *(hash + 1));
+	enetc_port_wr(hw, ENETC_PSIVHFR0(si_idx), lower_32_bits(hash));
+	enetc_port_wr(hw, ENETC_PSIVHFR1(si_idx), upper_32_bits(hash));
 }
 
 static int enetc_vid_hash_idx(unsigned int vid)
@@ -279,7 +279,7 @@ static void enetc_sync_vlan_ht_filter(struct enetc_pf *pf, bool rehash)
 		}
 	}
 
-	enetc_set_vlan_ht_filter(&pf->si->hw, 0, (u32 *)pf->vlan_ht_filter);
+	enetc_set_vlan_ht_filter(&pf->si->hw, 0, *pf->vlan_ht_filter);
 }
 
 static int enetc_vlan_rx_add_vid(struct net_device *ndev, __be16 prot, u16 vid)
-- 
2.25.1

