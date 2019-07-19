Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA286E9FD
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbfGSRVG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jul 2019 13:21:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:28001 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbfGSRVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 13:21:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 10:21:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="188040530"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jul 2019 10:21:05 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.232]) by
 ORSMSX103.amr.corp.intel.com ([169.254.5.44]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 10:21:05 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v2 03/10] xsk: add support to allow
 unaligned chunk placement
Thread-Topic: [Intel-wired-lan] [PATCH v2 03/10] xsk: add support to allow
 unaligned chunk placement
Thread-Index: AQHVO8i8c3wKUR6Q/U2iq7Xsontky6bSNOqQ
Date:   Fri, 19 Jul 2019 17:21:04 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40C31D@ORSMSX104.amr.corp.intel.com>
References: <20190620090958.2135-1-kevin.laatz@intel.com>
 <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190716030637.5634-4-kevin.laatz@intel.com>
In-Reply-To: <20190716030637.5634-4-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjhkMjExZDktNzhmNS00NzYyLTgwNmQtNjQzNjgyNDI3NzdkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoib2pvYnd2S0lXNk5MSFdnUjBmbCszNk9sa0pSWWVIWUlcL001aG1yTWF3TTNiSHEyUGpoK1NGU0diUVFRdnAzajIifQ==
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
> Sent: Monday, July 15, 2019 8:07 PM
> To: netdev@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net; Topel,
> Bjorn <bjorn.topel@intel.com>; Karlsson, Magnus
> <magnus.karlsson@intel.com>; jakub.kicinski@netronome.com;
> jonathan.lemon@gmail.com
> Cc: Richardson, Bruce <bruce.richardson@intel.com>; Loftus, Ciara
> <ciara.loftus@intel.com>; intel-wired-lan@lists.osuosl.org;
> bpf@vger.kernel.org; Laatz, Kevin <kevin.laatz@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 03/10] xsk: add support to allow
> unaligned chunk placement
> 
> Currently, addresses are chunk size aligned. This means, we are very
> restricted in terms of where we can place chunk within the umem. For
> example, if we have a chunk size of 2k, then our chunks can only be placed at
> 0,2k,4k,6k,8k... and so on (ie. every 2k starting from 0).
> 
> This patch introduces the ability to use unaligned chunks. With these
> changes, we are no longer bound to having to place chunks at a 2k (or
> whatever your chunk size is) interval. Since we are no longer dealing with
> aligned chunks, they can now cross page boundaries. Checks for page
> contiguity have been added in order to keep track of which pages are
> followed by a physically contiguous page.
> 
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
> 
> ---
> v2:
>   - Add checks for the flags coming from userspace
>   - Fix how we get chunk_size in xsk_diag.c
>   - Add defines for masking the new descriptor format
>   - Modified the rx functions to use new descriptor format
>   - Modified the tx functions to use new descriptor format
> ---
>  include/net/xdp_sock.h      |  2 +
>  include/uapi/linux/if_xdp.h |  9 ++++
>  net/xdp/xdp_umem.c          | 17 ++++---
>  net/xdp/xsk.c               | 89 ++++++++++++++++++++++++++++++-------
>  net/xdp/xsk_diag.c          |  2 +-
>  net/xdp/xsk_queue.h         | 70 +++++++++++++++++++++++++----
>  6 files changed, 159 insertions(+), 30 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


