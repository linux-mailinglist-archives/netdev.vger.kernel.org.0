Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3536B8154
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjCMTCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjCMTCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:02:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2098.outbound.protection.outlook.com [40.107.244.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7235C5FA5C;
        Mon, 13 Mar 2023 12:02:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gE9g/NHoMuQwEKQ/7f9SNHNi8qxxc92huLBV9FDTx6F+2Htr5UmpaW7kbWcxVogF3O9R/UmUMG9zZz4GWCd1/1qMSzmX7ZVYLwdTe5ECsDWtPvCBBp6OdjS3Pqo/5H4iFucNq3my8Bb83jy6f7o75DWR3aHzevg+kHxS7ffXJYDc0i85JWCMjwh13imaTHnryOxAkO4G9I2RSXwWqQMCPUsDQ9T1M+nF3jzVnoBXb2GSdUw7tlhcnIvcD/JmkbwE13Q5+AULwEkehZPAYAltg0XhBM0fwOZ+JP8B5ndGkANQF+295yPgJG1wd/r3q5PX8HjTO3nrIj3ap5s1PYe1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bG6DxwzgR8i2IZQkigQYmM9QqNKXpCvoYag9CehBpt4=;
 b=YjYnfIFqwmoYaEJ9YmaoXYn3jI2OnoZVuClB20pduFm6Zjytw97xIhA+Bh3URyKA+5jYaF4hcXemPGZv78uZPNELhmKJn7AEPTRbB0PPYSx4RyDvr79jE5iL8XCGAfx+ylh84mYHBeh4RPSZwGV1L7kXBsHyuFKMgQXZwos1VP5lCWmvg6L4KnIS9pYMNfGwBHsA18wncazfi9yJcYj3MReGq1bpFR8fzu/xIa0oV2S9opTHCZ+24wo1BTOzLObre7ktANPV2dG0a5r5HLpu2ZyEbmH9xRClkXV4oPkAqnYsjO9mRoQDzfnD/1s2QdJdYQ/xc72y8CP3C9nzI5Oe0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG6DxwzgR8i2IZQkigQYmM9QqNKXpCvoYag9CehBpt4=;
 b=r0BIBFh226YU7lFavjhJIPwddMxlvLRNGCyjYhgiXrPqI3VLz1ZVukm8lHasYMMpczsYNU19Edz4gH9tV2dmZGUAOu/aWfYYUVPr9E78nt/8X99LX51uHybRbsUILY7AT7y/P134P+mgy9+Xk1nuy1OgJh2x4o+YUWOZGeRV/Tc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4837.namprd13.prod.outlook.com (2603:10b6:303:d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 19:02:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 19:02:04 +0000
Date:   Mon, 13 Mar 2023 20:01:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] net: lan966x: Change lan966x_police_del return
 type
Message-ID: <ZA9zJ8lUB6mdMgMM@corigine.com>
References: <20230312195155.1492881-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312195155.1492881-1-horatiu.vultur@microchip.com>
X-ClientProxiedBy: AS4P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4837:EE_
X-MS-Office365-Filtering-Correlation-Id: 454480ac-af3f-4635-a1ab-08db23f56f39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HKaG2XGEJC2d3rLGOV83oKQjWSi1aEQk21OVtgRq5vU52YWFUbR9MWuwo/Z6kvQDPgXIKvVPMQk+djTrqXmzl+7YOLJLa20OIFuBy/29c/A21hDFwLtwnNIfIo/jvv7+y0iFC+lPOmKZ5N1lAxHF4kErzGcpau/cbDr4AqTuAAgSa9mlvjOWaWIA6+Ps57XeHnCuTw45lpXS/G2KyJTTyWSu1Inl+S2XrpjMKeCz3REJKfTGWvb35RTAzfBettGIDtC2Z3YOTzlZ4RAk2Q0MHFKY/qMkGmaCnCDTdKQhDhbrCHy5zLzHt7dicfLfBR3/ec00WWX6xt4FOHARyP3qiIH99XIIxUarTOi9s+rNl2gGHecdvkYfXloXF1U7+owf1wxHFwLhEdxj0q8ej0/eTDvDklTk2pP/LOgBw7ni4idFK36+gBgXUqcyllW6u2pln7xLGhINLoAfnBiwt7QT2oSKX/Cy7K+e05pTIoYY83oBZCy/dBSzAPO7glT3SJGvtzvARbA29OyweSLsMMNew22q/mlorjp6dbE0asKF2gbZmGnZ44r4A1I1IJ1MqLC6qK/scs7LqPudfOq3yXd9FuOWMDel0Lr47FgnkJm2c0yQFj5Yta5PqN0We0O1MfGDtVjljQEfuoUBdshubiBi+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(136003)(366004)(346002)(376002)(451199018)(86362001)(36756003)(38100700002)(66556008)(4326008)(66476007)(8676002)(66946007)(6916009)(8936002)(41300700001)(478600001)(316002)(6506007)(4744005)(44832011)(5660300002)(2906002)(2616005)(83380400001)(6666004)(186003)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hJPIbV/tWVxWF0LRFW9zlxPGUJkrOehmRhlgE2MeTwdFeCOyL7Jf5xYqVb3n?=
 =?us-ascii?Q?X8d2+c3pqI80jVYXvUim6i3t3/BQHR6NMr3TgJ5wWSJg0Nzdnk5J87nch4FW?=
 =?us-ascii?Q?ieQjU9DZ2ho2JKoRmICXNW7/2oPy2DhCz5HDhmvjFOKc58gPbohuZv09P92N?=
 =?us-ascii?Q?NfGBm6oVth4X/PlUeOFMXkMfKGTYoAmnCEM/BI598fV+6k2lFkhdFNt7VXlO?=
 =?us-ascii?Q?8yy1FVMgUKLaJZhyCV05TJry6IBljJ61+2G3AT0butBfYHjulxzqd/fLKR5E?=
 =?us-ascii?Q?lfk2UyiM7Vo2KTLPs2ciK73z6YUKkQUsBXmJ7J0GpkUP3/B8GwEZxhRIUgCv?=
 =?us-ascii?Q?9J/ZuwnM3e9icN+83m1cnCriG08JWs2YFtvcblAF8SwBqd92cJxIi2oNO4Vj?=
 =?us-ascii?Q?eIbm77lZWnAQW7DrwaWc1CnetDUzmtn8kcppjJG5DArOws2+iyAdA/LRtVAJ?=
 =?us-ascii?Q?xtThI7Ho/Hhk9WpzQh/IZlaykIDBLWHKbZyInG5rA+fMXFqYLE3zCJQXhrp5?=
 =?us-ascii?Q?BOT8sRolMHw9t1CyhNa7uu+dFDIHfZH9Pt/9Et/q3wYW5DHeqoh/6/3EDKFc?=
 =?us-ascii?Q?CdTW3XGd7QO4DkgKJxFsTNaR+HYBtT4dGi86W4Yx9EjRxtlK3OWNYFjrOsby?=
 =?us-ascii?Q?EZs8Yog/AdSz9H4x2wUFOEtpzYEW08n2r0MG9mBYuvJnKBzv59LO/VWwdhgz?=
 =?us-ascii?Q?zqnhLllB0PFPvRvNlCIv4gwtIokDcXoLcip+o63nm8N4/zpbnk/Z6luzvuHC?=
 =?us-ascii?Q?xBz1+u/fv0flSzfZA5AgIItde/0QRFKoOL2DviOTejlOFn5e2S1O5pfMR/yO?=
 =?us-ascii?Q?bSEG2kftpLhQvPCsQp/Vu90lPFZTy1kqZvlk+ldLpMkydsvEBRMOPo/YsVp+?=
 =?us-ascii?Q?YpsGl6C41wnTu0XSMIMsN+f14Ugs0qm1KSjG+1U+MhnzbAOjtGFBDnej+/eQ?=
 =?us-ascii?Q?G1XxPaZ4ox9K9P1spWpE7r/6Weq+2x9qRwvpBk5tARUiVt+XvZJFY3ng/FK3?=
 =?us-ascii?Q?47Gc7lUNC3mhnA6n4wLn4cfVBGmU2I/oBjokvwYx3IABkosZ1fsTa8TWG5hD?=
 =?us-ascii?Q?m9r6Jy+eQ0oR79vFgqRtoDBOszV/vi7/WtTTgsJJXpY1WTyFIkshIOBlML83?=
 =?us-ascii?Q?ZVJyxtjz4ttqrirWB3ARrEXJUqIg6bliR+PxSjRE32qTavEVYaMsyyiG4B8F?=
 =?us-ascii?Q?kug7Bbya8DO/ZW2GBcxqOs46ypo5nK0lGTQRwbLr8V+1EBa/XSG8/IuQMSr2?=
 =?us-ascii?Q?L2UQjy2+8KSGq2bKLPIM1XGxuiyz0MkJtJrORiuvgqDroN7xLDmBkrp74WIf?=
 =?us-ascii?Q?hsJ+pMgx+/SytdWehD5yu6xr09E8axH0NKCLJZILh4dkcGy27/E8X7UYNTfM?=
 =?us-ascii?Q?X5uLfgUwoYqQTohtbbhQ473+igpphxxJ4aSa0baHC8L1VXoY+8sWip1P3BD8?=
 =?us-ascii?Q?9Xu/X5/kUT/VoyUipVQZJUUJ4IuCSMzF3Y2+Tx9foaqhM1UJK7XFwnQcmSRi?=
 =?us-ascii?Q?AK1RLi2H9gfZUzUSXwLqR/yPbqArjui1jEIcV1zT89wuLd5RzYGGKegAx3J/?=
 =?us-ascii?Q?Nrwuxwo1l45mjj5Pm+lhbKLzlOFO6+G20iJp6KYKZiTvQyzsGAQilvayero0?=
 =?us-ascii?Q?ptWHU+8Qxz3lT02Ql/znApzpRoKlBQSytD8AV3ygH2ScRLtH7rUTW3bTVouw?=
 =?us-ascii?Q?JfPvIw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454480ac-af3f-4635-a1ab-08db23f56f39
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 19:02:04.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0p5bkWuL3zg9H2c7spDyPuZjtgxXJwxRM7kle2Zds3O9x7zV4cJgaFUsj9cTBoLVHNdCMwB4d4z3bnJumXisTsOIJtkjwqyrHDE77F4BQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4837
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 08:51:55PM +0100, Horatiu Vultur wrote:
> As the function always returns 0 change the return type to be
> void instead of int. In this way also remove a wrong message
> in case of error which would never happen.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
