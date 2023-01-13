Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AB5669933
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241571AbjAMN5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237550AbjAMN4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:56:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F7EBD0;
        Fri, 13 Jan 2023 05:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TsFuSkwR1WlHnCqE1Bje3dfaKMH46M3DRmRqT/WlQow=; b=G23umAhl+TT9CsE3I2NGNOA/gR
        9ZIz+nKz0V2p3Mtxlq67IyRIWo3+z0o2UC4QXKnySEeydWyqpTWwfxUWzQdxBA4mW6SRBTgeIyYsB
        id7C23royuWvIg1RsXg/siSXUu/Ewr9zVVbiCCxrb6EVnnCTcYs21XI5rayGJxJzg/Us=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pGKUV-0020Nc-Mz; Fri, 13 Jan 2023 14:53:07 +0100
Date:   Fri, 13 Jan 2023 14:53:07 +0100
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
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y8FiQ3Fv25QJyawQ@lunn.ch>
References: <20230106101651.1137755-1-lukma@denx.de>
 <20230106101651.1137755-1-lukma@denx.de>
 <20230106145109.mrv2n3ppcz52jwa2@skbuf>
 <20230113131331.28ba7997@wsk>
 <20230113122754.52qvl3pvwpdy5iqk@skbuf>
 <20230113142017.78184ce1@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113142017.78184ce1@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I tend to agree... The number of switched which suppor 1522 B max frame
> is only six. This may be why the problem was not noticed.
> 
> The fixed function maybe should look like below:
> 
> 
> static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
> {
> 	....
> 
> 	
> 	int max_mtu;
> 
> 	max_mtu = chip->info->max_frame_size - VLAN_ETH_HLEN -
> 		  ETH_FCS_LE;
> 
> 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
> 		  max_mtu -= EDSA_HLEN;
> 
> 	return max_mtu;
> }
> 
> Comments more than welcome.


I would suggest some comments are added, explaining what is going on
here. Given the number of Fixes: tags in this area, it is clearly
tricky to get right, given how different switches operate.

I've not looked back to the email archive, but i have a vague
recollection that it could be some switches don't impose the MTU limit
on CPU and DSA ports, just the user ports. So the value reported for
those ports can actually be bigger than then the max mtu, in order to
accommodate the DSA header.

	Andrew
