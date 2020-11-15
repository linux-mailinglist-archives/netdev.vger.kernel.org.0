Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DCB2B348C
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 12:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKOLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 06:15:25 -0500
Received: from correo.us.es ([193.147.175.20]:44676 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgKOLPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 06:15:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18A9BE34CC
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 12:15:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07942DA4CD
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 12:15:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F0000DA730; Sun, 15 Nov 2020 12:15:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA251DA72F;
        Sun, 15 Nov 2020 12:15:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 15 Nov 2020 12:15:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 879174265A5A;
        Sun, 15 Nov 2020 12:15:20 +0100 (CET)
Date:   Sun, 15 Nov 2020 12:15:20 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net v4] ipv6/netfilter: Discard first fragment not
 including all headers
Message-ID: <20201115111520.GA24052@salvia>
References: <20201111115025.28879-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111115025.28879-1-geokohma@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 12:50:25PM +0100, Georg Kohmann wrote:
> Packets are processed even though the first fragment don't include all
> headers through the upper layer header. This breaks TAHI IPv6 Core
> Conformance Test v6LC.1.3.6.
> 
> Referring to RFC8200 SECTION 4.5: "If the first fragment does not include
> all headers through an Upper-Layer header, then that fragment should be
> discarded and an ICMP Parameter Problem, Code 3, message should be sent to
> the source of the fragment, with the Pointer field set to zero."
> 
> The fragment needs to be validated the same way it is done in
> commit 2efdaaaf883a ("IPv6: reply ICMP error if the first fragment don't
> include all headers") for ipv6. Wrap the validation into a common function,
> ipv6_frag_thdr_truncated() to check for truncation in the upper layer
> header. This validation does not fullfill all aspects of RFC 8200,
> section 4.5, but is at the moment sufficient to pass mentioned TAHI test.
> 
> In netfilter, utilize the fragment offset returned by find_prev_fhdr() to
> let ipv6_frag_thdr_truncated() start it's traverse from the fragment
> header.
> 
> Return 0 to drop the fragment in the netfilter. This is the same behaviour
> as used on other protocol errors in this function, e.g. when
> nf_ct_frag6_queue() returns -EPROTO. The Fragment will later be picked up
> by ipv6_frag_rcv() in reassembly.c. ipv6_frag_rcv() will then send an
> appropriate ICMP Parameter Problem message back to the source.
> 
> References commit 2efdaaaf883a ("IPv6: reply ICMP error if the first
> fragment don't include all headers")
> 
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

In case you would like to follow up with another patch for the IPv6
reassembly in netfilter.o

net/ipv6/netfilter/nf_conntrack_reasm.c uses pr_debug() everywhere.

net/ipv4/netfilter/nf_defrag_ipv4.c however uses ip_defrag() which is
updating IPSTATS_MIB_*, so IPv4 and IPv6 code behave differently with
regards to the stats.

It would be probably good to get them aligned, by replacing the
existing pr_debug() in the net/ipv6/netfilter/nf_conntrack_reasm.c
code by IPSTATS_MIB_*.

Thanks.
