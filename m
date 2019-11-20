Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB01031C2
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfKTCr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:47:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfKTCr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 21:47:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D28B1146CFEDD;
        Tue, 19 Nov 2019 18:47:27 -0800 (PST)
Date:   Tue, 19 Nov 2019 18:47:27 -0800 (PST)
Message-Id: <20191119.184727.837407293057991626.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        ecree@solarflare.com, dsahern@gmail.com
Subject: Re: [PATCH net-next v3 0/2] net: introduce and use route hint
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1574165644.git.pabeni@redhat.com>
References: <cover.1574165644.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 18:47:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 19 Nov 2019 15:38:35 +0100

> This series leverages the listification infrastructure to avoid
> unnecessary route lookup on ingress packets. In absence of policy routing,
> packets with equal daddr will usually land on the same dst.
> 
> When processing packet bursts (lists) we can easily reference the previous
> dst entry. When we hit the 'same destination' condition we can avoid the
> route lookup, coping the already available dst.
> 
> Detailed performance numbers are available in the individual commit
> messages. Figures are slightly better then previous iteration because
> thanks to Willem's suggestion we additionally skip early demux when using
> the route hint.
> 
> v2 -> v3:
>  - use fib*_has_custom_rules() helpers (David A.)
>  - add ip*_extract_route_hint() helper (Edward C.)
>  - use prev skb as hint instead of copying data (Willem )
> 
> v1 -> v2:
>  - fix build issue with !CONFIG_IP*_MULTIPLE_TABLES
>  - fix potential race in ip6_list_rcv_finish()

To reiterate David A.'s feedback, having this depend upon
IP_MULTIPLE_TABLES being disabled is %100 a non-starter.

No distribution will benefit from these changes at all.
