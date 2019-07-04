Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54315F8E5
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfGDNKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:10:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34078 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfGDNKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:10:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hj1V6-0007UI-Gl; Thu, 04 Jul 2019 15:10:12 +0200
Message-ID: <a6fbee05df0efd2528a06922bcb514d321b1a8bc.camel@sipsolutions.net>
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
Date:   Thu, 04 Jul 2019 15:10:11 +0200
In-Reply-To: <20190704125315.GT20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
         <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
         <20190703114933.GW2250@nanopsycho> <20190703181851.GP20101@unicorn.suse.cz>
         <20190704080435.GF2250@nanopsycho> <20190704115236.GR20101@unicorn.suse.cz>
         <6c070d62ffe342f5bc70556ef0f85740d04ae4a3.camel@sipsolutions.net>
         <20190704121718.GS20101@unicorn.suse.cz>
         <2f1a8edb0b000b4eb7adcaca0d1fb05fdd73a587.camel@sipsolutions.net>
         <20190704125315.GT20101@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-07-04 at 14:53 +0200, Michal Kubecek wrote:
> 
> >  value: 0b00000000'000000xx'xxxxxxxx'xxxxxxxx
> >  mask:  0b00000000'00000011'11111111'11111111
> 
> One scenario that I can see from the top of my head would be user
> running
> 
>   ethtool -s <dev> advertise 0x...

The "0x..." here would be the *value* in the NLA_BITFIELD32 parlance,
right?

What would the "selector" be? I assume the selector would be "whatever
ethtool knows about"?

> with hex value representing some subset of link modes. Now if ethtool
> version is behind kernel and recognizes fewer link modes than kernel
> but in a way that the number rounded up to bytes or words would be the
> same, kernel has no way to recognize of those zero bits on top of the
> mask are zero on purpose or just because userspace doesn't know about
> them. In general, I believe the absence of bit length information is
> something protocols would have to work around sometimes.
> 
> The submitted implementation doesn't have this problem as it can tell
> kernel "this is a list" (i.e. I'm not sending a value/mask pair, I want
> exactly these bits to be set).

OK, here I guess I see what you mean. You're saying if ethtool were to
send a value/mask of "0..0100/0..0111" you wouldn't know what to do with
BIT(4) as long as the kernel knows about that bit?

I guess the difference now is depending on the operation. NLA_BITFIELD32
is sort of built on the assumption of having a "toggle" operation. If
you want to have a "set to" operation, then you don't really need the
selector/mask at all, just the value.

johannes

