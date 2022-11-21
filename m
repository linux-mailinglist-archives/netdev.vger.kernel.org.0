Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4FD63263A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiKUOin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKUOhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:37:48 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32A85DBAF;
        Mon, 21 Nov 2022 06:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OIMZGGKQ4c3XjKtX4PeLIcji0Qw9vqHZS0eq05MrW1g=; b=Whejk4/X8booZmCJGB2b3ePj6M
        E+SnclYNh/pxj3zZ2zutCWnjZnbj6V9A6toZI3KEFxDPPX7H8QfYBNm78OihD+5A5/RabmmroxnyF
        gURr5R23/B00hlzncFGExtDVPz9OPvx9Rsr6LC0VWkShwoRCf+xCYZ99j7SgtqukpW/0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ox7ug-00316I-I2; Mon, 21 Nov 2022 15:36:46 +0100
Date:   Mon, 21 Nov 2022 15:36:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yusongping@huawei.com
Subject: Re: [PATCH net v2] net: mdio-ipq4019: fix possible invalid pointer
 dereference
Message-ID: <Y3uM/qNkI8Cqiqr4@lunn.ch>
References: <20221117090514.118296-1-tanghui20@huawei.com>
 <Y3Y94/My9Al4pw+h@lunn.ch>
 <6cad3105-0e70-d890-162b-513855885fde@huawei.com>
 <Y3eMMc7maaPCKUNS@lunn.ch>
 <3cb5a576-8eb7-54fc-4f4b-9db360b6713d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cb5a576-8eb7-54fc-4f4b-9db360b6713d@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi, Andrew
> 
> My new patchset is ready, but I just found out that another patch has been
> applied to netdev/net.git. Can I solve the problem in present way? And I
> will add devm_ioremap_resource_optional() helper later to optimize related
> drivers. How about this?

This is one of those harder to merge changes. patches to lib/devres.c
generally go via GregKH. Networking changes are merged via the netdev
list.

Did you find this issue via a static analyser? I assume you are
running it over the entire tree and are finding problems in multiple
subsystems? So devm_ioremap_resource_optional() is potentially going
to be needed in lots of places?

One way to get this merged is to cross post the patch adding
devm_ioremap_resource_optional() and ask GregKH to ACK it, and then
get netdev to merge it. You can then use it within the netdev
subsystem. What you cannot do is use it in other subsystems until the
next kernel cycle when it will be globally available.

So three patches. One adding devm_ioremap_resource_optional(), one to
revert the 'fix', and one with the real fix using
devm_ioremap_resource_optional().

     Andrew
