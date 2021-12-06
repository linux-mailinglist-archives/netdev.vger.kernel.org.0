Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FDD46A090
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347027AbhLFQFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:05:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37152 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387552AbhLFP6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:58:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F8596123D;
        Mon,  6 Dec 2021 15:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08F0C341C2;
        Mon,  6 Dec 2021 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638806115;
        bh=WOFb9frdNx9ZU7zvR2O9esEMCMjxHjvz8qO/ktCZAxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pJBJt1nDyNC7wf4r0UOwS4mNhbi7frbyF+pjJ6xJXTyIiSUDNrkEOjnxLvWGlyZt+
         kxUwesXFYUs5A4yRzNlddLqcYTXb332hiNw8Pc8foRucwiFoYhQyPQ6+QjO03F8qIr
         aQRG4KOxO3lNkuAh+BUIc3Azop9ez+gqT8o4MzVE5xUBR6FZ3q+wGUP6yWw0S2sgOC
         D8nLVS5kvhSTKBrxSXlAbkuUH05CsDtfHluRnERYivNYyMklqSPwsAk5pAOm1aUDWu
         VUP26dSlI5C3Vu/kX2VSMNa2dLLD79lneVDCivgRGbk045CkU85V2vHozLDWEDugS2
         le3VzKo5xJEag==
Date:   Mon, 6 Dec 2021 07:55:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <mptcp@lists.linux.dev>, syzkaller-bugs@googlegroups.com,
        <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com
Subject: Re: [PATCH mptcp] mptcp: remove tcp ulp setsockopt support
Message-ID: <20211206075515.3cf5b0df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206075326.700f2078@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <00000000000040972505d24e88e3@google.com>
        <20211205192700.25396-1-fw@strlen.de>
        <20211206075326.700f2078@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 07:53:26 -0800 Jakub Kicinski wrote:
> On Sun,  5 Dec 2021 20:27:00 +0100 Florian Westphal wrote:
> > TCP_ULP setsockopt cannot be used for mptcp because its already
> > used internally to plumb subflow (tcp) sockets to the mptcp layer.
> > 
> > syzbot managed to trigger a crash for mptcp connections that are
> > in fallback mode:  
> 
> Fallback mode meaning ops are NULL? I'm slightly confused by this
> report.

Ah, it's the socket not the ops.

> > KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> > CPU: 1 PID: 1083 Comm: syz-executor.3 Not tainted 5.16.0-rc2-syzkaller #0
> > RIP: 0010:tls_build_proto net/tls/tls_main.c:776 [inline]
> > [..]
> >  __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
> >  tcp_set_ulp+0x428/0x4c0 net/ipv4/tcp_ulp.c:160
> >  do_tcp_setsockopt+0x455/0x37c0 net/ipv4/tcp.c:3391
> >  mptcp_setsockopt+0x1b47/0x2400 net/mptcp/sockopt.c:638
> > 
> > Remove support for TCP_ULP setsockopt.
> > 
> > Reported-by: syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com
> > Signed-off-by: Florian Westphal <fw@strlen.de>  

