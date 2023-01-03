Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AB565C845
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 21:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbjACUlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 15:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbjACUlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 15:41:36 -0500
X-Greylist: delayed 627 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Jan 2023 12:41:27 PST
Received: from smtp-out-04.comm2000.it (smtp-out-04.comm2000.it [212.97.32.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E212D74;
        Tue,  3 Jan 2023 12:41:27 -0800 (PST)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-04.comm2000.it (Postfix) with ESMTPSA id 7FD19BC32C1;
        Tue,  3 Jan 2023 21:30:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1672777856;
        bh=7UNz47u0wSsUl65PKsRxKJg9i0qWtwpdgL6NpbhB558=;
        h=Date:From:To:Cc:Subject;
        b=kZVBqsFP2rqqD2B6XQKv5E0TNJf/cO2ecBvEqQUov/JeD1L9NJEDgwiBL1m9b9Uu2
         hR6JVTinSpFeeGK7iC84IilpKGmR/WysoazEffD8t+81ikayE49P6m5DAJHJcim7B4
         rzkNXbBKY7ewJOBJvO2mo4uuMRELDNNIrUAdclLwwFa3AvRf5cBZPNmf481pa728YU
         mRCqhOzjIxRgMQNT9+cYWwsFNKiuV+HFspno3GHeHIEItOIUZLA5Q+Cy31/WmSbmhP
         0vKhWoFuhYQEnsmb7rQn6P+YkFZ4ric6AGVvALwsy9srkcngSBczTNs1jf9hntEE+5
         Dj7FmnTCfWKPg==
Date:   Tue, 3 Jan 2023 21:30:41 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: hdev->le_scan_disable - WARNING: possible circular locking
 dependency detected
Message-ID: <Y7SQcdg33X8xTPzs@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,
When enabling BT discovery I have this WARNING.

Linux 6.0.16, ARM, i.MX6ULL, with a Marvell BT device.

This looks like a regression on Linux 6.0, however I had no way to try
to bisect this yet. Any suggestion?

[  493.824758] ======================================================
[  493.831012] WARNING: possible circular locking dependency detected
[  493.837261] 6.0.16-6.1.0-devel+git.29e1bc6a55de #1 Not tainted
[  493.843171] ------------------------------------------------------
[  493.849416] kworker/u3:0/39 is trying to acquire lock:
[  493.854627] c2adcb18 (&hdev->req_lock){+.+.}-{3:3}, at: le_scan_disable_work+0x68/0x200
[  493.862877]
[  493.862877] but task is already holding lock:
[  493.868773] e0abdf28 ((work_completion)(&(&hdev->le_scan_disable)->work)){+.+.}-{0:0}, at: process_one_work+0x1e4/0x6f4
[  493.879775]
[  493.879775] which lock already depends on the new lock.
[  493.879775]
[  493.888017]
[  493.888017] the existing dependency chain (in reverse order) is:
[  493.895564]
[  493.895564] -> #1 ((work_completion)(&(&hdev->le_scan_disable)->work)){+.+.}-{0:0}:
[  493.904868]        __cancel_work_timer+0x198/0x224
[  493.909762]        hci_request_cancel_all+0x1c/0xb0
[  493.914746]        hci_dev_close_sync+0x38/0x5ac
[  493.919456]        hci_dev_do_close+0x30/0x64
[  493.923904]        process_one_work+0x280/0x6f4
[  493.928526]        worker_thread+0x40/0x4f8
[  493.932801]        kthread+0xe0/0x100
[  493.936550]        ret_from_fork+0x14/0x2c
[  493.940738]
[  493.940738] -> #0 (&hdev->req_lock){+.+.}-{3:3}:
[  493.947001]        lock_acquire+0xf4/0x364
[  493.951190]        __mutex_lock+0x80/0x8a0
[  493.955378]        mutex_lock_nested+0x1c/0x24
[  493.959912]        le_scan_disable_work+0x68/0x200
[  493.964800]        process_one_work+0x280/0x6f4
[  493.969424]        worker_thread+0x40/0x4f8
[  493.973698]        kthread+0xe0/0x100
[  493.977447]        ret_from_fork+0x14/0x2c
[  493.981632]
[  493.981632] other info that might help us debug this:
[  493.981632]
[  493.989702]  Possible unsafe locking scenario:
[  493.989702]
[  493.995682]        CPU0                    CPU1
[  494.000270]        ----                    ----
[  494.004857]   lock((work_completion)(&(&hdev->le_scan_disable)->work));
[  494.011583]                                lock(&hdev->req_lock);
[  494.017783]                                lock((work_completion)(&(&hdev->le_scan_disable)->work));
[  494.027025]   lock(&hdev->req_lock);
[  494.030704]
[  494.030704]  *** DEADLOCK ***
[  494.030704]
[  494.036685] 2 locks held by kworker/u3:0/39:
[  494.041026]  #0: c2bb6ca8 ((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work+0x1e4/0x6f4
[  494.049786]  #1: e0abdf28 ((work_completion)(&(&hdev->le_scan_disable)->work)){+.+.}-{0:0}, at: process_one_work+0x1e4/0x6f4
[  494.061236]
[  494.061236] stack backtrace:
[  494.065659] CPU: 0 PID: 39 Comm: kworker/u3:0 Not tainted 6.0.16-6.1.0-devel+git.29e1bc6a55de #1
[  494.074540] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
[  494.080797] Workqueue: hci0 le_scan_disable_work
[  494.085547]  unwind_backtrace from show_stack+0x10/0x14
[  494.090902]  show_stack from dump_stack_lvl+0x58/0x70
[  494.096089]  dump_stack_lvl from check_noncircular+0xe8/0x158
[  494.101985]  check_noncircular from __lock_acquire+0x1510/0x288c
[  494.108120]  __lock_acquire from lock_acquire+0xf4/0x364
[  494.113541]  lock_acquire from __mutex_lock+0x80/0x8a0
[  494.118789]  __mutex_lock from mutex_lock_nested+0x1c/0x24
[  494.124384]  mutex_lock_nested from le_scan_disable_work+0x68/0x200
[  494.130770]  le_scan_disable_work from process_one_work+0x280/0x6f4
[  494.137160]  process_one_work from worker_thread+0x40/0x4f8
[  494.142852]  worker_thread from kthread+0xe0/0x100
[  494.147756]  kthread from ret_from_fork+0x14/0x2c
[  494.152565] Exception stack(0xe0abdfb0 to 0xe0abdff8)
[  494.157708] dfa0:                                     00000000 00000000 00000000 00000000
[  494.165982] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  494.174248] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000

Francesco

