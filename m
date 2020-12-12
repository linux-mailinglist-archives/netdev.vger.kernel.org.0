Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B072D8572
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 10:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436773AbgLLJyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 04:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407336AbgLLJyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:54:33 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on20719.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1a::719])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A52C061282
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:02:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ygb1rQQWaewCFL6h0694vzfdMqmW3tO8NCitVz5XTVPwk6sWgIU3T9+Txs9townYNxlxCrTLmVfKZ/5QOEXbayRd9/N7QXCHjf4FfsLnPXTaGc9FN4zK9h/shJMgn4U9CTcXYFiLdPqBwPVk/6zpHaZrdJq/MjYSPyPg3DSzKqVR6dtm2sKVJveNnd5u8wpWw94XYzHu1xmzduHjWEQE0Eql7RFBRzh9otf1YGk6fuPOuD8kez8f2h6l6wGlHDQr3dm2tBdZipm7XVy/w4+Pq+x0FJ5rE+nN9PzJGDkMAtuzD2XpqzJWBYTeaO1L609Q9aq9/yWnchcBvEC/dx7u3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNnvd5SCktjfeY5vI9+05vaBqiWjq+OXkPnpQUA3dDo=;
 b=GXPFTif7xVfqeUpe995RFkm1x39QGOeNAmFy+i7x3F/FD7ZFwHWOBSJRJnqEJuNZGEq8jtD4RN5g5fGJJsx2KXbtpfN7zEXBdOJ0AUl/9496UTXwKIILgsXi01gV4redgHnwqQfkeRfj4DM1edjgf7Xjdmotox1MyKiRHhezM8n80FG20U+7FxHRwUyleCTy633WFXFO868NLpylvgJ/N8zsieqyv+tbR6OqUG12ItYZvQ/fpvvgH7Er86VUsZfTiy0GAxTatnku61iXJBd1TIEe1wucbFB3s1o2ZnsuE/GO7gRNu840o8JkW9Gg0WSKY+qnWu7TnhSwp1yvqlNi8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNnvd5SCktjfeY5vI9+05vaBqiWjq+OXkPnpQUA3dDo=;
 b=G1Wq0mJBPynba4sPdlKKIDDYWbmQ5FsKGtpuxRNZcy9FdxrUoT+ijoFyLVeRA7PgisW6/nJQPmqE00VzAzrzwECJXQoYYna/+HebxEPlsi0act9395N6F6gKvVFikRLjabl5XKS1c+mqouQFXkWfvotGJAOvAfjfinf97aqYcVw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VE1PR08MB4655.eurprd08.prod.outlook.com
 (2603:10a6:802:b2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 12 Dec
 2020 08:29:51 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.020; Sat, 12 Dec 2020
 08:29:51 +0000
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
From:   Vasily Averin <vvs@virtuozzo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
 <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com>
Message-ID: <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
Date:   Sat, 12 Dec 2020 11:29:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR02CA0124.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::21) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR02CA0124.eurprd02.prod.outlook.com (2603:10a6:20b:28c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sat, 12 Dec 2020 08:29:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 065e7dbe-ae87-48a3-3314-08d89e781822
X-MS-TrafficTypeDiagnostic: VE1PR08MB4655:
X-Microsoft-Antispam-PRVS: <VE1PR08MB465540EF0B76E26183E898ABAAC90@VE1PR08MB4655.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2J7ua+b1n1wCFRWEueuF3qV96zliugGwic7jHPQfMyBTjgKFdMDk/7ssyOws0NEZyhgwpa2+iw/kUOLAx2noJX4bmU59nkivsJ/djf4Mox1B51KmX9VO/EOAnm1+TGfa0adbwqPwyy1YMy21Vrlsj2rFz48n1/qGl4Z5bj+Cy+hVx9itf8Zp+zwpFwmy5KaRS2iirphFiQC0wlhDXfK6D3KNizRTuCKCwUta969hfTXdwHHG+inIqgWxRycsEWgqHBH97TiGiGWMvTWJZpscMnCZHocEFBu/QL8sadG6tewIYvBz/JeVN2kZVicjPg/YLdAIOQKj35Dhmtio8hJX5Layo8XV7H/p6W0vuXcvlGa9qC6kMY9MOYHTyWgXoeApu5GUclacqrNIO4FX7NykCcAFM27CsPI7jQuhCCb1lM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(346002)(136003)(366004)(396003)(376002)(83380400001)(53546011)(2906002)(36756003)(956004)(31686004)(2616005)(52116002)(66556008)(26005)(16576012)(66476007)(110136005)(16526019)(186003)(4326008)(66946007)(478600001)(8676002)(6486002)(5660300002)(316002)(86362001)(31696002)(8936002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YmlnRHZ2Wm1ncUg3NkdoRTdPd2NJK2RVRUhNTm1jWEpyeHNicXRVWFlQKzJ3?=
 =?utf-8?B?WUpxRWJBRmlCTDNwQkg4TkpBdHFuTWxtYnZodU51ZXQzdm8ySmJJWk4ydnZu?=
 =?utf-8?B?dlA1blIvYmUyQUNoSU9nSGlGMDRNRHJRY0dPRTUydEE3blZNdWtKcmtEWUlM?=
 =?utf-8?B?NnRxalFxa2NaQzF1bW5NcG42Sk9PQ0tMcmZFc3RYbHp1RWl0SzRQa3psdlM4?=
 =?utf-8?B?K2JqNkNYU2hTZ3FnZ0JJNmI4dW5iYnJTNzEzL1FCYmJYcnV3a2xacWxuSmMy?=
 =?utf-8?B?RjJiQU9GVlVvU1p1MmZpUjNmYVYxWjFsWHJmSHFWenNuYmhtSmxQSmIrdVBN?=
 =?utf-8?B?QWdVdFE3d3NwdlJOSHpTSEFsbGNqWkIvUXpSaVBrRndNY3cvb2dKWHJvTlJo?=
 =?utf-8?B?L2E1UWQvVWRKU1NKNFdQUG02SWk5Y29CbXUzalh1RTBlYkVFSW1RcEIrNkZK?=
 =?utf-8?B?OHlhdzNXZ1B6bnVkalNBZUxFbmRJcWFiYlJHa2JsMys5ZklXNG5XREhPeDNh?=
 =?utf-8?B?a1Rkd0hWOG9XcWVJZmF1ekhESm5CQjRYdkNpUnJqTENkOVB5bEltZStPM0M3?=
 =?utf-8?B?RGtHczhMYmQ0Zm1kMTM1MEUxUXFXM0cwbUVIYmxHMEN4VmdPUXFUMzJ6OWV5?=
 =?utf-8?B?czRHdVN1TnhKQVpuemJOblIrYUhtaDZKWnlVTXFZYUpmM0cvUmNkNDBFZWZn?=
 =?utf-8?B?WXIyc3M3M0xjaElqYXZweXVNL2x4Q2pwZ2g2dmhxTVEzMGFUdVg5eEM4SVly?=
 =?utf-8?B?c3RtUGVLY0dUK2krYXJyUG5lQ1F6Q2M2M2RnNmRDU3JyTDdibEY5SjZqUFpw?=
 =?utf-8?B?OTZhbDNham15Tk1YV1VPamQ4QnRwYW5CYkNaY0tkZW1LbDhOdER6TmNVV2dp?=
 =?utf-8?B?RW56cnQwaERTMEJxc0FETk1JS1pYK3V6U2VFUEdrTE5QWmVLbHVxaXB2dnVD?=
 =?utf-8?B?SzZMSy8wd2lvZWtYejlpaGhaRDY2ZmtFZk1Od3FLNU1pM284UmlFaFZUelc0?=
 =?utf-8?B?R2Jqd0M4T2tac3hjM2VLQVhEUEhWV2E1UCtkTmNVOFkzR3BBb2xoaktPWkNm?=
 =?utf-8?B?ZjE3VHpzSTFHOUltY2lndzkveFVuU0ljMnZlSHFVcVZ0NFlhbmQvK1Z5U3A1?=
 =?utf-8?B?aURxa0ZDR3JjMHdCb0dFeFpqMHhOZnhZcXJCa3Ztb3R0VjJGUjRlOUxjSnZm?=
 =?utf-8?B?dExkd2hoMUIxR1RyeE5Fd1FMeUtjdWNWNUZ6bnhzMURPT3NhcG15TGRLWWRp?=
 =?utf-8?B?T3JUTmlGdGRibXhpNjRNU3ZPVndmYkIvR3pveFBjU2ZUaWN5YnZPOEU3M0dq?=
 =?utf-8?Q?lGgtUzSwzg3++y8cUxpWwCxqIzgYfX3/Hx?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2020 08:29:50.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: 065e7dbe-ae87-48a3-3314-08d89e781822
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dE4ldtQ/j7mcHuzaIHg1jLIILlwvzYAqKTiyVrAjIJ/J24R5V0AQK7VJeQtSnLTllyRs7kzMTUDRnzq/48J8Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4655
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/20 6:37 PM, Vasily Averin wrote:
> It seems for me the similar problem can happen in __skb_trim_rcsum().
> Also I doubt that that skb_checksum_start_offset(skb) checks in 
> __skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
> becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
> Could somebody confirm it?

I've rechecked the code and I think now that other places are not affected,
i.e. skb_push_rcsum() only should be patched.

Thank you,
	Vasily Averin
