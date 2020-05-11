Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549D21CD287
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 09:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgEKHYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 03:24:51 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:28132
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728017AbgEKHYv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 03:24:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRkJAnjgmhQMShz1DsBgaO91z2l6sleLH7ESJfdTwe9Ni8oDcYxmI3Kts4mkvcnxiuAK5kOLj12YSWc/Kq0QK4jVRauvYfG6U5HadxyDJMwMPTYhH07ea8Cnf73LiDNQc1M36dMkqeWE3T7X+4UNG2BdVB+4k5P8S6Lr26D+kTJZc758dvaPmUI2X0ZH+xrA6pXKGbCzASFxRp/1M6zROVXB1ayNbJ8ddZBcUf4yJZq6cyquu9IWK7743waVwa9wcziCkPm78Lup5eK6QHRzxmNLObNOzz0Q6bQNPtRQVzh5P8iAouLqfqaSaiDElhM/6vUqYe/Z2+gmZlaDOY8k2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXH7HC8cgeE7LiUHT5zRSeVm+VVki1yCFW5LWNYzIR8=;
 b=Fez8KYx6O1MnP4TO86lr7b6//AMScuddvKiehdfWZLTroc8cRF8pDmzFHTQPBTuYSB6R8Ey9xSSDHt/1kfqMCPLHYaq0cEIpN3u4Mdza2EWpICXLIdlSAJXGKyDeYRwV/E9g2568vmqesnhcPjUI8BC3GF1qGi4z1l/hR/iqQxRukice9/pnDI2EsqWiwtl4eolrS1HaMA/XMPQJ56r5Uns77bvXZo7l4Z1fX+qqHUkpxLUDVa8cuyYVNeBCSWgN/Sj6gvIuljJv5JTwwo7KGV5wOid4Yh4vB2tUXeaBHO2gbFQDIHM2oS6EUu3//JeVeMcjEGB7DrOeR+AIPDrCbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXH7HC8cgeE7LiUHT5zRSeVm+VVki1yCFW5LWNYzIR8=;
 b=qE7NWmfvAsiA9kd+e2YWcYSrvUHQtFNPJuc8krutUt/sviO7FOOJNSzPjmL9/9HUyq8o3U62eVcDYbkPWCrOvbhdm2CitByi2jbzeW/0SIsKA4V4JeYX+2gHaoafySr6w5GkFFnNVa86DtOWK25+v/7VqSMwl+pWRwwVaZkKBcI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
 by AM6PR05MB4837.eurprd05.prod.outlook.com (2603:10a6:20b:6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Mon, 11 May
 2020 07:24:47 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 07:24:46 +0000
Subject: Re: [PATCH net] netfilter: flowtable: Fix expired flow not being
 deleted from software
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
References: <1588764449-12706-1-git-send-email-paulb@mellanox.com>
 <20200510222640.GA11645@salvia>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <a420c22a-9d52-c314-cf9b-ee19831e15a7@mellanox.com>
Date:   Mon, 11 May 2020 10:24:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200510222640.GA11645@salvia>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::39) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.62] (5.29.240.93) by AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 07:24:45 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d213115b-2a99-437c-d7a0-08d7f57c620a
X-MS-TrafficTypeDiagnostic: AM6PR05MB4837:|AM6PR05MB4837:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4837AB145531A06EC031F888CFA10@AM6PR05MB4837.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QYungjOogOWvgdNp1+Cn6TiyslIUUUwHg33iUX9DjBobTGFdLHmtsHzhNornNZKUHmu1Wm3T5mbJ4CNDXOBRhkv78pit9xV1rSk+A431Yz6NxtXc8+dl0yEwPkoz6q1LT9s21NszofpKHIPEhgrm+f0zwyLGjFJJdQ/5tRurzIT3UEjiZk8Q0jzy+YxBknbxyLuPhBT3sXuzgdVRm5J2S+jJ8NU0l0RG7diHlVYFUCb2Do/Eff1983HXs9r+8EAZTui7yDCrW+THkoRGntwoNxNnXDy/8+DnoVE8RTL1AvZ6FDl2eITkc6SgHmZUcZYTw51EwqLnNFHuQD06MSv0oyZGY+93mTRvHtM4A2Opm2j1DMOH66v92MHXK4eKrnxtngIStLw2OS8Jo3HvXppnI9Cus4R5VoqR39waioAblyv4GVdAHkPuRmOI8j9keinP9wtXpu8CiGr9x845Zx99ytyn6WOBAqWiLcWleYPj4okoy3Jv1uq3OlLs08B11niIbDhjzyBM+FuBb1kBHK8ZyJkkLiArkrqi4HgdT7PnKFPfmIBTBGPn08OfKh+U/44P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5096.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(33430700001)(26005)(53546011)(2616005)(956004)(16576012)(4326008)(31696002)(6916009)(478600001)(316002)(54906003)(66556008)(31686004)(66476007)(8676002)(186003)(33440700001)(66946007)(86362001)(52116002)(36756003)(2906002)(6486002)(16526019)(8936002)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fMHVGKmIg/yXXg48WvJUR189zzJxXp6IQtWbfQh0lzqJOGWiACM3dYcJpgRganvqBk7J6U48CtQioDihJT4dm3XShWL6KswB1FU+fBmHsumqURUOHivkn0Lf0TNeC2TIMYP4wVLznuZ28y78FrrP0w/j4RgvVk9jzB92K6Y8bs0jBIdDiFVk7CuVXcqilcam/eoUv+BYHnfOKsZlJacF+AQx/ZqPctIGkiQMM8tHaCAnqoYlCJGxI9IOMVAJ3ETd2CMrotzd2nr+f+6T+mzB4MMqiKc5/V4M+sFJC0z3QOQ5mqgIVTatQV1H4rKl9Jh0qeUCsNIFzVsUXcTEWoiXvarmBJku/3AJL2Mvcj7TiLfOHv6ZGzYJj23wXl9sSSBtqv0Q/9dNzoTKDH3augj2z9FBjtQgn2Kkj3eBY04t2Xe4/sdKz3LmaNsE8ky5rico25rfA/UrSLief+2J9UqR4rkRdVdMMjNm29SEBYKNZkg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d213115b-2a99-437c-d7a0-08d7f57c620a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 07:24:46.7751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rx6Dk9Ajsb/XI9wTElGLB51O8hbM533w/DO2bejx33hkh3Urlp9nr/8nysVtLjRlcX0QIi9fK/OsaYJh96frcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4837
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 1:26 AM, Pablo Neira Ayuso wrote:
> On Wed, May 06, 2020 at 02:27:29PM +0300, Paul Blakey wrote:
>> Once a flow is considered expired, it is marked as DYING, and
>> scheduled a delete from hardware. The flow will be deleted from
>> software, in the next gc_step after hardware deletes the flow
>> (and flow is marked DEAD). Till that happens, the flow's timeout
>> might be updated from a previous scheduled stats, or software packets
>> (refresh). This will cause the gc_step to no longer consider the flow
>> expired, and it will not be deleted from software.
>>
>> Fix that by looking at the DYING flag as in deciding
>> a flow should be deleted from software.
> Would this work for you?
>
> The idea is to skip the refresh if this has already expired.
>
> Thanks.

The idea is ok, but timeout check + update isn't atomic (need atomic_inc_unlesss
or something like that), and there is also
the hardware stats which if comes too late (after gc finds it expired) might
bring a flow back to life.
