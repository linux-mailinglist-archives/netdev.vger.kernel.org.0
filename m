Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A400D20F975
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388027AbgF3QaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:30:24 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:12006
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728931AbgF3QaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 12:30:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpFd9CUBKYC4MNWcElD5SgG2ZiJFqQa0jpgRNLrQNn1IXZN4n8fez1U8pcp27WWPjl8DKURnbWnmWvGU+XI63fP8JzuWtM3JMceubf+0AnuUaYGFjphtlr7jStB9MtX+P3BfNeRRGzAPIJfwl+vZ3sTThxsPlAhL2t4Y8bI6Fm2kepcWOeYJzwGdOHEtam94H02NjLmwkpzh62FARwxP0gc1ATJ23w/jSfn5crsdtKwKIryLbVNhRLSBPaBncbEaqYTGeqS8HwS7yySJ8GoWOq2wk9TXqz1dkcrkc3UOKuWd/AbVXOYNKyJlmy9gLKopF3kTho4LyptLk4jMarAKJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnXfu0paMgHDZuPgSRYMEJjYEKH7bsB1DXAcGtUkyA4=;
 b=oRspW8aBhI9pl91GG6mkVm6Zgm2eiLLeoqA2p6NBPPyMda+OAmR5u41egUf66g+Nbbglz0jln9G4bDPkQC4veIsM/y1TAguxxbK/pFWNEorjZSFKia63TM4MkR4RjTCJTF9BzVU6Jf+Zjl3sXlTC+upKmIugYnHdPcqO4+Jsc1fMMDHUm0wZRtJa+BK/cHa1TG1c2aU5z6yBNE+vu+eULmQENZ+9zzPMiQOABuFQTEbTaN0ZnOPHTo/auh+aoddHMyjL2hOyE9pGirRVVC6UZ34chWnOlUDVuQC74HzbHnuCNy3j8Fu4x0AqJDIsny47fzH2rhhn3U1cmhEoTwXnEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnXfu0paMgHDZuPgSRYMEJjYEKH7bsB1DXAcGtUkyA4=;
 b=eKjqwS3MuLH67FxrNmz5JpilAQCvLrG2SH4c7+De7kEQJL6dXPo4+hnR23QnSE5FWB4bx7WwA7u+kSkT9vGd03ZukF+uKBbwe0s1hzRuigqQhTFSgnefDaMXgb4kIWmVhzrQa031ZKV5tx6YrYj6i32ms9eVa2340EwJzbS++HE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR05MB6333.eurprd05.prod.outlook.com
 (2603:10a6:803:f8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 16:30:19 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 16:30:19 +0000
Subject: Re: [PATCH][next] net/mlx5e: fix memory leak of tls
To:     Colin King <colin.king@canonical.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200630151646.517757-1-colin.king@canonical.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <7c3bb6e8-6658-1a73-b5c7-b70bc6255576@mellanox.com>
Date:   Tue, 30 Jun 2020 19:30:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200630151646.517757-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0701CA0013.eurprd07.prod.outlook.com
 (2603:10a6:200:42::23) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.126.86.173) by AM4PR0701CA0013.eurprd07.prod.outlook.com (2603:10a6:200:42::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.12 via Frontend Transport; Tue, 30 Jun 2020 16:30:17 +0000
X-Originating-IP: [77.126.86.173]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b9a14d2-7793-4739-9da5-08d81d12e0c4
X-MS-TrafficTypeDiagnostic: VI1PR05MB6333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6333F9C4A6E35C3CB25BEE5BAE6F0@VI1PR05MB6333.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sVMxTXPiZ7+/yI6NZQRg52g1x1b7vAVa8Ecj+B1zP1aOqZMQ4D4tzmoqCkzvdsM4bYdBEZ2joOoZ/kiQcC2SBTP039Rh0DqI+5IeV7vbmsiCVE/Z3HghOkJVfRD1CAgpcS0qfeoA2VbDmdMRx8hsAHUL8tWu3BOR7x2A6YdM1+LtYYW6eiW2r7EfrMqEzOfc4iNLvMnUTaf7ULYwOCigVzWYMVJbyzjbBVetqPI8DUUFt9B9xLngpD7/NGShLxqXv+LhJ84eYf3cLgWSgUyT8ImuCIhTheYZTtT3+Zh0O2YbrMJKmWNU208b6zt+l8kRSCslXQCTvGRDDe6+vgOI8aIiQZyCs4xDdnaSpTZYIDJCcz4h5iZ8m/PVXW3Cx0v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(31686004)(478600001)(16576012)(26005)(186003)(6486002)(16526019)(316002)(956004)(2616005)(110136005)(4326008)(52116002)(53546011)(2906002)(31696002)(36756003)(86362001)(5660300002)(83380400001)(8676002)(66946007)(8936002)(66476007)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qq9FTn3TtGJplUfJMRyD1YNZqZkIDNoKgI6+I9CvlSjokV3O2INM2rXKtbAvkM2RMOqyuB9x98j4haekXCpcBm03l5JU613Q7m4CckMLrq0gqVm0mE09BLhSm4Ph6IHzu72F+NlgJw6jTu3BOdyvG74LdbTMLBxS1TpGLHKakE8O6xB3SZCqB1+uxNUQ+vLOkr1jSeJUpqHetjm4Ilm4QcK3rMbtv4qIm1lecz2F2he4JQ4yAATUAI2q6xzzI/h+vhbqMQ8YmLCWIzylfJ7ZChVjvMemoS7GGlZT3QLCJvyAQWs8L3udOku6URX05zzfanDNH/Lw+WjzPlHgKe3ObvMXcjHCYcDbaxzA3ha3PjyyE28rYzBj3G8rFysUR95OPmln6mFRsupb9zTJ7fAmajhVEf7pYxoK0mxPfdXzeCVDTB02eAbfv95gVtUJmvnHTfXRUJsPVVZ5C6DwmYwUzfVfsqZ3Q+AGOacqY6EfUcw8nBNCpvPHcvrddOJSPAOq
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9a14d2-7793-4739-9da5-08d81d12e0c4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0501MB2205.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 16:30:19.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6h06H+g8rJej/mcswVic/IBoO+E7TG5jlqtjaCntjSDjD7h6QCprtPHBAsyOi9lJ7b89PU9xWFCdf50/lCHjVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 6:16 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The error return path when create_singlethread_workqueue fails currently
> does not kfree tls and leads to a memory leak. Fix this by kfree'ing
> tls before returning -ENOMEM.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
> index 99beb928feff..fee991f5ee7c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
> @@ -232,8 +232,10 @@ int mlx5e_tls_init(struct mlx5e_priv *priv)
>   		return -ENOMEM;
>   
>   	tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
> -	if (!tls->rx_wq)
> +	if (!tls->rx_wq) {
> +		kfree(tls);
>   		return -ENOMEM;
> +	}
>   
>   	priv->tls = tls;
>   	return 0;
> 

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Thanks.
