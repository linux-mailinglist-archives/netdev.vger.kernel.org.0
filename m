Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218AD5EF836
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiI2PAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiI2PAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:00:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7614713C879;
        Thu, 29 Sep 2022 08:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qkht88ZXOQUl4Ga9al3536op0DNgwiqJBZ0ndODkQYg=; b=0u+87Rfs0PU6EKb8x3exrHsrbN
        YWJqF2Yq3M/StU4XRvBWmGlwBfBKdS7PxfbFjQ0Cd/fXqmRJYyCXvshDNg8Xrd2zHwFOc17ZFPlTT
        cE6JyjJH6bjijvmZD/Ui4QYY0VOzPpN0cl8vP85gpFgswTCEVIefy5xEO2vh2wUGeZH0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odv1Z-000ctn-0y; Thu, 29 Sep 2022 17:00:29 +0200
Date:   Thu, 29 Sep 2022 17:00:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <YzWzDEqCFYqqJcr0@lunn.ch>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzH65W3r1IV+rHFW@lunn.ch>
 <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzLybsJBIHtbQOwE@lunn.ch>
 <TYBPR01MB53419D2076953EB3480BC301D8549@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzQ3gdO/a+jygIDa@lunn.ch>
 <TYBPR01MB53415F3D11FEBFFC8BF09FE0D8579@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB53415F3D11FEBFFC8BF09FE0D8579@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 12:22:15PM +0000, Yoshihiro Shimoda wrote:
> Hi Andrew,
> 
> > From: Andrew Lunn, Sent: Wednesday, September 28, 2022 9:01 PM
> > 
> > > > How do you direct a frame from the
> > > > CPU out a specific user port? Via the DMA ring you place it into, or
> > > > do you need a tag on the frame to indicate its egress port?
> > >
> > > Via the DMA ring.
> > 
> > Are there bits in the ring descriptor which indicate the user port?
> > Can you set these bits to some other value which causes the switch to
> > use its MAC table to determine the egress interface?
> 
> I'm sorry, I misunderstood the hardware behaviors.
> 
> 1) From CPU to user port: CPU sends a frame to all user ports.
> 2) From user port to CPU: each user port sends a frame to each DMA ring.
> 
> About the 1) above, the switch can have MAC tables and sends a frame to
> a specific user port. However, the driver doesn't support it.

In order to make STP and PTP work, you need to be able to send a frame
out a specific port. With STP, that port can also be blocked,
i.e. normal frames are not allowed to be transmitted/received, but
these STP frames are allowed. You also need to know what port an STP
frame was received on.

So the switch probably has a mechanism to send a frame from the CPU
out one specific port. And frames received from a user port and passed
to the CPU should also be identifiable. There are different ways of
doing this. DSA typically has an extra header on the frame, indicating
where it is from/to. Some switches have extra bits in the DMA buffer
descriptor indicating the port.

> However, if I dropped specific registers setting, it doesn't work correctly.
> I'll investigate why removing speeds of PHY didn't work.

It could be the PHY is using SGMII, but your MAC needs 1000BaseX?

   Andrew
