Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697E34D0B88
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbiCGW4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiCGW4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:56:39 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21B438BED;
        Mon,  7 Mar 2022 14:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XkJHzBoGYjd42n0LjqjVuQ+Gqe3G1cnjzHTE4xVFH0g=; b=XX8eamN6U1ecX+0CvO70mry5jB
        VuOLX7Nbhjxt/nkGJf5zaSo9OLpgHV2ahJUvQH/bbuvKkX6q5kyS+YeZU6kOivk0COIlw2d7p+ebN
        fkb67Dx86KjMiM4x/adLmI76rRLVPxbG17OSVyI21lVL/Kwg0BIQVUoesScIjp2uzr10=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRMGP-009fOm-4H; Mon, 07 Mar 2022 23:55:37 +0100
Date:   Mon, 7 Mar 2022 23:55:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_dsa: Fix tx from VLAN uppers on
 non-filtering bridges
Message-ID: <YiaNaRp64ByP2SFa@lunn.ch>
References: <20220307110548.812455-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307110548.812455-1-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 12:05:48PM +0100, Tobias Waldekranz wrote:
> In this situation (VLAN filtering disabled on br0):
> 
>     br0.10
>      /
>    br0
>    / \
> swp0 swp1
> 
> When a frame is transmitted from the VLAN upper, the bridge will send
> it down to one of the switch ports with forward offloading
> enabled. This will cause tag_dsa to generate a FORWARD tag. Before
> this change, that tag would have it's VID set to 10, even though VID
> 10 is not loaded in the VTU.
> 
> Before the blamed commit, the frame would trigger a VTU miss and be
> forwarded according to the PVT configuration. Now that all fabric
> ports are in 802.1Q secure mode, the frame is dropped instead.
> 
> Therefore, restrict the condition under which we rewrite an 802.1Q tag
> to a DSA tag. On standalone port's, reuse is always safe since we will
> always generate FROM_CPU tags in that case. For bridged ports though,
> we must ensure that VLAN filtering is enabled, which in turn
> guarantees that the VID in question is loaded into the VTU.
> 
> Fixes: d352b20f4174 ("net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Thanks Tobias

Tested-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
