Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8582CC1F0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389057AbgLBQRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgLBQRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:17:05 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD99AC0617A6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 08:16:18 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id s8so4591882wrw.10
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=32wijpVRZam48n6WcEbTQm6X2gRK0yzC2hG6Y0Y2+Lk=;
        b=PlyX+bAbaCJ+ViZ3xFGoPUhiuB+2K2BHJQpYjSn9xuCgAlXPdGx9ck4kZMLiKNqYPw
         4YOSSXkVExGyKM71Um3KGpNbXs0B7shbuN5VRCT349Vd89LzeWx78sobdQxuea2b3LDY
         lIO2LXf0l1cgInR6lZnW/HDihBMsku+m/dB+0DLs3Lo1Nn5cyCkOVOs4cOo7zWiAfYYm
         J+tArr0vo9cKRrLuI+5D/rEA7Q7rPFtx+ENisJL+tn0YEit3M+xHE8NXY9VVkzWDbMbP
         O3ZjN7YhhUX9o2b04DH+eiMt6fix3aRcHgtU7miug3d1EF/lCG8mc5YDQZF2V3ufGBS1
         aXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=32wijpVRZam48n6WcEbTQm6X2gRK0yzC2hG6Y0Y2+Lk=;
        b=Ktf8ZulfHzRjPvRY+ASSWgKCX38pNmEDi185aDjEC4dFdyKmAJBVQmoIpPrjY2oosL
         oysnPwrtbiokTX/Mn13pQVS8/n8jxW1seBpg8x41LHGktI5n0NRhfeHgTdj/lrWM+m3Z
         msaO99/3Zx2U9PnueX/d6rXgij4YH1WGGUpNmNA/hTqu0EnHOBcnbo3VL6oAXMIkeFFA
         CmNfvCGEq/cbHcbXiynsSUpQSnj2IqKizh64fbvEiIROHsBy/DjQCRLD1KBw9Rl8HALK
         /KCVqbwOJnddBbB/FLIGa9dYgPbeaUXKjpCHJymX8pKJj91XPOLs+WBHKTjjjsbH8+xh
         rUaA==
X-Gm-Message-State: AOAM530zqKpQBc6fEQE7s0EmykNffINzXB9zUaggGdHuU5Y07o/W8p9k
        vCUV01iQd70fJ4BWHULZNeBhGw==
X-Google-Smtp-Source: ABdhPJxE5Lx04xyZanZUDA81AWi0NhR2YFRrdwcY6RR+G2YIKZDWA9D5NJ+ziv0L9zugYHw5s6vs0Q==
X-Received: by 2002:adf:eb91:: with SMTP id t17mr4358566wrn.330.1606925777480;
        Wed, 02 Dec 2020 08:16:17 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id s4sm2644505wru.56.2020.12.02.08.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 08:16:16 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH 2/4] net: freescale/fman-port: remove direct use of __devm_request_region
Date:   Wed,  2 Dec 2020 17:15:58 +0100
Message-Id: <20201202161600.23738-2-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202161600.23738-1-patrick.havelange@essensium.com>
References: <20201202161600.23738-1-patrick.havelange@essensium.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was directly calling __devm_request_region with a specific
resource on the stack as parameter. This is invalid as
__devm_request_region expects the given resource passed as parameter
to live longer than the call itself, as the pointer to the resource
will be stored inside the internal struct used by the devres
management.

In addition to this issue, a related bug has been found by kmemleak
with this trace :
unreferenced object 0xc0000001efc01880 (size 64):
  comm "swapper/0", pid 1, jiffies 4294669078 (age 3620.536s)
  hex dump (first 32 bytes):
    00 00 00 0f fe 4a c0 00 00 00 00 0f fe 4a cf ff  .....J.......J..
    c0 00 00 00 00 ee 9d 98 00 00 00 00 80 00 02 00  ................
  backtrace:
    [<c000000000078874>] .alloc_resource+0xb8/0xe0
    [<c000000000079b50>] .__request_region+0x70/0x1c4
    [<c00000000007a010>] .__devm_request_region+0x8c/0x138
    [<c0000000006e0dc8>] .fman_port_probe+0x170/0x420
    [<c0000000005cecb8>] .platform_drv_probe+0x84/0x108
    [<c0000000005cc620>] .driver_probe_device+0x2c4/0x394
    [<c0000000005cc814>] .__driver_attach+0x124/0x128
    [<c0000000005c9ad4>] .bus_for_each_dev+0xb4/0x110
    [<c0000000005cca1c>] .driver_attach+0x34/0x4c
    [<c0000000005ca9b0>] .bus_add_driver+0x264/0x2a4
    [<c0000000005cd9e0>] .driver_register+0x94/0x160
    [<c0000000005cfea4>] .__platform_driver_register+0x60/0x7c
    [<c000000000f86a00>] .fman_port_load+0x28/0x64
    [<c000000000f4106c>] .do_one_initcall+0xd4/0x1a8
    [<c000000000f412fc>] .kernel_init_freeable+0x1bc/0x2a4
    [<c00000000000180c>] .kernel_init+0x24/0x138

Indeed, the new resource (created in __request_region) will be linked
to the given resource living on the stack, which will end its lifetime
after the function calling __devm_request_region has finished.
Meaning the new resource allocated is no longer reachable.

Now that the main fman driver is no longer reserving the region
used by fman-port, this previous hack is no longer needed
and we can use the regular call to devm_request_mem_region instead,
solving those bugs at the same time.

Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index d9baac0dbc7d..354974939d9d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1878,10 +1878,10 @@ static int fman_port_probe(struct platform_device *of_dev)
 
 	of_node_put(port_node);
 
-	dev_res = __devm_request_region(port->dev, &res, res.start,
-					resource_size(&res), "fman-port");
+	dev_res = devm_request_mem_region(port->dev, res.start,
+					  resource_size(&res), "fman-port");
 	if (!dev_res) {
-		dev_err(port->dev, "%s: __devm_request_region() failed\n",
+		dev_err(port->dev, "%s: devm_request_mem_region() failed\n",
 			__func__);
 		err = -EINVAL;
 		goto free_port;
-- 
2.17.1

