Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE52260E40
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgIHJAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:00:14 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6009 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgIHJAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:00:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5747940004>; Tue, 08 Sep 2020 01:57:56 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 02:00:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 02:00:10 -0700
Received: from [172.27.14.146] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 08:59:57 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 06/10] net/mlx5e: Support multiple SKBs in a TX WQE
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20200903210022.22774-1-saeedm@nvidia.com>
 <20200903210022.22774-7-saeedm@nvidia.com>
 <20200903154609.363e8c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <489a69c6-d288-4cb4-fe32-8d4bd6f37667@nvidia.com>
Date:   Tue, 8 Sep 2020 11:59:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903154609.363e8c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599555476; bh=ALMal4jy9PWZMW2FvJlVxMmR82iKdDN56XTOokFJIsE=;
        h=X-PGP-Universal:From:Subject:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=MPgECDGrNQLQggsx/3nq/cFst8iSCx1Stb4BhT8cLctJPUa1w5QG1Uhr4TZ62uYUO
         ta6g7GZsblGA3bD9JczvEsff/3CY6cS142ljtFgNGTWdGt8RBRtHsxa7Y5nPh6xhyH
         DQIwyBUJVAXSSwXqFNgaknDJWHEkpIXORoYmUJdqHkFn2Pb5mRhfF6GvpakCjQ7WUP
         zI311XpM9/w3ygJMsZ1l0Pofoh7torIAjNkE4bQ9dRIL4+gg+B6NsY7C+dR0IW9sSA
         uRmx5wCqrsPa1vh/A951qKatuX9rv4UbZPsHW2Kix+38vN1XrNdE4e2sQOOz4wGFzw
         D7xI2/6P6K+Ig==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 01:46, Jakub Kicinski wrote:
> On Thu, 3 Sep 2020 14:00:18 -0700 Saeed Mahameed wrote:
>> +static inline void mlx5e_tx_wi_consume_fifo_skbs(struct mlx5e_txqsq *sq,
>> +						 struct mlx5e_tx_wqe_info *wi,
>> +						 struct mlx5_cqe64 *cqe,
>> +						 int napi_budget)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < wi->num_fifo_pkts; i++) {
>> +		struct sk_buff *skb = mlx5e_skb_fifo_pop(sq);
>> +
>> +		mlx5e_consume_skb(sq, skb, cqe, napi_budget);
>> +	}
>> +}
> 
> The compiler was not inlining this one either?

Regarding this one, gcc inlines it automatically, but I went on the safe 
side and inlined it explicitly - it's small and called for every WQE, so 
we never want it to be non-inline.
