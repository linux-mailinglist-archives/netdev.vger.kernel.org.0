Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE015115D9
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbiD0LMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiD0LMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:12:43 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2135.outbound.protection.outlook.com [40.107.20.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E73700C;
        Wed, 27 Apr 2022 04:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k65mrueYa4S0EYCer+N2spddBhjtROxHgUZro64ulBKDhMYCk3JxYr7ZNVNDhYyDoa1N5jYQJfyH2S1Nm17MBT8tB1ORBbNCjL6hFJPzH9nEkRG7BYUA2YSC4zZqV3pJ049DAz8GSntOVoVFcStyfRuGupqPgceXauRW9Zm0E0mlihZQftQnndlVZkihKxuwUDCFWOSE8s+Qe3RgIKwxWWAOdeEDJmdNgHyPbBy7bUnasuNvoAxdMYorMRiEScHWQv9rFQAuyOyjsMzgkkBu2qWCV9a01Oo/LceWcoGEEk+D4wZl2qZSj18MQ6hvn+MHQVxfr8NAWk99hBeVEWQEdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K/ZSk6jzJeP3UKiHSh6nSQOhxXKVdcAAvY0QNdTsvmc=;
 b=YfNO76v/uhTCLdqZJN4JIYGbuk/RHM/E1a8yPJB3ozau0m5FRXlkdSbgbIDsQ68jtFIn5AG51qnGI/r69sUImOdvrEUrTLpcVu1nffS67255SmVM0/7NKCAZzaAEAuwXacLf8m4kODJovNZkytM+Lzg6NPIM447kf+lJEhRjQSyUUYeLLa4Us/+rk6JflhtI81E9eS0kcz2UUTGXm6hJRV3QG1nwcqRcKDX6XwzMdpUI3s8lImpQWu7H6sS3kM6BlKK/oX2OoaV+tiObDA4v3cojAAgguNDa5WpOtZkzrFth0FBERIajRmiAyZGsgZQAjtObXk7LHQm40D1A9U363A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/ZSk6jzJeP3UKiHSh6nSQOhxXKVdcAAvY0QNdTsvmc=;
 b=Mm17z06pdIJt7eCJNnL7z03ijP6dyOiSfF0ZWPz4YYV/cAld91nWwbewwK3RG+ToIL7twRsSXu7GI7zCvZHu/iGIESr8T6Yd9Wb6ITlJJVFHmyeetWjdpEdqyF5/3Jojh3OQyKQCn2mcwmXqbc4UZtm0B4gPbIDRUoZc9JdpxRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from DB9P190MB1963.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:397::18)
 by AM8P190MB0929.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 11:09:26 +0000
Received: from DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
 ([fe80::2186:244e:8f91:a5ea]) by DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
 ([fe80::2186:244e:8f91:a5ea%8]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 11:09:26 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Oz Shlomo <ozsh@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] netfilter: conn: fix udp offload timeout sysctl
