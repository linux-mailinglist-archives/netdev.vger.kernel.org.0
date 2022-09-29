Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A01E5EF10D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiI2I66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiI2I65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:58:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20712.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::712])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECB3ECCF5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:58:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FC1gG6wH3HOrtZKDI10kxAheRJPTIhqDv1Xxk+AfbcWJCeA50jQ4rCAAH6rFmHBGtx95tAA9VC7xI5ZkjFxskb96VfKNSgHcAujpF/ttDUmZylVcvWAiJyeD+9Fpy1D0zGwMF/qwOgNM6jvWvRNaPc1ufiVbimCTNqYNJdSOE3ZUlaDRROkc0M/koAwzHhxifmPHTy4rBfEkDrzOBOnx6B4mMHE31tb9wlqZB1dOaJROryEglEuH2AbSCHOx61ULUwtRx3QvzkwV8lkie3vYHVMlLMjVNtbhrpsMu7AjSqega1ckeWgvcylgIpm8pCA3iiKbH1AN/j1vXndTK6vOpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20BPhhA5DG/0koyZeQ+H7/BsbYCGTuq1j3QcYkQ9pQk=;
 b=Fesxm8V2zClxnu1LvFf4ewtikAEy1rptUT/AB2VRSn+YBETh6Q/EJbxmW1deX21SD7jYFYsF0juRgWh+W3BUrh4rZqoRtTEWW+k1oXuyXhGgOziQmn2+kg8c73Up3FdR3agbZJsamgEp7HxA68x6kPSO/0PRe68n5lWil/LPYWHhXMB3xTPezr739W/QeMwojQihy6n3OZmHQpLwD94YtCXiT592Xz0i78QY9rWa65vkIpWLQpiH0RbLnCT9oeoocQcxCnDEM9/nEYd1fXWIeKkX4G9Rn1lnkHyhipyH4Z3IOYjCCZGw129IVJUmNqFiQD/FMJVIGE0tmQ/IjYs8mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20BPhhA5DG/0koyZeQ+H7/BsbYCGTuq1j3QcYkQ9pQk=;
 b=OzbJEvE3mqXQJZn/6zfotrPJrC+IxupPPRHXZPmBFtA0QdnVYfwWTGlBtI0HbU8qHM0HA9sdhsTsOrECfkbN/k1D2gbXaPiQlwf+huxmNaVw4rY6Ina+sTE+mfiL4IaNg9kwv8KHXeSpNXQKCU2J2YVic1xONwzQ/hk4897b5Q0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 08:58:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Thu, 29 Sep 2022
 08:58:52 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next v2 0/5] nfp: support FEC mode reporting and auto-neg
