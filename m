Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FED255C6A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFYXkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41956 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYXkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so499199wrm.8
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ELOU01/g2Nhd9L7JbUxwLkOw5q1aU08MgZlvZizk9Ww=;
        b=qfkuWKADtx53JBJq3umDC/UjcnpsLA6WEX67DCkW1LZp5scvZwhuBI/LwFtMZkTkWx
         R9utAOMwlHIEBosFvHBLV2vfty2+4CRgoEuUhoUmrqIlg3Rg2rGRlTyD0eMsX0OX5gj9
         MA/qT4ltmd+1/Yx9JqzzXhpYekzdUYgHUatM4bFQuXxJ3xGh6LYRVBEWcC6ON6gwNRmj
         IBAHVjaUgCGdhhM6M7xj7SxicXokFxSPDzPQSxETPnfOO+oCdDvbuu4ypVN/+gEBL5Vb
         3xrt4hUB4LDCkwDqE46TvY9O/Y6x1oZBqbR/IRKHZ192pkZXl/jENgsRN1bx7ZszLaoN
         jplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ELOU01/g2Nhd9L7JbUxwLkOw5q1aU08MgZlvZizk9Ww=;
        b=BGw50yfDLLaiFYvgv0TQ560X2h9A4znWq5JU42IHSpemjbQvtojsKd9yvsyoaPUxVk
         HJyLY8q4qmqGtwYSMhQuSMmkON2ffgzooR8+BDKKthqub4YQwJrgwuaPVjWDD7u66JCl
         FQdg3sWs4HznFLBRgMNVUwNKYDZLpYOIu57ENFSMdE80sVGdbzYjvHvEm0Ux+qA2jDSr
         3PZjIFsZDqrfUHD91P94ECH/xa2sp5tMFjyCHmghvnqgg5yKPFHnfgplDzzvg1fXsktG
         85NYTV8VhVzlmMCdbH1WzZcf9kcKZz0P79oCCv83GYxbsPUlntD/H74BgtCy8OAMFztn
         WYZQ==
X-Gm-Message-State: APjAAAVQISW3PdWxRLQgOKAsu1cI8Ev90ODoV1QyXhUvuL4eBLB4IJ96
        uveR6pzdhA8Dkb7ZJG9cAxc=
X-Google-Smtp-Source: APXvYqxM4qOEJexM/eEHl6f9Mcc8ZNRdOIXD/7/v3fSaHdEqUd58zhl6Am6FaIpXdgNr9AYo9yx9Ig==
X-Received: by 2002:adf:e889:: with SMTP id d9mr464156wrm.169.1561506005664;
        Tue, 25 Jun 2019 16:40:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 02/10] net: dsa: sja1105: Cancel PTP delayed work on unregister
Date:   Wed, 26 Jun 2019 02:39:34 +0300
Message-Id: <20190625233942.1946-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when the driver unloads and PTP is enabled, the delayed work
that prevents the timecounter from expiring becomes a ticking time bomb.
The kernel will schedule the work thread within 60 seconds of driver
removal, but the work handler is no longer there, leading to this
strange and inconclusive stack trace:

