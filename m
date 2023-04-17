Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C066E49F1
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjDQNcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjDQNcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:32:53 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC49F1FF0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:32:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvgQNHJEuBvq/9E+qPUPd8T/MSqGTZSvsiXSZS2CMUg6GBIBPVjTkcgEqubSqGWDW6lYdHrSnVmrHoq/cKz0WipIlT9nF2rqzTyEfd12dzsfTOYf10VRfcNfvWwf5/Jvy+llTKP7wQUqvIglek00YtDjkbYpPrbOIK6/YgVhl8Eyl/+6/mmRotaNvUX2M0MwItQ4hox80KdCqzLtadCpEC8tTQoQPq0nT5mtPU7AFtnQJ+at+triIYxSREGv4FqH6l2o0n+fwyH3Bf/ZBos6VeRQgSVyjI9NmeZtCynrQObMufQkeisZtvIy/banpOwwWVRJmVAJdGQWhi7JIlX0tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8CFUTyFdLacMLib5Gd4bA9T2z4g4nDeWssy+nbMybQ=;
 b=dXrov2wYkwAHkY/Nbkfu8sJPpDxeWgxDHDtm52INObCxNKr5nl7xG7vcC1uV15CqAHnvt0BXioQJ8AKULGMSKlXfKNRjBSLT3K4yf2H+IvkQWeyA+qSZjocH6B5NBtg53tcT+Jh7Nfdks/HPlrk4cn5sM7c1e6W9dOJhKOKNhA32FHNb7tx+goMreHDCaEtCS8Vz3SZhhglPFZYQ+maQcpMfx7vH7HhxyKDtMV2fp+ldWDGWANd3NaAYsSDUgdBekaDaKG/kJGJ566PBmuEl+7UO3S3jWF6i/Un4SA6CxMLmiGTTDBO4lWp9TD9LdGeZ8NGNNn+uOrW8YxjuUtl5vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8CFUTyFdLacMLib5Gd4bA9T2z4g4nDeWssy+nbMybQ=;
 b=vPtmCIzZkmPPIBZ0XYHBh67UrghdPdJ+lzPlN0DAg2faCRKcA9zJSAiYVXqhM/JCCqzltBGsskE6ECJq9adDxZ5RsrGF1WWWLBYTaQftFHoo9bQIP9HDEP4sejPItMQaHHfmE+kGvxY7l/2K7j3uorKLV9gxgJiKYNTG6zXeeSM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6057.namprd13.prod.outlook.com (2603:10b6:510:2b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 13:32:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:32:46 +0000
Date:   Mon, 17 Apr 2023 15:32:39 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 04/10] net/mlx5e: Prepare IPsec packet
 reformat code for tunnel mode
