Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48FC1BB213
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgD0XoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:44:11 -0400
Received: from correo.us.es ([193.147.175.20]:53870 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgD0XoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 19:44:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64682E1246
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:44:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57CDAB7FF1
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:44:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 573B92040D; Tue, 28 Apr 2020 01:44:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F160D53899;
        Tue, 28 Apr 2020 01:44:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 01:44:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BA77B42EF9E2;
        Tue, 28 Apr 2020 01:44:06 +0200 (CEST)
Date:   Tue, 28 Apr 2020 01:44:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
Message-ID: <20200427234406.GA22616@salvia>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
 <20200313145526.ikovaalfuy7rnkdl@salvia>
 <1bd50836-33c4-da44-5771-654bfb0348cc@iogearbox.net>
 <20200315132836.cj36ape6rpw33iqb@salvia>
 <CAF90-WgoteQXB9WQmeT1eOHA3GpPbwPCEvNzwKkN20WqpdHW-A@mail.gmail.com>
 <20200423160542.d3f6yef4av2gqvur@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423160542.d3f6yef4av2gqvur@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On Thu, Apr 23, 2020 at 06:05:42PM +0200, Lukas Wunner wrote:
[...]
> Daniel submitted a revert of this series but didn't cc me:
> 
> https://lore.kernel.org/netdev/bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net/
> 
> In the ensuing discussion it turned out that the performance argument
> may be addressed by a rearrangement of sch_handle_egress() and
> nf_egress() invocations.  I could look into amending the series
> accordingly and resubmitting, though I'm currently swamped with
> other work.
> 
> The question is whether that's going to be sufficient because Daniel
> mentioned having an in-tree user as a prerequisite for accepting this
> feature, to which Pablo responded with NAT64/NAT46.  I don't have
> intentions of implementing those, but maybe someone else has.

I'd love to work on integrating that feature, there are a few
implementations outthere that might be useful for this.

However, I'm terribly biased, I'm the Netfilter maintainer.

Even though, I really think this hook is going to be very useful for
the Linux community from day one.
