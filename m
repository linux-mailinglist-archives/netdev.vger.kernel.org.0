Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E61521F29
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346044AbiEJPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346600AbiEJPlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:41:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2678155496
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:37:40 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i17so17066585pla.10
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ewTyoQ/+iWcmU29RnsXrYQ82QNVfKCcVgsgraxTWcKE=;
        b=h04ZXlDCMnt6RheYKPEtONChHBfn6N7dpe0/0Jtlr0RrzrkMrZN7GTXuNLO/QA4Imx
         7hS7fUx4c/7f0oLmc47fvNdL4aYX5NsB93gSkibYYG/6sTd6Iabj1FxUplw4vs6RoxCF
         uBuB97F+pd9K7rybjSphigst5K8iUsSmVW+tSVkdSeq//xkyUJV4XEIKdr8Tsb6AuqZG
         SRJ4E5TDHVkXNu5NHu5hMtfk1w+oOY9ryZbbudVdgBmyVQLCfTOjqHo28DeCL/FJuAWg
         DVhPPmOB5ebtECPZmpllVbhMAQscWbNFNio9PHoREfofH0croD4ecxfYY5AOvzkBzC1s
         qwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ewTyoQ/+iWcmU29RnsXrYQ82QNVfKCcVgsgraxTWcKE=;
        b=ejhFAayeZTSZkqrqOQaNiZ7W9tMRXn8EWcDGezx+1c0VHgdqdL+dYtQqPOejlVxTti
         rGa56xjm49e8j9h8M+vkdWZkdNtCkAB1iVNfWTrd4R8Vp8GmskosB5P8ZOOp6ildryoQ
         gNkAxxv4+im6JliHfvpAug1wr+fW7oJAcjZIHlykMFIoV1zw3+Qhth0nQtvoPiDSgn53
         NnfF/Zd2jDBLu3xEnCKcrD4vEE8E71AvaYls0252WAZU8HXLhhZF4XzVwx6Drmee0ZZA
         1TYZ+yg88h4hrGtBO5qTrsCrRNDMR5vT4wDZcwzZp+WIik8OTWxLwEayVEr9dAKXfIyR
         GYEQ==
X-Gm-Message-State: AOAM531LKd7ragUncxIILoGmJPY209Gsuv3h76tQ4Cy8vTS0UzeROrwz
        7qW+kRupCowamzYZOgUUApm7RNxlVQU=
X-Google-Smtp-Source: ABdhPJya98FPP3tInt8yvPqEXagO72f2Nzv2M7b/r4ymM6p/VK8iRR17PFHZSgx5pcMwBhfkzztUkQ==
X-Received: by 2002:a17:902:d717:b0:15e:b6ed:4824 with SMTP id w23-20020a170902d71700b0015eb6ed4824mr21070314ply.110.1652197059627;
        Tue, 10 May 2022 08:37:39 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id bi10-20020a170902bf0a00b0015e8d4eb1fcsm2211308plb.70.2022.05.10.08.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:37:38 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/2] net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()
Date:   Tue, 10 May 2022 15:36:18 +0000
Message-Id: <20220510153619.32464-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220510153619.32464-1-ap420073@gmail.com>
References: <20220510153619.32464-1-ap420073@gmail.com>
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

Fixes: 8127d661e77f ("sfc: Add support for Solarflare SFC9100 family")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
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

