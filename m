Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7716DC565
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDJJzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjDJJym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:54:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03C33C29;
        Mon, 10 Apr 2023 02:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VL/z54HXFd3N5t2yTLKNO7bFnI2jyylJpzlhPJdMnF5VQaEbGIsD0XtMoMRTFK0rwWROs/NOdZvxNJGRwFb+CIkN730zYBGY7oRsofDcE8640v+l9KIez1LTo8sK9kGBhlsxwqFa+vsaD5Y1YoL2zKCeeDTWyP67DrMz6BpBboBDfPbvIxpcZH9RudNnN7y2JNrQy/3O9elsD0EsKu6PF6EVP1V1nsDynjiYXXXDYFnJXHOBs1W2EQjvn4qKY2S/gmshiGv1oxMFcN53zIaEWtmaVXkCfyWXPG9xvy8k4DYbZWuWMxJhueRoepYHkVgNuX5TOHlIZIHJk4IaP2t5Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EzRjwIGPeZMRf34Ao+VMns1e3cw+oX5XoAHEqHfn+wE=;
 b=XV65xQ4c3SPS9yf95uXk7tXZQhsoB8knSAjF2bXAySLorYI6d4goXDZusixqSz3lIsxv/4EnFL11qbc2eoEGGDakSGyS6AhzD/wbnK2P1tD38Bk8n6DDscTZlDhZQyfwcwmEDtRE7CQ8EDehxiIhtYdtg6FCQRnXBvvROND2ojt+kjv7zEw5OsDkL71MnWB5/q4wjHA/aN34wEBuZckTOIrhxG5WDXnrGP055aNq0RqX/B6bLcBdLlRr4p8tE18oqhg/CbJF+IRrHd0VpUnN1BNsi7tp52HSfX79m0KHzl0gIrxjvTbLwgtgMtTudfsF0ZZCwjVM4FRg0Yg29xHCgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzRjwIGPeZMRf34Ao+VMns1e3cw+oX5XoAHEqHfn+wE=;
 b=PFwpxbu4205eMNCu6TbyboPPkuOesVsbTfKdRA0dwOMhgsZ2Q4J8D9VHamf26+Y5pUrogQZmbI8lCzgMsgtDOMJ123aIwTP3pcj9HtgtvgiD9yKXzBfzydq4JuhsS3920J3sVd18uOngow+Po1fcKgIdMg7J9LZ5njlyca6pteA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5230.namprd13.prod.outlook.com (2603:10b6:408:159::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 09:54:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 09:54:35 +0000
Date:   Mon, 10 Apr 2023 11:54:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v4 02/14] sfc: implement MCDI interface for vDPA
 operations
