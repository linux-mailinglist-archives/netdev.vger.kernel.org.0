Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E901350A3
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgAIAuR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 19:50:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:61491 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgAIAuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 19:50:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 16:50:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,412,1571727600"; 
   d="scan'208";a="254415840"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jan 2020 16:50:17 -0800
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jan 2020 16:50:16 -0800
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.250]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.178]) with mapi id 14.03.0439.000;
 Wed, 8 Jan 2020 16:50:16 -0800
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] e1000e: fix missing cpu_to_le64 on buffer_addr
Thread-Topic: [PATCH] e1000e: fix missing cpu_to_le64 on buffer_addr
Thread-Index: AQHVtYkDl8Hax0/3vEaIb+hEJx6RVafhokAw
Date:   Thu, 9 Jan 2020 00:50:16 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971A921A@ORSMSX103.amr.corp.intel.com>
References: <20191218095308.2397408-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20191218095308.2397408-1-ben.dooks@codethink.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGJmZDc2MWMtMTc4Zi00ZDg3LTg0OWMtYmU0NDdlZDJkZmQ4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZFk0QktCSEUrTDBJN3R0UTg4VWpIXC94R1pxaDVuZkZ5VFpHUzdLVDI1clM5XC9YbTVoNCtKSmFONlBXYTdaZmI4In0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Ben Dooks (Codethink)
> Sent: Wednesday, December 18, 2019 1:53 AM
> To: ben.dooks@codethink.co.uk
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org
> Subject: [PATCH] e1000e: fix missing cpu_to_le64 on buffer_addr
> 
> The following warning suggests there is a missing cpu_to_le64() in
> the e1000_flush_tx_ring() function (it is also the behaviour
> elsewhere in the driver to do cpu_to_le64() on the buffer_addr
> when setting it)
> 
> drivers/net/ethernet/intel/e1000e/netdev.c:3813:30: warning: incorrect
> type in assignment (different base types)
> drivers/net/ethernet/intel/e1000e/netdev.c:3813:30:    expected restricted
> __le64 [usertype] buffer_addr
> drivers/net/ethernet/intel/e1000e/netdev.c:3813:30:    got unsigned long
> long [usertype] dma
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
> ---
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Tested-by: Aaron Brown <aaron.f.brown@intel.com>
