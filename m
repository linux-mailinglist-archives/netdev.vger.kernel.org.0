Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED9C32FA3
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfFCMaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:30:13 -0400
Received: from mail.us.es ([193.147.175.20]:51528 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfFCMaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 08:30:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7EE3C1A68
        for <netdev@vger.kernel.org>; Mon,  3 Jun 2019 14:30:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D53DBDA702
        for <netdev@vger.kernel.org>; Mon,  3 Jun 2019 14:30:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CAB3CDA70A; Mon,  3 Jun 2019 14:30:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2996DA702;
        Mon,  3 Jun 2019 14:30:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 03 Jun 2019 14:30:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 666604265A2F;
        Mon,  3 Jun 2019 14:30:07 +0200 (CEST)
Date:   Mon, 3 Jun 2019 14:30:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190603123006.urztqvxyxcm7w3av@salvia>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
 <20190601150429.GA16560@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601150429.GA16560@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 11:04:29AM -0400, Stephen Suryaputra wrote:
> On Sat, Jun 01, 2019 at 02:22:30AM +0200, Pablo Neira Ayuso wrote:
> > > It is the same as the IPv6 one. The offset returned is the offset to the
> > > specific option (target) or the byte beyond the options if the target
> > > isn't specified (< 0).
> > 
> > Thanks for explaining. So you are using ipv6_find_hdr() as reference,
> > but not sure this offset parameter is useful for this patchset since
> > this is always set to zero, do you have plans to use this in a follow
> > up patchset?
> 
> I developed this patchset to suit my employer needs and there is no plan
> for a follow up patchset, however I think non-zero offset might be useful
> in the future for tunneled packets.

For tunneled traffic, we can store the network offset in the
nft_pktinfo object. Then, add a new extension to update this network
offset to point to the network offset inside the tunnel header, and
use this pkt->network_offset everywhere.

I think this new IPv4 options extension should use priv->offset to
match fields inside the IPv4 option specifically, just like in the
IPv6 extensions and TCP options do. If you look on how the
priv->offset is used in the existing code, this offset points to
values that the specific option field conveys.

Thanks.
