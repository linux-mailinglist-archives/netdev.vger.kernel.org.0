Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CF9669816
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbjAMNJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241775AbjAMNIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:08:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265262CB;
        Fri, 13 Jan 2023 04:56:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pGJbh-0003QK-Ls; Fri, 13 Jan 2023 13:56:29 +0100
Date:   Fri, 13 Jan 2023 13:56:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: 6.1: possible bug with netfilter conntrack?
Message-ID: <20230113125629.GD19463@breakpoint.cc>
References: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
 <Y8CaaCoOAx6XzWq/@shell.armlinux.org.uk>
 <20230112234503.GB19463@breakpoint.cc>
 <Y8E8uX9gLBBywmf5@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8E8uX9gLBBywmf5@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King (Oracle) <linux@armlinux.org.uk> wrote:
[..]
> Digging through the tcpdump and logs, it seems what is going on is:
> 
> public interface			dmz interface
> origin -> mailserver SYN		origin -> mailserver SYN
> mailserver -> origin SYNACK		mailserver -> origin SYNACK
> origin -> mailserver ACK
> mailserver -> origin RST
> mailserver -> origin SYNACK		mailserver -> origin SYNACK
> mailserver -> origin SYNACK		mailserver -> origin SYNACK
> mailserver -> origin SYNACK		mailserver -> origin SYNACK
> mailserver -> origin SYNACK		mailserver -> origin SYNACK
> ...
> 
> Here is an example from the public interface:
> 
> 09:52:36.599398 IP 103.14.225.112.63461 > 78.32.30.218.587: Flags [SEW], seq 3387227814, win 8192, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
> 09:52:36.599893 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1452,nop,nop,sackOK,nop,wscale 7], length 0
> 09:52:36.820464 IP 103.14.225.112.63461 > 78.32.30.218.587: Flags [.], ack 1, win 260, length 0
> 09:52:36.820549 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [R], seq 816385330, win 0, length 0
> 09:52:37.637548 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1452,nop,nop,sackOK,nop,wscale 7], length 0
> 
> and the corresponding trace on the mailserver:
> 09:52:36.599729 IP 103.14.225.112.63461 > 78.32.30.218.587: Flags [SEW], seq 3387227814, win 8192, options [mss 1452,nop,wscale 8,nop,nop,sackOK], length 0
> 09:52:36.599772 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
> 09:52:37.637421 IP 78.32.30.218.587 > 103.14.225.112.63461: Flags [S.], seq 816385329, ack 3387227815, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
> 
> So, my first observation is that conntrack is reacting to the ACK
> packet on the public interface, and marking the connection established,
> but a firewall rule is rejecting the connection when that ACK packet is
> received by sending a TCP reset. It looks like conntrack does not see 
> this packet,

Right, this is silly.  I'll see about this; the rst packet
bypasses conntrack because nf_send_reset attaches the exising
entry of the packet its replying to -- tcp conntrack gets skipped for
the generated RST.

But this is also the case in 5.16, so no idea why this is surfacing now.
