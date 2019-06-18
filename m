Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A67249D75
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfFRJfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:35:13 -0400
Received: from mail.us.es ([193.147.175.20]:44100 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfFRJfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 05:35:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B522117738
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:35:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18700DA70E
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:35:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CE27DA706; Tue, 18 Jun 2019 11:35:11 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED660DA705;
        Tue, 18 Jun 2019 11:35:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 11:35:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AE8464265A31;
        Tue, 18 Jun 2019 11:35:08 +0200 (CEST)
Date:   Tue, 18 Jun 2019 11:35:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     wenxu@ucloud.cn, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190618093508.3c5jjmmmuz3m26uj@salvia>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 12:42:32AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Subject: Change bridge l3 dependency to meta protocol
> > > 
> > > This examines skb->protocol instead of ethernet header type, which
> > > might be different when vlan is involved.
> > >  
> > > +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
> > > +		if (expr->payload.desc == &proto_ip ||
> > > +		    expr->payload.desc == &proto_ip6)
> > > +			desc = &proto_metaeth;
> > > +	}i
> > 
> > Is this sufficient to restrict the matching? Is this still buggy from
> > ingress?
> 
> This is what netdev family uses as well (skb->protocol i mean).
> I'm not sure it will work for output however (haven't checked).

You mean for locally generated traffic?

> > I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
> > the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
> > NFTA_PAYLOAD_FLAGS and place it there. Just an idea.
> 
> What would NFT_PAYLOAD_CHECK_VLAN do?

Similar to the checksum approach, it provides a hint to the kernel to
say that "I want to look at the vlan header" from the link layer.

> You mean disable/enable the 'vlan is there' illusion that nft_payload
> provides?  That would work as well of course, but I would prefer to
> switch to meta dependencies where possible so we don't rely on
> particular layout of a different header class (e.g. meta l4proto doesn't
> depend on ip version, and meta protocol won't depend on particular
> ethernet frame).

If we can fix all cases from userspace, that's fine.

> What might be useful is an nft switch to turn off dependeny
> insertion, this would also avoid the problem (if users restrict the
> matching properly...).

Hm. How does this toggle would look like?

> Another unresolved issue is presence of multiple vlan tags, so we might
> have to add yet another meta key to retrieve the l3 protocol in use
> 
> (the problem at hand was 'ip protocol icmp' not matching traffic inside
>  a vlan).

Could you describe this problem a bit more? Small example rule plus
scenario.

> The other issue is lack of vlan awareness in some bridge/netdev
> expressions, e.g. reject.

This needs to be fixed for bridge. There is no support for netdev yet,
IIRC.

> I think we could apply this patch to nft after making sure it works
> for output as thats probably the only solution that won't need
> changes in the kernel.

That's fine with me.

> If it doesn't, we will need to find a different solution in any case.

OK.
