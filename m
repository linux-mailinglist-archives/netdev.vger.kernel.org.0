Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D3A2D0E9F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgLGLFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:05:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15222 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgLGLFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 06:05:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fce0c630002>; Mon, 07 Dec 2020 03:05:07 -0800
Received: from [172.27.12.57] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 11:05:05 +0000
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
To:     Saeed Mahameed <saeed@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
 <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
 <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
 <20201206170834.GA4342@hoboy.vegasvil.org>
 <a03538c728bf232ccae718d78de43883c4fca70d.camel@kernel.org>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <c6e706ad-3b06-76bb-f30f-d24193b92019@nvidia.com>
Date:   Mon, 7 Dec 2020 13:05:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <a03538c728bf232ccae718d78de43883c4fca70d.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607339107; bh=9f4SdyEHzSIPAHj9uZn5qK/x9ftagPOJCVYapIGVBJA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=YWwzQuLX84pE5IuUgRAeBretp5IbI5ZzcpurMX6fCrTXuWMkGeN4oXy9Na5AgpeOg
         uDoRCRJFHU1JK8A/wF1mybuJ24LiJ1+uTiWwDz1u2wwAv/byTK4l2M1dc3/nIlVGYp
         rOBRgzERInb9N2w3/kjWjbV2+fkYLf5vlaNdYFyULAcUno/OOsE8054m5Z5OxS3o/f
         ZYFbnb8ic58n5FqF5suJvgI1CBMRZelWLf0EaRtIK3LGA5BNl7EZWJiaDJ2CnUTH51
         KgbzQkGOIVGtPP8s1s2zmaSWBHefbijUl3peBv/oZbhCkMOQURwc/g70IEvwTgA179
         aaoK54GidyWAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2020 10:37 AM, Saeed Mahameed wrote:
> On Sun, 2020-12-06 at 09:08 -0800, Richard Cochran wrote:
>> On Sun, Dec 06, 2020 at 03:37:47PM +0200, Eran Ben Elisha wrote:
>>> Adding new enum to the ioctl means we have add
>>> (HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY for example) all the way -
>>> drivers,
>>> kernel ptp, user space ptp, ethtool.
>>>
> 
> Not exactly,
> 1) the flag name should be HWTSTAMP_TX_PTP_EVENTS, similar to what we
> already have in RX, which will mean:
> HW stamp all PTP events, don't care about the rest.
> 
> 2) no need to add it to drivers from the get go, only drivers who are
> interested may implement it, and i am sure there are tons who would
> like to have this flag if their hw timestamping implementation is slow
> ! other drivers will just keep doing what they are doing, timestamp all
> traffic even if user requested this flag, again exactly like many other
> drivers do for RX flags (hwtstamp_rx_filters).
> 
>>> My concerns are:
>>> 1. Timestamp applications (like ptp4l or similar) will have to add
>>> support
>>> for configuring the driver to use HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY
>>> if
>>> supported via ioctl prior to packets transmit. From application
>>> point of
>>> view, the dual-modes (HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY ,
>>> HWTSTAMP_TX_ON)
>>> support is redundant, as it offers nothing new.
>>
>> Well said.
>>
> 
> disagree, it is not a dual mode, just allow the user to have better
> granularity for what hw stamps, exactly like what we have in rx.
> 
> we are not adding any new mechanism.
> 
>>> 2. Other vendors will have to support it as well, when not sure
>>> what is the
>>> expectation from them if they cannot improve accuracy between them.
>>
>> If there were multiple different devices out there with this kind of
>> implementation (different levels of accuracy with increasing run time
>> performance cost), then we could consider such a flag.  However, to
>> my
>> knowledge, this feature is unique to your device.
>>
> 
> I agree, but i never meant to have a flag that indicate two different
> levels of accuracy, that would be a very wild mistake for sure!
> 
> The new flag will be about selecting granularity of what gets a hw
> stamp and what doesn't, aligning with the RX filter API.
> 
>>> This feature is just an internal enhancement, and as such it should
>>> be added
>>> only as a vendor private configuration flag. We are not offering
>>> here about
>>> any standard for others to follow.
>>
>> +1
>>
> 
> Our driver feature is and internal enhancement yes, but the suggested
> flag is very far from indicating any internal enhancement, is actually
> an enhancement to the current API, and is a very simple extension with
> wide range of improvements to all layers.
> 
> Our driver can optimize accuracy when this flag is set, other drivers
> might be happy to implement it since they already have a slow hw and
> this flag would allow them to run better TCP/UDP performance while
> still performing ptp hw stamping, some admins/apps will use it to avoid
> stamping all traffic on tx, win win win.
> 
> 
Seems interesting. I can form such V2 patches soon.

