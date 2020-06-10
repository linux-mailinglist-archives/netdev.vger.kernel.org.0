Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04B81F5195
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 11:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgFJJxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 05:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgFJJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 05:53:52 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39870C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 02:53:52 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l10so1500998wrr.10
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 02:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=bvZzWw7bmia/DwqE5dhI5x19Nr6ZQCVk8X8zK8NsUp4=;
        b=KR0dhPyekyvK5nTaC7AJT6BZwqld0EWxic3e0/kpSB3oXogMmHvW1EMERSvjRv2BTI
         4nTIWpezhQrLhIrp+oSYydwmDaCZxwplNFVK/b3u9ESfm1V4ufBELQsgWcN3arDQ3Wqg
         ejcR95wWUMVoDFLaXgLiQ93k8QKAkvrX4c8MXeI8VJJE1s1qwOz2Z5PEUqyePe7JwtJW
         U1mfoGtgr3FNHOttWvktzIk0zz2Q+vjSMxlZD3vRWLTVo6j25a+2jotQ7B8wgkdokjQw
         Yo4jphS+Hmbyi30qpQ5Z/5+9XHc6Wpsze4lmquIwjnbOxZQMMFWdJV7zXEZSzANBOmql
         SGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bvZzWw7bmia/DwqE5dhI5x19Nr6ZQCVk8X8zK8NsUp4=;
        b=AB3rz99W3t5HDncYKeQM/I24CqE/65irEmbMHJfJsIkKkmLMQfJXLm7hbMCL1nGrq5
         LcCcgFTK48o9QjSNgN4OqHHeCO2q82JH+zV/WjXDngpkb+xIvg/gB9nHeZbzRq/n12TP
         GsNFE5pMKD06kJhQMEc6j2WYUsFWOqRD2Wd7mc190dvwI/gyY+sGx0jbEwtx9awLXWK8
         xqFZvnt32IqCNDyvlCWVj+s6gSRyG7TPxILjdYoyfc52kAcDUfIv1xJ38Cal7+AitO2V
         0T9Ms+X4czm9I4WFZIHuVcSKYWP3aw3IsRC442HcBsq98STcc5JkHXDrTsWDwk1r64Qo
         U0ww==
X-Gm-Message-State: AOAM532yz2bqiWgFRGeVu6gih+0jDMBTcQTPfsW+Knv2/v0WnZvfkYNO
        WVFnvIZtiwzG6q3C4gdvL/N/allpLQ0=
X-Google-Smtp-Source: ABdhPJy1bd/J5y6xZ9gUUPZtVzVVQd0TNmkh6sX//KnKS5mXkD/VArtd319iIB9KRBGy6y1+UiviRA==
X-Received: by 2002:adf:82ab:: with SMTP id 40mr2573393wrc.85.1591782830876;
        Wed, 10 Jun 2020 02:53:50 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z22sm6233667wmf.9.2020.06.10.02.53.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jun 2020 02:53:50 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     antoine.tenart@bootlin.com, davem@davemloft.net,
        linux@armlinux.org.uk, nicolas.ferre@microchip.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] net: cadence: macb: disable NAPI on error
