Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B683404052
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 22:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350635AbhIHUwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 16:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhIHUwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 16:52:13 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8305C061575;
        Wed,  8 Sep 2021 13:51:04 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 473C669C3; Wed,  8 Sep 2021 16:51:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 473C669C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1631134263;
        bh=Rsr8yhVwiPXAd+PHqS4Ee2gc2en0YgpekPyCT9JDLz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AG6HtQGpBu/qrIDH/pa46CTseZpfnQxz9iVFCVtOKplxZXjIHf5VVXNVgp/IxAvya
         B3aMND26lRgQDI/J4DAtJhD/yTlUrYEmShEzvggkn6ITF+TZs/ftLiq3yChyH8vg7Z
         vSTWKeer7FWRoJFLlwsm1OuzVJKPsyrpP9djQprM=
Date:   Wed, 8 Sep 2021 16:51:03 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     "wanghai (M)" <wanghai38@huawei.com>
Cc:     Wenbin Zeng <wenbin.zeng@gmail.com>, viro@zeniv.linux.org.uk,
        davem@davemloft.net, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] auth_gss: netns refcount leaks when
 use-gss-proxy==1
Message-ID: <20210908205103.GE23978@fieldses.org>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
 <20190515010331.GA3232@fieldses.org>
 <20190612083755.GA27776@bridge.tencent.com>
 <20190612155224.GF16331@fieldses.org>
 <2c9e3d91-f4b3-6f6a-0dc0-21cef4fab3bb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c9e3d91-f4b3-6f6a-0dc0-21cef4fab3bb@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 10:48:52PM +0800, wanghai (M) wrote:
> 
> 在 2019/6/12 23:52, J. Bruce Fields 写道:
> >On Wed, Jun 12, 2019 at 04:37:55PM +0800, Wenbin Zeng wrote:
> >>On Tue, May 14, 2019 at 09:03:31PM -0400, J. Bruce Fields wrote:
> >>>Whoops, I was slow to test these.  I'm getting failuring krb5 nfs
> >>>mounts, and the following the server's logs.  Dropping the three patches
> >>>for now.
> >>My bad, I should have found it earlier. Thank you for testing it, Bruce.
> >>
> >>I figured it out, the problem that you saw is due to the following code:
> >>the if-condition is incorrect here because sn->gssp_clnt==NULL doesn't mean
> >>inexistence of 'use-gss-proxy':
> >Thanks, but with the new patches I see the following.  I haven't tried
> >to investigate.
> This patchset adds the nsfs_evict()->netns_evict() code for breaking
> deadlock bugs that exist, but this may cause double free because
> nsfs_evict()->netns_evict() may be called multiple times.
> 
> for example:
> 
> int main()
> {
>     int fd = open("/proc/self/ns/net", O_RDONLY);
>     close(fd);
> 
>     fd = open("/proc/self/ns/net", O_RDONLY);
>     close(fd);
> }
> 
> Therefore, the nsfs evict cannot be used to break the deadlock.

Sorry, I haven't really been following this, but I though this problem
was fixed by your checking for gssp_clnt (instead of just relying on the
use_gssp_proc check) in v3 of your patches?

--b.

