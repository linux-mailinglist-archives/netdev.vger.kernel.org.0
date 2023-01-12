Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856686687E7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 00:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbjALXiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 18:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjALXiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 18:38:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE2EBE0D;
        Thu, 12 Jan 2023 15:38:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pG796-0007RP-9e; Fri, 13 Jan 2023 00:38:08 +0100
Date:   Fri, 13 Jan 2023 00:38:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: 6.1: possible bug with netfilter conntrack?
Message-ID: <20230112233808.GA19463@breakpoint.cc>
References: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King (Oracle) <linux@armlinux.org.uk> wrote:
> Hi,
> 
> I've noticed that my network at home is rather struggling, and having
> done some investigation, I find that the router VM is dropping packets
> due to lots of:
> 
> nf_conntrack: nf_conntrack: table full, dropping packet
> 
> I find that there are about 2380 established and assured connections
> with a destination of my incoming mail server with destination port 25,
> and 2 packets. In the reverse direction, apparently only one packet was
> sent according to conntrack. E.g.:
> 
> tcp      6 340593 ESTABLISHED src=180.173.2.183 dst=78.32.30.218
> sport=49694 dport=25 packets=2 bytes=92 src=78.32.30.218
> dst=180.173.2.183 sport=25 dport=49694 packets=1 bytes=44 [ASSURED]
> use=1

Non-early-evictable entry that will expire in ~4 days, so not really
surprising that this eventually fills the table.

I'd suggest to reduce the
net.netfilter.nf_conntrack_tcp_timeout_established
sysctl to something more sane, e.g. 2 minutes or so unless you need
to have longer timeouts.

But this did not change, so not the root cause of this problem.

> However, if I look at the incoming mail server, its kernel believes
> there are no incoming port 25 connetions, which matches exim.
> 
> I hadn't noticed any issues prior to upgrading from 5.16 to 6.1 on the
> router VM, and the firewall rules have been the same for much of
> 2021/2022.
>
> Is this is known issue? Something changed between 5.16 and 6.1 in the
> way conntrack works?

Nothing that should have such an impact.

Does 'sysctl net.netfilter.nf_conntrack_tcp_loose=0' avoid the buildup
of such entries? I'm wondering if conntrack misses the connection
shutdown or if its perhaps triggering the entries because of late
packets or similar.

If that doesn't help. you could also check if

'sysctl net.netfilter.nf_conntrack_tcp_be_liberal=1' helps -- if it
does, its time for more debugging but its too early to start digging
atm.  This would point at conntrack ignoring/discarding fin/reset
packets.
