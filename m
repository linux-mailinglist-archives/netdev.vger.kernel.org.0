Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F431031C5
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKTCtw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Nov 2019 21:49:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:46939 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfKTCtw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 21:49:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 18:49:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; 
   d="scan'208";a="215673958"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 19 Nov 2019 18:49:51 -0800
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 Nov 2019 18:49:50 -0800
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.179]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.41]) with mapi id 14.03.0439.000;
 Tue, 19 Nov 2019 18:49:50 -0800
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Robert Beckett <bob.beckett@collabora.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2] igb: dont drop packets if rx flow
 control is enabled
Thread-Topic: [Intel-wired-lan] [PATCH v2] igb: dont drop packets if rx flow
 control is enabled
Thread-Index: AQHViO3rLlJTjkE42ECdgr94qN42KKeTiFmw
Date:   Wed, 20 Nov 2019 02:49:50 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B97179755@ORSMSX103.amr.corp.intel.com>
References: <20191022153155.9008-1-bob.beckett@collabora.com>
In-Reply-To: <20191022153155.9008-1-bob.beckett@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTllZjVhNWEtMGUwZS00MGQ4LWEwNTAtOTY3Yjc4MTM5Y2FlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiK0V2eXEyWDBLem5DMnhDY1BFd1I1bmRrZ3RXb2RRb1IzYllPMFwvUGMzV1JZaUE3R2VqSWRaa3VFUnBRZE1yN04ifQ==
x-ctpclassification: CTP_NT
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
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Robert Beckett
> Sent: Tuesday, October 22, 2019 8:32 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Robert Beckett <bob.beckett@collabora.com>; netdev@vger.kernel.org;
> David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH v2] igb: dont drop packets if rx flow control
> is enabled
> 
> If rx flow control has been enabled (via autoneg or forced), packets
> should not be dropped due to rx descriptor ring exhaustion. Instead
> pause frames should be used to apply back pressure. This only applies
> if VFs are not in use.
> 
> Move SRRCTL setup to its own function for easy reuse and only set drop
> enable bit if rx flow control is not enabled.
> 
> Since v1: always enable dropping of packets if VFs in use.
> 
> Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> ---
>  drivers/net/ethernet/intel/igb/igb.h         |  1 +
>  drivers/net/ethernet/intel/igb/igb_ethtool.c |  8 ++++
>  drivers/net/ethernet/intel/igb/igb_main.c    | 47 ++++++++++++++------
>  3 files changed, 42 insertions(+), 14 deletions(-)
> 
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
