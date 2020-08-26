Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93560252C06
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgHZLDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 07:03:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56724 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbgHZLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 07:03:12 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598439782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZaAkTdOab/XFooWlber6W3bQre4hvoIBpg4is6GPMvI=;
        b=onrC78SbMNK189bx5B9J/G6s8NfSzOML8/QswGPLaM7CNLUadKjp4RZkqQj1RpwAnqf9ND
        WHrr0sfogurwO1T9+nL2EocVhhdSgZ0KPGI/iuexx/2JUw0YevIydPq4BgtmRVhBYRr2H9
        kzNgRK7OBnzZ3BpBp2bRNNIjEyY+2G0JVleePH9tjONso7qd32vc+4yxT0SovbmgDtn7kX
        BJpgVC6m9/waC/lQVCd9lNZKfx7RbcHmiwjuCHpFim0i4wEaR0GZkqDXWSSOJg7RJpHX5h
        tUQjMpAvUqHIn7Kv266SPEKtJ5Pdfwe2BFa3tlGUAsQUziWsuUenKnL6a4+DPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598439782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZaAkTdOab/XFooWlber6W3bQre4hvoIBpg4is6GPMvI=;
        b=PfZ2hYH1I2ewe0aCaU53HrJiEJCFqmFzJ7d2d3J0q6ZM3xseBlhIbp4F8hJcGr9lQ4766W
        KACq5LU557imvSAA==
To:     syzbot <syzbot+51c9bdfa559769d2f897@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, anna.schumaker@netapp.com,
        bfields@fieldses.org, bp@alien8.de, davem@davemloft.net,
        douly.fnst@cn.fujitsu.com, hpa@zytor.com, jlayton@kernel.org,
        konrad.wilk@oracle.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        paulmck@kernel.org, peterz@infradead.org, puwen@hygon.cn,
        rafael.j.wysocki@intel.com, syzkaller-bugs@googlegroups.com,
        trond.myklebust@hammerspace.com, trond.myklebust@primarydata.com,
        vbabka@suse.cz, x86@kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: WARNING: ODEBUG bug in __do_softirq
In-Reply-To: <000000000000e7fab005adc3f636@google.com>
References: <000000000000e7fab005adc3f636@google.com>
Date:   Wed, 26 Aug 2020 13:03:02 +0200
Message-ID: <87v9h5vfdl.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26 2020 at 01:54, syzbot wrote:

Cc+: David Howells

> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    3a00d3df Add linux-next specific files for 20200825
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15080fa9900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9ef0a5f95935d447
> dashboard link: https://syzkaller.appspot.com/bug?extid=51c9bdfa559769d2f897
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17927a2e900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132b8ede900000
>
> The issue was bisected to:
>
> commit 5b317cbf2bcb85a1e96ce87717cb991ecab1dd4d
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Fri Feb 22 09:17:11 2019 +0000
>
>     Merge branch 'pm-cpufreq-fixes'
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=171ead5d200000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=149ead5d200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=109ead5d200000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+51c9bdfa559769d2f897@syzkaller.appspotmail.com
> Fixes: 5b317cbf2bcb ("Merge branch 'pm-cpufreq-fixes'")
>
> ------------[ cut here ]------------
> ODEBUG: free active (active state 0) object type: work_struct hint: afs_manage_cell+0x0/0x11c0 fs/afs/cell.c:498

AFS is leaking an active work struct in a to be freed data struct.

Thanks,

        tglx
