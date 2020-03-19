Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB68918B867
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgCSNy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:54:57 -0400
Received: from mx.0dd.nl ([5.2.79.48]:43316 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbgCSNy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 09:54:57 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2020 09:54:56 EDT
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 0BB065FAE6;
        Thu, 19 Mar 2020 14:48:14 +0100 (CET)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="noV2Bi8S";
        dkim-atps=neutral
Received: from pc-rene-vdorst-com.vdorst.com (pc-rene-vdorst-com.vdorst.com [192.168.2.14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id B65A424FCBC;
        Thu, 19 Mar 2020 14:48:13 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com B65A424FCBC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1584625693;
        bh=O6YczJK1x6AOo1kB2bIezDwDRopcG6VypEaDqIBfUMM=;
        h=From:To:Cc:Subject:Date:From;
        b=noV2Bi8S9TcIClj7xR6/P0K1PQmfRwkoO4jN2XGaSGv4LIWM/62TmvBatR57czl/6
         sy/4wFrEg2MF6bJoLFxGrmJ+E/J5ZxetESI6iy5pfW786/vqUFvhZ0/omebB2oRYuG
         UUCcO/riKC6BYTspGaK/l67IdOuTChEF0/Ybykcd+X7gA+i8NMNRp+TX4zS5d/G+jB
         UJYaLV5ELFKMXpsQU8QYRCT5Y4ZStzHdE6/kuC6gNxvuDJWZ3pUD8r0z76mYXiI4QC
         8KQ+h3lymmO9AlYtkWfWFt9LHV8wAcpjMvQqiC2HEADRk6w9vbGrEBFw0D8vzn0IKk
         +H8D2ybk/7Kdw==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     netdev@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Andrew Smith <andrew.smith@digi.com>
Subject: [[PATCH,net]] net: dsa: mt7530: Change the LINK bit to reflect the link status
Date:   Thu, 19 Mar 2020 14:47:56 +0100
Message-Id: <20200319134756.46428-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew reported:

After a number of network port link up/down changes, sometimes the switch
port gets stuck in a state where it thinks it is still transmitting packets
but the cpu port is not actually transmitting anymore. In this state you
will see a message on the console
"mtk_soc_eth 1e100000.ethernet eth0: transmit timed out" and the Tx counter
in ifconfig will be incrementing on virtual port, but not incrementing on
cpu port.

The issue is that MAC TX/RX status has no impact on the link status or
queue manager of the switch. So the queue manager just queues up packets
of a disabled port and sends out pause frames when the queue is full.

Change the LINK bit to reflect the link status.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Reported-by: Andrew Smith <andrew.smith@digi.com>
Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9ee3f263d529..d422d3d6a129 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -566,7 +566,7 @@ mt7530_mib_reset(struct dsa_switch *ds)
 static void
 mt7530_port_set_status(struct mt7530_priv *priv, int port, int enable)
 {
-	u32 mask = PMCR_TX_EN | PMCR_RX_EN;
+	u32 mask = PMCR_TX_EN | PMCR_RX_EN | PMCR_FORCE_LNK;
 
 	if (enable)
 		mt7530_set(priv, MT7530_PMCR_P(port), mask);
@@ -1512,7 +1512,7 @@ static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
 	mcr_new &= ~(PMCR_FORCE_SPEED_1000 | PMCR_FORCE_SPEED_100 |
 		     PMCR_FORCE_FDX | PMCR_TX_FC_EN | PMCR_RX_FC_EN);
 	mcr_new |= PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | PMCR_BACKOFF_EN |
-		   PMCR_BACKPR_EN | PMCR_FORCE_MODE | PMCR_FORCE_LNK;
+		   PMCR_BACKPR_EN | PMCR_FORCE_MODE;
 
 	/* Are we connected to external phy */
 	if (port == 5 && dsa_is_user_port(ds, 5))
-- 
2.25.1

