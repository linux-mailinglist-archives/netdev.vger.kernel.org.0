Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE26446E04A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhLIBip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:38:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhLIBip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:38:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6A82B8236A
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 01:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1801C00446;
        Thu,  9 Dec 2021 01:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639013710;
        bh=GP1NEoT8H2cecM6dsiXtvhGKINWXEB0geQD6wyMtb4o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=soVi9QHhi7iXFxzbt3h4+SGwPkcouppzS/TQcXR8PSOYOBawBi1jTCfgrpQBFljeT
         NyAJCnefMydGrap10hpYYd3ABvFi/i8bQD/r5mlkz3WemxIQ05RlfcLrlYxWKCfuoi
         zclLSgIkczdIpN7KaPusuaHlUSGiEFoJh0TcjKwhE73UZvsvuFTUgSizACT8PCmTzX
         jC5UmLQErz7Go/HpFNinw8DMo3iQAY/KaJGpNcPg3omxory22wfKcQF+R8Pem1VnHW
         MFwWu2r8PWWyji8LOFNiT8uDXp7QWfxH2grgVrhvWOZO8oBe+cfYPZhX9JaAzbifrt
         dctreb30NKF8Q==
Date:   Wed, 8 Dec 2021 17:35:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net 0/3] net/sched: Fix ct zone matching for invalid
 conntrack state
Message-ID: <20211208173508.4a9a7f3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208170240.13458-1-paulb@nvidia.com>
References: <20211208170240.13458-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 19:02:37 +0200 Paul Blakey wrote:
> Currently, when a packet is marked as invalid conntrack_in in act_ct,
> post_ct will be set, and connection info (nf_conn) will be removed
> from the skb. Later openvswitch and flower matching will parse this
> as ct_state=+trk+inv. But because the connection info is missing,
> there is also no zone info to match against even though the packet
> is tracked.
> 
> This series fixes that, by passing the last executed zone by act_ct.
> The zone info is passed along from act_ct to the ct flow dissector
> (used by flower to extract zone info) and to ovs, the same way as post_ct
> is passed, via qdisc layer skb cb to dissector, and via skb extension
> to OVS.
> 
> Since there was no more for BPF skb cb to extend the qdisc skb cb,
> tc info on the qdisc skb cb is moved to a tc specific cb that extend it
> instead of within it (same as BPF).

The last paragraph is missing words.

Please repost and cast a wider net for reviewers, you must CC blamed
authors.
