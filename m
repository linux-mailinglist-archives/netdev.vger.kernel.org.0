Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDF44D93E1
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbiCOFcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiCOFcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132444926A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C24A611E3
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 05:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97D7C340E8;
        Tue, 15 Mar 2022 05:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647322296;
        bh=qssovgxvnwLzcgqv29h/zmzhXs4elYmTb7CiGVzELKg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JISJZSeef1RrQvxkyjfjxY25kSpbJZkH9U4wTxh1Fa+QpEWZbsFTONOeKGT7swIZW
         crPbWyBzWz6hZhR9Q+lguCKQPaHmpPob1re7uzczgW9yviY6a9i+Y0BRorIQ1QAvWK
         JaYNkXXnVdnfzVkAI2OA9BTewsxHepFWaGUut/yZYDglAm83thFJkxZtYNB9tyHaM5
         KfcdVO2DbqOfQ65LZiFZRXBO4AOrVJG6A3azatQyr1nwnzn7zLkGSbcUCS9/xG12fQ
         cr/I1vuhPFoM0+R9zWjF6MhLZTgxYSZeFMUnOYrUzNqwPqKOo8Mc7J1y2k2fgCPw5e
         +SCJsUdzPRYRg==
Date:   Mon, 14 Mar 2022 22:31:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v3 1/3] netdevsim: Introduce support for L3
 offload xstats
Message-ID: <20220314223134.51e28932@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fa28d4ff7f55fec4928990850dc1abf8fac3eb45.1647265833.git.petrm@nvidia.com>
References: <cover.1647265833.git.petrm@nvidia.com>
        <fa28d4ff7f55fec4928990850dc1abf8fac3eb45.1647265833.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 15:01:15 +0100 Petr Machata wrote:
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
