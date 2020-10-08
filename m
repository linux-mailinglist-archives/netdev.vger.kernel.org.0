Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D120E2873B2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgJHL6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHL6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:58:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293F3C061755;
        Thu,  8 Oct 2020 04:58:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h2so2643122pll.11;
        Thu, 08 Oct 2020 04:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3OFquukHoMu9n94tKujWLnRYqiNvHzmkGIP28BJkBw8=;
        b=eOcnhk8Iw5OIf0hY3osasiDAnFP1KOXOqCwk7YMNIokUezphtq45JruiQqhsU+JXAB
         5Lx7cxi3WbDFGs/qJJaT7JW8JJIHzzom8Ft07hcvHdF8cjnIYYu44vVTmQtBNDp4ECRw
         L+po8/Xx0YQjCHwgFY9uGGhfz8dsCPWQpR1YgF+8yGnwtrBM20Ke+xvyV1SdyIHsMV62
         18bEDBf+cjxxjpv3hXcD4uhfnmpUD5r7s9uXkmrrNo0qgtoasBipTBdp9ldj1UvOVV1i
         tw3ocgV9rGApuwFzU7VBhTRwgQOeWfnMODkBAjhoQiA2HHcmZlxDIi4qpXCDJ+y74UyO
         MBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OFquukHoMu9n94tKujWLnRYqiNvHzmkGIP28BJkBw8=;
        b=ZLWy7IDUTXt78DhuXmk5beXTlGYDheE556OWXgUBK0zMIIOTrF8ht2QtyGTO55R7P5
         xABifJSgi0vuQM2xpOIwve/ifkzhAnVZrcz8mdrOsGvBPuiD39Y7trOg+ryLpSOTovHl
         nDwfu09inA96qTxXpetsw+WYTawvEN60Q/sZxiz4zEMyUJy+sLpqcOrxO9zyOCvjkDxM
         WTeKyFZtkCqA+RvOREtdvnrO5VnT2lFf1odwKPrk68bfTeDr6lUV685lkA+wQSeTK/20
         DLXzJNLKUHa8er1MCifOxouUDfephYVbf1gor1dJRvBaixBramhHXOunD+klXxdqosOL
         jPOA==
X-Gm-Message-State: AOAM532j08vTnmLZzQ5xF1lDZYCID4zlL44NL2HyK7ZNthUKbuaYp722
        WXM2JQWcX3LIThCmUM9LCVU=
X-Google-Smtp-Source: ABdhPJywIrj6kS3v/8UP7Gy3NYZB4iDCMUVBSvyhyeFrdW8F5KwFy8rKnRSc/BKDdMtdjMrWw/7yUg==
X-Received: by 2002:a17:902:6545:b029:d3:d370:2882 with SMTP id d5-20020a1709026545b02900d3d3702882mr7421335pln.44.1602158309625;
        Thu, 08 Oct 2020 04:58:29 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id nm11sm6081911pjb.24.2020.10.08.04.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 04:58:29 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/6] staging: qlge: coredump via devlink health reporter
Date:   Thu,  8 Oct 2020 19:58:04 +0800
Message-Id: <20201008115808.91850-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008115808.91850-1-coiby.xu@gmail.com>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    $ devlink health dump show DEVICE reporter coredump -p -j
    {
        "Core Registers": {
            "segment": 1,
            "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
        },
        "Test Logic Regs": {
            "segment": 2,
            "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
        },
        "RMII Registers": {
            "segment": 3,
            "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
        },
        ...
        "Sem Registers": {
            "segment": 50,
            "values": [ 0,0,0,0 ]
        }
    }

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_devlink.c | 131 ++++++++++++++++++++++++++--
 1 file changed, 125 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index aa45e7e368c0..91b6600b94a9 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -1,16 +1,135 @@
 #include "qlge.h"
 #include "qlge_devlink.h"
 
