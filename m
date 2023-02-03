Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85331689F57
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjBCQeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjBCQeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:34:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2130.outbound.protection.outlook.com [40.107.220.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C87C10D4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 08:33:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+/5ohJWf2wgRf73ixxr/CZ6DwC1IWsqvPa6X2CQlV/DZK8bXVK3bzsdmGk4B9QG1WExaaBV3vtt5z+oTu7NJtDd4jbC0YPIosoSZjE3TGRRcluAYhZ7GG0IEjma8X/enwQI3wE47VSZAoFEoSVkPl8wK12PlNQhNbEJH/HT7EYKOUPf51J99oWhN6pBndpOLX0PD2mayV7+LNOk9EdRoCfdEyK/sjzjrURFMZnZPzYrrYbHDY9X0f0NmCslzEvGW4bYOitnSixTHeQR7mpz5Dv+LmbQ3k/U4YUgfnA9pwlGp/3mhZ3EEH3Jf8Splk6vf5xgCZFB8H65uwjUNnMT3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uURBiQuxHXq+TD+aygY4V6n0TVXdCGMNN9tg2FTDP1A=;
 b=gwlWrlMrmj6re1sihEB84wkOkjrbVvWuMwSbjMq3Ic7Zpg8hC3GfSiIkhTfg2Sa/8wtbf4KakFNrSv9bTagABqicxTguzwRNvlLfXBhqCcWKWI3YU3i6Mbm4EYeKfB3RitErusT7DUtnOXx2XyICmq1dGMnAWWn97hCoCa4gUuVDyMLHs6Y9Cj6I+p1RcRarnPHtkYqXBY83c4DOVLmSiUa/s0ry5Lg86ezcHPJMoDJkOb16NOZpkJ94pB3dIHSKR/UL9PgVvmWUtgS1/y2EbOLDh3P9dR2zdGGZCh4xJswn9Ti2gz5QeCfyOQT9gYaDB3Ncx6z/yW5lZLRARSms9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uURBiQuxHXq+TD+aygY4V6n0TVXdCGMNN9tg2FTDP1A=;
 b=olfI/y6UrgVoe0foAXaytJ3KVl6LteJkj61c/xL5oiRusrW6tpGsiHNte1Z9FzWpOHq7SE0INxStu7ZxjVgxtWvZWaV9sg8yZt93UKemgbffs+pw4nGRX2bDE2v0Ar9X3scDGPIp6C7ZXOnyTBWSRxPojdDoG1EVjhMgpMRiW38=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6156.namprd13.prod.outlook.com (2603:10b6:510:292::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 16:33:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 16:33:55 +0000
Date:   Fri, 3 Feb 2023 17:33:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v5 net-next 12/17] net/sched: refactor mqprio qopt
 reconstruction to a library function
Message-ID: <Y903bfubjcHxzCAU@corigine.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-13-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202003621.2679603-13-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR07CA0035.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: b8407fa0-fbdb-4b0f-e95d-08db06047133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DpGUNmj3nJqn/E67x6P+1kRKbwVilaGx+KV70OaVclzEKc2MCjV++paGsLnEulqlxNEFBUF6gTXm5wzq0ABShT6hbrddsJFoiCCgupELyaz22Qc5sY3ADnXVapf/MZzfhidng7zqotec5ZrNIKTymUcBZiC+TCGvODCFVMjxdwHFGJufgF0JpsCjLSdqfgb6OYU2l4tuQuIQjZsRZcwz9AQXPNXZhOABJCw31OKtocTR9tFqXO6FA1k8mv4jUnHuQfw+nS2lN47aReCvOFt1fxyXMrYXFRMqx3bubR+6ixVANMNmG9dkeIRGzMg3kiFaJVmftup8QQ+S1AGanDM2c1MlNUjc8+NCwPKMMWtYkMaIihg92L+3/6t6AjGfQ/JjQyq5glzRpAv83oyHVASwbdHe9LGtcWLdAic9A/Uu0t29JvNZ9p1q1N7oFI//a4yG098/UG4dE3OlqpeNz4NCAkceVNxMrTSEv3nMDtZOvYfTuJhjr1HUOvMJK61APIOfBX5yqlGg9Tm+ac/8jwLzAX+I1XBGJMEZLo+Kjtpek6Z9nzsFzNmrQbfYD6VP2ySjJRYMEp3246Vra8p+iCh4PuuGPrxRJtkLNO3M2wKAfYfaHp+iyoizoDCz/3HN8yB7G5W6dGUWGIs1CI/htCsapQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(346002)(39840400004)(451199018)(38100700002)(36756003)(86362001)(6512007)(186003)(2616005)(6506007)(6666004)(8676002)(44832011)(2906002)(6486002)(66946007)(478600001)(8936002)(7416002)(66556008)(66476007)(5660300002)(4744005)(41300700001)(6916009)(4326008)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0QuzqbIaRRu0o88Ej2q8KeoyvVmzwjUcK4BhEpWYcXzz/Nig2mokg03Ebwv3?=
 =?us-ascii?Q?yv9FIaUZ2BTUSLBl0LMRB51yXwNGpYnqNYAf2DbwkX4TqxvrKUSiVV/YiUMb?=
 =?us-ascii?Q?f0AD1buEtdVZTvA6EcZcbddfn9cqW1KFhIO5EfgeeZH7YsXTp3Y69QGig6A7?=
 =?us-ascii?Q?X5Xx9c7l3EvXTma2QLY2CZTJCXle1GnHKz946DCu6Ib8U0kRIiFTnzM9QXKP?=
 =?us-ascii?Q?+douZorknEOsBD+5vaocKsHIqHRZ1rcNpkJ+ld1QCTRZdiK3BVEqsCKJtWQk?=
 =?us-ascii?Q?SUfW1tylnl70HD6DXk5eZqLB3jQx+V13TQ6E5FIvqvFWFaPrhRKBzlPAOSLR?=
 =?us-ascii?Q?0e2GAQ4wmsgUBzDOF0Tv2DwwKI36wiRPiZugpQlX8z8RjhnZDxYZcotjmcTW?=
 =?us-ascii?Q?I4XzgjZg+b5NShm6+qh/ANKu/mrlm5Sw+wKhWW5Ag/IGEOsB+5lT6E3VGY27?=
 =?us-ascii?Q?Q8rdafQez5lVwZvRfGRczDMJIU76qxhRjaXzJEICsnAno7j0K0uEYxtMIiKj?=
 =?us-ascii?Q?Jf9xFMBQg+R+KD4/vmHgXg8S4P8M+ASgjpI0zH9PjNoTCxaiYAV3IDhxmACr?=
 =?us-ascii?Q?w4Mj3D4qmfsERp39evmIO5km8/oyrXAWWrV64x6OjjZ0RN/PVshe99fTYDpt?=
 =?us-ascii?Q?EqXzelJbv74Nq6VQXgko31kMcYuBeQoIp4ObubJkCg1XKfkHQtxUSmr8I5Dm?=
 =?us-ascii?Q?Bi3wh63o4MEFmsgWOLxrObVlP72ccvtRPonsOchC4e73y5XRa1yksG3nibdx?=
 =?us-ascii?Q?bS/mEXKhwjJR2T5mJp4Moml4gjWpmDNVMdTLm3Z79WHwVA/9D6bKJJuki00A?=
 =?us-ascii?Q?m8miP3d69egxMcwFMjEAgjqAPb6OX/pIOJWPUNz2NhELaC0SrMVwGF6T8Jkh?=
 =?us-ascii?Q?ZA1zHld9fSKZWo9LKZAJHmu8FnMlSqjKZV3E2fEKv18bj3RyLxgrgIHX8ZgR?=
 =?us-ascii?Q?/4ecSVX1+ErhoY+9k6jj6POuSqDri3WAixmdJmlxMQsGMfQop/XCjR+Z8KPQ?=
 =?us-ascii?Q?BnXiDd60UB/W7AYDj0BLEa7QvqxSQSsuvfjizZmNBp0II0QvyGmcbMK2kSby?=
 =?us-ascii?Q?3Pr+yjSJv6hpsXLkENTlHgpnJ1RfnweyA3gyJD18rAmvGM1w7K7fHrAG5sT5?=
 =?us-ascii?Q?rhYTkovm0LeJjtImrNV5PD0qK8FHG94aPxNxRI0X0ouzPJRGyuG5Hih7asYK?=
 =?us-ascii?Q?zneAmEN19KTQMcg51jiaxcXr3/9UJwWGFjswcqmLDSOaTVQCiQry9smsOxdI?=
 =?us-ascii?Q?VY0gnKJWMaaz1JLyCyzYEPtnUyXrwa40zc6bCGoMhx+foCU6faJ/et19e9r0?=
 =?us-ascii?Q?Lm1fA5vpatvHzbYD1E0Q5PzTfILxW5umo90L7nkOyzNdBoebmR0jkyKEQ4sC?=
 =?us-ascii?Q?DIsyF37hN36Bmt6APsGJ2PdGUMCBeE1txsxjRBfc1jbwCIbrwm+f8LTyVXoI?=
 =?us-ascii?Q?FzH64fvQnCUdkNYMrjjiy7BRw4DptOR0xEox773aa3sZOY/hYFPoJWqFDDjy?=
 =?us-ascii?Q?ZvD4oNojfKFi50h6b/0fJQWKW4khmQoQnE/gFgTW7w8YrHFMvnH1ZrkQCqBu?=
 =?us-ascii?Q?b7s+lKNKHxcxtL5W+zS+VaMJ9rShTNbbMT+tU0etSmSmTUv43Uu0Py09y51C?=
 =?us-ascii?Q?xd/uAIi09YrPPYZG4LHEmJmYl8fCIjrn8xCavxA8+nKe0DSnsDbeTe7Irixi?=
 =?us-ascii?Q?fC0f5A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8407fa0-fbdb-4b0f-e95d-08db06047133
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 16:33:55.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gf2vjAehqX7nSWJnq1E1r8zkJGzHRitF8zXGaqID12LAMh+peMxLahgRa0xsP/y/MXq5K+9+gw7b1mpmsIE7jbqitvpHlJehhtefPZBqsmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6156
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 02:36:16AM +0200, Vladimir Oltean wrote:
> The taprio qdisc will need to reconstruct a struct tc_mqprio_qopt from
> netdev settings once more in a future patch, but this code was already
> written twice, once in taprio and once in mqprio.
> 
> Refactor the code to a helper in the common mqprio library.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

