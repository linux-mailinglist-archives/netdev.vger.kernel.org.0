Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD1F690AF4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjBINzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjBINzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:55:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB4C5ACED;
        Thu,  9 Feb 2023 05:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tFaUdKp7wDYrDTvnaxF2KtSQEYEo5175B30HdBwPNXc=; b=fmRTRM/LVwJDezrq4pjisSt/vq
        GcU5XcVLPw1gcRXIFBP9xYCIb2LmSqP9lC1UbFPZhN0nYc20oT3gn3SnMTTzJtWqvdQ5uLmoL3slx
        HllmbaL2nK94YEIikq8AIol0hu5xUx3dpdDWvXoMgFyQpNlZsRqkJyxWPD0OjCosvSUE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQ7O4-004VZS-JC; Thu, 09 Feb 2023 14:54:56 +0100
Date:   Thu, 9 Feb 2023 14:54:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     Roger Quadros <rogerq@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v4 2/2] net:
 ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <Y+T7MAu0/s1bjYIt@lunn.ch>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-3-danishanwar@ti.com>
 <Y+ELeSQX+GWS5N2p@lunn.ch>
 <42503a0d-b434-bbcc-553d-a326af5b4918@ti.com>
 <e8158969-08d0-1edc-24be-8c300a71adbd@kernel.org>
 <4438fb71-7e20-6532-a858-b688bc64e826@ti.com>
 <Y+Ob8++GWciL127K@lunn.ch>
 <6713252d-6f86-c674-9229-c4512ebf1d72@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6713252d-6f86-c674-9229-c4512ebf1d72@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sure, I'll do that. In the list of all phy modes described in [1], I can only
> see phy-mode "rgmii-txid", for which we can return -EINVAL. Is there any other
> phy-mode that requires enabling/disabling TX internal delays? Please let me
> know if any other phy-mode also needs this. I will add check for that as well.

There are 4 phy-modes for RGMII.

rgmii, rgmii-id, rmgii-rxid, rgmii-txid.

rgmii-id, rgmii-txid both require TX delays. If you do that in the MAC
you then need to pass rgmii-rxid and rgmii to the PHY respectively.

rmii and rgmii-rxid requires no TX delays, which your SoC cannot do,
so you need to return -EINVAl,

The interpretation of these properties is all really messy and
historically not very uniformly done. Which is why i recommend the MAC
does nothing, leaving it to the PHY. That generally works since the
PHYs have a pretty uniform implementation. But in your case, you don't
have that option. So i suggest you do what is described above. 

    Andrew
