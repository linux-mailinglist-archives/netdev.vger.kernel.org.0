Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146266EBE5F
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjDWJzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjDWJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:55:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F29030C1;
        Sun, 23 Apr 2023 02:55:30 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N6TpUM017994;
        Sun, 23 Apr 2023 02:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=JvnJl5vHx+H2j3SRzxgQu2niNFIni68n1jeFGhjY3HA=;
 b=O7tJdtYV3luV9s6zl5yD+E/uSCeOYFUSHbU6p+bX6npwEUdxJb5A3qY2NwmPCt/xWw9w
 1q5tvFbW7YTBndXm+iL0wWPfLOoF6WQXktl/p5L3VCoWNOyko2WOThuzRA0bDhtfAII+
 gRrd10V0V7FlYvvcCQBEEJLGrma3oTqEmQgnahdkfJSQM5rdEqhKmIgRPMrADXINYOa6
 VEwe1VChrQIL/9tK+ieM9/zh+sLJKKkbtt85t9i7t/cAPCaKKWu2+Apwrq1Qj6/ZJu6L
 frmSjR/k3MJf5d8KsTptnPk/EGFfoRd/lwtFgh3TjqjLooCrerIvikXcxF+BVdpVL/w/ wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:19 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id D8CAA3F7071;
        Sun, 23 Apr 2023 02:55:14 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 5/9] octeontx2-pf: mcs: Fix NULL pointer dereferences
Date:   Sun, 23 Apr 2023 15:24:50 +0530
Message-ID: <20230423095454.21049-6-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DdZn5Fz4rAfHjzSAEzz3r5V5ve2UEOLI
X-Proofpoint-GUID: DdZn5Fz4rAfHjzSAEzz3r5V5ve2UEOLI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

When system is rebooted after creating macsec interface
below NULL pointer dereference crashes occurred. This
patch fixes those crashes.

[ 3324.406942] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[ 3324.415726] Mem abort info:
[ 3324.418510]   ESR = 0x96000006
[ 3324.421557]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 3324.426865]   SET = 0, FnV = 0
[ 3324.429913]   EA = 0, S1PTW = 0
[ 3324.433047] Data abort info:
[ 3324.435921]   ISV = 0, ISS = 0x00000006
[ 3324.439748]   CM = 0, WnR = 0
....
[ 3324.575915] Call trace:
[ 3324.578353]  cn10k_mdo_del_secy+0x24/0x180
[ 3324.582440]  macsec_common_dellink+0xec/0x120
[ 3324.586788]  macsec_notify+0x17c/0x1c0
[ 3324.590529]  raw_notifier_call_chain+0x50/0x70
[ 3324.594965]  call_netdevice_notifiers_info+0x34/0x7c
[ 3324.599921]  rollback_registered_many+0x354/0x5bc
[ 3324.604616]  unregister_netdevice_queue+0x88/0x10c
[ 3324.609399]  unregister_netdev+0x20/0x30
[ 3324.613313]  otx2_remove+0x8c/0x310
[ 3324.616794]  pci_device_shutdown+0x30/0x70
[ 3324.620882]  device_shutdown+0x11c/0x204

[  966.664930] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  966.673712] Mem abort info:
[  966.676497]   ESR = 0x96000006
[  966.679543]   EC = 0x25: DABT (current EL), IL = 32 bits
[  966.684848]   SET = 0, FnV = 0
[  966.687895]   EA = 0, S1PTW = 0
[  966.691028] Data abort info:
[  966.693900]   ISV = 0, ISS = 0x00000006
[  966.697729]   CM = 0, WnR = 0
....
[  966.833467] Call trace:
[  966.835904]  cn10k_mdo_stop+0x20/0xa0
[  966.839557]  macsec_dev_stop+0xe8/0x11c
[  966.843384]  __dev_close_many+0xbc/0x140
[  966.847298]  dev_close_many+0x84/0x120
[  966.851039]  rollback_registered_many+0x114/0x5bc
[  966.855735]  unregister_netdevice_many.part.0+0x14/0xa0
[  966.860952]  unregister_netdevice_many+0x18/0x24
[  966.865560]  macsec_notify+0x1ac/0x1c0
[  966.869303]  raw_notifier_call_chain+0x50/0x70
[  966.873738]  call_netdevice_notifiers_info+0x34/0x7c
[  966.878694]  rollback_registered_many+0x354/0x5bc
[  966.883390]  unregister_netdevice_queue+0x88/0x10c
[  966.888173]  unregister_netdev+0x20/0x30
[  966.892090]  otx2_remove+0x8c/0x310
[  966.895571]  pci_device_shutdown+0x30/0x70
[  966.899660]  device_shutdown+0x11c/0x204
[  966.903574]  __do_sys_reboot+0x208/0x290
[  966.907487]  __arm64_sys_reboot+0x20/0x30
[  966.911489]  el0_svc_handler+0x80/0x1c0
[  966.915316]  el0_svc+0x8/0x180
[  966.918362] Code: f9400000 f9400a64 91220014 f94b3403 (f9400060)
[  966.924448] ---[ end trace 341778e799c3d8d7 ]---

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 9ec5f38d38a8..5f4402f7b03e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1065,6 +1065,9 @@ static int cn10k_mdo_stop(struct macsec_context *ctx)
 	struct cn10k_mcs_txsc *txsc;
 	int err;
 
+	if (!cfg)
+		return 0;
+
 	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
 	if (!txsc)
 		return -ENOENT;
@@ -1146,6 +1149,9 @@ static int cn10k_mdo_del_secy(struct macsec_context *ctx)
 	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
 	struct cn10k_mcs_txsc *txsc;
 
+	if (!cfg)
+		return 0;
+
 	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
 	if (!txsc)
 		return -ENOENT;
-- 
2.25.1

