Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E4EA75C3
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfICUzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:55:15 -0400
Received: from correo.us.es ([193.147.175.20]:34098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbfICUzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:55:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0C375B6C71
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 22:55:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDA70DA4D0
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 22:55:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D3DF9B8007; Tue,  3 Sep 2019 22:55:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6D4BD2B1F;
        Tue,  3 Sep 2019 22:55:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Sep 2019 22:55:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 93DE84265A5A;
        Tue,  3 Sep 2019 22:55:08 +0200 (CEST)
Date:   Tue, 3 Sep 2019 22:55:09 +0200
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
Message-ID: <20190903205509.y6bus5gw4jdw5d7l@salvia>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-2-leonardo@linux.ibm.com>
 <20190830205802.GS20113@breakpoint.cc>
 <99e3ef9c5ead1c95df697d49ab9cc83a95b0ac7c.camel@linux.ibm.com>
 <20190903164948.kuvtpy7viqhcmp77@salvia>
 <20190903170550.GA13660@breakpoint.cc>
 <20190903193155.v74ws47zcn6zrwpr@salvia>
 <20190903194809.GD13660@breakpoint.cc>
 <20190903201904.npna6dt25ug5gwvd@salvia>
 <20190903203531.GF13660@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903203531.GF13660@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 10:35:31PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Sep 03, 2019 at 09:48:09PM +0200, Florian Westphal wrote:
> > > We could do that from nft_do_chain_netdev().
> > 
> > Indeed, this is all about the netdev case.
> > 
> > Probably add something similar to nf_ip6_route() to deal with
> > ip6_route_lookup() case? This is the one trigering the problem, right?
> 
> Yes, this particular problem is caused by ipv6 fib not being
> initialized due to ipv6.disable=1.  I don't know if there are cases
> other than FIB.
> 
> > BTW, how does nft_fib_ipv6 module kicks in if ipv6 module is not
> > loaded? The symbol dependency would pull in the IPv6 module anyway.
> 
> ipv6.disabled=1 does load the ipv6 module, but its non-functional.

I see, thanks for explaining.
