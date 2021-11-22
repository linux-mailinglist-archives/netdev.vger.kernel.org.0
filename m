Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8EA459617
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 21:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhKVUgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 15:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhKVUgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 15:36:03 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645D9C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 12:32:56 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id b12so34952238wrh.4
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 12:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tA/w0P7EDVI0o67aNu96EyftiP/uK83rmcrhVqJn2ws=;
        b=3LL6WUePAmkHMnZjWqWe/VfGSlbcM5+IVOsobQ64nN+yK36r+xt7G4KOHHtcc8zozy
         3yxXYzJNVQJQWYu3gsx65vt/LDIRiyPPSHmrlVDNEF/emgYAhnkuYUvdoIDdxTjTnpgQ
         b9KweXAl/I9MSp/jRNag3m8F9oj3Gop1RHsxtzrcpGFb0N/Qu8PS6vVMKfLIofQcOha6
         gow66WKn5K6nTVuN6rU0aAjZvYJwkOVk945a4hry/s6PdrVL6mYctucjZ4m2+LLvDkCv
         Zm1PfeHjTYm8gOHR6KtQFNLkly6sa59mlh+g66EQrofhbAiMdvIoBptSoue7uhwgccO8
         Sfjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tA/w0P7EDVI0o67aNu96EyftiP/uK83rmcrhVqJn2ws=;
        b=i2TwAvceaSN8GgPQ9OOUkFLndIk6iwuh8VZOzozPFtSgt2xuC8qJcb5yhT4xy3vMVU
         Z72a/OycD8WlCxugAlptFUibQi1P74R1ZVWhsqNbmbriqWo0cf97bh/eLjIJoN8oSV6f
         mkm7S/+/gMaNnuy98uLkhf+n5Ne3XnDOhyrBT2tifiz6kikbjvh8M87h4TM/frB/iSA7
         VI7j+HR9w0hF+x+V68iMjxnFaXN+HgXOD3zR1PtBG5XTjG0UtNdcgWOLt1N89FxplT2S
         fPnos9O+mzFyKUi+6UiGgYh2bP+jRQAWMB0eHpfliGNSzD+oXhWfrGEdFDAUfX7Lt8U8
         z7cA==
X-Gm-Message-State: AOAM533KDCAc81GTPeUoTG0MrDF2fh0dTvXj3f7a+cnu8yan1ONrCxIU
        KwI3aIoN+B/VP9Z/liqpR/za/TfChve5JGKbgIU=
X-Google-Smtp-Source: ABdhPJzsuLSur8vqLW9191SogHVNY96wcqny6nRL/ZjwBvQA8yZ9NlS478oiwMlYUOsGcMO7TfyVwQ==
X-Received: by 2002:adf:a1d4:: with SMTP id v20mr43080856wrv.190.1637613174931;
        Mon, 22 Nov 2021 12:32:54 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id bg12sm9874453wmb.5.2021.11.22.12.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 12:32:54 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next] tsnep: Fix set MAC address
Date:   Mon, 22 Nov 2021 21:32:25 +0100
Message-Id: <20211122203225.6733-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>

Commit 4dfb9982644b ("tsn:  Fix build.") fixed compilation with const
dev_addr. In tsnep_netdev_set_mac_address() the call of ether_addr_copy()
was replaced with dev_set_mac_address(), which calls
ndo_set_mac_address(). This results in an endless recursive loop because
ndo_set_mac_address is set to tsnep_netdev_set_mac_address.

Call eth_hw_addr_set() instead of dev_set_mac_address() in
ndo_set_mac_address()/tsnep_netdev_set_mac_address() to copy the address
as intended.

