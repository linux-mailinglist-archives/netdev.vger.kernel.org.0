Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CAE1134D5
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfLDS0B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Dec 2019 13:26:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:15408 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbfLDSZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 13:25:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 10:25:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,278,1571727600"; 
   d="scan'208";a="242942985"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga002.fm.intel.com with ESMTP; 04 Dec 2019 10:25:54 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 4 Dec 2019 10:25:54 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Dec 2019 10:25:53 -0800
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 4 Dec 2019 10:25:53 -0800
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH] ixgbe: Fix calculation of queue with
 VFs and flow director on interface flap
Thread-Topic: [Intel-wired-lan] [PATCH] ixgbe: Fix calculation of queue with
 VFs and flow director on interface flap
Thread-Index: AQHVqT+sRBWDmorGrk+LGmHTdjVjZ6eqTcLQ
Date:   Wed, 4 Dec 2019 18:25:53 +0000
Message-ID: <da48f1f5ff794532b951591f5406ca21@intel.com>
References: <20191127090355.27708-1-cambda@linux.alibaba.com>
In-Reply-To: <20191127090355.27708-1-cambda@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjhiY2Y5ZTUtYjg3NS00ZjJiLWE5ODEtYzk0ZTVlOWMwODVhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibzU4bWVHWUxGeEpCbkdONHNiNnVHQmd1WGJXanM1eGVqaFNiNlRsTXlRdmEwWlpwdEJjdWpRVUZLMHpLYVIxOSJ9
dlp-reaction: no-action
dlp-version: 11.0.400.15
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Cambda Zhu
> Sent: Wednesday, November 27, 2019 1:04 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: Cambda Zhu <cambda@linux.alibaba.com>; Tyl, RadoslawX
> <radoslawx.tyl@intel.com>; netdev@vger.kernel.org; Joseph Qi
> <joseph.qi@linux.alibaba.com>; intel-wired-lan@lists.osuosl.org; David S.
> Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] ixgbe: Fix calculation of queue with VFs
> and flow director on interface flap
> 
> This patch fixes the calculation of queue when we restore flow director filters
> after resetting adapter. In ixgbe_fdir_filter_restore(), filter's vf may be zero
> which makes the queue outside of the rx_ring array.
> 
> The calculation is changed to the same as ixgbe_add_ethtool_fdir_entry().
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 37
> +++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 10 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


