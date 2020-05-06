Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2F1C6E6F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgEFKec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:34:32 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:28619
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728716AbgEFKeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 06:34:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1AGCCE5foCBdpxx0PI2aaJ8krGOcCTgfxnxJUEmyNlUuLOGNcCDLSygdnDuLCWYAC+IOx9zvRr/chRfmQjGBh7PxaV6+bridyiNnGlKxv7J6g/NcXqI0lbMnU35dMReraaqzphJqNpMEf/oBH/70HWW7RPEOlBFGd9WnlXK+e8DD2eLj5r9duoqTMsp2bUs5OrHF3F3gvztJDHC0qOQ0xDQkNeGKeCI0oJ9l7QZdlRdYGPIoMMs8nys/pnCqUHK672XJxH1EBX7gZbFa/hi9xxP/grQouxLkrWWkdqmMTGcdVlyJdV3OH3Fapvzzdpy3nhvLyoqVXNGIa0BNPh0ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c02mXJR2ooGxLAfT0hk4DZw8EOUPKezxn12qKu/UL4c=;
 b=WTswuhn2aAv4DmZOlt2kVhO+HL5EfEKCdI1MzcsfzQ1GZVQh/H/Ui1TOBB0BihSpZ6qDh9xWO0fP2NPrCX7zvdVJjmbDZClhrpvJ8lciow+kQUxH6FHPXwHjKu/bFHj1Ke7uKs0EQCRWGkrBnBl7a39WT3WYRYAFg67f/AAM52P/BObwxsnOzPr2Hdc7QJaxTDj1ELAIF+08LbwSjuij8WHmMLcxPZggGsEjkvhmh2RLD95FRfgdFi+vu/0f+AWF4nurICIwLRzGTWFYI4nZIz5le0CjskIqS8e46WYVPOPG408BAmkSllzUZK8OY3i2PRn0BYCgPbSWFLPWbaSpmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c02mXJR2ooGxLAfT0hk4DZw8EOUPKezxn12qKu/UL4c=;
 b=lNRB3uhS8SrfV6/PnwwuLkusr79VSWGafiIoako2Eq0e8yh6HMOofpPbYOChozKvBYqDcC2NxWEybaETsq9KeT8YBy+T7Gia/g/XU7XedHeCedzBGE7VeUp550pMY5hUjK8W3srO2PvvuAjoO4QDeUWGSyRzyfTvFS64IEtQSHI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com (2603:10a6:208:cd::25)
 by AM0PR05MB6164.eurprd05.prod.outlook.com (2603:10a6:208:116::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 6 May
 2020 10:34:28 +0000
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::a8a8:5862:d11d:627e]) by AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::a8a8:5862:d11d:627e%6]) with mapi id 15.20.2979.025; Wed, 6 May 2020
 10:34:28 +0000
Subject: Re: [PATCH v2 1/3] net/mlx5e: Implicitly decap the tunnel packet when
 necessary
