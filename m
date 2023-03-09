Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDF16B2B55
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCIQ6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCIQ5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:57:53 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABC319C79;
        Thu,  9 Mar 2023 08:51:07 -0800 (PST)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.5])
        by mail.ispras.ru (Postfix) with ESMTPSA id BC4AD4077AED;
        Thu,  9 Mar 2023 16:51:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru BC4AD4077AED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678380665;
        bh=/fzV+lgyZY1hxeAejs+4DusbBcnz3JiFIO3akEE9M50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHhEqPiJPnRB6qQzvS6/kg+A7vd/YpaVYtwIEm83/GiWhf/vZGHLJNW804Gg772Er
         JxGVwEGASwkUfsFOcwiZcJOqiKV6qo3QIzn3mVEF+8AplzBmo0PV9a4VM+pQ2I+Z4W
         WvnlNK57zslhnzKofbgzT05Xrbr0Uqge66Y1OKfE=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Simon Horman <simon.horman@corigine.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Subject: [PATCH v2] nfc: pn533: initialize struct pn533_out_arg properly
Date:   Thu,  9 Mar 2023 19:50:50 +0300
Message-Id: <20230309165050.207390-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308183035.0fb2febd@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct pn533_out_arg used as a temporary context for out_urb is not
initialized properly. Its uninitialized 'phy' field can be dereferenced in
error cases inside pn533_out_complete() callback function. It causes the
following failure:

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.2.0-rc3-next-20230110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:pn533_out_complete.cold+0x15/0x44 drivers/nfc/pn533/usb.c:441
Call Trace:
 <IRQ>
 __usb_hcd_giveback_urb+0x2b6/0x5c0 drivers/usb/core/hcd.c:1671
 usb_hcd_giveback_urb+0x384/0x430 drivers/usb/core/hcd.c:1754
 dummy_timer+0x1203/0x32d0 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0x1da/0x800 kernel/time/timer.c:1700
 expire_timers+0x234/0x330 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1fb/0xaf6 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107

Initialize the field with the pn533_usb_phy currently used.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 9dab880d675b ("nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()")
Reported-by: syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
v2: follow reverse xmas tree ordering as suggested by Simon Horman;
some tiny commit info updates

 drivers/nfc/pn533/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index ed9c5e2cf3ad..a187f0e0b0f7 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -175,6 +175,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	arg.phy = phy;
 	init_completion(&arg.done);
 	cntx = phy->out_urb->context;
 	phy->out_urb->context = &arg;
-- 
2.34.1

