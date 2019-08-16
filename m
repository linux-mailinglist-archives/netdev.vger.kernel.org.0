Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291C28F84A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfHPBE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:04:27 -0400
Received: from correo.us.es ([193.147.175.20]:39896 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbfHPBE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 21:04:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD011C4148
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 03:04:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB738DA4D0
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 03:04:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C1226DA72F; Fri, 16 Aug 2019 03:04:23 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAB20D2B1A;
        Fri, 16 Aug 2019 03:04:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 16 Aug 2019 03:04:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 869CB4265A2F;
        Fri, 16 Aug 2019 03:04:21 +0200 (CEST)
Date:   Fri, 16 Aug 2019 03:04:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v4 08/12] drivers: net: use flow block API
Message-ID: <20190816010421.if6mbyl2n3fsujy4@salvia>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-9-pablo@netfilter.org>
 <75eec70e-60de-e33b-aea0-be595ca625f4@solarflare.com>
 <20190813195126.ilwtoljk2csco73m@salvia>
 <b3232864-3800-e2a4-9ee3-2cfcf222a148@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3232864-3800-e2a4-9ee3-2cfcf222a148@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 05:17:20PM +0100, Edward Cree wrote:
> On 13/08/2019 20:51, Pablo Neira Ayuso wrote:
> > On Mon, Aug 12, 2019 at 06:50:09PM +0100, Edward Cree wrote:
> >> Pablo, can you explain (because this commit message doesn't) why these per-
> >>  driver lists are needed, and what the information/state is that has module
> >>  (rather than, say, netdevice) scope?
> >
> > The idea is to update drivers to support one flow_block per subsystem,
> > one for ethtool, one for tc, and so on. So far, existing drivers only
> > allow for binding one single flow_block to one of the existing
> > subsystems. So this limitation applies at driver level.
>
> That argues for per-driver _code_, not for per-driver _state_. For instance,
>  each driver could (more logically) store this information in the netdev
>  private data, rather than a static global.  Or even, since each driver
>  instance has a unique cb_ident = netdev_priv(net_dev), this doesn't need to
>  be local to the driver at all and could just belong to the device owning the
>  flow_block (which isn't necessarily the device doing the offload, per
>  indirect blocks).

This list could be placed in netdev_priv() area, yes.

> TBH I'm still not clear why you need a flow_block per subsystem, rather than
>  just having multiple subsystems feed their offload requests through the same
>  flow_block but with different enum tc_setup_type or enum tc_fl_command or
>  some other indication that this is "netfilter" rather than "tc" asking for a
>  tc_cls_flower_offload.

In tc, the flow_block is set up by when the ingress qdisc is
registered. The usual scenario for most drivers is to have one single
flow_block per registered ingress qdisc, this makes a 1:1 mapping
between ingress qdisc and flow_block.

Still, you can register two or more ingress qdiscs to make them share
the same policy via 'tc block'. In that case all those qdiscs use one
single flow_block. This makes a N:1 mapping between these qdisc
ingress and the flow_block. This policy applies to all ingress qdiscs
that are part of the same tc block. By 'tc block', I'm refering to the
tcf_block structure.

In netfilter, there are ingress basechains that are registered per
device. Each basechain gets a flow_block by when the basechain is
registered. Shared blocks as in tcf_block are not yet supported, but
it should not be hard to extend it to make this work.

To reuse the same flow_block as entry point for all subsystems as your
propose - assuming offloads for two or more subsystems are in place -
then all of them would need to have the same block sharing
configuration, which might not be the case, ie. tc ingress might have
a eth0 and eth1 use the same policy via flow_block, while netfilter
might have one basechain for eth0 and another for eth1 (no policy
sharing).

[...]
> This really needs a design document explaining what all the bits are, how
>  they fit together, and why they need to be like that.

I did not design this flow_block abstraction, this concept was already
in place under a different name and extend it so the ethtool/netfilter
subsystems to avoid driver code duplication for offloads. Having said
this, I agree documentation is good to have.
