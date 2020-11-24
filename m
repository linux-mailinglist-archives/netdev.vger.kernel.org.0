Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFBF2C21D9
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731391AbgKXJkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:40:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4725 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731388AbgKXJkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:40:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbcd4f20001>; Tue, 24 Nov 2020 01:40:02 -0800
Received: from [172.27.14.166] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 09:39:52 +0000
Subject: Re: [PATCH iproute2-next v2] tc flower: use right ethertype in
 icmp/arp parsing
To:     David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        <netdev@vger.kernel.org>
CC:     <simon.horman@netronome.com>, <jhs@mojatatu.com>,
        <jianbol@mellanox.com>
References: <20201110075355.52075-1-zahari.doychev@linux.com>
 <c51abdae-6596-54ec-2b96-9b010c27cdb1@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <3ae696c9-b4dd-a2e5-77d5-c572e98a4000@nvidia.com>
Date:   Tue, 24 Nov 2020 11:39:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <c51abdae-6596-54ec-2b96-9b010c27cdb1@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606210802; bh=ZNFt8DS9khx9MR6Ir3B+cUVJVfYRDp6l7kIYKGG3XuM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=h0lhW0PL1sWQK/3+geCs3oRwHVojLdkmBNskwSbbRD42KxXWRHQwVupazyDHj30RO
         5ymsiLPqi4aVR2sHaFcC9rkc8PMEdH/g/MALqxRgQ/eKUHE06vlX6Qqlil4a/byJXy
         OP8IUoBVbVU4X2ERPBAGaa+MK84glRkh6y3qGuPWSjg/2Zu7q72SjGcJfs0VMaZ3oA
         WlD830Urz/YWBaLFyhNtoEEIiWm7eJkzMTvSlOc6TNnpzCOCJ871jF7RSX4E6fXd++
         RA+JbZNYf+LU2qbf0G63RFT4+s0Wg86TzT9bb6/wQxtsOGcD0oUK+k4avZ/NHMsUlN
         dcndt2XQ6W0Zg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-11-14 5:12 AM, David Ahern wrote:
> On 11/10/20 12:53 AM, Zahari Doychev wrote:
>> Currently the icmp and arp parsing functions are called with incorrect
>> ethtype in case of vlan or cvlan filter options. In this case either
>> cvlan_ethtype or vlan_ethtype has to be used. The ethtype is now updated
>> each time a vlan ethtype is matched during parsing.
>>
>> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
>> ---
>>   tc/f_flower.c | 52 +++++++++++++++++++++++----------------------------
>>   1 file changed, 23 insertions(+), 29 deletions(-)
>>
> 
> Thanks, looks much better.
> 
> applied to iproute2-next.
> 

Hi,

I didn't debug yet but with this commit I am failing to add a tc
rule I always could before. also the error msg doesn't make sense.

Example:

# tc filter add dev enp8s0f0 protocol 802.1Q parent ffff: prio 1 flower\
  skip_hw dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50\
  vlan_ethtype 0x800 vlan_id 100 vlan_prio 0 action vlan pop action\
  mirred egress redirect dev enp8s0f0_0


Can't set "vlan_id" if ethertype isn't 802.1Q or 802.1AD


I used protocol 802.1Q and vlan_ethtype 0x800.
am i missing something? the rule should look different now?

Thanks,
Roi
