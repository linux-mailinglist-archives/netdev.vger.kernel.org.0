Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87381FE991
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgFRDm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:42:58 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98423C06174E;
        Wed, 17 Jun 2020 20:42:56 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so3708485edm.10;
        Wed, 17 Jun 2020 20:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4iPrKirZ8NEuL1HOSPw+c5m4s1pGzr7CigXav1HJa5Y=;
        b=b1JLzXd9dlj6dtDn7Y5tShzB0YYfFAtTLBx8Ls8HIvjCrhjW25GyIl1ZHCfDRI+EPy
         baGrD3uQw9V0wDrkv5lOpkFiz/u8X2oBynIhRE1vYynCg2739zeg7VPhvu+5ZPzADWnV
         VqiLI/HIoUNmeaKAzwNXqH3xPClKV6DynxFI9LXlFIGaI1zJ4TpuvRCEmsnT+WXenYu5
         DhpN3L2mhtMHMoVAteQ3BKVtJphCO1M/q9LttZrclIMr7SUw10mWleRvcLm9oJMSaqIT
         ccvgKayDe5X4F04wJ6eZ7K+252yOAQbH47oTbus8ahlK/OMcJShEjtOe5u8YUIK9n1bW
         ItEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4iPrKirZ8NEuL1HOSPw+c5m4s1pGzr7CigXav1HJa5Y=;
        b=b97QxSJ7Xj8mzzwvtIAdxCFAK9Drxp9WCGpRiqFUw/UdSzqu4z0F0OXUgu+tg9GDcd
         XUww5kVdgkr74SXneesrkenGNvcWJ7n2QD772nGedR17NYXuTBVgNlQMU2o2PkegL33E
         qs6jrh/zxWa/AFv0AEHTQ/PRgD2LB4qKFT7+5i5tql6KvEEPxQFf0jP3BkRD4qjunsWU
         GMpnDTh6C3s42D5b5fyIQMi4w9PkB4/ebBejNfrYjLnAU0rPZGqpaa416qza2UlNqkHA
         +nqXgcZnLcsZkX/+s2ipGOHNJbaJ2eSOswjVNq4zJgfjprnTyCucT+qRoVSprW36xxpj
         r5uw==
X-Gm-Message-State: AOAM531+UkrAsW4huq3pCnBBss1UQb3GApaqmz5JUPEVUN8FSJ6YbEUq
        J/96bVtQnth02R2NS4PccWk3IKtE
X-Google-Smtp-Source: ABdhPJz862sudnoLUaC0zEq+ft0dvDJcUFfVFJzxxcFy5IGN4eWV0/8/jEc3LafEv5VuZlNymsXi/Q==
X-Received: by 2002:aa7:c752:: with SMTP id c18mr2112230eds.55.1592451774988;
        Wed, 17 Jun 2020 20:42:54 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm1321909ejp.45.2020.06.17.20.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 20:42:54 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Fix node reference count
Date:   Wed, 17 Jun 2020 20:42:44 -0700
Message-Id: <20200618034245.29928-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_find_node_by_name() will do an of_node_put() on the "from" argument.
With CONFIG_OF_DYNAMIC enabled which checks for device_node reference
counts, we would be getting a warning like this:

[    6.347230] refcount_t: increment on 0; use-after-free.
[    6.352498] WARNING: CPU: 3 PID: 77 at lib/refcount.c:156
refcount_inc_checked+0x38/0x44
[    6.360601] Modules linked in:
[    6.363661] CPU: 3 PID: 77 Comm: kworker/3:1 Tainted: G        W
5.4.46-gb78b3e9956e6 #13
[    6.372546] Hardware name: BCM97278SV (DT)
[    6.376649] Workqueue: events deferred_probe_work_func
[    6.381796] pstate: 60000005 (nZCv daif -PAN -UAO)
[    6.386595] pc : refcount_inc_checked+0x38/0x44
[    6.391133] lr : refcount_inc_checked+0x38/0x44
...
[    6.478791] Call trace:
[    6.481243]  refcount_inc_checked+0x38/0x44
[    6.485433]  kobject_get+0x3c/0x4c
[    6.488840]  of_node_get+0x24/0x34
[    6.492247]  of_irq_find_parent+0x3c/0xe0
[    6.496263]  of_irq_parse_one+0xe4/0x1d0
[    6.500191]  irq_of_parse_and_map+0x44/0x84
[    6.504381]  bcm_sf2_sw_probe+0x22c/0x844
[    6.508397]  platform_drv_probe+0x58/0xa8
[    6.512413]  really_probe+0x238/0x3fc
[    6.516081]  driver_probe_device+0x11c/0x12c
[    6.520358]  __device_attach_driver+0xa8/0x100
[    6.524808]  bus_for_each_drv+0xb4/0xd0
[    6.528650]  __device_attach+0xd0/0x164
[    6.532493]  device_initial_probe+0x24/0x30
[    6.536682]  bus_probe_device+0x38/0x98
[    6.540524]  deferred_probe_work_func+0xa8/0xd4
[    6.545061]  process_one_work+0x178/0x288
[    6.549078]  process_scheduled_works+0x44/0x48
[    6.553529]  worker_thread+0x218/0x270
[    6.557285]  kthread+0xdc/0xe4
[    6.560344]  ret_from_fork+0x10/0x18
[    6.563925] ---[ end trace 68f65caf69bb152a ]---

Fix this by adding a of_node_get() to increment the reference count
prior to the call.

Fixes: afa3b592953b ("net: dsa: bcm_sf2: Ensure correct sub-node is parsed")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index c1bd21e4b15c..9f62ba3e4345 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1154,6 +1154,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	set_bit(0, priv->cfp.used);
 	set_bit(0, priv->cfp.unique);
 
+	/* Balance of_node_put() done by of_find_node_by_name() */
+	of_node_get(dn);
 	ports = of_find_node_by_name(dn, "ports");
 	if (ports) {
 		bcm_sf2_identify_ports(priv, ports);
-- 
2.17.1

