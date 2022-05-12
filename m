Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CE6524D2D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353895AbiELMje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353908AbiELMjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:39:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E95314CA12;
        Thu, 12 May 2022 05:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JDJLNxtzQmNv9ZM52zmyIFiZT5LJsi4aBhzMv6fNHmo=; b=jHvGd0Dw9Ky0KKv4tiTPpTLvRq
        6Nrv82JqSu+/cX65x3e8B2HMj3jJ54HwHyKf2HyjZbsD0B+DrY8qtQDJ/SubeZAhKKc7Eo32KN4B/
        UOSCwdM5E2d5cFG4EM7TcWJnPw19ZZqui8ZQulmJh+vrdA6LmwH10zKf9xRu5skS4lbE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1np861-002Ryk-2D; Thu, 12 May 2022 14:39:09 +0200
Date:   Thu, 12 May 2022 14:39:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <Ynz/7Wh6vDjR7ljs@lunn.ch>
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
 <20220510222101.od3n7gk3cofwhbks@skbuf>
 <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
 <20220511093245.3266lqdze2b4odh5@skbuf>
 <YnvJFmX+BRscJOtm@lunn.ch>
 <0ef1e0c2-1623-070d-fbf5-e7f09fc199ca@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ef1e0c2-1623-070d-fbf5-e7f09fc199ca@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix

Thanks for the additional testing.

> I just ran some more tests, here's what I found:
> The switch automatically pads all forwarded packets to 64 bytes.
> When packets are forwarded from one external port to another, the padding is
> all zero.
> Only when packets are sent from a CPU port to an external port, the last 4
> bytes contain garbage. The garbage bytes are different for every packet, and
> I can't tell if it's leaking contents of previous packets or what else is in
> there.
> Based on that, I'm pretty sure that the hardware simply has a quirk where it
> does not account for the special tag when generating its own padding
> internally.

This does not yet explain why your receiver is dropping the frame. As
Vladimir pointed out, the contents of the pad should not matter.

Is it also getting the FCS wrong when it pads? That would cause the
receiver to drop the frame.

Or do we have an issue in the receiver where it is looking at the
contents of the pad?

	 Andrew
