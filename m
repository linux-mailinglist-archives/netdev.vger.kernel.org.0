Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3301256D4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfLRWfm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Dec 2019 17:35:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:37654 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfLRWfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 17:35:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 14:35:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="240942503"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga004.fm.intel.com with ESMTP; 18 Dec 2019 14:35:41 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Dec 2019 14:35:41 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Dec 2019 14:35:40 -0800
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 18 Dec 2019 14:35:40 -0800
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] iavf: remove current MAC address filter
 on VF reset
Thread-Topic: [Intel-wired-lan] [PATCH] iavf: remove current MAC address
 filter on VF reset
Thread-Index: AQHVtMX3NxmzdEVU1UaG8vQUI1l3fKfAfVHg
Date:   Wed, 18 Dec 2019 22:35:40 +0000
Message-ID: <0b5c9869aadd45f9b3643ab6b63704c9@intel.com>
References: <20191217102923.3274961-1-sassmann@kpanic.de>
In-Reply-To: <20191217102923.3274961-1-sassmann@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOWNjMjRiZWItZTE0MS00MDdiLWI4NmEtZDY0ZGY1NmNkNjRmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTnQrRUhqRXRxYml5Q1wvRFB4QTVscU0wVFlSR3NFaFBuY3U3dzdQdEFjcXBCUWh5YnhcL2loWXdmRXdJWk1BT1VwIn0=
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
> Sent: Tuesday, December 17, 2019 2:29 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; davem@davemloft.net; sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] iavf: remove current MAC address filter
> on VF reset
> 
> Currently MAC filters are not altered during a VF reset event. This may lead
> to a stale filter when an administratively set MAC is forced by the PF.
> 
> For an administratively set MAC the PF driver deletes the VFs filters,
> overwrites the VFs MAC address and triggers a VF reset. However the VF
> driver itself is not aware of the filter removal, which is what the VF reset is
> for.
> The VF reset queues all filters present in the VF driver to be re-added to the
> PF filter list (including the filter for the now stale VF MAC
> address) and triggers a VIRTCHNL_OP_GET_VF_RESOURCES event, which
> provides the new MAC address to the VF.
> 
> When this happens i40e will complain and reject the stale MAC filter, at least
> in the untrusted VF case.
> i40e 0000:08:00.0: Setting MAC 3c:fa:fa:fa:fa:01 on VF 0 iavf 0000:08:02.0:
> Reset warning received from the PF iavf 0000:08:02.0: Scheduling reset task
> i40e 0000:08:00.0: Bring down and up the VF interface to make this change
> effective.
> i40e 0000:08:00.0: VF attempting to override administratively set MAC
> address, bring down and up the VF interface to resume normal operation
> i40e 0000:08:00.0: VF 0 failed opcode 10, retval: -1 iavf 0000:08:02.0: Failed to
> add MAC filter, error IAVF_ERR_NVM
> 
> To avoid re-adding the stale MAC filter it needs to be removed from the VF
> driver's filter list before queuing the existing filters. Then during the
> VIRTCHNL_OP_GET_VF_RESOURCES event the correct filter needs to be
> added again, at which point the MAC address has been updated.
> 
> As a bonus this change makes bringing the VF down and up again superfluous
> for the administratively set MAC case.
> 
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h          |  2 ++
>  drivers/net/ethernet/intel/iavf/iavf_main.c     | 17 +++++++++++++----
>  drivers/net/ethernet/intel/iavf/iavf_virtchnl.c |  3 +++
>  3 files changed, 18 insertions(+), 4 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


