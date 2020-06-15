Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9961F94FB
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 13:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgFOLF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 07:05:57 -0400
Received: from mail-eopbgr00040.outbound.protection.outlook.com ([40.107.0.40]:22889
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728304AbgFOLF4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 07:05:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FH6gGQ/FZk/A/6BXt9Y9kjisX7IP9VN6Hzu+6JVyhKmvOtluPN5fVZ3L0W2PmlQ5nerHT+5CJhha79VoNFxMQUC50zgjBl1n33leC3L4dabJIKc4TsIPvPirp9toiMSjZNkYbATRgSP8x8uTURmsYl9bo0CXNn0GzTVV1jetjUl7S5bYQf41zv4cPipf06tCIkyCxgvsK/AsfUr1KV2RA1fYfh8FlGdEPZHSjoJmMcm75BtD6SEaP/FzlOCbpe1DciTrApQfPGXpBMZjzreOXLCKI+ubh0B+NOyooVkU0HCaKwFQeCOJPIZjqMTAwdTO7iaOckKxzSFh5ZK3yX9HSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++n1Mvu+cMQwTuVNtpLq5eHwdRGWPMt7x9B6IM+mpuc=;
 b=IFvX4Wy5gngYlNrIo6SFfVMIJbYKE8FN+Dml1a2EuqLUbzwVBQH6F8K2R5EvunRK/t0OHMl4M4kQKtHS5fAmBnpmPr8+ZsPqzG7/C9G4/xzX2qpejo0TB/lrg6Rf0HYgv815GNn9Mm4fytDbrQ4Nk9ixybMrn/wS6yvm8Jsrtu6Gzjevqi/LzPWLCyNI4T/0j0nrJipCHUf6oKB7wc5PsOxf4kiP4rRY1UVfC06cYgxeCq8ffOqb2S5h6KRJgowNfOQA3mX3muHt2TN4Ql+3dtmhll+Vvxk2HfMffSeLtqHWTPnWM4TT/wmgI3HQgnBOl8wCWFod9OXRcBZYw7JZ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++n1Mvu+cMQwTuVNtpLq5eHwdRGWPMt7x9B6IM+mpuc=;
 b=fRNYz2weQn0o8+pYqEcq58qy+0kEP9WmWOoBjE6ZWfbSNKkxTksTSpDgf5gTsxb9KcJaj8f4AXKG+EG6eIoKL0PC+sDNdhUGuWIjdS87mZ0CuV/ApOJUURWDk3GCKOCb3r7hp4GL+0/0mvli5ZG+raaL003HCbsOQznKCOiL52w=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6696.eurprd05.prod.outlook.com (2603:10a6:20b:13a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Mon, 15 Jun
 2020 11:05:53 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724%3]) with mapi id 15.20.3088.028; Mon, 15 Jun 2020
 11:05:52 +0000
References: <1592040362-25389-1-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, vladbu@mellanox.com
Subject: Re: [PATCH net v2 1/4] flow_offload: fix incorrect cleanup for indirect flow_blocks
In-reply-to: <1592040362-25389-1-git-send-email-wenxu@ucloud.cn>
Date:   Mon, 15 Jun 2020 14:05:49 +0300
Message-ID: <vbfr1ug612q.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: GV0P278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::27) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by GV0P278CA0017.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:26::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21 via Frontend Transport; Mon, 15 Jun 2020 11:05:51 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b2e8ebe0-ec95-45b3-a995-08d8111c1179
X-MS-TrafficTypeDiagnostic: AM7PR05MB6696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB669684F23AE7B8490A9B0650AD9C0@AM7PR05MB6696.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04359FAD81
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qgx/NUePzxjmlQNHiVSikazZdJO96VoCB1+nxhW2YufL41lZJTkxH4scpyTMGHhrapU8QNspkv64a1v3iXOlStSr0/QWndlIiqUaLVzI9hA57p/bZCiEXXFb0DGy3ns++2kEFKD4b/T1iakaac6Fflsw191F9Z9zv7vyO4/MKqe562MEFhtk1o35ZUAGviyAYb+utt/Yz4PTf+NMmI7+trRexdZOC9PJA+dlltgwHhhd8lkemylhv642MKidTxTB57Xq0/EC+Sq9BsH4antnpBmb6i38VzVZiKLPVvrYz7lrUdWmW/ZR8JYP7BfW4xxHqA1PSUF2B2CDnSPpy7efFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(186003)(26005)(6486002)(83380400001)(4744005)(316002)(478600001)(66946007)(16526019)(6916009)(107886003)(66556008)(36756003)(66476007)(4326008)(86362001)(5660300002)(52116002)(956004)(2616005)(8936002)(8676002)(2906002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r6T8Vjxk/pEx5Xv2skBSio1rQrz3htumT4KwV84LKrEnDJLejo19GQpJJ1QIjOuEHLWqRzDdjlgaicP9KUHHV6Fxo3cINOYRCH5JmZCgXPb/Su7RQdwrdTivjlrEmnQ1qpceV+jxg4MeubBIU5xg2ElQbzTMGNaXLVZ6fPlo5Z0PkWn8LpPmFR8VchS+OM4OUIB1TIps8LRcqHOqLVoNDAoVAk8socioJvBVCbRESlApm4S7RyHsc8J+6hhSk61uBR5v1W5Ol1bW6Fl3UD97HsOxoaAobKjMkVMs8jA3fMEt/+ifgn2+YHYmjGWqGJ8+PhT9dhIthhyTjhGra6GsqDQ6N6/8+JzEYZrqhI62tGFH29a6ndkOtSURyHOEpd2vuZLOyIRsmfE3mJWDCL8IbALTdChA8owbFi1QN7ISgmUVFi99zTmOcZ7Wl/oWQnJhXYcLT+15n+iFNP1Ugq1R+WLCV7JbuQCEbun/Ip/RsMs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e8ebe0-ec95-45b3-a995-08d8111c1179
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2020 11:05:52.4968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnGy+PyfcQRcUZ3z5aVOgqt21nCp+l1wID3km4N4XempnOJ3R/GRtZ9I2BZVd23YTMdWVKQolrJVCSn82FrYBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 13 Jun 2020 at 12:25, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> If the representor is removed, then identify the indirect
> flow_blocks that need to be removed by the release callback.
>
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

Hi,

It is hard for me to review the code itself (because it lacks cover
letter, doesn't describe in any detail what problem it tries to fix or
provide steps to reproduce it, and lacks a changelog), but this version
of the series passes our test suite.

Regards,
Vlad
