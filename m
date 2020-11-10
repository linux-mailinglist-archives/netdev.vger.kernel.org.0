Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3772AD725
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgKJNLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgKJNLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 08:11:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BDEC0613CF;
        Tue, 10 Nov 2020 05:11:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kcTQz-0002W4-QT; Tue, 10 Nov 2020 14:11:41 +0100
Date:   Tue, 10 Nov 2020 14:11:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Numan Siddique <nusiddiq@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, ovs dev <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp
 flag - BE_LIBERAL per-ct basis.
Message-ID: <20201110131141.GH23619@breakpoint.cc>
References: <20201109072930.14048-1-nusiddiq@redhat.com>
 <20201109213557.GE23619@breakpoint.cc>
 <CAH=CPzqTy3yxgBEJ9cVpp3pmGN9u4OsL9GrA+1w6rVum7B8zJw@mail.gmail.com>
 <20201110122542.GG23619@breakpoint.cc>
 <CAH=CPzqRKTfQW05UxFQwVpvMSOZ7wNgLeiP3txY8T45jdx_E5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH=CPzqRKTfQW05UxFQwVpvMSOZ7wNgLeiP3txY8T45jdx_E5Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Numan Siddique <nusiddiq@redhat.com> wrote:
> On Tue, Nov 10, 2020 at 5:55 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Numan Siddique <nusiddiq@redhat.com> wrote:
> > > On Tue, Nov 10, 2020 at 3:06 AM Florian Westphal <fw@strlen.de> wrote:
> > > Thanks for the comments. I actually tried this approach first, but it
> > > doesn't seem to work.
> > > I noticed that for the committed connections, the ct tcp flag -
> > > IP_CT_TCP_FLAG_BE_LIBERAL is
> > > not set when nf_conntrack_in() calls resolve_normal_ct().
> >
> > Yes, it won't be set during nf_conntrack_in, thats why I suggested
> > to do it before confirming the connection.
> 
> Sorry for the confusion. What I mean is - I tested  your suggestion - i.e called
> nf_ct_set_tcp_be_liberal()  before calling nf_conntrack_confirm().
> 
>  Once the connection is established, for subsequent packets, openvswitch
>  calls nf_conntrack_in() [1] to see if the packet is part of the
> existing connection or not (i.e ct.new or ct.est )
> and if the packet happens to be out-of-window then skb->_nfct is set
> to NULL. And the tcp
> be flags set during confirmation are not reflected when
> nf_conntrack_in() calls resolve_normal_ct().

Can you debug where this happens?  This looks very very wrong.
resolve_normal_ct() has no business to check any of those flags
(and I don't see where it uses them, it should only deal with the
 tuples).

The flags come into play when nf_conntrack_handle_packet() gets called
after resolve_normal_ct has found an entry, since that will end up
calling the tcp conntrack part.

The entry found/returned by resolve_normal_ct should be the same
nf_conn entry that was confirmed earlier, i.e. it should be in "liberal"
mode.
