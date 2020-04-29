Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA2B1BE73C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgD2TVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726524AbgD2TVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:21:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA98C03C1AE;
        Wed, 29 Apr 2020 12:21:21 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTsGi-0025CO-Mz; Wed, 29 Apr 2020 21:21:16 +0200
Message-ID: <faf336e3ba515d41211910f3d8d207e693434cb9.camel@sipsolutions.net>
Subject: Re: [PATCH 4/7] netlink: extend policy range validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Antonio Quartulli <ordex@autistici.org>,
        linux-wireless@vger.kernel.org
Date:   Wed, 29 Apr 2020 21:21:15 +0200
In-Reply-To: <20200429111034.71ab2443@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200429134843.42224-1-johannes@sipsolutions.net>
         <20200429154836.b86f45043a5e.I7b46d9c85e4d7a99c0b5e0c2f54bb89b5750e6dc@changeid>
         <20200429111034.71ab2443@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-29 at 11:10 -0700, Jakub Kicinski wrote:

> > +static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
> > +					   const struct nlattr *nla,
> > +					   struct netlink_ext_ack *extack)
> >  {
> > -	bool validate_min, validate_max;
> > -	s64 value;
> > +	struct netlink_range_validation _range = {
> > +		.min = 0,
> > +		.max = U64_MAX,
> > +	}, *range = &_range;
> > +	u64 value;
> >  
> > -	validate_min = pt->validation_type == NLA_VALIDATE_RANGE ||
> > -		       pt->validation_type == NLA_VALIDATE_MIN;
> > -	validate_max = pt->validation_type == NLA_VALIDATE_RANGE ||
> > -		       pt->validation_type == NLA_VALIDATE_MAX;
> > +	WARN_ON_ONCE(pt->min < 0 || pt->max < 0);
> 
> I'm probably missing something, but in case of NLA_VALIDATE_RANGE_PTR
> aren't min and max invalid (union has the range pointer set, so this
> will read 2 bytes of the pointer).

No, you're right of course. It's reading 4 bytes, actually, they're both
s16. Which I did because that's the maximum range that doesn't increase
the size on 32-bit.

I could move it into the switch, but, hm.. the unused ones (min/max if
only one is used) should be 0, so I guess just

	WARN_ON_ONCE(pt->validation_type != NLA_VALIDATE_RANGE_PTR &&
                     (pt->min < 0 || pt->max < 0));

will be fine.

Thanks!

johannes


