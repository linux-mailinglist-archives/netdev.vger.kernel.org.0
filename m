Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6674FDE9B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345061AbiDLLub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349398AbiDLLro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18302574A1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649759291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CI/supGVxEWMyhUXNHAcGDlAX2GlLgQ43ophBjewddA=;
        b=GV+44362oNbDu9VbBOULJzZ40yp3VzDGQ1PJVKHbedEnlLn2mHyR7vRxg661TfQjkg3rve
        x4fw5cO+oWB5Z5QZgEDG9bPwiEQ5Ia5PaOIxhrGxJkROVpjOrd2fUFizaGUFMSRVFp4+qA
        h55Hy2QG/IZeDt2cqVuqbIuphSs5+co=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-7ujAnAPBPiaVaavGGEhO7Q-1; Tue, 12 Apr 2022 06:28:07 -0400
X-MC-Unique: 7ujAnAPBPiaVaavGGEhO7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD06D3804091;
        Tue, 12 Apr 2022 10:28:06 +0000 (UTC)
Received: from horn.redhat.com (unknown [10.40.193.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABA94145BA42;
        Tue, 12 Apr 2022 10:28:04 +0000 (UTC)
From:   Petr Oros <poros@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jacob.e.keller@intel.com, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org, ivecera@redhat.com
Subject: [PATCH] ice: wait for EMP reset after firmware flash
Date:   Tue, 12 Apr 2022 12:27:53 +0200
Message-Id: <20220412102753.670867-1-poros@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to wait for EMP reset after firmware flash.
Code was extracted from OOT driver and without this wait fw_activate let
card in inconsistent state recoverable only by second flash/activate

Reproducer:
[root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
Preparing to flash
[fw.mgmt] Erasing
[fw.mgmt] Erasing done
[fw.mgmt] Flashing 100%
[fw.mgmt] Flashing done 100%
[fw.undi] Erasing
[fw.undi] Erasing done
[fw.undi] Flashing 100%
[fw.undi] Flashing done 100%
[fw.netlist] Erasing
[fw.netlist] Erasing done
[fw.netlist] Flashing 100%
[fw.netlist] Flashing done 100%
Activate new firmware by devlink reload
[root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
reload_actions_performed:
    fw_activate
[root@host ~]# ip link show ens7f0
71: ens7f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
    altname enp202s0f0

dmesg after flash:
[   55.120788] ice: Copyright (c) 2018, Intel Corporation.
[   55.274734] ice 0000:ca:00.0: Get PHY capabilities failed status = -5, continuing anyway
[   55.569797] ice 0000:ca:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.28.0
[   55.603629] ice 0000:ca:00.0: Get PHY capability failed.
[   55.608951] ice 0000:ca:00.0: ice_init_nvm_phy_type failed: -5
[   55.647348] ice 0000:ca:00.0: PTP init successful
[   55.675536] ice 0000:ca:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[   55.685365] ice 0000:ca:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
[   55.692179] ice 0000:ca:00.0: Commit DCB Configuration to the hardware
[   55.701382] ice 0000:ca:00.0: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:c9:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
Reboot don't help, only second flash/activate with OOT or patched driver put card back in consistent state

After patch:
[root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
Preparing to flash
[fw.mgmt] Erasing
[fw.mgmt] Erasing done
[fw.mgmt] Flashing 100%
[fw.mgmt] Flashing done 100%
[fw.undi] Erasing
[fw.undi] Erasing done
[fw.undi] Flashing 100%
[fw.undi] Flashing done 100%
[fw.netlist] Erasing
[fw.netlist] Erasing done
[fw.netlist] Flashing 100%
[fw.netlist] Flashing done 100%
Activate new firmware by devlink reload
[root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
reload_actions_performed:
    fw_activate
[root@host ~]# ip link show ens7f0
19: ens7f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
    altname enp202s0f0

Fixes: 399e27dbbd9e94 ("ice: support immediate firmware activation via devlink reload")
Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d768925785ca79..90ea2203cdc763 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6931,12 +6931,15 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
 
+#define ICE_EMP_RESET_SLEEP 5000
 	if (reset_type == ICE_RESET_EMPR) {
 		/* If an EMP reset has occurred, any previously pending flash
 		 * update will have completed. We no longer know whether or
 		 * not the NVM update EMP reset is restricted.
 		 */
 		pf->fw_emp_reset_disabled = false;
+
+		msleep(ICE_EMP_RESET_SLEEP);
 	}
 
 	err = ice_init_all_ctrlq(hw);
-- 
2.35.1