-static int
-qlge_reporter_coredump(struct devlink_health_reporter *reporter,
-			struct devlink_fmsg *fmsg, void *priv_ctx,
-			struct netlink_ext_ack *extack)
+static int fill_seg_(struct devlink_fmsg *fmsg,
+		    struct mpi_coredump_segment_header *seg_header,
+		    u32 *reg_data)
 {
-	return 0;
+	int i;
+	int header_size = sizeof(struct mpi_coredump_segment_header);
+	int regs_num = (seg_header->seg_size - header_size) / sizeof(u32);
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, seg_header->description);
+	if (err)
+		return err;
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "segment", seg_header->seg_num);
+	if (err)
+		return err;
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "values");
+	if (err)
+		return err;
+	for (i = 0; i < regs_num; i++) {
+		err = devlink_fmsg_u32_put(fmsg, *reg_data);
+		if (err)
+			return err;
+		reg_data++;
+	}
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	return err;
+}
+
+#define fill_seg(seg_hdr, seg_regs)			               \
+	do {                                                           \
+		err = fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
+		if (err) {					       \
+			kvfree(dump);                                  \
+			return err;				       \
+		}                                                      \
+	} while (0)
+
+static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
+				  struct devlink_fmsg *fmsg, void *priv_ctx,
+				  struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);
+	struct ql_adapter *qdev = dev->qdev;
+	struct ql_mpi_coredump *dump;
+
+	if (!netif_running(qdev->ndev))
+		return 0;
+
+	dump = kvmalloc(sizeof(*dump), GFP_KERNEL);
+	if (!dump)
+		return -ENOMEM;
+
+	err = ql_core_dump(qdev, dump);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	fill_seg(core_regs_seg_hdr, mpi_core_regs);
+	fill_seg(test_logic_regs_seg_hdr, test_logic_regs);
+	fill_seg(rmii_regs_seg_hdr, rmii_regs);
+	fill_seg(fcmac1_regs_seg_hdr, fcmac1_regs);
+	fill_seg(fcmac2_regs_seg_hdr, fcmac2_regs);
+	fill_seg(fc1_mbx_regs_seg_hdr, fc1_mbx_regs);
+	fill_seg(ide_regs_seg_hdr, ide_regs);
+	fill_seg(nic1_mbx_regs_seg_hdr, nic1_mbx_regs);
+	fill_seg(smbus_regs_seg_hdr, smbus_regs);
+	fill_seg(fc2_mbx_regs_seg_hdr, fc2_mbx_regs);
+	fill_seg(nic2_mbx_regs_seg_hdr, nic2_mbx_regs);
+	fill_seg(i2c_regs_seg_hdr, i2c_regs);
+	fill_seg(memc_regs_seg_hdr, memc_regs);
+	fill_seg(pbus_regs_seg_hdr, pbus_regs);
+	fill_seg(mde_regs_seg_hdr, mde_regs);
+	fill_seg(nic_regs_seg_hdr, nic_regs);
+	fill_seg(nic2_regs_seg_hdr, nic2_regs);
+	fill_seg(xgmac1_seg_hdr, xgmac1);
+	fill_seg(xgmac2_seg_hdr, xgmac2);
+	fill_seg(code_ram_seg_hdr, code_ram);
+	fill_seg(memc_ram_seg_hdr, memc_ram);
+	fill_seg(xaui_an_hdr, serdes_xaui_an);
+	fill_seg(xaui_hss_pcs_hdr, serdes_xaui_hss_pcs);
+	fill_seg(xfi_an_hdr, serdes_xfi_an);
+	fill_seg(xfi_train_hdr, serdes_xfi_train);
+	fill_seg(xfi_hss_pcs_hdr, serdes_xfi_hss_pcs);
+	fill_seg(xfi_hss_tx_hdr, serdes_xfi_hss_tx);
+	fill_seg(xfi_hss_rx_hdr, serdes_xfi_hss_rx);
+	fill_seg(xfi_hss_pll_hdr, serdes_xfi_hss_pll);
+
+	err = fill_seg_(fmsg, &dump->misc_nic_seg_hdr,
+			(u32 *)&dump->misc_nic_info);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	fill_seg(intr_states_seg_hdr, intr_states);
+	fill_seg(cam_entries_seg_hdr, cam_entries);
+	fill_seg(nic_routing_words_seg_hdr, nic_routing_words);
+	fill_seg(ets_seg_hdr, ets);
+	fill_seg(probe_dump_seg_hdr, probe_dump);
+	fill_seg(routing_reg_seg_hdr, routing_regs);
+	fill_seg(mac_prot_reg_seg_hdr, mac_prot_regs);
+	fill_seg(xaui2_an_hdr, serdes2_xaui_an);
+	fill_seg(xaui2_hss_pcs_hdr, serdes2_xaui_hss_pcs);
+	fill_seg(xfi2_an_hdr, serdes2_xfi_an);
+	fill_seg(xfi2_train_hdr, serdes2_xfi_train);
+	fill_seg(xfi2_hss_pcs_hdr, serdes2_xfi_hss_pcs);
+	fill_seg(xfi2_hss_tx_hdr, serdes2_xfi_hss_tx);
+	fill_seg(xfi2_hss_rx_hdr, serdes2_xfi_hss_rx);
+	fill_seg(xfi2_hss_pll_hdr, serdes2_xfi_hss_pll);
+	fill_seg(sem_regs_seg_hdr, sem_regs);
+
+	kvfree(dump);
+	return err;
 }
 
 static const struct devlink_health_reporter_ops qlge_reporter_ops = {
-		.name = "dummy",
+		.name = "coredump",
 		.dump = qlge_reporter_coredump,
 };
 
-- 
2.28.0

