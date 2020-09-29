Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9727D928
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgI2UpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:45:25 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15176 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgI2UpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:45:25 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f739cb20000>; Tue, 29 Sep 2020 13:44:34 -0700
Received: from [10.25.75.191] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 20:45:21 +0000
Subject: Re: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
To:     David Miller <davem@davemloft.net>
CC:     <saeed@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <erezsh@nvidia.com>, <mbloch@nvidia.com>, <saeedm@nvidia.com>
References: <20200925193809.463047-2-saeed@kernel.org>
 <20200926.151540.1383303857229218158.davem@davemloft.net>
 <DM6PR12MB423444C484839CF7FB7AA6B3C0350@DM6PR12MB4234.namprd12.prod.outlook.com>
 <20200928.144149.790487567012040407.davem@davemloft.net>
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
Message-ID: <d53133e1-ca35-40cd-3856-f8592fd4895e@nvidia.com>
Date:   Tue, 29 Sep 2020 23:44:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200928.144149.790487567012040407.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601412274; bh=C8wGhaoFzNhz0a+QSEpxsBn31j2bC4EUaXmRu+x4z8M=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=lNyVPnOSFeJsCS1EStBvFzyLGMIeatDBA/hCaTkzLqujPPBicMPZmU8lOYTxlRZ+F
         7qiE6F2ZILBbVXa9luiSJz1ByBDHGYZw9Tn6S9xuvAUVTcNv1JWQtaxlJGVApJzs5O
         6fnZOav2QSD8TMCRLQJP0xzN/wKb990BmwFlqRwUUiA4D4XFcs7GM0nUnk9cuomsKd
         +tPBmqFbTX4A66BijCxVlqULS1FQPA17HyqlraHzdi5thPiJq6WATH8LuXhT9w1nmV
         TevFCRjG2bXbDxe4+VKeomGSDsvAkhiSQUgfepFNXfQrD6NDko3TnP9K6PTUmbIqcz
         gLDwCyUSw0Baw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29-Sep-20 00:41, David Miller wrote:
> 
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Date: Mon, 28 Sep 2020 19:58:59 +0000
> 
>> By replacing the bits-per-long array with a single counter we loose
>> this ability to jump faster to the free spot.
> 
> I don't understand why this is true, because upon the free we will
> update the hint and that's where the next bit search will start.
> 
> Have you even tried my suggestion?

I did, but I couldn't make it work for some use cases that
I expect to be fairly common. Perhaps I misunderstood something.
Let's look at the following use case (I'll make it 'extreme' to
better illustrate the problem):

A buddy is all allocated by mostly small chunks.
This means that the bit array of size n will look something like this:

idx  | 0 | 1 | ...                                     |n-2|n-1|
      |---|---|-----------------------------------------|---|---|
array| 0 | 0 | ....... all zeroes - all full .......   | 0 | 0 |
      |---|---|-----------------------------------------|---|---|

Then chunk that was allocated at index n-1 is freed, which means
that 'lowest set bit' is set to n-1.
Array will look like this:

idx  | 0 | 1 | ...                                     |n-2|n-1|
      |---|---|-----------------------------------------|---|---|
array| 0 | 0 | ....... all zeroes - all full .......   | 0 | 1 |
      |---|---|-----------------------------------------|---|---|


Then chunk that was allocated at index 0 is freed, which means
that 'lowest set bit' is set to 0.
Array will look like this:

idx  | 0 | 1 | ...                                     |n-2|n-1|
      |---|---|-----------------------------------------|---|---|
array| 1 | 0 | ....... all zeroes - all full .......   | 0 | 1 |
      |---|---|-----------------------------------------|---|---|

Then a new allocation request comes in.
The 'lowest set bit' is 0, which allows us to find the spot.

The 'lowest set bit' is now set to 1.
Array will look like this:

idx  | 0 | 1 | ...                                     |n-2|n-1|
      |---|---|-----------------------------------------|---|---|
array| 0 | 0 | ....... all zeroes - all full .......   | 0 | 1 |
      |---|---|-----------------------------------------|---|---|

Then another allocation request comes in.
The 'lowest set bit' is 1, which means that we now need
to scan the whole array.

Is there a way to make 'lowest set bit' hint to work for
the use cases similar to what I've described?

-- YK
