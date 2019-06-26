Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3FCD57448
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 00:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfFZW0O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jun 2019 18:26:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:2978 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfFZW0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 18:26:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 15:26:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,421,1557212400"; 
   d="scan'208";a="164503997"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga003.jf.intel.com with ESMTP; 26 Jun 2019 15:26:13 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 26 Jun 2019 15:26:12 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.70]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.236]) with mapi id 14.03.0439.000;
 Wed, 26 Jun 2019 15:26:12 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][net-next] iavf: fix dereference of
 null rx_buffer pointer
Thread-Topic: [Intel-wired-lan] [PATCH][net-next] iavf: fix dereference of
 null rx_buffer pointer
Thread-Index: AQHVJqupVXnzcA+L3kOQDxvwkDnUOqaujuOg
Date:   Wed, 26 Jun 2019 22:26:11 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D3FB501@ORSMSX104.amr.corp.intel.com>
References: <20190619143044.10259-1-colin.king@canonical.com>
In-Reply-To: <20190619143044.10259-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGIxZTkyNjktNzU5OS00Y2QxLTgzZWMtOTg0ZTczNjMzMzlmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicTZrSGFqK1VITGdcL2VaZjhwS2pJaHo1WTF3aFRLQSt6VGVJMTFtMHhaaGpuXC8xQTR6WGk1UXFLeERVV0hrMzBMIn0=
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
> Behalf Of Colin King
> Sent: Wednesday, June 19, 2019 7:31 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S . Miller
> <davem@davemloft.net>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH][net-next] iavf: fix dereference of null
> rx_buffer pointer
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> A recent commit efa14c3985828d ("iavf: allow null RX descriptors") added a
> null pointer sanity check on rx_buffer, however, rx_buffer is being
> dereferenced before that check, which implies a null pointer dereference
> bug can potentially occur.  Fix this by only dereferencing rx_buffer until after
> the null pointer check.
> 
> Addresses-Coverity: ("Dereference before null check")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