Date:   Thu, 29 Sep 2022 10:58:27 +0200
Message-Id: <20220929085832.622510-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: 00a0fa30-f01a-484a-5465-08daa1f8d524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOSPSBTQ5gITcDKXaVxreYtI4Td7Rz16tNepdBTCFPGQyqYjZSl0lfu0XtfVUeUg+IESBb+zTiqlECdmxQdZTpmdZyWsfqG1vwxHn95FEVtn8yV8ecBfAOZdZK8V8hvS1f14AU8HAk0bBFHuVh+V4Am7q72UVwel9MbkDCdN1yGLXDhJpGhX6PP/esKgoL6zJYRu4nRfAMMoZ1ocKFEsziM50czP3eMD7i4xWZWHL96cGxH7eXW8BKusl/o1D24GQpVyHsnNauD8VSkwOeWTybxpNo0Ssenh9y4yESF7rHeLyeKrrwTIp91T5dFgijF89osb4WfGQWhipt0FqSAlZa2q3RrpFxP+ZmA1q8RihFUyZSrUnxEjGtWyT57hHQQ3T4sGkbd+Ub81uGGx9DqZ5mJtsqNBsUbGn8ncY71CBdgGMUsUsGnGWhJbn7YHEz4+fn7WoVY12XKmgJQQpAg5fbALJBd4Htsj4EY005H7OGE1LoH+7A9nccxkj51YkIoyIF7xt+Y7DkgYZe4zWHMxCqeRGMRkpp4oCcDL/RhidYCoS1xgTodzxKwtWt1X8AFr77jVecefByf83jFjGKyC+OfNBoYUEEpVvGlQh60Nkw4DPtqChYbgwoD0CtSXR6AkQT9X5LRujw7sYt0nSBAeqlhPfiBUeoaqTOte8xLfC/2ZfEa4nklSyJ3jrpK5LyAa9b4qycombkWMfff3qf2lPlgM6LQEJi6/LOQmPU9KW6VENhGZDLH5prG6k9f9qYJR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(8676002)(2616005)(1076003)(186003)(83380400001)(6512007)(86362001)(66946007)(4326008)(54906003)(5660300002)(66476007)(6666004)(107886003)(2906002)(36756003)(6506007)(38100700002)(66556008)(6486002)(44832011)(52116002)(41300700001)(478600001)(8936002)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1LhLfPU+Nb4YgKP7RCPhrPIdbT8aN+Ooh8ELxomp37KnrOPebgIJK/009w1O?=
 =?us-ascii?Q?+xPmQInnispy3UowNdGIORPU5XFBozmf7MWRp7x1HiKgywIbSDo3OnPBB0yB?=
 =?us-ascii?Q?hXrDkBT/9ZNF23BYnkEXHQ/7uB2/ZcxmizvMv+UmJq94ce3vvlGhckCUnR5Z?=
 =?us-ascii?Q?8xM1TAhJo/bTj2yPtkhnMg5LFeuH1l8AHerl7ndHUQ9IPRZQFWHyYM7J8Oer?=
 =?us-ascii?Q?vxoTXVAK+VSE0AQNST9dMxY73F6ppHJpjgds9YYJpq+DOEEeLF0ZA2Acf6zO?=
 =?us-ascii?Q?lOsX6cC2xop4sS7hQOpe4wA4QMLd7hFreuLh9mxgt67Kq0rqzqzbR2l234Zo?=
 =?us-ascii?Q?JNWvmjD6tekNl2oDsOSNX+koo94Rs9CDb8EEraciFtnYMyvaUFS3u+6ZXKSJ?=
 =?us-ascii?Q?djKZpC/66YafxcCbNlxiAGt9SuuKfQzsvZzggUKZTZIg281iITunX9vR6k0v?=
 =?us-ascii?Q?RZPSkoc20exR+XoEGYvJMYk9EZWZoG4H19dHHbhtzXEf/NOxFUhB/J6ZTGk/?=
 =?us-ascii?Q?oR8OGiXtPOcBnZxIt/QfZgJjuH0GnHMqfy2BtTIV2/BsySepmWKe210sUJdv?=
 =?us-ascii?Q?WOPxbOIi7UE98aSExtEFDuxTPsLGsSKVuxd4R/RrZ5qu/5ytIJcaJe1RW0sD?=
 =?us-ascii?Q?7g9LSFHEZ7iA/CY3LTPdL5fL1a5tc+1AvsyKj2+jyu2HyjEtIhxsw4GpUEci?=
 =?us-ascii?Q?dxdf+PwfWGA84Dw4dot3AEUl4812U3uIOTfeSUYpCgM5ocZj9A2IzwFuqHGZ?=
 =?us-ascii?Q?37IamtCgBdPI1If/JhsVxwuSJGYML3aw5rYcSOdp/qnsRcuzW0b1SWoqlM2a?=
 =?us-ascii?Q?eLoh/3n73emXaQdw+OBciXmgio95IBtG1dtfHfI8ig5WvEVsQqmoamzDqEml?=
 =?us-ascii?Q?gDA8rXnwi/ZR7QVYHU4oJv4NFOXtqChBD25OX4di/uZAJyfBAK0XeQZXSpfB?=
 =?us-ascii?Q?/ycl8ATLLkXAJ9WzcE6i6Ryd021pqYuPNh2/WU/59RhRTV3Y1MBuoA3bdVSk?=
 =?us-ascii?Q?mQbg2sjzogsu7tjRb+wnbIhqak0x9njZN+GKSOSoB2AZo3MuVsaldutZgMPw?=
 =?us-ascii?Q?Xpg4QU/6+yDm15TwlHz4cCr8i2A0zG2pzNmudESD0xD6zVF7YBmKK0HW9neX?=
 =?us-ascii?Q?rTuxJKpomOoTTJGguzEHZyKUDdNkKawtMgB2BUBkqvVqIiZSizkH3FNB7H+r?=
 =?us-ascii?Q?Xy4RxFNKhIH6qIN/JYe661CeDSBhtzzH8QbbyChgI2lTrNEG39yWGfczXHD1?=
 =?us-ascii?Q?/v93k3IxrU3GSDvP3An+52hRD+zPSMx9GM9I76wLXo+UFjT79y/CLZnWDi4B?=
 =?us-ascii?Q?mSqw5/4WMc0f1chTWxuwnhg4xpvygFtVMXKpxBQO55GxW87awV0QqE/yn8mh?=
 =?us-ascii?Q?rd4G0LoE9qRRRxHLSib73LjCmH9My4rntLyv/zq+B4pji6ClnFkiYUnBWBBy?=
 =?us-ascii?Q?MkXadKJsCyFEKXpCF4RhhSsysMPQMpDhtkx/hfshKUMbgPwJtgG6qKyTcBU9?=
 =?us-ascii?Q?YKSkvs7IOT5m2fERHlZRJnb2+L8z7vyh1cSuy63ZwaZavZHgjBrCpRxyFP2s?=
 =?us-ascii?Q?nmVX61wzwPyb120evMWsJy0ez0CD/bPQC9v7zdKxFv3meqcVpXf3svJVYWAf?=
 =?us-ascii?Q?i4fiVls/sOJm70wPANYqAQJskbeD4ybWojHEotLePtELQsOk7LweOmz/XVlk?=
 =?us-ascii?Q?kFu+dw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a0fa30-f01a-484a-5465-08daa1f8d524
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:58:52.7330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Abdd4/p2mMaES4/WebPmkw30+pjr5p1iSl22rs0cSm6PlxjTdW+xLJxCOvR/EJMUg5yVsO4lBM8BiAaGY/fU1bH0smFWH74ktOAzI4JoT8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series adds support for the following features to the nfp driver:

* Patch 1/5: Support active FEC mode
* Patch 2/5: Don't halt driver on non-fatal error when interacting with fw
* Patch 3/5: Treat port independence as a firmware rather than port property
* Patch 4/5: Support link auto negotiation
* Patch 5/5: Support restart of link auto negotiation

Key changes since v1:
* Treat port independence as a firmware rather than port property
* remove the enforcement of FEC auto mode when link auto-neg is enabled
* Adjust the link reset function so that it can take effect
  in port force-up scenario

Fei Qin (1):
  nfp: add support restart of link auto-negotiation

Yinjun Zhang (4):
  nfp: add support for reporting active FEC mode
  nfp: avoid halt of driver init process when non-fatal error happens
  nfp: refine the ABI of getting `sp_indiff` info
  nfp: add support for link auto negotiation

 drivers/net/ethernet/netronome/nfp/nfp_main.c | 74 ++++++++++++++++++-
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  3 +-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c |  8 --
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 10 +--
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 61 +++++++++++++--
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 49 +-----------
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  |  3 +
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 11 ++-
 8 files changed, 147 insertions(+), 72 deletions(-)

-- 
2.30.2

