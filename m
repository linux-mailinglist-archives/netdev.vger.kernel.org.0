Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7DB84369
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 06:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfHGEec convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Aug 2019 00:34:32 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53428 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfHGEeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 00:34:31 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x774YQEn022830, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x774YQEn022830
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 7 Aug 2019 12:34:26 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 7 Aug
 2019 12:34:25 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 2/5] r8152: replace array with linking list for rx information
Thread-Topic: [PATCH net-next 2/5] r8152: replace array with linking list
 for rx information
Thread-Index: AQHVTEi8dqICcI3sDEmqKF0S4wiBPqbuAp4AgAEQ7MA=
Date:   Wed, 7 Aug 2019 04:34:24 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D04FA@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-291-albertk@realtek.com>
 <20190806125342.4620a94f@cakuba.netronome.com>
In-Reply-To: <20190806125342.4620a94f@cakuba.netronome.com>
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
[...]
> >  static int rtl_stop_rx(struct r8152 *tp)
> >  {
> > -	int i;
> > +	struct list_head *cursor, *next, tmp_list;
> > +	unsigned long flags;
> > +
> > +	INIT_LIST_HEAD(&tmp_list);
> >
> > -	for (i = 0; i < RTL8152_MAX_RX; i++)
> > -		usb_kill_urb(tp->rx_info[i].urb);
> > +	/* The usb_kill_urb() couldn't be used in atomic.
> > +	 * Therefore, move the list of rx_info to a tmp one.
> > +	 * Then, list_for_each_safe could be used without
> > +	 * spin lock.
> > +	 */
> 
> Would you mind explaining in a little more detail why taking the
> entries from the list for a brief period of time is safe?

Usually, it needs the spin lock before accessing the entry
of the list "tp->rx_info". However, for some reasons,
if we want to access the entry without spin lock, we
cloud move all entries to a local list temporally. Then,
we could make sure no other one could access the entries
included in the temporal local list.

For this case, when I move all entries to a temporal 
local list, no other one could access them. Therefore,
I could access the entries included in the temporal local
list without spin lock.


Best Regards,
Hayes


