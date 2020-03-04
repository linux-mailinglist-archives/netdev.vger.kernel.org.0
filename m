Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81D1178CA0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 09:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgCDIjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 03:39:22 -0500
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:6017
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727026AbgCDIjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 03:39:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwiIsKye012xbwgSNkhNaB0HFo72lXBHk1rZrMUutGaOusd+xnBiW3hSRBB76OJ8syeGW3YwMwG852HCF6FnNjn7LZ93JkS6AT6WHUhKCve4/Cw5zTe140TzsfbiuYakG0fQbr8yPUbZvOUduc4qRlxsAZ0WJe4e5ptZSOzyuPTk/x0Jkg3t5MgiemTEh9KewZgMMhKSiIsPaLhpj5Dj7JeHuUHdgDEDf+O5NMMX3cz+bG5jFDcqPFY42NUIsBnM4pFEpoacfe5XJm+LpVwBxjK0AZ+ALUjx1vPZy79P2cX53w6A2pg+2x7C1meWmxP6RRd1yTOR+zPAHPx0RaLjeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsqVOBlylxFzhBAeR/UePvJ8A83vDrevQHxykVVELUQ=;
 b=GH2TXW8btkJp3ZG0yHw1b/sf2rofYPpzaWMKqvZoCcxLvSjEDOwRUriqS0GRUl19Jl2bqArRsduj1NXlGtdyPvhLZQkykS/YDM8kvzOCD4g+fl/LyMCNK5b9sc+YjxJ0h8PuXZSrSlRm90BcEpiAzDvT6tokTUObsTVL3IiCY95mi2TKimizuwnPH/Z6/H24IBMqxX8ztV3IogbIF3W9BvzvEu2KDhFkCQwoZKEgv7qTYd1/cI7CQK8oGHvpRyDqMZxO/V3r7eXxvvzBJKcnDW+PdC2lapXG7VZfq1qFKLEtYtY2ZLlZhOaV3nmNjugUOcFDoYlY6oJEtpigdJbEog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsqVOBlylxFzhBAeR/UePvJ8A83vDrevQHxykVVELUQ=;
 b=Yat/smJ+Iq389tMDEbLGz/GwyQTXa7IT8eyBemCz1qrLDzbw7BOuqMUNkRqn06w5CG4Xom+2TyMIKO9ixyoArSNk36s8mIhHYnfl2Sc7VsR4wAZ/U6vDvJP+HNk6P9uHm2afTmY9YB+XNnsMJ6W1N1jN8o7W3e/+xE6VhXDHlVY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5128.eurprd05.prod.outlook.com (20.177.190.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Wed, 4 Mar 2020 08:39:17 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 08:39:17 +0000
Subject: Re: [PATCH net-next v5 0/3] act_ct: Software offload of conntrack_in
To:     David Miller <davem@davemloft.net>
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
References: <1583245281-25999-1-git-send-email-paulb@mellanox.com>
 <20200303.154403.2134473467599378075.davem@davemloft.net>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <1e2b3430-b5c5-c4a7-3a88-eeeda47230c8@mellanox.com>
Date:   Wed, 4 Mar 2020 10:38:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200303.154403.2134473467599378075.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0098.eurprd02.prod.outlook.com
 (2603:10a6:208:154::39) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR02CA0098.eurprd02.prod.outlook.com (2603:10a6:208:154::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Wed, 4 Mar 2020 08:39:16 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f57108d9-7c3a-4cb7-831c-08d7c017869f
X-MS-TrafficTypeDiagnostic: AM6PR05MB5128:|AM6PR05MB5128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5128D68466061B7D6D497569CFE50@AM6PR05MB5128.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(189003)(199004)(31696002)(4744005)(6666004)(36756003)(5660300002)(86362001)(31686004)(4326008)(6916009)(316002)(107886003)(81156014)(2616005)(81166006)(2906002)(16576012)(26005)(956004)(8936002)(8676002)(53546011)(66556008)(66946007)(52116002)(186003)(478600001)(16526019)(6486002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5128;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYwAmoLmEccyJpMD3T6p1SCflKEddrMC5c3bhkxkZow3IkUPbbkHkKGlCHbHCrBEexc/66rLJFf6O7/sn9OXS/mvVfVkqMdkdnyyiahSq7ufstBBZL1BsCaAFxRCG5yXuHSrcUxCA9yokVU+zzcVPODlTxBa4/VQZh9I7fKymp65vNm7WRa3ubG+sonn7WbbM1UlGLQyu0dcHV9FSk1mFvDHe0Rj2BaKjjeZwhX9jvHj5G+Ic5/dsNM6zsLVWNp2sybweDNmj8TW2+kH6VCfEipSFDTddg+KnotBb2HJPhz2+LgoeakEVuBW6L1sLchfz7UiC+i7W5Dmftvl8syeDHPkO8CdtCormKA4vF5gCYf220jpttHzG6YSaPZKwzF5EnHOFh+sCSGBEzrbdAE9FFqcHkySUxBDAYVs0jvIrFREyurMZcXlkAPu/pfFzNsp
X-MS-Exchange-AntiSpam-MessageData: bhyWHIzl9lKfOcssBqonmwxaouF+fy0vdKcIarr9dNLilbYQ6mD/g/BHFAzvqTbHWcDMwjrvS1sw15552h2xrw2HNMDkVBylFrTm97ncPy3iizY/xjyV2G4R2GKXN9E5nURo6bhDRCTq/3vZdlQcaA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f57108d9-7c3a-4cb7-831c-08d7c017869f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2020 08:39:17.3724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K73GUN71FZ5s+iuC4RbEFwZcqoBMvV29CyNRtiHL2G5pN5+4fnf36ftubY8k3YTfzC9Fp+D6vKVd/pCqAKXGlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/4/2020 1:44 AM, David Miller wrote:
> Ugh, so I see that I applied v4 and even this v5 is going to have some
> follow-up changes.
>
> I can revert v4 from net-next, or let you just build fixup patches
> against the current tree.
>
> Let me know how you want me to resolve this, sorry.

Hi, I'll rather submit a fixup with the diff.

Thanks.

