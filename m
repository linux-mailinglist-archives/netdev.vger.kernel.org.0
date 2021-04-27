Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222BA36CDAE
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhD0VKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbhD0VKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 17:10:41 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81829C061574
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 14:09:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d11so2992141wrw.8
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 14:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6QAKwie4+YMz+l+t8/j6PuN2pFh1kh2lwIawUsFEkm0=;
        b=xpVWTqnvN6aMbHRIk3JPlSwzenSxIVgYwRjcTVkUdmwz+uo9nhMJ/YoHJiJONl3RmV
         IvJB48oq9Pwm09SQW6RCgCQn90Gmefq+N/VYeMBwGS/spqDGqzanzoM70IBO1iOYKA03
         D4eo8vHDkgkjxEHAsi+W/MdubPQdr/F853EOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6QAKwie4+YMz+l+t8/j6PuN2pFh1kh2lwIawUsFEkm0=;
        b=F5g9snzn0H4DBgfQnsicE3aGC+9/O6M3wN2v8IG/XcXueGAgfHlMwoTD4/nO/j0aNd
         U+lQAkQgZe8NATv15H+6xeVHlCGJYYVQjoPnS9FYXdfhJuyKvdC4mCjwhOnno1CgLrYq
         l63WrepH+vF84vS095W7J4pSMD9NyVc4rvLgUHbQ8BDa/ocR1EJMaFzTsI5vDD2VOvHy
         YZX+OWx/Fk3PbWjkpSC3NUYEqXA4ERIJOrO4bW/cT7lR3THKwAC0VHIVrGD2Zq9HTGwr
         Sw9pjyot6itvR3QOBN+bY/K2rRjLn+GWi+/x4jl5GY92NEaLy3QLfam2WDhZr9sdf8ga
         1tgw==
X-Gm-Message-State: AOAM532g2hRM4gIc0alk1gwGk4kysC/ArkCQvV/50bWS29C/ZhvGWqKO
        /CPpIDGRsH1BLhzVRO87GCttFKW0rP1HHw==
X-Google-Smtp-Source: ABdhPJxM4HHCAuooQ0nL5IHO5zP3EzCulwuWaSrWS9G146WVMKANdqwrXlo7Cn7zxPrFXghoX0VgaQ==
X-Received: by 2002:a5d:40c3:: with SMTP id b3mr16340992wrq.304.1619557796145;
        Tue, 27 Apr 2021 14:09:56 -0700 (PDT)
Received: from localhost.localdomain ([198.41.152.153])
        by smtp.gmail.com with ESMTPSA id q19sm3722715wmc.44.2021.04.27.14.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 14:09:55 -0700 (PDT)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>, kernel-team@cloudflare.com,
        stable@vger.kernel.org
Subject: [PATCH] sfc: adjust efx->xdp_tx_queue_count with the real number of initialized queues
Date:   Tue, 27 Apr 2021 22:09:38 +0100
Message-Id: <20210427210938.661700-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

efx->xdp_tx_queue_count is initially initialized to num_possible_cpus() and is
later used to allocate and traverse efx->xdp_tx_queues lookup array. However,
we may end up not initializing all the array slots with real queues during
probing. This results, for example, in a NULL pointer dereference, when running
"# ethtool -S <iface>", similar to below

[2570283.664955][T4126959] BUG: kernel NULL pointer dereference, address: 00000000000000f8
[2570283.681283][T4126959] #PF: supervisor read access in kernel mode
[2570283.695678][T4126959] #PF: error_code(0x0000) - not-present page
[2570283.710013][T4126959] PGD 0 P4D 0
[2570283.721649][T4126959] Oops: 0000 [#1] SMP PTI
[2570283.734108][T4126959] CPU: 23 PID: 4126959 Comm: ethtool Tainted: G           O      5.10.20-cloudflare-2021.3.1 #1
[2570283.752641][T4126959] Hardware name: <redacted>
[2570283.781408][T4126959] RIP: 0010:efx_ethtool_get_stats+0x2ca/0x330 [sfc]
[2570283.796073][T4126959] Code: 00 85 c0 74 39 48 8b 95 a8 0f 00 00 48 85 d2 74 2d 31 c0 eb 07 48 8b 95 a8 0f 00 00 48 63 c8 49 83 c4 08 83 c0 01 48 8b 14 ca <48> 8b 92 f8 00 00 00 49 89 54 24 f8 39 85 a0 0f 00 00 77 d7 48 8b
[2570283.831259][T4126959] RSP: 0018:ffffb79a77657ce8 EFLAGS: 00010202
[2570283.845121][T4126959] RAX: 0000000000000019 RBX: ffffb799cd0c9280 RCX: 0000000000000018
[2570283.860872][T4126959] RDX: 0000000000000000 RSI: ffff96dd970ce000 RDI: 0000000000000005
[2570283.876525][T4126959] RBP: ffff96dd86f0a000 R08: ffff96dd970ce480 R09: 000000000000005f
[2570283.892014][T4126959] R10: ffffb799cd0c9fff R11: ffffb799cd0c9000 R12: ffffb799cd0c94f8
[2570283.907406][T4126959] R13: ffffffffc11b1090 R14: ffff96dd970ce000 R15: ffffffffc11cd66c
[2570283.922705][T4126959] FS:  00007fa7723f8740(0000) GS:ffff96f51fac0000(0000) knlGS:0000000000000000
[2570283.938848][T4126959] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2570283.952524][T4126959] CR2: 00000000000000f8 CR3: 0000001a73e6e006 CR4: 00000000007706e0
[2570283.967529][T4126959] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[2570283.982400][T4126959] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[2570283.997308][T4126959] PKRU: 55555554
[2570284.007649][T4126959] Call Trace:
[2570284.017598][T4126959]  dev_ethtool+0x1832/0x2830

Fix this by adjusting efx->xdp_tx_queue_count after probing to reflect the true
value of initialized slots in efx->xdp_tx_queues.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Fixes: e26ca4b53582 ("sfc: reduce the number of requested xdp ev queues")
Cc: <stable@vger.kernel.org> # 5.12.x
---
 drivers/net/ethernet/sfc/efx_channels.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 1bfeee283ea9..a3ca406a3561 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -914,6 +914,8 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
+	if (xdp_queue_number)
+		efx->xdp_tx_queue_count = xdp_queue_number;
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.20.1

