Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CA230A079
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 04:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBADJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 22:09:52 -0500
Received: from correo.us.es ([193.147.175.20]:38484 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230033AbhBADJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Jan 2021 22:09:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5274DA7EC
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:08:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6383DA722
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:08:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BBAA5DA730; Mon,  1 Feb 2021 04:08:56 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69545DA722;
        Mon,  1 Feb 2021 04:08:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Feb 2021 04:08:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4D99A426CC84;
        Mon,  1 Feb 2021 04:08:53 +0100 (CET)
Date:   Mon, 1 Feb 2021 04:08:53 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, fw@strlen.de
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
Message-ID: <20210201030853.GA19878@salvia>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
 <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roi,

On Sun, Jan 31, 2021 at 03:18:34PM +0200, Roi Dayan wrote:
[...]
> Hi Pablo,
> 
> We did more tests with just updating the timeout in the 2 callers
> and it's not enough. We reproduce the issue of rules being timed
> out just now frim different place.

Thanks for giving it a try to my suggestion, it was not correct.

> There is a 3rd caller nf_ct_gc_expired() which being called by 3
> other callers:
> ____nf_conntrack_find()
> nf_conntrack_tuple_taken()
> early_drop_list()

Hm. I'm not sure yet what path is triggering this bug.

Florian came up with the idea of setting a very large timeout for
offloaded flows (that are refreshed by the garbage collector) to avoid
the extra check from the packet path, so those 3 functions above never
hit the garbage collection path. This also applies for the ctnetlink
(conntrack -L) and the /proc/net/nf_conntrack sysctl paths that the
patch describes, those should not ever see an offloaded flow with a
small timeout.

nf_ct_offload_timeout() is called from:

#1 flow_offload_add() to set a very large timer.
#2 the garbage collector path, to refresh the timeout the very large
   offload timer.

Probably there is a race between setting the IPS_OFFLOAD and when
flow_offload_add() is called? Garbage collector gets in between and
zaps the connection. Is a newly offloaded connection that you observed
that is being removed?

> only early_drop_list() has a check to skip conns with offload bit
> but without extending the timeout.
> I didnt do a dump but the issue could be from the other 2 calls.
> 
> With current commit as is I didn't need to check more callers as I made
> sure all callers will skip the non-offload gc.
>
> Instead of updating more callers and there might be more callers
> later why current commit is not enough?
> We skip offloaded flows and soon gc_worker() will hit and will update
> the timeout anyway.

Another possibility would be to check for the offload bit from
nf_ct_is_expired(), which is coming slighty before nf_ct_should_gc().
But this is also in the ____nf_conntrack_find() path.

Florian?
