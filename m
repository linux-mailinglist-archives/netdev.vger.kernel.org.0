Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D27C2D0548
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 14:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgLFNhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 08:37:24 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5305 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgLFNhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 08:37:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fccde6b0000>; Sun, 06 Dec 2020 05:36:43 -0800
Received: from [172.27.13.141] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 6 Dec
 2020 13:36:41 +0000
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
 <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <43d6d07c-c75d-4a10-f49d-80f78ea07d39@nvidia.com>
Date:   Sun, 6 Dec 2020 15:36:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607261803; bh=cVNvhKHNjiOS1rDG0BYpMn83hJHnyIAk74JsiL/GFPM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=h5H7Ihb0Fw3LSBHG/+M0sf8ECGXtbigyWDbhKu0/myLkMDaiNT/gEIlUwAAcIoGap
         80qosCx2Rae6KbiZKF63n7eMp7spMHbbuvG3t4gTeG4HEGu9SMiriQ6pmJUXmiPRQL
         ETy3PzYxsGKADmrBW8WW9m0eL5fABE+KaRQ3asF/LhIpBl7O6xsYRUhK7OdGGLftoE
         SSSD1/pJMtTfBHNRL/jadQqEuq2ISxu+GJgm2D9KLBRoq0S+s390Xlfc67vaSXsZmE
         CF5DB2fTTZqO6nXBcguB8txrWi5aHMZ73hwcH97FJn2294kK9WUQimhlyX18h89tQ4
         UjfFZozFiAGCQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2020 1:17 AM, Jakub Kicinski wrote:
>> We only forward ptp traffic to the new special queue but we create more
>> than one to avoid internal locking as we will utilize the tx softirq
>> percpu.
> In other words to make the driver implementation simpler we'll have
> a pretty basic feature hidden behind a ethtool priv knob and a number
> of queues which doesn't match reality reported to user space. Hm.

We are not hiding these queues from the netdev stack. We report them in 
real num of TX queues and manage them as any other queue. The only 
change is that select_queue() will select a stream to them if and only 
if they match specific criteria.
