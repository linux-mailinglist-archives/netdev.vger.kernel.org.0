Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58EC20F772
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389071AbgF3OoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:44:03 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:56849
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbgF3OoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 10:44:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgmmyROuzyLnkG2igx1QVtdz1bj/POZhVKtGNYJrEYnFKV1n2+JKVbBuZAgL2n7XdIpxxC2AXMXUT7Y1Luc8MfYX2OIrmCs5khOGcY4eNktynhBrp13L66DkXtR445LO/O7AayWcacm2/Z29ZSFsyTr71HskTq6GSrV8uHD2o+Rh172hEGdny68TZ/623uqQIz7wIxsrN5pEkjC1G0Ycc322rVdwOjRNPYGAmCRpFaltHRGOsSEeaAWvLFZqxerepiFDtpLbIZYaaVUqm+g9RnhCtRlC5mmJcNZCbDNHFNssPIwktVl9/Lv71GfO+CtRxpwnUANlF28a4WUBNKdABA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNX6ajD670UpLGYvN8cR+QhT31OfT1IFjG5JkFipsIQ=;
 b=Z5nIDL9Sg3vORhrBiHbsBu3t6ekOiB6DcRaXR1wu98QJk+IX9/sLARMYO8wVmYWtjPxMOS6DcoBtijHAvN7J6se0qzl9Zk7IyiKFytCFDyF9hPrxJzCtrE451RroLmua7r+CVUQwk2VK02nkfjPwVjSmrQY8pB+yZJEAL9p8R3ekrWfEAtFrLlNHRfcEgKs42Oiz/HXwp9JkqvIsu5l+bnoLGLEAOeTmbLkZL0iCQbyZrs73EFhCFCluM1xiJwBs7fUn/Tf7XkcP+5ZOxwS98MVMcPkZxClA7rIj/7/CGQMJXuozLHLroILBbqnh27b5s6ymxFy7O2CJGux0xjqgPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNX6ajD670UpLGYvN8cR+QhT31OfT1IFjG5JkFipsIQ=;
 b=nS1qp6Lxb0vN5eJQjr0mpPCzx2C7Xry3ms+BbptoXbg4Y4HfiVce1/cG+MvqyvascXJKklWtGzH5/wFFw+judQJr74uNFV2w9J0IV+lTg5CobUuQALpPvr0Qd99l6GfGewWwt8OnVjI/nWE9mBirCF3LJRQOlzSYLqC8DCghOsE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR05MB5071.eurprd05.prod.outlook.com
 (2603:10a6:803:52::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 14:43:55 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 14:43:55 +0000
Subject: Re: [PATCH][next] net/tls: fix sign extension issue when left
 shifting u16 value
To:     Colin King <colin.king@canonical.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200630142746.516188-1-colin.king@canonical.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <dfb6ef40-d5ee-fd21-afb8-1632ecb03b6d@mellanox.com>
Date:   Tue, 30 Jun 2020 17:43:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200630142746.516188-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0114.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::19) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.126.86.173) by AM0PR01CA0114.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 14:43:54 +0000
X-Originating-IP: [77.126.86.173]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4da2fad4-fb43-4692-e950-08d81d0403c8
X-MS-TrafficTypeDiagnostic: VI1PR05MB5071:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB50710A45EE3651D28C3149AAAE6F0@VI1PR05MB5071.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKu91cKUsvuLRDlaOyhpTWPeOyOSI0CeZlMFmW2ylMJVgJV//LTQgfujkg6DPqFPcjrYsMIF882bTIuRV/c2vXnL+lLu1x/isPCiBdxKaCVYf2amaDMIW8LgysLGVRB4dBa+u20OOjMAZZpFX04VeIiu6+XTCOzjINnRAem1TAVBB5JepO9PgrUryFWT95cyjpfCn2VTEwab6BExV95tfg2Ozu1Yh40WCR14v6p0/4tUuL2l5Hvi8nHhLJFCxH4IivW1yQqdl5pF9gz0AeQcR3QWi4jd7Oa7xw9cEE3s+VbkgKt1Z6H+m9rc1Q5AhIJcMqA3KdiLEugM/4pilKyOtnYvqy+v97EkybeRwf1oe8LApxvDgcg7KvJZj4hbtoUp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(956004)(2616005)(52116002)(53546011)(31686004)(110136005)(478600001)(316002)(26005)(36756003)(16526019)(16576012)(8676002)(5660300002)(186003)(83380400001)(6486002)(66476007)(66556008)(66946007)(6666004)(86362001)(31696002)(8936002)(2906002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: knfYtp1WEG1txu5Huzb7kY/VvY86KlEtWOP5nscAQf38Fd+O+jwDNABXR6Qd1bu+39tCz4sLWWtEoA9qZaV+EkZY57CKleRSvtg5V+df3QykNXFLCJ67W72QzNHMQ59wwAP9dR23Jp1K/K6bdSmqBWc0d6Dr0fgCuUdRdYun3SovJNglyEeFpw87sD/sNwcI9BiqUGKhtsGVs3lmgB0YWtUL2ZF5QUjzxzNrFH+mniuDUolVHw2kNNesnn/VWZt7jI8lYNY2owVAqNxPIf9y3EssOpWbdJqhI/Bm8dVtBbBlvtJL1KzQr4oYu6KLNPINmBjE46O7x/pVFxkhE4hVg1jg/1mqjlqaCMobduq6g8jIs+JZdHMfiIZdiC9pKrR3/Xci9es5I1KNtXw9THBWgucPMP2LITOmVgvQsijBW57K5M0p4m/bmgYkKxBs6SvOQZHR+bBTnU9cGB4/HdApR4zDzVAw6LMeBvvelqVRYRwt8Xwk7NJWBNUx4/Pm68Sq
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da2fad4-fb43-4692-e950-08d81d0403c8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0501MB2205.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 14:43:55.6097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5n/A68Y6MqElXxlxLE7NUOi+FS8yLbdSaqgZW31LYTeWVJ8syu96uY06bDVKbP6T66vKkg9MIoUCY04yBmmww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5071
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 5:27 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Left shifting the u16 value promotes it to a int and then it
> gets sign extended to a u64.  If len << 16 is greater than 0x7fffffff
> then the upper bits get set to 1 because of the implicit sign extension.
> Fix this by casting len to u64 before shifting it.
> 
> Addresses-Coverity: ("integer handling issues")
> Fixes: ed9b7646b06a ("net/tls: Add asynchronous resync")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   include/net/tls.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/tls.h b/include/net/tls.h
> index c875c0a445a6..e5dac7e74e79 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -637,7 +637,7 @@ tls_offload_rx_resync_async_request_start(struct sock *sk, __be32 seq, u16 len)
>   	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
>   
>   	atomic64_set(&rx_ctx->resync_async->req, ((u64)ntohl(seq) << 32) |
> -		     (len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
> +		     ((u64)len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
>   	rx_ctx->resync_async->loglen = 0;
>   }
>   
> 

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Thanks!
