Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C757450EA85
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 22:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245423AbiDYUbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 16:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245551AbiDYUbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 16:31:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2721531DDB;
        Mon, 25 Apr 2022 13:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650918516; x=1682454516;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FpiU/JE3JgocdGXOl8+g5I9+KIpIYfU2V/kSMRJ742U=;
  b=XPzuH7A0ENbF7OK4vCPhTvmFXliVzo4h5HeDnhM8AyTmk9pY7eTO6zCR
   O+F0kxe56Cm6Hz2rnVuLS8a5RDzYPYgVGGol61yRLDsvthdeHFRT5VxYh
   BDhkIXUJNc43s3iLt/BXhFVBvgllPHtNRhrKfRyMP0qfZYALVQQ3soeGZ
   1FjDybEKQrDZNlaNZwhnQ4acRSIUh1RBd7Yuwgp606cQ1CE8gavfmUFIi
   RVwDWKItvszuhP2DZNNFr8spr2T2A01IB7181hSV/gDjQVhV/ascu8rFl
   anZCTOr0U/qnCxQCdow84u2h8Mh1oJyk32f3qfyKSLuE/aY5dntgmwsuU
   w==;
X-IronPort-AV: E=Sophos;i="5.90,289,1643698800"; 
   d="scan'208";a="153762962"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2022 13:28:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 25 Apr 2022 13:28:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 25 Apr 2022 13:28:33 -0700
Date:   Mon, 25 Apr 2022 22:31:54 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 5/5] net: lan966x: Add support for PTP_PF_EXTTS
Message-ID: <20220425203154.vtqcumdvzghvtlad@soft-dev3-1.localhost>
References: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
 <20220424145824.2931449-6-horatiu.vultur@microchip.com>
 <20220424150909.GA29569@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220424150909.GA29569@hoboy.vegasvil.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/24/2022 08:09, Richard Cochran wrote:

Hi Richard,

> 
> On Sun, Apr 24, 2022 at 04:58:24PM +0200, Horatiu Vultur wrote:
> 
> > @@ -321,6 +321,63 @@ irqreturn_t lan966x_ptp_irq_handler(int irq, void *args)
> >       return IRQ_HANDLED;
> >  }
> >
> > +irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args)
> > +{
> > +     struct lan966x *lan966x = args;
> > +     struct lan966x_phc *phc;
> > +     unsigned long flags;
> > +     u64 time = 0;
> > +     time64_t s;
> > +     int pin, i;
> > +     s64 ns;
> > +
> > +     if (!(lan_rd(lan966x, PTP_PIN_INTR)))
> > +             return IRQ_NONE;
> > +
> > +     /* Go through all domains and see which pin generated the interrupt */
> > +     for (i = 0; i < LAN966X_PHC_COUNT; ++i) {
> > +             struct ptp_clock_event ptp_event = {0};
> > +
> > +             phc = &lan966x->phc[i];
> > +             pin = ptp_find_pin(phc->clock, PTP_PF_EXTTS, 0);
> 
> Not safe to call ptp_find_pin() from ISR.  See comment in include/linux/ptp_clock_kernel.h

Good catch.
From what I can see, I should be able to use ptp_find_pin_unlocked.

> 
> Thanks,
> Richard

-- 
/Horatiu
