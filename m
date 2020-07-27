Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87C22FC33
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgG0WcI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:32:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:61912 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0WcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:32:08 -0400
IronPort-SDR: OjV3oyM7ahirJjwIINI91GaP570nwj2LSdNpMsz/NMEJ7OMygWgzi6w8QCCwfaxcoxjQGAe+2u
 gzxzcrceekVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="151105457"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="151105457"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 15:32:07 -0700
IronPort-SDR: xSwbYoNMH8hMSI+9Tus+NvXT3gIECkr2UENE3hPRnoGa9ZQxzPT8vw4Izah0NKNVfSphw4eJTi
 0s6kElizoSQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="272128245"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jul 2020 15:32:06 -0700
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 27 Jul 2020 15:32:04 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.197]) by
 fmsmsx122.amr.corp.intel.com ([169.254.5.78]) with mapi id 14.03.0439.000;
 Mon, 27 Jul 2020 15:32:04 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: RE: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Thread-Topic: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Thread-Index: AQHWZF/v4+Les+I0uE2ME1SudVL5+KkccjwAgAAEYYD//4wFYA==
Date:   Mon, 27 Jul 2020 22:32:03 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8B20741@fmsmsx101.amr.corp.intel.com>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
 <20200727221104.GD1705504@lunn.ch>
 <20200727222645.uhtve7x2wkzddnub@lion.mk-sys.cz>
In-Reply-To: <20200727222645.uhtve7x2wkzddnub@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Monday, July 27, 2020 3:27 PM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org; Jamie
> Gloudon <jamie.gloudon@gmx.fr>
> Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
> 
> On Tue, Jul 28, 2020 at 12:11:04AM +0200, Andrew Lunn wrote:
> > On Mon, Jul 27, 2020 at 02:47:00PM -0700, Jacob Keller wrote:
> > > The ethtool netlink API can send bitsets without an associated bitmask.
> > > These do not get displayed properly, because the dump_link_modes, and
> > > bitset_get_bit to not check whether the provided bitset is a NOMASK
> > > bitset. This results in the inability to display peer advertised link
> > > modes.
> > >
> > > The dump_link_modes and bitset_get_bit functions are designed so they
> > > can print either the values or the mask. For a nomask bitmap, this
> > > doesn't make sense. There is no mask.
> > >
> > > Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For
> compact
> > > bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
> > > regardless of the request to display the mask or the value. For full
> > > size bitmaps, the set of provided bits indicates the valid values,
> > > without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printing
> > > bits without this attribute if nomask is set. This essentially means
> > > that dump_link_modes will treat a NOMASK bitset as having a mask
> > > equivalent to all of its set bits.
> > >
> > > For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compact
> > > bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
> > > For full bitmaps, if nomask is set, then always return true of the bit
> > > is in the set, rather than only if it provides an
> > > ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
> > > bits.
> > >
> > > This fixes display of link partner advertised fields when using the
> > > netlink API.
> >
> > Hi Jacob
> >
> > This is close
> >
> > Netlink
> > 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
> > 	                                     100baseT/Half 100baseT/Full
> > 	                                     1000baseT/Full
> > 	Link partner advertised pause frame use: No
> > 	Link partner advertised auto-negotiation: Yes
> > 	Link partner advertised FEC modes: No
> >
> > IOCTL
> > 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
> > 	                                     100baseT/Half 100baseT/Full
> > 	                                     1000baseT/Full
> > 	Link partner advertised pause frame use: No
> > 	Link partner advertised auto-negotiation: Yes
> > 	Link partner advertised FEC modes: Not reported
> >
> > So just the FEC modes differ.
> 
> This is a different issue, the last call to dump_link_modes() in
> dump_peer_modes() should be
> 
> 	ret = dump_link_modes(nlctx, attr, false, LM_CLASS_FEC,
> 
> (third parameter needs to be false, not true).
> 
> Michal
> 

That's part of it, yea, but also it should use the string "Not Reported" instead of "No" I think?

> >
> > However, i don't think this was part of the original issue, so:
> >
> > Tested-by: Andrew Lunn <andrew@lunn.ch>
> >
> > It would be nice to get the FEC modes fixed.
> >
> >     Andrew
