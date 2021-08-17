Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27533EF515
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 23:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbhHQVia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 17:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231630AbhHQVi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 17:38:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF01161038;
        Tue, 17 Aug 2021 21:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629236274;
        bh=cJB26lZt5KTsxrHp0+aF8VOT1MIp+6ZNovI10dwqg1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QfSCyPTpc7fTQfm5SlrZxuzDWIxX/myIlVKcGbkynlU0lHF5H3VxDBvlRY7R7lP6K
         yXC9Wcly+2jLxVa0ppuayj0axE6Ja9FEhDPUOj79W99v0CMsk6kydhRloYWsdXyJNj
         vWWmvQPrv8Pt7LbQX5FRhRKbv+cmsQNUupUBDvPbHSGf3/ftlTiEcFMgQ8ccyYbvBs
         lDIq1hwMVVCgizJKPnIiPh6MwOkRhfY4fUwBE9tEtSr+ah66N3wbfiDVasMaIftWqj
         B+6iCswSuXmRX3qhK8ySuuO1zE9k7tdiMaYQuJEYO62lddzEgI300nEWMsJj0JMKB5
         ZivAyITou+MBQ==
Date:   Tue, 17 Aug 2021 14:37:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jonas Bechtel <post@jbechtel.de>, netdev@vger.kernel.org
Subject: Re: ss command not showing raw sockets? (regression)
Message-ID: <20210817143753.30f21bb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <af485441-123b-4f50-f01b-cee2612b9218@gmail.com>
References: <20210815231738.7b42bad4@mmluhan>
        <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817202135.6b42031f@mmluhan>
        <20210817114402.78463d9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <af485441-123b-4f50-f01b-cee2612b9218@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 13:54:53 -0600 David Ahern wrote:
> On 8/17/21 12:44 PM, Jakub Kicinski wrote:
> >> @kuba With PROC_NET_RAW I consider the problem is found, isn't it? So
> >> I will not download/bisect<->build or otherwise investigate the
> >> problem until one of you explicitely asks me to do so.
> >>
> >> I have now redirected invocation of command with set PROC_NET_RAW on
> >> my system, and may (try to) update to Linux 4.19.  
> > 
> > I suspect the bisection would end up at the commit which added 
> > the netlink dump support, so you can hold off for now, yes.  
> 
> agreed.
> > 
> > My best guess right now is that Knoppix has a cut-down kernel 
> > config and we don't handle that case correctly.
> >   
> 
> CONFIG_INET_RAW_DIAG (or INET_DIAG) is probably disabled. surprised the
> netlink dump does not return an error and it falls back to the proc file:
> 
>         if (!getenv("PROC_NET_RAW") && !getenv("PROC_ROOT") &&
>             inet_show_netlink(f, NULL, IPPROTO_RAW) == 0)
>                 return 0;
> 
> can you strace it?

Ah, good point, strace will show it. 

/me goes off to look at the strace Jonas sent off list.

Well this is unexpected:

sendmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=76, type=DCCPDIAG_GETSOCK, ...

--->8----------------

From: Jakub Kicinski <kuba@kernel.org>
Subject: ss: fix fallback to procfs for raw and sctp sockets

sockdiag_send() diverts to tcpdiag_send() to try the older
netlink interface. tcpdiag_send() works for TCP and DCCP
but not other protocols. Instead of rejecting unsupported
protocols (and missing RAW and SCTP) match on supported ones.

Fixes: 41fe6c34de50 ("ss: Add inet raw sockets information gathering via netlink diag interface")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 misc/ss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 894ad40574f1..b39f63fe3b17 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -3404,13 +3404,13 @@ static int tcpdiag_send(int fd, int protocol, struct filter *f)
 	struct iovec iov[3];
 	int iovlen = 1;
 
-	if (protocol == IPPROTO_UDP || protocol == IPPROTO_MPTCP)
-		return -1;
-
 	if (protocol == IPPROTO_TCP)
 		req.nlh.nlmsg_type = TCPDIAG_GETSOCK;
-	else
+	else if (protocol == IPPROTO_DCCP)
 		req.nlh.nlmsg_type = DCCPDIAG_GETSOCK;
+	else
+		return -1;
+
 	if (show_mem) {
 		req.r.idiag_ext |= (1<<(INET_DIAG_MEMINFO-1));
 		req.r.idiag_ext |= (1<<(INET_DIAG_SKMEMINFO-1));
-- 
2.31.1