Date:   Wed, 10 Jun 2020 09:53:44 +0000
Message-Id: <1591782824-31654-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the PHY is not working, the macb driver crash on a second try to
setup it.
[   78.545994] macb e000b000.ethernet eth0: Could not attach PHY (-19)
ifconfig: SIOCSIFFLAGS: No such device
[   78.655457] ------------[ cut here ]------------
[   78.656014] kernel BUG at /linux-next/include/linux/netdevice.h:521!
[   78.656504] Internal error: Oops - BUG: 0 [#1] SMP ARM
[   78.657079] Modules linked in:
[   78.657795] CPU: 0 PID: 122 Comm: ifconfig Not tainted 5.7.0-next-20200609 #1
[   78.658202] Hardware name: Xilinx Zynq Platform
[   78.659632] PC is at macb_open+0x220/0x294
[   78.660160] LR is at 0x0
[   78.660373] pc : [<c0b0a634>]    lr : [<00000000>]    psr: 60000013
[   78.660716] sp : c89ffd70  ip : c8a28800  fp : c199bac0
[   78.661040] r10: 00000000  r9 : c8838540  r8 : c8838568
[   78.661362] r7 : 00000001  r6 : c8838000  r5 : c883c000  r4 : 00000000
[   78.661724] r3 : 00000010  r2 : 00000000  r1 : 00000000  r0 : 00000000
[   78.662187] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   78.662635] Control: 10c5387d  Table: 08b64059  DAC: 00000051
[   78.663035] Process ifconfig (pid: 122, stack limit = 0x(ptrval))
[   78.663476] Stack: (0xc89ffd70 to 0xc8a00000)
[   78.664121] fd60:                                     00000000 c89fe000 c8838000 c89fe000
[   78.664866] fd80: 00000000 c11ff9ac c8838028 00000000 00000000 c0de6f2c 00000001 c1804eec
[   78.665579] fda0: c19b8178 c8838000 00000000 ca760866 c8838000 00000001 00001043 c89fe000
[   78.666355] fdc0: 00001002 c0de72f4 c89fe000 c0de8dc0 00008914 c89fe000 c199bac0 ca760866
[   78.667111] fde0: c89ffddc c8838000 00001002 00000000 c8838138 c881010c 00008914 c0de7364
[   78.667862] fe00: 00000000 c89ffe70 c89fe000 ffffffff c881010c c0e8bd48 00000003 00000000
[   78.668601] fe20: c8838000 c8810100 39c1118f 00039c11 c89a0960 00001043 00000000 000a26d0
[   78.669343] fe40: b6f43000 ca760866 c89a0960 00000051 befe6c50 00008914 c8b2a3c0 befe6c50
[   78.670086] fe60: 00000003 ee610500 00000000 c0e8ef58 30687465 00000000 00000000 00000000
[   78.670865] fe80: 00001043 00000000 000a26d0 b6f43000 c89a0600 ee40ae7c c8870d00 c0ddabf4
[   78.671593] fea0: c89ffeec c0ddabf4 c89ffeec c199bac0 00008913 c0ddac48 c89ffeec c89fe000
[   78.672324] fec0: befe6c50 ca760866 befe6c50 00008914 c89fe000 befe6c50 c8b2a3c0 c0dc00e4
[   78.673088] fee0: c89a0480 00000201 00000cc0 30687465 00000000 00000000 00000000 00001002
[   78.673822] ff00: 00000000 000a26d0 b6f43000 ca760866 00008914 c8b2a3c0 000a0ec4 c8b2a3c0
[   78.674576] ff20: befe6c50 c04b21bc 000d5004 00000817 c89a0480 c0315f94 00000000 00000003
[   78.675415] ff40: c19a2bc8 c8a3cc00 c89fe000 00000255 00000000 00000000 00000000 000d5000
[   78.676182] ff60: 000f6000 c180b2a0 00000817 c0315e64 000d5004 c89fffb0 b6ec0c30 ca760866
[   78.676928] ff80: 00000000 000b609b befe6c50 000a0ec4 00000036 c03002c4 c89fe000 00000036
[   78.677673] ffa0: 00000000 c03000c0 000b609b befe6c50 00000003 00008914 befe6c50 000b609b
[   78.678415] ffc0: 000b609b befe6c50 000a0ec4 00000036 befe6e0c befe6f1a 000d5150 00000000
[   78.679154] ffe0: 000d41e4 befe6bf4 00019648 b6e4509c 20000010 00000003 00000000 00000000
[   78.681059] [<c0b0a634>] (macb_open) from [<c0de6f2c>] (__dev_open+0xd0/0x154)
[   78.681571] [<c0de6f2c>] (__dev_open) from [<c0de72f4>] (__dev_change_flags+0x16c/0x1c4)
[   78.682015] [<c0de72f4>] (__dev_change_flags) from [<c0de7364>] (dev_change_flags+0x18/0x48)
[   78.682493] [<c0de7364>] (dev_change_flags) from [<c0e8bd48>] (devinet_ioctl+0x5e4/0x75c)
[   78.682945] [<c0e8bd48>] (devinet_ioctl) from [<c0e8ef58>] (inet_ioctl+0x1f0/0x3b4)
[   78.683381] [<c0e8ef58>] (inet_ioctl) from [<c0dc00e4>] (sock_ioctl+0x39c/0x664)
[   78.683818] [<c0dc00e4>] (sock_ioctl) from [<c04b21bc>] (ksys_ioctl+0x2d8/0x9c0)
[   78.684343] [<c04b21bc>] (ksys_ioctl) from [<c03000c0>] (ret_fast_syscall+0x0/0x54)
[   78.684789] Exception stack(0xc89fffa8 to 0xc89ffff0)
[   78.685346] ffa0:                   000b609b befe6c50 00000003 00008914 befe6c50 000b609b
[   78.686106] ffc0: 000b609b befe6c50 000a0ec4 00000036 befe6e0c befe6f1a 000d5150 00000000
[   78.686710] ffe0: 000d41e4 befe6bf4 00019648 b6e4509c
[   78.687582] Code: 9a000003 e5983078 e3130001 1affffef (e7f001f2)
[   78.688788] ---[ end trace e3f2f6ab69754eae ]---

This is due to NAPI left enabled if macb_phylink_connect() fail.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 36290a8e2a84..5b9d7c60eebc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2558,13 +2558,16 @@ static int macb_open(struct net_device *dev)
 
 	err = macb_phylink_connect(bp);
 	if (err)
-		goto pm_exit;
+		goto napi_exit;
 
 	netif_tx_start_all_queues(dev);
 
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_init(dev);
 
+napi_exit:
+	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
+		napi_disable(&queue->napi);
 pm_exit:
 	if (err) {
 		pm_runtime_put_sync(&bp->pdev->dev);
-- 
2.26.2

