Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D3E2904B7
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407177AbgJPMF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406845AbgJPMF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:05:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED06C061755;
        Fri, 16 Oct 2020 05:05:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y14so1362771pfp.13;
        Fri, 16 Oct 2020 05:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIgU8Plb5Hs46cFWHX9Gbtdd89uW5HBlBB0rZ1YZFlg=;
        b=Q8jJiAPhYm/407VOToSm9Nu8DVPvMyM63t+fLFLP0YhChsutdYM1TvbMNMGfPLnS8e
         rmI0DBy7197y40qusGvm4Nfp/ro2mqsFrr7vOP3CUmT6+uTrGRkWjrDclhgrHwujqdGO
         xlvNlVv7EW7p+v/H9Y+sJ4aP7ihBPpUlCuAD5GvLhfkzAlCE4HM/3gRxps4QwGiiaq7b
         suaQp3pzNyzyntqox3J9QxylOZnLBWRKY9wnOMDEkokpTZHVmzhDOMKW2bOkh+/DlEMe
         E0D/S1NV6yBpUWz7ZFlym/H0TT90D6n7/ikzG3uvuVIeQ4/eYD+J1BDHI1IVD6Z5hPEN
         fhNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIgU8Plb5Hs46cFWHX9Gbtdd89uW5HBlBB0rZ1YZFlg=;
        b=qkZEWxA12kiOjmyDds/Jhw339Wlv7Lg1BV9ytnm8pvj+hSc2kVESQ7CULl+Y3DSKHY
         5r8hyzZl8RNOo+JJZyaNeZgYnx82U+VIUE2ZR8wu0227EjLYZOh6jlM87zfI9ctP06J0
         PxoqSLilkx9wAkuXwfnEMGpJ4oZGdxYD7FJ0wKCg8h+OAQAVJfdzdKjd72etPHSgMwaf
         IgLGr0zrV6wzoVYSPC0OlYNyPyV/PFLdVeCJBTPcHNuya9nNCaWLeFSDz/ZVlmE6z06b
         sifviM1x8mFzlkw4wbzujhW+aTrv0dMkG2US+4KlUpE7L1pl/irS1o9Db8y5xibWbQXh
         uOog==
X-Gm-Message-State: AOAM5323hj0kw93xFUThQgvAjfSXm76ivU2JhwSBNf4R2PZ8EfXael6t
        fsbL6YgXtVzKUz5wtm7n6YQ=
X-Google-Smtp-Source: ABdhPJx4YgQUKDxWrW658qt080dTPpi/N6P2877g03FerOyS1Efpo35bR51xKc/8cFKjKMixK+ju6A==
X-Received: by 2002:a63:2246:: with SMTP id t6mr2892831pgm.103.1602849926703;
        Fri, 16 Oct 2020 05:05:26 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id e19sm2701300pff.34.2020.10.16.05.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:05:26 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 4/8] staging: qlge: coredump via devlink health reporter
Date:   Fri, 16 Oct 2020 19:54:03 +0800
Message-Id: <20201016115407.170821-5-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016115407.170821-1-coiby.xu@gmail.com>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
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
 drivers/staging/qlge/qlge_devlink.c | 130 ++++++++++++++++++++++++++--
 1 file changed, 124 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index d9c71f45211f..b75ec5bff26a 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -2,16 +2,134 @@
 #include "qlge.h"
 #include "qlge_devlink.h"
 
