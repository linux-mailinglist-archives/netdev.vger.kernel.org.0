Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2D328A65B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 10:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgJKIdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 04:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgJKIdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 04:33:39 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Oct 2020 01:33:39 PDT
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ef0:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F371C0613CE;
        Sun, 11 Oct 2020 01:33:39 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 917862800B1C9;
        Sun, 11 Oct 2020 10:26:57 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 75F9F86D80; Sun, 11 Oct 2020 10:26:57 +0200 (CEST)
Date:   Sun, 11 Oct 2020 10:26:57 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Laura =?iso-8859-1?Q?Garc=EDa_Li=E9bana?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20201011082657.GB15225@wunner.de>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 12:02:03AM +0200, Daniel Borkmann wrote:
> today it is possible and
> perfectly fine to e.g. redirect to a host-facing veth from tc ingress which
> then goes into container. Only traffic that goes up the host stack is seen
> by nf ingress hook in that case. Likewise, reply traffic can be redirected
> from host-facing veth to phys dev for xmit w/o any netfilter interference.
> This means netfilter in host ns really only sees traffic to/from host as
> intended. This is fine today, however, if 3rd party entities (e.g. distro
> side) start pushing down rules on the two nf hooks, then these use cases will
> break on the egress one due to this asymmetric layering violation. Hence my
> ask that this needs to be configurable from a control plane perspective so
> that both use cases can live next to each other w/o breakage. Most trivial
> one I can think of is (aside from the fact to refactor the hooks and improve
> their performance) a flag e.g. for skb that can be set from tc/BPF layer to
> bypass the nf hooks. Basically a flexible opt-in so that existing use-cases
> can be retained w/o breakage.

I argue that being able to filter traffic coming out of the container
is desirable because why should the host trust the software running
in the container to never send malicious packets.

As for the flag you're asking for, it already exists in the form of
skb->mark.  Just let tc set the mark when the packet exits the container
and add a netfilter rule to accept packets carrying that mark.  Or do
not set any netfilter egress rules at all to disable the egress
filtering and avoid the performance impact it would imply.

Thanks,

Lukas
