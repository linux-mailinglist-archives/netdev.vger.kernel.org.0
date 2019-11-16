Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2E2FF5B7
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfKPVJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:09:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:09:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24A60151A2085;
        Sat, 16 Nov 2019 13:09:13 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:09:12 -0800 (PST)
Message-Id: <20191116.130912.1991743343877963205.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, pabeni@redhat.com
Subject: Re: [PATCH net] ipmr: Fix skb headroom in ipmr_get_route().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <01fff31a5e934c1023624a2f00660e06d8d5e9b7.1573838861.git.gnault@redhat.com>
References: <01fff31a5e934c1023624a2f00660e06d8d5e9b7.1573838861.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:09:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Fri, 15 Nov 2019 18:29:52 +0100

> In route.c, inet_rtm_getroute_build_skb() creates an skb with no
> headroom. This skb is then used by inet_rtm_getroute() which may pass
> it to rt_fill_info() and, from there, to ipmr_get_route(). The later
> might try to reuse this skb by cloning it and prepending an IPv4
> header. But since the original skb has no headroom, skb_push() triggers
> skb_under_panic():
 ...
> Actually the original skb used to have enough headroom, but the
> reserve_skb() call was lost with the introduction of
> inet_rtm_getroute_build_skb() by commit 404eb77ea766 ("ipv4: support
> sport, dport and ip_proto in RTM_GETROUTE").
> 
> We could reserve some headroom again in inet_rtm_getroute_build_skb(),
> but this function shouldn't be responsible for handling the special
> case of ipmr_get_route(). Let's handle that directly in
> ipmr_get_route() by calling skb_realloc_headroom() instead of
> skb_clone().
> 
> Fixes: 404eb77ea766 ("ipv4: support sport, dport and ip_proto in RTM_GETROUTE")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied and queued up for -stable.
