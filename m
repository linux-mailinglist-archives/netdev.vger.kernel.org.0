Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605861C483C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEDU2F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 May 2020 16:28:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:60139 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbgEDU2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 16:28:05 -0400
IronPort-SDR: tEXcMrxJOw4out8B+zdAY1kEJSsAr0iepczBan6sKrt+4ctBGQo93G1Z9oi/iAobZ1z+pROtUg
 GNKfkuJQh/9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 13:28:04 -0700
IronPort-SDR: Tq/jZWgJ6AUwkRsjaMqbQWY2fWdseKH72RaHEPvpnJo0rzelICaR5nI2gOywHD4HNMNdXASnkw
 1zC1NwnCC7dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,353,1583222400"; 
   d="scan'208";a="249260889"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga007.fm.intel.com with ESMTP; 04 May 2020 13:28:03 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.68]) with mapi id 14.03.0439.000;
 Mon, 4 May 2020 13:28:03 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>,
        "kai.heng.feng@canonical.com" <kai.heng.feng@canonical.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] igb: Report speed and duplex as unknown when device is
 runtime suspended
Thread-Topic: [PATCH] igb: Report speed and duplex as unknown when device is
 runtime suspended
Thread-Index: AQHWIjoCs1YMgvTPr0+YmRp3SYYI9aiYsmYA//+t7dA=
Date:   Mon, 4 May 2020 20:28:03 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D9404498687DD5@ORSMSX112.amr.corp.intel.com>
References: <20200504173218.1724-1-kai.heng.feng@canonical.com>
 <20200504.112056.1400711844642835898.davem@davemloft.net>
In-Reply-To: <20200504.112056.1400711844642835898.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, May 4, 2020 11:21
> To: kai.heng.feng@canonical.com
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; intel-wired-
> lan@lists.osuosl.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] igb: Report speed and duplex as unknown when device is
> runtime suspended
> 
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Date: Tue,  5 May 2020 01:32:18 +0800
> 
> > igb device gets runtime suspended when there's no link partner. We
> > can't get correct speed under that state:
> > $ cat /sys/class/net/enp3s0/speed
> > 1000
> >
> > In addition to that, an error can also be spotted in dmesg:
> > [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
> >
> > Since device can only be runtime suspended when there's no link
> > partner, we can directly report the speed and duplex as unknown.
> >
> > The more generic approach will be wrap get_link_ksettings() with
> > begin() and complete() callbacks. However, for this particular issue,
> > begin() calls igb_runtime_resume() , which tries to rtnl_lock() while
> > the lock is already hold by upper ethtool layer.
> >
> > So let's take this approach until the igb_runtime_resume() no longer
> > needs to hold rtnl_lock.
> >
> > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> I'm assuming I will get this from upstream via Jeff K.
[Kirsher, Jeffrey T] 

Yep, I will be picking this up once Alex's last questions/concerns are addressed.
