Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850536800D9
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbjA2Sjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2Sjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:39:51 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E22311176
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 10:39:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pqal0R5nlkWGyOJPuG1XYFF5RQPD22Nd5MX6XZhbM7ecSBpsWez2iEp75MPIzr9QClxRoJGNWoyMse8IsRypXxDcSroXGzwNLVzEVtI1kRM8mdLh5umEhlh1GMZDjG/4DcO4sk432rf1Z1SG2Hq7r3bR7xjp/Hv0zMmVLuWBzsh1Xj5XOrWejpcmAPgxtRNBXpD2bQBHmFBwKafWfv7mRZi/wGxNLfkD9rbgAQvMZhh7/qmhvJv15SB54ZRIOgurella8E6eUBwbrGIu9rylNWiHh9+Kz6k5A+/p/hAfmvmYGqoPUz/2kG9J2SswRaqHmT0LCb+WhQan+OlOPQLeSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5431h7tNgILKX6a9//swea+hULDSePDtpNj0HhZQJI=;
 b=gmakVmleVb1D4yJHZgpx3zv+TCJ4iH9iy1vM+czmlfl0s8CPUUkiIxzSwACeE/wFJLlWS9ybfE9OIM469UUj/9zs8Dvnni1A7THgdGCyMZAYGaAg0Lu/Yzl359YF9TbWehAUEzcyxBXKuzw/lvyeycq4mc0a6fpY4vl/sM59j+NydOYuUQYynoz4Kd7zG/hosLKEUBMa6nx7/+oZztR7pdSOHUgsmF/YtGJZKun9mbl2t2aTFm+ppAsY82GMyXdv2Z82xHVHsjVi1K6hBtC4JBaTdJX+sT/mBIxVV+gz6Kh3qiXnaDAN7atjjbVign6758JJE4xaFM2nQhro9y8hag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5431h7tNgILKX6a9//swea+hULDSePDtpNj0HhZQJI=;
 b=p62OobRNoHFv+uRZIVZzpqf1Uq97sZ1imjf1xbzY5neT5ZxaHchcLQbqyvvItog/i1epAw3p0M2WZCA4fZhNVAkFrsCAoQwEcSiiKNYWfokY6FeyBJpJzx0+Q5vNJEQtJ8tClekwuLmTLX4izK3hqHD8T5r2uHKE7v+eAp8Ia14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4672.namprd13.prod.outlook.com (2603:10b6:5:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 18:39:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 18:39:47 +0000
Date:   Sun, 29 Jan 2023 19:39:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2] netlink: provide an ability to set default
 extack message
