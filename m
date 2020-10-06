Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6124B284C20
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgJFNCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:02:36 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7731 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:02:36 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c6ab40000>; Tue, 06 Oct 2020 06:01:40 -0700
Received: from [10.25.79.50] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 13:02:31 +0000
Subject: Re: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
To:     David Miller <davem@davemloft.net>
CC:     "saeed@kernel.org" <saeed@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erez Shitrit" <erezsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20200925193809.463047-2-saeed@kernel.org>
 <20200926.151540.1383303857229218158.davem@davemloft.net>
 <DM6PR12MB423444C484839CF7FB7AA6B3C0350@DM6PR12MB4234.namprd12.prod.outlook.com>
 <20200928.144149.790487567012040407.davem@davemloft.net>
 <d53133e1-ca35-40cd-3856-f8592fd4895e@nvidia.com>
Message-ID: <c231b69d-812a-b98e-b785-a807d6d640b5@nvidia.com>
Date:   Tue, 6 Oct 2020 16:02:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <d53133e1-ca35-40cd-3856-f8592fd4895e@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601989300; bh=1I0L7WTf8b4EJB8ZMCPnJEWvz/jEPtw1fw/Mkkap1S0=;
        h=Subject:From:To:CC:References:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=YN+Lleiasu8kA3UhR6JKd1dm8ZQZncxRXOtDR+EcNDJBY/7gDZRGdglY4wxWcjHIP
         iRaKvxDCd2GinL6y01HDAwo1igSLc8yQx9HFFeMgBJjwOwJuDXYmL5/B4rnYOhy42u
         Or/zbwK6911G9vwGRNIGkf/U/tC5bwxZgrISrNR5vdQNsnKvKtErsA65gkoYjHBRIo
         IJAcvw7Ft1PL+xi4qqrZxQbO/z8cvNR8SfRDWqkBscpY+rMTIGV3ucoLnninDXqlcv
         FrdHoPCF4Udtz9gNisqpGvxdODKY03IBg5E6SUfLd9Ei3O37lZMvmERGFIWdvtxjH4
         UOrhOy9wqvU9g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29-Sep-20 23:44, Yevgeny Kliteynik wrote:>
 > On 29-Sep-20 00:41, David Miller wrote:
 >>
 >> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
 >> Date: Mon, 28 Sep 2020 19:58:59 +0000
 >>
 >>> By replacing the bits-per-long array with a single counter we loose
 >>> this ability to jump faster to the free spot.
 >>
 >> I don't understand why this is true, because upon the free we will
 >> update the hint and that's where the next bit search will start.
 >>
 >> Have you even tried my suggestion?
 >
 > I did, but I couldn't make it work for some use cases that
 > I expect to be fairly common. Perhaps I misunderstood something.
 > Let's look at the following use case (I'll make it 'extreme' to
 > better illustrate the problem):

Following up on this mail.
In addition to the case I've described, I'd like to clarify why
the 'lowest set bit' hint doesn't work here.

Buddy allocator allocates blocks of different sizes, so when it
scans the bits array, the allocator looks for free *area* of at
least the required size.
Can't store this info in a 'lowest set bit' counter.

Furthermore, when buddy allocator scans for such areas, it
takes into consideration blocks alignment as required by HW,
which can't be stored in an external counter.

The code here implements standard buddy allocator with a small
optimization of an additional level to speed up the search.
Do you see something wrong with this additional level?

-- YK


 > A buddy is all allocated by mostly small chunks.
 > This means that the bit array of size n will look something like this:
 >
 > idx  | 0 | 1 | ...                                     |n-2|n-1|
 >      |---|---|-----------------------------------------|---|---|
 > array| 0 | 0 | ....... all zeroes - all full .......   | 0 | 0 |
 >      |---|---|-----------------------------------------|---|---|
 >
 > Then chunk that was allocated at index n-1 is freed, which means
 > that 'lowest set bit' is set to n-1.
 > Array will look like this:
 >
 > idx  | 0 | 1 | ...                                     |n-2|n-1|
 >      |---|---|-----------------------------------------|---|---|
 > array| 0 | 0 | ....... all zeroes - all full .......   | 0 | 1 |
 >      |---|---|-----------------------------------------|---|---|
 >
 >
 > Then chunk that was allocated at index 0 is freed, which means
 > that 'lowest set bit' is set to 0.
 > Array will look like this:
 >
 > idx  | 0 | 1 | ...                                     |n-2|n-1|
 >      |---|---|-----------------------------------------|---|---|
 > array| 1 | 0 | ....... all zeroes - all full .......   | 0 | 1 |
 >      |---|---|-----------------------------------------|---|---|
 >
 > Then a new allocation request comes in.
 > The 'lowest set bit' is 0, which allows us to find the spot.
 >
 > The 'lowest set bit' is now set to 1.
 > Array will look like this:
 >
 > idx  | 0 | 1 | ...                                     |n-2|n-1|
 >      |---|---|-----------------------------------------|---|---|
 > array| 0 | 0 | ....... all zeroes - all full .......   | 0 | 1 |
 >      |---|---|-----------------------------------------|---|---|
 >
 > Then another allocation request comes in.
 > The 'lowest set bit' is 1, which means that we now need
 > to scan the whole array.
 >
 > Is there a way to make 'lowest set bit' hint to work for
 > the use cases similar to what I've described?
 >
 > -- YK
 >
