Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EA96966DA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjBNO3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjBNO3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:29:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8137A5257;
        Tue, 14 Feb 2023 06:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B0wjCGjYGQCm4hijAVygopRxEENz4KRw7PHkvy98Nj0=; b=FjwaVMcE4IBv6zf10Uh03lqpRg
        w2cO2rBI6I/e4VGxYr/fb6sq+jXfmzkpItN29Y8p0KYdf2U07Oj8mLQk+R5TG0NVgA7Riae2xO4/L
        VxKirimssMII8aFk/4yzZB1thMEhu68dRQbQQTdc8i1tO04BPZcHn4zeAkjtS0Go4aQQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRwIT-004xYb-E1; Tue, 14 Feb 2023 15:28:41 +0100
Date:   Tue, 14 Feb 2023 15:28:41 +0100
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
Message-ID: <Y+uamTHJSaNHvTbU@lunn.ch>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <Y+pjl3vzi7TQcLKm@lunn.ch>
 <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com>
 <Y+p8WZCPKhp4/RIH@lunn.ch>
 <DB9PR04MB810669A4AC47DE2F0CBEA25B88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB810669A4AC47DE2F0CBEA25B88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sorry, I'm not very familiar with the configuration of pure software implementation
> of CBS. I tried to configure the CBS like the following. The bandwidth of queue 1 was
> set to 30Mbps. And the queue 2 is set to 20Mbps. Then one stream were sent the
> queue 1 and the rate was 50Mbps, the link speed was 1Gbps. But the result seemed that
> the CBS did not take effective.

I'm not that familiar with CBS, but that is what i would expect. You
are over subscribing the queue by 20Mbps, so that 20Mbps gets
relegated to best effort. And since you have a 1G link, you have
plenty of best effort bandwidth.

As with most QoS queuing, it only really makes a different to packet
loss when you oversubscribe the link as a whole.

So with your 30Mbps + 20Mbps + BE configuration on a 1G link, send
50Mbps + 0Mbps + 1Gbps. 30Mbps of your 50Mbps stream should be
guaranteed to arrive at the destination. The remaining 20Mbps needs to
share the remaining 970Mbps of link capacity with the 1G of BE
traffic. So you would expect to see a few extra Kbps of queue #1
traffic arriving and around 969Mbps of best effort traffic.

However, that is not really the case i'm interested in. This
discussion started from the point that autoneg has resulted in a much
smaller link capacity. The link is now over subscribed by the CBS
configuration. Should the hardware just give up and go back to default
behaviour, or should it continue to do some CBS?

Set lets start with a 7Mbps queue 1 and 5Mbps queue 2, on a link which
auto negs to 100Mbps. Generate traffic of 8Mbps, 6Mpbs and 100Mbps
BE. You would expect ~7Mbps, ~5Mbps and 88Mbps to arrive at the link
peer. Your two CBS flows get there reserved bandwidth, plus a little
of the BE. BE gets whats remains of the link. Test that and make sure
that is what actually happens with software CBS, and with your TC
offload to hardware.

Now force the link down to 10Mbps. The CBS queues then over subscribe
the link. Keep with the traffic generator producing 8Mbps, 6Mpbs and
100Mbps BE. What i guess the software CBS will do is 7Mbps, 3Mbps and
0 BE. You should confirm this with testing.

What does this mean for TC offload? You should be aiming for the same
behaviour. So even when the link is over subscribed, you should still
be programming the hardware.

   Andrew
