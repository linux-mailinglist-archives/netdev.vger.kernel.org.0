Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E90606372
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJTOpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiJTOpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:45:07 -0400
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27594A221C;
        Thu, 20 Oct 2022 07:44:52 -0700 (PDT)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout2.routing.net (Postfix) with ESMTP id 20C996047A;
        Thu, 20 Oct 2022 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1666277090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NLfl5Pdqwg6aGY+z2JjYmMdWIFLHrMR79K7EJC5O2Xk=;
        b=vZEulL3T7TwliUM7EVF5HlGsUJriE48id3uDksJ6DLN2DwtnIOMY8Rj2bTC6LT060NbNyO
        8bkreAm+kNAVbM4uw9aDKEWZFHQ9b7fizN/CJrrbvfepGz2/n15dzuK8Z6JsbRAnMLnmtY
        a/gq7bYfJ4MlIJKs3SCK7vYJH/3blQ4=
Received: from frank-G5.. (fttx-pool-217.61.146.75.bambit.de [217.61.146.75])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id BA5FA8008E;
        Thu, 20 Oct 2022 14:44:48 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Alexander Couzens <lynxis@fe80.eu>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Date:   Thu, 20 Oct 2022 16:44:31 +0200
Message-Id: <20221020144431.126124-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 21e2aa99-0ce2-48c8-b40d-8630028e796d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Couzens <lynxis@fe80.eu>

Implement mtk_pcs_ops for the SGMII pcs to read the current state
of the hardware.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>

Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
---
v2:
- reorder members in phylink_pcs_ops
- drop pause setting

without this Patch i get this trace in 6.1-rc1 when enabling the left
sfp (eth1) on bpi-r3 (crash happens in phylink core because a NULL-pointer,
so fixes-Tag is a guess):

[  108.302810] Unable to handle kernel execute from non-executable memory at virtual address 0000000000000000
[  108.312462] Mem abort info:
[  108.315263]   ESR = 0x0000000086000005
[  108.319003]   EC = 0x21: IABT (current EL), IL = 32 bits
[  108.324335]   SET = 0, FnV = 0
[  108.327378]   EA = 0, S1PTW = 0
[  108.330505]   FSC = 0x05: level 1 translation fault
[  108.335375] user pgtable: 4k pages, 39-bit VAs, pgdp=00000000419be000
[  108.341798] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000, pu
d=0000000000000000
[  108.350489] Internal error: Oops: 0000000086000005 [#1] SMP
[  108.356047] Modules linked in: cdc_mbim cdc_ncm cdc_wdm cdc_ether qcserial us
a_wwan usbnet usbser
a Mmeisis
ge from syslogd@bpi-r3 at Aug  7 15:26:54 ...
 kernel:[  108.350489] Internal error: Oops: 0000000086000005 [#1] SMP
[  108.376743] CPU: 3 PID: 8 Comm: kworker/u8:0 Not tainted 6.0.0-bpi-r3 #1
[  108.383461] Hardware name: Bananapi BPI-R3 (sdmmc) (DT)
[  108.388671] Workqueue: events_power_efficient phylink_resolve
[  108.394411] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  108.401355] pc : 0x0
[  108.403531] lr : phylink_mac_pcs_get_state+0x7c/0x100
[  108.408572] sp : ffffffc00963bd00
[  108.411873] x29: ffffffc00963bd00 x28: 0000000000000000 x27: 0000000000000000
[  108.418994] x26: ffffff80000ed074 x25: ffffff800001c105 x24: 0000000000000000
[  108.426116] x23: ffffff80022f8cd8 x22: ffffff80022f8d30 x21: ffffff80022f8c00
[  108.433236] x20: 0000000000000000 x19: ffffff8000126040 x18: 0000000000000000
[  108.440357] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[  108.447478] x14: ffffffffffffffff x13: 0000000000000030 x12: 0101010101010101
[  108.454598] x11: 7f7f7f7f7f7f7f7f x10: fefefefefefefeff x9 : ffffff80000ed07c
[  108.461720] x8 : fefefefefefefeff x7 : 0000000000000017 x6 : ffffff80000ed074
[  108.468840] x5 : 0000000000000000 x4 : 0000020000006440 x3 : 00000000fffffffa
[  108.475960] x2 : 0000000000000000 x1 : ffffffc00963bd80 x0 : ffffff80014c3ab0
[  108.483082] Call trace:
[  108.485516]  0x0
[  108.487344]  phylink_resolve+0x248/0x520
[  108.491256]  process_one_work+0x204/0x478
[  108.495256]  worker_thread+0x148/0x4c0
[  108.498993]  kthread+0xdc/0xe8
[  108.502037]  ret_from_fork+0x10/0x20
[  108.505608] Code: bad PC value
[  108.508652] ---[ end trace 0000000000000000 ]---
[  108.513255] Kernel panic - not syncing: Oops: Fatal exception
[  108.518984] SMP: stopping secondary CPUs
[  108.522894] Kernel Offset: disabled
[  108.526369] CPU features: 0x00000,00800084,0000420b
[  108.531232] Memory Limit: none
[  108.534274] Rebooting in 1 seconds..
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 736839c84130..8b7465057e57 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -122,7 +122,21 @@ static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
 }
 
+static void mtk_pcs_get_state(struct phylink_pcs *pcs, struct phylink_link_state *state)
+{
+	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	unsigned int val;
+
+	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
+	state->speed = val & RG_PHY_SPEED_3_125G ? SPEED_2500 : SPEED_1000;
+
+	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
+	state->an_complete = !!(val & SGMII_AN_COMPLETE);
+	state->link = !!(val & SGMII_LINK_STATYS);
+}
+
 static const struct phylink_pcs_ops mtk_pcs_ops = {
+	.pcs_get_state = mtk_pcs_get_state,
 	.pcs_config = mtk_pcs_config,
 	.pcs_an_restart = mtk_pcs_restart_an,
 	.pcs_link_up = mtk_pcs_link_up,
-- 
2.34.1

