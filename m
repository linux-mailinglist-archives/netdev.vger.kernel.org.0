Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BCD6BCC06
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjCPKHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCPKHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:07:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C631811EA0;
        Thu, 16 Mar 2023 03:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6IeZzH1jv3h0iCcdl37+vXAOU6pXlpWxYYmPQ0O++sSls5cUVnIEaOUAmmAO62XawnkU42cyuV2lsd8RuXHsf7T8+8kvNzNAi8KmXO/hsyxDwYC7THoDnRFyMD6gMuSnpLCbwY0GG60WF0sXrTZEc32xGtq+XO9b5r+dppLjdak7shVPbjvvezZeUiR0H7oS9OTr1fLWUsamsR2MI8bHTQAhoc573KyapxVaVNyiSGC8WwVr2KVqUVLMUK40q1NP/u2IGYCoR3XchEgwGinihA4lg1/pNBwPOr8HTh0whUAyHZXDVMJWbhcFqRDpijnbiktlPNHKG5b16KR0Rfrcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzbDDyhUpcr8fPWOgbo3D67B9+01dAm2maXyQ5F8RyQ=;
 b=hYB5bnnxv5J5XG5LZZvrSAgZmNOqCuv76OVkeYFJmfota/28IODOtlBpaNOPP1T45wVZfS4/VR8FVxDVcyryyeDl6yFVq8IU44zaPFOFqHmrJkaNby/CgS3WJbvPYpavxvheiWvu9eH4yCAz9+e96Kz24oVfMv8ceW5bz9+aBuOuTMhZJ0g4T5W74W0p8ow7EuXrdzlhj7jibrZm+1UZLWJs34gL1LSwuXLxy2RHkmppU+W5+EkJbm2dQujQMcSY283X5czaunruQP3aYeCt6oaWIpZLVzkYY18cJ88V7LFrgHuZrxN8ucY50ldXYBaychtqRvLrr4ojV95S7clvZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzbDDyhUpcr8fPWOgbo3D67B9+01dAm2maXyQ5F8RyQ=;
 b=o6u4cOoThUf0b0c9iZFf6ncePAa0aBXyrlWvnjxSThTJvetqoBXwSPZcXma2KKZEY7XJfgkXln4ed/EZmDMK5Xd6eCD42iz3WJ+MKmGE/TZbihKT48wr/PVHIxF7oydeHIFAU5NjyiGG7iBKYH6rKVQX2ZzzeoWNkBFYc/Q6eX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6279.namprd13.prod.outlook.com (2603:10b6:806:2e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 10:07:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 10:07:04 +0000
Date:   Thu, 16 Mar 2023 11:06:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/16] can: m_can: Add tx coalescing ethtool support
Message-ID: <ZBLqQmj4FoMAsNsh@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-11-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-11-msp@baylibre.com>
X-ClientProxiedBy: AS4P189CA0015.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: e4d14a95-f102-44a8-737f-08db26063110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/Z76vmD1opMeI1OAsCtLJUJVdDsOB1rD5npMsACCwaKEbJalLTzl4rvzThic6HLx/8Q4pRN8iNFL7XAMPY0RcQg/cNYMutO4qeIjNLgaFopxJKGKqTVZSiqdYaHADkgpyFgOUqopZP0uvkaEunXvWELPWGWAha8u0DsOB833oa76+1v5ayqYnQ73fE7Zt/JxA7P1WJfwrlOqZx6A9q1144qII35VItqV9exvEfAC6xV4fvyDeqFIRBiPVwvfF+m58Qm6a2Xdv2dJT2PV/NC2sRJXdhHX5MGQSnWjZcJjMgDyE9h7YYwp45xNpmdIJRsdNav8nfPUwpSoKl98RmVTO0o/vLFS9Le96H/refwQymsIBMr9J5LxPoYp1IQ3PjPpphrEAZSrLlw7V5qz1YbCkjSMWc46IbM2FsDGYg1nOGCAp/9+e5sH2KYw6Z4P307SfpZ1BGtv6h2QhaLgZAbFT6mCrdZnPavHwXSih+ba8nMkH7O2eTUc5UhI5fMn7YYkG/vEMunraOd1imkoPNz9D72JwVPy1cDtvM++yN+jV03UTDeuMokIlZXdg7FrEL9Uh62Pxbyg8xxp2aoxDgqf3xEzGonfWjsmHzPSuK3A+zEXThAcqfNX6XanRSgqOF4XQoryT4ERUd668bB+OifNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(366004)(39840400004)(136003)(451199018)(54906003)(316002)(83380400001)(478600001)(38100700002)(86362001)(2616005)(6666004)(186003)(6506007)(6512007)(6486002)(36756003)(5660300002)(6916009)(66946007)(8676002)(66476007)(66556008)(44832011)(41300700001)(8936002)(2906002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQV2/QKJVrAbuXi8pEL/pVUvN6l8UbTIhCc1UcvhvEH2s/E3aLPAzqJNUD2f?=
 =?us-ascii?Q?SqcM3EzrIHG/rNk0xCV0VcVbtaWJpY4lZ3M4wqzaEaEVBvo1j+1m3NUMqbdX?=
 =?us-ascii?Q?HQlzbRasjMwDqBwnq4WUoMkn6YCi2aIT/bVX8xcjvm/0Y/eea3GGmHagFxYM?=
 =?us-ascii?Q?ZdXLI3prUxfiolYg0+CY0BWXODAKVSYupiLHVLAI49eie9PcFt+XMVZJTixI?=
 =?us-ascii?Q?lgdiU4IYJ+LUGkgxCLys1D1zr0au/KPpUNcW+XeQ343jfHapt9R2P2Y/ucvB?=
 =?us-ascii?Q?w3ypdiIYyrn5/owluOEWHSy2L1gyR/I/CbJTVA821mwsGVn0rplfw41VpiFx?=
 =?us-ascii?Q?4LS8hT1/DnQsrLU+yeU0cHxIySM3k3zs4VQJm3LA5t+gZdMDA6hrU+OycEct?=
 =?us-ascii?Q?3+KFBqLigG4ncEl8hWkQ597C8zL9M2GP2/OXB+Qy6CJma1KKh7SFl4g+O8dX?=
 =?us-ascii?Q?moXkIa5XnlTT8YLguGdgXJbneu3UfXzRqEVtstWvi65LZPYrZUktaK2/N9vV?=
 =?us-ascii?Q?qxs5DzcgUkUeuCV1C7CLhO1SjD0Na1HglBv3C3rY+AB2RTSUpjnjbNxUBJ1S?=
 =?us-ascii?Q?ZWZqmOwL7zSXYCjFy+kfjnxegHfU9VjQ3l5wsZxOolOfnKPslAU+sMGLKSui?=
 =?us-ascii?Q?JJKKmlm61fW4wOCe1E/+sHLXCcf0UasELQtIlLf/G5BCfNbQDzqscwfmntmp?=
 =?us-ascii?Q?qRP5AeY9jktdR0t05GQ3CAOIpdg+YjtH1CQii4/BIwnR5uYDJAbnx4e0tVWx?=
 =?us-ascii?Q?ZWChvX4VHvwfkhhbWYyYOSAqa9IJlecZUVE2dwo+sdMMH0MphsuhmLYUisEw?=
 =?us-ascii?Q?zOKOvOaLFBrl6G+w+3loccev0dRAMradIfQnksRZANLzNJLhjAccNnN81WFW?=
 =?us-ascii?Q?MG/UJXkY4B0yInNES2pjXMdwGzSjplm2NBitxj5Q+0TkhoQGhx8djQSYbOAJ?=
 =?us-ascii?Q?mkGuZ8EqmLAu0c2fM+d9TlOtfjtUmvuC8trHfb0wjErScWOcpZBndu+lS32U?=
 =?us-ascii?Q?qxMWmYaXFPZI9SU1jQdqEJZ1Dg1w2ctheHSbWdMJoAKeJ5tlM3L3ZTmjXs7R?=
 =?us-ascii?Q?qj5y9LCDsvO0c0EW07HOm/mADUxXJyY8EBBPPnv6UWeR5gGP9ZSZB9mnqzHt?=
 =?us-ascii?Q?DT8m2Wx7Q3+PqZqD8PDtDxlAFkk3praICto0+EZ96sZSKG/SS8N4NUhNp6wD?=
 =?us-ascii?Q?o5I7xq5pG+Um5aMrUyPE4SwNJB/0tFtkWjO3J19fCuykiy51jS1gg+TUxOvZ?=
 =?us-ascii?Q?B3l1xEjLaOUrx3NV25FNipzS7AW43L4lmWBiFca7hBzALj4JaR5cTEk7YRgQ?=
 =?us-ascii?Q?0SXRK5KvXLIXYJLO0gz+wEBFvHskzH+e9mJWtRy4BkCKK5aLyo3Kx792LtIa?=
 =?us-ascii?Q?ycfkvU5+IiyjGEosOOOLxW9dDmSXRecH+ogw6BygKTBqzc+IarvLyMFALHPd?=
 =?us-ascii?Q?CZoiCqRqDpz28/8NylEsuONdqS2WtO1kRF0fUeK+vOnpn1A7NPNfyYQoN71J?=
 =?us-ascii?Q?JkKXUYMWVnShk0gLp1Bz0YOt2QkX5GYOtIampyhntdES4NH+eTRJvM3iZH1L?=
 =?us-ascii?Q?rWVbGHzyowlnFCZbM8oGbqf6qhjif6BhTBvSMgRkaHg26iu7CV5h2HXP3RVf?=
 =?us-ascii?Q?mShbN7AyRZek60rJ09jku8saM7W3E8tQMc+WCk2uyXKH3PHHsqZ/zKYb7oS8?=
 =?us-ascii?Q?jlOChg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d14a95-f102-44a8-737f-08db26063110
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 10:07:03.9127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZcwdKOicOkYQ73fvaJQ9pRAGqhxJCKlONwBZvDWKxOi5BWF9anPTaEcEpCVVF1DxxD/nwKXOBIDWKt5KUQSEfKErOZsxld/k5Mw2/HneOKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6279
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:40PM +0100, Markus Schneider-Pargmann wrote:
> Add get/set functions for ethtool coalescing. tx-frames-irq and
> tx-usecs-irq can only be set/unset together. tx-frames-irq needs to be
> less than TXE and TXB.

Perhaps I'm reading this wrong (maybe I need a coffee). But I think it
might be a bit clearer to call out the TX aspect of this patch up front (I
know it is in the subject.

Maybe something like this:

  Add TX support to get/set functions for ethtool coalescing...

> 
> As rx and tx share the same timer, rx-usecs-irq and tx-usecs-irq can be
> enabled/disabled individually but they need to have the same value if
> enabled.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Nits above and below not withstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/can/m_can/m_can.c | 38 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 7f8decfae81e..4e794166664a 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1945,6 +1945,8 @@ static int m_can_get_coalesce(struct net_device *dev,
>  
>  	ec->rx_max_coalesced_frames_irq = cdev->rx_max_coalesced_frames_irq;
>  	ec->rx_coalesce_usecs_irq = cdev->rx_coalesce_usecs_irq;
> +	ec->tx_max_coalesced_frames_irq = cdev->tx_max_coalesced_frames_irq;
> +	ec->tx_coalesce_usecs_irq = cdev->tx_coalesce_usecs_irq;
>  
>  	return 0;
>  }
> @@ -1971,16 +1973,50 @@ static int m_can_set_coalesce(struct net_device *dev,
>  		netdev_err(dev, "rx-frames-irq and rx-usecs-irq can only be set together\n");
>  		return -EINVAL;
>  	}
> +	if (ec->tx_max_coalesced_frames_irq > cdev->mcfg[MRAM_TXE].num) {
> +		netdev_err(dev, "tx-frames-irq %u greater than the TX event FIFO %u\n",
> +			   ec->tx_max_coalesced_frames_irq,
> +			   cdev->mcfg[MRAM_TXE].num);
> +		return -EINVAL;
> +	}
> +	if (ec->tx_max_coalesced_frames_irq > cdev->mcfg[MRAM_TXB].num) {
> +		netdev_err(dev, "tx-frames-irq %u greater than the TX FIFO %u\n",
> +			   ec->tx_max_coalesced_frames_irq,
> +			   cdev->mcfg[MRAM_TXB].num);
> +		return -EINVAL;
> +	}
> +	if ((ec->tx_max_coalesced_frames_irq == 0) != (ec->tx_coalesce_usecs_irq == 0)) {
> +		netdev_err(dev, "tx-frames-irq and tx-usecs-irq can only be set together\n");
> +		return -EINVAL;
> +	}

nit: checkpatch complains about unnecessary parentheses

drivers/net/can/m_can/m_can.c:1988: CHECK: Unnecessary parentheses around 'ec->tx_max_coalesced_frames_irq == 0'
+	if ((ec->tx_max_coalesced_frames_irq == 0) != (ec->tx_coalesce_usecs_irq == 0)) {

drivers/net/can/m_can/m_can.c:1988: CHECK: Unnecessary parentheses around 'ec->tx_coalesce_usecs_irq == 0'
+	if ((ec->tx_max_coalesced_frames_irq == 0) != (ec->tx_coalesce_usecs_irq == 0)) {


> +	if (ec->rx_coalesce_usecs_irq != 0 && ec->tx_coalesce_usecs_irq != 0 &&
> +	    ec->rx_coalesce_usecs_irq != ec->tx_coalesce_usecs_irq) {
> +		netdev_err(dev, "rx-usecs-irq %u needs to be equal to tx-usecs-irq %u if both are enabled\n",
> +			   ec->rx_coalesce_usecs_irq,
> +			   ec->tx_coalesce_usecs_irq);
> +		return -EINVAL;
> +	}
>  
>  	cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
>  	cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
> +	cdev->tx_max_coalesced_frames_irq = ec->tx_max_coalesced_frames_irq;
> +	cdev->tx_coalesce_usecs_irq = ec->tx_coalesce_usecs_irq;
> +
> +	if (cdev->rx_coalesce_usecs_irq)
> +		cdev->irq_timer_wait =
> +			ns_to_ktime(cdev->rx_coalesce_usecs_irq * NSEC_PER_USEC);
> +	else
> +		cdev->irq_timer_wait =
> +			ns_to_ktime(cdev->tx_coalesce_usecs_irq * NSEC_PER_USEC);

nit: perhaps adding us_to_ktime() and using it treewide would be interesting

>  	return 0;
>  }
>  
>  static const struct ethtool_ops m_can_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
> -		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ,
> +		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |
> +		ETHTOOL_COALESCE_TX_USECS_IRQ |
> +		ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ,
>  	.get_ts_info = ethtool_op_get_ts_info,
>  	.get_coalesce = m_can_get_coalesce,
>  	.set_coalesce = m_can_set_coalesce,
> -- 
> 2.39.2
> 