-static int
-qlge_reporter_coredump(struct devlink_health_reporter *reporter,
-		       struct devlink_fmsg *fmsg, void *priv_ctx,
-		       struct netlink_ext_ack *extack)
+static int qlge_fill_seg_(struct devlink_fmsg *fmsg,
+			  struct mpi_coredump_segment_header *seg_header,
+			  u32 *reg_data)
 {
-	return 0;
+	int regs_num = (seg_header->seg_size
+			- sizeof(struct mpi_coredump_segment_header)) / sizeof(u32);
+	int err;
+	int i;
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
+#define FILL_SEG(seg_hdr, seg_regs)			                    \
+	do {                                                                \
+		err = qlge_fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
+		if (err) {					            \
+			kvfree(dump);                                       \
+			return err;				            \
+		}                                                           \
+	} while (0)
+
+static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
+				  struct devlink_fmsg *fmsg, void *priv_ctx,
+				  struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	struct qlge_adapter *qdev = devlink_health_reporter_priv(reporter);
+	struct qlge_mpi_coredump *dump;
+
+	if (!netif_running(qdev->ndev))
+		return 0;
+
+	dump = kvmalloc(sizeof(*dump), GFP_KERNEL);
+	if (!dump)
+		return -ENOMEM;
+
+	err = qlge_core_dump(qdev, dump);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	FILL_SEG(core_regs_seg_hdr, mpi_core_regs);
+	FILL_SEG(test_logic_regs_seg_hdr, test_logic_regs);
+	FILL_SEG(rmii_regs_seg_hdr, rmii_regs);
+	FILL_SEG(fcmac1_regs_seg_hdr, fcmac1_regs);
+	FILL_SEG(fcmac2_regs_seg_hdr, fcmac2_regs);
+	FILL_SEG(fc1_mbx_regs_seg_hdr, fc1_mbx_regs);
+	FILL_SEG(ide_regs_seg_hdr, ide_regs);
+	FILL_SEG(nic1_mbx_regs_seg_hdr, nic1_mbx_regs);
+	FILL_SEG(smbus_regs_seg_hdr, smbus_regs);
+	FILL_SEG(fc2_mbx_regs_seg_hdr, fc2_mbx_regs);
+	FILL_SEG(nic2_mbx_regs_seg_hdr, nic2_mbx_regs);
+	FILL_SEG(i2c_regs_seg_hdr, i2c_regs);
+	FILL_SEG(memc_regs_seg_hdr, memc_regs);
+	FILL_SEG(pbus_regs_seg_hdr, pbus_regs);
+	FILL_SEG(mde_regs_seg_hdr, mde_regs);
+	FILL_SEG(nic_regs_seg_hdr, nic_regs);
+	FILL_SEG(nic2_regs_seg_hdr, nic2_regs);
+	FILL_SEG(xgmac1_seg_hdr, xgmac1);
+	FILL_SEG(xgmac2_seg_hdr, xgmac2);
+	FILL_SEG(code_ram_seg_hdr, code_ram);
+	FILL_SEG(memc_ram_seg_hdr, memc_ram);
+	FILL_SEG(xaui_an_hdr, serdes_xaui_an);
+	FILL_SEG(xaui_hss_pcs_hdr, serdes_xaui_hss_pcs);
+	FILL_SEG(xfi_an_hdr, serdes_xfi_an);
+	FILL_SEG(xfi_train_hdr, serdes_xfi_train);
+	FILL_SEG(xfi_hss_pcs_hdr, serdes_xfi_hss_pcs);
+	FILL_SEG(xfi_hss_tx_hdr, serdes_xfi_hss_tx);
+	FILL_SEG(xfi_hss_rx_hdr, serdes_xfi_hss_rx);
+	FILL_SEG(xfi_hss_pll_hdr, serdes_xfi_hss_pll);
+
+	err = qlge_fill_seg_(fmsg, &dump->misc_nic_seg_hdr,
+			     (u32 *)&dump->misc_nic_info);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	FILL_SEG(intr_states_seg_hdr, intr_states);
+	FILL_SEG(cam_entries_seg_hdr, cam_entries);
+	FILL_SEG(nic_routing_words_seg_hdr, nic_routing_words);
+	FILL_SEG(ets_seg_hdr, ets);
+	FILL_SEG(probe_dump_seg_hdr, probe_dump);
+	FILL_SEG(routing_reg_seg_hdr, routing_regs);
+	FILL_SEG(mac_prot_reg_seg_hdr, mac_prot_regs);
+	FILL_SEG(xaui2_an_hdr, serdes2_xaui_an);
+	FILL_SEG(xaui2_hss_pcs_hdr, serdes2_xaui_hss_pcs);
+	FILL_SEG(xfi2_an_hdr, serdes2_xfi_an);
+	FILL_SEG(xfi2_train_hdr, serdes2_xfi_train);
+	FILL_SEG(xfi2_hss_pcs_hdr, serdes2_xfi_hss_pcs);
+	FILL_SEG(xfi2_hss_tx_hdr, serdes2_xfi_hss_tx);
+	FILL_SEG(xfi2_hss_rx_hdr, serdes2_xfi_hss_rx);
+	FILL_SEG(xfi2_hss_pll_hdr, serdes2_xfi_hss_pll);
+	FILL_SEG(sem_regs_seg_hdr, sem_regs);
+
+	kvfree(dump);
+	return err;
 }
 
 static const struct devlink_health_reporter_ops qlge_reporter_ops = {
-	.name = "dummy",
+	.name = "coredump",
 	.dump = qlge_reporter_coredump,
 };
 
-- 
2.28.0

