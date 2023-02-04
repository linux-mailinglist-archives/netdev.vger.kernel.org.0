Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E72C68A9FE
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbjBDN0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjBDN0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:26:10 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F1B30B10;
        Sat,  4 Feb 2023 05:26:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5zVF2cNqclwzsonzi4l/VCi5KxjwUpDVU/rcUe1ROk53+jO1Dd6HvLKUWE8KkdHGL3AeiCeiJxmNUGtVHSgoic/X5Wky+ntdUjaHtsjoHo6e//Vyw1XZPrEPVL2HGsX8EbNvg/9/sSwO/slUuMGaefYzKKWxzovScn3HT61S7obUg4Q493kEKuKzm5IqtN8NqwIK7vfHFlDi0n0Ir71voZcgNHbs/oXv1jUuz1M4w3v1pRca2ec2WiPL3SmbByLYG6Qo6G9NZUJC1QWZRZjW/1nd4TzFePH4kdRS7JtL/c34d9JliAS/9UYCto+kbyRP+KHVk4Un0uJrnHQSB+0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHyIETW9sfu/DLE2HOGKa8QoA4fx7dvPGoG0aCHGgN4=;
 b=UzFQxmLhORDic63G8vrzO6uOvcBCt/T8PD/nfKnRHVedr95li8Pqf1N+WqLt66FpOsCCT9S3Ca8lN4knCQGdjnkteKQHrBECe2mZlp9P8+g2YsPLRol+Zk04p0QwPp3iZTRO6PxcISZu+uGcI/ikOyoJg0AEFxhTW+GCh9pf5uj9co7ikDA6t8quqnVhxBt6P1QhR1gfVvnl81gMg34T3UFlG588TvrNkbWlxwi1ANJTNrjenNe/7jEhuHvL1Edu+n/O7LEYj0kpMJ55QiO353vtFxKpKYteiyLzhrKxBp01sSVL+obGGqJgRJ0DTot2MKV0uoPFANx99M3LbM5mEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHyIETW9sfu/DLE2HOGKa8QoA4fx7dvPGoG0aCHGgN4=;
 b=kkHsQybKE+q6Qm3qNV0FvCjzBQ/U1xf4qIO43mR6IPXpmpOz7//Tw3Y6hBE7KZgSV8O+DMjzdbgy4mcLm4txldFKwthtDosSQMNmke/Mb6/6G0yhRExcNt62MncsTpxQGOR0Z96Rift1grbF+jxwk3m0XIcmfzPvQUKs9wTkBFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3675.namprd13.prod.outlook.com (2603:10b6:5:1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.24; Sat, 4 Feb 2023 13:26:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:26:08 +0000
Date:   Sat, 4 Feb 2023 14:25:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, tipc-discussion@lists.sourceforge.net,
        Andy Shevchenko <andy@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Ying Xue <ying.xue@windriver.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH v1 2/3] genetlink: Use string_is_valid() helper
