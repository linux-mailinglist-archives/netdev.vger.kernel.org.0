Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EC6682E02
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjAaNdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjAaNdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:33:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82295085D;
        Tue, 31 Jan 2023 05:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2Kb+RfZF2P0xLGtBohMblwLOSUXun94qd49rrzVcMJU=; b=vBCDOTlW4hLkt12W37EmOTEojN
        EIsxLpp4xPnqRIx+NQPLLcc95nwQvsjPuPLCGt3kVum69gG5EiaaG5q0d9WV+L35briLKEQ7s29bB
        +xqv9QBMzODJtSSPIi21ETpMQ2Lb08cDMycc2LVSy0dmDwut+5dbRrtM9N7bEjJVN+pI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMqlC-003h6b-Rj; Tue, 31 Jan 2023 14:33:18 +0100
Date:   Tue, 31 Jan 2023 14:33:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Frank.Sae" <Frank.Sae@motor-comm.com>
Cc:     Rob Herring <robh@kernel.org>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
Message-ID: <Y9kYnnYRMW9Vi0DU@lunn.ch>
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
 <20230130063539.3700-2-Frank.Sae@motor-comm.com>
 <20230130224158.GA3655289-robh@kernel.org>
 <af6beebc-0a70-16f5-e0e9-5f4cbeea8955@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af6beebc-0a70-16f5-e0e9-5f4cbeea8955@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> phy id list:
> YT8511	0x0000010a
> YT8521	0x0000011A
> YT8531  0x4f51e91b

The first two are clearly invalid, the OUI part is zero. So i would
not list those. Just use the last one.

In the binding part, you need something like

properties:
  compatible:
    const: ethernet-phy-id4f51.e91b
    description: Only needed for DT lint tools

What i don't know is how this will work in combination with the
compatibles gained from ethernet-phy.yaml. You might need to follow
the same structure, include a oneOf:

In the example part, you would do something like:
> 
>     mdio0 {
>         ...
>         ethernet-phy@5 {
	      # Only needed to make DT lint tools work. Do not copy/paste
	      # into real DTS files.
>             compatible = "ethernet-phy-id4f51.e91b";
>             reg = <5>;
>             ...
>         };
>     };

I don't think there are any examples to follow because the kernel
does not need any of this, is probes using the IDs. Listing
compatibles like this is purely for the DT tools, which is why i put
in the comments about not copy/pasting it to real DT blobs.

   Andrew
