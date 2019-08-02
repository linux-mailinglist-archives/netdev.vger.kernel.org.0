Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244057FF44
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404288AbfHBRH0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Aug 2019 13:07:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:47035 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403807AbfHBRH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 13:07:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 10:07:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,338,1559545200"; 
   d="scan'208";a="201720256"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga002.fm.intel.com with ESMTP; 02 Aug 2019 10:07:25 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 2 Aug 2019 10:07:25 -0700
Received: from orsmsx122.amr.corp.intel.com ([169.254.11.68]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.77]) with mapi id 14.03.0439.000;
 Fri, 2 Aug 2019 10:07:24 -0700
From:   "Allan, Bruce W" <bruce.w.allan@intel.com>
To:     Colin King <colin.king@canonical.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][net-next] ice: fix potential infinite
 loop
Thread-Topic: [Intel-wired-lan] [PATCH][net-next] ice: fix potential
 infinite loop
Thread-Index: AQHVSUpMQyMMSydwckqiAxGJUhtvkKboBjCA
Date:   Fri, 2 Aug 2019 17:07:24 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18401096DB0DF@ORSMSX122.amr.corp.intel.com>
References: <20190802155217.16996-1-colin.king@canonical.com>
In-Reply-To: <20190802155217.16996-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODEwYjE0OTYtMjlkZS00MDlmLTk2YTMtMWU0Y2QxOTc5ZDhhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiM1lmQzhFaHFodmkwbXoxUWhFRk95ZE5EV1NBd3pkRlZDV1RuYVZoMzZnNFFvZ0RxMjFnTmNwTDdcLysrOHZRcVUifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On Behalf
> Of Colin King
> Sent: Friday, August 02, 2019 8:52 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S . Miller
> <davem@davemloft.net>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH][net-next] ice: fix potential infinite loop
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> The loop counter of a for-loop is a u8 however this is being compared
> to an int upper bound and this can lead to an infinite loop if the
> upper bound is greater than 255 since the loop counter will wrap back
> to zero. Fix this potential issue by making the loop counter an int.
> 
> Addresses-Coverity: ("Infinite loop")

Actually, num_alloc_vfs should probably be a u16 instead of an int since num_alloc_vfs cannot exceed 256.

Which Coverity scan reported this and what options are used in the analysis?

> Fixes: c7aeb4d1b9bf ("ice: Disable VFs until reset is completed")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index c26e6a102dac..088543d50095 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -488,7 +488,7 @@ static void
>  ice_prepare_for_reset(struct ice_pf *pf)
>  {
>  	struct ice_hw *hw = &pf->hw;
> -	u8 i;
> +	int i;
> 
>  	/* already prepared for reset */
>  	if (test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
> --
> 2.20.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
