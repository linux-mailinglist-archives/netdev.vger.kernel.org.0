Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2994BEF1
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFSQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:50:45 -0400
Received: from mail.us.es ([193.147.175.20]:52032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfFSQuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:50:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 98021F278D
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 18:50:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86397DA702
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 18:50:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B82EDA70E; Wed, 19 Jun 2019 18:50:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 715C0DA704;
        Wed, 19 Jun 2019 18:50:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 18:50:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 501424265A2F;
        Wed, 19 Jun 2019 18:50:40 +0200 (CEST)
Date:   Wed, 19 Jun 2019 18:50:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND nf-next] netfilter: add support for matching IPv4
 options
Message-ID: <20190619165039.yg3gzhkg2kvze5py@salvia>
References: <20190611120912.3825-1-ssuryaextr@gmail.com>
 <20190618153112.jwomdzit6mdawssi@salvia>
 <20190618141355.GA5642@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618141355.GA5642@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 10:13:55AM -0400, Stephen Suryaputra wrote:
> On Tue, Jun 18, 2019 at 05:31:12PM +0200, Pablo Neira Ayuso wrote:
> > > +{
> > > +	unsigned char optbuf[sizeof(struct ip_options) + 41];
> > 
> > In other parts of the kernel this is + 40:
> > 
> > net/ipv4/cipso_ipv4.c:  unsigned char optbuf[sizeof(struct ip_options) + 40];
> > 
> > here it is + 41.
> >
> > ...
> >
> > > +	/* Copy the options since __ip_options_compile() modifies
> > > +	 * the options. Get one byte beyond the option for target < 0
> > 
> > How does this "one byte beyond the option" trick works?
> 
> I used ipv6_find_hdr() as a reference. There if target is set to less
> than 0, then the offset points to the byte beyond the extension header.
> In this function, it points to the byte beyond the option. I wanted to
> be as close as a working code as possible. Also, why +41 instead of +40.

OK. But this is never used in this new extension, priv->type is always
set. I mean, we already have a pointer to the transport header via
nft_pktinfo->xt.thoff.

> > > +		if (opt->end) {
> > > +			*offset = opt->end + start;
> > > +			target = IPOPT_END;
> > 
> > May I ask, what's the purpose of IPOPT_END? :-)
> 
> My understanding is that in ipv6_find_hdr() if the nexthdr is
> NEXTHDR_NONE, then that's the one being returned. The same here: target
> is the return value.

Code that falls under the default: case that deals with IPOPT_END is
never exercised, right?

priv->type is always set to >= 0, so the opt->end never happens.
Hence, we can remove the chunk in net/ipv4/ip_options.c.

> > Apart from the above, this looks good to me.
> 
> AOK for other comments. I can spin another version.

Please, do.

Thanks for explaining. I understand motivation is to mimic
ipv6_find_hdr() which is a good idea indeed... if this functions
becomes used away from the netfilter tree at some point that would be
a good pattern to extend it. However, so far - please correct me if
I'm mistaken - for the requirements of nft_exthdr to support IPv4
options, we don't seem to need it, so I would prefer to start with the
bare minimum code that nft_exthdr needs, if possible.

Thanks!
