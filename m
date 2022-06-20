Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5505522B3
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiFTRVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiFTRVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:21:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0FF1DA58;
        Mon, 20 Jun 2022 10:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655745673; x=1687281673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Yat8R+G8CrJ8fLq3/RWqsSncBYDHY8UEwygwlmgjhYs=;
  b=LvcfakX3ztUt4gyBujkm0NScLSVzZTo3GuYYWhC7bOnEqPX5TIA52ia8
   +R49qR7E3oqNd3QwCL30fGdZhPWJ5e/qQTqFdMBCWJJB7MdBomwHAaeVr
   NoIDdhuzMGF7nxDm0HNSHRdkGBWnYBHCYh9ERjsDuOLs4PutqWd9anD9r
   WwUIqytsTJMcylAdabzFkvpeU80+yx5BN93vj3ySacR4qQqSJidTFGZTq
   +YsK9d/7RKO0Ru8xjQCbogoV3oJZlNTSZWJtj1EauPD8DK6SiOQ7+3D/6
   ydEUOLjXDcUtz/7c/3lIkwE5sP3r+b8x3m8X2TcR47mTR04l5xVbsNiQ3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="262977650"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="262977650"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:21:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="689549673"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:21:07 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3L5E-000kYi-BG;
        Mon, 20 Jun 2022 20:21:04 +0300
Date:   Mon, 20 Jun 2022 20:21:04 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 00/12] ACPI support for DSA
Message-ID: <YrCsgIxOmXQcjy+B@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:13PM +0200, Marcin Wojtas wrote:
> Hi!
> 
> This patchset introduces the support for DSA in ACPI world. A couple of
> words about the background and motivation behind those changes:
> 
> The DSA code is strictly dependent on the Device Tree and Open Firmware
> (of_*) interface, both in the drivers and the common high-level net/dsa API.
> The only alternative is to pass the information about the topology via
> platform data - a legacy approach used by older systems that compiled the
> board description into the kernel.
> 
> The above constraint is problematic for the embedded devices based e.g. on
> x86_64 SoCs, which are described by ACPI tables - to use DSA, some tricks
> and workarounds have to be applied. Addition of switch description to
> DSDT/SSDT tables would help to solve many similar cases and use unmodified
> kernel modules. It also enables this feature for ARM64 ACPI users.
> 
> The key enablements allowing for adding ACPI support for DSA in Linux were
> NIC drivers, MDIO, PHY, and phylink modifications – the latter three merged
> in 2021. I thought it would be worth to experiment with DSA, which seemed
> to be a natural follow-up challenge.
> 
> It turned out that without much hassle it is possible to describe
> DSA-compliant switches as child devices of the MDIO busses, which are
> responsible for their enumeration based on the standard _ADR fields and
> description in _DSD objects under 'device properties' UUID [1].
> The vast majority of required changes were simple of_* to fwnode_*
> transition, as the DT and ACPI topolgies are analogous, except for
> 'ports' and 'mdio' subnodes naming, as they don't conform ACPI
> namespace constraints [2].

...

> Note that for now cascade topology remains unsupported in ACPI world
> (based on "dsa" label and "link" property values). It seems to be feasible,
> but would extend this patchset due to necessity of of_phandle_iterator
> migration to fwnode_. Leave it as a possible future step.

Wondering if this can be done using fwnode graph.

-- 
With Best Regards,
Andy Shevchenko


