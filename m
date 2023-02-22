Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E754B69FCB4
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 21:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjBVUH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 15:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBVUH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 15:07:28 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42811A490
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 12:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nH31+IryWkG0on+rJhHlkUlc+w0+jEleu4gG+KmLE6Q=; b=hpx2W+K3pCGJdMFG5dBCKudsYl
        HmOVBrfHGp0NIv0aurIUKLkZIHNmXSN9re4CKhRIPA2BJkA4Mvxogmb9ehGrcXxeulTsmO27V8UXk
        Gy94NKmg2lSPtNWBhxu0VUAOS3G2/jpzKYUybKGv5QLMP9AZYsRF0fmNprLMt9vuzlgo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pUvOa-005jVB-OG; Wed, 22 Feb 2023 21:07:20 +0100
Date:   Wed, 22 Feb 2023 21:07:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aryan Srivastava <Aryan.Srivastava@alliedtelesis.co.nz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: EEE support for 2.5G/5G
Message-ID: <Y/Z1+C+ZS/FajLsZ@lunn.ch>
References: <1677034396395.39388@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1677034396395.39388@alliedtelesis.co.nz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 02:53:17AM +0000, Aryan Srivastava wrote:
> Hi,
> 
> I am currently in the process of implementing EEE (energy-efficient ethernet) ethtool get/set on my PHY driver.

I hope you are following the discussions on the mailing list about
EEE. Most drivers get EEE wrong, so be careful which driver you copy.

> There are generic functions to achieve this, but they do not
> currently have the capability to set or check for 2.5G and 5G EEE
> LPI.
> 
> I had begun to add these additional modes when I realised this was
> not possible as the EEE ethtool command struct, only has 32-bit
> fields, and the ethtool bit mask for the 2.5G and 5G modes is 47 and
> 48 respectively.

So you need to differentiate between the IOCTL API and netlink.
Netlink should allow user space to use any link modes without any
backwards compatibility issues. The IOCTL API is stuck to just 1G and
less.

> To my knowledge, there is no framework currently in place to set
> 2.5G/5G EE through generic phy functions, and it cannot be
> implemented currently due to the size of the bit fields in the
> ethtool command.

Partially wrong. See above. But you are going to have do some kernel
internal plumbing. Within the kernel you need to replace struct
ethtool_eee with a different structure that replaces the u32
supported, advertised, and lp_advertised with a
__ETHTOOL_DECLARE_LINK_MODE_MASK. net/ethtool needs to map the IOCTL
call, using the UAPI ethtool_eee to this new structure, and the
netlink version should be swapped to ethnl_put_bitset() rather than
ethnl_put_bitset32(). You then need to modify every MAC driver which
has .eee_set() and .eee_get(). Those that use phylib probably don't
need any changes, but those doing EEE in firmware you are going to
have to add convert_link_ksettings_to_legacy_settings() to turn the
values back into u32. And then modify phylib to remove the recently
added convert_link_ksettings_to_legacy_settings().

Make sure you are on top of net-next. phylib has had a lot of EEE
changes recently, and more will be merged next cycle.

	Andrew



