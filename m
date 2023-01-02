Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9888C65B704
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 20:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjABT6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 14:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjABT6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 14:58:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451EC766B;
        Mon,  2 Jan 2023 11:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pksXG0NslpwTCVv33v4zdHkjHzxWpLEtSPoxEy9Fp/s=; b=wUzNrkx7Vb5D04xcNnaVUPab2c
        rcuWod9t7A5QmoKr5Gz2SKjNYaHZ2NKnobxaGali9eydH+aHsqwXuiH6rjzo44stYqKKPsTlyXCqw
        r/kuD6fhJHIESnqvFwoQsJaDsQTZraUZ2BDm8DwiOV1ruve0e4Q6D+EMcK2zVW7DtZpA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCQwc-000xcG-L3; Mon, 02 Jan 2023 20:58:02 +0100
Date:   Mon, 2 Jan 2023 20:58:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y7M3SnEib/08s9+c@lunn.ch>
References: <20230102150209.985419-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102150209.985419-1-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 04:02:07PM +0100, Lukasz Majewski wrote:
> Different Marvell DSA switches support different size of max frame
> bytes to be sent.
> 
> For example mv88e6185 supports max 1632 bytes, which is now in-driver
> standard value. On the other hand - mv88e6250 supports 2048 bytes.
> 
> As this value is internal and may be different for each switch IC,
> new entry in struct mv88e6xxx_info has been added to store it.
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> 
> ---
> Changes for v2:
> - Define max_frame_size with default value of 1632 bytes,
> - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> 
> Changes for v3:
> - Add default value for 1632B of the max frame size (to avoid problems
>   with not defined values)

I would add a WARN_ON_ONCE(!chip->info->max_frame_size) so a missing
value is detected. You can then skip the complexity of a default.

	Andrew
