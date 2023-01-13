Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BFA66955C
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 12:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbjAMLS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 06:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241363AbjAMLSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 06:18:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000C817412;
        Fri, 13 Jan 2023 03:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rk/Db5xfRP5hEJ7KyR6IvT3Xu96m6dQD5p6pRluPUec=; b=S3HO6t44KzH7KanCgiQZxN5hax
        SJlP/FmY/Z1lePMohijreZnM4fCqpDTeZNq25HGp5KehbDUt06w7RtpVt3CkSbjFj6ZJSXJS86jyq
        siax/B0xB1FKaVxlYUJV0Ek3Iuhk6/tQPBWSPJSxOrjSrrfK19D0+x7TM/2nhMn+Hw/S4nlCwE+xz
        7k789nQ2JSG3llxVzQdnvh9Pu76MYXx3x+XDUAAjG7c6vG+GWR77enR6IN16wH4RvCHE6p3nynwBn
        hcbULbhkXPO30Na1ztXf8DsDgBMB/eyDps19H/+CJsLLIOZVMZC5fdG7YuQkkpUrqlGfULbXs/vV+
        yeczVvVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36086)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pGHzX-0007jE-CA; Fri, 13 Jan 2023 11:12:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pGHzW-000375-1d; Fri, 13 Jan 2023 11:12:58 +0000
Date:   Fri, 13 Jan 2023 11:12:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: 6.1: possible bug with netfilter conntrack?
Message-ID: <Y8E8uX9gLBBywmf5@shell.armlinux.org.uk>
References: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
 <Y8CaaCoOAx6XzWq/@shell.armlinux.org.uk>
 <20230112234503.GB19463@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112234503.GB19463@breakpoint.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 12:45:03AM +0100, Florian Westphal wrote:
> Russell King (Oracle) <linux@armlinux.org.uk> wrote:
> > Given the packet counts as per my example above, it looks like
> > conntrack only saw:
> > 
> > src=180.173.2.183 dst=78.32.30.218	SYN
> > src=78.32.30.218 dst=180.173.2.183	SYN+ACK
> > src=180.173.2.183 dst=78.32.30.218	ACK
> > 
> > and I suspect at that point, the connection went silent - until
> > Exim timed out and closed the connection, as does seem to be the
> > case:
> > 
> > 2023-01-11 21:32:04 no host name found for IP address 180.173.2.183
> > 2023-01-11 21:33:05 SMTP command timeout on connection from [180.173.2.183]:64332 I=[78.32.30.218]:25
> > 
> > but if Exim closed the connection, why didn't conntrack pick it up?
> 
> Yes, thats the question.  Exim closing the connection should have
> conntrack at least pick up a fin packet from the mail server (which
> should move the entry to the 2 minute fin timeout).

Okay, update this morning. I left tcpdump running overnight having
cleared conntrack of all port 25 and 587 connections. This morning,
there's a whole bunch of new entries on conntrack.

Digging through the tcpdump and logs, it seems what is going on is:

public interface			dmz interface
origin -> mailserver SYN		origin -> mailserver SYN
mailserver -> origin SYNACK		mailserver -> origin SYNACK
origin -> mailserver ACK
mailserver -> origin RST
mailserver -> origin SYNACK		mailserver -> origin SYNACK
mailserver -> origin SYNACK		mailserver -> origin SYNACK
mailserver -> origin SYNACK		mailserver -> origin SYNACK
mailserver -> origin SYNACK		mailserver -> origin SYNACK
...

Here is an example from the public interface:

09:52:36.599398 IP 103.14.225.112.63461 > 78.32.30.218.587: Flags [SEW], seq 3387227814, win 8192, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
09:52:36.599893 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1452,nop,nop,sackOK,nop,wscale 7], length 0
09:52:36.820464 IP 103.14.225.112.63461 > 78.32.30.218.587: Flags [.], ack 1, win 260, length 0
09:52:36.820549 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [R], seq 816385330, win 0, length 0
09:52:37.637548 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1452,nop,nop,sackOK,nop,wscale 7], length 0

and the corresponding trace on the mailserver:
09:52:36.599729 IP 103.14.225.112.63461 > 78.32.30.218.587: Flags [SEW], seq 3387227814, win 8192, options [mss 1452,nop,wscale 8,nop,nop,sackOK], length 0
09:52:36.599772 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
09:52:37.637421 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0

So, my first observation is that conntrack is reacting to the ACK
packet on the public interface, and marking the connection established,
but a firewall rule is rejecting the connection when that ACK packet is
received by sending a TCP reset. It looks like conntrack does not see 
this packet, and also conntrack does not see the SYNACK retransmissions
(which is odd, because it saw the first one.)

As to why we're responding with a TCP reset to the ACK packet, it's
because iptables is hitting a reject rule as the IP address has been
temporarily banned due to preceding known spammer signatures a few
seconds before.

I probably ought to pick up on the initial SYN rather than the 3rd
packet of the connection... but even so, I don't think conntrack
should be missing the TCP reset from the reject rule.

The rule path that leads to the reject rule is currently:
  -A TCP -p tcp -m multiport --dports 25,587 -m conntrack --ctstate ESTABLISHED -j TCP-smtp-in
  -A TCP-smtp-in -p tcp -m set --match-set ip4-banned-smtp src -j TCP-smtp-s
  -A TCP-smtp-s -j SET --add-set ip4-banned-smtp src --exist --timeout N
  -A TCP-smtp-s -p tcp -j REJECT --reject-with tcp-reset

(I've omitted the timeout.)

There definitely seems to be a change in behaviour - looking back to
the logs prior to upgrading to 6.1, there were never any conntrack
table overflows, and that older kernel had been running for hundreds
of days.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
