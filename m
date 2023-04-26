Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C746A6EEE50
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbjDZG01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbjDZG0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:26:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B277630E4;
        Tue, 25 Apr 2023 23:26:00 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q64Kfo001000;
        Tue, 25 Apr 2023 23:25:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vvzubNaZO+fbiB5i3liUp++u7cDAvPtmLpNSpBWRXYw=;
 b=KlppwRA46DExm+QWlNYjR0Mfuvc3WouERDutWBRy1jGRv0j7AyudJFQJT4EWEkbozuwJ
 tkJ6MpJlp8DPw4rRPi8iFIWPT0WUaUcYjHMM+goj/sXaBe3HhGWrSv41UGfyJWCa2WII
 fN0Q+yVq3728QH5v2kPC5ztI/c1eyYJwAMnAekV79x7wjlSkyLh2nlc6++QR24aDA9xi
 T7V6zijf4zW6K3YgfaUtUIag6aeqHxc5bUefyGWskbvXgYxvXsWALpDhq7FOXobCb5pT
 CdHeE5CXDaXviqnGZuukvXL2eNRfj9SH8UR3tHlyEmC6tyF9zU4otj4fYXWc1KxqGuAP OA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pdcws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 23:25:53 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 23:25:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 23:25:50 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B8FD13F7075;
        Tue, 25 Apr 2023 23:25:47 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH v2 5/9] octeontx2-pf: mcs: Fix NULL pointer dereferences
Date:   Wed, 26 Apr 2023 11:55:24 +0530
Message-ID: <20230426062528.20575-6-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426062528.20575-1-gakula@marvell.com>
References: <20230426062528.20575-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 9srHDiYVploIK9iwT12yFoDwsivAKsUk
X-Proofpoint-GUID: 9srHDiYVploIK9iwT12yFoDwsivAKsUk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

When system is rebooted after creating macsec interface
below NULL pointer dereference crashes occurred. This
patch fixes those crashes by using correct order of teardown

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
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 179433d0a54a..a75c944cc739 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3073,8 +3073,6 @@ static void otx2_remove(struct pci_dev *pdev)
 		otx2_config_pause_frm(pf);
 	}
 
-	cn10k_mcs_free(pf);
-
 #ifdef CONFIG_DCB
 	/* Disable PFC config */
 	if (pf->pfc_en) {
@@ -3088,6 +3086,7 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	otx2_unregister_dl(pf);
 	unregister_netdev(netdev);
+	cn10k_mcs_free(pf);
 	otx2_sriov_disable(pf->pdev);
 	otx2_sriov_vfcfg_cleanup(pf);
 	if (pf->otx2_wq)
-- 
2.25.1

