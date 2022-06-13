Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E433D549BAA
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiFMShR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245712AbiFMShC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:37:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7695D2452;
        Mon, 13 Jun 2022 07:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kgaOivgVuvl4d3T7CdI1Azd7OrRQH+RXo0cFw9RJT0A=; b=vTPQmgu4pXETpWR2FDU/YUpQJ/
        yWyuh6FtLojBT7/urS3VWhyK0anC/w0ol6jnZKvZTUTF144Ff5aBbZAPEibZNQGKwIv+QfmlQkcHg
        mMI2vk8fqokyNWjX4Ofc8+PMPtGEPAI5RLTJHHsDa05vUNdcxr7sdY5GZHF5YI8dmNag=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o0lUb-006kmW-Sz; Mon, 13 Jun 2022 16:56:37 +0200
Date:   Mon, 13 Jun 2022 16:56:37 +0200
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
Message-ID: <YqdQJepq3Klvr5n5@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
 <YqS+zYHf6eHMWJlD@lunn.ch>
 <20220613125552.GA4536@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613125552.GA4536@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If I see it correctly, there is no way to notify about remote fault when
> the link is up. The remote fault bit is transferred withing Link Code
> Word as part of FLP burst. At least in this part of specification.

Thanks for looking at the specification. So ksetting does seem like
the right API.

Sorry, i won't have time to look at the specification until tomorrow.
The next question is, is it a separate value, or as more link mode
bits? Or a mixture of both? Is there a capability bit somewhere to
indicate this PHY can advertise a remote fault? That would suggest we
want a ETHTOOL_LINK_MODE_REMOTE_FAULT_BIT, which we can set in
supported and maybe see in lpa? Set it in advertising when indicating
a fault. The actual fault value could then be in a separate value
which gets written to the extended page? Does 802.3 allow a remote
fault to be indicated but without the reason?

> So receiving remote fault information via linkstate and send remote fault via
> ksetting?

We could also just broadcast the results of a ksetting get to
userspace?

I don't have easy access to a machine at the moment. What does

ip monitor all

show when a link is configured up, but autoneg fails? And when autoneg
is successful but indicates a remote fault? Are there any existing
messages sent to userspace?

> The next logical question is, if a remote fault is RX'ed (potentially with a
> reason) who will react on this. There might be different policies on how to
> react on same reason.

Policy goes in userspace, is the general rule.

The only exception might be, if we decide to make use of one of these
to silence the link to allow cabling testing. We probably want the
kernel to try to do that.

       Andrew
