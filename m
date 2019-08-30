Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508D6A335B
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfH3JHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:07:17 -0400
Received: from correo.us.es ([193.147.175.20]:50466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbfH3JHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:07:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 921CBDA725
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 11:07:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83024FF2E8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 11:07:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7863BDA72F; Fri, 30 Aug 2019 11:07:11 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46DFADA72F;
        Fri, 30 Aug 2019 11:07:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 30 Aug 2019 11:07:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 241F64265A5A;
        Fri, 30 Aug 2019 11:07:09 +0200 (CEST)
Date:   Fri, 30 Aug 2019 11:07:10 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@resnulli.us
Subject: Re: [PATCH 0/4 net-next] flow_offload: update mangle action
 representation
Message-ID: <20190830090710.g7q2chf3qulfs5e4@salvia>
References: <20190830005336.23604-1-pablo@netfilter.org>
 <20190829185448.0b502af8@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829185448.0b502af8@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 06:54:48PM -0700, Jakub Kicinski wrote:
> On Fri, 30 Aug 2019 02:53:32 +0200, Pablo Neira Ayuso wrote:
> > * Offsets do not need to be on the 32-bits boundaries anymore. This
> >   patchset adds front-end code to adjust the offset and length coming
> >   from the tc pedit representation, so drivers get an exact header field
> >   offset and length.
> 
> But drivers use offsetof(start of field) to match headers, and I don't
> see you changing that. So how does this work then?

Drivers can only use offsetof() for fields that are on the 32-bits
boundary.

Before this patchset, if you want to mangle the destination port, then
the driver needs to refer to the source port offset and the length is
4 bytes, so the mask is telling what needs to be mangled.

After this patchset, the offset is set to the destination port, the
length is set to 2-bytes, and the mask is telling what bytes of the
destination port field you specifically want to update.

It's just 100 LOC of preprocessing that is simplifying driver
codebase.

> Say - I want to change the second byte of an IPv4 address.

Then, the front-end sets the offset to IPv4 address header field, and
the mask tells what to update.

> > * The front-end coalesces consecutive pedit actions into one single
> >   word, so drivers can mangle IPv6 and ethernet address fields in one
> >   single go.
> 
> You still only coalesce up to 16 bytes, no?

You only have to rise FLOW_ACTION_MANGLE_MAXLEN coming in this patch
if you need more. I don't know of any packet field larger than 16
bytes. If there is a use-case for this, it should be easy to rise that
definition.

> As I said previously drivers will continue to implement mangle action
> merge code if that's the case. It'd be nice if core did the coalescing,
> and mark down first and last action, in case there is a setup cost for
> rewrite group.

In this patchset, the core front-end is doing the coalescing.
