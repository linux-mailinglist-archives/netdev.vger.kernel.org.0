Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D57E6ACFE5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCFVKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCFVKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:10:41 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2137.outbound.protection.outlook.com [40.107.223.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE2E7D561
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:10:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sz3CTs99xxdGyQzbXVCBllvOs/K09AIHX9D2zdzfgQGWGj6jsfwxRkfKsycix2cnZMJNEL9s3Boos1SaIULPk5R0xLARnIkOkH+3a4hKSIYywTl1YKoGark14z810o0SU8cbeSf/PgnkXQ4T0TGEh9tahyJ1iPD3mEKYoUnUzHBy/lu26K4gPbTWcbFBC4RkyFnTPvqS/EfuttJInkSxCkgl70mPBlSl+J0VdDBRxGXn7b0jRXqL7xbE82Db1iH4JpMrur0oIGa+4Kb56YnCn+Ncf6PH7FhmHaN6HFD8lmzWb1duoAm77pcJ1VeDmHJ1yfv5I4UL88SDHwHTuWWr7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yjMlKoAvoXBpQ94kIWcMa6Y0rjY0gEZ43urQk1yhFQ=;
 b=To+Qa6vbxsdPYViQ6vfj5LJEHMMQK8Ok8d0g0dpn6IP5ULv/087CnK2U8/SqzbO7MOcuBcaLfVurxnLLLuZnpM6dKBXxgHIPlY4N3cUNemxSOnyZfE0xztS0kzjLkMSRcEg/t/fPfx/gNNPBoG51TLsS23l8TdlRaQQXWFgeh1Sp+2LMkGvorfYINCa1WxU6zV4mp7XSzzvaWdUWH0QuGT1gHvEemo1DMvjuCRZHSyoE7x3BPfOu4QmKlHpZdwA+MpxGkmnvE44BKBaWWky2+Kmw3W0Pf0TmLKJqJssDnN31UdhzEnZrZPO5+Rg5dPWpGG8Z5g9IlMRlH322DG04UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yjMlKoAvoXBpQ94kIWcMa6Y0rjY0gEZ43urQk1yhFQ=;
 b=koqYrFGnPdI+dJzVjVrxhcDyLZWLHuADH4KAjt9VTuX1VZHVxue2K6q5m/NDzcgDKr1bgDXWBielvUgYaoyJ4kVG+gSNkSwi47Gg1+xKH5ZRTpfpcEbTotijhchyc2igGmBthSYRWkFJehrrwzEotUzb25aU1P37Hisnd8j8f6c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5790.namprd13.prod.outlook.com (2603:10b6:806:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 21:10:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 21:10:18 +0000
Date:   Mon, 6 Mar 2023 22:10:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] net: remove enum skb_free_reason
Message-ID: <ZAZWsxWkSURjyTjo@corigine.com>
References: <20230306204313.10492-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306204313.10492-1-edumazet@google.com>
X-ClientProxiedBy: AM4PR0101CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 22709279-4e19-4064-f33a-08db1e87302f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0oKFMtvuNwx16a5gafomQwe+qnfNzy7/YDzHtHtVDyKRuQotBFJvaJHn1w+MXC++NMPnR6ARkJWjU9a0iRdaTUmk/9x4Zp1cDwRXrBxlOw6kU/Zf+vGocU0S4KDGK5J0KGzO4BwL41bk0ROkAdiSBKjQAuFWQtcAWEUXUfHlbOat6DsamnBzbYDRMEQN7TGpz38Ok2EfjmlR/7u1vU/d0C3FuXs+/Y9iwZIrW5U+5vnMtanBgjzQbHweh+OV5qQ3p/mdwqwFGqYFmm2BMrhZFU5EmOYmPdsvtb6doQ286UaQUNsu46760oloYmcqiIAnNkUGHJomYW8p6rxJ9U5WJSdVYzfl18eOWIPoR84NftzSlUjotLSXHJz1z4sYUjLLQ0FV1p1uQdzVwZcOBEiBEM9psESNVFIkhaYYSjmcbWhEGWuc7n7dQi4Z3zvJFEeJ0JTa9GafF819T8ksCSe+/cf6byhqswkaUCyWf/ePocMXqaizQF5t6appx4kXkLTW197imarBDaROcav4m3cpDexvNvC7lchz5NdJ+9PHSRbBnE+7sdTwUw7u8DFDM6Plhl5U7FwF9LS35pdZw+M5/9oujjxlzDMpwVrd1EhHKz1ox8PzEXOFzwr307vEUZ8ZnPfoSYdxpspNuog/oiEz1uHKwYNBN7G9Tocrx3DZUD7IKBzUYvmEnqAyFGnJ6an1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39840400004)(376002)(366004)(451199018)(8936002)(5660300002)(41300700001)(4326008)(6916009)(8676002)(66946007)(66476007)(66556008)(4744005)(44832011)(2906002)(316002)(6506007)(54906003)(478600001)(6512007)(6486002)(186003)(6666004)(86362001)(2616005)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nxdqCIs3CvKFU2F+3dMA82rkjGqA1iWKVc1LkWtwD8piyahKzFJbytg9xPGm?=
 =?us-ascii?Q?0j0ur0ZIgE+SzHzWZK4+uQVngeTt+KvMKRMKyIu2viGQe+zO+WrdwkMgr9G9?=
 =?us-ascii?Q?Zf/cfYuY+C9VoNNKIpSOQyeWaN8a+SOT+2fhUPKk+FfKEMPsfQCbNRmnTL3R?=
 =?us-ascii?Q?uQiJ3E3/bHqTiPOTaIhwlit4YK6AeD7kYOg+iNzj59V4QboeHSeVIX2nub0U?=
 =?us-ascii?Q?TikoI+jRo6l47Ccok57AstkIYzqP2IwHM3zDTPvd2HmC9JpFe1L8FZ6K6jkU?=
 =?us-ascii?Q?cHUCbCQ0BqFsWRaG1G6NjZK6se+v+K7tx0D+BjiouZhoJRQNN7qoqyOR4Ev3?=
 =?us-ascii?Q?YHE8c5rDxVI39LCYxK1DSmrisev7TB5OrMlPZzS9XPCwtxRD42BnVOetFhTf?=
 =?us-ascii?Q?kLmLzVGN44JPoioMk3kEX9iSAxH0pytwwj/QRdOav/9I6oTmet6wjXMlxMRq?=
 =?us-ascii?Q?0wIODdqotxxh0LJEvmL3kfiErtc4//QQKrIHg2x7eZ87CSqdmrmswIIzx1G9?=
 =?us-ascii?Q?abb4NgHTpzQC5itkTi4Myi2hHyt9Yj9rL4w1l3vlUWbndBM7mAoE5/gVoDaR?=
 =?us-ascii?Q?DLTnv7aBh+ddtdzTFwFs9v5chD+/d09A6YfKPvNNNLjWnOlW7KCOeXYQt/7h?=
 =?us-ascii?Q?q8IIXfC3+D2cPUg/6q3o7eTSVL6q6Jax4yQUuUsOgShttUHCk73pG8p7ek+T?=
 =?us-ascii?Q?D0mBaZhdtSSOg5H3iQIzYS4SgoNnXLgRzIRZY2Z5DEvK90prFdHDT/fCzJT+?=
 =?us-ascii?Q?k6I8AW8cL+03NvcAOOueG6Baf+iDgqjewkt7bgDMgBY3K2YRb6TVYs4YBbDh?=
 =?us-ascii?Q?JNJFaL8RpmX7jf9H96nD4VMHkFpc00kcdb6FIHLwGcnV8JU4Tti5GYIBpSMl?=
 =?us-ascii?Q?YuNBaByDv58Sbnr3U9dJDSYEDI+iAzmaPww92ibFmjQqpKmhEGhiS/CB1XRI?=
 =?us-ascii?Q?PrErZAX720C5AfbSiMJ7vmgowVNjXyLClHw1h0Y4Mdb+7dQ8mtxtsb1xQAnC?=
 =?us-ascii?Q?6x9tb9k3B/CXEP8A6CFO+tFtsey6Kejxisor+d7w1tn7vRRCMWacV9f3Ry9j?=
 =?us-ascii?Q?Gx0Js/cnnZIgdM5BFpzNrUmCFcrVc0jd6SkazdyLVgcTrkqL9yBZuXB6/okP?=
 =?us-ascii?Q?bb6eBzJQrWxY107AIVPXYEX0JnM+6xbTuNfNVXzAW3D/AcjQCGyUMDlxi/Hw?=
 =?us-ascii?Q?nF2/+6lBx89q42zzsfQuM46O5SUgX1VX2nQSSMrq3Y1ucY4HTSx+zw9MYydv?=
 =?us-ascii?Q?rQxcKI9lWDZmKq+NrAH4ooynbq6cf6mKO03FcqKHbPLIsRO7P/hKxvAiruEn?=
 =?us-ascii?Q?NDdsF5xCiZzt7VeZ4gWjV30ivBNesokTUS171QUdmCGeQ0JVsta+/PW5fEx8?=
 =?us-ascii?Q?c316hZOBCSHFuGE0s8qcpKnEzxwW/NHiRWyZIN6CkGTPt4ltnipqbRLgCUNR?=
 =?us-ascii?Q?Dvvpchl+oqUQ8bPqfeUNEfgqwdpMhxGO2tVcSW7kuoHij9xHdyufN7X2lyvt?=
 =?us-ascii?Q?cjB6CrvWLs4rIZIUuJPCLZ/h3zXrx0fg4pWaC2NAOWiHKMo9KCHwCQvU7oBz?=
 =?us-ascii?Q?GQRCEg1z79evrz710Lwd/IXo5gFNmJ9ksdIilBucr3VQbNAh7WSjz6mj+vSD?=
 =?us-ascii?Q?668WGG/eHNc7Jf0pDO6wFQdIsMBP/stESWQdztmUhQFAwM3z2SwZhNwPK7PG?=
 =?us-ascii?Q?1vJTmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22709279-4e19-4064-f33a-08db1e87302f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 21:10:18.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dm9imrNqI/yvfP1Q5RwrQ5QU2ooxCwaiGwAITOTVgSo9o8cHOZiUP5Jfqeq9O+D8CAW+zL/J0ImRXlBHSsSOl5A+gEHVi+biB/aIIEvqwEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 08:43:13PM +0000, Eric Dumazet wrote:
> enum skb_drop_reason is more generic, we can adopt it instead.
> 
> Provide dev_kfree_skb_irq_reason() and dev_kfree_skb_any_reason().
> 
> This means drivers can use more precise drop reasons if they want to.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