Message-ID: <Y95c58dT1p7+lXdY@corigine.com>
References: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
 <20230203140501.67659-2-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203140501.67659-2-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: AM0PR04CA0139.eurprd04.prod.outlook.com
 (2603:10a6:208:55::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3675:EE_
X-MS-Office365-Filtering-Correlation-Id: 23be529e-0df2-4a33-15a6-08db06b35fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7RahvURZ2f3R/CBEjuTSVBGG3Xp+DGIS22RXMXBHfrTHyl4//45FaAZrtaokiKwUGGbNyClmCqZ2iVljj4fQEj56lu8KMrZrOHL75gVs516Ot7U3jVVtSaUfhwPozWvl7ccXPeoj7pZ2HvzdbpQHBfCbYxx5OO4wTo8LEOjvsZUr0939gg1NJLTjH51H2GvdQYx1iFWj5oaHumaRMBmQXrvZXMtvVbA0mDANoUQyMgRKVbEx1VWADeuKOMNKdGQkHCs/hw/eG86UR9Ss6dSvyTKhRIUgaxsd3ytvNzpdnxqZT5pRSLB1koDOobOFi1ojXohACHw16R1wudysrSxVgnBbq7jF+lD0W2zjt23kj54XlVKWODOjj6QARH2AacgJVnaTVxieT0coTkqbf3pPXdG849iLVAKQmST7xPPWyIrUzOtqwgP4AwWflNTwXLDrdrvvnKaVtrLJQDGXt+upUCJv2u8J9gnGyrCaOPDmpo3ECXScV2PIeoZ4vmqh4RJgLx2GBnA9rDsv47zh154SM+eVlHhfO4tPczf9CpXfvwP5ajlOWzBDY2qTa4OhAUB2O5SszU4vIpmjqoaGB76MfwxZ/OWiggAIRPiYfbs1WlKjuaA1rfCoVoQtVIp83MHa/i9rYS70+Rl1E35KtZFDEQWJu7aD00nutL7581QI70VsEFzJj4QRGhWE6kq2/Hj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39840400004)(396003)(376002)(451199018)(86362001)(36756003)(6512007)(6486002)(2616005)(38100700002)(478600001)(186003)(41300700001)(6506007)(54906003)(4744005)(316002)(6666004)(44832011)(4326008)(66946007)(2906002)(8936002)(66556008)(5660300002)(7416002)(8676002)(6916009)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aPb07Twg1FJheY6iO031/DnwgB8bxrTMoJq6vcPkFRscwZTwLU5jIpFyFwlF?=
 =?us-ascii?Q?N6r1yD7AWwQGPmtEdhhM+nkgy1Zj/lH/IJEaIjAj09ARt40HtyU9JXTRyQLP?=
 =?us-ascii?Q?IZkrcoNrUBJsx2GA5Zc8v9+fLwEmMISurOIewmfd0XMVf5YGeP2Djt0emOOa?=
 =?us-ascii?Q?0L4muX876iVecMmt+UxilM+gUWcx0EfBlLD88ZmsC7b5vo8cm6bNiO4I6wC+?=
 =?us-ascii?Q?DW9ZMXe3Us2jYZRo55vXamOtj2ZlVAOzhCFsDalraDDEnRpmAtqoM9uvLloh?=
 =?us-ascii?Q?3ZfRv564bP+6kT/YNMuO07tbJLtfhwMd00j5sxHsn2O8qmvO/Q3n8KQW9PiG?=
 =?us-ascii?Q?807WHb/Xhquu/vvOk4/1hs+RGTF5H5QQggJdGDmoGVQGVRL1Tw3xUhBiMB68?=
 =?us-ascii?Q?zTh52zJumltSJnJ/qXP8bD+1nk6YWw5/Sy1641QBq/QqSUx5xN+tVBjQYP3i?=
 =?us-ascii?Q?OEJlK4Ssqf0W/nrASapWPXc/rDomg2V/MWEFftLTrHZZO5mQR8AI5Z5xvmYa?=
 =?us-ascii?Q?UTrxOJElpStDf4LGYhsz/bsYDYCoFzC0j5kxyePMk5Ihrhlg4CJcdlCRonxj?=
 =?us-ascii?Q?hayT89BpeTo6izyPGNakCGWBnn1eE3Vc3fo2alOIDtzNB561zf+spIICAYk8?=
 =?us-ascii?Q?+YtBDujOC4KX+0Q4KwFLxgcaDjE1Y3Zv9mUGYVAo/Rk7Nal9lhkNS7FuAncx?=
 =?us-ascii?Q?X0tvxBbOXkmqggNksO5sIozzg2IwhbDmBP9qeOOI8WIqDZhTMExGJJsH6l6D?=
 =?us-ascii?Q?aEed0/JbaYnmUPoAXDEJjrsVh7SOEFZx1UmPY2xKT8K8hvu6JurO86KF6daH?=
 =?us-ascii?Q?lgelU7Ij664XiI7pm0hZRbpq5mvnuCZBnhajjtz8yolaHyRsNFazgo+a2MEq?=
 =?us-ascii?Q?YrddlbWT1GO51nkIwBszcHVc9PVGqEeT2hNJnZ3vEeF0KZWybUsRNiOYY2M9?=
 =?us-ascii?Q?lL60gQDWiUGNVNrNK2rqekQXBAQkBsyzPyJxH+DRNBnucwDcDsFWllRebi1/?=
 =?us-ascii?Q?rVkuisfEFo1zzN//mQyvpFHPIkM6aam7UakXouwughRMWxsW1wqs2XT7yUt8?=
 =?us-ascii?Q?XA/+mduXDXI8dD1lWLu+9a/dpblZ8dQV14Bh7eWZL/CXWvMTAS2EKmH0n170?=
 =?us-ascii?Q?zVuiMogfKE0Q63m7HhU1OdV7WshP5CqZp5Q0yISIq2RPF4jgAFBDVENYnpVx?=
 =?us-ascii?Q?Ny013muyr4GwJL6wZyhudOAthzpS/G9JPOAGD+2VYhwSUuTnh4Mq5+BJUZbz?=
 =?us-ascii?Q?1Sucf4Mi0QRaT6onxYZrJh2b1j7EM897BB2nJHAnA6FoGnfzUtn/8hVkzuNq?=
 =?us-ascii?Q?HalgUlt2KD2mK+qJzFX+lQn4Ts4otefZBOfB/geG1KIUjxLUtZf1PGBLjbl0?=
 =?us-ascii?Q?pSy6sUusHNal/xZ6eqtYGCzP+NlfUT7ETKULNJDn8LLwSq76bqCMWDeHxdYt?=
 =?us-ascii?Q?QMsmnjPZbvYJJGi89vDaOSPsuiodhC5fQUCbTB3ZObUOfso1HiLmTorkLuLZ?=
 =?us-ascii?Q?SsxoeawpXByrzCHl5WyyiKfreshdVvYj0C5nkDmqsKt0IB3rh+VG/dl+LJOa?=
 =?us-ascii?Q?ycCFS7It5pyZE5RCHxRzR454Su+ZSdfXwzVraRSErRW3G/wMIQYBoC+p5V2Q?=
 =?us-ascii?Q?iRp51+4t+MqaWlBBn37ONxiQ01IhxrB8Cn4afUZXdR9j0BWhC3HI3JgCZO09?=
 =?us-ascii?Q?jwT2/Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23be529e-0df2-4a33-15a6-08db06b35fd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:26:08.1943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EsnKHUXvBhivG8ddhFPFW54c8H3FVv5ZmaiqeN3+EKIM08s3qTXcZy5YVniujilP96zPwGCUxLwb+Nw6JTr90/Wf1CxtjNTXPWEKVm1DTk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 04:05:00PM +0200, Andy Shevchenko wrote:
> Use string_is_valid() helper instead of cpecific memchr() call.
> This shows better the intention of the call.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

For networking patches, the target tree, in this case net-next, should
appear in the patch subject:

[PATCH v1 net-next 1/3] genetlink: Use string_is_valid() helper

That notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