Message-ID: <Y9a9bTU3edwDRW6N@corigine.com>
References: <c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org>
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4672:EE_
X-MS-Office365-Filtering-Correlation-Id: a1bc5e1a-106e-4fbc-2e18-08db02283294
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpuSnRKHtfvPffU28TMLDk0K2rhB1xyycwvgvInbfAuyX02AsVChb6IdcF/GImQxk++95EzPxSak/9as+QvSeao1luH12b+HZTCXx2eQy26ZVq2JQP++nedMzx+jsKnaIYbDIFsEyWE77fIR4aEbDGSFqsH4zfq2h3liOUkoOrdg/YCkpM8yC3WHjLoW46wVWh0u8r4Rz7+1JTSGWdaxNVNfDI535vtcub3XQPtkoqYaJqdI8k5C5/n/HBZIMoKbE11iCt63nBH8dmDzJtvVBY6xjOnptvkHGugIQh9BQFNG9aY3H7NPiwFGM3jKluxEBUspzVdZqjFoXrusI1PgVzHe7kCVMrb3cuRm2knTZqo/S7Crh9XIl0yL+uPqw+7ecd7cNUlrGpzvsElwZ3LyJ0l5XkF95TAvD6poU+HKM/qRriZg2Va8aYVs94YdNnLRvkdMO5o2AM2gKljycT8GyTdx5pMeeCdZqelJwOodYgu60ltMCnF/NKjcvUKWDgjim5A2Vo1mxIemXPiqDQCFOha6wslrU//b8x7aOxelOfLmqWBzmzaHNUy8uBf0xYeqFa0rC7QB59EnmEA9o7KMnH453OUm+bNzw0SXVhQe2gmTHL+hdLQ1xQNnl2jlUNPvgzVqoEye1+Lnb5Ji7uu8IBBaZrgcA6JJoXsO7Dze7WoRwXT6TiiAwGSZVtWkW5FV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(136003)(39830400003)(451199018)(6506007)(478600001)(6512007)(186003)(6486002)(6666004)(966005)(4326008)(6916009)(66476007)(2616005)(66556008)(66946007)(83380400001)(41300700001)(8936002)(8676002)(86362001)(15650500001)(38100700002)(36756003)(44832011)(2906002)(5660300002)(316002)(4744005)(54906003)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rcU6BrXzS3o9YrJA4SJmvQysBznZhdWrjl1UBxskfNC/drrLFDTM06RyrLK5?=
 =?us-ascii?Q?p38/uTrs+f3l0OYVVBCUg6X14FzMvLdOpfdVwn1KgzWe63GDhiYHPEZUAnQ7?=
 =?us-ascii?Q?KGEI2SV78aoBV++vlVzn/tJpsWzaPzI0FpmvocXInOYpyFNmbqH/9i78lTRc?=
 =?us-ascii?Q?rbo+e18FcVxt4QGIgBGwlCxZncLOyYADiwX4welIVVKNDfEZdbp/f+1ISZ16?=
 =?us-ascii?Q?RSwkZUsGWvgbWaoLwceyxBtKXj64+AuzKIlWtCBlAuDa9eRJiLwfl60z2ZNn?=
 =?us-ascii?Q?Vkt3fwHbtg1Ne9137ljYW3gPoWSVLf4AcEOv4sXwn+2FL1Lnnj2zSOlS4dba?=
 =?us-ascii?Q?3XPeNhAvygpGpPsNfbI/k2FkEhRDBrc3CS+YTFtiQ9QGRl1+EQDHTopI6aBM?=
 =?us-ascii?Q?P7B/hxjK0wau70uST9UCtJtWuujbmQGaFNm5jJD7AOjkX6Vwxt09vyZibwnB?=
 =?us-ascii?Q?q3hZb9n7FeEWiYy+vEtLzvod6hnow8EawmR+t2Mx0FraBbIo7MwxT9ft1/eY?=
 =?us-ascii?Q?zfVN6uLgco6SPaZmMWdYb1hk/MIn/ffPRIL2x3R3vhLKWqXwsxJAUNbiZC4F?=
 =?us-ascii?Q?YEBegES/hULgeWPAnvNQKZuPmMacdNt/zVp1NTSkUp2S4EskMjX++zl4N2zs?=
 =?us-ascii?Q?J8+okuUpkGqOjFOjEasycoPnKmdSOO40KA4IK0KNmIAPoY/yFgvEOsyBlCFe?=
 =?us-ascii?Q?/G+UbtXjJqj4eFgT23SbPbnqj5swPRzoEy0Mw6BMPRsVb69o3T28G02zXQ4Q?=
 =?us-ascii?Q?WaPjfHbcKjyykygSmxeQtF+yQrQsBAKN87fch6xb9t6v6meJWx5LOh5Ojgii?=
 =?us-ascii?Q?695tizauLuwK0NVpGRo91hRp7W5rc/bErXJYnNa05GjiptVFJdonoYbDXlw3?=
 =?us-ascii?Q?gUjWY/QjF0V2n2FxzrwV3+7/e3FLtlcQSB2sNWB2p53pLGMRby6MPCIks8fa?=
 =?us-ascii?Q?30czfSbT3QMCGQfMqS4CIfrkR5SxVOqfR/nNnpSdfkLuHVp9yGtlnadq2CBG?=
 =?us-ascii?Q?FMFa8wJuIzsvk0N+h3nw4spe/ZL37H6b7lMuvvl0NQ6rK/0SU6PutZCNW8tl?=
 =?us-ascii?Q?cNTSCbx5FmdgPv2qU/4pFe1CZLHZFNFTOCWx2RCpu0W/SMIEROnb0E6yKBR+?=
 =?us-ascii?Q?AyDEPfXeROLnOMECQmAQNUJ1gSD/vihUbew1Q4dthHgGY90rmyC/bhL3OZHK?=
 =?us-ascii?Q?tpredIKID3OkrkQCFCedkqLAJayUNayU4XZH0sKRLpOoMpjv8nybNkFAjha9?=
 =?us-ascii?Q?b01VuS4ILpvJ9aMAi069q1es9/C0xpVs0e+/Thb96P6xciwcDYyEPh71QSpq?=
 =?us-ascii?Q?j93c/2Q5Kfz+c4mKSK23r5PVbSZI0KgYOBTuMXGeBhDlMxiObF9Troo78W2f?=
 =?us-ascii?Q?UWMsZs7enQybaQH/8iXQtZGKcTl/uhAVOVDE//ZlYBkwhht+yVqcsOHamZcI?=
 =?us-ascii?Q?lK6YyCc4FBeQYB4xxPgWHpBAncgRQMsIqT8eYZrUj3bcBaVUfTUnPtXlN8lf?=
 =?us-ascii?Q?jTzGLwIeG7H8jepi1mb3bolk3z+K6atcXNtKz+JCTMDHdf6I1Jnofc9ZkYtI?=
 =?us-ascii?Q?MlNp7fjr5UogSpq2iuKgso4lPWVck+voG8ARcLvg+pPb8SMTYIYSLTpfyQlb?=
 =?us-ascii?Q?O9gKI8mDJoCnD61wIyNHm7+dfEey6Nr5sBPV4HYCJoWHx5JXLibM2ZxAoNri?=
 =?us-ascii?Q?xlnwwQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bc5e1a-106e-4fbc-2e18-08db02283294
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 18:39:47.4982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3o4wZ/7t42xWxniQEcJBmXiiZFWDS1GgXrSWB9VCI+5dfZmMTPIBsjpzwC0+8bmbrRxFvHNJFIwsjotSMECSJUWpBos1cDR4ZbiTOLY91KM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 06:51:37PM +0200, Leon Romanovsky wrote:
> In netdev common pattern, extack pointer is forwarded to the drivers
> to be filled with error message. However, the caller can easily
> overwrite the filled message.
> 
> Instead of adding multiple "if (!extack->_msg)" checks before any
> NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> add new macro to common code.
> 
> [1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

