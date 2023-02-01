Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC36869D1
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjBAPQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjBAPQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:16:03 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2092.outbound.protection.outlook.com [40.107.100.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14C71259C
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:15:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvw0jYlj22pH1VcIw7L3G3rHkOJFcj81KoAx+zB0QRc8PDEPkEw69hzUoIOXrBN8va4ohYRsJKi3tXzp9PjM2JMmH2PrLHhHXikIrt/Eu7yh8rvLqXLtKXnn6hkwK1IsjalFsdVVIQD9gX7PIrWEnnWvy482/nZYNeKsLOr6qE1xuo+4dRv7VnchGIIwZEhAoQi7gwLcXigXJPddGx6Ja+rA9KgYTNYlFwhzx3v5Dv6zB9GOG4SSaU4ZkHTjTI/xa/tSR1j5fIO/WYi0RlcS//YiNWAkodGlG69Y7GcjS/7jpMZyPUxpDALzVBK1BCoPYvFhXmr20LGnpUJssrQPNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qb3vUS3jAAoiQarnznTxWMwXmNVQ3OcPa8NwrWwAaU=;
 b=kxgHq1Rz0J5xYbD2OyK2pCnboY3zCxtr4kkXZ2ldhANhup6120HDRSYkr+dz7SUYW128qI6sVCzkfQdaonV7LLhNsnq3QW28z+v9AUUHZKki3PEFkk5O79r1eJoyo2kcAmyiioY7+ET15kipPwEMIg/8Pb0bS16xdXVA1fVGryDBUXu4yhD/jAka9+2hLAv0Knie8292akGnALdO2L+3tHLWQr1iEYrJe8TPzC96tIgb+v/FUpA5ceKq4PqSCYXo4/P4GmwIiEu8vlgLAkyZ8YMAPVxa+lsZWiUiWXDmeua1xZMEhNyyvASFYrzZx8RBAYEBRKn/CGFcidPDMRrF9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qb3vUS3jAAoiQarnznTxWMwXmNVQ3OcPa8NwrWwAaU=;
 b=i/rPnrqjhM63hNt/7C0SHf64Tyt4icn2jk/Eq13i/KeJdsFHNGbDDxqyCAUb+ylBJrfhXrFy5TWHkZB27E13ij9/N/cCk1gcn5kaP73O9F9vy6nf3Hz8VZ7PgZvg5n5k8J2kgffKQu6AatwNRNUD37yTD0jdMyttRHyvz706K70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5719.namprd13.prod.outlook.com (2603:10b6:303:171::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 15:15:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 15:15:49 +0000
Date:   Wed, 1 Feb 2023 16:15:34 +0100
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
Subject: Re: [PATCH v4 net-next 11/15] net: enetc: act upon the requested
 mqprio queue configuration
Message-ID: <Y9qCFtb6RBUZ4+Wj@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-12-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: b11b133f-50b8-4603-b8d2-08db04673318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e602t84rhzRNFsFMAebuikEr4JuPmuakGduoXB+yB24VGkRSAkfO3dNAae7pN+sfgWTvJs327LAwPR/dljkmMR2ya/ZLjEM8ipdjGt/w105hf51dfFUvsmjE7ZZGLDn3f3FN6ZjOOLIysbKrLB3rt6KrWmXxLD2HL7mEPo2WouidQk/adKZ8Z4kEfxfV/E2Gs39D3ny/ur/ZIrSiDJdGIrnZUSrClcS/br0nOtOenL0BHUb2WQhrUaXi5GnrmTeHYlYz9yqDQlZJlDTvaMAJIK8/ke/fs3/ZJlJKAmd+KqSZmCPGTS7KvG38n9EbEl949AE6uwNklY0I+PN9jlZpcRiy6QaRVRV6c/XwPkPmqBYFV40fZSEETUbvJDbljNp5D32UikugI+zJTh3OQqqtpYQnc/gdBx8K8MCqDqI3HbxFdb0G94Kde3KqUdBM3BkKLCpYeSJNGwkWzURQfeo5AtN+dT+pORFlzh36hKDCyD03gFvAMepvxbseRqm6QywZld3Y3y8i6ze2xyypJNtI1cB7oShkkds9ujcq1EvdBUFSJ0zwf4Ik9ddcPpejpf4UKaT9jcpWQNGt5eD0SDKYUgqYj3kIWmhfq5476jdm8dmMdoCML2b8CrNnqZMgHliPvv6QNTPJ+Y5BPZRJfBUKgtV6KApQUq+jeJXy8ni+InqWeIy72JoIrUOI0S5h7FBFGhquKOqEQvEXz/K+bSeHYLgUGvkBn09tWQsImwKs7PBQrSTAMvcLw3QcmCFEXDx0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(136003)(366004)(376002)(451199018)(478600001)(316002)(6916009)(4326008)(8676002)(8936002)(66476007)(41300700001)(6506007)(66556008)(66946007)(83380400001)(6666004)(6512007)(6486002)(186003)(86362001)(54906003)(2616005)(44832011)(5660300002)(7416002)(38100700002)(2906002)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5H7hvHKMAGsWVkLRt3yq+/CSpJFJ8rpOcjivc5dNj9YJ1Aw8m28wdst3faP4?=
 =?us-ascii?Q?0gXB75tBEINnQBvSc1PGj3M1xzJl/7q2thnXmzYxEDtYOZfAfWZqyEmTsXh0?=
 =?us-ascii?Q?2FNi5XoKU9c4K3M00+pmC8aGcU+n+RJHC7dj3VqBAV+hi/tYS6WCdrC0N5Hc?=
 =?us-ascii?Q?B+/mGC6S+ivkjTgPng568naIZLRTUFNwo3rgFyT4hnNOTgv2J7OsPzOCsDkb?=
 =?us-ascii?Q?p8Bzl1nW2jJXbSsAS8o5xtjhv2s/K1N5CH2k0UOyq1sFmd5IZXtjHN5+4aRJ?=
 =?us-ascii?Q?KVcwj5Z6RccL8MR16FrszYLAXQHCSNFBfhRizz0Qwi1oti7QXSOWximbxNYC?=
 =?us-ascii?Q?JiWRCugvha2j9wJdf1yXrOhSeFTa2xQuYQ4xziPLmZTYUoCrBZJL7J8/aRR0?=
 =?us-ascii?Q?6cZpALkyGZtvlBoTe0s1ZEXEjsxTqZpSB6BnrmFplmrwzlT6tTcWlartZc/M?=
 =?us-ascii?Q?kkrCoQq5EaW8DQbf6GpWFo29vxzAZq16fFDMVUd0wsmLnaAgV3zhrsgTw2ZX?=
 =?us-ascii?Q?qxGKLdcL84UyxqyA/iDFDYYQ3nzDqCJqQGRI5BOJrBCb8S6pemcvMqJBi1Wj?=
 =?us-ascii?Q?8Vt1H9Uh9dsgErYOJLq1VBLgJcIXJRucbBzD/4tX12qXLISNmlPLCaKpZOai?=
 =?us-ascii?Q?zq5yel1VcSoD3XyI4O5VVWIPHhqxKvEQ4I5U2rVT+CxD4DC5+utQZJfWTK6f?=
 =?us-ascii?Q?EogwtsNpkbep8ReF+ngrMgYjaVRckdDob2VsyWYHSsd5npXFEWdBGuJzT+6A?=
 =?us-ascii?Q?Enxou6gXhRnNk51t2mjdaFQV5oEJnnJ5UgbIk7qu8P5UlQNfp1SxbuFCDijf?=
 =?us-ascii?Q?PzAcAmWOg+ApygFLnSpBosM4l4JB+SykaXw99LQRtz4eaRXY/PVAjh68P5N9?=
 =?us-ascii?Q?j7x7N2zzpNNgRlBuXhs1kcTPPT65Dbcz7DQ48lyHkEVh6VvP+P1NC6dIQgTe?=
 =?us-ascii?Q?OnAWaoMduDwQtcpWP42i7BOuOkyxcN2NaWyv09ClxFhGDCDVL0JKmoXMLJxJ?=
 =?us-ascii?Q?s2Cq5VzcFI4mDp7kJxiMhy6wa49i2ZGSIUk7fYe+mfggAApTeLlygCR1d+3Y?=
 =?us-ascii?Q?ZXI87AUfphIKHon2AUmKAWh1ozHAaUzCL4MQrSaZR88hF7OBlMBV0nVOCFlu?=
 =?us-ascii?Q?/+3o3CuvmMnUusK6gyaoMKf3JC/K4QxVS5aqflwgbTdFq8Kn94LJjBogkosW?=
 =?us-ascii?Q?+LTx29SaqzbkZAHzlAE7hGHUVa++XbZSYLt+feBcsxwa9sAgAKiwR3v7A/nc?=
 =?us-ascii?Q?osN2+nyjpxNT4IoP8CQNXpGdgew1zV2PYRHaIgRlmCwlKvYluGvAf+bEHGTz?=
 =?us-ascii?Q?gku5hGyOCG8yyMAekCf30B9SSaEbCAuWflXwUHsT6++4Y7CCOpduInvNVr13?=
 =?us-ascii?Q?nSKqvbK0r9fHRInD2p2YCSUThygu7hMK1qzCLy+p9x+yikR9SXQKCJ8w00iZ?=
 =?us-ascii?Q?lzEQcxrEkuEevLqWwmMvVgvuiYVHHFRNCtlc0IjkojwmkOB6vyRKL4j0wM3e?=
 =?us-ascii?Q?zeS6APhxyvqalLa7308FFbEHWX/LO3XBi1bAqTGZA97Ofw+BLum8Wqwogh+f?=
 =?us-ascii?Q?NLTgwWftvvzRwLzy0JGtq1xfhzcJ0a/JAiDusY5jJE/ljd4kwtp0eynFb6+D?=
 =?us-ascii?Q?v1Q9vr/4P5YGPLV1nzC14GmwgrhY6zKzZeQtxjb/k6tN4Om21YlxFnGDFgh8?=
 =?us-ascii?Q?QxO/1w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11b133f-50b8-4603-b8d2-08db04673318
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 15:15:49.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miKesCvu9HUJ45CSaf4He9caN3Fjg+y8doUNo2/1yLyZn2A1rJSziHacICCfyDsfM1gD1BvNLpVGv6S4KvbugS9EMttFTXmJ7r+dS3sWGJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5719
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:41PM +0200, Vladimir Oltean wrote:
> Regardless of the requested queue count per traffic class, the enetc
> driver allocates a number of TX rings equal to the number of TCs, and
> hardcodes a queue configuration of "1@0 1@1 ... 1@max-tc". Other
> configurations are silently ignored and treated the same.
> 
> Improve that by allowing what the user requests to be actually
> fulfilled. This allows more than one TX ring per traffic class.
> For example:
> 
> $ tc qdisc add dev eno0 root handle 1: mqprio num_tc 4 \
> 	map 0 0 1 1 2 2 3 3 queues 2@0 2@2 2@4 2@6
> [  146.267648] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
> [  146.273451] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
> [  146.283280] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 1
> [  146.293987] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 1
> [  146.300467] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 2
> [  146.306866] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 2
> [  146.313261] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 3
> [  146.319622] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 3
> $ tc qdisc del dev eno0 root
> [  178.238418] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
> [  178.244369] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
> [  178.251486] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 0
> [  178.258006] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 0
> [  178.265038] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 0
> [  178.271557] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 0
> [  178.277910] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 0
> [  178.284281] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 0
> $ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
> [  186.113162] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
> [  186.118764] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 1
> [  186.124374] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 2
> [  186.130765] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 3
> [  186.136404] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 4
> [  186.142049] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 5
> [  186.147674] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 6
> [  186.153305] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 7
> 
> The driver used to set TC_MQPRIO_HW_OFFLOAD_TCS, near which there is
> this comment in the UAPI header:
> 
>         TC_MQPRIO_HW_OFFLOAD_TCS,       /* offload TCs, no queue counts */
> 
> but I'm not sure who even looks at this field. Anyway, since this is
> basically what enetc was doing up until now (and no longer is; we
> offload queue counts too), remove that assignment.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

