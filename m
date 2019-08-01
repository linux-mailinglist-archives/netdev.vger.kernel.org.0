Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6767DB15
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbfHAMNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:13:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37459 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730152AbfHAMNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 08:13:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so48256395wrr.4
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 05:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7h/UR6i2sYvHhLaWoTpYLzUoMVyfS2cAta4y7sLvNA=;
        b=JcJohTYZqPA9EeejyGGPB3D4DWJ2uExjaH+CMJB066Tfwagg8sJXdJslxH0xbRI3Bx
         0G6WSe9UO4upr42KzSe1a65iCfcPXf5JpPUZCHYxAU2QSvAP6ZjAKilkdrF/kR8zZQur
         K+EDhnUXUeciACCXMsJxHjiH9zFS7Bd71qDzVdnPxZKEZNiFSe2woqotZ06ZESgixvWu
         4zsgOp9ve0HSeH+V4ZshZXn4u17vkXTv4FVLHRGCQcoGLITPZgFbFzpb9tMnm6DJ0TO4
         ShDXwev7Mq5DwE2sIrZycxIXiNEzdjuzNTbRD0l6tHPsuLtV86wU7NoC8dFSG8mSSum9
         940A==
X-Gm-Message-State: APjAAAVT7k8CqSqkdDP6gVNdi8bzGypLYdpAYaxhmF4QR69+JD4wX7k9
        4M4zRc0lhX4t5RxemW+IXEniOoHbuoDRUA==
X-Google-Smtp-Source: APXvYqygcfyRcOw/MSDQR2PAoDgO9uzHnF0mgMQeQ+e0FOUXqEEsuEVt/M9YOiHuxrYlxT+mhxErMg==
X-Received: by 2002:adf:b612:: with SMTP id f18mr131185310wre.97.1564661613940;
        Thu, 01 Aug 2019 05:13:33 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
        by smtp.gmail.com with ESMTPSA id c4sm56980017wrt.86.2019.08.01.05.13.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 05:13:33 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>
