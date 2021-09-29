Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF57841C3B4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245034AbhI2LsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:48:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:4372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245266AbhI2LsS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 07:48:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="288577626"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="288577626"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 04:46:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="655466370"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 29 Sep 2021 04:46:37 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9CCEA58097E;
        Wed, 29 Sep 2021 04:46:34 -0700 (PDT)
Date:   Wed, 29 Sep 2021 19:46:31 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Message-ID: <20210929114631.GB2089@linux.intel.com>
References: <20210928041938.3936497-1-vee.khee.wong@linux.intel.com>
 <20210928041938.3936497-3-vee.khee.wong@linux.intel.com>
 <20210928104104.etfxxaeuwk2has32@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928104104.etfxxaeuwk2has32@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 10:41:04AM +0000, Vladimir Oltean wrote:
> On Tue, Sep 28, 2021 at 12:19:38PM +0800, Wong Vee Khee wrote:
> > According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> > required to disable Clause 37 auto-negotiation by programming bit-12
> > (AN_ENABLE) to 0 if it is already enabled, before programming various
> > fields of VR_MII_AN_CTRL registers.
> > 
> > After all these programming are done, it is then required to enable
> > Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> > 
> > Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > ---
> 
> Other comments:
> 
> - please provide a Fixes: tag, like:
> 
> Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
> 
> (just like that, not split on multiple lines)
> 
> - please target the patches to the "net" tree. I see the xpcs_modify
>   patch has other stuff in its context (nxp_sja1105) that will conflict
>   with the tree in which the bad commit was originally introduced, so I
>   think the easiest way would be if you could just open-code the initial
>   clearing of bit MDIO_AN_CTRL1_ENABLE. You could then wait until "net"
>   merges with "net-next" again and do the other cleanups afterwards - it
>   looks like other places could use a _modify method as well, just
>   looking at DW_VR_MII_AN_CTRL, DW_VR_MII_DIG_CTRL1. Also, the complete
>   replacement of DW_VR_MII_MMD_CTRL with MDIO_CTRL1 can also be done in
>   net-next. Just try to keep the fix minimally self-contained.

Sure! will mark this target for 'net' for v2.
