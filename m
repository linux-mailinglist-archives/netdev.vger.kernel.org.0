Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E547469D872
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjBUCZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBUCZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:25:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A393B2201E;
        Mon, 20 Feb 2023 18:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rbZpLXvJ7Aha1uh0eV22zaYZ2Zs2OOypm/WF5Ox+AyA=; b=zpz0hERUs4p0xB1aoQiZ/eYYZJ
        gruzJ3AZ4zx7oPcmo+FdiDMPdNnMhYQyNHFvq7dVuJeoUqz0YqFKGQ/7HEzsWxGEUe6YsCQyhiby0
        xyOxBpIehMEEOXBqH7kD4tmWZ92F6Kol3nM01YGqOcsPHm9j/qgqg+NBwC5Iikd9iDNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pUILM-005YLh-D4; Tue, 21 Feb 2023 03:25:24 +0100
Date:   Tue, 21 Feb 2023 03:25:24 +0100
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
Message-ID: <Y/QrlM011Jw2hsnG@lunn.ch>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <Y+pjl3vzi7TQcLKm@lunn.ch>
 <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com>
 <Y+p8WZCPKhp4/RIH@lunn.ch>
 <DB9PR04MB810669A4AC47DE2F0CBEA25B88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Y+uamTHJSaNHvTbU@lunn.ch>
 <DB9PR04MB810629C2CEB106787D6A2B8C88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Y/Amx27oh9Z1uMSp@lunn.ch>
 <DB9PR04MB8106C0ADA70B24BFCF9D2BD988A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB8106C0ADA70B24BFCF9D2BD988A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Unfortunately, FEC IP itself not follows the standard 802.1Qav spec completely.
> We only can program DMAnCFG[IDLE_SLOPE] field to calculate bandwidth fraction.
> And IDLE_SLOPE is restricted to certain values. It's far away from CBS QDisc implemented
> in Linux TC framework. It is more difficult to guarantee similar software behavior when
> the link speed changes.
> If the method of keeping the bandwidth ratio unchanged is not sensible, I can only give up
> CBS offload and use pure software CBS. :(

I know the hardware supports less parameters. But if you restrict the
CBS configuration such that the parameters you don't support are 0,
can you accurately implement what you do support?

If the user configures TC such that it matches the hardware
capabilities, you can accept the offload. If not return -EOPNOTSUPP,
and the software CBS should take over. And then you need to clearly
document what parameters can be set for hardware offload to work.

	 Andrew