> 
> A large number of netns leaks may cause OOM problems, currently I
> can't find a good solution to fix it, does anyone have a good idea?
> >--b.
> >
> >[ 2908.134813] ------------[ cut here ]------------
> >[ 2908.135732] name 'use-gss-proxy'
> >[ 2908.136276] WARNING: CPU: 2 PID: 15032 at fs/proc/generic.c:673 remove_proc_entry+0x124/0x190
> >[ 2908.138144] Modules linked in: nfsv4 rpcsec_gss_krb5 nfsv3 nfs_acl nfs lockd grace auth_rpcgss sunrpc
> >[ 2908.140183] CPU: 2 PID: 15032 Comm: (coredump) Not tainted 5.2.0-rc2-00441-gaef575f54640 #2257
> >[ 2908.142062] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
> >[ 2908.143756] RIP: 0010:remove_proc_entry+0x124/0x190
> >[ 2908.144519] Code: c3 48 c7 c7 60 24 8b 82 e8 29 16 a5 00 eb d5 48 c7 c7 60 24 8b 82 e8 1b 16 a5 00 4c 89 e6 48 c7 c7 ec 4c 52 82 e8 50 fd db ff <0f> 0b eb b6 48 8b 04 24 83 a8 90 00 00 00 01 e9 78 ff ff ff 4c 89
> >[ 2908.148138] RSP: 0018:ffffc900047bbdb0 EFLAGS: 00010282
> >[ 2908.148945] RAX: 0000000000000000 RBX: ffff888036060580 RCX: 0000000000000000
> >[ 2908.150139] RDX: ffff88807fd24e80 RSI: ffff88807fd165b8 RDI: 00000000ffffffff
> >[ 2908.151334] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> >[ 2908.152564] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa00adb1b
> >[ 2908.153816] R13: 00007ffc8bda5d30 R14: 0000000000000000 R15: ffff88805e2873a8
> >[ 2908.155007] FS:  00007f470bc27e40(0000) GS:ffff88807fd00000(0000) knlGS:0000000000000000
> >[ 2908.156421] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[ 2908.157333] CR2: 0000562b07764c58 CR3: 000000005e8ea001 CR4: 00000000001606e0
> >[ 2908.158529] Call Trace:
> >[ 2908.158796]  destroy_use_gss_proxy_proc_entry+0xb7/0x150 [auth_rpcgss]
> >[ 2908.159966]  gss_svc_shutdown_net+0x11/0x170 [auth_rpcgss]
> >[ 2908.160830]  netns_evict+0x2f/0x40
> >[ 2908.161266]  nsfs_evict+0x27/0x40
> >[ 2908.161685]  evict+0xd0/0x1a0
> >[ 2908.162035]  __dentry_kill+0xdf/0x180
> >[ 2908.162520]  dentry_kill+0x50/0x1c0
> >[ 2908.163005]  ? dput+0x1c/0x2b0
> >[ 2908.163369]  dput+0x260/0x2b0
> >[ 2908.163739]  path_put+0x12/0x20
> >[ 2908.164155]  do_faccessat+0x17c/0x240
> >[ 2908.164643]  do_syscall_64+0x50/0x1c0
> >[ 2908.165170]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >[ 2908.165959] RIP: 0033:0x7f47098e2157
> >[ 2908.166445] Code: 77 01 c3 48 8b 15 69 dd 2c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 15 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 39 dd 2c 00 f7 d8 64 89 02 b8
> >[ 2908.169994] RSP: 002b:00007ffc8bda5d28 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
> >[ 2908.171315] RAX: ffffffffffffffda RBX: 0000562b0774d979 RCX: 00007f47098e2157
> >[ 2908.172563] RDX: 00007ffc8bda5d3e RSI: 0000000000000000 RDI: 00007ffc8bda5d30
> >[ 2908.173753] RBP: 00007ffc8bda5d70 R08: 0000000000000000 R09: 0000562b07d0b130
> >[ 2908.174943] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc8bda5d30
> >[ 2908.176163] R13: 0000562b07b34c80 R14: 0000562b07b35120 R15: 0000000000000000
> >[ 2908.177395] irq event stamp: 4256
> >[ 2908.177835] hardirqs last  enabled at (4255): [<ffffffff811221ee>] console_unlock+0x41e/0x590
> >[ 2908.179378] hardirqs last disabled at (4256): [<ffffffff81001b2f>] trace_hardirqs_off_thunk+0x1a/0x1c
> >[ 2908.181031] softirqs last  enabled at (4252): [<ffffffff820002be>] __do_softirq+0x2be/0x4aa
> >[ 2908.182458] softirqs last disabled at (4233): [<ffffffff810bf8e0>] irq_exit+0x80/0x90
> >[ 2908.183869] ---[ end trace d88132b63efc09d8 ]---
> >[ 2908.184620] BUG: kernel NULL pointer dereference, address: 0000000000000030
> >[ 2908.185829] #PF: supervisor read access in kernel mode
> >[ 2908.186924] #PF: error_code(0x0000) - not-present page
> >[ 2908.187887] PGD 0 P4D 0
> >[ 2908.188318] Oops: 0000 [#1] PREEMPT SMP PTI
> >[ 2908.189254] CPU: 2 PID: 15032 Comm: (coredump) Tainted: G        W         5.2.0-rc2-00441-gaef575f54640 #2257
> >[ 2908.192506] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
> >[ 2908.195137] RIP: 0010:__lock_acquire+0x3d2/0x1d90
> >[ 2908.196414] Code: db 48 8b 84 24 88 00 00 00 65 48 33 04 25 28 00 00 00 0f 85 be 10 00 00 48 8d 65 d8 44 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <48> 81 3f 60 0d 01 83 41 bb 00 00 00 00 45 0f 45 d8 83 fe 01 0f 87
> >[ 2908.202720] RSP: 0018:ffffc900047bbc80 EFLAGS: 00010002
> >[ 2908.204165] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> >[ 2908.206125] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000030
> >[ 2908.208203] RBP: ffffc900047bbd40 R08: 0000000000000001 R09: 0000000000000000
> >[ 2908.210219] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88807ad91500
> >[ 2908.211386] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000282
> >[ 2908.212532] FS:  00007f470bc27e40(0000) GS:ffff88807fd00000(0000) knlGS:0000000000000000
> >[ 2908.213647] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[ 2908.214400] CR2: 0000000000000030 CR3: 000000005e8ea001 CR4: 00000000001606e0
> >[ 2908.215393] Call Trace:
> >[ 2908.215589]  ? __lock_acquire+0x255/0x1d90
> >[ 2908.216071]  ? clear_gssp_clnt+0x1b/0x50 [auth_rpcgss]
> >[ 2908.216720]  ? __mutex_lock+0x99/0x920
> >[ 2908.217114]  lock_acquire+0x95/0x1b0
> >[ 2908.217484]  ? cache_purge+0x1c/0x110 [sunrpc]
> >[ 2908.218000]  _raw_spin_lock+0x2f/0x40
> >[ 2908.218370]  ? cache_purge+0x1c/0x110 [sunrpc]
> >[ 2908.218882]  cache_purge+0x1c/0x110 [sunrpc]
> >[ 2908.219346]  gss_svc_shutdown_net+0xb8/0x170 [auth_rpcgss]
> >[ 2908.220104]  netns_evict+0x2f/0x40
> >[ 2908.220439]  nsfs_evict+0x27/0x40
> >[ 2908.220786]  evict+0xd0/0x1a0
> >[ 2908.221050]  __dentry_kill+0xdf/0x180
> >[ 2908.221458]  dentry_kill+0x50/0x1c0
> >[ 2908.221842]  ? dput+0x1c/0x2b0
> >[ 2908.222126]  dput+0x260/0x2b0
> >[ 2908.222384]  path_put+0x12/0x20
> >[ 2908.222753]  do_faccessat+0x17c/0x240
> >[ 2908.223125]  do_syscall_64+0x50/0x1c0
> >[ 2908.223479]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >[ 2908.224152] RIP: 0033:0x7f47098e2157
> >[ 2908.224566] Code: 77 01 c3 48 8b 15 69 dd 2c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 15 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 39 dd 2c 00 f7 d8 64 89 02 b8
> >[ 2908.228198] RSP: 002b:00007ffc8bda5d28 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
> >[ 2908.229496] RAX: ffffffffffffffda RBX: 0000562b0774d979 RCX: 00007f47098e2157
> >[ 2908.230938] RDX: 00007ffc8bda5d3e RSI: 0000000000000000 RDI: 00007ffc8bda5d30
> >[ 2908.232182] RBP: 00007ffc8bda5d70 R08: 0000000000000000 R09: 0000562b07d0b130
> >[ 2908.233481] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc8bda5d30
> >[ 2908.234750] R13: 0000562b07b34c80 R14: 0000562b07b35120 R15: 0000000000000000
> >[ 2908.236068] Modules linked in: nfsv4 rpcsec_gss_krb5 nfsv3 nfs_acl nfs lockd grace auth_rpcgss sunrpc
> >[ 2908.237861] CR2: 0000000000000030
> >[ 2908.238277] ---[ end trace d88132b63efc09d9 ]---
