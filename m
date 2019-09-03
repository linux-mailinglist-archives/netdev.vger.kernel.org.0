Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEEFA5E60
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 02:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfICAFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 20:05:52 -0400
Received: from correo.us.es ([193.147.175.20]:41650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbfICAFw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 20:05:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B69351878A4
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 02:05:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8E6EB8017
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 02:05:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99BB2B8004; Tue,  3 Sep 2019 02:05:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CA4CDA72F;
        Tue,  3 Sep 2019 02:05:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Sep 2019 02:05:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6C2624265A5A;
        Tue,  3 Sep 2019 02:05:45 +0200 (CEST)
Date:   Tue, 3 Sep 2019 02:05:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@resnulli.us
Subject: Re: [PATCH 0/4 net-next] flow_offload: update mangle action
 representation
Message-ID: <20190903000546.rmjmxqozycylgbdb@salvia>
References: <20190830005336.23604-1-pablo@netfilter.org>
 <20190829185448.0b502af8@cakuba.netronome.com>
 <20190830090710.g7q2chf3qulfs5e4@salvia>
 <20190830153351.5d5330fa@cakuba.netronome.com>
 <20190831142217.bvxx3vc6wpsmnxpe@salvia>
 <20190901134754.1bcd72d4@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901134754.1bcd72d4@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 01, 2019 at 01:47:54PM -0700, Jakub Kicinski wrote:
> On Sat, 31 Aug 2019 16:22:17 +0200, Pablo Neira Ayuso wrote:
[...]
> > > Please see the definitions of:
> > > 
> > > struct nfp_fl_set_eth
> > > struct nfp_fl_set_ip4_addrs
> > > struct nfp_fl_set_ip4_ttl_tos
> > > struct nfp_fl_set_ipv6_tc_hl_fl
> > > struct nfp_fl_set_ipv6_addr
> > > struct nfp_fl_set_tport
> > > 
> > > These are the programming primitives for header rewrites in the NFP.
> > > Since each of those contains more than just one field, we'll have to
> > > keep all the field coalescing logic in the driver, even if you coalesce
> > > while fields (i.e. IPv6 addresses).  
> > 
> > nfp has been updated in this patch series to deal with the new mangle
> > representation.
> 
> It has been updated to handle the trivial coalescing.
> 
> > > Perhaps it's not a serious blocker for the series, but it'd be nice if
> > > rewrite action grouping was handled in the core. Since you're already
> > > poking at that code..  
> > 
> > Rewrite action grouping is already handled from the core front-end in
> > this patch series.
> 
> If you did what I'm asking the functions nfp_fl_check_mangle_start()
> and nfp_fl_check_mangle_end() would no longer exist. They were not
> really needed before you "common flow API" changes.

Thanks for the pointer. This driver-level coalescing routine you are
refering to is specific to optimize your layout. I agree the core
could be updated to do more coalescing, but this would need a way to
express what coalescing the driver would like to see in place. I would
wait to see more drivers that can benefit from that. I can only make
incremental steps, it's already hard to navigate over all this code.