[   64.473112] Unable to handle kernel paging request at virtual address 79746970
[   64.480340] pgd = 008c4af9
[   64.483042] [79746970] *pgd=00000000
[   64.486620] Internal error: Oops: 80000005 [#1] SMP ARM
[   64.491820] Modules linked in:
[   64.494871] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.2.0-rc5-01634-ge3a2773ba9e5 #1246
[   64.503007] Hardware name: Freescale LS1021A
[   64.507259] PC is at 0x79746970
[   64.510393] LR is at call_timer_fn+0x3c/0x18c
[   64.514729] pc : [<79746970>]    lr : [<c03bd734>]    psr: 60010113
[   64.520965] sp : c1901de0  ip : 00000000  fp : c1903080
[   64.526163] r10: c1901e38  r9 : ffffe000  r8 : c19064ac
[   64.531363] r7 : 79746972  r6 : e98dd260  r5 : 00000100  r4 : c1a9e4a0
[   64.537859] r3 : c1900000  r2 : ffffa400  r1 : 79746972  r0 : e98dd260
[   64.544359] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   64.551460] Control: 10c5387d  Table: a8a2806a  DAC: 00000051
[   64.557176] Process swapper/0 (pid: 0, stack limit = 0x1ddb27f0)
[   64.563147] Stack: (0xc1901de0 to 0xc1902000)
[   64.567481] 1de0: eb6a4918 3d60d7c3 c1a9e554 e98dd260 eb6a34c0 c1a9e4a0 ffffa400 c19064ac
[   64.575616] 1e00: ffffe000 c03bd95c c1901e34 c1901e34 eb6a34c0 c1901e30 c1903d00 c186f4c0
[   64.583751] 1e20: c1906488 29e34000 c1903080 c03bdca4 00000000 eaa6f218 00000000 eb6a45c0
[   64.591886] 1e40: eb6a45c0 20010193 00000003 c03c0a68 20010193 3f7231be c1903084 00000002
[   64.600022] 1e60: 00000082 00000001 ffffe000 c1a9e0a4 00000100 c0302298 02b64722 0000000f
[   64.608157] 1e80: c186b3c8 c1877540 c19064ac 0000000a c186b350 ffffa401 c1903d00 c1107348
[   64.616292] 1ea0: 00200102 c0d87a14 ea823c00 ffffe000 00000012 00000000 00000000 ea810800
[   64.624427] 1ec0: f0803000 c1876ba8 00000000 c034c784 c18774b8 c039fb50 c1906c90 c1978aac
[   64.632562] 1ee0: f080200c f0802000 c1901f10 c0709ca8 c03091a0 60010013 ffffffff c1901f44
[   64.640697] 1f00: 00000000 c1900000 c1876ba8 c0301a8c 00000000 000070a0 eb6ac1a0 c031da60
[   64.648832] 1f20: ffffe000 c19064ac c19064f0 00000001 00000000 c1906488 c1876ba8 00000000
[   64.656967] 1f40: ffffffff c1901f60 c030919c c03091a0 60010013 ffffffff 00000051 00000000
[   64.665102] 1f60: ffffe000 c0376aa4 c1a9da37 ffffffff 00000037 3f7231be c1ab20c0 000000cc
[   64.673238] 1f80: c1906488 c1906480 ffffffff 00000037 c1ab20c0 c1ab20c0 00000001 c0376e1c
[   64.681373] 1fa0: c1ab2118 c1700ea8 ffffffff ffffffff 00000000 c1700754 c17dfa40 ebfffd80
[   64.689509] 1fc0: 00000000 c17dfa40 3f7733be 00000000 00000000 c1700330 00000051 10c0387d
[   64.697644] 1fe0: 00000000 8f000000 410fc075 10c5387d 00000000 00000000 00000000 00000000
[   64.705788] [<c03bd734>] (call_timer_fn) from [<c03bd95c>] (expire_timers+0xd8/0x144)
[   64.713579] [<c03bd95c>] (expire_timers) from [<c03bdca4>] (run_timer_softirq+0xe4/0x1dc)
[   64.721716] [<c03bdca4>] (run_timer_softirq) from [<c0302298>] (__do_softirq+0x130/0x3c8)
[   64.729854] [<c0302298>] (__do_softirq) from [<c034c784>] (irq_exit+0xbc/0xd8)
[   64.737040] [<c034c784>] (irq_exit) from [<c039fb50>] (__handle_domain_irq+0x60/0xb4)
[   64.744833] [<c039fb50>] (__handle_domain_irq) from [<c0709ca8>] (gic_handle_irq+0x58/0x9c)
[   64.753143] [<c0709ca8>] (gic_handle_irq) from [<c0301a8c>] (__irq_svc+0x6c/0x90)
[   64.760583] Exception stack(0xc1901f10 to 0xc1901f58)
[   64.765605] 1f00:                                     00000000 000070a0 eb6ac1a0 c031da60
[   64.773740] 1f20: ffffe000 c19064ac c19064f0 00000001 00000000 c1906488 c1876ba8 00000000
[   64.781873] 1f40: ffffffff c1901f60 c030919c c03091a0 60010013 ffffffff
[   64.788456] [<c0301a8c>] (__irq_svc) from [<c03091a0>] (arch_cpu_idle+0x38/0x3c)
[   64.795816] [<c03091a0>] (arch_cpu_idle) from [<c0376aa4>] (do_idle+0x1bc/0x298)
[   64.803175] [<c0376aa4>] (do_idle) from [<c0376e1c>] (cpu_startup_entry+0x18/0x1c)
[   64.810707] [<c0376e1c>] (cpu_startup_entry) from [<c1700ea8>] (start_kernel+0x480/0x4ac)
[   64.818839] Code: bad PC value
[   64.821890] ---[ end trace e226ed97b1c584cd ]---
[   64.826482] Kernel panic - not syncing: Fatal exception in interrupt
[   64.832807] CPU1: stopping
[   64.835501] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D           5.2.0-rc5-01634-ge3a2773ba9e5 #1246
[   64.845013] Hardware name: Freescale LS1021A
[   64.849266] [<c0312394>] (unwind_backtrace) from [<c030cc74>] (show_stack+0x10/0x14)
[   64.856972] [<c030cc74>] (show_stack) from [<c0ff4138>] (dump_stack+0xb4/0xc8)
[   64.864159] [<c0ff4138>] (dump_stack) from [<c0310854>] (handle_IPI+0x3bc/0x3dc)
[   64.871519] [<c0310854>] (handle_IPI) from [<c0709ce8>] (gic_handle_irq+0x98/0x9c)
[   64.879050] [<c0709ce8>] (gic_handle_irq) from [<c0301a8c>] (__irq_svc+0x6c/0x90)
[   64.886489] Exception stack(0xea8cbf60 to 0xea8cbfa8)
[   64.891514] bf60: 00000000 0000307c eb6c11a0 c031da60 ffffe000 c19064ac c19064f0 00000002
[   64.899649] bf80: 00000000 c1906488 c1876ba8 00000000 00000000 ea8cbfb0 c030919c c03091a0
[   64.907780] bfa0: 600d0013 ffffffff
[   64.911250] [<c0301a8c>] (__irq_svc) from [<c03091a0>] (arch_cpu_idle+0x38/0x3c)
[   64.918609] [<c03091a0>] (arch_cpu_idle) from [<c0376aa4>] (do_idle+0x1bc/0x298)
[   64.925967] [<c0376aa4>] (do_idle) from [<c0376e1c>] (cpu_startup_entry+0x18/0x1c)
[   64.933496] [<c0376e1c>] (cpu_startup_entry) from [<803025cc>] (0x803025cc)
[   64.940422] Rebooting in 3 seconds..

In this case, what happened is that the DSA driver failed to probe at
boot time due to a PHY issue during phylink_connect_phy:

[    2.245607] fsl-gianfar soc:ethernet@2d90000 eth2: error -19 setting up slave phy
[    2.258051] sja1105 spi0.1: failed to create slave for port 0.0

Fixes: bb77f36ac21d ("net: dsa: sja1105: Add support for the PTP clock")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index c7ce1edd8471..d19cfdf681af 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -387,6 +387,7 @@ void sja1105_ptp_clock_unregister(struct sja1105_private *priv)
 	if (IS_ERR_OR_NULL(priv->clock))
 		return;
 
+	cancel_delayed_work_sync(&priv->refresh_work);
 	ptp_clock_unregister(priv->clock);
 	priv->clock = NULL;
 }
-- 
2.17.1

