Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985606D378C
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 13:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDBLS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 07:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDBLS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 07:18:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2117.outbound.protection.outlook.com [40.107.94.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA27C66F
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 04:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H000Q1AwUhlb8tjSdJUWtrKpiv6yQ9On+W3zIbxzW3MwIYJ7xXhLzNgzI89BmCehxUtvHdclBCknycV91h+APQ9yXG+tKt59kbx5fsOuQiCI+9ja1B9eNlHt8zXBLJxDYJsD6MUMUEmiXuxO/k9sH2bZRvtMocvyMIe2zMdnCTjGZ2XOb4Cqyp+FGjKBqNr4t0k9NAIR9o9imAb7EEyk23Mi43Munw84EBABp696NX04YvZ4MbgcgVqh6MRfJsKY7WvJKcBYHbMFi5W4DLdN01M+T+Z9PLC8M23VUNC3fKtl+Ydnz1ATS7JqzivpvrmqRlJglwazWaZLbyKPn2c1Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkFxkYHzmVsI5sqYJRH/Iubhaj8gaZEL5o5b6xYnXLU=;
 b=dmrqXVs28ceKK4UlxiyElthjDoXDe+LllYDZ9tnT3Za/Yofuui5mRzFxPVGKx0jrdvNKoRwmi9kkjY6AKEe+RbeyY19X5R0NkOgyEyWm81XEDz1rNuvHRRnyZP3ml0rk1SjWH7yot0a/oo1Lx4v1vwlvcfYvcNxM+5cVZSCvMncRkC4Yl6JeGeR+ZxRGJx5iISTXuzgVBHY1+S7Ypc2CHvX5sFgh/a/Khg5u3NhdLcbMpgafV9mmpxMN0NdTKEfO4yfN/q7Wu2alrhG5B/pzfeVcrgnavBa2Rxyqc6nJuaFBhnkCc8uSaIJgVVTm/Xx4S7LW5V+V2Gt8fu4M2aPntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkFxkYHzmVsI5sqYJRH/Iubhaj8gaZEL5o5b6xYnXLU=;
 b=GylOuu+bShXTD3EqfeilakScVT+CxearMF0svglRVIlVHV/mU/86F8HtHzanrpRta3LFAQ1K+hgf8jUNKWPuW9R2d3zdI9KDkMRISvdRhuOLzfcTk2Rh/IUbaEQ/TNt0LeKufw8Dm+DUcilFBW+NcKF/oztIHzbnS7dYyy6x53Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3635.namprd13.prod.outlook.com (2603:10b6:a03:218::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Sun, 2 Apr
 2023 11:18:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sun, 2 Apr 2023
 11:18:21 +0000
Date:   Sun, 2 Apr 2023 13:18:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Subject: Re: [PATCH net-next 2/4] ice: sleep, don't busy-wait, for
 sq_cmd_timeout
Message-ID: <ZClkczf8EvDsPidF@corigine.com>
References: <20230401172659.38508-1-mschmidt@redhat.com>
 <20230401172659.38508-3-mschmidt@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230401172659.38508-3-mschmidt@redhat.com>
X-ClientProxiedBy: AM0PR01CA0170.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3635:EE_
X-MS-Office365-Filtering-Correlation-Id: 1385c298-75a2-4e45-9deb-08db336bf727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4+6w9E1pqhY+1KYCcqHcDWcWHTWr32j8mwc48jEcFCvgsl9MQY37fHoNriL475SQ2Rz3gZoJGBR2HcbjiDHT10uHFt54FBNhtPjsQLmjOGGh4MgmThDSI2AhZCcFZ4yBUCDhDMtDDHwD98cKbaCMNgVRA3ShIB6xHA8lb8WtHm+J8XTqTmOqkm57lHZGvxY6bjEFaAZcm2Zqoq/Po9sItuEtdNTKtoffKUPQc3CItF+mHHhloJgWgzt/VLAXkYGw1yc4HZ50KNprH8zdWJBHsfQYPazcXm3Jle3dFnehwZak5AENPYM9xzm0c1ST8/ThTHvggZKNaOhSrveSSL81Zyv4iMhWRGsttSuPa2nnKoa9qgYA9FGxcFS5P21J+Aac4QbZPKB5xjI14xGNZua/QhoEg7OVQOG24uvHPxXWNQkdxalywTc9cGYYhRuJEZcngnIfNMWYR/VBzEoUynbGDsHS8AZyiOTicX6UOc4dax8r2GZW5TYT5KDPHVFmeKE3YF5/1adJbmjqDegfbHDjvsGPtM7MAuX28gQ9f+XMwVWt14TQtfG3IBw4t61ymLuAW5eK52CZFDHoDnQ7ZffS7Wtjyyj4Qc3ww/O0ZffxS8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(366004)(39830400003)(451199021)(41300700001)(8676002)(6916009)(4326008)(66476007)(66946007)(66556008)(478600001)(316002)(54906003)(8936002)(5660300002)(38100700002)(186003)(83380400001)(2616005)(44832011)(6666004)(6486002)(6512007)(6506007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekE5V0FGTExOcDFUR2szcC9TYTNuOFBad1VoZW1rc0hrdGNuYmhsMFVGMjA4?=
 =?utf-8?B?SWc0QVpKTjZ1VWNIRmQzYjVFQlpGcmZCN2FHbldWNzdCSit1eCt4R25DY01r?=
 =?utf-8?B?T29LQUZRelFMbmJXY0NPVjRnWHA5Tys3aFVINVVVaG9iL3A2WFAzRUl0RjJr?=
 =?utf-8?B?WDN3bDRySW9iK1M2RDhKZGF0WkI4RW8vZVFEU2tWN09Za2pyakNhWWhyZUEv?=
 =?utf-8?B?T0lUMERZSC9Gc3BtamZVUng1YVR6U1BWVmpSZE11eWQxVVpkcFJUQ2pickd0?=
 =?utf-8?B?SGRRTTgzTDdkVjVLRXU3Q01OTm5LWUlwVXE1MHd2c0dyTzZJOWpjbUEza1hp?=
 =?utf-8?B?MW45NXpveWg2OUMyTTQ2UDlzWkNBUC83Smg2NUJ2NVNxaTZwMEVzUTNPVnox?=
 =?utf-8?B?c3dxVERJUk12M2Y2aml1RlBReXdiajNQVXBwMGpyS1ExUkJiY0FmNmg2WkRo?=
 =?utf-8?B?V20zemM4ZTlKeGIwaUdEUGJoOFJvMXdRUFB5QWUxUEVMbGVnT0ZGRGk5ZFZC?=
 =?utf-8?B?dWU5MUVLVlZtVGlZWFRMR2RUb2l2eDBaL2RlZFNYV2xkSlNJWVNzTWxIMHhT?=
 =?utf-8?B?N2U2TGFMam0vTWEybDRDTG5MLzdndHBqZm5rUWV0RFhac2ZRa3BhR1JTRkVp?=
 =?utf-8?B?dWU0eFhNa3FtbmwvK0l1amtKK244Y21NTlhNV0ZoelA1aFdJTTI2Q0wwS1VK?=
 =?utf-8?B?SjRNQ3p3NW41OU10S2RseU9qV1NkeWVqQTR1NGN6SFNMdDE1Y3VoY1NNeUla?=
 =?utf-8?B?YTBsUmo4UEF6cHpSWGFnQlp1TkV2VzZCeVlkSWp0ZXljR25XaHg0Uko3MTNK?=
 =?utf-8?B?ZnVxUTlyak9tVThCQU1rWXlwMm84dE5RVlBYWDRkVjBiYlhVaThLSVA3dHdP?=
 =?utf-8?B?NUN2WVBFWXp5U0hLWGFCMkowWmMxSlNhcmFSaGMvVkM0V2NLNElwdFlKZFZm?=
 =?utf-8?B?UERuVjYwV1ZJeE8rU1pZUTA0WjMrc3JKSjd0QTRIMCt2ZkJNZ3hVcWxTaldQ?=
 =?utf-8?B?cHh0WDRoUmc5L2xESnFCUmMvMkZJay95MDcrdEV5WDZINkZ6bHpMMmhRekts?=
 =?utf-8?B?LzlpZkZBVDN2VXBkNnZESVJyVGp3OHVnTXZ2T2plTUlnTEhxR21acEZFQXVl?=
 =?utf-8?B?Q200QTRJK2FwMVZudzRpR1VIM1lpUEM3YXNrQWlBL2Uwc1ZyanYvL3R3dGx4?=
 =?utf-8?B?SERDb3RiQ2JiUnMxSjBUaW5pWW00NHZrVEQrcUxsQVFIOGt6QzhZSXhKTjBu?=
 =?utf-8?B?WFBjOUpoUExBcndPa0VNSUlKTUpvYUtJV2dpMjhVMWFiakJLLzNLM0ZGQmhX?=
 =?utf-8?B?dnQ1Y1VwWEZXN2JSOHFrQ09mRVd3U1ZyZXg2MFhVcnFGaHFMdG5xeVM3dGxv?=
 =?utf-8?B?aXRoNTVEdEpTVWpqOHJTbzV5ODlqQUVYS0VWMklEcEh3ZUlRdWMwdmNEaHds?=
 =?utf-8?B?dm5CNUNvN1U2RVFmMTJMZUFNL1pZN2JrcU9obngwWFNEbWVOWU5IellxY1l2?=
 =?utf-8?B?REZnNFptYkcwM2g2RzYxemM4aVd6MENrbzV4K1ZrYzh1QmdSZ2RsNzVOeFNI?=
 =?utf-8?B?VUZxczkzYUozNEplUnhkL2xwR1NCMkNsclR1U2FhRkRaaVRBck5laTRnNjc1?=
 =?utf-8?B?M0RJU2pwcy9YbEU4aENHbDN4T0RGMXVNZmp4dnd4Tk9WVXE5bG9HZm9zd2NK?=
 =?utf-8?B?K0NDalpIU2lyZjlLbVFOazFSbi95b0EvZ1I3citMWDg2TkMwWmw2aHJjd3h2?=
 =?utf-8?B?MkxKd01CaGo1TXltNDRKU0taR0tnSXhEd2pGL29LQ2FDLzJ2Q1J2YU96OXpu?=
 =?utf-8?B?UUNVTW5TcUpld3dkTjA1VDM1SWNxbVE5ZG5pSDVhOHRwREIrNFhvMTFnZDlz?=
 =?utf-8?B?ZlVHR3VyOUlRK0FXLzhlVEJTc2c1eHh5eit2V294UFNidkhqeG5Qeng0ZFcw?=
 =?utf-8?B?VG9rTjFnUlZzY28vdXJuQWdVL3ZVcEE1Z0pwdXFxOXkyOFE1cXZsTGNXR2c2?=
 =?utf-8?B?TVhVU2hQbVZDRVE3a1ZjelNCellYMUNwRWJTek5ueExQVmRib0JVa2JLbUhW?=
 =?utf-8?B?MTIrdmt0eWx2VnFDaTlNNmZhWXFVdUI5MGR4QklWck0ydTNrNFVncG1IM3Zs?=
 =?utf-8?B?ZWI0NS8wbHdBcGZtRkcxaDVaNTJsMjZYYUpKWVVXamtLT0tUaHd5MENIZGhW?=
 =?utf-8?B?UlhpZUxRYVhLTElXeEljUE9hV0RaK0tpUFhFb2Fma1BYMGZvMUo4MC9ublpr?=
 =?utf-8?B?QXgyN05WT1NVNnJDVW8yVU43OVNnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1385c298-75a2-4e45-9deb-08db336bf727
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 11:18:21.1085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUYuNcmILncwYkvGIZAeOl2krTnM5+2lnVsI/WLm0wxXVrkXsj9So82jZC0xL/evIRqUItQWR/VSbPcRJXcOU6pARekUp/fvt9gnN1zaVOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3635
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 07:26:57PM +0200, Michal Schmidt wrote:
> The driver polls for ice_sq_done() with a 100 µs period for up to 1 s
> and it uses udelay to do that.
> 
> Let's use usleep_range instead. We know sleeping is allowed here,
> because we're holding a mutex (cq->sq_lock). To preserve the total
> max waiting time, measure cq->sq_cmd_timeout in jiffies.
> 
> The sq_cmd_timeout is referenced also in ice_release_res(), but there
> the polling period is 1 ms (i.e. 10 times longer). Since the timeout
> was expressed in terms of the number of loops, the total timeout in this
> function is 10 s. I do not know if this is intentional. This patch keeps
> it.
> 
> The patch lowers the CPU usage of the ice-gnss-<dev_name> kernel thread
> on my system from ~8 % to less than 1 %.
> I saw a report of high CPU usage with ptp4l where the busy-waiting in
> ice_sq_send_cmd dominated the profile. The patch should help with that.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_common.c   | 14 +++++++-------
>  drivers/net/ethernet/intel/ice/ice_controlq.c |  9 +++++----
>  drivers/net/ethernet/intel/ice/ice_controlq.h |  2 +-
>  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> index c2fda4fa4188..14cffe49fa8c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -1992,19 +1992,19 @@ ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
>   */
>  void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
>  {
> -	u32 total_delay = 0;
> +	unsigned long timeout;
>  	int status;
>  
> -	status = ice_aq_release_res(hw, res, 0, NULL);
> -
>  	/* there are some rare cases when trying to release the resource
>  	 * results in an admin queue timeout, so handle them correctly
>  	 */
> -	while ((status == -EIO) && (total_delay < hw->adminq.sq_cmd_timeout)) {
> -		mdelay(1);
> +	timeout = jiffies + 10 * hw->adminq.sq_cmd_timeout;

Not needed for this series. But it occurs to me that a clean-up would be to
use ICE_CTL_Q_SQ_CMD_TIMEOUT directly and remove the sq_cmd_timeout field,
as it seems to be only set to that constant.

> +	do {
>  		status = ice_aq_release_res(hw, res, 0, NULL);
> -		total_delay++;
> -	}
> +		if (status != -EIO)
> +			break;
> +		usleep_range(1000, 2000);
> +	} while (time_before(jiffies, timeout));
>  }
>  
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
> index 6bcfee295991..10125e8aa555 100644
> --- a/drivers/net/ethernet/intel/ice/ice_controlq.c
> +++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
> @@ -967,7 +967,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
>  	struct ice_aq_desc *desc_on_ring;
>  	bool cmd_completed = false;
>  	struct ice_sq_cd *details;
> -	u32 total_delay = 0;
> +	unsigned long timeout;
>  	int status = 0;
>  	u16 retval = 0;
>  	u32 val = 0;
> @@ -1060,13 +1060,14 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
>  		cq->sq.next_to_use = 0;
>  	wr32(hw, cq->sq.tail, cq->sq.next_to_use);
>  
> +	timeout = jiffies + cq->sq_cmd_timeout;
>  	do {
>  		if (ice_sq_done(hw, cq))
>  			break;
>  
> -		udelay(ICE_CTL_Q_SQ_CMD_USEC);
> -		total_delay++;
> -	} while (total_delay < cq->sq_cmd_timeout);
> +		usleep_range(ICE_CTL_Q_SQ_CMD_USEC,
> +			     ICE_CTL_Q_SQ_CMD_USEC * 3 / 2);
> +	} while (time_before(jiffies, timeout));
>  
>  	/* if ready, copy the desc back to temp */
>  	if (ice_sq_done(hw, cq)) {
> diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
> index c07e9cc9fc6e..f2d3b115ae0b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_controlq.h
> +++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
> @@ -34,7 +34,7 @@ enum ice_ctl_q {
>  };
>  
>  /* Control Queue timeout settings - max delay 1s */
> -#define ICE_CTL_Q_SQ_CMD_TIMEOUT	10000 /* Count 10000 times */
> +#define ICE_CTL_Q_SQ_CMD_TIMEOUT	HZ    /* Wait max 1s */
>  #define ICE_CTL_Q_SQ_CMD_USEC		100   /* Check every 100usec */
>  #define ICE_CTL_Q_ADMIN_INIT_TIMEOUT	10    /* Count 10 times */
>  #define ICE_CTL_Q_ADMIN_INIT_MSEC	100   /* Check every 100msec */
> -- 
> 2.39.2
> 
