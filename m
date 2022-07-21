Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C8357D230
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiGURFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiGURFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:05:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCC7BCA9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=m8xY/cddqSgzbMFHcOpZV5bzM1Xx4ApE7cBkNLW+p0I=; b=EuHp99y6cPP6suRwiSMLFIAIYB
        UISk5NKSA3BzEodryo5U+vd7CXyrC25tLyzHCxaW3801lU3DTe74RqU9F6/kaOE4Hq25n13Itbwpx
        cqCJrd6FsOiJfuM8I5bGgmyMSeshSOBZidcYnXdORjGl9if7CY/jaGdQ7apJ3+yiVh2Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oEZbo-00B3mU-Mk; Thu, 21 Jul 2022 19:05:08 +0200
Date:   Thu, 21 Jul 2022 19:05:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: Handling standalone PCS IRQ
Message-ID: <YtmHRDdbCsDy3Wha@lunn.ch>
References: <20220719143912.2727014-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719143912.2727014-1-dqfext@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 10:39:12PM +0800, Qingfang DENG wrote:
> Hi all,
> 
> I was working with an SoC that has a built-in DWC XPCS with IRQ support.
> However the current driver still uses polling.
> 
> I may modify xpcs_create() to try getting an IRQ number from DT, and fall back
> to polling if it fails (see the code below). But I don't know how to notify
> phylink in the IRQ handler.
> 
> There is a phylink_mac_change() function to notify phylink, but it is supposed
> to be used in a MAC driver, and it requires a (struct phylink *), not a
> (struct phylink_pcs *). Do we need a similar one for PCS?

Russell should really answer this. But my take on this, is yes, you
should add a phylink_pcs_change(), which calls phylink_run_resolve().

As you say, i don't currently see a way to go from phylink_pcs to
phylink. So you might need to add a pointer to phylink_pcs. Just be
careful of race conditions, phylink->pcs can change, and you don't
want an interrupt delivered while it is changing. I would also make
the value in phylink_pcs opaque, we don't want the PCS actually using
information from the phylink structure.

    Andrew
