Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D260583FAD
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbiG1NMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236688AbiG1NMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:12:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D066454CB9;
        Thu, 28 Jul 2022 06:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IRO9xgSlBIIqF+gFlWl24ukH/G3G/wx7T+Evz1UrmeQ=; b=2v8LYbL1S0fEA+nX2ouKbLXvNY
        4VZzX4JTfrTq/RXB6AlLQsqKxbL90iCabutlcb2dUsfAfe74l2MPy27WYvMmA3MNQNN1lM7ZaH2sr
        Qe4Vz8sUTyPTvToKxr3pTT9bcdZRoym19ctWzMJevUoZRM+WTsnpSUzpZFeL7Qrf+fDo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oH3JI-00Bo54-Lv; Thu, 28 Jul 2022 15:12:16 +0200
Date:   Thu, 28 Jul 2022 15:12:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Message-ID: <YuKLMIJcb9OkBHry@lunn.ch>
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net>
 <YtbPtkF1Ah9xrBam@lunn.ch>
 <d645f6e1-d977-e2ea-1f8e-0b5458c9438e@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d645f6e1-d977-e2ea-1f8e-0b5458c9438e@openvpn.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 09:44:18AM +0200, Antonio Quartulli wrote:
> Hi,
> 
> On 19/07/2022 17:37, Andrew Lunn wrote:
> > > +static int ovpn_net_change_mtu(struct net_device *dev, int new_mtu)
> > > +{
> > > +	if (new_mtu < IPV4_MIN_MTU ||
> > > +	    new_mtu + dev->hard_header_len > IP_MAX_MTU)
> > > +		return -EINVAL;
> > 
> > If you set dev->min_mtu and dev->max_mtu, the core will validate this
> > for you, see dev_validate_mtu().
> 
> Yeah, thanks for the pointer.
> 
> > 
> > > +static int ovpn_get_link_ksettings(struct net_device *dev,
> > > +				   struct ethtool_link_ksettings *cmd)
> > > +{
> > > +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported, 0);
> > > +	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising, 0);
> > 
> > These two should not be needed. Look at tun, veth etc, they don't set
> > them.
> 
> I found this in tun.c:
> 
> 3512         ethtool_link_ksettings_zero_link_mode(cmd, supported);
> 3513         ethtool_link_ksettings_zero_link_mode(cmd, advertising);
> 
> Which seems a more appropriate version of my code, no?

I would trace is backwards. Where is cmd coming from? In order to
avoid unintentional information leaks, the core should be clearing any
memory which gets passed to a driver which might optionally be filled
in and then returned to user space. So take a look in net/ethtool, and
see if there is a memset() or a kzalloc() etc. If it is already been
zero'ed, you don't need this.

	  Andrew
