Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AF74D69C4
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 21:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiCKU6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 15:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiCKU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 15:57:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0C6207A34
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 12:56:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4530B82D5A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 20:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AB8C340E9;
        Fri, 11 Mar 2022 20:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647032171;
        bh=Z1Fz26ZGUphVna457mPG030xoo5Xq+IOtFFvRPLjqwk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AftCryC/g86kFhgT71vqntcdlUxfVfQvmUktBaf2C+PeaZJ8cjZdj289Td0YSvdee
         HTHsCSkQmM+K73YlDJpeozEI6O5p7uzSkS6eC3i2haFVdl6OS3F8tjp1B1PC/uPwdG
         GIzm37bPyqe6iNg/MVuS9G6bQh/t7hj+PRtGDB4TGa9Q3C6KXgMTDv0t0vWVcOqavw
         d2Rtyv/7NVMdU5TXmjiECRVQO0XvYtR6vyJD+sWYP985Jeg3sPEtuzxgw+uY1kFMg1
         ckR4VVt3wG2xjPJwOf/nqbXahQ7eG4p2zU1bFc6rsxz8p9XQtpORwRTMn7o4zg7Q2c
         GvS6Zy7DA9J4w==
Date:   Fri, 11 Mar 2022 12:56:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v2 1/3] netdevsim: Introduce support for L3
 offload xstats
Message-ID: <20220311125610.3a076be2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7480f1df343e383234e7f197d78c180eefe92e89.1647009587.git.petrm@nvidia.com>
References: <cover.1647009587.git.petrm@nvidia.com>
        <7480f1df343e383234e7f197d78c180eefe92e89.1647009587.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 15:41:22 +0100 Petr Machata wrote:
> Add support for testing of HW stats support that was added recently, namely
> the L3 stats support. L3 stats are provided for devices for which the L3
> stats have been turned on, and that were enabled for netdevsim through a
> debugfs toggle:
> 
>     # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/enable_ifindex
> 
> For fully enabled netdevices, netdevsim counts 10pps of ingress traffic and
> 20pps of egress traffic. Similarly, L3 stats can be disabled for a given
> device, and netdevsim ceases pretending there is any HW traffic going on:
> 
>     # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/disable_ifindex
> 
> Besides this, there is a third toggle to mark a device for future failure:
> 
>     # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/fail_next_enable
> 
> A future request to enable L3 stats on such netdevice will be bounced by
> netdevsim:
> 
>     # ip -j l sh dev d | jq '.[].ifindex'
>     66
>     # echo 66 > /sys/kernel/debug/netdevsim/netdevsim10/hwstats/l3/enable_ifindex
>     # echo 66 > /sys/kernel/debug/netdevsim/netdevsim10/hwstats/l3/fail_next_enable
>     # ip stats set dev d l3_stats on
>     Error: netdevsim: Stats enablement set to fail.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
