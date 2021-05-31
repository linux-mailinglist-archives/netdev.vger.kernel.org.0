Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD57396712
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhEaRbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhEaRay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:30:54 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26738C04C49A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 09:17:16 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b17so14129569ede.0
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stnM2/sJcAsXBAJyDqFS24d9EhqJV2yT9cn8XxVQ/zk=;
        b=dbGoJVl91VnmZmbq1cPEc4iyJa1QJzM8MVM14V5uIU1Wfl8ojN44Hz6zOoRzKzLUER
         woTXRvGA36iEEdSKnyPWIuBMBhXbVsejFBFy4yl41voFybg61mKsAM0IOdtgKDwHe7KK
         Idtvyj3DD7clm+x0SMTjSQbAz4Iw3ZHsAdxb3oZtDiePh2wyhI+WKMYTRTJ372/TgE63
         7RHnCRch7xH/ulQtdU6cqaJa2WxFI5GJ+e1IZ7mvAlkMSKOgr6T+JpkdWBmAtruljK2j
         ovqVEPYzxNOjD/9sekjqPX20Lmi1UNuJv8aY9tuN0/szQldP4a3l03cUTR/qaXWgS9v4
         vQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stnM2/sJcAsXBAJyDqFS24d9EhqJV2yT9cn8XxVQ/zk=;
        b=CjnhoWzAxNnUAyhfM1vdmZ4tb6fanI/IMtu4FJWZ64RqZwGQtzHnKKT2LUGtwjn8tj
         7FEMToU5fWn67S+lYLsXGUYlsd148WvJUGeAkEUTa7e4mB5f4f3uVGiejzfAd36DZ/Xc
         8Zxp2HQbI9onLg+EyUmN4j7XHIPR4FFZABpOV4Bs7wUYflTrGPe/V6cwI+TW2Tq6ikpm
         E4y+4U2s0R2/WVazNy0YJcm9cHJlJmwrGeNaEcJTrCSEUbYCS0WaQ3IC185S/IpDHHp3
         6OmQ8lNykGPAOCGMc1IDXbHZo9CXZ8h6Rvkv8YNM/gTansTwgcDmDvUSJa0nE9UuWRBB
         q+bQ==
X-Gm-Message-State: AOAM530wBIxWHVCcqA8vzPgPHOFgdgjmmOC19bt4N3wwadv0kRaXFwlc
        btlr5iOOvwcj8C7T4dH6QlY=
X-Google-Smtp-Source: ABdhPJznEDsOMcJBg04D3w/2j7JOPvYMXqkBsCwQovtApnioL1lzLsPBm3APOvIMVrnEQL+2nZ2DXw==
X-Received: by 2002:a05:6402:b89:: with SMTP id cf9mr7760321edb.198.1622477834734;
        Mon, 31 May 2021 09:17:14 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id f8sm1566483ejw.75.2021.05.31.09.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 09:17:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: enetc: catch negative return code from enetc_pf_to_port()
Date:   Mon, 31 May 2021 19:17:07 +0300
Message-Id: <20210531161707.1142218-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After the refactoring introduced in commit 87614b931c24 ("net: enetc:
create a common enetc_pf_to_port helper"), enetc_pf_to_port was coded up
to return -1 in case the passed PCIe device does not have a recognized
BDF.

Make sure the -1 value is checked by the callers, to appease static
checkers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index af699f2ad095..4577226d3c6a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -465,8 +465,13 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	struct streamid_conf *si_conf;
 	u16 data_size;
 	dma_addr_t dma;
+	int port;
 	int err;
 
+	port = enetc_pf_to_port(priv->si->pdev);
+	if (port < 0)
+		return -EINVAL;
+
 	if (sid->index >= priv->psfp_cap.max_streamid)
 		return -EINVAL;
 
@@ -499,7 +504,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	si_conf = &cbd.sid_set;
 	/* Only one port supported for one entry, set itself */
-	si_conf->iports = cpu_to_le32(1 << enetc_pf_to_port(priv->si->pdev));
+	si_conf->iports = cpu_to_le32(1 << port);
 	si_conf->id_type = 1;
 	si_conf->oui[2] = 0x0;
 	si_conf->oui[1] = 0x80;
@@ -524,7 +529,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	si_conf->en = 0x80;
 	si_conf->stream_handle = cpu_to_le32(sid->handle);
-	si_conf->iports = cpu_to_le32(1 << enetc_pf_to_port(priv->si->pdev));
+	si_conf->iports = cpu_to_le32(1 << port);
 	si_conf->id_type = sid->filtertype;
 	si_conf->oui[2] = 0x0;
 	si_conf->oui[1] = 0x80;
@@ -567,6 +572,11 @@ static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
 {
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct sfi_conf *sfi_config;
+	int port;
+
+	port = enetc_pf_to_port(priv->si->pdev);
+	if (port < 0)
+		return -EINVAL;
 
 	cbd.index = cpu_to_le16(sfi->index);
 	cbd.cls = BDCR_CMD_STREAM_FILTER;
@@ -586,8 +596,7 @@ static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
 	}
 
 	sfi_config->sg_inst_table_index = cpu_to_le16(sfi->gate_id);
-	sfi_config->input_ports =
-		cpu_to_le32(1 << enetc_pf_to_port(priv->si->pdev));
+	sfi_config->input_ports = cpu_to_le32(1 << port);
 
 	/* The priority value which may be matched against the
 	 * frame’s priority value to determine a match for this entry.
@@ -1548,7 +1557,7 @@ int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct flow_block_offload *f = type_data;
-	int err;
+	int port, err;
 
 	err = flow_block_cb_setup_simple(f, &enetc_block_cb_list,
 					 enetc_setup_tc_block_cb,
@@ -1558,10 +1567,18 @@ int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		set_bit(enetc_pf_to_port(priv->si->pdev), &epsfp.dev_bitmap);
+		port = enetc_pf_to_port(priv->si->pdev);
+		if (port < 0)
+			return -EINVAL;
+
+		set_bit(port, &epsfp.dev_bitmap);
 		break;
 	case FLOW_BLOCK_UNBIND:
-		clear_bit(enetc_pf_to_port(priv->si->pdev), &epsfp.dev_bitmap);
+		port = enetc_pf_to_port(priv->si->pdev);
+		if (port < 0)
+			return -EINVAL;
+
+		clear_bit(port, &epsfp.dev_bitmap);
 		if (!epsfp.dev_bitmap)
 			clean_psfp_all();
 		break;
-- 
2.25.1

