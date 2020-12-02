Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8A2CC266
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgLBQcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:32:42 -0500
Received: from mail-eopbgr80103.outbound.protection.outlook.com ([40.107.8.103]:52847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727942AbgLBQcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 11:32:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHJ9kk+lHaxRxZi1r1spJhu5kwbTgomMC+Y2MjWSOfYfSFw995vOuUovMTjVf1OIPdLN4z3r4ScjkWLIUw723wbDmPoIvHXloxcT+BhP0gc5Tb/sfzLxIvblgoGPRS1u7FBLamz0LaeEXDiz/4U6tLOOszGIzy+FprrAEocYu9HeryU6TFPkGvbJsM2ZP19UJC3rBD4wodaFYBwgQjKWmQ43prMya1dWM3Z+/+mliSwjSKU9Qur6a+EyiNYbScOJ1B6aHaXUpYmOVD7wGF5rH8cDZrVXmsLEN9LM9EKw9VnoXtRINQQE1tsqXcAvvYqXCmQ9qvVM/GEm8vsj2bSNXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qI2NSi6o8wt5S7bpeiA0KfdkiFGLI3P5JqIMJz35U98=;
 b=QDvgs8X07b2oz0D2DqO74jK8VA/gPcAPIJ1WQiZOn7x3trIL9FZZ7e/trWzemh75xdF5DGrprSlfJ1xgO0IGVygdumveyzCbRzhLpqAKJxcKi/a4Xuii9qvGDCLXf0sQ/hugj0pnRJUPdOxnl4gc5nfMGQlH8GOBWcuHLogf//ot+ifazlnKxRH7U4TC50dnBpiXM/gv2EjDJK3WIzeLESeqI4Cn67kvloECHjryeGb9CxZ8X6pvWh9L26J5Se+K08oTFZU2zsWC/qPd8yK2/RCwC/H0G3ntG8bMCboiDHj/gnlE4lPswL6bxwqQk3ed+cr43ejM22QJzAjLt3Cjnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qI2NSi6o8wt5S7bpeiA0KfdkiFGLI3P5JqIMJz35U98=;
 b=GOFeASi1nZa95R46pLsf46AewECyKUmSVOGIL7sgjkxlklUaJ05OVkFLJWzyDZ4B1xL59DH3Vidk5RZd+iI+4rqYDWJMDw0l2eQhw/PjX4pJIp46proA+KOk3vjouMfh6Jy/Rjn5RB9ksWSwDqjXaN7Eq8rSAD0VbBcwWIYVT20=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=victronenergy.com;
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com (2603:10a6:10:192::11)
 by DB7PR07MB5355.eurprd07.prod.outlook.com (2603:10a6:10:66::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.9; Wed, 2 Dec
 2020 16:31:53 +0000
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c]) by DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c%3]) with mapi id 15.20.3632.009; Wed, 2 Dec 2020
 16:31:53 +0000
Subject: Re: [PATCH] can: don't count arbitration lose as an error
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>
References: <20201127095941.21609-1-jhofstee@victronenergy.com>
 <434167b4-c2df-02bf-8a9c-2d4716c5435f@pengutronix.de>
 <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
 <0988dd09-70d9-3ee8-9945-10c4dea49407@hartkopp.net>
 <405f9e1a-e653-e82d-6d45-a1e5298b5c82@victronenergy.com>
 <b08226a0-bd96-637f-954d-fb8dedc0017b@hartkopp.net>
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
Message-ID: <defd8917-cdc6-3560-7b65-7b38980d3fa1@victronenergy.com>
Date:   Wed, 2 Dec 2020 17:31:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b08226a0-bd96-637f-954d-fb8dedc0017b@hartkopp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2001:1c01:3bc5:4e00:e791:efe6:bf00:7133]
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To DBAPR07MB6967.eurprd07.prod.outlook.com
 (2603:10a6:10:192::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2001:1c01:3bc5:4e00:e791:efe6:bf00:7133] (2001:1c01:3bc5:4e00:e791:efe6:bf00:7133) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 16:31:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd3b8015-69ef-454c-9e35-08d896dfc6f9
