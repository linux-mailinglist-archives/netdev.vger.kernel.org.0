Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFAF50B24C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445392AbiDVIAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445370AbiDVIAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:00:01 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0EA527F5;
        Fri, 22 Apr 2022 00:56:29 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VAlrUan_1650614179;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VAlrUan_1650614179)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Apr 2022 15:56:27 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net/smc: Two fixes for smc fallback
Date:   Fri, 22 Apr 2022 15:56:17 +0800
Message-Id: <1650614179-11529-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set includes two fixes for smc fallback:

Patch 1/2 introduces some simple helpers to wrap the replacement
and restore of clcsock's callback functions. Make sure that only
the original callbacks will be saved and not overwritten.

Patch 2/2 fixes a syzbot reporting slab-out-of-bound issue where
smc_fback_error_report() accesses the already freed smc sock (see
https://lore.kernel.org/r/00000000000013ca8105d7ae3ada@google.com/).
The patch fixes it by resetting sk_user_data and restoring clcsock
callback functions timely in fallback situation.

But it should be noted that although patch 2/2 can fix the issue
of 'slab-out-of-bounds/use-after-free in smc_fback_error_report',
it can't pass the syzbot reproducer test. Because after applying
these two patches in upstream, syzbot reproducer triggered another
known issue like this:

==================================================================
BUG: KASAN: use-after-free in tcp_retransmit_timer+0x2ef3/0x3360 net/ipv4/tcp_timer.c:511
Read of size 8 at addr ffff888020328380 by task udevd/4158

CPU: 1 PID: 4158 Comm: udevd Not tainted 5.18.0-rc3-syzkaller-00074-gb05a5683eba6-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
  print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
  print_report mm/kasan/report.c:429 [inline]
  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
  tcp_retransmit_timer+0x2ef3/0x3360 net/ipv4/tcp_timer.c:511
  tcp_write_timer_handler+0x5e6/0xbc0 net/ipv4/tcp_timer.c:622
  tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
  expire_timers kernel/time/timer.c:1466 [inline]
  __run_timers.part.0+0x679/0xa80 kernel/time/timer.c:1737
  __run_timers kernel/time/timer.c:1715 [inline]
  run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1750
  __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
  invoke_softirq kernel/softirq.c:432 [inline]
  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
  irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 ...
(detail report can be found in https://syzkaller.appspot.com/text?tag=CrashReport&x=15406b44f00000)

IMHO, the above issue is the same as this known one: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed,
and it doesn't seem to be related with SMC. The discussion about this known issue is ongoing and can be found in
https://lore.kernel.org/bpf/000000000000f75af905d3ba0716@google.com/T/.

And I added the temporary solution mentioned in the above discussion on
top of my two patches, the syzbot reproducer of 'slab-out-of-bounds/
use-after-free in smc_fback_error_report' no longer triggers any issue.

Wen Gu (2):
  net/smc: Only save the original clcsock callback functions
  net/smc: Fix slab-out-of-bounds issue in fallback

 net/smc/af_smc.c    | 135 ++++++++++++++++++++++++++++++++++++----------------
 net/smc/smc.h       |  29 +++++++++++
 net/smc/smc_close.c |   5 +-
 3 files changed, 126 insertions(+), 43 deletions(-)

-- 
1.8.3.1

