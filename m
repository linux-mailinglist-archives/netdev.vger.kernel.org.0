Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4354546F8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhKQNPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhKQNPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:15:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFA0C061570;
        Wed, 17 Nov 2021 05:12:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mnKk4-0000nK-7E; Wed, 17 Nov 2021 14:12:48 +0100
Date:   Wed, 17 Nov 2021 14:12:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: "AVX2-based lookup implementation" has broken ebtables
 --among-src
Message-ID: <20211117131248.GJ6326@breakpoint.cc>
References: <d35db9d6-0727-1296-fa78-4efeadf3319c@virtuozzo.com>
 <20211116173352.1a5ff66a@elisabeth>
 <20211117120609.GI6326@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117120609.GI6326@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Might be a bug in ebtables.  This is what nft monitor shows:
> 
> add chain bridge filter INPUT { type filter hook input priority filter;
> 	policy accept; }
> 	add rule bridge filter INPUT ether saddr . ip saddr {
> 08:00:27:40:f7:09 .
> 	   192.168.56.10-0x1297286e2b2 [..]

nft monitor calls interval_map_decompose() even though it should not
in this case.  After fix this shows:

add rule bridge filter INPUT ether saddr . ip saddr { 08:00:27:40:f7:09 . 192.168.56.10, 08:00:27:40:f7:09 . 192.168.56.10 } counter

... instead, which looks correct (even though
the concat range is technically not required in this case).
