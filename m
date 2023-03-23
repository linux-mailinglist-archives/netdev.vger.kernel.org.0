Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFC26C6D04
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjCWQLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCWQLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:11:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2126.outbound.protection.outlook.com [40.107.92.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5E024CBB;
        Thu, 23 Mar 2023 09:11:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7U4K12rbFdddcE/zxDViPxM+Ows6kOyPd4rVpo3mG2XKLwidy2WPjSWBAE/2X63PjoY7dOk1ViCRB7pJm7cM8aIKq6e6EcBm+6NSR0pP43SCjvYxTJAiA2F8o9KBjlYh6EuyI0T39D7QI+HqLzD343jIGcWZsGuoH36XhVZrwfweESzdx4F7AD286SwR4sGc+QYdziFGILcvfOS7SY72+oH/N3V8nGFoFmcKJU8OouEEizGlI1XRRO0zu5sdOZznDyxGsEtjw311V9VYTucnmd6DH0l6u4Tk7nmj9iLxfOxI9pmLwg016ZxdoqJIS4L9eeUb773pWk36g87NeUtFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26bO0K0A4TLKrdpl/ISrQzk3AJUA0si9ePVoHGTIfb8=;
 b=gfRpsLC9f5muxOLloa0XWOm1V/+Aeqbehb/h7530cWEjOb8KLxXIat/K9arFy2QALy+j7l7XYCF87/mDf1FP6UsR74oW/Cwcw9p6EI/rLMZbezcGbxfaSxAiEvJIz+7PIKJL5Wu0KquLT9AgTHw5CcBGuPDbdmU7STlpaQiZraKKpor1vyhHjyzTo7c+k0Nnku6PkKX4Pv0NpDeu+Li4218Lgj3t9FXO7+zxWegC41VxZRJYU/HjA9JU40RrEilCMB8j6njITzQjXeead0S0drusPawS4j3bBAKtktUWnB4N0GqT6nz1RXjhBkIgWlxbsipAc4Slrpoh9BphvZtKbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26bO0K0A4TLKrdpl/ISrQzk3AJUA0si9ePVoHGTIfb8=;
 b=o7Z119MkdGrFvCDok2w41Kp/CYL+5CiF/bmty6lR9MSIm+mF598SbLi8LYFGPgr9gACcDfSvJVzkX8+B9ptoBPk1ZMHz2UcTUexguyzsn1tLZ3KViLkWZ/tw/+kkyz8FsjT/nACC9ZajIonP8Shwy6aieGS5PtuaghRpLmwaZD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4654.namprd13.prod.outlook.com (2603:10b6:5:3a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 16:11:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:11:27 +0000
Date:   Thu, 23 Mar 2023 17:11:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/9] net: dsa: tag_ksz: do not rely on
 skb_mac_header() in TX paths
Message-ID: <ZBx6KXoosEVuZZhD@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-6-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM9P250CA0005.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: 25ab5a86-f87d-4ea4-369f-08db2bb941de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WVpZoPzGfbExhAcyv2Zy8rPWF0/2/AqSm3wDmnHYc4Mfzj45y6BjrjPboxfKz2IA02akd+WWzKF47SQrRoSyvMNwLfONcPpY2yXjrL4fOpR5H1CRpiAOO3/ltKzAoCtr8aALmvVekmnLQ5AqOLJ3OhS9tk9OkJrEZe6e2UkdzdNWyRCNGeWCRVu4KYws/5uCKXfgcK3kvMFHLnXsLAfrxdj8en0IEPpbLKC1ZLB8fzuIjxUJLeaLQ3cBA8a5NtUNXDndUfVYq/kpfQFhFTj3SxnJLc6kydeXR9W95JSDPimVS2BmAXRuykIjfWWr84YMDJks1QagMOPyNqMXVcNs6HeCqViucCRYV7h4BVrhp+cOagoKJyU649FEhHAWjA7tbpyuCcWYvSTGxBygCUacbTwJUTCqnxamucMf03qoGQiScAXV4pGWrglcy9MjLQlGcRTEMW8RxyMwpGxSFNINhzP6wo2Y0eg+yXT6iyaKzp3OxEsEIWxT3Y4XCWD1Gene4UilvlMxcTx2uca4L0jVTqhuLdB3MA949gDCb83EkZ3URcyDme5mMjDcuryG76Xsy4bQ6GsKu6S3/Kn8LbyABcR4m0/YJoviJTH9Vzb4Xs7VXbvlkCtNmjcPwIhw26N9Ww2J5ZP4jxf56rMJVGB85HIf+kIsA8ML/uIJuUIfubEbjH/G/3pUJJKV8t7jlUA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39840400004)(136003)(451199018)(38100700002)(2906002)(478600001)(6486002)(2616005)(316002)(186003)(36756003)(86362001)(54906003)(4744005)(8676002)(66556008)(66476007)(6916009)(4326008)(66946007)(6666004)(8936002)(6512007)(6506007)(5660300002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0zXEsL55YWu07BWTg6ypyaUm9yGMJxco3/Bo9g537S0RJmvkSowl2m2vKMzp?=
 =?us-ascii?Q?GNa3zR/PS1r510VKkGMRwp505pm5Ioo+DNamaRIOuCuLiCAuQe5KcWEAXGtd?=
 =?us-ascii?Q?2lH6xELxVpcU+SuzvV2zVy0mh5aSwCV+YrQc3lCeuJXacOAFnk9NWbgn0LaP?=
 =?us-ascii?Q?T4mwi3RBvO+/o+j7hH8j/Vuw5R3vxW8ncFauuGapO1QHOoRPrwi2mx79FDFI?=
 =?us-ascii?Q?qZsCSEOKH+POa7qJFJs0OZmvbIf6x16R9bM4zxHpNggICGBeBuN3jZ8Il5UU?=
 =?us-ascii?Q?Z1nUjPqvgl0Eoqr3uKmfSCEi9IAzwglYGQ+F+GNzAWtI0+2IYpy9Tj1VIwVp?=
 =?us-ascii?Q?qXsoXPQj/SqGOc8T4c8evKzoGB8Y1I2z2aVhFMjOuZIRL1MHCws0CXJVCAlY?=
 =?us-ascii?Q?z29kSz1m3JfJnDisypaVywb8ZkFoCGjvo+zyOq8gQ+/HoBFamOiBKDkf+ceH?=
 =?us-ascii?Q?6/+pL2TC4FRleeNPK0cnrpkWW9qCChmcObzyUYZ5kdqyuWlcD5J4vdcvmrUK?=
 =?us-ascii?Q?lm7ATTt5/GFUKbZkUKhimGm+BoPYPXlMrzJGrUpfqAc85Q/gpRQng7PBgA9F?=
 =?us-ascii?Q?Q7nG+EsnHR32OhEkg0lWvAJgPQ7aSLhsR80JXVjGVJiWpHIeE2ee4JIiPVmk?=
 =?us-ascii?Q?u+Zvg5EdZIm949eFqgcn5sYwsAmSh8vZ/tX2HUT7L1zyfKJUN0D3XE0V522a?=
 =?us-ascii?Q?rFUomTfkfn7PiSazPYva2UvL2IgRhKA2mio7s0MIlwRsj6q7eK55Z09NqIf3?=
 =?us-ascii?Q?fAbH7gWe9JgpyxEz9lrbWDzbRBdVbIoZHC41uqpZ8sYRndQJZ2g+ooa1HJpo?=
 =?us-ascii?Q?bQmxr1DhlHHvIzVdEPWpBs15eMxxsjTiA4+Kgt2M3UMKaOyV4f8kppr39NCF?=
 =?us-ascii?Q?uZmvTsvCwifWxxUWpfKCOu7PGec+V6hbg3EuK3tSnyl4GSrCSoIz+N/tg9nZ?=
 =?us-ascii?Q?5xQ8b8dmyKTo2G2WjsXv6zvjyM3jce4Zr1ehwbfIsdaS9HVFaazBudW1p8Cb?=
 =?us-ascii?Q?eMVUc/QAMznxui9qpo9/XHlf2sjM6yKLAaSowSmhyx8E2JisgeFLcUIXJAVu?=
 =?us-ascii?Q?JTsl6cxeEPeKxGf9hfjpPZ4hiptoXEC9xhB2jWO5M3N7bBNiwSItosFMUq6b?=
 =?us-ascii?Q?MJDhKVZafaJwR2BHrK07a+f9298X57DeBflNSOJM+//QgOXnIaLSEgmx2f5u?=
 =?us-ascii?Q?F7Als2WAz0gY9gQ1Dw0bvPCM1Q8QSUbThbv0CKZOBPmWNeTSwGKyeBaDXWIi?=
 =?us-ascii?Q?HwI6IbXU2SSB/LCsF7E9tjhb7hWcmxfLH/CtrPCb76HYzImSTuLLJcfMD4Y8?=
 =?us-ascii?Q?ShwSAtOwBh5UcNOCuuSqrGzP5yVIeiDYNbxeW0f4Z/syF9ez/VQx3YwQlM7F?=
 =?us-ascii?Q?cIhEbAgyP9N3YUuqI0kbBZ0BSweFjUofQApmXZVWAGIQqul1gRw91W6NLqGt?=
 =?us-ascii?Q?XBjhImBLKUmgOuZZe+2jvHJbcCwK1mYFTbvIZR+2v6xUO0S9OCJQqzmi1IJg?=
 =?us-ascii?Q?VtFT3taRFqUhD2Y0t4FX2iK8n2vQyNCam7mWpW11oDZqVez4X5Ri/GDXu2yL?=
 =?us-ascii?Q?VFsbp0a5tZraersjK/E/mGQZ/1EWZTtFEF5dgQ/aoOm/xwnag88tMmnYn/54?=
 =?us-ascii?Q?WtH9eimJceMpEd+gjav5eaNG/fjzSrX4EAtLm5QZReyaFtJw/cBLtcSXMPbV?=
 =?us-ascii?Q?43wTgA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ab5a86-f87d-4ea4-369f-08db2bb941de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:11:27.8658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+2zKmFLH7f+aeztEkAB+gd3DRi9sqqDctbFDtFNRpX4cGRGOExV5NFl1J2x56g8T3J0Wi68ekbIGB9xPLfyz8ANyh2Fzl5F++XdRKImXIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4654
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:19AM +0200, Vladimir Oltean wrote:
> skb_mac_header() will no longer be available in the TX path when
> reverting commit 6d1ccff62780 ("net: reset mac header in
> dev_start_xmit()"). As preparation for that, let's use skb_eth_hdr() to
> get to the Ethernet header's MAC DA instead, helper which assumes this
> header is located at skb->data (assumption which holds true here).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