Message-ID: <ZD1Kdyf+p0jqYEGF@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <f9e31cf8ff6a60ea4eb714c93e5fad7fbd56b860.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e31cf8ff6a60ea4eb714c93e5fad7fbd56b860.1681388425.git.leonro@nvidia.com>
X-ClientProxiedBy: AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: e7243e5d-5c20-4ee3-9a2d-08db3f483b36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oi6Q1wQoNkLNBDox1BkvZNM267z6z41vecXnk4mUpHgfQXIZAgmo9ilL4lwy0V4YzQ4axZsExMg7gakQZPziq63Coxgum/uWuLpe2svGCf4V1X3tN/23eOlasIidH/zxwP5FlWB8+mBen5SVJAOmpWbnym4zsi3Foald4IY86YPfHCOJuV1ggHwuYX62mQpymuvcGkqlrNRwcsVQVglPqUxFkf97Jwlu5wGnBEJLzQFsAWALxLZ210QP7zqDOTphMB2I/9tfPpJ7e0pVk8Q9YLmR3Aqnb3nMZuuWcSDDW+pbuwP5mGygGEAmWwN1jBeizAF05/wndKNUivu+Ebe6TwVi4ZAFkwu3xxx8DXlFfTNvJLV1WHT5UBYmrqxq9zyaqfCozq2LLf6Q3ZpknjlU70NhM8z2S1BBQpGCa46dZ0FIV5AFwbtwSm4WrgLv3oRFao+I1FFneq51U/cewv3YmjfOyTcDTooxFtN5S804gxOt5CayV7Hd97qhUjtKryJVTGaAVrlq3uyNf6Qyo2CrmaAPW3FX0u3Umme1eJ2PDUGebauAleBRkAqPV/fSf5NFpk2ct7y9qoPIxh3ibqdOT0ah3/iQiZlMDfMHBO0rS7a+jsiFU+M/ZD/R8lyXtBjqwI2p7BInVSEgDlQPE1PDtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(376002)(39840400004)(451199021)(66476007)(316002)(6512007)(66946007)(4326008)(6916009)(66556008)(54906003)(6666004)(41300700001)(478600001)(8676002)(6486002)(7416002)(5660300002)(8936002)(44832011)(2906002)(36756003)(86362001)(4744005)(38100700002)(2616005)(6506007)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eh6w5hwBpPtP7erDZbAPfvGrOT53OGDgGpVc7ZBTd7rphufjZam5GoxqiHHm?=
 =?us-ascii?Q?pGSg0XoPRcHGdlv5c+64hPsnX/7lboHszlbsGfCGFujCGcLqCE7UsVRf+j8m?=
 =?us-ascii?Q?vKDJtnrV41vmLboPZts/JuyQfR/pnLjFsRd421Iws6gNCuFJ35RZI8lrWgFL?=
 =?us-ascii?Q?PHNgaoTrPGXEL2WvcZPPCuwtQUZEcXHq7RY/+RH9+JcEmrCSXWZN3zDooH+F?=
 =?us-ascii?Q?vXCUmGiCrbB4dTC+gT1LXyd6GqARcfGe+inWSsRi3t2GRrKFaVD85BSFXsqx?=
 =?us-ascii?Q?2pVb/GS+cUagP8VatTNojnn7L8fYzhfts1PgA3C3AvOfWhmyTHOCLa96yB7M?=
 =?us-ascii?Q?PHFUyTfrliWSSE61wFLIkAkF9M3AH+QyMnrMkUsAdi4J7/yCfcvCMivnPXF/?=
 =?us-ascii?Q?Lh05KS5jfUHgnewg+5b40uJk175qUnbDDtYSBsEc4FG7Pgs0NDzv5EfMxGil?=
 =?us-ascii?Q?cPTLOAXbpj2aCuBGlEALtzZbAdITHWW8U+b7AcJtEmo4v22+EPT87l5Hxzbt?=
 =?us-ascii?Q?JbES45ZHRZ8nplEhCO0sVhuLsFgSZ5o6f+MXfwhU4c87andS+ITcvZ0UCUNW?=
 =?us-ascii?Q?1+YvCDHVjGvKmowELJX8IWoLepxkeOV1oTZULkbdRBWaazRnFr7yHtyG3NCu?=
 =?us-ascii?Q?I03WvEe8hPuujNZVhHmqr4A6HwoiR1YgGkS9de5EPMWBX4IFc2FkgKsJlKwX?=
 =?us-ascii?Q?3YyZI7B7ay6PNUNu9qRwtYJvcBj8xacwEMwOa+HQt+czyjsQcM8EAtcvOdjA?=
 =?us-ascii?Q?344DEDiqVuOWwAYG9eBhEkUoGeyTui4sKCBNlLipBZKWrYVcxCJL4i1E7YN0?=
 =?us-ascii?Q?dQdOW0GE+Md5w2pcT/KGvhAHEZ/tavMdjYtFCM0P0U3eQ00/fXH1aQkJVnB2?=
 =?us-ascii?Q?QT1muoWm0W7vi1eFzzp6alQlSuHKI+oKGu/RbZt8+oJmBMW72oAwYnIVqQ+r?=
 =?us-ascii?Q?hhBaiUBNqQzzU0918OoaWGmmsUoo8VM5/rdbxTX7ZkT2sFBaVhUekEzIFiPx?=
 =?us-ascii?Q?2qtCFlGZB3TzEFYx6MaYut4HwYFEB6q14HOIpcp5eJnPrjMtOia1E6dBf05J?=
 =?us-ascii?Q?nUmAgRuJNkgt544Q0o1QgiZvxfYqarGmDDOkC5ANWVBH1nHK5Qoo9mKrC2ah?=
 =?us-ascii?Q?fqSZF4H+bEnPK+2omlL2oI19h/WMq73NiGhhK2ykaCj1/AyJ196KPndqPCt/?=
 =?us-ascii?Q?68GxFMY167MlDcU0DrJy+zmthbZuAghCQhcxPFqbHeMidO8YNGvq+Iifoti4?=
 =?us-ascii?Q?cpISBIhaql6BJDVVE5soXdyMTswnsnkVEsINhgsThX/IvcJhPTe7cHdZ15ps?=
 =?us-ascii?Q?au1eR69Q31zeFSZiVBwKzIY1OORGYq86fUO+DI/flG7IxDz51yMnq/sU4HYx?=
 =?us-ascii?Q?3w74XrFD5RtYOpMzUbnd8jYQcM+ZDAzzdw+CKdCYwS4w2bovJJGCVt7JGUM1?=
 =?us-ascii?Q?w66a43fyJN6kcfJz7bvgIoHsI5LvLh+c9U2PMhsf3fNo7EP6D9p5V7e7nmKH?=
 =?us-ascii?Q?R9t40Qp2TcMv29w3YrtIbSTMVlnGSbIO6BJpXa480vbw7Sz1d7X6jMZwxf/t?=
 =?us-ascii?Q?lm+jjdG029mvCrL/XXo5dyxAyFukjwjE/M25MeYxZUKI6UrN68UMmQ3n+YFv?=
 =?us-ascii?Q?ylx9aPTkCDp/jw5UCU0xmPu/Z1x95PJ6sK3IwwBADyg0KHEZ0mcKZFOvEgqD?=
 =?us-ascii?Q?6CLU6w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7243e5d-5c20-4ee3-9a2d-08db3f483b36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:32:46.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCVB3G41qwEJkG4WH5ihy89jr8gfuhI9N/igXwnKDRTgQ6ro6jaVh3Z0Csz7SGhqyoSRBOyN1SxsAC76Hh9sfLmIa2XcW2D9pdW9UJ3l98o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6057
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:29:22PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Refactor setup_pkt_reformat() function to accommodate future extension
> to support tunnel mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

