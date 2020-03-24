Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC1A190984
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 10:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCXJYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 05:24:39 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:44566 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCXJYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 05:24:38 -0400
IronPort-SDR: 9rNACHU5GfjfbxS52CSXzX4cpJYA2I123pBps2yVbW5cCG9XrQZadfkYQLVQE5HkzsT7qi2Prc
 zypdd4Rm+Giodg0ZhLNvpP4lfPWaA0AKUxSbOPTum/ZqpP9tF5hNdyW/ggINTBONSRcj6iPJNR
 nMdMpnAUGKnTocalTYMixM4ihZSeNlcY612xGuU0r/e1oznQ0Q7XdCjtFwvMz3Hn5Hk63mFjaE
 qPhMKejNa7wmLV1BCgaMJYba67d7Guq3q454J3MBscuHCleDlb+ibA8iGfwbd9IP1UiVFz1AL1
 eW0=
X-IronPort-AV: E=Sophos;i="5.72,299,1580799600"; 
   d="scan'208";a="70035298"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2020 02:24:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Mar 2020 02:24:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 24 Mar 2020 02:24:37 -0700
Date:   Tue, 24 Mar 2020 10:24:36 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Yangbo Lu <yangbo.lu@nxp.com>, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Message-ID: <20200324092436.stq25qac2h4rm3il@soft-dev3.microsemi.net>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
 <CA+h21hoBwDuWCFbO70u1FAERB8zc5F+H5URBkn=2_bpRRRz1oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hoBwDuWCFbO70u1FAERB8zc5F+H5URBkn=2_bpRRRz1oA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

The 03/20/2020 15:20, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Yangbo,
> 
> On Fri, 20 Mar 2020 at 12:42, Yangbo Lu <yangbo.lu@nxp.com> wrote:
> >
> > Support 4 programmable pins for only one function periodic
> > signal for now. Since the hardware is not able to support
> > absolute start time, driver starts periodic signal immediately.
> >
> 
> Are you absolutely sure it doesn't support absolute start time?
> Because that would mean it's pretty useless if the phase of the PTP
> clock signal is out of control.

It looks like there is no support for absolute start time. But you
should be able to control the phase using the register
PIN_WF_LOW_PERIOD.

> 
> I tested your patch on the LS1028A-RDB board using the following commands:
> 
> # Select PEROUT function and assign a channel to each of pins
> SWITCH_1588_DAT0 and SWITCH_1588_DAT1
> echo '2 0' > /sys/class/ptp/ptp1/pins/switch_1588_dat0
> echo '2 1' > /sys/class/ptp/ptp1/pins/switch_1588_dat1
> # Generate pulses with 1 second period on channel 0
> echo '0 0 0 1 0' > /sys/class/ptp/ptp1/period
> # Generate pulses with 1 second period on channel 1
> echo '1 0 0 1 0' > /sys/class/ptp/ptp1/period
> 
> And here is what I get:
> https://drive.google.com/open?id=1ErWufJL0TWv6hKDQdF1pRL5gn4hn4X-r
> 
> So the periodic output really starts 'now' just like the print says,
> so the output from DAT0 is not even in sync with DAT1.
> 
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
> 
> Thanks,
> -Vladimir

-- 
/Horatiu
