Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4564BC9D1
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 19:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbiBSS3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 13:29:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiBSS3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 13:29:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445CC6595;
        Sat, 19 Feb 2022 10:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=reP9JOLT8/GySfc6/C09NUIj+SFYzzGKZaOj+wqaV/Y=; b=GwAzgerQnOuYJUj3c5B1Oko+6E
        +o1JckBomXcuyHe/NrhP1tBvkovL735lZfEKma8soo4YDirNdjfMBqpditNDmcB9AH9i0Pj4d+/Sx
        5i95fp5LJzZwtbwPWtGBr6ABiXBy+k2xc2T7W1E0cN/GqOFd9Cz8X5xCGWrLrPAvz0ns=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nLUSw-006tRh-IM; Sat, 19 Feb 2022 19:28:18 +0100
Date:   Sat, 19 Feb 2022 19:28:18 +0100
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
Message-ID: <YhE2wl7XcTUQvEd4@lunn.ch>
References: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
 <YgwSAjGN2eWUpamo@lunn.ch>
 <4964f8c3-8349-4fad-e176-8c26840d1a08@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964f8c3-8349-4fad-e176-8c26840d1a08@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 06:08:35PM +0800, Heyi Guo wrote:
> Hi Andrew,
> 
> The DHCP issue is gone after applying below patch. I put the lock statements
> outside of the pure reset function, for the phydev lock has been acquired
> before calling adjust_link. The lock order in ftgmac100_reset_task() was
> also changed, to make it the same as the lock procedure in adjust_link, in
> which the phydev is locked first and then rtnl_lock. I'm not quite sure
> whether it will bring in any potential dead lock. Any advice?

Did you run the code with CONFIG_PROVE_LOCKING enabled. That will help
detect possible deadlock situations.

       Andrew
