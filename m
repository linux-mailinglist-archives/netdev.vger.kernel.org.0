Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632432B4087
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgKPKL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:11:56 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3154 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbgKPKL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:11:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb250630001>; Mon, 16 Nov 2020 02:11:47 -0800
Received: from [10.26.72.39] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Nov
 2020 10:11:43 +0000
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Add DSFP EEPROM dump support to
 ethtool
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
References: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
 <1605160181-8137-3-git-send-email-moshe@mellanox.com>
 <20201112131321.GL1480543@lunn.ch>
 <74076266-d861-993d-cd84-1cf170937c5f@nvidia.com>
 <20201113004427.GP1480543@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <7575def5-2ff3-75db-019a-9f4456375492@nvidia.com>
Date:   Mon, 16 Nov 2020 12:11:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113004427.GP1480543@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605521507; bh=nFl/oxXGKpyIQJ3S+72GHk5xdaMqB9LruQUKcIOigU8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=jFnQ1EKsH2z5t4AuA35e43hKHnf9S4cQNOVihN+50fq4BOvQrva2FEpsZlLdybaBX
         8zJe77VCu/C66m2BaRL98jYzWXda9n3LFd/NXdLkv9rRkeDfk1SMKbxXR1DZ647j9h
         MIw/QclVtCLTF8dOlM+yQJXY+S7gCh6PnCeCuxzRWCRc82VmhifO1h0D7oTjVegBvT
         FTraBBbxE2ViG65O7ZB30B1T3V57apHn2xBSG2hPMpssglpgMjmzAC8dCtZngaaVSu
         PFO8k6lH067J1pakYyo0j1fduKf0Ez6lazPdXQ5DaspaUk9raULN/K/ZZtwqI28m6u
         r+e0paaTKIaBA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/13/2020 2:44 AM, Andrew Lunn wrote:
> On Thu, Nov 12, 2020 at 05:54:51PM +0200, Moshe Shemesh wrote:
>> On 11/12/2020 3:13 PM, Andrew Lunn wrote:
>>> On Thu, Nov 12, 2020 at 07:49:41AM +0200, Moshe Shemesh wrote:
>>>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>>>
>>>> DSFP is a new cable module type, which EEPROM uses memory layout
>>>> described in CMIS 4.0 document. Use corresponding standard value for
>>>> userspace ethtool to distinguish DSFP's layout from older standards.
>>>>
>>>> Add DSFP module ID in accordance to SFF-8024.
>>>>
>>>> DSFP module memory can be flat or paged, which is indicated by a
>>>> flat_mem bit. In first case, only page 00 is available, and in second -
>>>> multiple pages: 00h, 01h, 02h, 10h and 11h.
>>> You are simplifying quite a bit here, listing just these pages. When i
>>> see figure 8-1, CMIS Module Memory Map, i see many more pages, and
>>> banks of pages.
>>
>> Right, but as I understand these are the basic 5 pages which are mandatory.
>> Supporting more than that we will need new API.
> Humm, actually, looking at the diagram again, pages 10h and 11h are
> banked. Is one bamk sufficient? If so, you need to document that bank
> zero is always returned, and make sure your firmware is doing that.
>
> We also need to be clear that tunable laser information is not
> available, due to this fixed layout.


Pages 10h and 11h are banked, but the mandatory data for active 
transceivers is in bank 0. I will document it in the commit. There are 
more banked pages, but they are all optional. Also pages 03h and 04h are 
optional. I am looking to support here the mandatory part. For 
supporting the optional pages we will need to change API.

>       Andrew
