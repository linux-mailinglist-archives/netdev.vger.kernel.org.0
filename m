Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB8171713
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgB0MYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:24:36 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39631 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728929AbgB0MYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:24:35 -0500
Received: by mail-pj1-f66.google.com with SMTP id e9so1108665pjr.4
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=y2vpz0FdIGm2WC58Vex756E7WY5gu0S9BW8+MPP8dUI=;
        b=mn3hvBjMPJFbNzBSxOz7sjBvL+WbWYZP77haZpa6/9f/saLqz5ooEA/EYxxKFQfU9l
         /q2OasHO3GOARHktE1usOkpAaxi67epOzmq9Ap+LIy+Rz0if3IkV1c1gnUN5GKsH0B5K
         WURV9LefxJSCb5y5l/aAdGzMbuLaMl8Uo14WOvHGI4Ihf83+VWEX+P/HDW1gdJW6fQZt
         82WJnleo+HwicqBgZqwXSyOJdCZfN0la3ybbzsUPd8xiUeZBibkvfBlz487WdrXTxdiY
         e7PwSCYhnpkm1Jc8c43JbfPyGXERysdL7bInNn+Gy/cwaRyer5c97VSZVvnhnDbbc5NZ
         v6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y2vpz0FdIGm2WC58Vex756E7WY5gu0S9BW8+MPP8dUI=;
        b=B/eqPYtoQeeq6ljQzkiakerHCCV1ACIoFxkzhnJBoSluYXc0q4PBpa9ynwOzprt2b6
         YLtarXZH0KKWR+72xLM4QXUpgb/PGonuew0Hl3Ss1xLKKLzSPavdmKvQsdJ7l97TS6PD
         yUGZH5fExxH1xyvplL0DIxOa6S7Ufazj1EHR4O8chDTjwgwpq5jqhm1PSC68W6bOU9vp
         yhmabceppqHLWJGFG7Te4oRgTEctfDCVkT633wYBbIr+ZJHyBGj3iuGWbvy2bXlBEASG
         Q/RcpnMZKdt87Fuz5RDzImzs2P0igADyhs00OQDq1OqAjByf7zD3MbyDtcQF/8IQknz0
         o4dQ==
X-Gm-Message-State: APjAAAWezTAgA9GGs0uTwlsJLjQ5qKx97plP74agIaxTRPbDkHfMS/8Q
        svIENJsHUazcu2b0Iip37/4=
X-Google-Smtp-Source: APXvYqyplzGfOx+JJSyRsMSJMhgSak5DWAvvEiNJYQcNWh6x1W724AVR7/mNQ4HxUmgPcxaU+pplAg==
X-Received: by 2002:a17:90a:77c3:: with SMTP id e3mr3122867pjs.143.1582806274348;
        Thu, 27 Feb 2020 04:24:34 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f8sm6864943pfn.2.2020.02.27.04.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:24:33 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 2/8] net: rmnet: fix NULL pointer dereference in rmnet_changelink()
Date:   Thu, 27 Feb 2020 12:24:26 +0000
Message-Id: <20200227122426.19090-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the rmnet_changelink(), it uses IFLA_LINK without checking
NULL pointer.
tb[IFLA_LINK] could be NULL pointer.
So, NULL-ptr-deref could occur.

rmnet already has a lower interface (real_dev).
So, after this patch, rmnet_changelink() does not use IFLA_LINK anymore.

Test commands:
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set rmnet0 type rmnet mux_id 2

Splat looks like:
[   90.578726][ T1131] general protection fault, probably for non-canonical address 0xdffffc0000000000I
[   90.581121][ T1131] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   90.582380][ T1131] CPU: 2 PID: 1131 Comm: ip Not tainted 5.6.0-rc1+ #447
[   90.584285][ T1131] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   90.587506][ T1131] RIP: 0010:rmnet_changelink+0x5a/0x8a0 [rmnet]
[   90.588546][ T1131] Code: 83 ec 20 48 c1 ea 03 80 3c 02 00 0f 85 6f 07 00 00 48 8b 5e 28 48 b8 00 00 00 00 00 0
[   90.591447][ T1131] RSP: 0018:ffff8880ce78f1b8 EFLAGS: 00010247
[   90.592329][ T1131] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff8880ce78f8b0
[   90.593253][ T1131] RDX: 0000000000000000 RSI: ffff8880ce78f4a0 RDI: 0000000000000004
[   90.594058][ T1131] RBP: ffff8880cf543e00 R08: 0000000000000002 R09: 0000000000000002
[   90.594859][ T1131] R10: ffffffffc0586a40 R11: 0000000000000000 R12: ffff8880ca47c000
[   90.595690][ T1131] R13: ffff8880ca47c000 R14: ffff8880cf545000 R15: 0000000000000000
[   90.596553][ T1131] FS:  00007f21f6c7e0c0(0000) GS:ffff8880da400000(0000) knlGS:0000000000000000
[   90.597504][ T1131] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.599418][ T1131] CR2: 0000556e413db458 CR3: 00000000c917a002 CR4: 00000000000606e0
[   90.600289][ T1131] Call Trace:
[   90.600631][ T1131]  __rtnl_newlink+0x922/0x1270
[   90.601194][ T1131]  ? lock_downgrade+0x6e0/0x6e0
[   90.601724][ T1131]  ? rtnl_link_unregister+0x220/0x220
[   90.602309][ T1131]  ? lock_acquire+0x164/0x3b0
[   90.602784][ T1131]  ? is_bpf_image_address+0xff/0x1d0
[   90.603331][ T1131]  ? rtnl_newlink+0x4c/0x90
[   90.603810][ T1131]  ? kernel_text_address+0x111/0x140
[   90.604419][ T1131]  ? __kernel_text_address+0xe/0x30
[   90.604981][ T1131]  ? unwind_get_return_address+0x5f/0xa0
[   90.605616][ T1131]  ? create_prof_cpu_mask+0x20/0x20
[   90.606304][ T1131]  ? arch_stack_walk+0x83/0xb0
[   90.606985][ T1131]  ? stack_trace_save+0x82/0xb0
[   90.607656][ T1131]  ? stack_trace_consume_entry+0x160/0x160
[   90.608503][ T1131]  ? deactivate_slab.isra.78+0x2c5/0x800
[   90.609336][ T1131]  ? kasan_unpoison_shadow+0x30/0x40
[   90.610096][ T1131]  ? kmem_cache_alloc_trace+0x135/0x350
[   90.610889][ T1131]  ? rtnl_newlink+0x4c/0x90
[   90.611512][ T1131]  rtnl_newlink+0x65/0x90
[ ... ]

Fixes: 23790ef12082 ("net: qualcomm: rmnet: Allow to configure flags for existing devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
  - update commit log.

 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 471e3b2a1403..ac58f584190b 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -300,10 +300,8 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (!dev)
 		return -ENODEV;
 
-	real_dev = __dev_get_by_index(dev_net(dev),
-				      nla_get_u32(tb[IFLA_LINK]));
-
-	if (!real_dev || !rmnet_is_real_dev_registered(real_dev))
+	real_dev = priv->real_dev;
+	if (!rmnet_is_real_dev_registered(real_dev))
 		return -ENODEV;
 
 	port = rmnet_get_port_rtnl(real_dev);
-- 
2.17.1

