Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D120180A7
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 21:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfEHTuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 15:50:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58807 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbfEHTuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 15:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5DOmx//fzezxXgA6dXN4cXOSgxB/Losdvoy8bCClEOA=; b=oijb849rOm0vwPxJ/7MRCE3fwS
        OaJ6Z+jCbi0UjJwtOezbYLCkNIRF/My7PBlpqOSQd1Q0yzUQMaOZ9e02lKGkZ1oMGvccaeU+qDsq/
        I7DkChQVJDsHTk3IENfEkBiXRnzBhPUBqXEk2QjInxyfWs+Hd0NjGiY0dIdDCirEcyKg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOSZv-0004Mv-45; Wed, 08 May 2019 21:50:11 +0200
Date:   Wed, 8 May 2019 21:50:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 00/11] net: stmmac: Selftests
Message-ID: <20190508195011.GK25013@lunn.ch>
References: <cover.1557300602.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 09:51:00AM +0200, Jose Abreu wrote:
> [ Submitting with net-next closed for proper review and testing. ]
> 
> This introduces selftests support in stmmac driver. We add 4 basic sanity
> checks and MAC loopback support for all cores within the driver. This way
> more tests can easily be added in the future and can be run in virtually
> any MAC/GMAC/QoS/XGMAC platform.
> 
> Having this we can find regressions and missing features in the driver
> while at the same time we can check if the IP is correctly working.
> 
> We have been using this for some time now and I do have more tests to
> submit in the feature. My experience is that although writing the tests
> adds more development time, the gain results are obvious.
> 
> I let this feature optional within the driver under a Kconfig option.
> 
> For this series the output result will be something like this
> (e.g. for dwmac1000):
> ----
> # ethtool -t eth0
> The test result is PASS
> The test extra info:
> 1. MAC Loopback                 0
> 2. PHY Loopback                 -95
> 3. MMC Counters                 0
> 4. EEE                          -95
> 5. Hash Filter MC               0
> 6. Perfect Filter UC            0
> 7. Flow Control                 0

Hi Jose

The man page says:

       -t --test
              Executes adapter selftest on the specified network
              device. Possible test modes are:

           offline
                  Perform full set of tests, possibly interrupting
                  normal operation during the tests,

           online Perform limited set of tests, not interrupting
                  normal operation,

           external_lb
                  Perform full set of tests, as for offline, and
                  additionally an external-loopback test.

The normal operation is interrupted by the tests you carry out
here. But i don't see any code looking for ETH_TEST_FL_OFFLINE

> (Error code -95 means EOPNOTSUPP in current HW).

How deep do you have to go before you know about EOPNOTSUPP?  It would
be better to not return the string and result at all. Or patch ethtool
to call strerror(3).

   Andrew
