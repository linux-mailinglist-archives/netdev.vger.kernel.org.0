Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C76C6E9F2
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfGSRTO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jul 2019 13:19:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:44903 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730927AbfGSRTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 13:19:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 10:19:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="188039930"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jul 2019 10:19:12 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 10:19:11 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.232]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.246]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 10:19:11 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v2 01/10] i40e: simplify Rx buffer
 recycle
Thread-Topic: [Intel-wired-lan] [PATCH v2 01/10] i40e: simplify Rx buffer
 recycle
Thread-Index: AQHVO8isPSN96BFiCUm00MdT0dQEY6bSNFwA
Date:   Fri, 19 Jul 2019 17:19:11 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40C2FD@ORSMSX104.amr.corp.intel.com>
References: <20190620090958.2135-1-kevin.laatz@intel.com>
 <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190716030637.5634-2-kevin.laatz@intel.com>
In-Reply-To: <20190716030637.5634-2-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTViYTFlZWQtODk3MC00ZTlhLWI4ZmItN2FjMWE5ZjczOGZmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVmVkR1ZROVVDV3YrZDE3N1NlRkkwSm00WUhYZkVRVDdsSlZ6NzFJcGZEVkoxZXZWRldhaUFqOEZHM1NBbFdRcCJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Kevin Laatz
> Sent: Monday, July 15, 2019 8:06 PM
> To: netdev@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net; Topel,
> Bjorn <bjorn.topel@intel.com>; Karlsson, Magnus
> <magnus.karlsson@intel.com>; jakub.kicinski@netronome.com;
> jonathan.lemon@gmail.com
> Cc: Richardson, Bruce <bruce.richardson@intel.com>; Loftus, Ciara
> <ciara.loftus@intel.com>; intel-wired-lan@lists.osuosl.org;
> bpf@vger.kernel.org; Laatz, Kevin <kevin.laatz@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 01/10] i40e: simplify Rx buffer recycle
> 
> Currently, the dma, addr and handle are modified when we reuse Rx buffers
> in zero-copy mode. However, this is not required as the inputs to the
> function are copies, not the original values themselves. As we use the copies
> within the function, we can use the original 'old_bi' values directly without
> having to mask and add the headroom.
> 
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