[   26.563303] Insufficient stack space to handle exception!
[   26.563312] ESR: 0x96000047 -- DABT (current EL)
[   26.563317] FAR: 0xffff80000a507fc0
[   26.563320] Task stack:     [0xffff80000a508000..0xffff80000a50c000]
[   26.563324] IRQ stack:      [0xffff80000a0c0000..0xffff80000a0c4000]
[   26.563327] Overflow stack: [0xffff00007fbaf2b0..0xffff00007fbb02b0]
[   26.563333] CPU: 3 PID: 381 Comm: ifconfig Not tainted 5.16.0-rc1-zynqmp #60
[   26.563340] Hardware name: TSN endpoint (DT)
[   26.563343] pstate: a0000005 (NzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   26.563351] pc : inetdev_event+0x4/0x560
[   26.563364] lr : raw_notifier_call_chain+0x54/0x78
[   26.563372] sp : ffff80000a508040
[   26.563374] x29: ffff80000a508040 x28: ffff00000132b800 x27: 0000000000000000
[   26.563386] x26: 0000000000000000 x25: ffff800000ea5058 x24: 0904030201020001
[   26.563396] x23: ffff800000ea5058 x22: ffff80000a5080e0 x21: 0000000000000009
[   26.563405] x20: 00000000fffffffa x19: ffff80000a009510 x18: 0000000000000000
[   26.563414] x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffffd1341030
[   26.563422] x14: ffffffffffffffff x13: 0000000000000020 x12: 0101010101010101
[   26.563432] x11: 0000000000000020 x10: 0101010101010101 x9 : 7f7f7f7f7f7f7f7f
[   26.563441] x8 : 7f7f7f7f7f7f7f7f x7 : fefefeff30677364 x6 : 0000000080808080
[   26.563450] x5 : 0000000000000000 x4 : ffff800008dee170 x3 : ffff80000a50bd42
[   26.563459] x2 : ffff80000a5080e0 x1 : 0000000000000009 x0 : ffff80000a0092d0
[   26.563470] Kernel panic - not syncing: kernel stack overflow
[   26.563474] CPU: 3 PID: 381 Comm: ifconfig Not tainted 5.16.0-rc1-zynqmp #60
[   26.563481] Hardware name: TSN endpoint (DT)
[   26.563484] Call trace:
[   26.563486]  dump_backtrace+0x0/0x1b0
[   26.563497]  show_stack+0x18/0x68
[   26.563504]  dump_stack_lvl+0x68/0x84
[   26.563513]  dump_stack+0x18/0x34
[   26.563519]  panic+0x164/0x324
[   26.563524]  nmi_panic+0x64/0x98
[   26.563533]  panic_bad_stack+0x108/0x128
[   2k6.563539]  handle_bad_stack+0x38/0x68
[   26.563548]  __bad_stack+0x88/0x8c
[   26.563553]  inetdev_event+0x4/0x560
[   26.563560]  call_netdevice_notifiers_info+0x58/0xa8
[   26.563569]  dev_set_mac_address+0x78/0x110
[   26.563576]  tsnep_netdev_set_mac_address+0x38/0x60 [tsnep]
[   26.563591]  dev_set_mac_address+0xc4/0x110
[   26.563599]  tsnep_netdev_set_mac_address+0x38/0x60 [tsnep]
...
[   26.565444]  dev_set_mac_address+0xc4/0x110
[   26.565452]  tsnep_netdev_set_mac_address+0x38/0x60 [tsnep]
[   26.565462]  dev_set_mac_address+0xc4/0x110
[   26.565469]  dev_set_mac_address_user+0x44/0x68
[   26.565477]  dev_ifsioc+0x30c/0x568
[   26.565483]  dev_ioctl+0x124/0x3f0
[   26.565489]  sock_do_ioctl+0xb4/0xf8
[   26.565497]  sock_ioctl+0x2f4/0x398
[   26.565503]  __arm64_sys_ioctl+0xa8/0xe8
[   26.565511]  invoke_syscall+0x44/0x108
[   26.565520]  el0_svc_common.constprop.3+0x94/0xf8
[   26.565527]  do_el0_svc+0x24/0x88
[   26.565534]  el0_svc+0x20/0x50
[   26.565541]  el0t_64_sync_handler+0x90/0xb8
[   26.565548]  el0t_64_sync+0x180/0x184
[   26.565556] SMP: stopping secondary CPUs
[   26.565622] Kernel Offset: disabled
[   26.565624] CPU features: 0x0,00004002,00000846
[   26.565628] Memory Limit: none
[   27.843428] ---[ end Kernel panic - not syncing: kernel stack overflow ]---

Fixes: 4dfb9982644b ("tsn:  Fix build.")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 6a7feb24589a..8333313dd706 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1004,7 +1004,7 @@ static int tsnep_netdev_set_mac_address(struct net_device *netdev, void *addr)
 	retval = eth_prepare_mac_addr_change(netdev, sock_addr);
 	if (retval)
 		return retval;
-	dev_set_mac_address(netdev, sock_addr, NULL);
+	eth_hw_addr_set(netdev, sock_addr->sa_data);
 	tsnep_mac_set_address(adapter, sock_addr->sa_data);
 
 	return 0;
-- 
2.20.1

