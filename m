Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6738E4BED05
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 23:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiBUWJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 17:09:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiBUWJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 17:09:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71DDE5A;
        Mon, 21 Feb 2022 14:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=+Yh0NkVUkr1543FXohP7uVf0y3aW8/RHNzP/DPSASDs=; b=nx
        GaVeSCvASp+apT7hnSFsBAqEmqpn187kng60Y1gjwuOMSbUh6UveF8WeiTV+UdIpNp2wKniVwxjZl
        4ZqDbqcoxuPJWSm8yq7tvNDzzzH9SypWARQPaeXHUzGl+q3lkGK9j1F+UEpa+eTJA9AOroHnFpMwE
        +xiYniW8+FLNSyU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMGrx-007RMB-4J; Mon, 21 Feb 2022 23:09:21 +0100
Date:   Mon, 21 Feb 2022 23:09:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heyi Guo <guoheyi@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Issue report] drivers/ftgmac100: DHCP occasionally fails during
 boot up or link down/up
Message-ID: <YhQNkQDwqUag1UmA@lunn.ch>
References: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
 <YgwSAjGN2eWUpamo@lunn.ch>
 <4964f8c3-8349-4fad-e176-8c26840d1a08@linux.alibaba.com>
 <YhE2wl7XcTUQvEd4@lunn.ch>
 <1a7e74b4-8827-c14b-7371-9656a643d03c@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a7e74b4-8827-c14b-7371-9656a643d03c@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [   16.872475]  Possible unsafe locking scenario:
> [   16.872475]
> [   16.872478]        CPU0                    CPU1
> [   16.872482]        ----                    ----
> [   16.872485]   lock(&dev->lock);
> [   16.872495]                                lock(rtnl_mutex);
> [   16.872505] lock(&dev->lock);

It looks like the whitespace got messed up here, and it should
actually be:
> [   16.872505]                                lock(&dev->lock);

> [   16.872513]   lock(rtnl_mutex);

So if up calls open() which first takes rtnl and then the
phydev->lock.

adjust link is called with phydev->lock already held and it then takes
the rtnl. Deadlock.

During the adjust_list callback, the phydev lock is held so the
contents of phydev are consistent. What you could do is make a copy of
what you need and then release phydev lock. You can then take rtnl and
do the reset. Once the reset is finished, program MAC with the copy
you took from phydev. Then lock phydev again, and return.

    Andrew
