Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9136F335A
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 18:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjEAQDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 12:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjEAQDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 12:03:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2094.outbound.protection.outlook.com [40.107.92.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28849E61;
        Mon,  1 May 2023 09:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIdQphTOKXHuaMhN9WLAI3BeFg9VIuVMoKKhG88Y4iQnMgA/cUdGpXSfEf/r3aYcR8dRjHxcLBXDybyTnGQ/mu/096snaAzvVFX7efK4gTofVvLHtRn33BhmuDcKsZBN66IzGzKxcEZ51p6bmgVLzVXBL9nwnx3FwJH/kOSXia7gqWPH7RxOVMbGYLnLPBzKyk0wfzh98noT4ocyr8Ty69mQXngGSbCDgjWlNzin7b96NqITzHixUJEjRauIFHIjkzXKH1Ie6tU2gqsDxTbwd5RhUNgz86a0DkbenYqV1CmfAkQCT/Ba7hdFEutLb0chnfivrGkecmINCCYhlHa83g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+fBVb+tt4579p3JBCN9ZAleojjhMFaOEbtUgNuFI2UM=;
 b=T1kqJg8XIp+LQLQw7M7sA6QNX9CffFcsKyfOEcTUWiCBtHMwtC1FoO0BlfZUgRKXs4Ww7QsAqBBc1UJojw63tnmfItx8OKm1leXTL2ZYDChcaie182yjJdm5enBQaKgUh+uz3g6vxTANFFAc3w7sg4Lnuz0GxqLwh76NkTbqHd3TfY/9A5hHVE7xHEQhjpOdRLAOWBu0mAIELvlkdIB8nBGsVCf9uW9HIdkzWdIjVHKaApTPIHWuTJZO9PUgetlsCctk0iy7fVb6vXj6l10iBeLFu/HHnuWe2eFs/4TaSjpsTtzSPppBu4htIdbI5LatljLuA+4BMVrZMnur493e9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fBVb+tt4579p3JBCN9ZAleojjhMFaOEbtUgNuFI2UM=;
 b=Wx8YS3cNCIRDnD0mIp7nxElAWtFYUC2wwfFUxRm9jzsoD3E9TTM0oGYuZYFFgDD6e763JahkbtY3OmPFhaQ3ZsEaBQaxY0kK73dEYn5U5SBEcbaI6eu6kis880371R5ToC2b3ZY0GpKerCaQHrXmobvXAqXIIuhmEQb1pLgU5c0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6145.namprd13.prod.outlook.com (2603:10b6:806:339::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.28; Mon, 1 May
 2023 16:03:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 16:03:40 +0000
Date:   Mon, 1 May 2023 18:03:32 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 1/4] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <ZE/i1G1HTerZV4jk@corigine.com>
References: <20230424195402.516-1-jm@ti.com>
 <20230424195402.516-2-jm@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424195402.516-2-jm@ti.com>
X-ClientProxiedBy: AM8P251CA0026.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: cdfb0083-14d9-4b22-0168-08db4a5da108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXJlzhiK6QudGxx2fmkKopiQPlrl/o9AOMx9zm5GpKhmYAsRnvPiUzX0Xgm/4H5NchFFCdJkt3WBuAHdwDg2tfYaaxK8/FumT2LPASjEgSWuY7+u5UhlNNY5TZcWs1VCXHAJq2B485P6c+VhXd1gBmwZ7PKjkXJyxOrEMXzvjiCb26JJSdE9rRfzftGDuBGxo1yKU9fpLS6fGPRrO1E5XMW+8LjYcxSbiegRtDV29KOfSn76C+JqUhK1dSmVWeNEqPsToBCgTKGXNHa7LAqvDSImAkcFTCHbsL+CPth1mDokXV/iW54oWyS4jUVlOtD21/nbsBVIFeufD6SR0Lh5pUg1a4GC01FREjEsxc/RqgM4uxLdHQbuPGqBSxX9CNFVo/pzA2TPyPDkKxBWsSV1RXpzou7JRg6jrh7Yvfq0gDK64L+yvGtPwhOxtOXnm9RyxzGKwkt37JyXNUaeHEQQ85C7i0xP+4nRDDZEneVvb4+QqCkGKGGJP90VMa0VWe3nDShHWukLO6klU07ERP3fyNmCtd+NP4dfCC2C5JlsJRoDhCO79BNflltBLInEex58
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39830400003)(346002)(136003)(396003)(366004)(451199021)(2616005)(83380400001)(478600001)(186003)(4326008)(6916009)(54906003)(66946007)(66476007)(66556008)(6486002)(6666004)(6506007)(6512007)(316002)(44832011)(7416002)(8936002)(8676002)(5660300002)(41300700001)(2906002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mk9IFAFF4bG83Vo7MQc004WjpmNCD3ChoxKLg0thQdjwfyaaGw0s/Eb1daWN?=
 =?us-ascii?Q?0sYCjLHTzngKRM9wfCzYsrO9xV8LG73zj/j1yOf7wNH98UD5nwm68eROlbi2?=
 =?us-ascii?Q?NSXEQAPY2CZL88nVfnEmxMYmaQKFp3XnrZz9WWPdh3S3FLAmqMZbmRd6rJDm?=
 =?us-ascii?Q?HYZSUrYW9KXTvNTag9/0P/iE3fQcTcGTaTZvJyAEXZEVil+bA6TiUscDMTaN?=
 =?us-ascii?Q?PCgROl0mlnqRgebwFUEdqH1GDLJXkxHvLItwa842KtT2ctSKZ7JpdKeIaguv?=
 =?us-ascii?Q?xMH2jTQKaiPpke4WMSg8EBpv2lADyamhD42fl89Kv8ZbakbbZvbDS+SuYzjX?=
 =?us-ascii?Q?9SAluYv3VZDMU49zHENUhPAotGdCVXfo1TSVo3Aqx5rWpJDY/1MkTQHvSH4Z?=
 =?us-ascii?Q?wa3tQVzOezikLHibVZtyoRx/+OExiFbToCQtp9NKm/qfLHUN0hUkQo2cMCt4?=
 =?us-ascii?Q?y4xl1U/1ZULUVre2Uc4JD0dmkrY999DARvhs8JxW1muD2KXZO6sBA9QC1aOz?=
 =?us-ascii?Q?/YMAO4ZGKKeqfIrA4u4BsQBeelbzR8QFfUcD+aY7R/VdyggF/wkE9BwoMnX9?=
 =?us-ascii?Q?dqHf3230WnznA2datn9VtVUsiVvUqgxIHHllcta0DBSo+QS7BoHmCAt9wM63?=
 =?us-ascii?Q?hLZv7Pvz1gktYqVb5lnPZlREUD3yMZD9zm6vFkDpOnWwIaNH4fAClMEZX1aJ?=
 =?us-ascii?Q?JYe6pSaHv+lZwxMH2QNAaLRIS0mkZSuKEi6MOQlXla0qgI3Pk0WVqmi0bF+J?=
 =?us-ascii?Q?5KrPk/gBKrWPj40TQp0nXMUp45qZR+5N2ye7v5NpPywGWUMk6tXKP+eR5snd?=
 =?us-ascii?Q?t6a09qVtkJDmdieXYpjpiBgK93F7I57xq9QfHNXCbQpyL4qa5y+SibeogBeN?=
 =?us-ascii?Q?AOJ4l3IBtY4TDBH7f6zgcz40Ke8J2pP0zk4zAcYP6+PvoFoLOgrpw4qtZvKC?=
 =?us-ascii?Q?7WQDYalP9s9LY0KaPNzaS8zXcnJgh4c1bo8cllvAy/Sh9uRdTZ1ko8hUN1Cl?=
 =?us-ascii?Q?ap0tStbBjzEFVfPyj/cn2l41S0ykFYUBYN1b+2r4rYMuXr02/dh/U1IxVuVg?=
 =?us-ascii?Q?nKEZp5YND+vICD+kDGALBeI8MdNyRFoDmHqkHjQTBvXadcZRXEkwPLR10ORa?=
 =?us-ascii?Q?kWlFKeqmFM6U62mBdsRcUATdedmCdp0OyJ05kgqUCklJCEDtmm+YzzZTnZ30?=
 =?us-ascii?Q?sHniEYuyfV/IRkxJXFQd2Xx8Xi8Qgl5HFzZWpTt6pi1lLpyPkn/vTuciOmXZ?=
 =?us-ascii?Q?ql8bqPj2FCSCgSPP4ApUUVBqsb1hRKTPSzxOxL0+zetMQ1SQTqowS7AGVsJV?=
 =?us-ascii?Q?QhaL8ZVjBw2A+H+Wf0pdURfsakZ8HJt1tiZ9r6moCp/Huccp02zP1cP2w1Py?=
 =?us-ascii?Q?WyLQ+kZkejhkkq++e+pQcuOoIPirsI4A6yAonzJAk37gvu2iL9gS0HWMyz9o?=
 =?us-ascii?Q?BRbZd4ctXqBkPGelje6Xl5QdH86Z9gWq1KFd30w16zJQMPZR2pN5KI8eypCX?=
 =?us-ascii?Q?EDTNgSjFyPdI6hCD0fQ528W6MDY9HWJLQYB+n8AAm2XxuvrewcQCjoOxGjve?=
 =?us-ascii?Q?LwZ9etxqTi2wLj+X7Mp2qQoW/6qIgrqB4df2YYZXyn8N/t0P+WflOBfsMcrJ?=
 =?us-ascii?Q?lZANmsbHFxadl7FZ3i328HyP3c7n4XiT+5g1UMKvfpzvXvDVkt4a69L/JBIp?=
 =?us-ascii?Q?ckEwJQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfb0083-14d9-4b22-0168-08db4a5da108
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 16:03:39.9208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0guggQ5LAh5IJl1Giwpy0NQT5i2ep16rFXjTrzuJmd4091RnMe8HVMOBSYEL+6MS6MVI1jXaCJvpKJMqfb4Rc37VN2ZyRkm5ll/f5zx+dHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6145
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 02:53:59PM -0500, Judith Mendez wrote:
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found and
> poll-interval property is defined in device tree M_CAN node.
> 
> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
> Changelog:
> v2:
> 	1. Add poll-interval to MCAN class device to check if poll-interval propery is
> 	present in MCAN node, this enables timer polling method.
> 	2. Add 'polling' flag to MCAN class device to check if a device is using timer
> 	polling method
> 	3. Check if both timer polling and hardware interrupt are enabled for a MCAN
> 	device, default to hardware interrupt mode if both are enabled.
> 	4. Changed ms_to_ktime() to ns_to_ktime()
> 	5. Removed newlines, tabs, and restructure if/else section.
> 
>  drivers/net/can/m_can/m_can.c          | 30 ++++++++++++++++++++-----
>  drivers/net/can/m_can/m_can.h          |  5 +++++
>  drivers/net/can/m_can/m_can_platform.c | 31 ++++++++++++++++++++++++--
>  3 files changed, 59 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a5003435802b..33e094f88da1 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -23,6 +23,7 @@
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/hrtimer.h>
>  
>  #include "m_can.h"
>  
> @@ -1587,6 +1588,11 @@ static int m_can_close(struct net_device *dev)
>  	if (!cdev->is_peripheral)
>  		napi_disable(&cdev->napi);
>  
> +	if (cdev->polling) {
> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
> +		hrtimer_cancel(&cdev->hrtimer);
> +	}
> +
>  	m_can_stop(dev);
>  	m_can_clk_stop(cdev);
>  	free_irq(dev->irq, dev);
> @@ -1793,6 +1799,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>  	return NETDEV_TX_OK;
>  }
>  
> +enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)

Hi Judith,

This function seems to only be used in this file,
so it should be static.

> +{
> +	struct m_can_classdev *cdev =
> +		container_of(timer, struct m_can_classdev, hrtimer);
> +
> +	m_can_isr(0, cdev->net);
> +
> +	hrtimer_forward_now(timer, ms_to_ktime(1));
> +
> +	return HRTIMER_RESTART;
> +}
> +

...
