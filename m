Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0EA5F7A9
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfGDMHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:07:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33182 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfGDMHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:07:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hj0WD-0005Xr-0v; Thu, 04 Jul 2019 14:07:17 +0200
Message-ID: <51ab673812121794b021a09073a74fca33b81210.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Jul 2019 14:07:16 +0200
In-Reply-To: <20190703143724.GD2250@nanopsycho> (sfid-20190703_163726_852714_F806A186)
References: <cover.1562067622.git.mkubecek@suse.cz>
         <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
         <20190703114933.GW2250@nanopsycho>
         <b3cd61506080143f571d6286223ae33c8bd02c3a.camel@sipsolutions.net>
         <20190703143724.GD2250@nanopsycho> (sfid-20190703_163726_852714_F806A186)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-03 at 16:37 +0200, Jiri Pirko wrote:
> Wed, Jul 03, 2019 at 03:44:57PM CEST, johannes@sipsolutions.net wrote:
> > On Wed, 2019-07-03 at 13:49 +0200, Jiri Pirko wrote:
> > > 
> > > > +Value and mask must have length at least ETHTOOL_A_BITSET_SIZE bits rounded up
> > > > +to a multiple of 32 bits. They consist of 32-bit words in host byte order,
> > > 
> > > Looks like the blocks are similar to NLA_BITFIELD32. Why don't you user
> > > nested array of NLA_BITFIELD32 instead?
> > 
> > That would seem kind of awkward to use, IMHO.
> > 
> > Perhaps better to make some kind of generic "arbitrary size bitfield"
> > attribute type?
> 
> Yep, I believe I was trying to make this point during bitfield32
> discussion, failed apparently. So if we have "NLA_BITFIELD" with
> arbitrary size, that sounds good to me.

I guess it could be the same way - just have the content be

u32 value[N];
u32 select[N];

where N = nla_len(attr) / 8

That'd be compatible with NLA_BITFIELD32, and we could basically change
all occurrences of NLA_BITFIELD32 to NLA_BITFIELD, and have NLA_BITFIELD
take something like a "max_bit" for the .len field or something like
that? And an entry in the validation union to point to a "u32 *mask"
instead of the current validation_data that just points to a single u32
mask...

So overall seems like a pretty simple extension to NLA_BITFIELD32 that
handles NLA_BITFIELD32 as a special case with simply .len=32.

(len is a 16-bit field, but a 64k bitmap should be sufficient I hope?)

johannes

