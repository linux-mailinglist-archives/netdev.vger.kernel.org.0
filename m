Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA7906831C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 07:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfGOFKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 01:10:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42931 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfGOFKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 01:10:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so7663310plb.9
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 22:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OeCHboNn9AfT2zO6G7OIkyXIT6KSrckY2cpEmyCv3zo=;
        b=hD8L0k0dweu7fnfOzcI+FQDYRH9NOmYboJKF5soN9Gadp1ukj/Nh6tjTieGHKEnQcd
         hE/njT2baiqpc7SzDbU1mdz689Lxt/I+Bc2xP5i/0mWYJTYbIceF3QZtJpgikFXAIEVH
         6sn95KjHb2xX7ObHmX3vvBfCA98ijemp58vaBc3V4zGCFVqR3izPSNQ+/LTyg07qXdqx
         qk5oC+aT9V3oABbVYoz5ktMMJ2Gn/M8z+TNvRzFYTllmSZXWdIuNpzeDFXioNCtJ4a/t
         WaaoH8z/6gPhWaKYXPTYmvqxs6Z8giAEaOcO3dbJk8wPP+CmLiu9qoHgwFYNJuhGg+60
         lrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OeCHboNn9AfT2zO6G7OIkyXIT6KSrckY2cpEmyCv3zo=;
        b=S54t9DxIsQPCYZDMt6Ff2xSY7ZkENs1MrIOJ75vVL2Ex8ReYdJGhCfOPr0dx+M3JR9
         hzUZdOFt3Hvv+dIqWwYPxRr80lLfnQ3nxRZHr8osNPXnvchAUSH1qYfM5ZkyVyD5n2aQ
         tnOxiJa154Mo1bhgtMUnJnfV6iVa5VbRgduA6XmubLWGxPHiOFdZOBRps4gGeVkEGICN
         yvEUSrRRvaV7+PfTexgdhe+Y5SpLUajvcpqZYgCqHrpNhtR4fmnXmr9Ia4sLv/GBCpwJ
         losA5qEsxwb+1rylpuuHCUbZFSqp+cpJ0pMHgx3NaxWCjy+kL2erEKTlJake3hln3T9T
         4CEw==
X-Gm-Message-State: APjAAAWGQEjPUo6UsnSLfMmw/SwufhIMXb1SBDbwupHMM708vxpYmrqg
        bE4IoimQ3R31fwSsUlJkIfM=
X-Google-Smtp-Source: APXvYqzQKM6dn/3hjnevMOoQ2MAV1c8Fnm9ywvPX0BXCSW2yA3ObRoL/srtjmkAV4MdQeoTMNKDGJg==
X-Received: by 2002:a17:902:aa5:: with SMTP id 34mr27219680plp.166.1563167424179;
        Sun, 14 Jul 2019 22:10:24 -0700 (PDT)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id br18sm13861559pjb.20.2019.07.14.22.10.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 14 Jul 2019 22:10:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] caif-hsi: fix possible deadlock in cfhsi_exit_module()
Date:   Mon, 15 Jul 2019 14:10:17 +0900
Message-Id: <20190715051017.7514-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cfhsi_exit_module() calls unregister_netdev() under rtnl_lock().
but unregister_netdev() internally calls rtnl_lock().
So deadlock would occur.

Fixes: c41254006377 ("caif-hsi: Add rtnl support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
I did only compile test because I don't have the testbed.
Could anyone test this patch?
 drivers/net/caif/caif_hsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_hsi.c b/drivers/net/caif/caif_hsi.c
index b2f10b6ad6e5..bbb2575d4728 100644
--- a/drivers/net/caif/caif_hsi.c
+++ b/drivers/net/caif/caif_hsi.c
@@ -1455,7 +1455,7 @@ static void __exit cfhsi_exit_module(void)
 	rtnl_lock();
 	list_for_each_safe(list_node, n, &cfhsi_list) {
 		cfhsi = list_entry(list_node, struct cfhsi, list);
-		unregister_netdev(cfhsi->ndev);
+		unregister_netdevice(cfhsi->ndev);
 	}
 	rtnl_unlock();
 }
-- 
2.17.1

