Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308BE2BC1A9
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 20:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgKUS72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 13:59:28 -0500
Received: from correo.us.es ([193.147.175.20]:60498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgKUS72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 13:59:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3066B160A25
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 19:59:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E374DA78D
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 19:59:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 135F7DA72F; Sat, 21 Nov 2020 19:59:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE9AEDA722;
        Sat, 21 Nov 2020 19:59:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 19:59:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B42C84265A5A;
        Sat, 21 Nov 2020 19:59:22 +0100 (CET)
Date:   Sat, 21 Nov 2020 19:59:22 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20201121185922.GA23266@salvia>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
 <20201011082657.GB15225@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201011082657.GB15225@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On Sun, Oct 11, 2020 at 10:26:57AM +0200, Lukas Wunner wrote:
> On Tue, Sep 15, 2020 at 12:02:03AM +0200, Daniel Borkmann wrote:
> > today it is possible and
> > perfectly fine to e.g. redirect to a host-facing veth from tc ingress which
> > then goes into container. Only traffic that goes up the host stack is seen
> > by nf ingress hook in that case. Likewise, reply traffic can be redirected
> > from host-facing veth to phys dev for xmit w/o any netfilter interference.
> > This means netfilter in host ns really only sees traffic to/from host as
> > intended. This is fine today, however, if 3rd party entities (e.g. distro
> > side) start pushing down rules on the two nf hooks, then these use cases will
> > break on the egress one due to this asymmetric layering violation. Hence my
> > ask that this needs to be configurable from a control plane perspective so
> > that both use cases can live next to each other w/o breakage. Most trivial
> > one I can think of is (aside from the fact to refactor the hooks and improve
> > their performance) a flag e.g. for skb that can be set from tc/BPF layer to
> > bypass the nf hooks. Basically a flexible opt-in so that existing use-cases
> > can be retained w/o breakage.
> 
> I argue that being able to filter traffic coming out of the container
> is desirable because why should the host trust the software running
> in the container to never send malicious packets.
> 
> As for the flag you're asking for, it already exists in the form of
> skb->mark.  Just let tc set the mark when the packet exits the container
> and add a netfilter rule to accept packets carrying that mark.  Or do
> not set any netfilter egress rules at all to disable the egress
> filtering and avoid the performance impact it would imply.

Would you follow up on this? I'd really appreciate if you do.

We're lately discussing more and more usecases in the NFWS meetings
where the egress can get really useful.

Thank you.