To:     xiangxia.m.yue@gmail.com, saeedm@mellanox.com, roid@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org
References: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <1fa1ddbe-44cb-3251-998b-29e7b8b8bcb6@mellanox.com>
Date:   Wed, 6 May 2020 13:34:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR07CA0135.eurprd07.prod.outlook.com
 (2603:10a6:207:8::21) To AM0PR05MB5089.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.62] (5.29.240.93) by AM3PR07CA0135.eurprd07.prod.outlook.com (2603:10a6:207:8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Wed, 6 May 2020 10:34:27 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d93220c6-8b4e-400c-f513-08d7f1a90dc1
X-MS-TrafficTypeDiagnostic: AM0PR05MB6164:|AM0PR05MB6164:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB61648BDBC68B91EF7703E426CFA40@AM0PR05MB6164.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEmnNpRaFhcDa/yrLm0ysXZByGEylvgDabcWhwZbLzujIO8ysDL35jjViC2P7Vlbp9/SK7r+9wVUwmFKxXCZj+AgDXl0o+IP/UB1b7WnbfSuhPEqhoB0hsb99cNee4+SipSOJAq4Kxx5dTHz2eVqpoS1mWn0fwNJ0r5vPxN6M1UB+7zEVCs7PB6/ezunli8jmUSvdEbAQoXmrGt+OfciaATCvS48ayjMnmbYB4UWxbiSrxAJ3YM7yx0qzPodoQXAgKqsPOr9ql9H2A9t1+x4OQERZaPVA1ux5NjhC5HmJx6f4AiMeYkKQzsAbS8MX+KvwPq0B1hndY0Hc43N3BALO7Pm8yuceuDoLk756QHoIZuBaGsHc9wRMQfEby97zyTrGoM5/TSgGGDy4HmDS9XAG0eb58O2eo9uCmdJOmu3WWoVG+4lxGiPwI9UKX3aZA8s+C/42W3ZSLsaeoKwCtUia2K+YKAaZvEMgRgvbUg2zxR5kOtSWtdy81uV19R/IfMc/LBL7Zwxqze4RtPu/iMX0SXwupS+0OL4Rl6iUBav4hswfh1rIQ6cQBfb4TGdM0OL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5089.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(33430700001)(31696002)(16526019)(316002)(66556008)(66476007)(16576012)(6486002)(4326008)(52116002)(36756003)(26005)(2616005)(6666004)(956004)(66946007)(86362001)(53546011)(2906002)(186003)(478600001)(5660300002)(31686004)(8676002)(33440700001)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mT0hjB9JtgT4F7SVaQI4xq1oAmzB4I1nJODjlYCu2+X69u5Zqb7h9nSGuboIZlOqC7UeTeOoFLCTc2Qv+j7p7rEr/fXBLllrfXGD76jjHZQ69No/kyQvBNEOMtDJjxKPhvZr1aLT/v4ukhR3Aj9no0Hze2dJuJ+bI2hKVU8pjWITJcfiPNYFexLsxmbdg1pbv1WIuw2Yk5WjZjAVUa9crtUfLaALp/a4ZKiB2xmqWqUizERwh00BCUU7VfItRi+dIqFgCK+zO2b+mGNJMAYFIUZMwatQqwYNeCjvAQ00WY7VrRlTaotNjIF1KEyFHnMzvK9Nu+b/Kuu69DuSmNoZxT7MSO2/R2TwEQJOq1XorbF2wnV0vBHK6K93a7h3LOLzP1d5y3HC7pPhQJLZi7TGNTXFuZYBwjAImkWOn1b+brHXUqhVqo909og5k1la+j7OIsGpU4Ru5KqfL2xrA3CdwztUG9RzrL1vuJlPg/6GtLJqoZi4Rq+9Ly3eLDq6k5tMTEA4h6fh0AABek9kqVZOXcypoW54DvgjI8e9Gl32j2+UcTKZas93BviilIgvgcZXr+IPBUULEz4a8gmLVL9KspEEYwh1BZS/tUtWPyrJJZq9wMzgjbpOb8Unl8Ys0N4KYcFzyqsHaJliasemTbdk6K7ah/51eQsM24T/rcuMKV2yaAocVGdHcyndFFky13mRMovpYS7kE9mp34a3+RE1VDTN/0cpJyMoQ3td0D/ncaOQRS2xbCu4Kmr0l1vBCNgjqqfd7TM0bAtMRHC4QTI/y83c0rp6SxtuCkNV+zwA8k0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93220c6-8b4e-400c-f513-08d7f1a90dc1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 10:34:28.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0l5wbaYLeITq423dfTyEJUE0fclxnonLshFQErdcfcnZ5ep/xdAdcsifHhlA+YR3Csf4IGrIxlZ97+fmNp3HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/2020 5:16 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The commit 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with
> goto action"), will decapsulate the tunnel packets if there is a goto
> action in chain 0. But in some case, we don't want do that, for example:
>
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200		\
> 	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100		\
> 	action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200		\
> 	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200		\
> 	action tunnel_key unset action mirred egress redirect dev enp130s0f0_1

Also the workaround for these to be actually offloaded is to use the same tunnel
match in chain 0 as well.

$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
	enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100 enc_dst_port 4789	\
        enc_key_id 100	\
        action goto chain 2
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200		\
	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100		\
	action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
$ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
	flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200		\
	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200		\
	action tunnel_key unset action mirred egress redirect dev enp130s0f0_1

or just make chain 2 chain 0 :|


