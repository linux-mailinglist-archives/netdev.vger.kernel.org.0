Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F6522FBE9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgG0WLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:11:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgG0WLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:11:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0BKq-007ALy-Co; Tue, 28 Jul 2020 00:11:04 +0200
Date:   Tue, 28 Jul 2020 00:11:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Message-ID: <20200727221104.GD1705504@lunn.ch>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727214700.5915-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 02:47:00PM -0700, Jacob Keller wrote:
> The ethtool netlink API can send bitsets without an associated bitmask.
> These do not get displayed properly, because the dump_link_modes, and
> bitset_get_bit to not check whether the provided bitset is a NOMASK
> bitset. This results in the inability to display peer advertised link
> modes.
> 
> The dump_link_modes and bitset_get_bit functions are designed so they
> can print either the values or the mask. For a nomask bitmap, this
> doesn't make sense. There is no mask.
> 
> Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For compact
> bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
> regardless of the request to display the mask or the value. For full
> size bitmaps, the set of provided bits indicates the valid values,
> without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printing
> bits without this attribute if nomask is set. This essentially means
> that dump_link_modes will treat a NOMASK bitset as having a mask
> equivalent to all of its set bits.
> 
> For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compact
> bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
> For full bitmaps, if nomask is set, then always return true of the bit
> is in the set, rather than only if it provides an
> ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
> bits.
> 
> This fixes display of link partner advertised fields when using the
> netlink API.

Hi Jacob

This is close

Netlink
	Link partner advertised link modes:  10baseT/Half 10baseT/Full
	                                     100baseT/Half 100baseT/Full
	                                     1000baseT/Full
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: No

IOCTL
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	                                     1000baseT/Full 
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported

So just the FEC modes differ.

However, i don't think this was part of the original issue, so:

Tested-by: Andrew Lunn <andrew@lunn.ch>

It would be nice to get the FEC modes fixed.

    Andrew
