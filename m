Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2C353E305
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiFFHJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 03:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiFFHJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 03:09:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2139.outbound.protection.outlook.com [40.107.220.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2006711906F;
        Mon,  6 Jun 2022 00:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdJhPH44X6iSN4gSBbEJcFqd/oD7kyejYwT4RV5B6blH4wtch5tJ40CWc2e7N480rt4/IQQUfa3G6oHeRHI2rJv79SBPk4Dugh1R9Q4bmqheYMdrZA3nNQuS4DCWH2x8+XyjyLs46ls9q0G8O1sr+PqHLwRYzqkYrIP213zzytxr8LoXym1oWDcuwxDxhewwLrsC+ftua5vWD2sQKQpGXr8kI5WZ2mAhGTuvdEhP2mxaSRzLqrUG0V2DQ+uvPUYg7XtEtN/uYK9gjKc2qUepw72gtS9X9CRuOEjRwfZl5g0b7nRx5xCuHXNdv6v1HHAPc0AVnfq4ZhvgmYXxkRu1QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5iAnNBWNODApz/4fu2SVFeBbpFB5hrJuKP1u02imvw=;
 b=Asd53CmIOIops9my+fodQnD1hl/kFcHqFENai/AWzVc3pxiEnK/wumNGoRDmGxoWkiiBFxvOu2KiLN38VspQ30tR4tS5LeRb7Wgnaqy38ofiGf3T2mNHIhMV2ehhI+PgT4ZIA29kmD6lTdJ1T2d2ye5aa33fE3O58nQZbmW8TnleOhzFWkytUPv/OkvM6VO3SzboR7gTqq3jDYdSWJ7pLAMF3RpwjQ0DhKjR7g+hq6POj7fd9vcsGts0N+tW6BJK3gw/Zi+vnargMgA3cJXnTO5RmE8Dq2gr42TgzwZw6AFhVIjiJxPzjZLYqLtVIvM9zyedWqTYjSHTJH7hrBg6wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5iAnNBWNODApz/4fu2SVFeBbpFB5hrJuKP1u02imvw=;
 b=XoM5YE7dcVWoHxVOUD9epQZU31mpwUa52Ki+93dwVa9CwM/ORyC+OQttLHVclV3CMbV+JwfRQtlVf/1QlRXV0kNpd18Q3y9JDavn+jSkFB0aLAaslVoWA9QJIM1y8S4+41bqC7VRJXbOmNnZPPmak4rv82ccwZHx5YvpqFwn91E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1526.namprd13.prod.outlook.com (2603:10b6:903:12e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.9; Mon, 6 Jun
 2022 07:07:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.009; Mon, 6 Jun 2022
 07:07:10 +0000
Date:   Mon, 6 Jun 2022 09:07:04 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, oss-drivers@corigine.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] nfp: Remove kernel.h when not needed
Message-ID: <Yp2nmFgJVgYCKJ/D@corigine.com>
References: <e9bafd799489215710f7880214b58d6487407248.1654320767.git.christophe.jaillet@wanadoo.fr>
 <YpsjFwNv5s14sdhD@corigine.com>
 <d7be07bb-2234-ae9c-b2b8-b8d23cce5978@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7be07bb-2234-ae9c-b2b8-b8d23cce5978@wanadoo.fr>
X-ClientProxiedBy: AM3PR07CA0140.eurprd07.prod.outlook.com
 (2603:10a6:207:8::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db94861c-8f7c-411b-eb29-08da478b2c83
X-MS-TrafficTypeDiagnostic: CY4PR13MB1526:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1526BD370E87B10DBAF51DA6E8A29@CY4PR13MB1526.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fb2igb0rB6mwmd+PQsl1qYgIQh4E7k8FRUTiq2MTnHId/RpvBsXhihaaQev5b9oaqoYSxvF6iF+PqGJYiWPVGm/LPrNBKDRu6A0iyfrmX6k3UrWeyqOfPchNaf3gFYAWcbTu9sXDSBxMn941XGtPGYsFFczB/xvofDmASFfkSYj/tz8Xh1uMHb5x8PpUlrhT5U9AfTkjTxaRK9Z0Xp9eHGEJxCyxI9wgffhjl4YFrnjE3mWQIXKmKcI5VMCUxgxH5/Gw1dJBHvshSLqPrREGAPy90tM4qjp8450VRE8NVsSQYbAFUA2TI9kbnwyEB2R5wFQqoTsCkgjOWPocQF3E+8GrpS3gkTwJO1/FM731rgxyaJrYecinZcP2p1OL/2fNJ3N530Q7YCBM87sucHfbNR3RPdtH6NAiTYjfRf4hBNIKl7uozTxUv/JzDvtBUNV8VaCXnGXhIG9543f119RS+b2Wjr6pthuUtLWYo4jipx09fK/m1mqLu8XoRGl3YFRPH0acO5VB7rIk1x6yX53R0X9y4inG7wmFIMTKmfaf++dtQlUepPeX3RPzcEVupWOi+SXL6ZxoxgPyS83oBoGzFThK0A44rIAQk8/hQkKcGAzGmCcD2nsGGJgv1qgxPDyfvgxVdIOgWQ9s5eIZMEmBEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(396003)(39830400003)(136003)(366004)(346002)(2616005)(316002)(41300700001)(38100700002)(5660300002)(8676002)(6916009)(6486002)(508600001)(86362001)(4326008)(2906002)(52116002)(54906003)(6506007)(66556008)(66946007)(8936002)(6666004)(66476007)(44832011)(6512007)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGpRQjFwdzhKTVFZTXpVY1NLWnBjVWVFT1UxSVJ3Y2oyVUVHbjNQUThieFBI?=
 =?utf-8?B?Qjc3MFFSZlF5VlcxMSswVUhoUFZQOFRiNzNaLyttc3ZSWVhMZ2txVFhvVzI3?=
 =?utf-8?B?L1UybDFKVUU0MWNaYm9NalhpZjJVNmhzZHpUQzZHMXJwUHRGclV0bDBxS2RL?=
 =?utf-8?B?Yy9pdWxPc010RC96OGYvdllEWlBVL1BjZUpET1ZWaVZaYlQ3RjBuMnpVcFBH?=
 =?utf-8?B?d21CK1pRSE1NUkpnVGt5R3FFeDc5NmFuL2RjNmZsVXVSamlHVkt5RjcwNzFh?=
 =?utf-8?B?cnJNYi9ZV3BlSi9VZHFRTWRxb09SSXFYdmtOaWxrNHJqUkFvb0VWdk9sbmZQ?=
 =?utf-8?B?MDVMR2daa1VFQTMyUnpMVHFYQlM0SFNZTEIrZzhTVkxZb2wrekFzblFRZXlY?=
 =?utf-8?B?RWp4RGlkMHlKWnZxN1doRStYd002czJLM1BQT1daT1BvenpNUFNNTWpIOFhB?=
 =?utf-8?B?YlNMZDNVYTR0aUIvUDU5dWJtdG1IaVFqQ0RGUHI3RTRGYnRoWkRKdiswWkd0?=
 =?utf-8?B?SWNHam43V0srTGZzcy9kNmFuRGJXRzZPZUIxNENiYWhPbVByTVdTVXdWVTdr?=
 =?utf-8?B?b3dXNDdyTGFJL1ZMUWFwK2ZFaVpxZlo4MGhXMmJKY0hFNzB1SnpRUUYxSlI3?=
 =?utf-8?B?L2FjRVZBRzdmVDFCZG4vTEd6YmhuK1ZCSDdqS0JPc0gyd1BiSVhPd3lJUlh5?=
 =?utf-8?B?OW1VaEM4bXNyMnBSdTdBY2kxMC9wcm9VQjkyMGJ5U2dJTXREaGgwdG4wVzAy?=
 =?utf-8?B?WGFpZnE2VW1GWUYzaFBGYVFaQm8rbVQwV0J5YVZzeDZkdkdOREcwZnBJSGtl?=
 =?utf-8?B?c1hUVTd6UEsvR2p0Zk42ZmVMY29LcE9YTXpjSCt3M1YvckJhS0QwL0FyaW5V?=
 =?utf-8?B?SWVRNFA5emFTYUpnSEVQVFQvamgvL09FVHlETEpCSEJBMHRpaG5PUVJua0JU?=
 =?utf-8?B?Nm5jUHJ3WU42OU1BZW85UVhCOWZWN3d2NXhPUnJKSXhFODRUVWtmWFpnc3BO?=
 =?utf-8?B?bUE0aEZPUDNkSmV1V01XUURIMVJrUEtucVN0M1pPaFBvbmJvSWVJTm1QTVhT?=
 =?utf-8?B?b2hnUkViMlpwaDNDdnlJVElzOTMyRUFYVUU3cVFHdnR4ZVduYVF3Rm85WW42?=
 =?utf-8?B?NkIzOFBZRCtPYjlLcktQdTQ5aDRBc3lCUXFKQ1drMnhUVDVVc3RKWkFpL2xG?=
 =?utf-8?B?R2RjTUVuU3JTTWVsRHdSZlBiRlp5d3N6TENqT2thV3ZDeno2dmp1WTQ3M25F?=
 =?utf-8?B?SjUvUThLdEpLT2ZYY2ptYVgvUEswUnBYRDFCN3o3UXJKS2k3SWQrNWEwbkxr?=
 =?utf-8?B?TC9tandyeVFLN1BLUEJaNVl6S1ZJY0h2ZHppbWplZllKRnVaVXJHcmg0RGNi?=
 =?utf-8?B?eWNhYnQvZ3NsOEVpRnFxZ3Uxb2N6OVRuQmdMekRPWisxOG1uTmJnbU1ab0g4?=
 =?utf-8?B?TUltd2dqRU5CbjBpTUFRbkJQZG4ycHdTM1Z5aEEwcThSOWlzaStnTEwyZGRQ?=
 =?utf-8?B?QUkwZnErdjU2TWpEMWFXaDJaSWYrMG5BcmNEWHlzUGFtaFJQYklVUjI0dUhV?=
 =?utf-8?B?ZWpqNk95dUFlZ1dsVkFtalorS25wclh6UVY4cDRjZnpyVndJeUhPRmtGYzdO?=
 =?utf-8?B?dUNXQmxsc21GTzA3bDVlRmZHZ0JYUGxacjg2QXNNM0U5bytnTmowWHBrbVEr?=
 =?utf-8?B?amUwYzVpUlRkWlVIUStLTFhxNlZFbGpGTG5Qa0o1ZVF1SFNiNGl3QXJSK1hG?=
 =?utf-8?B?cDNIZXdoM0dNbjJWUE5zbkdsTWc4SlVPR2dQN2psQ2I0MkhXcFZQQ0grbUJO?=
 =?utf-8?B?d0owNURPb3NoMUFMNm1DS3l3VGlkQ2RTdTdGajdRZ0FKd1hlSlJwbnZOeVla?=
 =?utf-8?B?cTBLaU1zUEdmZlR2MjdkZDdiWldQRHhPODQ5Tzd3SVVUamwwMVk4RXJyczZ5?=
 =?utf-8?B?N1QrVktlcFp0M0dNNFBuMVhva2Zrck5vemZPWmY4azl4MlQwT1Zacnl3cWRZ?=
 =?utf-8?B?SGo3NlpURHRJYTMvMFI3NFhyc0lKbTYzM2srL09tVmdiU3p6anpxUVF0Y3FX?=
 =?utf-8?B?OTVGc0VWcVJBYkR3dzhoWG5scU5BVnZDMVU1NDdpbXBpekRKQzRjMythWEpT?=
 =?utf-8?B?UUlkWndwRWNYT2JLVG1KTndNWU9OdGFHUUxacDA1Z3hSZlhINFdleXJ0Zi83?=
 =?utf-8?B?cWlBZzlCaWlkOFpJVFhYRml6LzJPVGllR0UrTGFEYUR6V1hTMi8xNXdieFZv?=
 =?utf-8?B?RDZwVFk2allpSHdjNk9NUE5wTEtrOHFwN0ZORE9kdUFqK1NVdXBYVENTOWNn?=
 =?utf-8?B?N1NlUWhhbDU0UllRWEpvb0JnMlRmeS9WcEQ4NEQ1UzVucy9aTUtadWJ4cEU1?=
 =?utf-8?Q?QlCr1jVeEF1QBgANz+BQ2Zi5SL5Kml5SNioTP853p0+WW?=
X-MS-Exchange-AntiSpam-MessageData-1: KzHb5b8ck9eYIIwWM6lXEOYyrIJyv4ekEKc=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db94861c-8f7c-411b-eb29-08da478b2c83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 07:07:10.0777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3gCHl+v1cRMBrYCmUPmVFf2vnQPkDzu/87koDgOmbCk68h7BgyECxjqq2lyr217oel2izbdCewsI17JQ2he29ZIC+i5F8MVy5Su+dF/FJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1526
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 04, 2022 at 02:58:25PM +0200, Christophe JAILLET wrote:
> Le 04/06/2022 à 11:17, Simon Horman a écrit :
> > On Sat, Jun 04, 2022 at 07:33:00AM +0200, Christophe JAILLET wrote:
> > > When kernel.h is used in the headers it adds a lot into dependency hell,
> > > especially when there are circular dependencies are involved.
> > > 
> > > Remove kernel.h when it is not needed.
> > > 
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > 
> > Thanks for improving the NFP driver.
> > 
> > I think the contents of this patch looks good.
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > 
> > I also think this patch is appropriate for net-next
> > ("[PATCH net-next] ..." in subject) and should thus be re-submitted
> > once net-next re-opens for the v5.20 development cycle, which I would
> > expect to happen in the coming days, after v5.19-rc1 has been released.
> > 
> > I'm happy to handle re-submitting it if you prefer.
> > 
> 
> Hi,
> if you don't mind, yes I prefer.
> 
> Dealing with timing of release cycles and prefix depending on where the
> patch should land is a bit too much for me.
> 
> Thank you for your help :)

You are welcome, thanks for your patch.
