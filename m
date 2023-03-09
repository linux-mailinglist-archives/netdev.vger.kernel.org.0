Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EF56B26EF
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjCIOeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjCIOeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:34:06 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8844ECC0
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:34:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjWbSxA1gCeEwFePs14nEwS9nD8+1GV2S0JnptFS+VvQLTqzFUD+tw1Pk0lVmrQQIqZkaKH2XaStodJ1qk75RV0Wd/tAcVo0ra9cEZK3k/kN1GrZ1eE1pRkk697nOCJIrQue+K7vX67CebE5ADXRuBdUfPpX1Cf47Q+fEbTZ+jJ52Rjd584hbR9z5mH/ZA8A1FBPF9i39j33ai31cLJjxTxF1AhdHVXncaFDddKss5IjjV2pSq9xyaawtZKH8z0rcKbe11XU9BN6ed6tdBJ1dieq408XwwP/iG/PKl5aNahDYCgmGTaTH2oc/tz+XZlvU/NBTqRvGmVCRR+g8Lm5uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxmy+FZ370oM8jNAfdgwlN3sMcAVapa0KhDAJRI/NK0=;
 b=Mhg+SGWaJuQoOqRKfyYSWTke23b5OPKgfEBLgnLnQixD677+DZtrWeS1nvhgZQOycSj6oEYZ2RsoOJW0nBcQ/x3vkcmW8FgtuN99rxiKYir5KZKSOJiqyt657tkrmWv2TcqHEymgMVJS/VKReNA0S+xBbU6+6JeW1i3dKriK6RZmpIyaZZTuTV9kxNOsQdERQYsyoEWictGR4ljLvOECYrs6N7l24xf4ompnOoETmhKPgzFuzmAcUhG+EiRU0AlYwvhhRZ/aNdI/RqoEUs86CVeAB9AGcVIOq3j/HzXsMlB/0R+fT8JUp/LeX1p+nMapuN5EjrUDXzXZ0SwmUEoQbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxmy+FZ370oM8jNAfdgwlN3sMcAVapa0KhDAJRI/NK0=;
 b=DBcnqtUDXdR8Oju6FXvoXCoQob0MsNo5Uf+ZJLCFfhKOfdIkXEvm6ECcuITkAwJXx3aOnUaT+5fSJk0jfq4EAUok8fouqxB63G8xfuvOYgPxczkWJBa0Vw9rG4Q6YNKNmZkuzoHip/NI6iPK5T4p70WMV7hKAAdkvXbIgFHEfrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5617.namprd13.prod.outlook.com (2603:10b6:510:138::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 14:34:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 14:34:00 +0000
Date:   Thu, 9 Mar 2023 15:33:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: smsc: use phy_set_bits in
 smsc_phy_config_init
Message-ID: <ZAnuUVDxLvdt+Jpm@corigine.com>
References: <b64d9f86-d029-b911-bbe9-6ca6889399d7@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b64d9f86-d029-b911-bbe9-6ca6889399d7@gmail.com>
X-ClientProxiedBy: AS4PR10CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: f8700c59-4193-4a36-b705-08db20ab52d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4MxIA5EzpRbJv2b/2K1FH3mMJtRtJHT5Yas0WH3NKR/hvucjx2clFGBULGhbqF7mktb+IwM5WqXeMl47cOoyWqCFO7Glgv4lrECuoNDONeS8vWMGZ+ZafGp5wwdZj+PW5cfl2gHJ6h/rG3PPE4wecGzRiFW4Y5eYqC55iAjmOv+SglYSmoOJRs3OIIl5Mczo0TKcyqcv4rTFPyK7lOGhVWL9o+9LBQvD3aYpch4BkJz4z+10soMZPegulx4QtugX4pv6ANpcTyWJIIfDM9Y0T7JzoWqiNKk+h5sNTtWpF0ol0VKVtkoeh1vNZZaukkUE8RXxWsu+gJTB3a+B2cn7btl3hlcDj4CCILVNzj9VbtOmjZei7Y/q7zbyliSVSfhwoHOfRz+A/76U4pfcI10lFjckpJGMjga2ZPWr+TWvpfD978JQK1jpKYlnBofnRAHQOaRdnYWxMrEkaSmAStKEGSUZ+p68W7PEVVLLVxs6OFvDC4uWoVJu3azuw1hCXzHK0VcguIlch6fRpCT4UQIRvS1oJ+c+AWvrLFLnqbrMIfs1RFbWXZFKY/ZCNcfWqK6VLUo9Dmqvhx12LIBJBe4tOV0s5XzO8Gk9Q9ueTCHNW/xk2BE8XgVyQRDNiK1wT4opKkp17XrDFxq+qhETlN3+CMaI0NH4W4frN0GEFCDq9j0l0huHfLFiDTB4L4LPLCUxoWUe0HV3kXNNb+7vOcm+AUuzpQKhMiVqcxwjfPZ7jzZul3D0C43Uujf+kUqavjzH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(136003)(396003)(376002)(366004)(451199018)(558084003)(36756003)(38100700002)(478600001)(54906003)(316002)(2616005)(6486002)(6512007)(186003)(6506007)(6666004)(5660300002)(44832011)(66476007)(66556008)(41300700001)(8936002)(4326008)(6916009)(66946007)(8676002)(2906002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z+/m0qNd/MjeG/uEhYzDMJR0VRfFSRpfDc0aIdGZkh/pHdFhvabeOpdeiHL5?=
 =?us-ascii?Q?lowAgAOh+VlRcxNbyVFaSz8UvNsaOcywWzbIHKrB1aVijLW2+t3fdg/hEDOq?=
 =?us-ascii?Q?/pL4R9mL3/ZA8o3E/WAOF3hnSJs2SYLxUVlzyAJS+WB9BZQrsMLMnGwgUtjv?=
 =?us-ascii?Q?sTfbsZffViGw/8NGCT8QL6RmKrrKciUPnRWHMUzyhWnVLWXaBg6IObCbY+Ab?=
 =?us-ascii?Q?fqb0PcBZZy/mRHEH5XOg0X+Fqjzm3Sj3hMO4VYcCw5r53eVsir9L8EiQNwYU?=
 =?us-ascii?Q?ct49UIs+PYO1MZVdziT/wMAeB62ucpWjn5E3gaD7SAK12D0iDap5kzHDmgWx?=
 =?us-ascii?Q?CotBt33CHbfwUjaa3U71vmc+8Fz7U+m5uwGNDKYbwMC9xNOfQ8ON79kLBtVB?=
 =?us-ascii?Q?VxuCoNs0oOCOtTKph9ZAX1ijxFsvq+vzwxkJvums6fWm8WqX+dgX9j5vfv6k?=
 =?us-ascii?Q?gav2biKYux70fXoaFp3QdIYpgVVr2zEQTwv0mqNF9duY+EFBSpR+VRAXNag6?=
 =?us-ascii?Q?nY9d25nRcDmzdxGa2OVHy9Q1UDdgoiiYMIxQAL76mRy5q1lYcRDoX0+tszLQ?=
 =?us-ascii?Q?V9ywCph+sVBCellffoo91hJVBo4n/czuvWzln3JMr4CiPf7C8g7LPM5Lnv04?=
 =?us-ascii?Q?Yf1lEW9ibqNuOLGO93ef1PH+XOgO8yPbeyt7tavq0S16ncLWxeCFJR4A5vU4?=
 =?us-ascii?Q?aJha+PX9iPhAvc0sRfwBi21VAOCS0rjsT9R+6djQhtwQRpXXgZOnUbxfkeas?=
 =?us-ascii?Q?+HVnDCpIwZXEtNfbyDlerXt6i900afzI3uyccsBOf5UXa0Z4/EwCd5H77Iky?=
 =?us-ascii?Q?HWc14kwxdDt8U6nm7x8qyh3slem7mh1roNcG6qCtDNFTS8dvb165od2mNrN9?=
 =?us-ascii?Q?j/ILLoYf2Q+cfDTokzjFvjJbG3IsiPRXJWJ+QarM8i92xgt28Iqp51Rc6ceC?=
 =?us-ascii?Q?C+E3z8VypUDFETWixcxxbg1CG6ueI/tRSZeccNRecLFw0KVTjlIX/suDGmlq?=
 =?us-ascii?Q?Nzq1NwXlwAcWh0CvY33jwE+tPOVTKHS3SDEC2bSf/lJiFCPtMo++rGFE81ul?=
 =?us-ascii?Q?GfQuepJfgw+W97R6j7o8rMBwx1Llda8LAIyiyd6SvYYCqboCRZZ7QCrj9vRC?=
 =?us-ascii?Q?/ltDb8q4wbcYwzRly2OoRtPUhStClRmH8dxXmWuuSjUHr4zuR8hJl1UATh5Z?=
 =?us-ascii?Q?pH0kaCuqDlKVDlSKjKv354o+yLk7hDGvrNVJzrrTDkVakh+SpgaIo212i1Kg?=
 =?us-ascii?Q?DlhFwzfWHGb0TBMSfC2dGR7TD2dF+hJef/GuQ/l9qsCGhIpER1Wvn/bUVNHa?=
 =?us-ascii?Q?ppAtqtzQ4nAR1NBZS7zuyQfl2gTdWQjizJ9ZiczmnyMq8BG20Xo7C1c++fyC?=
 =?us-ascii?Q?u/lHpiDB0JWQGyGiIoz4BiUihdCb9RfaTOHNl4A2ySbt04FagCusHdg5ufVE?=
 =?us-ascii?Q?5/BTjOHdxI/4HPyttkZ7UQ74EMQcFYXf4SzeVPQX08sT6wsfuRUdX+9imUyR?=
 =?us-ascii?Q?DeRWNKTBq+tsYUQv5B5MSCyj32QnIuTrOzKWd2ULgLI2jQCi7k4t9TgR2sc0?=
 =?us-ascii?Q?fmvV0Zsp3mo/Pcjclw6XIshFfFafKPjcpng2CmaaUq6pYY5jZAbXxKlHEURp?=
 =?us-ascii?Q?llvLLaTpzPVtgUWgpz/E3G5eFnXcM4Jf2N/haNmmXhWpiuCNR0LKjijcOUZW?=
 =?us-ascii?Q?h4kYOQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8700c59-4193-4a36-b705-08db20ab52d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 14:34:00.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZZ5aPPruUIwAetRNiFDr5OOEMl0uSb4FxEGMQOvZ6jGvmg8Cz9lBZpbtPrdUq/ugkuaTlQh8av0b2pJevRlapeCvKoqhWB4PKHxo8itXNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5617
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 09:19:55PM +0100, Heiner Kallweit wrote:
> Simplify the code by using phy_set_bits().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

