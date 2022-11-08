Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DC6620F17
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiKHL3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbiKHL3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:29:08 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04916614B;
        Tue,  8 Nov 2022 03:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667906947; x=1699442947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iFgt+xRSCifhlEtMvApfJxKTh8oobLSPoJahFBguwSk=;
  b=D8PDaxeWyhi0gkXSEidgAyyZH55/ihD52NC0idr6X771PiTCZCW8pbDW
   /hG0Y/m0qk6xX/WEx9PIMVxrYAIiE9sh4jKk4JzhZt8dV/6J4Ll2QE4Ye
   8SBOi2zAHYuQSEi0OYaSUeH4Rc6cJlrqNF3keLaaqjWqP/Glp0qp7viO3
   N2J43wJo4TxV8yWV0/9RRCgWkVMZhHaEOpawbglUDd2OHw9y5bj8LIEgB
   fTwTw5TB1gooDRfe9RlVQvS2A4nUtRyr1uxbkvZQUibAkNH3RUZxaWGC2
   gVpRsH8qL7TcdBpXDZEthWQDpiZTPhy4A/HdySXZ91w7rqWwCiLQtOH1q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311826544"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="311826544"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 03:29:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="638759350"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="638759350"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 08 Nov 2022 03:29:03 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A8BT2xd013292;
        Tue, 8 Nov 2022 11:29:02 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 3/4] net: lan966x: Add basic XDP support
Date:   Tue,  8 Nov 2022 12:26:01 +0100
Message-Id: <20221108112601.605326-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107212618.73aqn3cdqojs6zbo@soft-dev3-1>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com> <20221106211154.3225784-4-horatiu.vultur@microchip.com> <20221107161357.556549-1-alexandr.lobakin@intel.com> <20221107212618.73aqn3cdqojs6zbo@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 7 Nov 2022 22:26:18 +0100

> The 11/07/2022 17:13, Alexander Lobakin wrote:
> 
> Hi Olek,
> 
> > 
> > From: Alexander Lobakin <alexander.lobakin@intel.com>
> > 
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Date: Sun, 6 Nov 2022 22:11:53 +0100
> > 
> > > Introduce basic XDP support to lan966x driver. Currently the driver
> > > supports only the actions XDP_PASS, XDP_DROP and XDP_ABORTED.
> > >
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > > ---
> > >  .../net/ethernet/microchip/lan966x/Makefile   |  3 +-
> > >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 11 ++-
> > >  .../ethernet/microchip/lan966x/lan966x_main.c |  5 ++
> > >  .../ethernet/microchip/lan966x/lan966x_main.h | 13 +++
> > >  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 81 +++++++++++++++++++
> > >  5 files changed, 111 insertions(+), 2 deletions(-)
> > >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> > 
> > [...]
> > 
> > > +bool lan966x_xdp_port_present(struct lan966x_port *port)
> > > +{
> > > +     return !!port->xdp_prog;
> > > +}
> > 
> > Why uninline such a simple check? I realize you want to keep all XDP
> > stuff inside in the separate file, but doesn't this one looks too
> > much?
> 
> I was kind of hoping that the compiler will inline it for me.
> But I can add it in the header file to inline it.

That is very unlikely for the compilers to uninline an extern
function. LTO is able to do that, but even then it's not
guaranteed. So I'd keep it in a header file as an inline.

> 
> > 
> > > +
> > > +int lan966x_xdp_port_init(struct lan966x_port *port)
> > > +{
> > > +     struct lan966x *lan966x = port->lan966x;
> > > +
> > > +     return xdp_rxq_info_reg(&port->xdp_rxq, port->dev, 0,
> > > +                             lan966x->napi.napi_id);
> > > +}
> > > +
> > > +void lan966x_xdp_port_deinit(struct lan966x_port *port)
> > > +{
> > > +     if (xdp_rxq_info_is_reg(&port->xdp_rxq))
> > > +             xdp_rxq_info_unreg(&port->xdp_rxq);
> > > +}
> > > --
> > > 2.38.0
> > 
> > Thanks,
> > Olek
> 
> -- 
> /Horatiu

Thanks,
Olek