Subject: [PATCH net v2] mvpp2: fix panic on module removal
Date:   Thu,  1 Aug 2019 14:13:30 +0200
Message-Id: <20190801121330.30823-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvpp2 uses a delayed workqueue to gather traffic statistics.
On module removal the workqueue can be destroyed before calling
cancel_delayed_work_sync() on its works.
Fix it by moving the destroy_workqueue() call after mvpp2_port_remove().
Also remove an unneeded call to flush_workqueue()

    # rmmod mvpp2
    [ 2743.311722] mvpp2 f4000000.ethernet eth1: phy link down 10gbase-kr/10Gbps/Full
    [ 2743.320063] mvpp2 f4000000.ethernet eth1: Link is Down
    [ 2743.572263] mvpp2 f4000000.ethernet eth2: phy link down sgmii/1Gbps/Full
    [ 2743.580076] mvpp2 f4000000.ethernet eth2: Link is Down
    [ 2744.102169] mvpp2 f2000000.ethernet eth0: phy link down 10gbase-kr/10Gbps/Full
    [ 2744.110441] mvpp2 f2000000.ethernet eth0: Link is Down
    [ 2744.115614] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
    [ 2744.115615] Mem abort info:
    [ 2744.115616]   ESR = 0x96000005
    [ 2744.115617]   Exception class = DABT (current EL), IL = 32 bits
    [ 2744.115618]   SET = 0, FnV = 0
    [ 2744.115619]   EA = 0, S1PTW = 0
    [ 2744.115620] Data abort info:
    [ 2744.115621]   ISV = 0, ISS = 0x00000005
    [ 2744.115622]   CM = 0, WnR = 0
    [ 2744.115624] user pgtable: 4k pages, 39-bit VAs, pgdp=0000000422681000
    [ 2744.115626] [0000000000000000] pgd=0000000000000000, pud=0000000000000000
    [ 2744.115630] Internal error: Oops: 96000005 [#1] SMP
    [ 2744.115632] Modules linked in: mvpp2(-) algif_hash af_alg nls_iso8859_1 nls_cp437 vfat fat xhci_plat_hcd m25p80 spi_nor xhci_hcd mtd usbcore i2c_mv64xxx sfp usb_common marvell10g phy_generic spi_orion mdio_i2c i2c_core mvmdio phylink sbsa_gwdt ip_tables x_tables autofs4 [last unloaded: mvpp2]
    [ 2744.115654] CPU: 3 PID: 8357 Comm: kworker/3:2 Not tainted 5.3.0-rc2 #1
    [ 2744.115655] Hardware name: Marvell 8040 MACCHIATOBin Double-shot (DT)
    [ 2744.115665] Workqueue: events_power_efficient phylink_resolve [phylink]
    [ 2744.115669] pstate: a0000085 (NzCv daIf -PAN -UAO)
    [ 2744.115675] pc : __queue_work+0x9c/0x4d8
    [ 2744.115677] lr : __queue_work+0x170/0x4d8
    [ 2744.115678] sp : ffffff801001bd50
    [ 2744.115680] x29: ffffff801001bd50 x28: ffffffc422597600
    [ 2744.115684] x27: ffffff80109ae6f0 x26: ffffff80108e4018
    [ 2744.115688] x25: 0000000000000003 x24: 0000000000000004
    [ 2744.115691] x23: ffffff80109ae6e0 x22: 0000000000000017
    [ 2744.115694] x21: ffffffc42c030000 x20: ffffffc42209e8f8
    [ 2744.115697] x19: 0000000000000000 x18: 0000000000000000
    [ 2744.115699] x17: 0000000000000000 x16: 0000000000000000
    [ 2744.115701] x15: 0000000000000010 x14: ffffffffffffffff
    [ 2744.115702] x13: ffffff8090e2b95f x12: ffffff8010e2b967
    [ 2744.115704] x11: ffffff8010906000 x10: 0000000000000040
    [ 2744.115706] x9 : ffffff80109223b8 x8 : ffffff80109223b0
    [ 2744.115707] x7 : ffffffc42bc00068 x6 : 0000000000000000
    [ 2744.115709] x5 : ffffffc42bc00000 x4 : 0000000000000000
    [ 2744.115710] x3 : 0000000000000000 x2 : 0000000000000000
    [ 2744.115712] x1 : 0000000000000008 x0 : ffffffc42c030000
    [ 2744.115714] Call trace:
    [ 2744.115716]  __queue_work+0x9c/0x4d8
    [ 2744.115718]  delayed_work_timer_fn+0x28/0x38
    [ 2744.115722]  call_timer_fn+0x3c/0x180
    [ 2744.115723]  expire_timers+0x60/0x168
    [ 2744.115724]  run_timer_softirq+0xbc/0x1e8
    [ 2744.115727]  __do_softirq+0x128/0x320
    [ 2744.115731]  irq_exit+0xa4/0xc0
    [ 2744.115734]  __handle_domain_irq+0x70/0xc0
    [ 2744.115735]  gic_handle_irq+0x58/0xa8
    [ 2744.115737]  el1_irq+0xb8/0x140
    [ 2744.115738]  console_unlock+0x3a0/0x568
    [ 2744.115740]  vprintk_emit+0x200/0x2a0
    [ 2744.115744]  dev_vprintk_emit+0x1c8/0x1e4
    [ 2744.115747]  dev_printk_emit+0x6c/0x7c
    [ 2744.115751]  __netdev_printk+0x104/0x1d8
    [ 2744.115752]  netdev_printk+0x60/0x70
    [ 2744.115756]  phylink_resolve+0x38c/0x3c8 [phylink]
    [ 2744.115758]  process_one_work+0x1f8/0x448
    [ 2744.115760]  worker_thread+0x54/0x500
    [ 2744.115762]  kthread+0x12c/0x130
    [ 2744.115764]  ret_from_fork+0x10/0x1c
    [ 2744.115768] Code: aa1403e0 97fffbbe aa0003f5 b4000700 (f9400261)

Fixes: 118d6298f6f0 ("net: mvpp2: add ethtool GOP statistics")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c51f1d5b550b..ad42cc0a2b4a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5759,9 +5759,6 @@ static int mvpp2_remove(struct platform_device *pdev)
 
 	mvpp2_dbgfs_cleanup(priv);
 
-	flush_workqueue(priv->stats_queue);
-	destroy_workqueue(priv->stats_queue);
-
 	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
 		if (priv->port_list[i]) {
 			mutex_destroy(&priv->port_list[i]->gather_stats_lock);
@@ -5770,6 +5767,8 @@ static int mvpp2_remove(struct platform_device *pdev)
 		i++;
 	}
 
+	destroy_workqueue(priv->stats_queue);
+
 	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
 		struct mvpp2_bm_pool *bm_pool = &priv->bm_pools[i];
 
-- 
2.21.0

