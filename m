Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44D4A575
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfFRPdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:33:37 -0400
Received: from mail.us.es ([193.147.175.20]:46508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbfFRPdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 11:33:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22CBE1176AB
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 17:33:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11774DA707
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 17:33:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06ABEDA70B; Tue, 18 Jun 2019 17:33:34 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA552DA702;
        Tue, 18 Jun 2019 17:33:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 17:33:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B1AFE4265A2F;
        Tue, 18 Jun 2019 17:33:31 +0200 (CEST)
Date:   Tue, 18 Jun 2019 17:33:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190618153331.6u44cwxnaejuswqo@salvia>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
 <22ab95cb-9dca-1e48-4ca0-965d340e7d32@ucloud.cn>
 <20190618093748.dydodhngydfcfmeh@breakpoint.cc>
 <591caf69-ba08-33b5-5330-8230779cc903@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <591caf69-ba08-33b5-5330-8230779cc903@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 10:27:12PM +0800, wenxu wrote:
> 
> 在 2019/6/18 17:37, Florian Westphal 写道:
> > wenxu <wenxu@ucloud.cn> wrote:
> >> On 6/18/2019 6:42 AM, Florian Westphal wrote:
> >>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>>>> Subject: Change bridge l3 dependency to meta protocol
> >>>>>
> >>>>> This examines skb->protocol instead of ethernet header type, which
> >>>>> might be different when vlan is involved.
> >>>>>  
> >>>>> +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
> >>>>> +		if (expr->payload.desc == &proto_ip ||
> >>>>> +		    expr->payload.desc == &proto_ip6)
> >>>>> +			desc = &proto_metaeth;
> >>>>> +	}i
> >>>> Is this sufficient to restrict the matching? Is this still buggy from
> >>>> ingress?
> >>> This is what netdev family uses as well (skb->protocol i mean).
> >>> I'm not sure it will work for output however (haven't checked).
> >>>
> >>>> I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
> >>>> the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
> >>>> NFTA_PAYLOAD_FLAGS and place it there. Just an idea.
> >>> Another unresolved issue is presence of multiple vlan tags, so we might
> >>> have to add yet another meta key to retrieve the l3 protocol in use
> >> Maybe add a l3proto meta key can handle the multiple vlan tags case with the l3proto dependency.  It
> >> should travese all the vlan tags and find the real l3 proto.
> > Yes, something like this.
> >
> > We also need to audit netdev and bridge expressions (reject is known broken)
> > to handle vlans properly.
> >
> > Still, switching nft to prefer skb->protocol instead of eth_hdr->type
> > for dependencies would be good as this doesn't need kernel changes and solves
> > the immediate problem of 'ip ...' not matching in case of vlan.
> >
> > If you have time, could you check if using skb->protocol works for nft
> > bridge in output, i.e. does 'nft ip protocol icmp' match when its used
> > from bridge output path with meta protocol dependency with and without
> > vlan in use?
> 
> I just check the kernel codes and test with the output chain, the
> meta protocol dependency can also work in the outpu chain.

OK.

Florian, would you submit a patch, including a test for this?

Thanks!
