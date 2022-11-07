Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F0E6200FA
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiKGVWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiKGVVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:21:44 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D8A2A71B;
        Mon,  7 Nov 2022 13:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667856095; x=1699392095;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YkoNsI9/1R+ki7fJQr6gAdHFToRmOJwu7Ie2j7MiVaU=;
  b=Gul6JWYhv58qIG/yFCwxqv3RB3p/lz2tcRjWMOGsVsMoRxZtXRH4bXmr
   XH4W47dBb6m106wp0XaiwALFemMKbVwXl+qaW5kpKitAFPNTWktMwRuvt
   s5hxSmf/YPnwjefu0R6N2DtnzZ32Nh4p7qldvuxQC3fwsrryYomLNeZJH
   vyA26M+lBqBus3K2SykLRUoNpG3+YFSCWpypc3M+lstWhFs3GsJZrpW8z
   mAkM48zyofqdlyi47Qp0s47Z96dFGpEPZsRu0z9dOUaz7JaAqDJPVW3vI
   L6BicLMBch0gcVTbp4S76SPdzvL8WzqbTu4QJkmnSQkMwhBjdukUCs4iL
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="187996260"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 14:21:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 14:21:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 7 Nov 2022 14:21:33 -0700
Date:   Mon, 7 Nov 2022 22:26:18 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     Alexander Lobakin <alexander.lobakin@intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 3/4] net: lan966x: Add basic XDP support
Message-ID: <20221107212618.73aqn3cdqojs6zbo@soft-dev3-1>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
 <20221106211154.3225784-4-horatiu.vultur@microchip.com>
 <20221107161357.556549-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221107161357.556549-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/07/2022 17:13, Alexander Lobakin wrote:

Hi Olek,

> 
> From: Alexander Lobakin <alexander.lobakin@intel.com>
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Sun, 6 Nov 2022 22:11:53 +0100
> 
> > Introduce basic XDP support to lan966x driver. Currently the driver
> > supports only the actions XDP_PASS, XDP_DROP and XDP_ABORTED.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan966x/Makefile   |  3 +-
> >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 11 ++-
> >  .../ethernet/microchip/lan966x/lan966x_main.c |  5 ++
> >  .../ethernet/microchip/lan966x/lan966x_main.h | 13 +++
> >  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 81 +++++++++++++++++++
> >  5 files changed, 111 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> 
> [...]
> 
> > +bool lan966x_xdp_port_present(struct lan966x_port *port)
> > +{
> > +     return !!port->xdp_prog;
> > +}
> 
> Why uninline such a simple check? I realize you want to keep all XDP
> stuff inside in the separate file, but doesn't this one looks too
> much?

I was kind of hoping that the compiler will inline it for me.
But I can add it in the header file to inline it.

> 
> > +
> > +int lan966x_xdp_port_init(struct lan966x_port *port)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     return xdp_rxq_info_reg(&port->xdp_rxq, port->dev, 0,
> > +                             lan966x->napi.napi_id);
> > +}
> > +
> > +void lan966x_xdp_port_deinit(struct lan966x_port *port)
> > +{
> > +     if (xdp_rxq_info_is_reg(&port->xdp_rxq))
> > +             xdp_rxq_info_unreg(&port->xdp_rxq);
> > +}
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
