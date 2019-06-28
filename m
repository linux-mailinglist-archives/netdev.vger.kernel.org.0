Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604CD59E14
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 16:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF1Ome (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 10:42:34 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52732 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfF1Ome (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 10:42:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hgs5A-0003lm-1I; Fri, 28 Jun 2019 16:42:32 +0200
Message-ID: <0092b0b405e02ac7401ceaad2ea650abc44559ea.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: use 48 byte ctx instead of 6 signed longs for
 callback
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 28 Jun 2019 16:42:26 +0200
In-Reply-To: <20190628144022.31376-1-Jason@zx2c4.com>
References: <20190628144022.31376-1-Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-06-28 at 16:40 +0200, Jason A. Donenfeld wrote:
> People are inclined to stuff random things into cb->args[n] because it
> looks like an array of integers. Sometimes people even put u64s in there
> with comments noting that a certain member takes up two slots. The
> horror! Really this should mirror the usage of skb->cb, which are just
> 48 opaque bytes suitable for casting a struct. Then people can create
> their usual casting macros for accessing strongly typed members of a
> struct.
> 
> As a plus, this also gives us the same amount of space on 32bit and 64bit.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

I think this makes a lot of sense - we've got a mess here in many
places, e.g. look at struct nl80211_dump_wiphy_state in nl82011.c, I
think that could fit into the ctx[] since those don't all need to be
'long' (int or even shorter would be OK), we just want many more fields
and somehow it didn't occur to me to cast that "long args[]" array to
another struct ...

Thanks for doing this!

johannes

