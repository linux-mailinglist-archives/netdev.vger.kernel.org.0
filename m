Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0787A3D1ECD
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhGVGhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVGhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 02:37:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315B7C061575;
        Thu, 22 Jul 2021 00:18:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m6Sxq-0000W6-JX; Thu, 22 Jul 2021 09:17:50 +0200
Date:   Thu, 22 Jul 2021 09:17:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Message-ID: <20210722071750.GG9904@breakpoint.cc>
References: <20210716151833.GD9904@breakpoint.cc>
 <20210719012151.28324-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719012151.28324-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> Adds support for masquerading into a smaller subset of ports -
> defined by the PSID values from RFC-7597 Section 5.1. This is part of
> the support for MAP-E and Lightweight 4over6, which allows multiple
> devices to share an IPv4 address by splitting the L4 port / id into
> ranges.
> 
> Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
> Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
> ---
> +
> +	/* In this case we are in PSID mode, avoid checking all ranges by computing bitmasks */
> +	if (is_psid) {
> +		u16 power_j = ntohs(max->all) - ntohs(min->all) + 1;

I think this needs to be 'u32 power_j' to prevent overflow of
65535 + 1 -> 0.

> +		if (base)
> +			off = prandom_u32() % (((1 << 16) / base) - 1);

I think this can use prandom_u32_max(((1 << 16) / base) - 1).

I have no other comments.  Other kernel patches LGTM.
