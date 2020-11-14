Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F1E2B2CFC
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 13:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgKNMBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 07:01:04 -0500
Received: from correo.us.es ([193.147.175.20]:41346 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgKNMBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 07:01:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A77EFFBA4
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 13:01:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F17E9DA792
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 13:00:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E73AFDA796; Sat, 14 Nov 2020 13:00:59 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF614DA72F;
        Sat, 14 Nov 2020 13:00:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 14 Nov 2020 13:00:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B1C2D42EFB80;
        Sat, 14 Nov 2020 13:00:57 +0100 (CET)
Date:   Sat, 14 Nov 2020 13:00:57 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 3/9] net: resolve forwarding path from
 virtual netdevice and HW destination address
Message-ID: <20201114120057.GB21025@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201111193737.1793-4-pablo@netfilter.org>
 <20201113174246.300997fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201113174246.300997fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 05:42:46PM -0800, Jakub Kicinski wrote:
> On Wed, 11 Nov 2020 20:37:31 +0100 Pablo Neira Ayuso wrote:
> > +int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
> > +			  struct net_device_path_stack *stack)
> > +{
> > +	const struct net_device *last_dev;
> > +	struct net_device_path_ctx ctx;
> > +	struct net_device_path *path;
> > +	int ret = 0;
> > +
> > +	memset(&ctx, 0, sizeof(ctx));
> > +	ctx.dev = dev;
> > +	ctx.daddr = daddr;
> > +
> > +	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
> > +		last_dev = ctx.dev;
> > +
> > +		path = &stack->path[stack->num_paths++];
> 
> I don't see you checking that this stack doesn't overflow.
> 
> What am I missing?

Yes, this check in missing indeed.

I'll fix it and will include it in the next patchset version including
Nikolay's request.

Thank you.
