Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE87E171710
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgB0MYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:24:03 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33163 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729039AbgB0MYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:24:02 -0500
Received: by mail-pj1-f67.google.com with SMTP id m7so3244658pjs.0
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QoqzCIRGxNkv9KHDAWyUfPOF18i0o9JxGzEG10AKYc0=;
        b=sgx+nS24I8BYR7WaAb1rGPPCFewMHJFwf+pdqV6yEaxj0n/dKgikwC0r65b7kN6TFT
         8TzZ9XjxD+6MhafBgHEBsSBvYyBrAekzV6nlClPRgAxtWY3AU9mcAKUbdpTwyIbjCKuo
         Y+vtiLNdEXluLD78W69FWAXsqdCr0qLsKsxBQ7xNUceyG6T6iFXz5K9WNKfOshu7W4eL
         GOrRh3Qcqf4y9OQPm8DjpZCCRWZWIzG29WhMv5/PVGb7Kz54eyCjEHSSFaE8Jjbll38u
         6nbcEBgNHw/jFgs7UKBTD9TV+aQLVuhc0rmzKE1tOoYlX/90z3Pb45MBNsHdjKxFwe3R
         wi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QoqzCIRGxNkv9KHDAWyUfPOF18i0o9JxGzEG10AKYc0=;
        b=JPV2VKyxFs15aT2Cy5uMfUYxKusrGx1YbYXdJ4/2s+jhyUiFZTzG1GxaZSO6l3SVgm
         krIjgIoMXcJiiUtwGiIO8HzW9nkp7/FMnmWaV2I6Kq2r83HIt0x6lOgKY7gVvswxlEst
         sRe5Tg8HOYMCYI8BgKIpJRVDMEssGZleVlMLpZWNwx1YPYfWVsVJdgrDkfbbZ/3lHhN1
         QdJD044ogcXfiFOjyGGreEyEFDZSijVAEd9yDaaXy/xjnBK3l2u6AFzRfN6d1q6rBmgH
         8gFw8X2aaniA2bX2AnFfmYDtgUEZH75wSsRpRrv5pLWGAGxCumF/Y6HPLfELFltEKvlO
         vvWg==
X-Gm-Message-State: APjAAAV9On5BZ773C+r8kkZDCfZ4TMulqEnzyTuBPnY0ZxRerszz6F3F
        1HO4jvMp94jFe8bSqrp2kf3DeMqIxjs=
X-Google-Smtp-Source: APXvYqybLdxvvSap6/4uxfACdHlX2Ik7VLQ0KDRi1+mgxHJ5HxGBcOBoCLiYAwTdtEycYwAXZoeBpw==
X-Received: by 2002:a17:902:8a83:: with SMTP id p3mr4548025plo.56.1582806241527;
        Thu, 27 Feb 2020 04:24:01 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id e1sm7014430pff.188.2020.02.27.04.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:24:00 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 1/8] net: rmnet: fix NULL pointer dereference in rmnet_newlink()
Date:   Thu, 27 Feb 2020 12:23:52 +0000
Message-Id: <20200227122352.18934-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rmnet registers IFLA_LINK interface as a lower interface.
But, IFLA_LINK could be NULL.
In the current code, rmnet doesn't check IFLA_LINK.
So, panic would occur.

Test commands:
    modprobe rmnet
    ip link add rmnet0 type rmnet mux_id 1

Splat looks like:
[   36.826109][ T1115] general protection fault, probably for non-canonical address 0xdffffc0000000000I
[   36.838817][ T1115] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   36.839908][ T1115] CPU: 1 PID: 1115 Comm: ip Not tainted 5.6.0-rc1+ #447
[   36.840569][ T1115] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   36.841408][ T1115] RIP: 0010:rmnet_newlink+0x54/0x510 [rmnet]
[   36.841986][ T1115] Code: 83 ec 18 48 c1 e9 03 80 3c 01 00 0f 85 d4 03 00 00 48 8b 6a 28 48 b8 00 00 00 00 00 c
[   36.843923][ T1115] RSP: 0018:ffff8880b7e0f1c0 EFLAGS: 00010247
[   36.844756][ T1115] RAX: dffffc0000000000 RBX: ffff8880d14cca00 RCX: 1ffff11016fc1e99
[   36.845859][ T1115] RDX: 0000000000000000 RSI: ffff8880c3d04000 RDI: 0000000000000004
[   36.846961][ T1115] RBP: 0000000000000000 R08: ffff8880b7e0f8b0 R09: ffff8880b6ac2d90
[   36.848020][ T1115] R10: ffffffffc0589a40 R11: ffffed1016d585b7 R12: ffffffff88ceaf80
[   36.848788][ T1115] R13: ffff8880c3d04000 R14: ffff8880b7e0f8b0 R15: ffff8880c3d04000
[   36.849546][ T1115] FS:  00007f50ab3360c0(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[   36.851784][ T1115] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.852422][ T1115] CR2: 000055871afe5ab0 CR3: 00000000ae246001 CR4: 00000000000606e0
[   36.853181][ T1115] Call Trace:
[   36.853514][ T1115]  __rtnl_newlink+0xbdb/0x1270
[   36.853967][ T1115]  ? lock_downgrade+0x6e0/0x6e0
[   36.854420][ T1115]  ? rtnl_link_unregister+0x220/0x220
[   36.854936][ T1115]  ? lock_acquire+0x164/0x3b0
[   36.855376][ T1115]  ? is_bpf_image_address+0xff/0x1d0
[   36.855884][ T1115]  ? rtnl_newlink+0x4c/0x90
[   36.856304][ T1115]  ? kernel_text_address+0x111/0x140
[   36.856857][ T1115]  ? __kernel_text_address+0xe/0x30
[   36.857440][ T1115]  ? unwind_get_return_address+0x5f/0xa0
[   36.858063][ T1115]  ? create_prof_cpu_mask+0x20/0x20
[   36.858644][ T1115]  ? arch_stack_walk+0x83/0xb0
[   36.859171][ T1115]  ? stack_trace_save+0x82/0xb0
[   36.859710][ T1115]  ? stack_trace_consume_entry+0x160/0x160
[   36.860357][ T1115]  ? deactivate_slab.isra.78+0x2c5/0x800
[   36.860928][ T1115]  ? kasan_unpoison_shadow+0x30/0x40
[   36.861520][ T1115]  ? kmem_cache_alloc_trace+0x135/0x350
[   36.862125][ T1115]  ? rtnl_newlink+0x4c/0x90
[   36.864073][ T1115]  rtnl_newlink+0x65/0x90
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

 v1 -> v2:
  - update commit log.

 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 06de59521fc4..471e3b2a1403 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -135,6 +135,11 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	int err = 0;
 	u16 mux_id;
 
+	if (!tb[IFLA_LINK]) {
+		NL_SET_ERR_MSG_MOD(extack, "link not specified");
+		return -EINVAL;
+	}
+
 	real_dev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
 	if (!real_dev || !dev)
 		return -ENODEV;
-- 
2.17.1

