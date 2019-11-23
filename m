Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECB4107ED2
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 15:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKWOXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 09:23:09 -0500
Received: from bmailout1.hostsharing.net ([83.223.95.100]:43737 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfKWOXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 09:23:09 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id EA1D030022AC1;
        Sat, 23 Nov 2019 15:23:05 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id C093D70E401; Sat, 23 Nov 2019 15:23:05 +0100 (CET)
Date:   Sat, 23 Nov 2019 15:23:05 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH nf-next,RFC 5/5] netfilter: Introduce egress hook
Message-ID: <20191123142305.g2kkaudhhyui22fq@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
 <de461181e53bcec9a75a9630d0d998d555dc8bf5.1572528497.git.lukas@wunner.de>
 <d5876ef3-bcee-e0b2-273e-e0405fe17b79@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5876ef3-bcee-e0b2-273e-e0405fe17b79@iogearbox.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 11:39:58PM +0100, Daniel Borkmann wrote:
> On 10/31/19 2:41 PM, Lukas Wunner wrote:
> > Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> > handle_ing() under unique static key") introduced the ability to
> > classify packets on ingress.
> > 
> > Allow the same on egress.
> > 
> > The need for this arose because I had to filter egress packets which do
> > not match a specific ethertype.  The most common solution appears to be
> > to enslave the interface to a bridge and use ebtables, but that's
> > cumbersome to configure and comes with a (small) performance penalty.
> > An alternative approach is tc, but that doesn't afford equivalent
> > matching options as netfilter.
> 
> Hmm, have you tried tc BPF on the egress hook (via sch_cls_act -> cls_bpf)?

There's another reason I chose netfilter over tc:  I need to activate the
filter from a kernel module, hence need an in-kernel (rather than user space)
API.

netfilter provides that via nf_register_net_hook(), I couldn't find
anything similar for tc.  And an egress netfilter hook seemed like
an obvious missing feature given the presence of an ingress hook.

The module I need this for is out-of-tree:
https://github.com/RevolutionPi/piControl/commit/da199ccd2099

In my experience the argument that a feature is needed for an out-of-tree
module holds zero value upstream.  If there's no in-tree user, the feature
isn't merged, I've seen this more than enough.  Which is why I didn't mention
it in the first place.

For our use case I wouldn't even need the nft user space support which I
posted separately, I just implemented it for completeness and to increase
acceptability of the present series.

Thanks,

Lukas
