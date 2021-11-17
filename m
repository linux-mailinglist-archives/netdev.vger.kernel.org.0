Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4432945461B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 13:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbhKQMJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 07:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhKQMJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 07:09:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D0DC061570;
        Wed, 17 Nov 2021 04:06:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mnJhZ-0000WK-LW; Wed, 17 Nov 2021 13:06:09 +0100
Date:   Wed, 17 Nov 2021 13:06:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: "AVX2-based lookup implementation" has broken ebtables
 --among-src
Message-ID: <20211117120609.GI6326@breakpoint.cc>
References: <d35db9d6-0727-1296-fa78-4efeadf3319c@virtuozzo.com>
 <20211116173352.1a5ff66a@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116173352.1a5ff66a@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> [Adding netfilter-devel]
> 
> Hi Nikita,
> 
> On Tue, 16 Nov 2021 11:51:01 +0300
> Nikita Yushchenko <nikita.yushchenko@virtuozzo.com> wrote:
> 
> > Hello Stefano.
> > 
> > I've found that nftables rule added by
> > 
> > # ebtables -A INPUT --among-src 8:0:27:40:f7:9=192.168.56.10 -j log
> > 
> > does not match packets on kernel 5.14 and on current mainline.
> > Although it matched correctly on kernel 4.18
> > 
> > I've bisected this issue. It was introduced by your commit 7400b063969b ("nft_set_pipapo: Introduce 
> > AVX2-based lookup implementation") from 5.7 development cycle.
> > 
> > The nftables rule created by the above command uses concatenation:
> > 
> > # nft list chain bridge filter INPUT
> > table bridge filter {
> >          chain INPUT {
> >                  type filter hook input priority filter; policy accept;
> >                  ether saddr . ip saddr { 08:00:27:40:f7:09 . 192.168.56.10 } counter packets 0 bytes 0 
> > log level notice flags ether
> >          }
> > }
> > 
> > Looks like the AVX2-based lookup does not process this correctly.
> 
> Thanks for bisecting and reporting this! I'm looking into it now, I
> might be a bit slow as I'm currently traveling.

Might be a bug in ebtables.  This is what nft monitor shows:

add chain bridge filter INPUT { type filter hook input priority filter;
	policy accept; }
	add rule bridge filter INPUT ether saddr . ip saddr {
08:00:27:40:f7:09 .
	   192.168.56.10-0x1297286e2b2 [..]

I can have a look at ebtables-nft side.
