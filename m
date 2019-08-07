Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6BD8436B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 06:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfHGEeb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Aug 2019 00:34:31 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53429 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfHGEea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 00:34:30 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x774YR7Q022834, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x774YR7Q022834
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 7 Aug 2019 12:34:27 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 7 Aug 2019
 12:34:26 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 4/5] r8152: support skb_add_rx_frag
Thread-Topic: [PATCH net-next 4/5] r8152: support skb_add_rx_frag
Thread-Index: AQHVTEi+c0k3CTBGAEW0bigEUz2nUKbuKCYAgADvzlA=
Date:   Wed, 7 Aug 2019 04:34:24 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D04FF@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-293-albertk@realtek.com>
 <20190806150802.72e0ef02@cakuba.netronome.com>
In-Reply-To: <20190806150802.72e0ef02@cakuba.netronome.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
> Sent: Wednesday, August 07, 2019 6:08 AM
[...]
> >  #define RTL8152_REQT_READ	0xc0
> > @@ -720,7 +723,7 @@ struct r8152 {
> >  	struct net_device *netdev;
> >  	struct urb *intr_urb;
> >  	struct tx_agg tx_info[RTL8152_MAX_TX];
> > -	struct list_head rx_info;
> > +	struct list_head rx_info, rx_used;
> 
> I don't see where entries on the rx_used list get freed when driver is
> unloaded, could you explain how that's taken care of?

When the driver is unloaded, all rx_agg would be freed from
info_list list.

The info_list includes all rx_agg buffers which may be idle
or be busy. The rx_done and rx_use are used to determine
the status of rx_agg buffer included in info_list.

info_list: the rx_agg buffer would be inserted in this list
	   when it is allocated.
rx_done: the rx_agg buffer is ready (contains rx data). Or
	 it needs to be resubmitted.
rx_use: the rx_agg buffer is busy and couldn't be submitted
	yet.


Best Regards,
Hayes


