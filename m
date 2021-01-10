Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9BD2F05E0
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 08:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbhAJH4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 02:56:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9260 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbhAJH4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 02:56:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffab31b0001>; Sat, 09 Jan 2021 23:56:11 -0800
Received: from [172.27.13.71] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 10 Jan
 2021 07:56:08 +0000
Subject: Re: [net-next 09/15] net/mlx5e: CT: Support offload of +trk+new ct
 rules
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-10-saeed@kernel.org>
 <20210108215900.GC3678@horizon.localdomain>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <3eb1ef64-1ce7-5431-be1c-1bd6b4f99bf0@nvidia.com>
Date:   Sun, 10 Jan 2021 09:55:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108215900.GC3678@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610265371; bh=JdHcazUpb1f1rA11M99L8nzpLVZSOft2Av3PD052UME=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=oP2ykegFRYkXvVWtXvNs96kN9N0YioOU6ZYRRcTpW7+RcfEtXq6GCI8wnQan6kNKx
         0ysEcAD/7W48UHUoGdIVZXGsIHfrMwsulBLBAp7Wkh6yfl8/dOK8L4RBAh9rUvpfWo
         3PGjmP7xsuJ9NUhM9JlnvV3hI/VH2+Ipw+mtuMW4/V0Fg2Yw08iKH3584FsvbIFyYG
         mIutUrcGw7uurqWnAK9xIODf43tg/cRJ75SavIWaR7sFZ3e4qOh+45B9j4ZnGX5FSK
         26hcSGaW0mHuGWIhC7eYZhLRCCJqCRjUDsZoHJKxtWR5kXDC0MpO7gnsU7YuxUBAq7
         kXdYBywanHwzA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-08 11:59 PM, Marcelo Ricardo Leitner wrote:
> Hi,
> 
> On Thu, Jan 07, 2021 at 09:30:48PM -0800, Saeed Mahameed wrote:
>> @@ -1429,6 +1600,14 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
>>   	if (err)
>>   		goto err_insert;
>>   
>> +	nf_ct_zone_init(&ctzone, zone, NF_CT_DEFAULT_ZONE_DIR, 0);
>> +	ft->tmpl = nf_ct_tmpl_alloc(&init_net, &ctzone, GFP_KERNEL);
> 
> I didn't test but I think this will add a hard dependency to
> nf_conntrack_core and will cause conntrack to always be loaded by
> mlx5_core, which is not good for some use cases.
> nf_ct_tmpl_alloc() is defined in nf_conntrack_core.c.
> 
> 762f926d6f19 ("net/sched: act_ct: Make tcf_ct_flow_table_restore_skb
> inline") was done similarly to avoid this.
> 

right. we will take a look what we can do with this.
thanks

>> +	if (!ft->tmpl)
>> +		goto err_tmpl;
>> +
>> +	__set_bit(IPS_CONFIRMED_BIT, &ft->tmpl->status);
>> +	nf_conntrack_get(&ft->tmpl->ct_general);
>> +
>>   	err = nf_flow_table_offload_add_cb(ft->nf_ft,
>>   					   mlx5_tc_ct_block_flow_offload, ft);
>>   	if (err)
