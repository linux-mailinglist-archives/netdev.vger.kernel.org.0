Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3704D243F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbiCHW2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350822AbiCHW2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:28:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4014F583B8;
        Tue,  8 Mar 2022 14:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646778428; x=1678314428;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7l6jxbKbZmfdRAwe6nmc8SY4mZKw+uHcQDJK850rraA=;
  b=BRVJwWwbiEWNDfB3L/yAaGn9clgPfU9STD6kDGrH+AzQlkuMl7ojV7tq
   vC3us92cLSu773/f2naMMepVo5vOY8Lhf8p33z9mB2xS8gzbKugpEmCp4
   Ebk3p2vUjzeJ6T4TYwZaQoGQv2Dz3oaJ4WrikEMugY2Jx/BdhKM98b/bH
   gN/mBj/RJXDkeY+5KHKCHEhEjSlExJ/rRfIH7Que5SsvjT10gj1bTf6S7
   88kAnFXe+k8OsFyvAQI+an8vMci8x0yEiToAepaLEXEuMXlVIE93OYxdF
   ghPDw4sbb65MvGCcIYZTfeUrkdiG7o7qnxobwWs2CX9dx2MCR9fC9D2dY
   w==;
X-IronPort-AV: E=Sophos;i="5.90,165,1643698800"; 
   d="scan'208";a="156181155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 15:27:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 15:27:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 8 Mar 2022 15:27:07 -0700
Date:   Tue, 8 Mar 2022 23:30:00 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YifMSUA/uZoPnpf1@lunn.ch>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/08/2022 22:36, Andrew Lunn wrote:
> 
> >  static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
> >  {
> > -     u32 val;
> > +     unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
> > +     int ret = 0;
> >
> > -     return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
> > -                                      QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
> > -                                      READL_SLEEP_US, READL_TIMEOUT_US);
> > +     while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> > +              QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> > +             if (time_after(jiffies, time)) {
> > +                     ret = -ETIMEDOUT;
> > +                     break;
> > +             }
> 
> Did you try setting READL_SLEEP_US to 0? readx_poll_timeout_atomic()
> explicitly supports that.

I have tried but it didn't improve. It was the same as before.

> 
>     Andrew

-- 
/Horatiu
