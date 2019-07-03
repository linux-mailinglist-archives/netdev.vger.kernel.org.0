Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B805E5B0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGCNpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:45:09 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38540 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCNpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:45:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hifZC-0000hr-Hn; Wed, 03 Jul 2019 15:44:58 +0200
Message-ID: <b3cd61506080143f571d6286223ae33c8bd02c3a.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Wed, 03 Jul 2019 15:44:57 +0200
In-Reply-To: <20190703114933.GW2250@nanopsycho> (sfid-20190703_134935_025840_EF167268)
References: <cover.1562067622.git.mkubecek@suse.cz>
         <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
         <20190703114933.GW2250@nanopsycho> (sfid-20190703_134935_025840_EF167268)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-03 at 13:49 +0200, Jiri Pirko wrote:
> 
> > +Value and mask must have length at least ETHTOOL_A_BITSET_SIZE bits rounded up
> > +to a multiple of 32 bits. They consist of 32-bit words in host byte order,
> 
> Looks like the blocks are similar to NLA_BITFIELD32. Why don't you user
> nested array of NLA_BITFIELD32 instead?

That would seem kind of awkward to use, IMHO.

Perhaps better to make some kind of generic "arbitrary size bitfield"
attribute type?

Not really sure we want the complexity with _LIST and _SIZE, since you
should always be able to express it as _VALUE and _MASK, right?

Trying to think how we should express this best - bitfield32 is just a
mask/value struct, for arbitrary size I guess we *could* just make it
kind of a binary with arbitrary length that must be a multiple of 2
bytes (or 2 u32-bit-words?) and then the first half is the value and the
second half is the mask? Some more validation would be nicer, but having
a generic attribute that actually is nested is awkward too.

johannes