Date:   Wed, 27 Apr 2022 14:09:00 +0300
Message-Id: <1651057740-12713-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::6) To DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:397::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff056cc4-19b0-44f7-a8f2-08da283e6442
X-MS-TrafficTypeDiagnostic: AM8P190MB0929:EE_
X-Microsoft-Antispam-PRVS: <AM8P190MB09295CE666FA2EA9D0B9D3D88FFA9@AM8P190MB0929.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ICtpoKVHsCNO0MlMFziY37BgMeeWpDHK0QeUrS8uevRAcfrc+IF8aWGgsxaUBgNjF9NCZ/3aeYa5lwSdmJIu5tYYCCWPao84NWpz5t7FxEwJ7xO/VMd1Hfc41NcgH5iBq0fZAyDQVUiuFgcAF5xS8WvmyZUy8hpvMIkOOZNLQRpYjp3SpBzNQnwJmS0FKxKuRDXEIq8YUei80h/DWql24akviPvJCyUQBNT+BYdC83PB5Q32zIJaQrisbTHovDBKi6RisYob5wHkICmV7PZfUpS7rOOrDDmej86GT2YgnSXrfL1uL+9DJL55x1yNJJ+ymbdQ9HNDybEzUgYFidaGed7xTDVGDYhbKRB+YbVFE76fFGXex4AkJtKaMtAhL91VzA5cfK02DF2OlcIeRhArcv3MH2u7/K3xMJiEvpB0/mKygQHsGYDOihHxM9O0h08f/FQpuGDVb3SY8bAMqZk8OoPcMbUezFh9zZkEiRt3buS43rYZFxo+6r+Y1mfRQEwliiYmPF/qU4vgcRH/IiWLXF3fJe+wfJKH0+d5PyHCQKIjXb/02Bh+8o7uWhuW+EPcQRrlllS4pxBTxlPDKpZfnh0jZE9/ngs5Z4+w7w1JgRRftdCHhqqYNjBMIBwafnHYSRqX6fEyrgNhAHAj/PVfL+yJ49F/l5QIUF7kVwjwrXtM18KT59SbTzT9bdMED9aa1SdzJEVhHBH7eNiKZCfp8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P190MB1963.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(39830400003)(396003)(136003)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38350700002)(38100700002)(6666004)(52116002)(186003)(44832011)(2906002)(66946007)(66556008)(316002)(66476007)(7416002)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(6916009)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Eytp46/UYuH9OHEhns6FrVkwVWzNYwq4JC0mo4hHpY2Y7XqE62RJSGUHNc+F?=
 =?us-ascii?Q?nQ2/1OZqZcfd8irfC6Jir/Rkw72NCMDiqjw+ci0Dg2Mos/DrlalaKLyEmYRe?=
 =?us-ascii?Q?pw5xJaiyrSwXc4ZLnqU1OV2gRE8UpHJJX7erP2yemGYpQR/QvZ2mFBKxhZ0S?=
 =?us-ascii?Q?V3Xb7V/xDNrlJliv7GF7S0usJOhgHhofPmd+ApD3GNqpk7rR99QrujkWE+sF?=
 =?us-ascii?Q?YIcaNDSMI/RqgpeRjoZYvrZ9VXFfFPFmmKdX2CAUsBIQUsThISKMU8YpHgjP?=
 =?us-ascii?Q?btywB5olE09DZ2Ju+k/GZQQbAMetAGwfzqEDWfXOfBWp6i7FTpmHJuaT9kYR?=
 =?us-ascii?Q?AgJfig6TJiZs63ghflTeMCwkpgR4nWpL0mqa3Am1kFXvkg56loaW1t4iEjYn?=
 =?us-ascii?Q?TRxSSj5N/7j4c5EvykeeyofCHhXsAh5HGOKDpk7pHYPPdAl4mqZu5XlfOxDk?=
 =?us-ascii?Q?t3YbUXEDonCSSKnJE4zpqhKCglfnQNT5eolz83IUKpajiNvTvxaFxWIqL8tY?=
 =?us-ascii?Q?Ip0gSpVejiErU6Qzo90PmweCikbXoTf5rl94yAl0UvKep85IMYuN9RhDW5Zz?=
 =?us-ascii?Q?HVwDaEnThqbiz04GtZ2NAz/YgAzKuePCcoxVu7PuedwRIUCvVQcePFI92KTf?=
 =?us-ascii?Q?kwyXPKPVcDWdewvesjuNPifSi631MuH09rr+fB4yD5nJYW/b3vFoFG09krmT?=
 =?us-ascii?Q?qmeulcopO9sY6nmxq0ooPgXLLBpX0Xk0YzMNs4YzJ7F02S/XAfqMgeFeh4Qd?=
 =?us-ascii?Q?VfvVacG3oW04y2aISua8GsaTtgSjSxGpOsUUxThkyiXvo3FXH4LXfuGo/slE?=
 =?us-ascii?Q?NHwTKfWog7jNVaJ4yxlSTVxU25M2iBUkb4EJm5clI2IlIqDEaJQHfur+ja28?=
 =?us-ascii?Q?cRQFYuq4345Ob+nSmVfGN7bMj4vHAqWdMKQQuhUsc9QevmBMUcvykjlMs0cI?=
 =?us-ascii?Q?ixGGcWNcMOBWpPmthpM4rgneqAEw4Xsogbmn8k9ZOWtNRu12r82vokT/nkbg?=
 =?us-ascii?Q?+rgh6c4vXx5f1CrrgcS4ubqf29jF7jNFbGBeTXg7WymjGsgFkNfE842j9hBL?=
 =?us-ascii?Q?JcLC+3tn3FRj1Lmzhd+8cKmvMVRj8EszIhFOMXzD6RegQeRdlVw0HqfYpach?=
 =?us-ascii?Q?6cczdg0UgSGPFPRCWQx2vlqUcSYYUsXMoqt7u6StfJoKcjJDKf6/Q6YmfeW4?=
 =?us-ascii?Q?rRL1gcZGebyu4+HPwCCBBgm73mqLoAOVJoiOCNM1ePiVGcnWTll8yQukWwSm?=
 =?us-ascii?Q?0fjhTR558o+6joGHTPSvg1R5556sjRzypibstXAC64pfc2qLyRezL3ezEv9N?=
 =?us-ascii?Q?OzlGeW86udwfNXPvQMOSyjS5jNonsbcOV35uIv6YMPcB6WRKNdDFtKwV3Gsg?=
 =?us-ascii?Q?2YkV7KCpW13/7DnUdY0wkWm5bVwaanU9G1sAVG4Jb2d6wK+4dZRJDiRd0mgK?=
 =?us-ascii?Q?SbeeT3MAdWbl1i6SklS1vHq/0siJT+Ry5k26wVmDhmV4UvbYROv9Aqq4qqY1?=
 =?us-ascii?Q?uD5I67bJNOWbvJHu1MCg2VUNh7lpxN3jsOoNhOprsfaV1Mk+zKrovDoGANPH?=
 =?us-ascii?Q?E10KyAGNRXXiNFdvkaRXYq1fIvtxOexVgkOmggDlPOtmI66A2287qvaYz4Ys?=
 =?us-ascii?Q?OHd8Iv4K5VXD9iyBkkFXGhJcQH6WQuGgSqVcsfNxbFVcehSY9wa/1NOrFbED?=
 =?us-ascii?Q?up/r3AJNofobNi/2B6q9vEG/enX+4903H0/C3jLKOoOpy042ScK3JiusGYer?=
 =?us-ascii?Q?ZvyUpOFq2r0HwVxPLuDt9wDHdYkG0Ww=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ff056cc4-19b0-44f7-a8f2-08da283e6442
