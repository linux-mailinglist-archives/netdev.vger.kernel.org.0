Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170183014B0
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 11:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbhAWKsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 05:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbhAWKro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 05:47:44 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1463C06178B;
        Sat, 23 Jan 2021 02:47:01 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x18so4739479pln.6;
        Sat, 23 Jan 2021 02:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GfTNa5bwFQCNMV4FpKX6IjAm7o6KaTkwbSExiVZKe64=;
        b=hOEc0L13E1k80oI2SDLn4Dmi+U9Cg58TC4Sb7mhhiNjpVAnUNMj1a9VpxpfMiOLGR/
         QN1AAxyaDN3B/bB1B567wEttjIF+oo7+j81C0EjEySr9H5/Ph6EPopeK1ug3ldLs6iDa
         NQ3kTgwNupC2clrWkEXBH2/MI+IqEcHpdBcQlztBllrR26Pzd0lYjZVXCDrsc2qUrR3I
         hGRatA3Ru0ae7Q+d8G5xRdi+jEce+05MGXZkmPAh6z1M1b3MB2Lb0mbP9cv/AcykbagX
         zFYMkf+a8eqIH57pBeqwZYZyr9NNzapW+5GOA5efSz5sRn+yJxhxJkRadCyK6RM2tMYA
         y5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GfTNa5bwFQCNMV4FpKX6IjAm7o6KaTkwbSExiVZKe64=;
        b=j+vPXPrPLDzZY3g9/mcpGsIREzYiROhLbxtC38h+ca2izBdybE2s7UAXpq4netvgoJ
         41ZyIVsdzsmiD7PBvZW93Irnka6LFrJ+XubrY4y28C+5wtfUURXUpI7GUdKPYtf9+LYm
         pgyE0IvcfmRlztiRa4ItnlP7FV3LlwWy4MOYl6ns0KBVk1Kc/NnySBNdC5jRGrl1AExX
         NTyU4vUNgqUvKrdNBE7PTLddlCmfB3DTFEHSgK3bpwk+l7O9um8cWL7+xmS9z//hVnpU
         qFJE3hGsLEkAgbvmxyycfen00FNA9zkNttw7r8svIcy68gC+MAHCTBY209OftfKc7unv
         rZGQ==
X-Gm-Message-State: AOAM532rGaTlEE75mqSK4+Tk8f8NUsFFFFjuPBMolKDWxksjFd89niM9
        Qm8eBpXJrELqY/W4+PuwT2Q=
X-Google-Smtp-Source: ABdhPJxqxkcJh2DkL0rpJVZIrP6cBGPsc0DW1bEgJ9Qyr9pOZghnV/h2M0YjxSZ7tXJs4H5ZosegNA==
X-Received: by 2002:a17:90a:4a0e:: with SMTP id e14mr4620600pjh.200.1611398821647;
        Sat, 23 Jan 2021 02:47:01 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id i9sm1360134pfo.146.2021.01.23.02.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 02:47:01 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com, Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 5/8] staging: qlge: support force_coredump option for devlink health dump
Date:   Sat, 23 Jan 2021 18:46:10 +0800
Message-Id: <20210123104613.38359-6-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123104613.38359-1-coiby.xu@gmail.com>
References: <20210123104613.38359-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With force_coredump module parameter set, devlink health dump will
reset the MPI RISC first which takes 5 secs to be finished.

Note that only NIC function that owns the firmware can do the
force_dumping. Otherwise devlink will receive an EPERM error.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_devlink.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index bf7d75ed5eae..c6ef5163e241 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -56,10 +56,23 @@ static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
 
 	struct qlge_adapter *qdev = devlink_health_reporter_priv(reporter);
 	struct qlge_mpi_coredump *dump;
+	wait_queue_head_t wait;
 
 	if (!netif_running(qdev->ndev))
 		return 0;
 
+	if (test_bit(QL_FRC_COREDUMP, &qdev->flags)) {
+		if (qlge_own_firmware(qdev)) {
+			qlge_queue_fw_error(qdev);
+			init_waitqueue_head(&wait);
+			wait_event_timeout(wait, 0, 5 * HZ);
+		} else {
+			netif_err(qdev, ifup, qdev->ndev,
+				  "Force Coredump failed because this NIC function doesn't own the firmware\n");
+			return -EPERM;
+		}
+	}
+
 	dump = kvmalloc(sizeof(*dump), GFP_KERNEL);
 	if (!dump)
 		return -ENOMEM;
-- 
2.29.2

