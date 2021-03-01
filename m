Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E601C3281D5
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhCAPJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:09:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236896AbhCAPIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:08:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614611242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3CcxvPbENRoxnpPYUhLzxCww37f6skYKB+CD+PRX/BM=;
        b=Ch2p7rc+kWj9s4Ru6vmKLAg2TTFvdLa2rE9d5VvlNeLzl3KPHQjHQg+sBCXjEGESsZgCJI
        Um2gy+41xkW9qqgOgy7nsgV2tjMIDCNCufXpXof0zvhG+qnEaialdvecSarIq9dH4P+ijF
        Lyz/ZjQgukuHhNg3dYBtHjDxkPfa3oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-t7bwRF9dOFm6QxJxl1AHCQ-1; Mon, 01 Mar 2021 10:07:18 -0500
X-MC-Unique: t7bwRF9dOFm6QxJxl1AHCQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8B47107ACE6;
        Mon,  1 Mar 2021 15:07:15 +0000 (UTC)
Received: from ovpn-114-130.ams2.redhat.com (ovpn-114-130.ams2.redhat.com [10.36.114.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AC695C3E5;
        Mon,  1 Mar 2021 15:07:12 +0000 (UTC)
Message-ID: <51bd5e035546937b8c46264b52e149f0331d0b60.camel@redhat.com>
Subject: Re: possible deadlock in ipv6_sock_mc_close
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chuck Lever <chuck.lever@oracle.com>,
        syzbot <syzbot+e2fa57709a385e6db10f@syzkaller.appspotmail.com>
Cc:     Bruce Fields <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Date:   Mon, 01 Mar 2021 16:07:11 +0100
In-Reply-To: <974A6057-4DE8-4C9A-A71E-4EC08BD8E81B@oracle.com>
References: <0000000000001d8e2c05bc79e2fd@google.com>
         <974A6057-4DE8-4C9A-A71E-4EC08BD8E81B@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2021-03-01 at 14:52 +0000, Chuck Lever wrote:
> > On Mar 1, 2021, at 8:49 AM, syzbot <syzbot+e2fa57709a385e6db10f@syzkaller.appspotmail.com> wrote:
> > 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    eee7ede6 Merge branch 'bnxt_en-error-recovery-bug-fixes'
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=123ad632d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e2d5ba72abae4f14
> > dashboard link: https://syzkaller.appspot.com/bug?extid=e2fa57709a385e6db10f
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109d89b6d00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e9e0dad00000
> > 
> > The issue was bisected to:
> > 
> > commit c8e88e3aa73889421461f878cd569ef84f231ceb
> > Author: Chuck Lever <chuck.lever@oracle.com>
> > Date:   Tue Nov 3 20:06:04 2020 +0000
> > 
> >    NFSD: Replace READ* macros in nfsd4_decode_layoutget()
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13bef9ccd00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=107ef9ccd00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17bef9ccd00000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+e2fa57709a385e6db10f@syzkaller.appspotmail.com
> > Fixes: c8e88e3aa738 ("NFSD: Replace READ* macros in nfsd4_decode_layoutget()")
> > 
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > 5.11.0-syzkaller #0 Not tainted
> > ------------------------------------------------------
> > syz-executor905/8822 is trying to acquire lock:
> > ffffffff8d678fe8 (rtnl_mutex){+.+.}-{3:3}, at: ipv6_sock_mc_close+0xd7/0x110 net/ipv6/mcast.c:323
> > 
> > but task is already holding lock:
> > ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
> > ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/0x130 net/mptcp/protocol.c:3507
> > 
> > which lock already depends on the new lock.
> 
> Hi, thanks for the report.
> 
> Initial analysis:
> 
> c8e88e3aa738 ("NFSD: Replace READ* macros in nfsd4_decode_layoutget()"
> changes code several layers above the network layer. In addition,
> neither of the stack traces contain NFSD functions. And, repro.c does
> not appear to exercise any filesystem code.
> 
> Therefore the bisect result looks implausible to me. I don't see any
> obvious connection between the lockdep splat and c8e88e3aa738. (If
> someone else does, please let me know where to look).

I agree the bisect result is unexpected.

This looks really as an MPTCP-specific issue, likely introduced by:

32fcc880e0a9 ("mptcp: provide subflow aware release function")

and should be fixed inside MPTCP.

Cheers,

Paolo