X-MS-TrafficTypeDiagnostic: DB7PR07MB5355:
X-Microsoft-Antispam-PRVS: <DB7PR07MB53555E94F17EADB6BCDD8005C0F30@DB7PR07MB5355.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I97eC2DC9mwVOyZtZI+CMPFMk5y1z3donPgp68vsl8gxnqgYTeboD/rbicTHBzvHtWHJmp8CVqZGWjQoYat+o7DiG/SCF5PvOFscMIU1CgL7HTrNi97IRrAbjBxbM2nWPq3jKG0BuXA4L6xMc5amflt1RDlhnJpC/CUm6g2K4BDUUsEY3br8an5m1L6X7+y6M4UGc34HtuMPdD1MxbFSgESHKF5780n0eMS/izlhq2zZpqwwRUSe1rzFX2dVAG9RioSSafb6C0Q3ulkXMC9ah+pP6jcxib0Dc+Sy4TcX7YMVjyJLY9XSW/5jCmMuRebkZUnOKWyQNBI8oXactCRxH5lmbJ0Lr+tD8U1XaIixf3OzDHiWCi5X9cg5xiGeCoS58KoCjYg7gujuwWEN1Kru5gCNxbvsBhccgBgzmArafew=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR07MB6967.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(346002)(396003)(376002)(53546011)(478600001)(2906002)(186003)(2616005)(16526019)(110136005)(31686004)(52116002)(66946007)(316002)(54906003)(4744005)(66476007)(6486002)(86362001)(83380400001)(8936002)(4326008)(31696002)(66556008)(5660300002)(8676002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R2FXdnpqbFFBR2hFZEx3b1lJWEsyTmtEM2cwbEcrTG5USlJvN082bm1jMUVK?=
 =?utf-8?B?TlJlOW55dllORzVXTDRkL0xyT3BQc0xYL2V2M2g0aHFCKzdwcGJqTE1vMDk0?=
 =?utf-8?B?NGZyWXBLeWg1akQ5ZTk4WE93Z0lzbG9NMHNOOVJTVGc1TUZyQkRuektHMjlq?=
 =?utf-8?B?dTVDVkRBSFRYQWtnT2NlSFcvS1ZUYUF3TitLV2VKNGhsTVhHQ0ZXYkcyYmJN?=
 =?utf-8?B?aXl5dGtSVGVESUtkTW5KbGh2TjMxZHdIdFpTd2MwYkVOSFZCTkordFlQakJP?=
 =?utf-8?B?SmtVMnI0VGt6TmdFREtFc28vK1A5TVJxTVdxemNUSlg3QUw1THN0SG1QalMr?=
 =?utf-8?B?cW16SFAyNVlFZDhvRmlUQWVjWWFwUUM0NXROakQyaVFuRS9UTmtTK0xRb0pX?=
 =?utf-8?B?eGVhQitaWnRsbVFBR09oUDFmOFZUSS9WcDNjMU5GR3J1a2l1SE04TktjVzhQ?=
 =?utf-8?B?b3g1STZrVUxkZWtrUWorMnBEbWsvN2hNRXc4cklYSDE3ZG9mWTNqV2hoNzVU?=
 =?utf-8?B?L0ZvaCtiZFV2ZUpXV3lNRW9vbVdndXVjV0FSaDgzQlNlR2FSV3VaaUhCd0Vi?=
 =?utf-8?B?Yks1QjZwTkxRKzlxUDlZUk9yMzR6U2lOSFltcElSR1M4bTZqWG5CSmpRSEhY?=
 =?utf-8?B?bGdlUXIvTTlSOWZRbGRRTUMrN1ZxblFjeHNQSXpBaFFJbEhmd1RYZUs3RXVJ?=
 =?utf-8?B?ZUgxRVFVNzN5YklFRXIraEFxTWl2TmVoemx4UzFlU1MwQkpMVmFISFNocE9S?=
 =?utf-8?B?bjBhV2J0QktLbEdrSWpGdTlReDRSd1A0a2VPSjdpRWc1NnJHSTBvT2xQbmRz?=
 =?utf-8?B?ZnVDR3RsWlUxWGJZWFZRMDgyd3N4QkNCckNPQ21rSWJwekZ6WTN4V1NCeHJY?=
 =?utf-8?B?VVdvL1U1ODFwSlN2VDE4SkRYYlVrK3J6RDY5b3N4VHVwRDNHN3UxNlNnYU5t?=
 =?utf-8?B?bUZjcnhLdjNuQmdsK1czL0pXUDg0Z05hQURKYW9BZlBhS2sxTmRORHFNWUxr?=
 =?utf-8?B?K0lwc1FqRkJNZm1mdEhkNlhnZEZRT2g2YkZVaEhiTk9MMVdqcGxXZEZabi9H?=
 =?utf-8?B?SVdUREtYZmErbUY0Q2tUVHVOUXdFc0plK2pnWG9pUUNTUVE1S0N2WXFXOGtv?=
 =?utf-8?B?N1VZamUxaFRUNTdmS3FOendpR0ozTGRoeTlaQjg1V2RYdCtuT0dzRmJlV2kx?=
 =?utf-8?B?YWt4bTVxSjVvQ0dXQUpoanpwTUtweEJlUnBTbDA2SnQ0Z2hDNGYvOUN0R0JB?=
 =?utf-8?B?VGNMcXJKaS9XQ2syTFdwK0luWnlQOFpyWk16N0pPd0lPZUI2a1FWV2syZ2Vv?=
 =?utf-8?B?Y21jeG80QitoZUp2ajJiNzZMVlZNQnNHUnBNcTRSL290dVNWQUlCbVN5dDVy?=
 =?utf-8?B?SXFwQ01SeG9KN2FqRG5jT0xmdDIyMDhJKzhrTlNyWW1MV0VpNVFQbzFkUk9h?=
 =?utf-8?Q?hMojUKK4?=
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-AuthSource: DBAPR07MB6967.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 16:31:53.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3b8015-69ef-454c-9e35-08d896dfc6f9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RoVbJ8+mBk7Tn9mJ710Dx3iMl4yX2wSAj9iuzr2xe/n+WNYIiVUXuZBcf/prYeKw5zkFJWjml/hTkBPcfl6Lc2aDYFNyfRJ7nbPdLMVjlUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oliver,

On 12/2/20 5:22 PM, Oliver Hartkopp wrote:
> [...]
>> Aborting the current transmission in non single shot mode
>> will get you there and incorrectly report the message as
>> transmitted, but that is not implemented afaik.
>
> Ahem, no. If you get there the echo_skb is deleted and the tx_errors 
> counter is increased. Just as it should be.
>
>
>

Ahem, yes. I meant how it is, so it will take the else
without CAN_CTRLMODE_ONE_SHOT being set.
But since that is not implemented, it is not relevant.

Regards,

Jeroen

