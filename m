Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CC854FDDE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 21:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbiFQTo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 15:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbiFQToY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 15:44:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA4242EF9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 12:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5EF461FF0
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 19:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2631C3411B;
        Fri, 17 Jun 2022 19:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655495062;
        bh=VOnmdE4elYHgDDgAV6ttQlmrwmNEZGGi/lbjWQ0CZuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fQ/KNnjystqPhhFr/g16juKzUWmGTmBTBWiNFA8u+rJKpcnHQg/YG/4j96qSxEscK
         x7YMSxNu/PerhrOzhzkJwzkJfh25Bd0kpfv6FxRIM6csLINwOOGVFyv3potOM7HGv9
         FaQzilU+3OpPCTLl1uzvkbjh2gIA+SKEISVnRjI+5JX4oKI0Fzq6omdu7bhpUAD2sN
         1fRC4OEGiuDCz2L56BzXccZMrtSFl57JQmDK2QXOoa0Q2W/1GraXj+xxF6O0uezNhv
         hiR4XKRrP7BX9uBf6Ya8YI7yAJGKAllNkaqn8M0gXvAHnvKuId1Fi01VmuAbvc3YRT
         H0rlpNwnA3LGA==
Date:   Fri, 17 Jun 2022 12:44:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
Message-ID: <20220617124413.6848c826@kernel.org>
In-Reply-To: <5765.1655484175@famine>
References: <9088.1655407590@famine>
        <20220617084535.6d687ed0@kernel.org>
        <5765.1655484175@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jun 2022 09:42:55 -0700 Jay Vosburgh wrote:
> 	In this case, it's to permit the bonding ARP / ND monitor to
> function if that software device (veth in this case) is added to a bond
> using the ARP / ND monitor (which relies on trans_start, and has done so
> since at least 2.6.0).  I'll agree it's a niche case; this was broken
> for veth for quite some time, but veth + netns is handy for software
> only test cases, so it seems worth doing.

I presume it needs it to check if the device has transmitted anything
in the last unit of time, can we look at the device stats for LLTX for
example?

> 	I didn't exhaustively check all LLTX drivers, but, e.g., tun
> does update trans_start:
> 
> drivers/net/tun.c:
> 
>        /* NETIF_F_LLTX requires to do our own update of trans_start */
>         queue = netdev_get_tx_queue(dev, txq);
>         txq_trans_cond_update(queue);

Well, it is _an_ example, but the only one I can find. And the
justification is the same as yours now -- make bonding work a31d27fb.
Because of that I don't think we can use tun as a proof that trans 
start should be updated on LLTX devices as a general, stack-wide rule.
There's a lot more LLTX devices than veth and tun.
