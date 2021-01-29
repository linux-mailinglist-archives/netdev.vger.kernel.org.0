Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C407308E29
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhA2UJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:09:29 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10298 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbhA2UH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:07:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60146af10002>; Fri, 29 Jan 2021 12:07:13 -0800
Received: from [172.27.0.17] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 20:07:11 +0000
Subject: Re: net/mlx5: Maintain separate page trees for ECPF and PF functions
To:     Colin Ian King <colin.king@canonical.com>,
        Daniel Jurgens <danielj@nvidia.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
References: <ce13ef88-37c4-e9b6-891d-13722a4aa098@canonical.com>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <86dab3fb-0581-34c3-7b75-9ee809dce66a@nvidia.com>
Date:   Fri, 29 Jan 2021 22:06:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <ce13ef88-37c4-e9b6-891d-13722a4aa098@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611950833; bh=DvGJ0kWzQZiJGCZJOaIKst6Byc8J/ZmRmFLgGuVWcLw=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=ot5p1k8uM2OJd1B6gaZfJLDrEPO9xspJmfvcKu/+hIq6XqaXothmdcjYO/S0q2MV+
         n10qQQQc1RimLSTSWtPp0WVZLqNpuWHF8Tfyy7FgxwiwPHfdF0j87I3Fg4IAWPDH7F
         spmE5qtiIRe/OM+keinBjoENm3Yu9ozmFP8Jd4Mv1Tn1P0oa5L6/Ai/fgREchZbwO2
         Dj2bK+WIw58lVFN0LamENaOsmyyRhKAajxI+w2m7k7qU3KJzQ5kiUYtDD/H4/c8tnn
         lOKGM0iqGGyaIHIt4hXe0pFmY+J08ceXAvAEhUZav3tDi9w067u5aXkgXvwjHgszvS
         fvDEF+snmN+cQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2021 2:18 PM, Colin Ian King wrote:
> Hi,
> 
> Static analysis with Coverity has detected an issue with the following
> commit:
> 
> commit 0aa128475d33d2d0095947eeab6b3e4d22dbd578
> Author: Daniel Jurgens <danielj@nvidia.com>
> Date:   Fri Jan 22 23:13:53 2021 +0200
> 
>      net/mlx5: Maintain separate page trees for ECPF and PF functions
> 
> The analysis is as follows:
> 
>   77 static u32 get_function(u16 func_id, bool ec_function)
>   78 {
> 
> Operands don't affect result (CONSTANT_EXPRESSION_RESULT)
> result_independent_of_operands: func_id & (ec_function << 16) is always
> 0 regardless of the values of its operands. This occurs as a return value.
> 
>   79        return func_id & (ec_function << 16);
>   80 }
> 
> 
> boolean ec_function is shifted 16 places to the left, so the result is
> going to be 0x10000 or 0x00000. Bit-wise and'ing this with the 16 bit
> unsigned int func_id will always result in a zero.  Not sure what the
> intention is, so I can't fix it.
> 
> Either the & operator should be |,  or func_id should be wider than a u16

Hi, thanks for the report.
The u32 return value was supposed to be a concatenation of 16-bit 
func_id and ec flag.
Hence, indeed there is a bug here.

it should be
return (u32)func_id | (ec_function << 16);

Please update if you want to post this fix patch or prefer Me/Daniel to 
take it.

Eran
> 
> Colin
> 
