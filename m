Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5265A9B26
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 17:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbiIAPE3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Sep 2022 11:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiIAPE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 11:04:28 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887E783F2F
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 08:04:26 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2042.outbound.protection.outlook.com [104.47.22.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-Fh6ra7bcN_uF57AhHxm4YQ-2; Thu, 01 Sep 2022 17:04:19 +0200
X-MC-Unique: Fh6ra7bcN_uF57AhHxm4YQ-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZR0P278MB0492.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:37::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.11; Thu, 1 Sep 2022 15:04:17 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%2]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 15:04:17 +0000
Date:   Thu, 1 Sep 2022 17:04:16 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
CC:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <20220901150416.GA1237970@francesco-nb.int.toradex.com>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
In-Reply-To: <20220901140402.64804-1-csokas.bence@prolan.hu>
X-ClientProxiedBy: MR1P264CA0033.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::20) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c6184dc-90eb-4bc4-d52d-08da8c2b3db1
X-MS-TrafficTypeDiagnostic: ZR0P278MB0492:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: lkegQkCJHlD1AbR7VqpsORZCs0IQMsAtHHAdWKdrs+ugjLFkW8RYche29eRW7eLPh3GG70PN6Gu0htCh/ihKQV/FxTgFFvFPRNirMh3lTQP2nwl0QzKzPz7Ohv13XUYb8rYezBnQgNsuGbLk5fV0cHwH1aRSji5WgRC/INC+9ye3Gi0mAETb+z641O/Ly+BMRS4bNAmHLwzY2OSdT3sErtj/+jDFjHcPV0cqem/f3SGqpaWQ0xdXdlWRroH0cL3zueXdyZnl83M0jZwVWMB4xKwmDhueeqQS0zzYy6KSht19tfrdWo/0snsN97q+tmsSb2Pxfbf071o8U9HvPHe8JjnttXhNNZ04OoCwD4EQE/8Y2hOF/avEhEs+ysQ8wsP8sJ9W+NswjXCB+qWGo33BVjOsBmcxCOLWbd3BPGgqq0J5LD4+97Uj5mooTcdTvUIZqhWz664m+cfRFdDRPAWuybwBVCrD/JILEeIPte3RbTEKk4coj46v31KmB/dMLFoP+yskcSgaZU2X0NR5xWfzUoSd9ibaxah+7BwgRHuB4evVaBLT843V1EsenPZlCheOmuMf16eEtRrLEF4b6wgQyQrJjT98bxYSJOdH3cz0B+3Tg1vv3Kkbbhua1I/WH02ATu/d36wpmtotaNLi1UfP2JqMBvNCETOWovjOu3gZJvy/PUY8sh7wjkUqOgiUHb7yoxNmWb+9yh2vzeFhWCDQocfMu54vd5SW9OJ9qYwXZQUTTS6fu4Kfq33Bf/LsRBEQvCMc6zy/EaIYcj4hWanYK+TeEGViZ+h9ePzcbxDayHE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(136003)(39840400004)(346002)(4744005)(86362001)(38100700002)(38350700002)(316002)(54906003)(6916009)(2906002)(8936002)(8676002)(44832011)(4326008)(66556008)(5660300002)(66946007)(66476007)(66574015)(83380400001)(1076003)(478600001)(186003)(41300700001)(52116002)(6506007)(26005)(6512007)(6486002)(33656002)(81973001);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ipNv1NmsIUGzSilLQICZSRTF7JQcqFbYsLj4RM1PRM1NHD/xdVPnSDGMH3Q3?=
 =?us-ascii?Q?8sG5sGijhhjDrwTDIha+4he+BT99GqA7SiwXATp7VTblE2W8M94JXgN0TSnQ?=
 =?us-ascii?Q?CcRYCw6UyNX+v3u9f8bdnvatq0KfLcA3Dl6sn9d3far9OQ76x5Sl3dL5pj8u?=
 =?us-ascii?Q?DDQBxb3WbsNO/jCzVrG6UYzhrIBAlj7+vZBy+0MJ3Y91kAHUmU9zbswDOeBW?=
 =?us-ascii?Q?2HHnOSJpPW6EhZYuukNv8NfCSPKvnV+MhwcSNadrYDzsv3EVk/YMIf4IpnV0?=
 =?us-ascii?Q?+QS6+1gZBtcu2HdX7umIc8sWF3hadOwjUVkezlvoEKxjH/n9jl7kErBJHL2h?=
 =?us-ascii?Q?TqnZy3rzES6mRCGDkCUdt/nB8tIar+EJA2Pr2OjJbOAyQGZj1vnCfXwgnVfa?=
 =?us-ascii?Q?QhxxtVjHSgPTCszt3kTgn+9DCFkgmtAZjYQM2Dy/iAzRNB5kQzQLlyQuf/im?=
 =?us-ascii?Q?wwHbiOCirphhzocADypdUuEOd+uaf70e3a8UCvugJZF4fTW9ONhjw73axb7i?=
 =?us-ascii?Q?Q25JaYR8YVtXQKgb77jnsWF9fVG+pq3v4lxlY8t12cU3WnbDeB4yKUw6uAao?=
 =?us-ascii?Q?Le90yT8UX719Efu7GvU1G7awT3bMJSKdKLR/PPNwsWMi11u9cBVgR8wmkgTR?=
 =?us-ascii?Q?pLHaMhquksqW2ntGqPYS8jtpnmyPwePeafXoRZ3fkCPm08yWww3Wr11CR6Nx?=
 =?us-ascii?Q?akszN+mqYg9aeEX5OEH4iAxNSQLphZlzg8f7KNlvvFHJNwuGpGL/NHKVIYyC?=
 =?us-ascii?Q?nctUhs+1vTauU+cu8lFqDNaUOTrFPWu9P9U68vQzl/xYnNUl8WTkK5IEJSXM?=
 =?us-ascii?Q?f0aNVpB4LSJseQKYCCRKUaLiWQl2v7QF3rNNSD4yP6AVj4TrfefBbfSwyNIJ?=
 =?us-ascii?Q?zNpDiE1MTHySw/d03U0Xym/Wzu5eTzpyWvu6VdrAlxitgosW1y68NQXcPdhO?=
 =?us-ascii?Q?gt+8U8j6vmd+BbBwwnYK3+mnmwVs2PqPqixIKUDbmACJy+83JR4SnwyGhdjM?=
 =?us-ascii?Q?xMCnmoi1tGZkNP0MjUZlrMUaUAkBBf4zQ9NY0Jk9IRB+8kAWImGfqEEasWwn?=
 =?us-ascii?Q?0Nreu9U9eD5rbVXrnjbJuG0VwziOXZe84HCMkJWjlSiGj019d8WL18aQ4d77?=
 =?us-ascii?Q?4sDaC2EvdLjS1UISweQSJeAsw5TenwwwzLoqntgazKYXfFLLoa2sbNuXP/Ib?=
 =?us-ascii?Q?kMMJI6JPUrk/1+WXleDRqMqKSDbUomaNYSgnVQp3JoC8ua3CvOE9+vlWiluY?=
 =?us-ascii?Q?WLvcRGm+Usx/WBg3ehjF8tTnJMeWCJebuqxCWja44spvKs9g6K7604xF/CM4?=
 =?us-ascii?Q?a23HS3lUGkhBhSxJhu5AhkNUJnmDgZnkhru+e0qyTx0OXVukPXVZ7Qo4HVgV?=
 =?us-ascii?Q?6juEL8CIyh37Vr2en2YLK9ZhXZp+kUDHnbprSVWAFEJDAHNZ51HY8LzVy3yZ?=
 =?us-ascii?Q?3snf5X9Y7NUTYF8p+KDPKRYxYXou+HUgGi8DKnsKngPXY+S1smkY85VqiMsK?=
 =?us-ascii?Q?CxlY1w8zRMvkQTpn7+Ug3vzwz+T+K7CaZ9JdWEzCquFgZESsiVxdNHbTrkmD?=
 =?us-ascii?Q?0QSCzqjWeAV7ZAgskHqc75Ov2sou9sVsVvHubZBiNN/nBLqZ8vavUA9yH9gA?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6184dc-90eb-4bc4-d52d-08da8c2b3db1
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 15:04:17.3518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFLG43tEzv3v0lsUooLe/XqxNmZXeUMK8hnNpKGwqH6qWUqStfWpL+AkpbuRwS2eeH+VDlkbtz8mOsrols0xL+PXwE5nVZlmBC/eKYommnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0492
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 04:04:03PM +0200, Csókás Bence wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `tmreg_lock` fixes this.
> 
> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
This should be removed, there was no issue with just this commit. Am I
wrong?

One of the reasons of the Fixes tag is to backport to stable releases,
and you do not want this commit in 5.15.x.

Francesco

