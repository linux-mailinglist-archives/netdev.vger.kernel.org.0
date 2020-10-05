Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFAA283F98
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgJET0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJET0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:26:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22707C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:26:09 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPW7S-00HOMO-TO; Mon, 05 Oct 2020 21:25:59 +0200
Message-ID: <18fc3d1719ce09d5aa145a164bf407fe7a7bbb81.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz,
        dsahern@gmail.com, pablo@netfilter.org
Date:   Mon, 05 Oct 2020 21:25:57 +0200
In-Reply-To: <20201005122242.48ed17cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-6-kuba@kernel.org>
         <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
         <20201005122242.48ed17cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 12:22 -0700, Jakub Kicinski wrote:

> > > +	if (value & ~(u64)pt->mask) {
> > > +		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
> > > +		return -EINVAL;  
> > 
> > You had an export of the valid bits there in ethtool, using the cookie.
> > Just pointing out you lost it now. I'm not sure I like using the cookie,
> > that seems a bit strange, but we could easily define a different attr?
> > 
> > OTOH, one can always query the policy export too (which hopefully got
> > wired up) so it wouldn't really matter much.
> 
> My thinking is that there are no known uses of the cookie, it'd only
> have practical use to test for new flags - and we're adding first new
> flag in 5.10.

Hm, wait, not sure I understand?

You _had_ this in ethtool, but you removed it now. And you're not
keeping it here, afaict.

I can't disagree on the "no known uses of the cookie" part, but it feels
odd to me anyway - since that is just another netlink message (*), you
could as well add a "NLMSGERR_ATTR_VALID_FLAGS" instead of sticking the
data into the cookie?

But then are you saying the new flags are only in 5.10 so the policy
export will be sufficient, since that's also wired up now?

johannes

(*) in a way - the ack message has the "legacy" fixed part before the
attrs, of course