Message-ID: <ZDPc063jzve18fqp@corigine.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230407081021.30952-3-gautam.dawar@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407081021.30952-3-gautam.dawar@amd.com>
X-ClientProxiedBy: AM0PR06CA0117.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ad7eec-5337-4ab9-6ca7-08db39a99706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtQfsDUspafIQyRIstxYKcNbKIUkR1t0gDPom9mOm5v/SNFOnmyFtFH8BmJxGF1aDGD41NlApzBcktZ+pap3fkhEbwavO/iTbxCTWOrPBenFi1Muoa/XSYMbhflDC5B3nd9W/4cU/BOqxW5ZG/tB1G5QsNMe/qoJEijAEpyibQYF5A/eWp533l9Wh7sdAGvxJCUe5BdxKfCg8l7NGASwLXV5ShMo5XJ45Hgel3uINdnvfUd1EvrE9aWVyMwFJhcwu2xx85aKiL3R6NMngNd4S0fsCoUB0ZW6574UKp6eO1R6e2NPcZ53bNz/H8y/hhoyRn1f376Uy34BFTMX6vn56iGNcRK0ViXDAmDJupl44Khl5Jp8/tTxPk9zfSO8Xe97qEFA4zpMaMHPdTTuqOjz4XBysKR5KHetb+3CYvIVfgL1lq6X35rigxTs5cxigxOMBt1PrwIJcz++RYChkCZJ2xWlZGzX7ALnaUB/Y9NgSmit9lrkzhclZBvjEdIWkjk9guzPJ8lXkl6ibvGyGkFewB2R87uNIKslGCwG+H9fs1fMDvIPiBo2a3xcburutpWT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(366004)(346002)(136003)(451199021)(316002)(54906003)(478600001)(36756003)(6512007)(186003)(6506007)(2616005)(6486002)(6666004)(66946007)(6916009)(4326008)(38100700002)(2906002)(66476007)(66556008)(7416002)(8676002)(8936002)(86362001)(41300700001)(44832011)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oAL7PjHYKOL7SrCzg81CLjObGyo8XfF1uxVntJj3+2INlYqbpgaKF+gffMat?=
 =?us-ascii?Q?oMkGNWabYPgQD6CT0oBIdo8jHC2GhSweF/bEpQWkE7cTGaIR7cRd2Ioj/sXI?=
 =?us-ascii?Q?Uz5lyBJqZIlxC7SCklN0AhPJIcOjw+hiCYn2KLT6909/QJESHtCZQNOk3IK6?=
 =?us-ascii?Q?9eUlhOV7lNJht+8TAHoryTYObPYCgp3bvoszKpZbyksKQxxqpojkyd0AFqPU?=
 =?us-ascii?Q?W8NfLjDRMBlWtNvpcoU6YTaC9TQOK978T581cQD9yWZ5d8jbKxXgDcXopfP5?=
 =?us-ascii?Q?PBr2nLbYkCr82gwEcwlpT/zVPQghpKfSQnnVWXSnKPHU+hHIcBxesGJEGqwg?=
 =?us-ascii?Q?2OaL7qx/JN6QOng4sg81KBV6jSmUGRn07ZpONvm5i10Twq133kErdH9Tp8Iu?=
 =?us-ascii?Q?vGgJp842jDvOR/g1/rF5qcmQyIOPyKUFLKynIxVUwUkVcHoz+yFyEdkYUs4l?=
 =?us-ascii?Q?yTer+GCRG2D5sFO5ba83YjTyXpvW+jKc8D67JesW9TU3GfUMQL/BlXdeme6D?=
 =?us-ascii?Q?PQmjETieXRFrYfLLfROMzReI+U4i8PuApyzBRlxdEZOFH2n9PA15Ojt9Q4lZ?=
 =?us-ascii?Q?de0PbRECkPS/gxpSvhq0zBjHGrRhcl41jx9XZsNpdvXJ2a0lrPdpuR4GBHtn?=
 =?us-ascii?Q?q9/WzI3ZUXN3f3vIiFbW9dIG2tZGrPoBUS6WrxoHzlIxxNvcrwaBuR+/QXVZ?=
 =?us-ascii?Q?r6HqFItdTE3rK5eGaQ99x5LgAqcMNXfjGhvLatkqCfIe06JsgWlXJquucyv4?=
 =?us-ascii?Q?vwmDp71lU9KEI5xPwCBtSXWo3ItC2gSqEeqFpQIO9211c1dRXmhNniWEmMne?=
 =?us-ascii?Q?hvM/5v03Eehi6InSWmq6zyqr2I5ODY9VuKJLFLVqt+UPy+xLDe4uCF49q8PW?=
 =?us-ascii?Q?JSqGqStdSTDxMok2VI3mj7ivTdZfMXRqr/wfUP/lQyocEEsrQ+Pt0sJgNNZt?=
 =?us-ascii?Q?JedmbHvDMNrYQPLjpD7s4aGSM1QDRHnqEbSqmLjwXxOZAKCapYgF+G1MVWxc?=
 =?us-ascii?Q?pDRaYKPOzVL4szWxijaKNFlJkGRaWyBcOQHHXAQJxx/iorMIYxDNRPa0w6Jf?=
 =?us-ascii?Q?li4v4MY/PfYxd1v0sotD50PBwtvdQUL+DvaFNrGBxtYeXT3gFpJpP1PbUkb5?=
 =?us-ascii?Q?4Lj9ohKBAnDltxU5CkGFoAkl/e+0Avtfu/QCNaM7wM8GMFstJRwaYbl1XOUP?=
 =?us-ascii?Q?DFvAbiIGm0kTZaLLX2UMNyISAWm/KRmg+1OfMk6IpWX3dsVbCn/d/Go/7KWo?=
 =?us-ascii?Q?JzRNJAUWPyfTUpmFkAw+vk9Wlss9+VNoI9NFAK+dSIHkelMXGhkf2bkDo7vW?=
 =?us-ascii?Q?cLPlkQLaoiheCMmWBLr/YsBKseY6s6SA5zMQvFQ5hE3G7dwcq/dgSO15YnsQ?=
 =?us-ascii?Q?OzNX4LZ0mg5QjkaOkFSVYlrP2xMu3PEMfQRfpml6sFG4c+hlFqXG6Viq8cCg?=
 =?us-ascii?Q?rsqLaNs38bK0JbQ7Vcp4mXSVi6eZZteatg+8C8zZ8kFRT8uIDgafS479PAD1?=
 =?us-ascii?Q?vJVX2waz9gGluixPSKY3TPtUEu5BFrzRa6/s+BMZbk6C4AfQjWt16WK7FqNP?=
 =?us-ascii?Q?gJsVZ77xFcyPOly2eP+njmr/iufKvvxPtjnvgDV5ab/grukHxayKCzf1tRNq?=
 =?us-ascii?Q?BQ7D16nBh8i+AqyOWbJA2liFUwnanOpY1JA1P4xrZKRUVOI9oNnJylWYlbZi?=
 =?us-ascii?Q?rnvDTw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ad7eec-5337-4ab9-6ca7-08db39a99706
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 09:54:35.0985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELUEowPoN1Fa9k1VMri/IMQoWs/NXWM98pIY7HcOWyTsMIdyT3G3DFtHWNN6GlQTYxB5yOi5S4+jpFBftjDPqtC+2zy9DjqY7by0ukdMljI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5230
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 01:40:03PM +0530, Gautam Dawar wrote:
> Implement functions to perform vDPA operations like creating and
> removing virtqueues, getting doorbell register offset etc. using
> the MCDI interface with FW.
> 
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>

Hi Gautam,

thanks for your patch.
I think that I found a minor problem, as described below.

...

> diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.c b/drivers/net/ethernet/sfc/mcdi_vdpa.c

...

> +void efx_vdpa_vring_fini(struct efx_vring_ctx *vring_ctx)
> +{
> +	kfree(vring_ctx);
> +}
> +
> +int efx_vdpa_get_features(struct efx_nic *efx,
> +			  enum ef100_vdpa_device_type type,
> +			  u64 *features)
> +{
> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN);
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_GET_FEATURES_IN_LEN);
> +	u32 high_val, low_val;
> +	ssize_t outlen;
> +	int rc;
> +
> +	if (!efx) {
> +		pci_err(efx->pci_dev, "%s: Invalid NIC pointer\n", __func__);

efx is NULL but it is dereferenced.

Reported by Smatch as:

drivers/net/ethernet/sfc/mcdi_vdpa.c:72 efx_vdpa_get_features() error: we previously assumed 'efx' could be null (see line 71)

And by Coccinelle as:

drivers/net/ethernet/sfc/mcdi_vdpa.c:72:15-22: ERROR: efx is NULL but dereferenced.

> +		return -EINVAL;
> +	}

...
