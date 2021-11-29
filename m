Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A2B460E12
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 05:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhK2Ekr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 23:40:47 -0500
Received: from mail-eopbgr80125.outbound.protection.outlook.com ([40.107.8.125]:56896
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231447AbhK2Eiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 23:38:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3U06YUJH1l6yMkWijE63dTpCzLE4j/YmFDAEC9PcO3efEwkQ3c7SWwewQw9usdMTDfTBJXqiTAmk69m9rCLHPpmbqF+Ep//HtfsjqPzNJ2VPzbdtXkF/mAsQpXjhM/tdZTWrywB8g743SuAqAtclwUUyMfpHk2OPKUJXgsQozXLoleBCPz5kykuRzwJpFCkYSy1v+bKH6yJtXzo0p2IxFp50jsCRk2USZ5bxqpqvYOLvJVyi1Phh2LJbqVWIUWx39irU+R42TAeNjNuxys6U01OrhZZ6JmW+a9j2TKjjoiLThDkulJTUCX9vLeTUiQtPTejR5kj77FDaF5f7GQc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywc+JeZ3ExGWVWW1FtS3xo31EGOvCrxDO2kRh5nFSI0=;
 b=Zfo3dWP72k5Vwe2EjL2b/fbTj6gSgJdZkIrQ/oMkE4D0IK/lJasU0zyVqLKEWcpDa+7gOJgmy03od5muoBC5rhed6/W51H1LvKo/MV9lFDvpK0FxdJesaGjU+9ej1n7trMzmnAdcML8dcE5Eu9XF8MYINaFBAmBLWvCezF8G1QGSTrNIYKvw4xk3npbeJ30FO4aBzBvzagHT5f9uOJbmar+D7ZiBeMbcCjGIXXkbKJUG1OdUcI6MZ+u8kpBJkRo5ftOwZUz/Uqr5TpDezHMKXL2+9e51JYR6x1IymbuIEQ62LlD67E43Tjn4tQNediPYrqkWWl9ySciRkinknMPJkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywc+JeZ3ExGWVWW1FtS3xo31EGOvCrxDO2kRh5nFSI0=;
 b=NKKPzUMlvavUa9veQUxl91nucCfzLdPq2JQnRLEDXZ/Y58KaevOKbJ+HsJETf8A/aoG6Hwx8+g3QSt9GnsJ9K8mKfzHZUUnrfnooJU3/JWHPnaANqmfbm8QITqITADgI2aM2YzSJs64kkBJ4em56TRDv31jauvVP1K2cTlckt98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB5630.eurprd08.prod.outlook.com (2603:10a6:800:1ae::7)
 by VE1PR08MB4655.eurprd08.prod.outlook.com (2603:10a6:802:b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 04:35:26 +0000
Received: from VE1PR08MB5630.eurprd08.prod.outlook.com
 ([fe80::5807:e24c:a173:3b71]) by VE1PR08MB5630.eurprd08.prod.outlook.com
 ([fe80::5807:e24c:a173:3b71%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 04:35:25 +0000
Subject: Re: [PATCH nf 1/2] nft_set_pipapo: Fix bucket load in AVX2 lookup
 routine for six 8-bit groups
To:     Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, kernel@openvz.org
References: <cover.1637976889.git.sbrivio@redhat.com>
 <5577a613f815575804cb19754f064071b852bbab.1637976889.git.sbrivio@redhat.com>
From:   Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Message-ID: <5dc1bd99-38ea-a136-5b98-05fc366ac310@virtuozzo.com>
Date:   Mon, 29 Nov 2021 07:35:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <5577a613f815575804cb19754f064071b852bbab.1637976889.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0601CA0071.eurprd06.prod.outlook.com
 (2603:10a6:206::36) To VE1PR08MB5630.eurprd08.prod.outlook.com
 (2603:10a6:800:1ae::7)
MIME-Version: 1.0
Received: from [192.168.112.17] (94.141.168.29) by AM5PR0601CA0071.eurprd06.prod.outlook.com (2603:10a6:206::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Mon, 29 Nov 2021 04:35:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a71a31f9-6ecf-431b-defe-08d9b2f1a9b1
X-MS-TrafficTypeDiagnostic: VE1PR08MB4655:
X-Microsoft-Antispam-PRVS: <VE1PR08MB46557B664F637D3A06B77487F4669@VE1PR08MB4655.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ovl9BHGl/VhrnNf6CEtSts1m/DafxM0V8d3eK5ENqOLkqmdutvH5vpNbOGiFVROS5VlxK/vn2eppwj5GCV5ndPRM8GAvuri/pX5uMJ7I42PaGyoZLN3fyfwaO6wsEY9TeiiRMOsafjgqGagFTZ0W66s7vTB+WV+WEsk8OqVbRfGrC41SlXAMkqGiJEpWCoeDmVUbl9Do9opaU0MogqPE61o/X8r+YCNI4DXHJ42PL0VHx6Ti2s36tkZ/XHiIjB9X9mxt0KiayD41+wHneqRJS0vh1zg9JQsd2zWQEpfVGkpCGddfJK3WVY4lhldoLU6YoSEoz8ndIDV9vbnMVnd+oqTsEUPs+VT5Fqf4fe3xadlRN/MjftmO2kAjk/8O19SjtfRfTUN44OfYPxutTMHZ+p05un+zFL01RMvGpGxi/F35tXflsXwM+tAggIPcUzRPzMEQmTkKdLJ326JQt8EV5ow7vq9v1OC8rswXIXC56hL36TT4YYLoiig5zs6M7Fh1z0GwJo0HhkL3eKQtJ4UZC7VMTexBa+wdX17slUWQWwjjbpei1Iw2sN44C1HmbEIupJs/beAw/BP6CdaF6NC/BqOq5l/gc5QaSPHLFkDIrGkzMLOLswAgJb1CF2tyV0Kgmkd2ASPNM6lNf5jP+C91lg0PE4VKOK35H02VWL8vum7sNejRFS9NLuNLDqIGICDipAhdoqTlZ2uXMK8pjObcC0x94Hhw8/jX3zwamgEf+mM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB5630.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(26005)(66946007)(31686004)(5660300002)(186003)(956004)(2906002)(36756003)(508600001)(31696002)(8936002)(44832011)(2616005)(66476007)(8676002)(110136005)(107886003)(6486002)(66556008)(16576012)(4326008)(38100700002)(86362001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STNNeDNrZWZ5V2hUOHY1TExFL2cvVjRmNENWa2J2STc2L1ZOekt1WmZlQU1r?=
 =?utf-8?B?amF6VElHbXlyaXE3WVFzV01WMW1BWHVzUXI2TkNLV0JrTGNBQWR1emlCbVdJ?=
 =?utf-8?B?eGZxV0EzTktCYmZnYktDMWtFNkFoUE03cGhSQmxmbzNJSTVaQmhlSHlhOEJN?=
 =?utf-8?B?azZ5YmlqSzJzYWhOWHd1MVpkdTlaTDhUWDNwenphWmJIbjJKUDBGSHJZYWJw?=
 =?utf-8?B?dnlJSmFrazEvUlQ1d2NBbDVUTGI4cFFIdVpxU3V1ckFBWXZOc283Z1NWRFBq?=
 =?utf-8?B?R1V4MXVoR1V6SFRBSVhOTGUrM0o4ZnZKT0pIaHJIR2FsNmZ1VldmSnlXM2Ja?=
 =?utf-8?B?OEF6ZnQrY0VnUTNzdEZRVFVXSnhFTDhNVTliUmNJQnp5NzdBR2s3STZtRDlK?=
 =?utf-8?B?aEt5WmRqMTBUQW02N0dNeWlCSjVYcFg0aDBzSkdVQVhENFJwdlBNNWh4VENL?=
 =?utf-8?B?TGNidkgzMTBKSjhINEh2WnNyblhqMlRJSU5KeWRSMGJBY09jcmhWMjRTckdU?=
 =?utf-8?B?UXlrTGVBT2tuM0Y3K3dhbWorWkxHb0lGSEFIVzNQVGxMeHFYQUFydHdtUnZh?=
 =?utf-8?B?U3crbkRjNEo2a3lPeHdjU3YrQXhoVTI0R041U21sZGZqTFFPK3c0YzMza05S?=
 =?utf-8?B?eEhBYWxobi9GZ0RQVmEyRXNrSVlXMjltQzZ5dCtzT3JKMGRXeVkrdVFBOGg3?=
 =?utf-8?B?UHA2Rk01L0Jkd0RFaThMQVE2R2NMOFBCalM4N0VIK3RQZC92cGwvd0hNZFMz?=
 =?utf-8?B?Z0VLeDh1THprdGcvLys1N3RJMU5ITCtLSDZTR3RCaFlRR0lhTVNTUkw4YnBG?=
 =?utf-8?B?dCt0Ym5vQU9uR3dUYlBZUktiN1kybFZXRnlpUUthYlJQM1ZqTnU2WWdNbVhp?=
 =?utf-8?B?Y1BMMlU2aHp0ZW1zczhoc3JvQkJhTzJYRDJsUTJLYWRIT0ZZVW16OWJoR1Av?=
 =?utf-8?B?czUyRVhLZmpDclNpRm9uREpQdmplVWprZVlmbGVadUxraFZDWGRvc2VONXJa?=
 =?utf-8?B?QUZ5WFhIWmZlVDhwcVRFZi9jaGw5bEZpZStZek5ydDFkRkJkdXR5d3pmSVIx?=
 =?utf-8?B?Q1VxS0k1UnAwZU5vLzU5N1hDemlqVGZMamJJM3BjWnhBVFc4Zm56WjIvWDN1?=
 =?utf-8?B?bTBLNlpneFdXTTlkTEptaEt4UnFJVm9yZG5mWHkxOTV5Ymowbk5WbzdVZ3Zv?=
 =?utf-8?B?V3lkVmFEQU5PbW93ek04L2hIaktHWTNudG1DWmpyRmNHa1pCU0RsQmJTaUhv?=
 =?utf-8?B?UnNyTVNxYmRvK2U3Nll4L3d5WHRUZWZuYnN4Z2t0QTZGcjFSSklFcHVvbHQx?=
 =?utf-8?B?T1hyMUlMN2c3b2hqMkFIekh6aWJNcjBkQ2lDOGVabDQwRzBZa3g1c1VLTVI4?=
 =?utf-8?B?ODJmL0FBMk1HWTl1NVdNZU5xQnN0MVZXUHRvWUVEanFsb3N1Y3VTVHJlTkpn?=
 =?utf-8?B?V3MvMUFzUHNvTHFKWlBoRE9QZU1pVzJTMDQrZ24vTm5WNmNNR1ZwdkRQZzQv?=
 =?utf-8?B?MlRuYU5LcWxkZEZKcHUrWVZEQWdHaHdLbUlKNnRsM24rb1AxeDFzVld1T0lo?=
 =?utf-8?B?UG1WeFpkYVYxaklIMHFOQ042NGk4YnB6UTN5YVcwbS9JdGxhTGlERHY4UGZG?=
 =?utf-8?B?T0EyTlMxOC84cVF3N1ZiUW1kRXVrSnFZdEQrMHZLSVBVUVRJaUlpT0p3eGl4?=
 =?utf-8?B?WlRINFJtOHVFMHRPclVlNnk1RFVsUy9rZVNkMmZ5M2RSdVBKUVJhZ3Q1MmtX?=
 =?utf-8?B?eER2dHU3eTFIS3V4c3pYaXBNbnRGa3lSZ1Erc2J5KzRqQmUxd2R3SUlQOHVv?=
 =?utf-8?B?aFBTVGFZbEh3cHNtbm9jZFlmR0d4aFlKWW9HSnpqWVRQZmtZZzNFbUFuQ0Zi?=
 =?utf-8?B?MXFJdHdkNzZ3QzhKUGhFcS9BS2FkNFZiQXJsVkdaVUZmL2ZnK1prME15bUQ2?=
 =?utf-8?B?ZG9ReC94UEgyc2pJdHFTVUc4QUQya281QXFybU9EQnVPTXFCVVJDL2xvT1ZK?=
 =?utf-8?B?NXRENzJqTkJzZkwwSUVVWUdxQXMyUmFoVW1MWHQ0dXkxQ1MrNDBTWHJHQTZ4?=
 =?utf-8?B?bWxDNnNOVUJtbUxvRGcrY1dROE0raE9vTGdSbi9qK2hYdkkrZHJtS3hqak1k?=
 =?utf-8?B?MG80TkJRVEM0djI4VzlrNmdsRHlkUnNUZmtQNE13VjVuVVZua2phQkFDR2Rt?=
 =?utf-8?B?NFFKVnc3RXd6K0lTTk85SzVwZmFEU0xBWEdLTzNXYktZNENoUlpra28vcS84?=
 =?utf-8?B?aUVYcDF2OHNoZjRVZVFOL3NpOWVRPT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71a31f9-6ecf-431b-defe-08d9b2f1a9b1
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB5630.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 04:35:25.6690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpjTL+jVvQgyNxoKPlwn1mM49AEcBgP2/9Rc1jOGQ0zrO1Mrs+uRAhyWUF25/OeIfi5XKwFV6XeBtiEmN3/g5xaplT3Y3XPGlqb2S6FpSDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4655
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The sixth byte of packet data has to be looked up in the sixth group,
> not in the seventh one, even if we load the bucket data into ymm6
> (and not ymm5, for convenience of tracking stalls).
> 
> Without this fix, matching on a MAC address as first field of a set,
> if 8-bit groups are selected (due to a small set size) would fail,
> that is, the given MAC address would never match.
> 
> Reported-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
> Cc: <stable@vger.kernel.org> # 5.6.x
> Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Tried it. The issue is indeed fixed.

Tested-By: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
