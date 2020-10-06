Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BD3284B21
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgJFLw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 07:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgJFLw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 07:52:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DC3C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 04:52:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPlWO-000DTG-E6; Tue, 06 Oct 2020 13:52:44 +0200
Message-ID: <f302acfdb9558ebe0ddedc7726beba7d388fffda.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Date:   Tue, 06 Oct 2020 13:52:43 +0200
In-Reply-To: <3418a5af0030a7d4aa447fd8d6ef75b0a6cb3259.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-6-kuba@kernel.org>
         <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
         <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
         <93103e3d9496ea0e3e3b9e7f9850c9b12f2397b6.camel@sipsolutions.net>
         <20201005124029.5ebe684d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <37c768d663f7f3158f1bfae6d7e1aa86e76e9880.camel@sipsolutions.net>
         <667995b1fe577e6c6c562856fe85cb1a853acb68.camel@sipsolutions.net>
         <20201005152110.42b8e71e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3418a5af0030a7d4aa447fd8d6ef75b0a6cb3259.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-06 at 08:37 +0200, Johannes Berg wrote:
> On Mon, 2020-10-05 at 15:21 -0700, Jakub Kicinski wrote:
> 
> > > > Nice, easy & useful, maybe I'll code it up tomorrow.  
> > > 
> > > OK I thought about it a bit more and looked at the code, and it's not
> > > actually possible to do easily right now, because we can't actually
> > > point to the bad attribute from the general lib/nlattr.c code ...
> > > 
> > > Why? Because we don't know right now, e.g. for nla_validate(), where in
> > > the message we started validation, i.e. the offset of the "head" inside
> > > the particular message.
> > > 
> > > For nlmsg_parse() and friends that's a bit easier, but it needs more
> > > rejiggering than I'm willing to do tonight ;)
> > 
> > I thought we'd record the const struct nla_policy *tp for the failing
> > attr in struct netlink_ext_ack and output based on that.
> 
> We could, but it's a bit useless if you know "which" attribute caused
> the issue, but you don't know where it was in the message? That way you
> wouldn't know the nesting level etc.
> 
> I mean, we actually have that problem today - the generic lib/nlattr.c
> policy violation doesn't tell you where exactly the problem occurred, so
> it'd be good to fix that regardless.

Just for the record: I'm obviously *completely* confused, of course we
do say which attribute was bad, I was just looking for the offset, but
we carry around a pointer and calculate the offset later,
with NL_SET_ERR_MSG_ATTR() or NL_SET_BAD_ATTR().

Which means this isn't so hard ...

johannes

