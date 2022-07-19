Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF2B57A34F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbiGSPhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiGSPhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:37:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA893599E3;
        Tue, 19 Jul 2022 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sfvZpWOEq6JYILmPXBYR+uDtjMbWCX9Pn/cYZ5pJzQQ=; b=wzeCNFtgwP6NpoC2RSTvSQI5XR
        RZwffZ6xSZdo7gPeT1KgxqD3yTRWaq3BM0NvaohQtV+um1394cg0yMnMEBr/jpBWOvKi6WYalKOVT
        HS6axJFVFI0lh5EIx74VDIEPzSU2O/47n5ETcUjSJS9WCxTxa9y4HvjxGgmYZOPaDyJI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDpHq-00Apxj-D3; Tue, 19 Jul 2022 17:37:26 +0200
Date:   Tue, 19 Jul 2022 17:37:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Message-ID: <YtbPtkF1Ah9xrBam@lunn.ch>
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719014704.21346-2-antonio@openvpn.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ovpn_net_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	if (new_mtu < IPV4_MIN_MTU ||
> +	    new_mtu + dev->hard_header_len > IP_MAX_MTU)
> +		return -EINVAL;

If you set dev->min_mtu and dev->max_mtu, the core will validate this
for you, see dev_validate_mtu().

> +static int ovpn_get_link_ksettings(struct net_device *dev,
> +				   struct ethtool_link_ksettings *cmd)
> +{
> +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported, 0);
> +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising, 0);

These two should not be needed. Look at tun, veth etc, they don't set
them.

	Andrew
