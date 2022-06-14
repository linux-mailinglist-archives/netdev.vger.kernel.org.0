Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454FA54BCE1
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357988AbiFNViK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354348AbiFNViK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:38:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C7F11460;
        Tue, 14 Jun 2022 14:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xfkmdhpjTHYwAxAIlk0l1dxq56t6l3kfqLcC/dieiG4=; b=LxLdA4enRhmptfXjFIE1ZGX2GR
        LnWi+6re2QkFS/MNWzJT/VzU2JUJDfWYhwbqvdGZf6DTwayZR8AAYAqUpEXekUAu1m3lDEandyv4i
        d9s7dPBc3ZzLnVMG1OwlNoHR0Up//E4sT7+WfpXUGUOtumvnaBdzlUsdW9nAfQlSifzg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1EES-006vrA-Sv; Tue, 14 Jun 2022 23:37:52 +0200
Date:   Tue, 14 Jun 2022 23:37:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <Yqj/sKRXx/98VQ5Y@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
 <YqS+zYHf6eHMWJlD@lunn.ch>
 <20220613125552.GA4536@pengutronix.de>
 <YqdQJepq3Klvr5n5@lunn.ch>
 <20220614051217.GC4536@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614051217.GC4536@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 07:12:17AM +0200, Oleksij Rempel wrote:
> On Mon, Jun 13, 2022 at 04:56:37PM +0200, Andrew Lunn wrote:
> > > If I see it correctly, there is no way to notify about remote fault when
> > > the link is up. The remote fault bit is transferred withing Link Code
> > > Word as part of FLP burst. At least in this part of specification.
> > 
> > Thanks for looking at the specification. So ksetting does seem like
> > the right API.
> > 
> > Sorry, i won't have time to look at the specification until tomorrow.
> > The next question is, is it a separate value, or as more link mode
> > bits? Or a mixture of both? 
> 
> It is the bit D13 within Base Link Codeword as described in "28.2.1.2
> Link codeword encoding". Every PHY will send or receive it, but may be
> not every PHY will allow to set this bit.
> 
> The actual error value can be optionally transmitted separately withing the
> "Next Page".

So the API needs to handle it being optional. We have a bit indicating
a remote fault has been indicated, and then a code which might
indicate more details.

> by using ethnl_multicast()? I it something what should be implemented?

Yes, that sounds about right. 

It would be nice if we could add generic code for c22, but i guess
that is out of scope for you, you seem to be doing C45. However, it
would be nice if it just worked for all C45 PHYs which follow the
standard.

      Andrew
