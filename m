Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB6E2CD838
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgLCNvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728877AbgLCNvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:51:48 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B96C061A54
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 05:50:55 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k4so2179490edl.0
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=32wijpVRZam48n6WcEbTQm6X2gRK0yzC2hG6Y0Y2+Lk=;
        b=Y8z/8EuFA6ejo6uNXN3hvgjf2bBiWOtpkVqtVbJc39AD0hDdwCfH7jMRp0Fqviek6h
         vzoeCESVCdFOLPy01jeD5p3DY2c7O7hvTDdciTZNvNTLnu+Z296xanf6RLanEfDF8a/0
         Y2xXyJPGoOsQHcUYyvelkmMu5Xnsyott645gcYSbEILzmnOxCYQclATF4tm4k8LPgpLE
         Dfuo5mjL9/dN7rNxpUuURAUIKJYARMYl8XJEQu681tZ2PlKQCof4/AcC7n7xUjMW88nW
         Mc9bL/oaRgFotODx9ppFbGNV/34SIE87WOGwAluESGyCfL0kD7hUYCseosyvp/V6J7LK
         WoSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=32wijpVRZam48n6WcEbTQm6X2gRK0yzC2hG6Y0Y2+Lk=;
        b=JDTIyOGKNOgXahSJWivbvj4/cOa+fp7YV6pa5sZcx7UyuEC8SHlFFXF07jUiyUAbxj
         anL37c1+lUwyf4gd/ZFwco9bCl0G1phpR74CVjVzsbJHE22eeL/SqK1T+3CqwGDO/+cH
         6k1m/U54CkPhDXOeEfZ06r7V98CHYgV1rdzC7NZUDrCgBLExV056OZifFuQvagyaOZbl
         yLPkvk/0FArQeuxNH8yGhRP6k3VfV9FaT9GrjvPIYjmYFwznZvzXey5qo03Y8Wz9akh8
         xIFzNH7v6Rr88ItSQWkFR3xpe7h2siTfELkpl4KJuUNUBgbtAToMC61qbDFYp4GP5E0G
         5sJQ==
X-Gm-Message-State: AOAM531yl7f3WRjeZ4mWNmDQLu/0+FIfWOfjAnrptWuNLe83x+kExBzA
        7w0zNP1xkU9Kq0MSYy5lfVYqYQ==
X-Google-Smtp-Source: ABdhPJxK7ivMeqHmdO88xAdb7S2f1m58nWZyi58XtU2CWRWbeB6CiptUNSInd2qvBfrMu6IC5Ar5Lg==
X-Received: by 2002:a05:6402:17ad:: with SMTP id j13mr2937991edy.347.1607003453896;
        Thu, 03 Dec 2020 05:50:53 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id t19sm903192eje.86.2020.12.03.05.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:50:53 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH net 2/4] net: freescale/fman-port: remove direct use of __devm_request_region
Date:   Thu,  3 Dec 2020 14:50:37 +0100
Message-Id: <20201203135039.31474-3-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203135039.31474-1-patrick.havelange@essensium.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
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

