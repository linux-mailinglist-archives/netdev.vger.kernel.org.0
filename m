Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572E3CDE94
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfJGKBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:01:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51289 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfJGKBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 06:01:07 -0400
Received: by mail-io1-f70.google.com with SMTP id x13so25624200ioa.18
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 03:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2dOhl9LWYh299C4nMLmYFQZPM+ApcfTb4SWssQCL8EI=;
        b=BlaVOaQ8UND7WnLZOLSTkjHSHupiqRfnpoLYtZ2QAJTFgQL9Y7INy21fxlnT3BP1G/
         g709dAlzPLPMGt7IwWK+LtqeatbSzhPadsCIhDMio2H9lWCkvCfJ8aLIuANiJ5jdqeDN
         WtgLgBJ9mUPIheWhe44pbOddGB8IU607hbBzS92wUuDfOxhVp7hduwqgr4DVDvkvbiiE
         442kxkS6mOfkcmSUwviQs0jGRX48VnMaWtItQ/SXMJXMEYQ0Cft99ZNreYXnt+7eMxvT
         RewW+WDnm/qbFhkvBosPiO0Z1L8NaH/mOek880Ht2Y91x/CvdcZZgJrNwhXzlbPdaIlq
         vhWg==
X-Gm-Message-State: APjAAAWExlxxT3gakbUOCjuQl5u6H4TDcXARE39ZmIHm6uOoEEqyi7Lk
        n6n0dIRcty8VcXGFR5BIWgncHgxBThW2ky1TbPRCL7K1znYj
X-Google-Smtp-Source: APXvYqxi4OHvyHUK0a+SaogOYzTO73QeBkiB/kA+CnfygUK1TS2GeKAort/9PY+sGb8ufHnle77oiXUW5FMz/iuvXDkFlBov9d5v
MIME-Version: 1.0
X-Received: by 2002:a6b:b704:: with SMTP id h4mr22413104iof.218.1570442466837;
 Mon, 07 Oct 2019 03:01:06 -0700 (PDT)
Date:   Mon, 07 Oct 2019 03:01:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000604e8905944f211f@google.com>
Subject: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
From:   syzbot <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, elver@google.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b4bd9343 x86, kcsan: Enable KCSAN for x86
git tree:       https://github.com/google/ktsan.git kcsan
console output: https://syzkaller.appspot.com/x/log.txt?x=11edb20d600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0906aa620713d80
dashboard link: https://syzkaller.appspot.com/bug?extid=134336b86f728d6e55a0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult

write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
  rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244
  rcu_report_exp_rdp+0x6c/0x90 kernel/rcu/tree_exp.h:254
  rcu_preempt_deferred_qs_irqrestore+0x3bb/0x580 kernel/rcu/tree_plugin.h:475
  rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
  __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
  rcu_read_unlock include/linux/rcupdate.h:645 [inline]
  batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
  batadv_nc_worker+0x13a/0x390 net/batman-adv/network-coding.c:718
  process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
  worker_thread+0xa0/0x800 kernel/workqueue.c:2415
  kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
  _find_next_bit lib/find_bit.c:39 [inline]
  find_next_bit+0x57/0xe0 lib/find_bit.c:70
  sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375
  sync_rcu_exp_select_cpus+0x30c/0x590 kernel/rcu/tree_exp.h:439
  rcu_exp_sel_wait_wake kernel/rcu/tree_exp.h:575 [inline]
  wait_rcu_exp_gp+0x25/0x40 kernel/rcu/tree_exp.h:589
  process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
  worker_thread+0xa0/0x800 kernel/workqueue.c:2415
  kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7251 Comm: kworker/1:4 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: rcu_gp wait_rcu_exp_gp
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
