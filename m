Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5766D82E1
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbjDEQE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238764AbjDEQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:04:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2095.outbound.protection.outlook.com [40.107.243.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD7559CD
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5pApzAA0zobc5xuaqlZdP4ltZefDjRCEbsXirShWvV6JXyK7QP9HaHesXNNyvCQP3R8u/Vzu/VIA4IFlIf0CW1CSXmC6RQYRoa4RLdb1JdEJ2/LQ7AiYVoSgbUWUP3BkaVscNXBuL0j3KxYSUOTkg6bygij2Qly1Af7m9a61/ql4IuphRr3Vo93o4cEU3PvACjdpjrsqi6Ekz2sqSBmVKaDxAMk4VA3lTDyuKiuQXfdxVvmQphR94ai70khqxyNGYvEV9TRh1aBLpNCp4nnOHCbCtCZIMM/l4zEUgdubXqBTpOPtCrxlYqyGHF4zDKxxRffo6ERmq+yl/zYYoPDUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0cJyeAqfk+Lmf6Ee6GSJTyS3iBrx1daLG5I2NIInCc=;
 b=PMuVThH1J3k45Wcp6ODGo6PsJodUUGGWM3Os9AP4oNn3yt5axPFHFtzQHgZsfNzXYnT0M5uReXSeNCKmQO9G/pXpkeVNcq/jk1izx/AsxSnHPiuGfQvz27tP+UG0XYsdK4sMAeJvTGrkuHppOYdITCp9deeE9U10X/qBpn/GzVDwYl9tKM9Dl1yLKTcxhjdCedbkkDVvAYiCrI0ZVC5fnOjSJtIMPOOzyY+oViZQdxHDMKi8WuCnuLzGZbFNvgJrKlAS5ROq4BhOMEbTjXGx9y8H708gRZYg4BeF+8NjVQVxK1NEFaVr6g53TuoiFJl77EzSHVpMv4ZGJEZJ3we00w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0cJyeAqfk+Lmf6Ee6GSJTyS3iBrx1daLG5I2NIInCc=;
 b=KDxXl5YigqvuLfnk9gUHnx8aTUkwfsy2CklDoF3l18cJpszLxW746MCvqfF91BqlHpytmPARgss573HIJW+Z5tvT3CfaUu4cokJz1ja69wSSIlLU8JF+xpfhJX4PCWMdqkIaeV4CkXgaUVwzbr6eaA6k8rem60UCD2SyqQmlof0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4681.namprd13.prod.outlook.com (2603:10b6:610:df::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Wed, 5 Apr
 2023 16:04:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 16:04:40 +0000
Date:   Wed, 5 Apr 2023 18:04:32 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net/sched: sch_mqprio: use netlink payload
 helpers
Message-ID: <ZC2cEDUfUxvUjOmt@corigine.com>
References: <20230404203449.1627033-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404203449.1627033-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4PR09CA0004.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4681:EE_
X-MS-Office365-Filtering-Correlation-Id: 34aa6b8e-d4dc-4e59-59c3-08db35ef75f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uaU1odDmRdONxVB9gORGLste3K/SLbhgoZk3vItl3asE9ALVEnycI7aO27UwvKAsoFzgARfack4JrsY09WH2QI9UVfpAX7JmU+lma8g5uFOOy/+DiO0NgV0IkO4kpDVtevC2ZeSAs3U+uMJSyEX4Ol9VysWg6/dw/cPXp0IAt+oKtozJHKyCV64ZS49HXRokW57hzALOyeL/WRGN3Y+d965C/KEwF4y10lcYIVcy3h57S8FU2SXNZsl/DhUqqDeb0bH63HNpVHoWZSAhYkD5blsRfEO8UWEVwU7ypU8ocqboapgr0unGMjkW+BC+B/oWxxOvsmwdN5Blo0714v1c97m7ZZ0Of/64C9DhPDqz9GhL8Fs2N/3s92at5wXYUgqyLnOvxLPJI6LqosP8QxBMiKqPaB1RdImZyDtvxyGYCEnQnr7U80gMX2t7aPHVy91/60/uVXolaWvbhOPCmugxKjYZy7zkPx02HMqwkhKR/9qpyiIeUaSBXns8y0NMfjd55RPLNkxr3vYiHBhviPEXTw0Fayr1FkwxuxbXITir349VmfKimxChzEWRRBHX94O4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39830400003)(366004)(346002)(376002)(451199021)(2616005)(36756003)(38100700002)(5660300002)(44832011)(66946007)(6916009)(4326008)(86362001)(8676002)(41300700001)(8936002)(66556008)(66476007)(83380400001)(4744005)(6512007)(6506007)(2906002)(6486002)(478600001)(6666004)(316002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AgquMPqEbvyEDdE4Wa/M6Pbm4XNdUg5wl+4WMtYRWCTYhFiZfP5zb69etqVw?=
 =?us-ascii?Q?gKK4oMgZZXj6I2SU1diOZkqfv0aJcktTmz6iDhKTnpwoT7Fe1Y83B2n8uuLw?=
 =?us-ascii?Q?3L6fuULHYcNrtp1xWoNFp2/SdYjgzUJfTuqwWJCfHg6ECW5dVvcloDoTUtPv?=
 =?us-ascii?Q?BfGAn8d32fUi7ljIjgb9szAQNAJO07cDMuJk+E7xfAjLx6Cizs/E/y3J/qzI?=
 =?us-ascii?Q?jz6NA6A8gIp3yfdTyyuL13hEq7xxr8zuEwvXG8w5+Dod7SdXmBVxWmWKe3PW?=
 =?us-ascii?Q?XWS9GAos3u102xzJEnSXb5AFgsDvtOwwyvXvHO1h22bkoZUyjfDrwzJdjbeR?=
 =?us-ascii?Q?zlsJGTQ7jpWAikKYDFySXG6lcLd3+pq7PEJfR9Jgm/nys9Aaj2i7HZu5mWaA?=
 =?us-ascii?Q?vTEdCdd0D1tDHMoimAMme+1cri3LVv4gMJM7GazvQ0lTk+9/M/0quR/BVp9U?=
 =?us-ascii?Q?nEpeOcd0rb7BL2+iJPOtr797/MjzZYxXTMOQAmD6ia05puJ5XimzEgdJ9poY?=
 =?us-ascii?Q?DgHQIEkS7Khdb137k3KwszhZsr9OS5mWrp7ntRpUNTlp40IYHJ4q+ZeqORaK?=
 =?us-ascii?Q?hT2OSh7koUFrLsClkFoQM3DnCZbAqlg8j5SJ5+xof2tPm37EYHpYDyTTqqFD?=
 =?us-ascii?Q?d9YqArDiPPvWdo9H6mXm4C3CevZyhtuTblRX8h7QeQ37Rfo0UC6KDrembsxy?=
 =?us-ascii?Q?BkQwGRxnCb3YeX9KdfTp0kApKLeiB2X9IAGwVFb7zWjN7WF9vuOBDltoNidP?=
 =?us-ascii?Q?zdYe6y8MAUKnFniR89iUUhM1TKt/xleudSQ1Xx+YfLiqZMIe7yKaZQoOI/Pk?=
 =?us-ascii?Q?xSPN65Nx2Iw0v7wRKRvakuXo7qBRU01AmluJR5xzbue2lHYHJVspk6TYF8Xa?=
 =?us-ascii?Q?4zsF6g75VquQUQEMU3xPEcQ8EewyIpe/GPMVNRJEieJYU4UGtH9OG0PRVUvS?=
 =?us-ascii?Q?Zh7fZ/tNeoomn7PSIEU7YcHf8B2GsBdV4vKNeMf5Lbrf9pjRHbvLwzBdd6qp?=
 =?us-ascii?Q?sz5rcSOyKiEYqVfTtMXewxyV8o20cJgKcPyiia6B3beshlaKBG/SZCLuHgpE?=
 =?us-ascii?Q?RYXTH53YJjLiB+8EZF3hcsuml7GYHjjxoNy8sdayA/SAOAeHSs1/mLsvB1Lf?=
 =?us-ascii?Q?FoVdDlAjoQTGiyCt+G9tZNb5hO5Ly/mPYLRWmg4bGscPHJXjOuZsUT/KDZL4?=
 =?us-ascii?Q?rlC0K6tPcadXwxLXb0LACyt7WUqLdyT6KGswXzVxy31lOCfkqgO/Y5dYtBnW?=
 =?us-ascii?Q?vO+t4PJsdTwhwcnEHA9DrEg6+ToF5/ar3GX9rB1sa31pFUDV2yc6UQh8vrOE?=
 =?us-ascii?Q?/6VSGzEbqi2NgT6wzPzl0fAVDLArPw1zebHtfhic8IW0pBm6XWSQG3AzwxjQ?=
 =?us-ascii?Q?e9PjlbVa9/PsEwJ55zArLJrYFoB3EMa9iZjEiVRgkitv+1kDzY7ApCeJp8z3?=
 =?us-ascii?Q?7t9UQ7eONYXzVZJJYlNrQH8WsLroBhaZyJWj8FaSw61PLA221AGTUY+wa1jO?=
 =?us-ascii?Q?MUItOvuqemqG6jw0AWUtfZSJ8ICvd4AQPwPYMEQ4ZIErNHjpxGsbr74DUQw3?=
 =?us-ascii?Q?EEVAJPRs3Qt3KMAZ4PPHxLjRFGy+SuZ85zVX6pLNHLlpJrjH+DiyHU7WGPsn?=
 =?us-ascii?Q?8IzujUcSOQd0xaiCCkRAjW3qgV+3lwEDJF1eQYTKmUEdhzLj38o/urm9ccMX?=
 =?us-ascii?Q?HoY+BQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34aa6b8e-d4dc-4e59-59c3-08db35ef75f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:04:39.9707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uf0U571JkCU1/MpAWsstWHwChdKxbmQaTay5ByFA3a4fGKkHMpMt8qduEb6NeKilkpddWE5Q7DATN8FM6sdZxF0a5ilXCAb9ff8ieq7clBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4681
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:34:49PM -0300, Pedro Tammela wrote:
> For the sake of readability, use the netlink payload helpers from
> the 'nla_get_*()' family to parse the attributes.
> 
> tdc results:
> 1..5
> ok 1 9903 - Add mqprio Qdisc to multi-queue device (8 queues)
> ok 2 453a - Delete nonexistent mqprio Qdisc
> ok 3 5292 - Delete mqprio Qdisc twice
> ok 4 45a9 - Add mqprio Qdisc to single-queue device
> ok 5 2ba9 - Show mqprio class
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
