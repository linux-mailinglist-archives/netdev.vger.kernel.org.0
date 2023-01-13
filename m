Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E73668850
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbjAMAVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbjAMAUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:20:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25036671B1;
        Thu, 12 Jan 2023 16:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SYbG/8N9ErbjViYnu7EiBZn310fX/7/4xAw1q8PMG7o=; b=GjQScXq/c0QbBUryLlGecDs+js
        dJ5KeAonx+R6mdr6BTmqMGkPF8G66DQ3NQwehDg9Om8PMewBE14IUqGxzuCU1Ce4lbxR5bUHrMghz
        wCs6pRdhx1wAYWdFSHSW7d39gZrz0VEfE5l6Q5CthB9yAh5cWgs/hmyPKV86xXwkW9QUrPxIyN7zY
        ybu2L9ajG81/3dyAzEsAXsiOnHXhWG74fI9ta6StNb74sm7VAvS7rfzDI2+GEa/6ZgCAbqR4/FZvW
        vDWEtZcQCsy6TVZuBgwe0kDzlBxe7z+a9dzh05LtvcvdYMjZnLHmCngIQ+nDWDpefowHr406V5stx
        1eSHmuUQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36078)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pG7kG-00079x-HR; Fri, 13 Jan 2023 00:16:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pG7kF-0002dd-J0; Fri, 13 Jan 2023 00:16:31 +0000
Date:   Fri, 13 Jan 2023 00:16:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: 6.1: possible bug with netfilter conntrack?
Message-ID: <Y8Ci39eQNgqkTe4j@shell.armlinux.org.uk>
References: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
 <20230112233808.GA19463@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112233808.GA19463@breakpoint.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Thanks for the quick reply.

On Fri, Jan 13, 2023 at 12:38:08AM +0100, Florian Westphal wrote:
> Russell King (Oracle) <linux@armlinux.org.uk> wrote:
> > Hi,
> > 
> > I've noticed that my network at home is rather struggling, and having
> > done some investigation, I find that the router VM is dropping packets
> > due to lots of:
> > 
> > nf_conntrack: nf_conntrack: table full, dropping packet
> > 
> > I find that there are about 2380 established and assured connections
> > with a destination of my incoming mail server with destination port 25,
> > and 2 packets. In the reverse direction, apparently only one packet was
> > sent according to conntrack. E.g.:
> > 
> > tcp      6 340593 ESTABLISHED src=180.173.2.183 dst=78.32.30.218
> > sport=49694 dport=25 packets=2 bytes=92 src=78.32.30.218
> > dst=180.173.2.183 sport=25 dport=49694 packets=1 bytes=44 [ASSURED]
> > use=1
> 
> Non-early-evictable entry that will expire in ~4 days, so not really
> surprising that this eventually fills the table.
> 
> I'd suggest to reduce the
> net.netfilter.nf_conntrack_tcp_timeout_established
> sysctl to something more sane, e.g. 2 minutes or so unless you need
> to have longer timeouts.
> 
> But this did not change, so not the root cause of this problem.

I'll hold off trying that for now - I do tend to have some connections
that may be idle...

> > However, if I look at the incoming mail server, its kernel believes
> > there are no incoming port 25 connetions, which matches exim.
> > 
> > I hadn't noticed any issues prior to upgrading from 5.16 to 6.1 on the
> > router VM, and the firewall rules have been the same for much of
> > 2021/2022.
> >
> > Is this is known issue? Something changed between 5.16 and 6.1 in the
> > way conntrack works?
> 
> Nothing that should have such an impact.
> 
> Does 'sysctl net.netfilter.nf_conntrack_tcp_loose=0' avoid the buildup
> of such entries? I'm wondering if conntrack misses the connection
> shutdown or if its perhaps triggering the entries because of late
> packets or similar.
> 
> If that doesn't help. you could also check if
> 
> 'sysctl net.netfilter.nf_conntrack_tcp_be_liberal=1' helps -- if it
> does, its time for more debugging but its too early to start digging
> atm.  This would point at conntrack ignoring/discarding fin/reset
> packets.

I think first I need to work out how the issue arises, since it seems
to be behaving normally at the moment. I have for example:

$ grep 173.239.196.95 bad-conntrack.log | wc -l
314

and this resolves to 173-239-196-95.azu1ez9l.com. It looks like exim
was happy with that, so would have issued its SMTP banner very shortly
after the connection was established, but all the entries in the
conntrack table show packets=2...packets=1 meaning conntrack only
saw the SYN, SYNACK and ACK packets establishing the connection, but
not the packet sending the SMTP banner which seems mightily weird.

I've just tried this from a machine on the 'net, telneting in to the
SMTP port, the conntrack packet counters increase beyond 2/1, and when
exim times out the connection, the conntrack entry goes away - so
everything seems to work how it should.

Digging through the logs, it looks like the first table-full happened
twice on Dec 30th, just two and a half days after boot. Then eight
times on Jan 10th, and from the 11th at about 11pm, the logs have been
sporadically flooded with the conntrack table full messages.

I'll try to keep an eye on it and dig out something a bit more useful
which may help locate what the issue is, but it seems the trigger
mechanism isn't something obvious.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
