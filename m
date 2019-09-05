Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC66AAD0A
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391638AbfIEUc4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Sep 2019 16:32:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:41393 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732067AbfIEUc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:32:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:32:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="358571534"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga005.jf.intel.com with ESMTP; 05 Sep 2019 13:32:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Sep 2019 13:32:54 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Sep 2019 13:32:54 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Thu, 5 Sep 2019 13:32:54 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] iavf: fix MAC address setting for VFs
 when filter is rejected
Thread-Topic: [Intel-wired-lan] [PATCH] iavf: fix MAC address setting for VFs
 when filter is rejected
Thread-Index: AQHVY7QLjd11p33TCUmpnO3Wp4IioacdirQA
Date:   Thu, 5 Sep 2019 20:32:54 +0000
Message-ID: <16c6fa96d4b54e93891625668a4352e8@intel.com>
References: <20190905063422.28743-1-sassmann@kpanic.de>
In-Reply-To: <20190905063422.28743-1-sassmann@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjAzZGIxNmUtMWRkOC00Nzk0LTliZTctNzQwODYyZWUwOGE4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaGI3NlwvN29JcFo4eXJ1WG1CVExwMTBWajI4YlNCU2pjMGRqbkI1Z3A0QjM5ZHBvVWJnMnZPVkU5QzNYS1FNTkoifQ==
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
> Behalf Of Stefan Assmann
> Sent: Wednesday, September 4, 2019 11:34 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; davem@davemloft.net; sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] iavf: fix MAC address setting for VFs when
> filter is rejected
> 
> Currently iavf unconditionally applies MAC address change requests. This
> brings the VF in a state where it is no longer able to pass traffic if the PF
> rejects a MAC filter change for the VF.
> A typical scenario for a rejected MAC filter is for an untrusted VF to request
> to change the MAC address when an administratively set MAC is present.
> 
> To keep iavf working in this scenario the MAC filter handling in iavf needs to
> act on the PF reply regarding the MAC filter change. In the case of an ack the
> new MAC address gets set, whereas in the case of a nack the previous MAC
> address needs to stay in place.
> 
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c     | 1 -
>  drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 7 +++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