X-MS-Exchange-CrossTenant-AuthSource: DB9P190MB1963.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 11:09:26.3394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3b8lvFCyPjcLkmHITgjKE/DF8HGafz2J+IjgCAOgyCZF5eA1Xg0AKgdypsgaUEoNDXv03K88NUWgX0GNFbWj9NQONTuxY4Y47AfmVgndzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0929
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`nf_flowtable_udp_timeout` sysctl option is available only
if CONFIG_NFT_FLOW_OFFLOAD enabled. But infra for this flow
offload UDP timeout was added under CONFIG_NF_FLOW_TABLE
config option. So, if you have CONFIG_NFT_FLOW_OFFLOAD
disabled and CONFIG_NF_FLOW_TABLE enabled, the
`nf_flowtable_udp_timeout` is not present in sysfs.
Please note, that TCP flow offload timeout sysctl option
is present even CONFIG_NFT_FLOW_OFFLOAD is disabled.

I suppose it was a typo in commit that adds UDP flow offload
timeout and CONFIG_NF_FLOW_TABLE should be used instead.

Fixes: 975c57504da1 ("netfilter: conntrack: Introduce udp offload timeout configuration")
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
---
 net/netfilter/nf_conntrack_standalone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3e1afd10a9b6..55aa55b252b2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -823,7 +823,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-#if IS_ENABLED(CONFIG_NFT_FLOW_OFFLOAD)
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD] = {
 		.procname	= "nf_flowtable_udp_timeout",
 		.maxlen		= sizeof(unsigned int),
-- 
2.7.4

