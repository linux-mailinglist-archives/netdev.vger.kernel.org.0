Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46868B909
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjBFJwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBFJwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:52:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB571CAF1;
        Mon,  6 Feb 2023 01:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675677151; x=1707213151;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/fz92rrfNiQYYLl9iRrLzt4/HkXzlkAqUMhrDatDgB8=;
  b=HvD1YekvV6jz3rPu2H6WutArgWIrw3owrhCWBOnJNl58ppaYAYKaQHjX
   HSRDa1RV4JB90lcK7wLoOkHaqwwkvjiexc7iCaTnvCXYckJ2hzYQSfBJa
   4dBl/Zj9aP5IvtFHdypUBCvSkyJL4kZoT+S6yFLNptFjcT0/CqgXXtCc7
   cfYo9ZBYNWua4O3gWDWuBVYGqK9AKwMzPrDuRxh0e6rquVfUAEWtEmdka
   ioHJy9batSpIig1dRMpqc481Nw6+Y+iIp4o/9Q27L4T/m5vCRlTUUHiLJ
   TbPvqVX+iFCCQZuiM68nIDGpepeAG+yJtq4nB2RSk5s7AIvV6GG/G7d/V
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,276,1669100400"; 
   d="scan'208";a="199083144"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2023 02:52:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 02:52:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Mon, 6 Feb 2023 02:52:28 -0700
Date:   Mon, 6 Feb 2023 10:52:27 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: lan966x: Add support for TC flower filter
 statistics
Message-ID: <20230206095227.25jh3cpix5k55qv3@soft-dev3-1>
References: <20230203135349.547933-1-horatiu.vultur@microchip.com>
 <Y96R+oEaZijtdaFH@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y96R+oEaZijtdaFH@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/04/2023 18:12, Simon Horman wrote:
> 
> On Fri, Feb 03, 2023 at 02:53:49PM +0100, Horatiu Vultur wrote:
> > Add flower filter packet statistics. This will just read the TCAM
> > counter of the rule, which mention how many packages were hit by this
> > rule.
> 
> I am curious to know how HW stats only updating the packet count
> interacts with SW stats also incrementing other values, such as the byte
> count.

First, our HW can count only the packages and not also the bytes,
unfortunately. Also we use the flag 'skip_sw' when we add the rules in
this case the statistics look OK.
If the user doesn't use the skip_sw then the statistics will look
something like this (using command: tc -s filter show dev eth0 ingress):

        Action statistics:
        Sent 92 bytes 4 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 92 bytes 2 pkt
        Sent hardware 0 bytes 2 pkt
        backlog 0b 0p requeues 0
        used_hw_stats immediate

As you see there are different counters for SW and Hw statistics.

> 
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../microchip/lan966x/lan966x_tc_flower.c     | 22 +++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> > index 88c655d6318fa..aac3d7c87f1d5 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> > @@ -234,6 +234,26 @@ static int lan966x_tc_flower_del(struct lan966x_port *port,
> >       return err;
> >  }
> >
> > +static int lan966x_tc_flower_stats(struct lan966x_port *port,
> > +                                struct flow_cls_offload *f,
> > +                                struct vcap_admin *admin)
> > +{
> > +     struct vcap_counter count;
> > +     int err;
> > +
> > +     memset(&count, 0, sizeof(count));
> 
> nit: As was pointed out to me recently it's simpler to declare
>      count as follows and skip the memset entirely.
>      No need to respin for this!
> 
>      struct vcap_counter count = {};

Good to know this.

> 
> > +
> > +     err = vcap_get_rule_count_by_cookie(port->lan966x->vcap_ctrl,
> > +                                         &count, f->cookie);
> > +     if (err)
> > +             return err;
> > +
> > +     flow_stats_update(&f->stats, 0x0, count.value, 0, 0,
> > +                       FLOW_ACTION_HW_STATS_IMMEDIATE);
> > +
> > +     return err;
> > +}
> > +
> >  int lan966x_tc_flower(struct lan966x_port *port,
> >                     struct flow_cls_offload *f,
> >                     bool ingress)
> > @@ -252,6 +272,8 @@ int lan966x_tc_flower(struct lan966x_port *port,
> >               return lan966x_tc_flower_add(port, f, admin, ingress);
> >       case FLOW_CLS_DESTROY:
> >               return lan966x_tc_flower_del(port, f, admin);
> > +     case FLOW_CLS_STATS:
> > +             return lan966x_tc_flower_stats(port, f, admin);
> >       default:
> >               return -EOPNOTSUPP;
> >       }
> > --
> 
> Also, not strictly related, but could you consider, as a favour to
> reviewers, fixing the driver so that the following doesn't fail:
> 
> $ make drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
>   DESCEND objtool
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.o
> In file included from drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c:3:
> drivers/net/ethernet/microchip/lan966x/lan966x_main.h:18:10: fatal error: vcap_api.h: No such file or directory
>    18 | #include <vcap_api.h>
>       |          ^~~~~~~~~~~~
> compilation terminated.

I will try to have a look at this.


-- 
/Horatiu
