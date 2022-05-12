Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7872A524521
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349959AbiELFrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiELFrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:47:19 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CFC32042
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:47:18 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id bo5so3859059pfb.4
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ZrRyE9N8aoR2d7o64w8aZQ60Jvh9jnadBRwPjg4JMms=;
        b=dTEuNQqAV+bnnDr2nwanA3WB7aMSZIPJQ/TuuHZuMiTQbiGThjPOkFmcZ5T9+Mh4O9
         F9fk/yTZmfhw89n0L/XLecp7BFJ2RJ6h1ojvJruYbs5xVv6i500U+81rJnr2Bg+zuSRJ
         qbvpgdL61Zo2233sSXDZDiMDIe/vPUZxtlM9tr/xqo3EA9N9URt+izesyjKetkncD9qW
         fK7g5BtvL2VZnaZA1SwjoP3swJ5dfg6BNEAiqLHDEED3I5pkaZW+OEAD/z7RwrLdx1NR
         08U0+6otxB5+s+7ggFs8FM7kvAjo6MQVh3d//an+JH4L/vXkeOTKfaNoRmrWHQ4KoIgE
         AWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZrRyE9N8aoR2d7o64w8aZQ60Jvh9jnadBRwPjg4JMms=;
        b=sGnaFeeD0c7sdZQfZAPhPfLIx8LONvHcRixW9XxImR0f2qh9TcOH6BHe2SLxWErG5/
         dvnI8jm17zA+72ki5BeXY2MxfThD41va49IiTSmOX/gDoTVRESykoLeVScrO3/zb2QKj
         uajhyNujY/xyOKyIqC3J3xXSP01umgyHPTNJYXrFFEAgnRypwerVa6AlpF8qGKOjZiF0
         pRaxlIZq0vb9PVIlZPUd+uGSvwYzncwMERfZi6V2A2SlyshK7E3iZtH38eUOCkgIubO0
         i6rG9x+3fHWsskdy8/QVvyWo8enG6oUwrxlZbqCpnO0BRDoXdQOsTl4zz3buhQKbEnfv
         KrcQ==
X-Gm-Message-State: AOAM530NtnPAqdLJ6BPYHbcZXh7nvzBqPV6h9JobiHCspocu7USFchbb
        jALbHf09tdZz5ok6vtVYftD+LuMRKD0=
X-Google-Smtp-Source: ABdhPJxFTuNV9GlwRvLvw2QyKXUydS6Jwd9pvYxgR+8DysCvidsLjeVSJ7DJQN6aHv6RguY2C5b45Q==
X-Received: by 2002:a05:6a00:198f:b0:50d:bf61:3de9 with SMTP id d15-20020a056a00198f00b0050dbf613de9mr28628073pfl.16.1652334437963;
        Wed, 11 May 2022 22:47:17 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id g185-20020a636bc2000000b003c14af505fesm917796pgc.22.2022.05.11.22.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 22:47:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2] net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()
Date:   Thu, 12 May 2022 05:47:09 +0000
Message-Id: <20220512054709.12513-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the NIC ->probe() callback, ->mtd_probe() callback is called.
If NIC has 2 ports, ->probe() is called twice and ->mtd_probe() too.
In the ->mtd_probe(), which is efx_ef10_mtd_probe() it allocates and
initializes mtd partiion.
But mtd partition for sfc is shared data.
So that allocated mtd partition data from last called
efx_ef10_mtd_probe() will not be used.
Therefore it must be freed.
But it doesn't free a not used mtd partition data in efx_ef10_mtd_probe().

kmemleak reports:
unreferenced object 0xffff88811ddb0000 (size 63168):
  comm "systemd-udevd", pid 265, jiffies 4294681048 (age 348.586s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffffa3767749>] kmalloc_order_trace+0x19/0x120
    [<ffffffffa3873f0e>] __kmalloc+0x20e/0x250
    [<ffffffffc041389f>] efx_ef10_mtd_probe+0x11f/0x270 [sfc]
    [<ffffffffc0484c8a>] efx_pci_probe.cold.17+0x3df/0x53d [sfc]
    [<ffffffffa414192c>] local_pci_probe+0xdc/0x170
    [<ffffffffa4145df5>] pci_device_probe+0x235/0x680
    [<ffffffffa443dd52>] really_probe+0x1c2/0x8f0
    [<ffffffffa443e72b>] __driver_probe_device+0x2ab/0x460
    [<ffffffffa443e92a>] driver_probe_device+0x4a/0x120
    [<ffffffffa443f2ae>] __driver_attach+0x16e/0x320
    [<ffffffffa4437a90>] bus_for_each_dev+0x110/0x190
    [<ffffffffa443b75e>] bus_add_driver+0x39e/0x560
    [<ffffffffa4440b1e>] driver_register+0x18e/0x310
    [<ffffffffc02e2055>] 0xffffffffc02e2055
    [<ffffffffa3001af3>] do_one_initcall+0xc3/0x450
    [<ffffffffa33ca574>] do_init_module+0x1b4/0x700

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Fixes: 8127d661e77f ("sfc: Add support for Solarflare SFC9100 family")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Remove unnecessary cover letter.
 - Drop unnecessary second patch.
 - Add Acked tag.

 drivers/net/ethernet/sfc/ef10.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 50d535981a35..f8edb3f1b73a 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3579,6 +3579,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 		n_parts++;
 	}
 
+	if (!n_parts) {
+		kfree(parts);
+		return 0;
+	}
+
 	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
 fail:
 	if (rc)
-- 
2.17.1

