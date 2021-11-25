Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED2145D724
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 10:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351294AbhKYJ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 04:29:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:64468 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353293AbhKYJ15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 04:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637832285; x=1669368285;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bOgiuiiPcvB4FuclcRHS2sLWtNkNt7ECdbQr0u1l51Q=;
  b=dtmj9LHQAOihCljanjAKvcrKQMtgXsEETXNIHBDSPd8RPBMAmtaQpBgj
   1s3/En1sGOTuz4poSTc6V9czQ07RQo8OOgn0xCCGDoLE3oSENy08pZVMl
   uQkDUtLPNjxRdrtLqVBmPbdg1GogUmn9E3wbKOGU83Hc4BQj6tcvo7dsq
   +cY7cwRjkDjboPgrFGF9ro5/QCiPO/ey9LhPugPeTOdnj19InBrS7gEjV
   P8qixJnA6ODYIg+c5er0vDf7lq0n0MScDyy2fuMiT9Vs6gfdcuFoYzsBk
   q2/CmWouGVVzWkliXTcQbUJHeNH3EWW8MaANKBeksLPFUB8RjjzANOID4
   A==;
IronPort-SDR: EUaciTsYnjZNFVDay0nfpQMkWIIKnkcAbe15uniw3nQBuaXxB2CuyKdtOQrIgLLcKdcgPhVlxh
 W9sXpOs6xcjvufB96+VNn/l5IQKuXBYmCfKJPbTSokBTd3Big4u+pX4LI0BoF06CA3GXO7fy39
 PyTasGACNyysAkUJ/swnQxo3epnB1E4AUfbg40inr3i467D/231U98Q3Zw5YYFN8MvU7Drwmnp
 gcXmfwbEooaguMRR36FH22RBOWVLNaT8asr4gfJCK+LzzlinSJkFkTPU06udJDlifF+/rvtGcO
 yiALr4v5jzoiSaeGz+ZoK1TW
X-IronPort-AV: E=Sophos;i="5.87,262,1631602800"; 
   d="scan'208";a="137702892"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2021 02:24:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 25 Nov 2021 02:24:45 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 25 Nov 2021 02:24:44 -0700
Date:   Thu, 25 Nov 2021 10:26:38 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/6] net: lan966x: add port module support
Message-ID: <20211125092638.7b2u75zdv2ulekmo@soft-dev3-1.localhost>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
 <20211123135517.4037557-4-horatiu.vultur@microchip.com>
 <YZ59hpDWjNjvx5kP@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YZ59hpDWjNjvx5kP@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/24/2021 18:59, Andrew Lunn wrote:

Hi Andrew,

> 
> > +static void lan966x_ifh_inject(u32 *ifh, size_t val, size_t pos, size_t length)
> > +{
> > +     int i;
> > +
> > +     for (i = pos; i < pos + length; ++i) {
> > +             if (val & BIT(i - pos))
> > +                     ifh[IFH_LEN - i / 32 - 1] |= BIT(i % 32);
> > +             else
> > +                     ifh[IFH_LEN - i / 32 - 1] &= ~(BIT(i % 32));
> > +     }
> > +}
> > +
> > +static void lan966x_gen_ifh(u32 *ifh, struct lan966x_frame_info *info,
> > +                         struct lan966x *lan966x)
> > +{
> > +     lan966x_ifh_inject(ifh, 1, IFH_POS_BYPASS, 1);
> > +     lan966x_ifh_inject(ifh, info->port, IFH_POS_DSTS, IFH_WID_DSTS);
> > +     lan966x_ifh_inject(ifh, info->qos_class, IFH_POS_QOS_CLASS,
> > +                        IFH_WID_QOS_CLASS);
> > +     lan966x_ifh_inject(ifh, info->ipv, IFH_POS_IPV, IFH_WID_IPV);
> > +}
> > +
> 
> > +     /* Write IFH header */
> > +     for (i = 0; i < IFH_LEN; ++i) {
> > +             /* Wait until the fifo is ready */
> > +             while (!(QS_INJ_STATUS_FIFO_RDY_GET(lan_rd(lan966x, QS_INJ_STATUS)) &
> > +                      BIT(grp)))
> > +                     ;
> > +
> > +             lan_wr((__force u32)cpu_to_be32(ifh[i]), lan966x,
> > +                    QS_INJ_WR(grp));
> 
> There is a lot of magic going on here constructing the IFH. Is it
> possible to define the structure using bit fields and __be32. You
> should then be able to skip this cpu_to_be32 and the ugly cast. And
> the actual structure should be a lot clearer.

If I undestood you correctly I have tried to do the following:

struct lan966x_ifh {
    __be32 timestamp;
    __be32 bypass : 1;
    __be32 port : 3;
    ...
};

But then I start to get errors from sparse:

error: invalid bitfield specifier for type restricted __be32.

On thing that I can do is to use packing() instead of
lan966x_ifh_inject() and declare ifh as __be32.
I think this will also work and simplify a little bit the code.

> 
> > +static int lan966x_rx_frame_word(struct lan966x *lan966x, u8 grp, bool ifh,
> > +                              u32 *rval)
> > +{
> > +     u32 bytes_valid;
> > +     u32 val;
> > +
> > +     val = lan_rd(lan966x, QS_XTR_RD(grp));
> > +     if (val == XTR_NOT_READY) {
> > +             if (ifh)
> > +                     return -EIO;
> > +
> > +             do {
> > +                     val = lan_rd(lan966x, QS_XTR_RD(grp));
> > +             } while (val == XTR_NOT_READY);
> 
> I would add some sort of timeout here, just in case the hardware
> breaks. You have quite a few such loops, it would be better to make
> use of the helpers in linux/iopoll.h.

Yes, I will do that, I will also add sime timeout also for injection.

> 

-- 
/Horatiu
