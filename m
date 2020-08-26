Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84B25295A
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 10:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgHZIku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 04:40:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36894 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgHZIkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 04:40:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BC49D20561;
        Wed, 26 Aug 2020 10:40:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7zobVbAa-7X3; Wed, 26 Aug 2020 10:40:45 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 516182026E;
        Wed, 26 Aug 2020 10:40:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 10:40:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 26 Aug
 2020 10:40:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 67B68318035F; Wed, 26 Aug 2020 10:40:44 +0200 (CEST)
Date:   Wed, 26 Aug 2020 10:40:44 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     Bram Yvakh <bram-yvahk@mail.wizbit.be>, <netdev@vger.kernel.org>,
        <xmu@redhat.com>
Subject: Re: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
Message-ID: <20200826084044.GX20687@gauss3.secunet.de>
References: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
 <5F295578.4040004@mail.wizbit.be>
 <20200807144701.GC906370@bistromath.localdomain>
 <5F2D7615.6090802@mail.wizbit.be>
 <20200810122020.GA1128331@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200810122020.GA1128331@bistromath.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 02:20:20PM +0200, Sabrina Dubroca wrote:
> 2020-08-07, 17:41:09 +0200, Bram Yvakh wrote:
> 
> If the packet doesn't have the DF bit set (so the stack can fragment
> the packet at will), or if the stack decided that it can ignore it and
> fragment anyway, there's no need to check the mtu, because we'll
> fragment the packet when we need. Otherwise, we're not allowed to
> fragment, so we have to check the packet's size against the mtu.
> 
> > In other words: 'xfrm4_tunnel_check_size' only cares about the mtu if ignore_df isn't set.
> > The original code in 'xfrmi_xmit2': only checks the mtu if ignore_df isn't set. (-> looks consistent)
> 
> Except that we reset skb->ignore_df in between (just after the mtu
> handling in xfrmi_xmit2, via xfrmi_scrub_packet).

I guess the problem appears with a local ping, right?
Does 'ping -M do' work?

Looks like the comment in __ip_make_skb() on ignore_df
is not true for packets that are sent through a virtual
interface that increases the packet size. It says:

/* Unless user demanded real pmtu discovery (IP_PMTUDISC_DO), we allow
 * to fragment the frame generated here. No matter, what transforms
 * how transforms change size of the packet, it will come out.
 */

If we reset ignore_df before we can fragment it, the packet
won't come out.

I tend to apply your patch because it makes xfrmi consistend with
vti, but that might not be the end of the story. We will then signal
PMTU events also to sockets that can't handle it. Unfortunately, we
can't fragment before we send the packets into the interface, as
we don't know their final size. Alternatively, we can keep the
ignore_df on th skb and fragment the encapsulated packet later on.
But this has problems on its own...

