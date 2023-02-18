Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1947369B75E
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBRBQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBRBQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:16:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23AD2528C;
        Fri, 17 Feb 2023 17:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+ptoffDVYgxt0P2DE5JtekmfBaZOv2MwgelUi56EYdk=; b=CWYL+oFvvItR6oQuAmSJ5lqYhB
        u+/OAyoKYXzOik3PnH//s4FxRBjbNyCBu8PnPMLfwYq89cLpPOAd/Na8q8Ct1bQu0oG6WGR8XIuAM
        HykoKy6IObvy4JI8SM/CGVhsOJ343obkV5evGmdFkODl3fSbYNP9vLi6K66HCn49Yh1o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTBpP-005M8A-8X; Sat, 18 Feb 2023 02:15:51 +0100
Date:   Sat, 18 Feb 2023 02:15:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Message-ID: <Y/Amx27oh9Z1uMSp@lunn.ch>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <Y+pjl3vzi7TQcLKm@lunn.ch>
 <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com>
 <Y+p8WZCPKhp4/RIH@lunn.ch>
 <DB9PR04MB810669A4AC47DE2F0CBEA25B88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Y+uamTHJSaNHvTbU@lunn.ch>
 <DB9PR04MB810629C2CEB106787D6A2B8C88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB810629C2CEB106787D6A2B8C88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I have tested the pure software CBS today. And below are the test steps and results.
> Link speed 100Mbps.
> Queue 0: Non-CBS queue, 100Mbps traffic.
> Queue 1: CBS queue, 7Mbps bandwidth and 8Mbps traffic.
> Queue 2: CBS queue, 5Mbps bandwidth and 6Mbps traffic.
> Results: queue 0 egress rate is 86Mbps, queue 1 egress rate is 6Mbps, and queue 2
> egress rate is 4Mbps.
> Then change the link speed to 10Mbps, queue 0 egress rate is 4Mbps, queue 1 egress
> rate is 4Mbps, and queue 2 egress rate is 3Mbps.
>
> Beside the test results, I also checked the CBS codes. Unlike hardware implementation,
> the pure software method is more flexible, it has four parameters: idleslope, sendslope,
> locredit and hicredit. And it can detect the change of link speed and do some adjust.
> However, for hardware we only use the idleslope parameter. It's hard for us to make
> the hardware behave as the pure software when the link speed changes.
> So for the question: Should the hardware just give up and go back to default behaviour,
> or should it continue to do some CBS?

If you give up on hardware CBS, does the software version take over?

The idea of hardware offload is that the user should not care, nor
really notice. You want the software and hardware behaviour to be
similar.

> I think that we can refer to the behaviors of stmmac and enetc drivers, just keep the
> bandwidth ratio constant when the link rate changes. In addition, the link speed change
> is a corner case, there is no need to spend any more effort to discuss this matter.

It is a corner case, but it is an important one. You need it to do
something sensible. Giving up all together is not sensible. Falling
back to software CBS would be sensible, or supporting something
similar to the software CBS.

	Andrew
