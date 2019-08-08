Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2261868F8
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403890AbfHHSm5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 14:42:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:15537 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732375AbfHHSm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 14:42:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 11:42:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="258799512"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga001.jf.intel.com with ESMTP; 08 Aug 2019 11:42:55 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 8 Aug 2019 11:42:55 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.30]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.82]) with mapi id 14.03.0439.000;
 Thu, 8 Aug 2019 11:42:55 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH v3 1/1] ixgbe: sync the first fragment unconditionally
Thread-Topic: [PATCH v3 1/1] ixgbe: sync the first fragment unconditionally
Thread-Index: AQHVTZ5IOEeUaPwZuEuqOf/M8/vBiqbxltMw
Date:   Thu, 8 Aug 2019 18:42:55 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40F4D7@ORSMSX104.amr.corp.intel.com>
References: <20190808040312.21719-1-firo.yang@suse.com>
In-Reply-To: <20190808040312.21719-1-firo.yang@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjMxNGEyYWUtMjc4OS00ZjU5LWE4ZjItOTg5ODZhOWFmMDliIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVzZYTVhFdGh0TktPY1laeUpoRDR6QTRxcU5WYmFGTzFXUTZsZ2pkdUhxaFcwdlE4WVA3bkNXSVlNQ2FNbnU4RyJ9
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
> Behalf Of Firo Yang
> Sent: Wednesday, August 7, 2019 9:04 PM
> To: netdev@vger.kernel.org
> Cc: maciejromanfijalkowski@gmail.com; Firo Yang <firo.yang@suse.com>;
> linux-kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> jian.w.wen@oracle.com; alexander.h.duyck@linux.intel.com;
> davem@davemloft.net
> Subject: [Intel-wired-lan] [PATCH v3 1/1] ixgbe: sync the first fragment
> unconditionally
> 
> In Xen environment, if Xen-swiotlb is enabled, ixgbe driver could possibly
> allocate a page, DMA memory buffer, for the first fragment which is not
> suitable for Xen-swiotlb to do DMA operations.
> Xen-swiotlb have to internally allocate another page for doing DMA
> operations. This mechanism requires syncing the data from the internal page
> to the page which ixgbe sends to upper network stack. However, since
> commit f3213d932173 ("ixgbe: Update driver to make use of DMA attributes
> in Rx path"), the unmap operation is performed with
> DMA_ATTR_SKIP_CPU_SYNC. As a result, the sync is not performed.
> Since the sync isn't performed, the upper network stack could receive a
> incomplete network packet. By incomplete, it means the linear data on the
> first fragment(between skb->head and skb->end) is invalid. So we have to
> copy the data from the internal xen-swiotlb page to the page which ixgbe
> sends to upper network stack through the sync operation.
> 
> More details from Alexander Duyck:
> Specifically since we are mapping the frame with
> DMA_ATTR_SKIP_CPU_SYNC we have to unmap with that as well. As a result
> a sync is not performed on an unmap and must be done manually as we
> skipped it for the first frag. As such we need to always sync before possibly
> performing a page unmap operation.
> 
> Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA attributes in
> Rx path")
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Signed-off-by: Firo Yang <firo.yang@suse.com>
> ---
> Changes from v2:
>  * Added details on the problem caused by skipping the sync.
>  * Added more explanation from Alexander Duyck.
> 
> Changes from v1:
>  * Imporved the patch description.
>  * Added Reviewed-by: and Fixes: as suggested by Alexander Duyck.
> 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


