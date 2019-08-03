Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC38803B4
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 03:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390212AbfHCB1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 21:27:41 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14799 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388638AbfHCB1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 21:27:40 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d44e30c0000>; Fri, 02 Aug 2019 18:27:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 02 Aug 2019 18:27:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 02 Aug 2019 18:27:39 -0700
Received: from [10.110.48.28] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 3 Aug
 2019 01:27:39 +0000
From:   John Hubbard <jhubbard@nvidia.com>
Subject: NFSv4: rare bug *and* root cause captured in the wild
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
X-Nvconfidentiality: public
Message-ID: <dba47642-1ff2-81d0-14d7-fd2fa397770e@nvidia.com>
Date:   Fri, 2 Aug 2019 18:27:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564795660; bh=VkF+dYkLEMuE38OO7xSjtD6Jc/mXTWO+u/A2pmORYbE=;
        h=X-PGP-Universal:From:Subject:To:X-Nvconfidentiality:Message-ID:
         Date:User-Agent:MIME-Version:X-Originating-IP:X-ClientProxiedBy:
         Content-Type:Content-Language:Content-Transfer-Encoding;
        b=IUli3Vr4a+380i4BjZeED+in6na0AfJPULPkKh1SiEdYEEvNKXegT5wSX8YzPMJCX
         USmQ9ypArQRY6X0LI+T7xbKskyRjia8AAbrdVZHxoAMIWIlFl3pc9zYu6cjGEqp8uA
         1t1pzosFbC/5CBGvGeRcHnTajXcdKvbhKx/eVoppy+oLh2MDmI965SMPmvrBBp5ItF
         kNcuHV5nTKp3AQ2w1SpL+jm0xoBIICiqD+GqFpKU+ITc0d4wDaRhv4lxWX6zkCO7Xq
         RAefjT0f1Qxv1iV4s2RwG27S56BabsbF73rPp2Za5aNZGj4SPPrtU08wD0+kh81EL/
         BLpB8bzpDXtXw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While testing unrelated (put_user_pages) work on Linux 5.3-rc2+,
I rebooted the NFS *server*, tried to ssh to the client, and the
client dumped a backtrace as shown below.

Good news: I found that I can reliably reproduce it with those steps, 
at commit 1e78030e5e5b (in linux.git) plus my 34-patch series [1], which
off course is completely unrelated. :) Anyway, I'm making a note of the 
exact repro commit, so I don't lose the repro.

I see what's wrong, but I do *not* see an easy fix. Can one of the
designers please recommend an approach to fixing this?

This is almost certainly caused by commit 7e0a0e38fcfe ("SUNRPC: 
Replace the queue timer with a delayed work function"), which changed 
over to running things in process (kthread) context. The commit is dated
May 1, 2019, but I've only been running NFSv4 for a couple days, so
the problem has likely been there all along, not specific to 5.3.

The call stack starts off in atomic context, so we get the bug:

nfs4_do_reclaim
    rcu_read_lock /* we are now in_atomic() and must not sleep */
        nfs4_purge_state_owners
            nfs4_free_state_owner
                nfs4_destroy_seqid_counter
                    rpc_destroy_wait_queue
                        cancel_delayed_work_sync
                            __cancel_work_timer
                                __flush_work
                                    start_flush_work
                                        might_sleep: 
                                         (kernel/workqueue.c:2975: BUG)

Details: actual backtrace I am seeing:

BUG: sleeping function called from invalid context at kernel/workqueue.c:2975
in_atomic(): 1, irqs_disabled(): 0, pid: 2224, name: 10.110.48.28-ma
1 lock held by 10.110.48.28-ma/2224:
 #0: 00000000d338d2ec (rcu_read_lock){....}, at: nfs4_do_reclaim+0x22/0x6b0 [nfsv4]
CPU: 8 PID: 2224 Comm: 10.110.48.28-ma Not tainted 5.3.0-rc2-hubbard-github+ #52
Hardware name: ASUS X299-A/PRIME X299-A, BIOS 1704 02/14/2019
Call Trace:
 dump_stack+0x46/0x60
 ___might_sleep.cold+0x8e/0x9b
 __flush_work+0x61/0x370
 ? find_held_lock+0x2b/0x80
 ? add_timer+0x100/0x200
 ? _raw_spin_lock_irqsave+0x35/0x40
 __cancel_work_timer+0xfb/0x180
 ? nfs4_purge_state_owners+0xf4/0x170 [nfsv4]
 nfs4_free_state_owner+0x10/0x50 [nfsv4]
 nfs4_purge_state_owners+0x139/0x170 [nfsv4]
 nfs4_do_reclaim+0x7a/0x6b0 [nfsv4]
 ? pnfs_destroy_layouts_byclid+0xc4/0x100 [nfsv4]
 nfs4_state_manager+0x6be/0x7f0 [nfsv4]
 nfs4_run_state_manager+0x1b/0x40 [nfsv4]
 kthread+0xfb/0x130
 ? nfs4_state_manager+0x7f0/0x7f0 [nfsv4]
 ? kthread_bind+0x20/0x20
 ret_from_fork+0x35/0x40

And last but not least, some words of encouragement: the reason I moved 
from NFSv3 to NFSv4 is that the easy authentication (matching UIDs on
client and server) now works perfectly. Yea! So I'm enjoying v4, despite 
the occasional minor glitch. :)

[1] https://lore.kernel.org/r/20190802022005.5117-1-jhubbard@nvidia.com

thanks,
-- 
John Hubbard
NVIDIA
