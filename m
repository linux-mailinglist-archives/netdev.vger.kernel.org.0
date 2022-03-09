Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CE84D2B7B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiCIJMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiCIJMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:12:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB7E16BF9F;
        Wed,  9 Mar 2022 01:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646817105; x=1678353105;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mZMvj/d4RxDXuFyqTt7AkqfhH3BqZuN573wwxJ8CnwU=;
  b=jEr4A+MEcmTGK6wF7r7bLck/IbmZ3XYXHt8kUwJrlVLdXDZr++wTYAWX
   DaEh7BaKWYOTfGH0C/xQNPu7kIMKRvqoraYxq4IwaXYGLe+JSR30JtPtw
   BpZ6LyPeJIMM+/oWBlTMnWAOelzEkGPNpebusq8m+fKyFwgAHj0dBaDM4
   xt0XWzt3Q5yRIdkabZ0TLUepR/lobh00cCzNfijhDPZuFYxoQR9hYRUP6
   +pUg1lBELuKo57k0Qe+bgUzlze1xdsy2TCUlDtUYsTA87fk1P+bnbW7dE
   SpRp8G246t8s6MIha4N+fOh+nt5APPbhsn1XKpdJMZACu+vICq62Gp0AL
   w==;
X-IronPort-AV: E=Sophos;i="5.90,167,1643698800"; 
   d="scan'208";a="165068916"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2022 02:11:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Mar 2022 02:11:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 9 Mar 2022 02:11:44 -0700
Date:   Wed, 9 Mar 2022 10:14:37 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <20220309091437.in7leaufeagwotty@soft-dev3-1.localhost>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
 <20220308164024.5f65b426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220308164024.5f65b426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/08/2022 16:40, Jakub Kicinski wrote:
> 
> On Tue, 8 Mar 2022 23:30:00 +0100 Horatiu Vultur wrote:
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
> Huh, is ktime_get() super expensive on that platform?

Hm.. it looks like. Just adding ktime_get() before the while loop, then
the performance drops like before.
I am using SOC_LAN966 which has an ARMv7 CPU. So I am not sure how
expensive is ktime_get().

> jiffies vs ktime seems to be the main difference?

-- 
/Horatiu
