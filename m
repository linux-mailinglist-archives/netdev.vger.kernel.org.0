Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C35C283FE2
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgJETxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgJETxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:53:19 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A20C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:53:18 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPWXp-00HPJX-ME; Mon, 05 Oct 2020 21:53:13 +0200
Message-ID: <37c768d663f7f3158f1bfae6d7e1aa86e76e9880.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Date:   Mon, 05 Oct 2020 21:53:12 +0200
In-Reply-To: <20201005124029.5ebe684d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-6-kuba@kernel.org>
         <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
         <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
         <93103e3d9496ea0e3e3b9e7f9850c9b12f2397b6.camel@sipsolutions.net>
         <20201005124029.5ebe684d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 12:40 -0700, Jakub Kicinski wrote:

> > I would totally support doing that here in the general validation code,
> > but (again) don't really think NLMSGERR_ATTR_COOKIE is an appropriate
> > attribute for it.
> 
> Hm. Perhaps we can do a partial policy dump into the extack?

Hm. I like that idea.

If we have NLMSGERR_ATTR_OFFS we could accompany that with the sub-
policy for that particular attribute, something like

[NLMSGERR_ATTR_POLICY] = nested {
  [NL_POLICY_TYPE_ATTR_TYPE] = ...
  [NL_POLICY_TYPE_ATTR_MASK] = ...
}

which we could basically do by factoring out the inner portion of
netlink_policy_dump_write():

	attr = nla_nest_start(skb, state->attr_idx);
	if (!attr)
		goto nla_put_failure;
	...
	nla_nest_end(skb, attr);

from there into a separate function, give it the pt and the nested
attribute (what's "state->attr_idx" here) as arguments, and then we call
it with NLMSGERR_ATTR_POLICY from here, and with "state->attr_idx" from
netlink_policy_dump_write() :-)

Nice, easy & useful, maybe I'll code it up tomorrow.

> Either way, I don't feel like this series needs it.

Fair enough.

johannes

