Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F192F192688
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCYLCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:02:22 -0400
Received: from correo.us.es ([193.147.175.20]:56718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727457AbgCYLCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 07:02:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3550FB45F
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:01:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C65D6FC5E9
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:01:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C13F0FC5F4; Wed, 25 Mar 2020 12:01:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E10D9FC5E4;
        Wed, 25 Mar 2020 12:01:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Mar 2020 12:01:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BB38A42EF42A;
        Wed, 25 Mar 2020 12:01:41 +0100 (CET)
Date:   Wed, 25 Mar 2020 12:02:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nft_fwd_netdev: Fix CONFIG_NET_CLS_ACT=n build
Message-ID: <20200325110218.ga2m5n2jfbdbfivs@salvia>
References: <20200325093300.5455-1-geert@linux-m68k.org>
 <20200325104001.yekvtbrw3lvkhvta@salvia>
 <CAMuHMdWRKW3HoWk+drmbwKi6wArN9qjgjp=8NcyBK7P2kT=cLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWRKW3HoWk+drmbwKi6wArN9qjgjp=8NcyBK7P2kT=cLg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 12:00:08PM +0100, Geert Uytterhoeven wrote:
> Hi Pablo,
> 
> On Wed, Mar 25, 2020 at 11:40 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Mar 25, 2020 at 10:33:00AM +0100, Geert Uytterhoeven wrote:
> > > If CONFIG_NET_CLS_ACT=n:
> > >
> > >     net/netfilter/nft_fwd_netdev.c: In function ‘nft_fwd_netdev_eval’:
> > >     net/netfilter/nft_fwd_netdev.c:32:10: error: ‘struct sk_buff’ has no member named ‘tc_redirected’
> > >       pkt->skb->tc_redirected = 1;
> > >             ^~
> > >     net/netfilter/nft_fwd_netdev.c:33:10: error: ‘struct sk_buff’ has no member named ‘tc_from_ingress’
> > >       pkt->skb->tc_from_ingress = 1;
> > >             ^~
> > >
> > > Fix this by protecting this code hunk with the appropriate #ifdef.
> >
> > Sorry about this, and thank you for fixing up this so fast.
> >
> > I'm attaching an alternative fix to avoid a dependency on tc from
> > netfilter. Still testing, if fine and no objections I'll formally
> > submit this.
> 
> Thanks, that fixes the issue, too.
> (Note that I didn't do a full build).

Thanks. I'll submit formaly asap.

There was another spot I forgot to update in net/core/pktgen.c, I will
include that chunk too in my formal submission.
