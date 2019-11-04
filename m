Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C056CEF154
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 00:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387394AbfKDXoB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 Nov 2019 18:44:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:24720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729688AbfKDXoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 18:44:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 15:44:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="213701601"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga002.jf.intel.com with ESMTP; 04 Nov 2019 15:44:00 -0800
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 4 Nov 2019 15:44:00 -0800
Received: from orsmsx113.amr.corp.intel.com ([169.254.9.28]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.61]) with mapi id 14.03.0439.000;
 Mon, 4 Nov 2019 15:44:00 -0800
From:   "Creeley, Brett" <brett.creeley@intel.com>
To:     Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     Arkady Gilinsky <arcadyg@gmail.com>
Subject: RE: [PATCH net] i40e/iavf: Fix msg interface between VF and PF
Thread-Topic: [PATCH net] i40e/iavf: Fix msg interface between VF and PF
Thread-Index: AQHVktE9LXQEe1tn8E2yMWCX6YmauKd7neLQ
Date:   Mon, 4 Nov 2019 23:43:59 +0000
Message-ID: <3508A0C5D531054DBDD98909F6FA64FA11B3936D@ORSMSX113.amr.corp.intel.com>
References: <1572845537.13810.225.camel@harmonicinc.com>
In-Reply-To: <1572845537.13810.225.camel@harmonicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODdmYzMzOTMtMTRlYy00ZGI5LWE0MTQtZjVkMmViMDNlODk2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiREdKTUNPTFczbVUrTUcyZ09cL2JWSGJGNkM1ejcrWkhrOU9NdjV0RndQalhTcllEUndydmNtMGRNRXhwVUsyU2wifQ==
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On Behalf Of Arkady Gilinsky
> Sent: Sunday, November 3, 2019 9:32 PM
> To: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: Arkady Gilinsky <arcadyg@gmail.com>
> Subject: [PATCH net] i40e/iavf: Fix msg interface between VF and PF
> 
> From af5ab2aaa51882bb7111b026882fe217ed81c15b Mon Sep 17 00:00:00 2001
> From: Arkady Gilinsky <arkady.gilinsky@harmonicinc
> .com>
> Date: Sun, 3 Nov 2019 20:37:21 +0200
> Subject: [PATCH net] i40e/iavf: Fix msg interface between VF and PF
> 
>  * The original issue was that iavf driver passing TX/RX queues
>    as bitmap in iavf_disable_queues and the i40e driver
>    interprets this message as an absolute number in
>    i40e_vc_disable_queues_msg, so the validation in the
>    latter function always fail.

The VIRTCHNL interface expects the tx_queues and rx_queues to be sent as
a bitmap so this should/can not be changed.

I think something like the following would be better becase the change is
completely contained inside the i40e driver and it should completely
address the issue you are seeing. Of course, this would have to be
in both the enable and disable queue flow. Also, with this change it might
be best to check and make sure the sizeof(vqs->[r|t]x_queues) equal
sizeof(u32) in case those members ever change from u32 to u64, which
will cause this check to always fail.

static bool i40e_vc_verify_vqs_bitmaps(struct virtchnl_queue_select *vqs)
{
	/* this will catch any changes made to the virtchnl_queue_select bitmap */
	if (sizeof(vqs->rx_queues) != sizeof(u32) ||
	     sizeof(vqs->tx_queues) != sizeof(u32))
		return false;

	if ((vqs->rx_queues == 0 && vqs->tx_queues == 0) ||
	      hweight32(vqs->rx_queues) > I40E_MAX_VF_QUEUES ||
	      hweight32(vqs->tx_queues) > I40E_MAX_VF_QUEUES)
		return false;

	return true;
}

if (i40e_vc_verify_vqs_bitmaps(vqs)) {
	aq_ret  = I40E_ERR_PARAM;
	goto error_param;
}

>    This commit reorganize the msg interface between i40e and iavf
>    between the iavf_disable_queues and i40e_vc_disable_queues_msg
>    functions (also for iavf_enable_queues and i40e_vc_enable_queues_msg).
>    Now both drivers operate with number of queues instead of
>    bitmap. Also the commit introduces range check in
>    i40e_vc_enable_queues_msg function.
> 
> Signed-off-by: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 23 ++++++++++++++++------
>  drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  6 ++++--
>  2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index 3d2440838822..c650eb91982a 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -2352,13 +2352,22 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf *vf, u8 *msg)
>  		goto error_param;
>  	}
> 
> -	/* Use the queue bit map sent by the VF */
> -	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx], vqs->rx_queues,
> +	if ((vqs->rx_queues == 0 && vqs->tx_queues == 0) ||
> +	    vqs->rx_queues > I40E_MAX_VF_QUEUES ||
> +	    vqs->tx_queues > I40E_MAX_VF_QUEUES) {
> +		aq_ret = I40E_ERR_PARAM;
> +		goto error_param;
> +	}
> +
> +	/* Build the queue bit map from value sent by the VF */
> +	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx],
> +				  BIT(vqs->rx_queues) - 1,
>  				  true)) {
>  		aq_ret = I40E_ERR_TIMEOUT;
>  		goto error_param;
>  	}
> -	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx], vqs->tx_queues,
> +	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx],
> +				  BIT(vqs->tx_queues) - 1,
>  				  true)) {
>  		aq_ret = I40E_ERR_TIMEOUT;
>  		goto error_param;
> @@ -2416,13 +2425,15 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
>  		goto error_param;
>  	}
> 
> -	/* Use the queue bit map sent by the VF */
> -	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx], vqs->tx_queues,
> +	/* Build the queue bit map from value sent by the VF */
> +	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx],
> +				  BIT(vqs->tx_queues) - 1,
>  				  false)) {
>  		aq_ret = I40E_ERR_TIMEOUT;
>  		goto error_param;
>  	}
> -	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx], vqs->rx_queues,
> +	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx],
> +				  BIT(vqs->rx_queues) - 1,
>  				  false)) {
>  		aq_ret = I40E_ERR_TIMEOUT;
>  		goto error_param;
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
> index c46770eba320..271f144bf05b 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
> @@ -308,7 +308,8 @@ void iavf_enable_queues(struct iavf_adapter *adapter)
>  	}
>  	adapter->current_op = VIRTCHNL_OP_ENABLE_QUEUES;
>  	vqs.vsi_id = adapter->vsi_res->vsi_id;
> -	vqs.tx_queues = BIT(adapter->num_active_queues) - 1;
> +	/* Send the queues number to PF */
> +	vqs.tx_queues = adapter->num_active_queues;
>  	vqs.rx_queues = vqs.tx_queues;
>  	adapter->aq_required &= ~IAVF_FLAG_AQ_ENABLE_QUEUES;
>  	iavf_send_pf_msg(adapter, VIRTCHNL_OP_ENABLE_QUEUES,
> @@ -333,7 +334,8 @@ void iavf_disable_queues(struct iavf_adapter *adapter)
>  	}
>  	adapter->current_op = VIRTCHNL_OP_DISABLE_QUEUES;
>  	vqs.vsi_id = adapter->vsi_res->vsi_id;
> -	vqs.tx_queues = BIT(adapter->num_active_queues) - 1;
> +	/* Send the queues number to PF */
> +	vqs.tx_queues = adapter->num_active_queues;
>  	vqs.rx_queues = vqs.tx_queues;
>  	adapter->aq_required &= ~IAVF_FLAG_AQ_DISABLE_QUEUES;
>  	iavf_send_pf_msg(adapter, VIRTCHNL_OP_DISABLE_QUEUES,
> --
> 2.11.0

