Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9D82FAB58
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394309AbhARUXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:23:51 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46499 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394269AbhARUW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:22:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611001347; x=1642537347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3vkIEGQPFf489pGA8tP/HOKmNsBhghNgESRdR43Dvi4=;
  b=JEU1+kv9EJ0ycQnsQpKzQQEpFgMrxDgZUWCNTHk+xwG8JigKupzPT/j5
   zGPxH/ApYkhz+CX8BImKCoG9f1jDNGFD9D2Hr5fPS7FsWp913k0bWIOcz
   Fd9G3saQSvpNRk3THpN2SvLstNVzABA0mKi33n/KiQrap/IN8KAXIjp88
   fRfNrn1h+XqQz05DQtEeJRFEJddFSbw5I5PFfu9xE2jB9DWxcrvpej+BA
   XcHR2+EFlcyqk+MUvbw64kdtvB0235/99476Xi6Pn9JNRN2glVfZORVEw
   w2002bfaqIwklCGmeCr6hSOYDxsK+++1YIvcZVpkQUpkn3026po284HOV
   Q==;
IronPort-SDR: rMWYeylswX1gedRqJc0sbzC07gP3jSvW+2wrO19QaXbFHctPUv6k3twJY5sL/DnbwtL9B/ThoV
 jZOqweyOj82hJFlZH9sQBO58Ar4LT5x4Ad2mZ/jAU49Ip7TE0NdG3JKaD5z5q2/pihHafrHo6n
 FXsLztcT+qP5WSqdBCjNREbRzbyaDx9hNUzwcUb6JK6zPr1Sb4ORd+MTSryXS8L+OgnVHxXvNA
 xRBUyxYF5+TnauZoxd1cub2mQYGLTGqGejLCCLkv5EiAAX8rUyFnpQAKQhsZBi6TefqS764vu9
 Y18=
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="103319071"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2021 13:20:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 18 Jan 2021 13:20:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 18 Jan 2021 13:20:36 -0700
Date:   Mon, 18 Jan 2021 21:20:36 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Message-ID: <20210118202036.wk2fuwa3hysg4dmj@soft-dev3.localdomain>
References: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
 <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
 <20210118194632.zn5yucjfibguemjq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210118194632.zn5yucjfibguemjq@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/18/2021 19:46, Vladimir Oltean wrote:
> 
> On Mon, Jan 18, 2021 at 07:56:18PM +0100, Horatiu Vultur wrote:
> > The reason was to stay away from STP, because you can't run these two
> > protocols at the same time. Even though in SW, we reuse port's state.
> > In our driver(which is not upstreamed), we currently implement
> > SWITCHDEV_ATTR_ID_MRP_PORT_STATE and just call the
> > SWITCHDEV_ATTR_ID_PORT_STP_STATE.
> 
> And isn't Rasmus's approach reasonable, in that it allows unmodified
> switchdev drivers to offload MRP port states without creating
> unnecessary code churn?

I am sorry but I don't see this as the correct solution. In my opinion,
I would prefer to have 3 extra lines in the driver and have a better
view of what is happening. Than having 2 calls in the driver for
different protocols.
If it is not a problem to have STP calls when you configure the MRP,
then why not just remove SWITCHDEV_ATTR_ID_MRP_PORT_STATE?

> 
> Also, if it has no in-kernel users, why does it even exist as a
> switchdev attribute?

-- 
/Horatiu
