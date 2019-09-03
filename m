Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CE2A7484
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfICUTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:19:10 -0400
Received: from correo.us.es ([193.147.175.20]:57986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbfICUTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:19:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D66B6B6C6F
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 22:19:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C759DDA7B6
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 22:19:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BACBBFB362; Tue,  3 Sep 2019 22:19:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8CACD2B1F;
        Tue,  3 Sep 2019 22:19:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Sep 2019 22:19:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8A1E14265A5A;
        Tue,  3 Sep 2019 22:19:03 +0200 (CEST)
Date:   Tue, 3 Sep 2019 22:19:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/2] netfilter: Terminate rule eval if protocol=IPv6
 and ipv6 module is disabled
Message-ID: <20190903201904.npna6dt25ug5gwvd@salvia>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-2-leonardo@linux.ibm.com>
 <20190830205802.GS20113@breakpoint.cc>
 <99e3ef9c5ead1c95df697d49ab9cc83a95b0ac7c.camel@linux.ibm.com>
 <20190903164948.kuvtpy7viqhcmp77@salvia>
 <20190903170550.GA13660@breakpoint.cc>
 <20190903193155.v74ws47zcn6zrwpr@salvia>
 <20190903194809.GD13660@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903194809.GD13660@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 09:48:09PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > I was expecting we could find a way to handle this from br_netfilter
> > > > alone itself.
> > > 
> > > We can't because we support ipv6 fib lookups from the netdev family
> > > as well.
> > > 
> > > Alternative is to auto-accept ipv6 packets from the nf_tables eval loop,
> > > but I think its worse.
> > 
> > Could we add a restriction for nf_tables + br_netfilter + !ipv6. I
> > mean, if this is an IPv6 packet, nf_tables is on and IPv6 module if
> > off, then drop this packet?
> 
> We could do that from nft_do_chain_netdev().

Indeed, this is all about the netdev case.

Probably add something similar to nf_ip6_route() to deal with
ip6_route_lookup() case? This is the one trigering the problem, right?

BTW, how does nft_fib_ipv6 module kicks in if ipv6 module is not
loaded? The symbol dependency would pull in the IPv6 module anyway.
