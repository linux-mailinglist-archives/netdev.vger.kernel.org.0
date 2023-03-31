Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8F6D21B5
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjCaNt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjCaNt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:49:56 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2126.outbound.protection.outlook.com [40.107.212.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9452D63
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:49:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/lITqetYFh5rbnecHBOQ2kmsKZVwo5h3dfHcb3xL23+qsZx0dhFLgXfBAPl6qxW7LBuTy4f3cBCmtKpxwq6N9DCuicRZDfQ73pks5AISLQIVxsQ+FHeopRhKT6I26IK04gn2Lk4OsKl/5XfAym9sU/cXr6qMZl9/4yC8AojFiX509/DJ8ubGkjJ14ZbVqjYuMS59HVoBueXPN3Hg30OpgMvRvxF+i5GdedyegL8qWK5QWVBHegyE4EmJy6/FKkRE+JCva23WP6Awdaf0wdP/DcWMmK2Y6zhje84LbShyTmXV2tMvL2MBDpHW6a7eEx7pMobLYnxQ7VFe8T55vbpWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNgRccwMSXUietmgmnXuwoil7ThsGMceLV1/KIy1WyM=;
 b=SkwKNbF5vhJVQApy4CX/xP62Lq8PR2b41RgMjhYxqK0MDMzKJrkrjLLaxpb+aM6Gm3sX0AGjdZMwOMsQMi3BUC1AsT7MWKuIvHtjS/FnTsRb0sEUyFL0jbXOLC/cz72KOyINYLyNeNyiRulOfEYoDaG2Zo94ebBDLiJr8A8+zKmSYSZvdDjuW8jPeRxX3/2gAcBT3X7kqD0o9fMPZMv4gwJr91/6ogCab2NfQvFEYjGb58m3bQ3L3FcApdnKuycyAC37ULx5fbidksIGt54H5JPe9Nk2BBBxb9L2tsleg70kOYdp0V3zbY4CYdw5y77vz0GFKBwLbcRlqxpXPVnicg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNgRccwMSXUietmgmnXuwoil7ThsGMceLV1/KIy1WyM=;
 b=Yc4EfKVZGaI+YViIoS0/HAAoo7SWcjNlFL9UM9/IT4KY6gfwr8/Rvb6lNPKhv1+csCEA34cYo/hiE/VnXqzDyRBTYxYWvgdDPs3/65Ln5PGF96xiLW64rRSs9NDg2UyFfzWJKgSLo9uLtrHeTmRO84Q3TyYYgptBKAhTrs+Ox6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5509.namprd13.prod.outlook.com (2603:10b6:303:190::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 13:49:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 13:49:54 +0000
Date:   Fri, 31 Mar 2023 15:49:47 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, netdev@vger.kernel.org,
        leon@kernel.org
Subject: Re: [PATCH net-next v3 3/4] net/mlx5: Consider VLAN interface in
 MACsec TX steering rules
Message-ID: <ZCbk+2oblodtwSQc@corigine.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
 <20230330135715.23652-4-ehakim@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330135715.23652-4-ehakim@nvidia.com>
X-ClientProxiedBy: AM8P191CA0009.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5509:EE_
X-MS-Office365-Filtering-Correlation-Id: a610dd58-146c-43d4-9542-08db31eece79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4o3IOZT/WAKXS1VWVmZVGK1A3OyWY0Oz//ppOtftC3pycZdWvoJgrCYHTF9NpjYzIMZKBTEAPK8SWytPSlNePzokL4Yd4fNObPSyriOdKWtLFv4o2bK55t5ZnnzS+2ZMx3xIVvmf+QmWDvDX6VS4ZB40etdgHpDBrYCAujkrU67vnkT8MEl7prL8MXYHrs14iDekmk4tzJL9KIrMHIb1aMnm7w0qLDgx/9pmdxnw8V8B2v/qwuZ3OVAAV0DPcFp46ZnHW88DK+OPhDO299sWnw/sMcmmhudDJoRspH1V1mLBoAQlrHPbNR8JfEHCT1zH82TRTmmhxIR9S4wUD2e3zD0O5c6/h+ZE8MsNCQ8ZLecoyGJhsWNUNQshHZVFbdSH4QMothO7RTh3fM6eM1va+XgAdh+vtSKxQXTcYpsB818nmms6RtW7k2gCS/VFen3NgJtt3uTgL1wMPIHux98y5Pl0YxIwLtmONbDXg+ivO0SC/5fFwxHgLuongr/MKf1YusmoKu3zgOlj9/2LYMAEGb8rNx+Umzftl47/sU8nvwAzsaeObpHfxzTfWZkMP0OegSoJ0XzT81wFueeBAegskgASo1tT6Jm9zrWuiHEia3RY7oOJn8J4dbC+ZeQ5zegESEMM5c8b20eSRPldGE5cTQ+VrpnLwEvNo0EPX7nPKMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(366004)(39840400004)(451199021)(4744005)(2906002)(83380400001)(2616005)(44832011)(478600001)(5660300002)(6916009)(4326008)(6666004)(41300700001)(316002)(8936002)(66556008)(66476007)(66946007)(6486002)(8676002)(86362001)(36756003)(6506007)(6512007)(186003)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lj++YbXuufJyTbMAjQm+5n38kzL6Vm+eMiERCxYRIm/23sPostW/UyJ7OZ8b?=
 =?us-ascii?Q?KbS2TARqpLuTXGIF55xrIyJCAg8H7s4QuS3dh0ssnrchoeovGB9d7sz8SAGz?=
 =?us-ascii?Q?PdVMdnxugNyPzrKd+SF5kYVJa5RrEvL81wis3SGZ/xypHZTf6zG8AAWf5gyw?=
 =?us-ascii?Q?h9Lizx5bXwR907P6xFQk5oz967YLS4Gz2ybP41nGX/GNjNh7IgkiMD8ClG0n?=
 =?us-ascii?Q?5CEB6SP2ybAR6OAC8XB+exLSflgWKUcK8S2zNIbR627JBVN2Xv0sR9H0Y7d5?=
 =?us-ascii?Q?oPbZxcTjaWOP2B/KDLrdSTl1uzNoXEZuoOd3ZGyuLQIOKmEpF8974pAn6sRc?=
 =?us-ascii?Q?Yod+B4luruxiyEE8nXIWqFeqcZKozns81wKivZwxXbQFmXUf5QSDAYtidOar?=
 =?us-ascii?Q?TiDOwLZg03RejZzKlfXkSr28g20q22r0MAcNRpxIGVjBykfDFmcNyqaay04r?=
 =?us-ascii?Q?K6lAyTknf2se2IrVuOudRDsUyVvL6JMbxzTrSu4MMiHqY8Nke0/MsI/PNpgb?=
 =?us-ascii?Q?glRm8TQws/ZzD1Gfy/qb1Jkxh9kBQFimhekksQDe3CX+cLgIHFLM7oWinabr?=
 =?us-ascii?Q?wvaUI/TxRMw7lw1IkSmULGFG1UV6CqrgW7hgjOKM9Uz0ffRyqwCjCkSgdseI?=
 =?us-ascii?Q?uRfRuYOa4Ral5SnMzLFj9Zu5Bpwx6aauTf8GSRdFtadcHknqdSpLcsi0XcdV?=
 =?us-ascii?Q?UjKjFIX2WzpL45fza465nbUGSQu7/Y0SWB7OADuTrPFrSt/LOUlIkhvXCi/g?=
 =?us-ascii?Q?p3my8gndX3gRi3etZJrvns/wl/rgYnBvfWhiuZwjlo/h49SK8Z6qjwsieQDm?=
 =?us-ascii?Q?r2z6yDmrJaa3Ha+LXgvmZfbtNlgTlHwjd9ncZx4EW3p/6X3zP360quCQaept?=
 =?us-ascii?Q?Qml19Rb1sSyZaJcNs9ySmHqXxbPJu6jKAFYl+W5uIUFDpeKr0J8j4JDpgAio?=
 =?us-ascii?Q?qQNIFc3iRiwisr9nG9FN1twDeuVKvXPLbjJ4N5kWFmVTDRe7Oy5ij85bDFHa?=
 =?us-ascii?Q?9sloxTzoyb+KhksfotHqle8cNGmR870O5pLk31TfKJfcdyI8B7uQMP+Eby6s?=
 =?us-ascii?Q?UaE/+vuj/elK2913ub49sCptLRw6iNd+ChPPHPG9xd2LF7L3Wsx5z+p+xu82?=
 =?us-ascii?Q?GWdPzLM1eIzXreHsrdtg5Miy84syqN2Vs7QlXVyJk483QS+s48iYxSWCNkX+?=
 =?us-ascii?Q?GT/JuW+sOQq1tGgYVWGpX+iX53FD3MRCqJ9IEyaRnhmjDby6uwz9zunGgcyU?=
 =?us-ascii?Q?Rpob+ySpSnZ6CWCcr4WbB8I0R71AB+EeaQGcFvvZMqyI/KiqFKAtu0wzayLx?=
 =?us-ascii?Q?OkHEdeTx3gxVJrjU2NiJd/HD07qRt3dw0/igXDrLEU1jimiCZqeL4URzSHJu?=
 =?us-ascii?Q?UQaEwaCxt15NVjsR9HyU2cd/LWE4NUAz/U4l5zcB76kwLgRQcgtTHnXwi+pl?=
 =?us-ascii?Q?m7bAf4yrMAZD9PoUoiSC39f2TcTw4bQyjPZNlt2pzX2lqvPROZ6rVARAyp5i?=
 =?us-ascii?Q?uUSFJ19r1UNNHM7o4UzDzjAf8FfgckedqGgp0aRGgkuAdZ2lYjVO0ntuARzF?=
 =?us-ascii?Q?OZao9DyKi2SktjwL5bkvELFoewezxsnOcWeaPY1c8uULINvAbfu1/hRxZeF8?=
 =?us-ascii?Q?p4A4OvG3l0/KtUjn0mPhFAIVZJS5F+UB+pXQWuEVHmbm1g63NiYEdHhoQyng?=
 =?us-ascii?Q?NxAXqw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a610dd58-146c-43d4-9542-08db31eece79
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 13:49:54.1139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDghQ4QHNbespwREACjBKOJlqHsoWqCiAYb0WHnR3lYvJCI6ZDFj2W8p7BNZ3Q+bYGX8CsEGxxptXh3JiBAK64Ygz0fXPSQmGje48qZ1thc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5509
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:57:14PM +0300, Emeel Hakim wrote:
> Offloading MACsec when its configured over VLAN with current MACsec
> TX steering rules will wrongly insert MACsec sec tag after inserting
> the VLAN header leading to a ETHERNET | SECTAG | VLAN packet when
> ETHERNET | VLAN | SECTAG is configured.
> 
> The above issue is due to adding the SECTAG by HW which is a later
> stage compared to the VLAN header insertion stage.
> 
> Detect such a case and adjust TX steering rules to insert the
> SECTAG in the correct place by using reformat_param_0 field in
> the packet reformat to indicate the offset of SECTAG from end of
> the MAC header to account for VLANs in granularity of 4Bytes.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

