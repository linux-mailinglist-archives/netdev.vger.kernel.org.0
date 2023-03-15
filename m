Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE46B6BB8B4
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjCOP4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbjCOP4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:56:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2102.outbound.protection.outlook.com [40.107.220.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203B07EA29
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:55:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONQupuq89J9fbgTrcebDWPbQBmmctRBs7GiE21F0Kabq+/mgX7LI/x63oJEbIQseGdKTCs8SlxZ6RRq31vzp31Vf+fBy9A+oTBRbHp6VqxOxDpuVw7iZXgXl+d+La9idq3uAuzEEvsBf0DtnYiopIs0yaNADHa3iICvZwvqPPl9EO381C+fSJlxCfNsisTAKjHbKXtV44H5M5NI+8NQsMF5+OpDpctXTSBKjyX3Q4iSAratqmb5xzpoxFsgDawTqyiBEF2F7sq5uzPIKu+bz6sOah4iBewW/kmluK9AYDp/4DvtTdzztXnJY5StogMcgyv0UZq+42bleFoGhvsuzBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1LPmlXZBjIWjOZVxVmYt7WhTAapMjk5a19sEAJi4BY=;
 b=D8h7uNJJKEAwLfPQqeqtHuM7w4tpjnt8cn+bvnbBFZE4y2tLE/mF/LJXU55Gq4g/Y6F4RJxtOzidkgWOxTTDd2/QP/t/t9cSwg8W0yP3XNXT28bUcq71y1NvDID2UKITPtKb1f6spLe5Oh1wwH9k0pDLITlXOQizWcfmC5UL9Q1jRgcOz0AAlvcudBKW8NQrz9LTcd55993R6oV3WPBZYhY6Dp0VLFSOfWKxpMg06AC012bQBaur67TukUQKXbe4wZi1poh8AxEhP7SSrmQNHyYw3Fk/u0kNHpSvK/RMkl1XeKsbPfMgXCb3qjX83lK+0Ef4xPRxaCe9+n6JMIsRCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1LPmlXZBjIWjOZVxVmYt7WhTAapMjk5a19sEAJi4BY=;
 b=eVUcvhjy344lprWdhL9i1SMZcPvpOCQ1XCaTHQkSvNYebQAp1U+vHqDte/IwdZEalMIUMDI72grKFcKITGDSOOFsqWZr7PhSTzs+GEAG9sak5MMjMoF7/TuNdFDvKsmoxPWKOvMgF9CFnGmn7WFyUEj00NUf3HPyF8JpKejWQps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5775.namprd13.prod.outlook.com (2603:10b6:806:217::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 15:54:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:54:06 +0000
Date:   Wed, 15 Mar 2023 16:53:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 4/4] net/sched: act_pedit: rate limit
 datapath messages
Message-ID: <ZBHqF7ZMs2YuksbO@corigine.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
 <20230314202448.603841-5-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314202448.603841-5-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P195CA0009.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5775:EE_
X-MS-Office365-Filtering-Correlation-Id: 636a0dc0-71c7-4424-3713-08db256d81a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Ftq9sCPDd+YoRDEM9eDSEqucU01piNtDOoGmVTWX5PDVnbwroUPTs9RixPyXhqvsLlLdHNqNuBgm3oivG+QcZEtMZA8XkW+g4iEMPEF1hhkeFgCR4M6yfnhEvWZgHFRX2+r3xSmRJLzc/q4vWzBN9ZEB5xbr/wPHg5qv58Wu4mhnmVrHh6vLnG9/acDJA4CyfuVGTAdexORj6jDKaZsDCUluDcbgpJMvGemRLrmtxTxq7Fvv03VfRk+g2BT8ftA2aL4Zl1+2qJ+ESzmjP18aHZFNE9WGNtUbZu7/2/FRKoOrb/e8T6XMHDeNI+oF90Un4xTtbpDYsX3tTaHv74PyUEEpQfT2G113iSRRUzRU4eEeD5zFUfVY8raCOgONja/qTJvjVu2snTB+uwLQC8l9li3MrcGia1D7Ks4ISk//ba6zRx59jaV1JXavGXFgPlWbVcYAl7FVki/aCH6+1cKXgQ9fhe2CRG+6XJCYenCoaZ1xACmxVz5l/F4zYChvlZ14VUt8IF77DxyHSHiLsCCcYgmzwRwB9RAcgHzT0NNCk8Gr0dVlMTRxNe2ZQNKXyIZyqLps+xGxZ9vF7ubQKBUb/LAiRGoml7V4sHPpjGHCeZDbhiOlytNxsrFvfd1ZWPavEnWkQoRSJmwk3N04uuZAh28Xwx62f4pG4Ah/Rk03YiC+lz3gMHvT36dWB6fRXLU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(346002)(366004)(396003)(451199018)(38100700002)(5660300002)(4744005)(8936002)(41300700001)(15650500001)(2906002)(44832011)(36756003)(86362001)(6916009)(478600001)(66556008)(6486002)(66946007)(8676002)(66476007)(6666004)(4326008)(6512007)(83380400001)(316002)(2616005)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UiRmlo04Hlhp8NE46tqjaegWZZYk2rNb+qT5qrxE8WpJNEi74r7c04D6p7vC?=
 =?us-ascii?Q?2za1W6xA/kvgq+sb844037z16MtG80sSMo5Z6jaNUJtvdGcnjRhcWDRYggwf?=
 =?us-ascii?Q?qw7I8qKQrazILmp3qO1c2cl29+52rr7lvHFg1ysdSZH8NK9rvNz+GpO5HiO5?=
 =?us-ascii?Q?AckoZn1Yjz3SZMOAh7gLeeTLoY07B2q3BgaNWKbHRmYiJzQZJvDmdlAV1dWf?=
 =?us-ascii?Q?6fVv6Ci/BmNTodIMC5F/29wKOp72ySvdfe8Cg6l1yEcd2RBDqc5ml7Hz/zQn?=
 =?us-ascii?Q?8wRdI3Kx4qStzuUlz2/XqAaO2Vyp87g/Ju4tai8jvC7MuEVc3fzhLq08NGOf?=
 =?us-ascii?Q?dqV/ZsT5HyhuyxBDuqaWwfitVncUiF64ASJkY3/iCcOw7zvgU+kBK701vox2?=
 =?us-ascii?Q?PpZOsHCPxO9NUp+4hucQPtBCBgu5hXSQjk5hVSJhE4X8kQsAnP57yVLIAS+A?=
 =?us-ascii?Q?8gwXoTLylk6NFZsOFBNN15hTme157ZVnlkWZ+zzT4GNzcObfQS9/qefSn9TE?=
 =?us-ascii?Q?DhP58gtHtzK+A6vbii5C/Fb5bOD2zrRQKEPT+953uHsTjr5YFRkVXP5pupc0?=
 =?us-ascii?Q?3q/mqeySAi/pjUsQ2LnSvcI+H1AVCuiantZmcsrXIolVzW/Xs3lT2r/00Ts3?=
 =?us-ascii?Q?9xyAXtg0yLrrB/6XnWnnhyCsx6SmvvtH6/kg2me2tYkLGJuhEh2kfO9hJQw6?=
 =?us-ascii?Q?crJ0omkUSjxD0tb/6YDtuEzKOYrIQx1v3thd8FeTJTchGO+4B7h06p1AlC3Z?=
 =?us-ascii?Q?3XpfXuER5XnBdJHfRk9wfo+CKxUKZiDroPcf4Prwqew/tdCByvyR273pjb8S?=
 =?us-ascii?Q?VnJCYx+oXFZQfZfyxBsRcsJHobxjmXP99mktwOQGB0iPouAwDcKMyoNcP8Pn?=
 =?us-ascii?Q?IoOnYq9yS0FgSW9kHm8aiK2eW4jZHHoQZWDsU0qqUwOcw8TJISsIg85BxjKK?=
 =?us-ascii?Q?91Qd6mAOK946Feu9oy4OE7tfvRXLYSY+AtE3SSanOZlV8BRR5yXNj8nUl/Ie?=
 =?us-ascii?Q?xeMydBwRD6Z9prh/cIkfsRHkptph+P8Bn2g6zJGSYtQk2BZ4dtRRpWv6qLeH?=
 =?us-ascii?Q?cLO9rOrdiCBy9eOl4G/VSj5A+tkt9AAQn672IRzURqPw5kJUueiRY0tfjjPA?=
 =?us-ascii?Q?1XRwiLOg0hXYcSQD/VwPtimSu/WWTV3Tp22bwi5dKuNJ7Bt/V96qrrVeLVfF?=
 =?us-ascii?Q?nx0IDWXxnPjxYmSOdmEV0xCgviam20KfRqI4zWo4eCVaO+mwITQ7ubG3Kmq2?=
 =?us-ascii?Q?WmYngym6eefjZm0+s/JUkrsCBJyN+nD4QuGaVMC03pDToDnz4T5FYVmcm4jB?=
 =?us-ascii?Q?WccuI9rnQRxXigWAqk695+ZbLuMgXCrQiohB82MucOyCoIk+YHbQwhrUbVk6?=
 =?us-ascii?Q?k1u0XfZ4Fi8XqLiCrwbTG/cUNlAAGbFeSePNh3qe89ZGL7Ukehm4sZYKFhyF?=
 =?us-ascii?Q?J6G6oHanCX6axHe38Yf2cytdfbAjNrkCJWeaI7G5f2hx+r6JMVnMCS5FoDYe?=
 =?us-ascii?Q?Hfdul+qe/A5ugaKt0wHIkAnDegTGv8tz2CO7D13SNUSD4sc5U7ZJzLdV+qvY?=
 =?us-ascii?Q?8EYtX2Ge0M3uXcorsRW21nUlrB+qibfFNuglMDlWLkNryBSHGcEwox0SnWZy?=
 =?us-ascii?Q?JJf5pGAuL8W1cuHkOLd5GCfQTHx3mqBBRTwI8F5RtbPeQCOCSFkZQAKCzoC/?=
 =?us-ascii?Q?DoXjzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636a0dc0-71c7-4424-3713-08db256d81a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:54:06.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSQppEnOqmav4uDgEapmBaASzdCrLjgCnYF7eIxvu9w0GwJgOgmgnBvuGyLLcZWi2Mrfbo6Wr/6DZ08wOvY0qBJKcvRfZ3e++fxxHIi6OM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5775
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:24:48PM -0300, Pedro Tammela wrote:
> Unbounded info messages in the pedit datapath can flood the printk ring buffer quite easily
> depending on the action created. As these messages are informational, usually printing
> some, not all, is enough to bring attention to the real issue.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

