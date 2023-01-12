Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3536687E9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 00:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjALXk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 18:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjALXk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 18:40:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D2A17E1E;
        Thu, 12 Jan 2023 15:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OiDXpnXgpS6WQ5/qI/Qoqx8Cau26pqIbPmCSXyhsuj0=; b=vo2M9lmuwOjnaslNqoMg3+5CSx
        IIXpUfjcUjf/dP6CT1TQY+r8XYl+SAygrClHmtNUi5jzcek/mowD2Mx8NW9m61KVcuMAYDbN8uUEf
        ic8XDDaw2L2puxyU5Y1tX71Q+a3OSJoOBGqEFiZZgvUCiHsv2bCyG6ataFq3sMLRCmlUn42zWQWWg
        SjjD7s+y/4AyXb00lUZIJpIcWmRk8UMcepO+5/kMskGgI1wYDwz3tNG4lk6pcwkUgJ3+suvJd6q+X
        Ni4OMHuyKDeom3lDKSe9f3As7ukvc/QexBtZ0/Btjmbb/nD0Z9l0KElhG82RJRv47elCC5bJnyAOI
        +GMiOfCQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36076)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pG7BJ-00078N-SG; Thu, 12 Jan 2023 23:40:25 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pG7BI-0002bU-Ts; Thu, 12 Jan 2023 23:40:24 +0000
Date:   Thu, 12 Jan 2023 23:40:24 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: 6.1: possible bug with netfilter conntrack?
Message-ID: <Y8CaaCoOAx6XzWq/@shell.armlinux.org.uk>
References: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:03:56PM +0000, Russell King (Oracle) wrote:
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
> 
> However, if I look at the incoming mail server, its kernel believes
> there are no incoming port 25 connetions, which matches exim.
> 
> I hadn't noticed any issues prior to upgrading from 5.16 to 6.1 on the
> router VM, and the firewall rules have been the same for much of
> 2021/2022.
> 
> Is this is known issue? Something changed between 5.16 and 6.1 in the
> way conntrack works?
> 
> I'm going to be manually clearing the conntrack table so stuff works
> again without lots of packet loss on my home network...
> 
> Thanks.

Having cleared out all the dport=25 and dport=587 entries, and
observation there after, it looks like conntrack generally works
as one would expect - I see connections become established, and
then disappear as one expects.

All traffic between the 'net and the mail server goes through the
router VM in both directions - there is no asymetry there (the
mail server is on a DMZ network which is only routed within the
router VM to the PPP interfaces also in the router VM for the
public network.) So, conntrack will be aware of every packet in
both directions.

I do see conntrack entries entering TIME_WAIT, LAST_ACK, CLOSE
etc.

Given the packet counts as per my example above, it looks like
conntrack only saw:

src=180.173.2.183 dst=78.32.30.218	SYN
src=78.32.30.218 dst=180.173.2.183	SYN+ACK
src=180.173.2.183 dst=78.32.30.218	ACK

and I suspect at that point, the connection went silent - until
Exim timed out and closed the connection, as does seem to be the
case:

2023-01-11 21:32:04 no host name found for IP address 180.173.2.183
2023-01-11 21:33:05 SMTP command timeout on connection from [180.173.2.183]:64332 I=[78.32.30.218]:25

but if Exim closed the connection, why didn't conntrack pick it up?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
