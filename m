Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503FE6D2447
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbjCaPqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjCaPqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:46:18 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2116.outbound.protection.outlook.com [40.107.100.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5BF6E98
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:46:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOPQ9fO6ahBcnpE4edcybixh0F8S9jYFiOaht/4Ih++ot7XkCvY05fVgOqimY4gEIvWs2z8lMJ5P5cHc1KvmHTvdjBO0EMeJs7WIuX6dTtq8q0slWJa9qXRDWH/SNtQ3NiG/7H4SbcRM5uknweCCtIrPcTL6cECi585Wa4QuaJsS/nO+WiRhrR/ISmSRCiRJxoEp2b889P8hwdXAv7QhliVMy2xi0QrYWVAUHRK12ih+nVYPPJ2Fjlp8Eg+L4HtG896dcDgxKd7JL1WcGQ7hLtUWjdlY1hmFpUaJkMvkWZDUmtPyxVIdG1pxKtTeQMYAqczEkPiVYkWDsaSrCEeTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N770zoRFZdGkcpaffAlzTADnq+qUSpFbL29E9qrS4+w=;
 b=RC3RHTtOA1dI7v47gjJ9+UtIBTq5d7RzIyD27LdGyk2JwgaZYqBJhVFGhI2FL8yzCdM/VABaihagU2876K62YAawIoCAjE8ilAnwNk2qnDryWuAfXjHk/LXi0x9NER2K29Ml/omatFqCphJCHWJ8ZUNDfUnlv/U1rq+dzuqKr9WBBfz633Jmvd8oKonmiMCy2UGn89cLRrw80T59RHLg0s6ux5skCiv4464uuGWKyCtcf8hhdAFIrZMVBDUGpu79x+AJ2RaEbh5r21iGlppj7u2WdusCvg4wNeKAdE7gwXgUoG1mxU9QsLcjRJa1Ih5kpDvx9U7Xrh4ulKWYUMnJAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N770zoRFZdGkcpaffAlzTADnq+qUSpFbL29E9qrS4+w=;
 b=NP0+x9vNXFpvRih250Xjz7X5H0a9JCmDHlyEY4u5NIECADCC7bFjt0uMj8bTbfyF4tcVeHic1s73CAziY0QXgLnmt9S7LjPKZRIN/k8QqdGsceLVvw+0lL2X1sh3fu+5DZhOIC/vqhQ66Whj/NXDyoJFTe2E5AKT8mBXH2OvIp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4932.namprd13.prod.outlook.com (2603:10b6:a03:36c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Fri, 31 Mar
 2023 15:46:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 15:46:13 +0000
Date:   Fri, 31 Mar 2023 17:46:07 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 05/15] idpf: add create vport
 and netdev configuration
Message-ID: <ZCcAP7Oc735h2b9z@corigine.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-6-pavan.kumar.linga@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329140404.1647925-6-pavan.kumar.linga@intel.com>
X-ClientProxiedBy: AM0PR03CA0080.eurprd03.prod.outlook.com
 (2603:10a6:208:69::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4932:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb254f6-867d-4b51-aa31-08db31ff0e89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mz1qkxsADBVL35G8uvxQ74dZvCskmonjVvapMrAdflQghTwgK3lUYG2fILYYzpzyWI6KYlYIkjPptbYky6zEEqEsHpGcXCexNFW2FoAcum++QsSjC/wGRYkcqTNpJtHuucH1QZBVRjRCyR7GKE1JqpXvFWv822SGtI2gDf+SVVELwveiP8Ze1dfI8jWzAiettHd8mKEnFUx8c6B4zj+57OsfRkvgyC4S1nAcaiSkPM3WDBGsexvS8lSRj0OAGGFmxp+zaWmh/WxF9/mYphqdXNOv9x4sYAZrEIWgXsDqQd2TsWSTF4Yym83GHgxFGaICT0Yj3E0BShVlBD/FxiMedynkhnW3GZB3TTo4ESQD/SWyNgnLZHd0yqtRZgmw4Gv5vNKrcolgWotxGsXwWmKD8K62/7GLzbUwBvJb2RMAOc6PkPb69lkx3KwyCoG9ls/6vLASeSEdoe33VZ/FHFT351Qz3hrm3hIwub1Qr7kRKh90aHq/lQspxPoLS9EEEu60UdGeDnB5PH7L4XOsG+Yogn49+uYy6ykBNDlQfeHGDWIJmrqAT/TJboIE3f+PzyyGF3PU/mW8gvRL135NTvMxZE/wuDb4diPL0h/xRzJHL9w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(451199021)(54906003)(38100700002)(2906002)(86362001)(6486002)(8936002)(44832011)(478600001)(36756003)(2616005)(186003)(6512007)(6666004)(6916009)(8676002)(66556008)(316002)(66476007)(5660300002)(41300700001)(66946007)(4326008)(6506007)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?52A9fICAHfEK6wVVit1RxN/1F582DpImTBzhUkwLz1wtV7DCxN+Mq6qe3+oN?=
 =?us-ascii?Q?fbqz28ooNXHW98qV7uqhmCWCMhlwk5qvrqK6Ki2MLxx+G8fEJDd3RHDPompv?=
 =?us-ascii?Q?9yaA6xs2TXhasLRpLfUJYCYqxonCEkJTLq5lx/Nwn3RwL8qCHlbGVj/IJ4Zm?=
 =?us-ascii?Q?UwwVB35Y4PP4e7WDLEShutGLpIsZlxbe2WClXcmUKl1IcDf201jlh/GfSUgp?=
 =?us-ascii?Q?p0F/hkywYgsFJhBYhAsImWGXStl87PMsdK7o0zh/jlGicOT8k3Gd8c8OGlbH?=
 =?us-ascii?Q?uAQF/OtwDLLVgnqSWEn3qGFz0p06a4xsEQzWVckDd7Q9RuMF9lrPuLdgXdmF?=
 =?us-ascii?Q?vtyNZftPtYPaH5gs5f6odxv+UYknoEtykP5Fxph2iwuDdsetF3S4Z7EVNmr+?=
 =?us-ascii?Q?W8m87UyS/QS3thHZdWBSgTUZsKZm2TmipuhzX8Rr17DieNTE0fYb+CNlPHTs?=
 =?us-ascii?Q?ZEzCssV4R4YXFojb3bhgahX9XjPV/z0Ioc7L4SjdA3e1gsE2y062bh8auIeT?=
 =?us-ascii?Q?gtfED2Mo/yT3MBWA+/05/yqeuru+qMchrcwcf2jeDJ+Nw7BXHoPmZoRErH4a?=
 =?us-ascii?Q?UO8BtmH50HmmnvnM79yDARYkQmC6ocs+Ak6ghth7A1dFy3eQ6my3bdPQPkIf?=
 =?us-ascii?Q?FNjXIn7kzkcn3lRrxAGf5mFVw0Ctg63J5tkA5J3QR+XYZz8H2qsZ9hzLpBRd?=
 =?us-ascii?Q?lnxfsvu3e6E3hQv6ySozkirLx1SY7hW1mVU2tGb4vBfGQdR1yU9u7YlH31LL?=
 =?us-ascii?Q?iabi9sunweT/FqEE8rJBXGMXGnneCGZGRE7TAy64dOJsVeT59OhYEs2MpBeM?=
 =?us-ascii?Q?LlydkuMeyVjq1CtMMof3VSV2hJa/5rKaixRuxvwoDVDmtu+jXj6CpRvKz76i?=
 =?us-ascii?Q?e21DjZeoctrowP+yQ121cVB+BhULU0HSfjddW5XnqlRYwPzuHnvkuRdNDqeI?=
 =?us-ascii?Q?mjZhD3XSaNiwZAdlI1BUcJuMaj7Cns1gsbJuT81W+bZfnfoU8/vbYyObC/UM?=
 =?us-ascii?Q?0aIgo+br0X2TcSQ/vieYE3LA4ATkLGm9y/jHveTapIOQ0Ggjuz2quq+Ck2ny?=
 =?us-ascii?Q?Yz3S+5dz5XbmUPChsGAN+stev6975RHoW1GDLkqBxPyz3q2FyNBSV8i+xd6f?=
 =?us-ascii?Q?hva4w7ufPCm4Wj7iISd1Uk3yd8yXVyuxcQkIvSLmj/LAtUVVkx6+HhcAj16A?=
 =?us-ascii?Q?XZdbkpM1AzONaA4x/jnhM68qTD7/+iwDBl565brPnFB0tMrmLHsrdNMgQUOb?=
 =?us-ascii?Q?ShE5T9ixcByJBaTq5S4OKo1g0AJG0e1dl/rlfiSC94ovFVMvcd6Kx+4tvC7q?=
 =?us-ascii?Q?Aklt10TFvUIM6kax6TqLLRCI7+5ms/Yx7oo+SnR0/WVtxNxiyS0toykxoEDE?=
 =?us-ascii?Q?pqwh7AtMoVGvvinoWNGggK0FIi0bwQSAGuRcyGBzKVWelqGEDfznUwQvfr45?=
 =?us-ascii?Q?Us1y1ebkfOMUWomWlXM1wmn16jPWnC6uDOaG7lcXPtUVU6wNpe/qofFPzDiu?=
 =?us-ascii?Q?sWGUSd7H6q7HtzCLP4jmbxvQW4Iv2jM1a7R1VngJJyvnFe7p8AWcdmbU+NEh?=
 =?us-ascii?Q?7Z+CSbXNNo2oKfV/qBtaf3YArTMT6Q7qHw4DlNj8cMeivqDPv7a4g8G0xqD7?=
 =?us-ascii?Q?jHYI4Y0GRpMEqu4/DEXZmhTlJKzuM62dCjPY8lcDW3iiPI5Ok/NFo3nU4jai?=
 =?us-ascii?Q?HQqgbA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb254f6-867d-4b51-aa31-08db31ff0e89
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:46:13.5880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZ2SFfw+herzvWrQ5+eUvhZxbr2g+p+RPY5N791TP/5k2PTnCY+Nh6anX0q7cuWtyVIsUmLnFw3rzgBnCH8cr9a3xG2xbM8m0Zmv2NrFkGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4932
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:03:54AM -0700, Pavan Kumar Linga wrote:
> Add the required support to create a vport by spawning
> the init task. Once the vport is created, initialize and
> allocate the resources needed for it. Configure and register
> a netdev for each vport with all the features supported
> by the device based on the capabilities received from the
> device Control Plane. Spawn the init task till all the default
> vports are created.
> 
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

Some spelling nits from my side.

> diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c

...

> +/**
> + * idpf_decfg_netdev - Unregister the netdev
> + * @vport: vport for which netdev to be unregistred
> + */

s/unregistred/unregistered/

> +/**
> + * idpf_deinit_task - Device deinit routine
> + * @adapter: Driver specific private structue

s/structue/structure/

> + *
> + * Extended remove logic which will be used for
> + * hard reset as well
> + */

...
