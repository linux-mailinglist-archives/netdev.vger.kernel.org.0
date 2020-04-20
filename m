Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A3D1B0A9D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgDTMt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:49:27 -0400
Received: from correo.us.es ([193.147.175.20]:60226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbgDTMtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C654BB4975
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:49:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7F1B100789
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:49:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9D9EC100788; Mon, 20 Apr 2020 14:49:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAB74FA525;
        Mon, 20 Apr 2020 14:49:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 Apr 2020 14:49:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 894D742EF42A;
        Mon, 20 Apr 2020 14:49:20 +0200 (CEST)
Date:   Mon, 20 Apr 2020 14:49:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Edward Cree <ecree@solarflare.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420124920.j3edwvc5fwobqhyg@salvia>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
 <20200420123611.GF6581@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200420123611.GF6581@nanopsycho.orion>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 02:36:11PM +0200, Jiri Pirko wrote:
> Mon, Apr 20, 2020 at 02:28:22PM CEST, ecree@solarflare.com wrote:
> >On 20/04/2020 12:52, Jiri Pirko wrote:
> >> However for TC, when user specifies "HW_STATS_DISABLED", the driver
> >> should not do stats.
> >What should a driver do if the user specifies DISABLED, but the stats
> > are still needed for internal bookkeeping (e.g. to prod an ARP entry
> > that's in use for encapsulation offload, so that it doesn't get
> > expired out of the cache)?  Enable the stats on the HW anyway but
> > not report them to FLOW_CLS_STATS?  Or return an error?
> 
> If internally needed, it means they cannot be disabled. So returning
> error would make sense, as what the user requested is not supported.

Hm.

Then, if the user disables counters but there is internal dependency
on them, the tc rule fails to be loaded for this reason.

After this the user is forced to re-load the rule, specifying enable
counters.

Why does the user need to force in this case to reload? It seems more
natural to me to give the user what it is requesting (disabled
counters / front-end doesn't care) and the driver internally allocates
the resources that it needs (actually turn them on if there is a
dependency like tunneling).
