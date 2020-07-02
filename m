Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9DA212ADF
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgGBRJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbgGBRJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:09:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54FBC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:09:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id l6so9615265pjq.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mmOEg3ME21xgBq7SNfmB4cbHt34rvtrguho041gtfA0=;
        b=UzvYDLPSB0ZQBlFgWynRkb1E8fVr02u98YcMiSRQ/6UDScpAxljQz8ipkQamnl/VOz
         CGwS0Ag0jKe/NuBBF2tv2dTR5onASMnRLMpf7IeWwDExziMt0rgWbyCUwiZJfgJCZfYC
         5QauBA2hGrM/p0JIr9Al2trzJLjksumcMOQKX7IMsS+OABUjF7xQVmCPEeH4YMgSNVSI
         l5Aytbo3AAzdTP3lznwCPpIH0X7inLkuqICj1Ub0F9FvtLxFRJzPWb9aEwyINmuoWvYa
         +jVsppEnkGn5FUt2QL/T86BLds6DafgKcnyvQS3p0Tnhj8kXP09RcuTQKZzpYEcIYmHs
         Wr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mmOEg3ME21xgBq7SNfmB4cbHt34rvtrguho041gtfA0=;
        b=YpaxqLRT9UF4agP3+fQpQDRMe/Uh5MdrcRhT5G6ScewE9F7QJZ1LJaJz+7JFwCmtOQ
         gH75xoZwgRltVSG8lQl0yVi9dJPN20jxspuNxLDa12shyMRCQLUXgHAq85UvihxlzwfP
         wlkGEWszrSDrHhEiZuGM9YRHabEbLu75j7SMfO9mkClMPVcI4Wnk8neqv+9ijkya8yKF
         YkEZot1cJ8KAzExmx0jC3yQVLaVVvrvkdGnTKPhCZLt8kieiY+33SOmx8c6JMK3PvSZY
         SXEUQWKaJXnjGMXqRVpUiCygt7f3CCX1CrOvYKMESmwjqUG84AZ510nn3s6GfvKjhq2T
         ADXQ==
X-Gm-Message-State: AOAM531k+vjzIO2EftUSA6HPcDVqbAIwfesvJdnGzhGUMxRfZFMzoB7e
        JJlzJqIwebPn9kfgbHvWdCE=
X-Google-Smtp-Source: ABdhPJzhoeNf873AEza3XCCZtgwsY6GtC95UEf6nCPjcmdZn7BZeVU48CSkTHdg5lgSpgFteVOIe7Q==
X-Received: by 2002:a17:902:8a8f:: with SMTP id p15mr27480897plo.172.1593709742409;
        Thu, 02 Jul 2020 10:09:02 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id o8sm8824118pgb.23.2020.07.02.10.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:09:01 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/2] net: rmnet: do not allow to add multiple bridge interfaces
Date:   Thu,  2 Jul 2020 17:08:55 +0000
Message-Id: <20200702170855.10639-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rmnet can have only two bridge interface.
One of them is a link interface and another one is added by
the master operation.
rmnet interface shouldn't allow adding additional
bridge interfaces by mater operation.
But, there is no code to deny additional interfaces.
So, interface leak occurs.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add dummy2 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set dummy1 master rmnet0
    ip link set dummy2 master rmnet0
    ip link del rmnet0

In the above test command, the dummy0 was attached to rmnet as VND mode.
Then, dummy1 was attached to rmnet0 as BRIDGE mode.
At this point, dummy0 mode is switched from VND to BRIDGE automatically.
Then, dummy2 is attached to rmnet as BRIDGE mode.
At this point, rmnet0 should deny this operation.
But, rmnet0 doesn't deny this.
So that below splat occurs when the rmnet0 interface is deleted.

Splat looks like:
[  186.684787][    C2] WARNING: CPU: 2 PID: 1009 at net/core/dev.c:8992 rollback_registered_many+0x986/0xcf0
[  186.684788][    C2] Modules linked in: rmnet dummy openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_x
[  186.684805][    C2] CPU: 2 PID: 1009 Comm: ip Not tainted 5.8.0-rc1+ #621
[  186.684807][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  186.684808][    C2] RIP: 0010:rollback_registered_many+0x986/0xcf0
[  186.684811][    C2] Code: 41 8b 4e cc 45 31 c0 31 d2 4c 89 ee 48 89 df e8 e0 47 ff ff 85 c0 0f 84 cd fc ff ff 5
[  186.684812][    C2] RSP: 0018:ffff8880cd9472e0 EFLAGS: 00010287
[  186.684815][    C2] RAX: ffff8880cc56da58 RBX: ffff8880ab21c000 RCX: ffffffff9329d323
[  186.684816][    C2] RDX: 1ffffffff2be6410 RSI: 0000000000000008 RDI: ffffffff95f32080
[  186.684818][    C2] RBP: dffffc0000000000 R08: fffffbfff2be6411 R09: fffffbfff2be6411
[  186.684819][    C2] R10: ffffffff95f32087 R11: 0000000000000001 R12: ffff8880cd947480
[  186.684820][    C2] R13: ffff8880ab21c0b8 R14: ffff8880cd947400 R15: ffff8880cdf10640
[  186.684822][    C2] FS:  00007f00843890c0(0000) GS:ffff8880d4e00000(0000) knlGS:0000000000000000
[  186.684823][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  186.684825][    C2] CR2: 000055b8ab1077b8 CR3: 00000000ab612006 CR4: 00000000000606e0
[  186.684826][    C2] Call Trace:
[  186.684827][    C2]  ? lockdep_hardirqs_on_prepare+0x379/0x540
[  186.684829][    C2]  ? netif_set_real_num_tx_queues+0x780/0x780
[  186.684830][    C2]  ? rmnet_unregister_real_device+0x56/0x90 [rmnet]
[  186.684831][    C2]  ? __kasan_slab_free+0x126/0x150
[  186.684832][    C2]  ? kfree+0xdc/0x320
[  186.684834][    C2]  ? rmnet_unregister_real_device+0x56/0x90 [rmnet]
[  186.684835][    C2]  unregister_netdevice_many.part.135+0x13/0x1b0
[  186.684836][    C2]  rtnl_delete_link+0xbc/0x100
[ ... ]
[  238.440071][ T1009] unregister_netdevice: waiting for rmnet0 to become free. Usage count = 1

Fixes: 037f9cdf72fb ("net: rmnet: use upper/lower device infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 2c8c252b7b97..fcdecddb2812 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -429,6 +429,11 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 		return -EINVAL;
 	}
 
+	if (port->rmnet_mode != RMNET_EPMODE_VND) {
+		NL_SET_ERR_MSG_MOD(extack, "more than one bridge dev attached");
+		return -EINVAL;
+	}
+
 	if (rmnet_is_real_dev_registered(slave_dev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "slave cannot be another rmnet dev");
-- 
2.17.1

