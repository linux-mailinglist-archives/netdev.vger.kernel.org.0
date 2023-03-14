Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6065B6B8B4A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjCNGhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNGhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:37:03 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2111.outbound.protection.outlook.com [40.107.95.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142067C3F0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TywjaCFH42xq8J/SGe/SkrpeugdQUfXVegRVabpUBal7MQNb7FUP8/GPy6QEpeTxvBcEZDV7aISN9BXucK1fa9NtiVarynSB5esOwqXrVImAi/+Svr7I56ZUB19IF6xvS4WBDBDxIXZHsvskorWeBlKdHk8+kgDf10/lNyeNf1/e9jbNO74oUxWyeh1JVFzYl1X6sIIU6K4rW+nhIkxS7QrCcgdSwk78kBDmRNlrCeEPVKQhPoYNt3rWZuSU5ORSlkYb7J+B+OwQTUzLanfXp8A/iqlEaQFGAOpnRnnmyvUnn2XDHkrU216jn4BIshaLxwrzzh0/aPj1XL4AqiWwfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yYOAXUFfgaCGrmNSNAKuaghP6noc6I7NsT11o9FxE0=;
 b=RFIitbcq07pgHTiJomvP8wv1VLgoVXW8jwCotcYiEV1rcpAEN14Ae6ri7XfZiv8CTPNDx8AZAGGaRkmRRfDNcbrfuUCM77IBpUquLEPPz4c/lIxu9lY01AlhU6TcEMeaqgZ1Vd/jgK0038e6KFnZld9K0nyXLvb/sSnwyVgnWJAYpWuSytgMhgK4ZhZKaBZXsRfiqLEm3UE6H05TyZ3czux8tGBBDFa1TK12UIerxnoQqmNF6TfpUxXGxvNiz+2vAeioDfZTHMmiZhWHlbE3EGv3rw8sPJ7VAZUlnWkKxCfYjM3BU6DUc5OgBC9nnxuSihSvPja6DIj3HjtcuMqUSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yYOAXUFfgaCGrmNSNAKuaghP6noc6I7NsT11o9FxE0=;
 b=r4kQIsXyvFWu0PB+Shab/2U8/t8XT5L4M1UPGjYh85TFileAzYjxv7Hrz+VdpWBcaPckhu9/j+UPHOs9EPVmXcTjiS/1ksxlu6g+ps7+iEDTiWUQ/3DIKGiRUE5dl78f2mDmd6YFp2y9fFQeKHgLRGsGc4Y48rJqIJ+3LqbFfPM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA0PR13MB4110.namprd13.prod.outlook.com (2603:10b6:806:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 06:37:00 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 06:37:00 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 0/6] nfp: flower: add support for multi-zone conntrack
Date:   Tue, 14 Mar 2023 08:36:04 +0200
Message-Id: <20230314063610.10544-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA0PR13MB4110:EE_
X-MS-Office365-Filtering-Correlation-Id: f45bf29b-8e03-46b0-7f8c-08db245683ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5KOjPeCXkiE9rw0oqXtyGRCIoGO5LPpbIggzulPhJaKZjNvoQXjM2NO7B0SmE/2yNc+/OAUfCsduEEz1ZP7Hmj5sEKEvFD32PBAeGQf6zGOIL+Lz5DxcrBqvb4tp6vFkbybJzYYfqWJkg3g5bes9HTYsbvaTCTNta4iDgX5x+Ws2DyAaeMx+hN/M91dO9EIEXoq1SrtC20LB735ZXx/01HylMOZHeKTlp6S3Ycp8V4wOibhCEdPiswR13EpjPw8E/fU+4IxJkO/08+eMMlvvd+N8AzMW7nliwJZULIdvrzlZ0wMMRQDcYwqjwV08fyXRj8M7UmSGc5QNtOL2PgIAEV3HfEkYtHZYGXY4sxR2g36Szayijhu2Idp0VVFKoHZHMwTGey7ZGXV4N7C5TMJK1qi7odTFi0XLD5XdYK/Miu21SgsHWN0ZPsVobkFhOVU8zg96T0q5qjv3cLkl3BPDGWeZa64CEg4jX0yf7yanNY/5XPH0sRZ/n/3UWd1E5c2infymnCJMzWciLDojf+K7yHvHPX8tj4+idDCoFo968FFOe0jGx/C4H5VSN6LkuJNMXHXOYQyEJcrsS29u8/LuMoymgArbOBDXsV/5jWcK5t/2LA3yEJ+PzpU7/wEpoCC98RXJS1UEOgi8K+77eBuql2gH4N5GwZngnFp7MRyRfJFzakWiwu7AKDIZesbt6QG/449jq25mnOrRAzt3aYRhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(376002)(396003)(366004)(451199018)(41300700001)(5660300002)(44832011)(2906002)(86362001)(38350700002)(36756003)(38100700002)(8936002)(52116002)(478600001)(66946007)(66556008)(66476007)(8676002)(6486002)(107886003)(4326008)(83380400001)(110136005)(316002)(1076003)(186003)(6506007)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qobB+rAGUgQywAMnI28UZ5zewQlnyUN5vVKzeAK7fOy5cxVG/LgvA6fFmM17?=
 =?us-ascii?Q?cKzLMhUQIwDikMXBy3I19EP0xM1mavpoIhHGKSvS3ky945lfZWftjFn0TLCw?=
 =?us-ascii?Q?zqMb0UHmn8PYoZyEyPUyvwiy0TqhpNe1xv5pI4Oyj/TblWcB7VYv6C4HAmmT?=
 =?us-ascii?Q?ywwnEyX3q/VmL/4MRoOc0Cz4hDwv2a84YfgwF1E3vQVd5h4bLHRj8T3WhoWO?=
 =?us-ascii?Q?ZHuQd0hfRrCBOMofFPxhtHgN+HiIyO9jJWiFhBEB2WVL+21eh/BbMpym2CeQ?=
 =?us-ascii?Q?WnEZgpm/E0S3MkMMFS/+sL6e7bycxqHktpp3X9NfxTVWOCo/Za75cau6cPc2?=
 =?us-ascii?Q?jcyCGSpwEbMs/Tyorg4aeLpuF2PFCssCMRAFp2zjqWQLgPyoKhZCINLhqtKt?=
 =?us-ascii?Q?5tZPajx3i6YM2zYHjF6UHPyexxrRn9LBlVDU4iuZjpkVgI6AGaK5HvnIFeMZ?=
 =?us-ascii?Q?ORhA/7agC/YG7nMQuOuHen+Wpahh0Q6q7n3P8turmHRhjXzmEHK27fJ6APzL?=
 =?us-ascii?Q?Y1mW1zBF0xN/b0kU1es9PXG8CsD9b0ZZeBT+VciDfDFK562Fk40AZj90yE8C?=
 =?us-ascii?Q?NON4o5PxRLA+Yx2UJ95P/tsDrOrr2AXMJEcwm0cVZxMf6SJBwEmFxyk7QsKP?=
 =?us-ascii?Q?6x6TevKEUA/0Sk7k8guF1P9uuN8oxgo8vRZg4KtgjMxka9Al9MaQkXUqPW4V?=
 =?us-ascii?Q?1LdCNRqehy9oAUgAPSdi9mDtane19zJ4wgdawgOQy9auv3nND8vdSVdxkCzV?=
 =?us-ascii?Q?rBzPP2F1tBUmKqRBl6ZNMp1TFtW1dzcAm93Y6PX5fRKjN3tol+mZ6+sN0E+F?=
 =?us-ascii?Q?01ETgNKj2e4VtWNVpbO0PfRwDcD5Qi7j9DKw0FLMtCHaiOEBMm6AJxx8YvuS?=
 =?us-ascii?Q?i4qCSFHWRuBs7eWAF1CZ7rhLhkKcfOpUiz/7P7jb10WZIgHlGC5GxxeyHDmV?=
 =?us-ascii?Q?Wfs/mZJYP7BJA5Q9ocSMD/uu+dKw2v5qRHqm3nOcy/CPq3eg7lZd9HFh7Tz2?=
 =?us-ascii?Q?zUjiAzrmGW+lJe/tq9m+rqq4hmM8M3CDEy4bPn3hAVcLGf7zQhw5KYUJWFrL?=
 =?us-ascii?Q?xLnxUEN5xAtKbpA7QLLH1mK5IXPS3WoISBEH9kazj/IIa+uTEHrGsxxLFALj?=
 =?us-ascii?Q?OOMV3viudQI+Y2EbZE6kgAJXeEqFYFcuSZOImA+4wc16CaYYtHVL5EFLnjbr?=
 =?us-ascii?Q?ZFlGHT6lV4sjlEeOk5bMucXKfUeQpZYyaltVB/w6xIwztyys4MNqJ4QdRlPs?=
 =?us-ascii?Q?a+3XkFbRCFIoWSyjooi/3iPy77QYfH/Qc3TBMyo2UOrCjtC/OMbFC0K/ZKEV?=
 =?us-ascii?Q?qlkxt4QzxbTPHeAMVuGJWV6sQcVgec2MI/HfoIex/QphJJKaQD47m+v3qaLF?=
 =?us-ascii?Q?Wt6/+7ut2soxdi3WYHrZ00HX5oF5M5uq0y04MFXlWeXtB6tfvhBti/VftoOQ?=
 =?us-ascii?Q?GZteQpxuIuGsczdDJy1AxsYdUSp/ap+JLvRmVFj8QtfhyrphtTf3bCWCIPjk?=
 =?us-ascii?Q?45gIhBfcBBSakqpgrVofLigKvBRDdrDlwmjZPD0/D32T2UyDiRxDwpl7H2Rm?=
 =?us-ascii?Q?b8+RLYU++5n1jbynhc5UpPMpsFehaenNKSJPX9gv+ZPZfg5cKF60wP0kvf1E?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45bf29b-8e03-46b0-7f8c-08db245683ed
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 06:37:00.3474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RljVMFb9aGfmYN0z0zEOnp7BbuJ5kUQoR/AGq8bf/72WBiK6O6cHfi7QgA3zwJO7Lr9/+3ubFjkdPU7yb61hf/DI5nM5PkWZ1TfYMR+mduM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4110
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add changes to support offload of connection tracking across
multiple zones. Previously the driver only supported offloading of a
single goto_chain, spanning a single zone. This was implemented by
merging a pre_ct rule, post_ct rule and the nft rule. This series
provides updates to let the original post_ct rule act as the new pre_ct
rule for a next set of merges if it contains another goto and
conntrack action. In pseudo-tc rule format this adds support for:

    ingress chain 0 proto ip flower
        action ct zone 1 pipe action goto 1

    ingress chain 1 proto ip flower ct_state +tr+new ct_zone 1
        action ct_clear pipe action ct zone 2 pipe action goto 2
    ingress chain 1 proto ip flower ct_state +tr+est ct_zone 1
        action ct_clear pipe action ct zone 2 pipe action goto 2

    ingress chain 2 proto ip flower ct_state +tr+new ct_zone 2
        action mirred egress redirect dev ...
    ingress chain 2 proto ip flower ct_state +tr+est ct_zone 2
        action mirred egress redirect dev ...

This can continue for up to a maximum of 4 zone recirculations.

The first few patches are some smaller preparation patches while the
last one introduces the functionality.

Wentao Jia (6):
  nfp: flower: add get_flow_act_ct() for ct action
  nfp: flower: refactor function "is_pre_ct_flow"
  nfp: flower: refactor function "is_post_ct_flow"
  nfp: flower: add goto_chain_index for ct entry
  nfp: flower: prepare for parameterisation of number of offload rules
  nfp: flower: offload tc flows of multiple conntrack zones

 .../ethernet/netronome/nfp/flower/conntrack.c | 260 ++++++++++++++----
 .../ethernet/netronome/nfp/flower/conntrack.h |  32 ++-
 .../ethernet/netronome/nfp/flower/offload.c   |   2 +-
 3 files changed, 230 insertions(+), 64 deletions(-)

-- 
2.34.1

