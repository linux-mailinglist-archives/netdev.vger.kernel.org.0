Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE74D3C81
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiCIWDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiCIWD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:03:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58A649CB0;
        Wed,  9 Mar 2022 14:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646863345; x=1678399345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9+Y+W6kPpAhOBsTIr7uplKjRx92r1AT6ix+u1mTH2hM=;
  b=BdN5dhV4N0WwLDIEZ6bsv/aETPS9ZYvuCrl4UV30Zh5eVtEH40T5OMfg
   wpkIZyajzEf5frYesVogZMJ1vjSqzog6PcNXarvFLkkZnj4RBh5PwOCkj
   gZiFKy3QZEL9UuX+AENUR76cU1YGhSee9moAkfv6rrbZzwJYuQC2N6UHK
   RhO1uqG7KoGKHGLeZtD10e3Rw9HAyqsSFTIpKOwAncsO7wYCB7fvMz4iM
   PrlShOw9vbIMRsfnWQlmLUqHqOwv58btvywROzn0lxGUg2YQ7fzDPkaRT
   SAdchBLma3w4p4v3/JPE334GEJkE00CeMerkKpJpNJ0WiU6mZiJ76nryd
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,168,1643698800"; 
   d="scan'208";a="155874789"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2022 15:02:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Mar 2022 15:02:23 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 9 Mar 2022 15:02:22 -0700
Date:   Wed, 9 Mar 2022 23:05:16 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <20220309220516.smxhbtikbvctlkeh@soft-dev3-1.localhost>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
 <YiinmN+VBWRxN5l4@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YiinmN+VBWRxN5l4@lunn.ch>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/09/2022 14:11, Andrew Lunn wrote:
> 
> On Tue, Mar 08, 2022 at 11:30:00PM +0100, Horatiu Vultur wrote:
> > The 03/08/2022 22:36, Andrew Lunn wrote:
> > >
> > > >  static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
> > > >  {
> > > > -     u32 val;
> > > > +     unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
> > > > +     int ret = 0;
> > > >
> > > > -     return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
> > > > -                                      QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
> > > > -                                      READL_SLEEP_US, READL_TIMEOUT_US);
> > > > +     while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> > > > +              QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> > > > +             if (time_after(jiffies, time)) {
> > > > +                     ret = -ETIMEDOUT;
> > > > +                     break;
> > > > +             }
> > >
> > > Did you try setting READL_SLEEP_US to 0? readx_poll_timeout_atomic()
> > > explicitly supports that.
> >
> > I have tried but it didn't improve. It was the same as before.
> 
> The reason i recommend ipoll.h is that your implementation has the
> usual bug, which iopoll does not have. Since you are using _atomic()
> it is less of an issue, but it still exists.
> 
>      while (!(lan_rd(lan966x, QS_INJ_STATUS) &
>               QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> 
> Say you take an interrupt here
> 
>              if (time_after(jiffies, time)) {
>                      ret = -ETIMEDOUT;
>                      break;
>              }
> 
> 
> The interrupt takes a while, so that by the time you get to
> time_after(), you have reached your timeout. So -ETIMEDOUT is
> returned. But in fact, the hardware has done its thing, and if you
> where to read the status the bit would be set, and you should actually
> return O.K, not an error.

That is a good catch and really nice explanation!
Then if I add also the check at the end, then it should be also OK.

> 
> iopoll does another check of the status before deciding to return
> -ETIMEDOUT or O.K.
> 
> If you decide to simply check the status directly after the write, i
> suggest you then use readx_poll_timeout_atomic() if you do need to
> poll.
> 
>         Andrew

-- 
/Horatiu
