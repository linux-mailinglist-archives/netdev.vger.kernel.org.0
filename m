Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE3B2F05DB
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 08:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbhAJHq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 02:46:26 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7562 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbhAJHq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 02:46:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffab0a90003>; Sat, 09 Jan 2021 23:45:45 -0800
Received: from [172.27.13.71] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 10 Jan
 2021 07:45:43 +0000
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-9-saeed@kernel.org>
 <20210108214812.GB3678@horizon.localdomain>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
Date:   Sun, 10 Jan 2021 09:45:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108214812.GB3678@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610264745; bh=l/ifkE+Mqr/GSwkcQbwTdOLdziUgSGOmoTCeLIxvrJw=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=Cs+ciHfkUt2mRiWlKi2N/LZ/tAH8yybotF5SMBPuW/D/0hBFmAYB+ymVm35pQum2e
         5lNpjNf2XLndaDLdTkjy+On2ZSO7/fyGIPu/K6iv/+Nz8DHMT0h4vSckJlUDr5xpmT
         SvM+1TjE13C/b5LMRDJvVg8o3fuU0VMYRSgsATXs7UpnV26Kxugz9qE/WAAJ/3FfyD
         2Rrtt8eWbDlNo1tQQzmxx3ee1hZHuDLO3ti4qvJtvLzy7vB7pGzFTrPJQby2QSjSAU
         iIl5ff68NWvuqdKle4kbQ0cLMoQOi1YTK9/rtpaynqthtMXU/ySecbZm3MjwSbGRpD
         8G8+CUiFiTz4g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-08 11:48 PM, Marcelo Ricardo Leitner wrote:
> Hi,
> 
> On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
>> From: Roi Dayan <roid@nvidia.com>
>>
>> Connection tracking associates the connection state per packet. The
>> first packet of a connection is assigned with the +trk+new state. The
>> connection enters the established state once a packet is seen on the
>> other direction.
>>
>> Currently we offload only the established flows. However, UDP traffic
>> using source port entropy (e.g. vxlan, RoCE) will never enter the
>> established state. Such protocols do not require stateful processing,
>> and therefore could be offloaded.
> 
> If it doesn't require stateful processing, please enlight me on why
> conntrack is being used in the first place. What's the use case here?
> 

The use case for example is when we have vxlan traffic but we do
conntrack on the inner packet (rules on the physical port) so
we never get established but on miss we can still offload as normal
vxlan traffic.

>>
>> The change in the model is that a miss on the CT table will be forwarded
>> to a new +trk+new ct table and a miss there will be forwarded to the slow
>> path table.
> 
> AFAICU this new +trk+new ct table is a wildcard match on sport with
> specific dports. Also AFAICU, such entries will not be visible to the
> userspace then. Is this right?
> 
>    Marcelo
> 

right.
