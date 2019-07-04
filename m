Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FAE5F79A
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfGDMDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:03:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33118 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbfGDMDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:03:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hj0S8-0005T8-3A; Thu, 04 Jul 2019 14:03:04 +0200
Message-ID: <6c070d62ffe342f5bc70556ef0f85740d04ae4a3.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Jul 2019 14:03:02 +0200
In-Reply-To: <20190704115236.GR20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
         <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
         <20190703114933.GW2250@nanopsycho> <20190703181851.GP20101@unicorn.suse.cz>
         <20190704080435.GF2250@nanopsycho> <20190704115236.GR20101@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-07-04 at 13:52 +0200, Michal Kubecek wrote:
> 
> There is still the question if it it should be implemented as a nested
> attribute which could look like the current compact form without the
> "list" flag (if there is no mask, it's a list). Or an unstructured data
> block consisting of u32 bit length 

You wouldn't really need the length, since the attribute has a length
already :-)

And then, if you just concatenate the value and mask, the existing
NLA_BITFIELD32 becomes a special case.

> and one or two bitmaps of
> corresponding length. I would prefer the nested attribute, netlink was
> designed to represent structured data, passing structures as binary goes
> against the design (just looked at VFINFO in rtnetlink few days ago,
> it's awful, IMHO).

Yeah, I dunno. On the one hand I completely agree, on the other hand
NLA_BITFIELD32 already goes the other way, and is there now...

> Either way, I would still prefer to have bitmaps represented as an array
> of 32-bit blocks in host byte order. This would be easy to handle in
> kernel both in places where we have u32 based bitmaps and unsigned long
> based ones. Other options seem less appealing:
> 
>   - u8 based: only complicates processing
>   - u64 based: have to care about alignment
>   - unsigned long based: alignment and also problems with 64-bit kernel
>     vs. 32-bit userspace

Agree with this.

johannes

