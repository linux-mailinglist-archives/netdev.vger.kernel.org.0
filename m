Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46124B12C6
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733210AbfILQ2K convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Sep 2019 12:28:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:4827 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfILQ2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 12:28:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 09:28:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="269134479"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 12 Sep 2019 09:28:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Sep 2019 09:28:09 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Sep 2019 09:28:09 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Thu, 12 Sep 2019 09:28:09 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH bpf-next 2/3] ixgbe: fix xdp handle
 calculations
Thread-Topic: [Intel-wired-lan] [PATCH bpf-next 2/3] ixgbe: fix xdp handle
 calculations
Thread-Index: AQHVaMws/RmUsUOPPkiAyCDyL0vP3KcoPEcA
Date:   Thu, 12 Sep 2019 16:28:08 +0000
Message-ID: <5bda2f9461624c7a8a82e8eea25b7de5@intel.com>
References: <20190911172435.21042-1-ciara.loftus@intel.com>
 <20190911172435.21042-2-ciara.loftus@intel.com>
In-Reply-To: <20190911172435.21042-2-ciara.loftus@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzBmYWNmMzEtNmFjMS00NTU2LWFjMTUtOTdkNjkwNzhmYzA1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRk5FV2ppamtLdEFtRk1wTjNWWGpoQWlyQjlkRkl5dGwwZUFYUjlkRmhRS3RzNHF3TmVoYXRXXC9cL2RHVFZsbEJDIn0=
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
> Behalf Of Ciara Loftus
> Sent: Wednesday, September 11, 2019 10:25 AM
> To: netdev@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net; Topel,
> Bjorn <bjorn.topel@intel.com>; Karlsson, Magnus
> <magnus.karlsson@intel.com>; jonathan.lemon@gmail.com
> Cc: Richardson, Bruce <bruce.richardson@intel.com>; bpf@vger.kernel.org;
> intel-wired-lan@lists.osuosl.org; Loftus, Ciara <ciara.loftus@intel.com>;
> Laatz, Kevin <kevin.laatz@intel.com>
> Subject: [Intel-wired-lan] [PATCH bpf-next 2/3] ixgbe: fix xdp handle
> calculations
> 
> Commit 7cbbf9f1fa23 ("ixgbe: fix xdp handle calculations") reintroduced the
> addition of the umem headroom to the xdp handle in the ixgbe_zca_free,
> ixgbe_alloc_buffer_slow_zc and ixgbe_alloc_buffer_zc functions. However,
> the headroom is already added to the handle in the function
> ixgbe_run_xdp_zc. This commit removes the latter addition and fixes the
> case where the headroom is non-zero.
> 
> Fixes: 7cbbf9f1fa23 ("ixgbe: fix xdp handle calculations")
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


