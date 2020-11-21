Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849C82BBED0
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 12:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgKUL6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 06:58:46 -0500
Received: from correo.us.es ([193.147.175.20]:49488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbgKUL6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 06:58:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5C609E780B
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 12:58:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D90BDA797
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 12:58:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 42ADDDA78E; Sat, 21 Nov 2020 12:58:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16AB4DA722;
        Sat, 21 Nov 2020 12:58:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 12:58:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E935C42EF42A;
        Sat, 21 Nov 2020 12:58:40 +0100 (CET)
Date:   Sat, 21 Nov 2020 12:58:40 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, fw@strlen.de,
        razor@blackwall.org, jeremy@azazel.net, tobias@waldekranz.com
Subject: Re: [PATCH net-next,v5 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201121115840.GA18793@salvia>
References: <JbOm90Raei3ADlleQvsaCY9krt0lOkG1YFpbZEgylgU@cp4-web-014.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <JbOm90Raei3ADlleQvsaCY9krt0lOkG1YFpbZEgylgU@cp4-web-014.plabs.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Nov 20, 2020 at 03:09:37PM +0000, Alexander Lobakin wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Fri, 20 Nov 2020 13:49:12 +0100
[...]
> > The following patchset augments the Netfilter flowtable fastpath to
> > support for network topologies that combine IP forwarding, bridge and
> > VLAN devices.
> 
> I'm curious if this new infra can be expanded later to shortcut other
> VLAN-like virtual netdevs e.g. DSA-like switch slaves.
> 
> I mean, usually we have port0...portX physical port representors
> and backing CPU port with ethX representor. When in comes to NAT,
> portX is set as destination. Flow offload calls dev_queue_xmit()
> on it, switch stack pushes CPU tag into the skb, change skb->dev
> to ethX and calls another dev_queue_xmit().
> 
> If we could (using the new .ndo_fill_forward_path()) tell Netfilter
> that our real dest is ethX and push the CPU tag via dev_hard_header(),
> this will omit one more dev_queue_xmit() and a bunch of indirect calls
> and checks.

If the XMIT_DIRECT path can be used for this with minimal changes,
that would be good.

> This might require some sort of "custom" or "private" cookies for
> N-Tuple though to separate flows from/to different switch ports (as
> it's done for VLAN: proto + VID).

Probably VLAN proto + VID in the tuple can be reused for this too.
Maybe add some extra information to tell if this is a VLAN or DSA
frame. It should be just one extra check for skb->protocol equals DSA.
Looks like very minimal changes to support for this.

> If so, I'd like to try to implement and publish that idea for reviews
> after this one lands nf-next.

Exploring new extensions is fine.

I received another email from someone else that would like to extend
this to support for PPPoE devices with PcEngines APU routers. In
general, adding more .ndo_fill_forward_path for more device types is
possible.
