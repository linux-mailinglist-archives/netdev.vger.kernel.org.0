Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294914E7728
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 16:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356531AbiCYP1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 11:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377086AbiCYPXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 11:23:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E873E5410
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5uGdLlhZA23tbglQnVu7FWKny0XeHQdBzrTAhk2Q5Uo=; b=trIlRgFerIPmKwULU+gtHXj0N6
        WGeruh4i62mNsDPxhr0NwoD6XNY6xptLYuwNW++CQLD6MxlJvMFBKHpe1JdiZiANEuy5NRGrmsmqo
        Hn63w1xqroWSBciE29w9cJ5N2giLPWrhyB0xevpNe4VuYZlAEVbbAVwQSVBY8BLZt9lc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXlgf-00Ce9B-NS; Fri, 25 Mar 2022 16:17:13 +0100
Date:   Fri, 25 Mar 2022 16:17:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO timeout and polled IO
Message-ID: <Yj3c+cDzdvsUbYtp@lunn.ch>
References: <20220325140808.GA1047855@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325140808.GA1047855@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 03:08:08PM +0100, Francesco Dolcini wrote:
> Hello Andrew and all,
> I was recently debugging an issue in the FEC driver, about 2% of the
> time the driver is failing with "MDIO read timeout" at boot on a 5.4
> kernel.
> 
> This issue is not new and from time to time appear again, it seems that
> the previous interrupt based mechanism is somehow easy to break.
> 
> I backported your patch
> f166f890c8f0 (net: ethernet: fec: Replace interrupt driven MDIO with polled IO, 2020-05-02)
> to kernel 5.4 and it seems that it fixes the issue (I was able to do 470
> power cycles, while before it was failing after a couple of hundreds
> cycles best case).
> 
> Shouldn't this patch be backported to kernel 5.4? 

Hi Francesco

This patch was purely a performance boost, it was not a bug fix in any
way. That change also caused a lot of pain. There are at least two
different implementations of the MDIO bus in the FEC, and they
behaviour slightly differently. So what worked for me with the Vybrid
broke some other platforms. It took an NXP software engineer talking
to there hardware guys to figure out how to do this correctly. Which
is why you will see a complicated patch history.

I personally would not recommend a back port, unless you can test the
back port on a wide range of SoC with the FEC.

If you are getting timeouts, i would suggest you look at whatever else
is happening in the system during boot. Are interrupts getting
disabled for too long? Is something blocking the running of the
completion?

Or just update to v5.15.

   Andrew
