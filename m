Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF4E2D30EE
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 18:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgLHRZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 12:25:01 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:42004 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728510AbgLHRZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 12:25:01 -0500
Received: from pps.filterd (m0170398.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B8HIRSo025200;
        Tue, 8 Dec 2020 12:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=smtpout1;
 bh=6pwVA+zAX3guBHyruQ0OaiSMpzrQ0K5rhts4w8FvW2I=;
 b=TrMOLDOIl8QAV70dNBkGH7FZr3DXx+PLluUZpYe4+Y3p1cdTfxLwz1qJgwU6e6xZcixI
 slLkQPXV4ITxhV4BbKBgr3yUeAHSSmyygw2hPWoPmQHy9cfB/1FhFoplwyyRvu/BzET+
 GIIYJkadJDZ+X7NwGuHAVyMHLF+0TAK8AT4g0PCIdG3dBGf4p02NDankVkjCBGCMy+l1
 7+hWFgbjCgwjf9VS5dHmOY57KFzs8smFLenzkubKK9+PQAnKIyyq73UVH5cyj3AP9Kzc
 yztUq9Wg0rINElvH3lpaRAQDMP6rKaKOfVXbvmDpYsvMdzy45yXj8p86HK6ViRevsvoT qQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 3587cdk8gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 12:24:20 -0500
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B8HHTDf158878;
        Tue, 8 Dec 2020 12:24:19 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 35adafhesv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 12:24:18 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,403,1599541200"; 
   d="scan'208";a="1017279786"
Subject: Re: [PATCH v3 1/7] e1000e: fix S0ix flow to allow S0i3.2 subset entry
To:     Mario Limonciello <mario.limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com,
        Vitaly Lifshits <vitaly.lifshits@intel.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <20201204200920.133780-2-mario.limonciello@dell.com>
From:   Mario Limonciello <Mario.Limonciello@dell.com>
Organization: Dell Inc.
Message-ID: <354075ae-f605-eb01-4cf9-a66e4eb7b192@dell.com>
Date:   Tue, 8 Dec 2020 11:24:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201204200920.133780-2-mario.limonciello@dell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_14:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080106
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/4/20 2:09 PM, Mario Limonciello wrote:
> From: Vitaly Lifshits <vitaly.lifshits@intel.com>
>
> Changed a configuration in the flows to align with
> architecture requirements to achieve S0i3.2 substate.
>
> Also fixed a typo in the previous commit 632fbd5eb5b0
> ("e1000e: fix S0ix flows for cable connected case").
>
> Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

I realize that the series is still under discussion, but I intentionally 
moved this
patch to the front of the series so it can be pulled in even if the 
others are still
discussed.

@David Miller:
This particular patch is more important than the rest.  It actually 
fixes issues
on the non-ME i219V as well.  Can this one be queued up and we can keep
discussing the rest?

> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index b30f00891c03..128ab6898070 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6475,13 +6475,13 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>   
>   	/* Ungate PGCB clock */
>   	mac_data = er32(FEXTNVM9);
> -	mac_data |= BIT(28);
> +	mac_data &= ~BIT(28);
>   	ew32(FEXTNVM9, mac_data);
>   
>   	/* Enable K1 off to enable mPHY Power Gating */
>   	mac_data = er32(FEXTNVM6);
>   	mac_data |= BIT(31);
> -	ew32(FEXTNVM12, mac_data);
> +	ew32(FEXTNVM6, mac_data);
>   
>   	/* Enable mPHY power gating for any link and speed */
>   	mac_data = er32(FEXTNVM8);
> @@ -6525,11 +6525,11 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>   	/* Disable K1 off */
>   	mac_data = er32(FEXTNVM6);
>   	mac_data &= ~BIT(31);
> -	ew32(FEXTNVM12, mac_data);
> +	ew32(FEXTNVM6, mac_data);
>   
>   	/* Disable Ungate PGCB clock */
>   	mac_data = er32(FEXTNVM9);
> -	mac_data &= ~BIT(28);
> +	mac_data |= BIT(28);
>   	ew32(FEXTNVM9, mac_data);
>   
>   	/* Cancel not waking from dynamic
-- 
*Mario Limonciello*
*Dell*| CPG Software Engineering
*office*+1 512 723 0582
