Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D1C284836
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgJFIQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgJFIQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 04:16:07 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F79A2078E;
        Tue,  6 Oct 2020 08:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601972166;
        bh=rykVwVTmBmGpcopd950wK1or7+3AVRiWL9lnV+qoF7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o77EsqhavPejEmO43Ssll9DR6fqoHpJ/c6F8EFR9+nKzkQUdXFcJVmoaiWd/8R5MZ
         6y0ZO7lbnydq6jFBc9K5Q5YEfrMhw4YIeo68vvbHj3wha8m2AIi3EZNtxUDQZ9/pNR
         B/wNFa6wH6pBsEhztXrqAJT2wIXhVpN9O4d+oP60=
Date:   Tue, 6 Oct 2020 09:16:00 +0100
From:   Will Deacon <will@kernel.org>
To:     syzbot <syzbot+45d7c243c006f39dc55a@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        catalin.marinas@arm.com, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, will.deacon@arm.com,
        zlim.lnx@gmail.com
Subject: Re: WARNING in sta_info_alloc
Message-ID: <20201006081559.GA25187@willie-the-truck>
References: <00000000000055e16405b0fc1a90@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000055e16405b0fc1a90@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 01:08:23AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    549738f1 Linux 5.9-rc8
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b97ba3900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c06bcf3cc963d91c
> dashboard link: https://syzkaller.appspot.com/bug?extid=45d7c243c006f39dc55a
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bae9c0500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1099b1c0500000
> 
> The issue was bisected to:
> 
> commit 643c332d519bdfbf80d21f40d1c0aa0ccf3ec1cb
> Author: Zi Shen Lim <zlim.lnx@gmail.com>
> Date:   Thu Jun 9 04:18:50 2016 +0000
> 
>     arm64: bpf: optimize LD_ABS, LD_IND
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d44477900000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13d44477900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15d44477900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+45d7c243c006f39dc55a@syzkaller.appspotmail.com
> Fixes: 643c332d519b ("arm64: bpf: optimize LD_ABS, LD_IND")
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6879 at net/mac80211/ieee80211_i.h:1447 ieee80211_get_sband net/mac80211/ieee80211_i.h:1447 [inline]
> WARNING: CPU: 0 PID: 6879 at net/mac80211/ieee80211_i.h:1447 sta_info_alloc+0x1900/0x1f90 net/mac80211/sta_info.c:469
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 6879 Comm: syz-executor071 Not tainted 5.9.0-rc8-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x198/0x1fd lib/dump_stack.c:118
>  panic+0x382/0x7fb kernel/panic.c:231
>  __warn.cold+0x20/0x4b kernel/panic.c:600
>  report_bug+0x1bd/0x210 lib/bug.c:198
>  handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
>  exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
> RIP: 0010:ieee80211_get_sband net/mac80211/ieee80211_i.h:1447 [inline]

The patch fingered by the bisection only affects arm64, but this is an x86
box. So this is clearly bogus.

Will
