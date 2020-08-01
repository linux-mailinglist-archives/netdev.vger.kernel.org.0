Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AD2353B9
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgHARJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 13:09:45 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4090 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgHARJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 13:09:45 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f25a1ca0000>; Sat, 01 Aug 2020 10:09:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sat, 01 Aug 2020 10:09:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sat, 01 Aug 2020 10:09:44 -0700
Received: from [10.2.53.233] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 1 Aug
 2020 17:09:42 +0000
Subject: Re: [PATCH net] vxlan: fix memleak of fdb
To:     Taehee Yoo <ap420073@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <roopa@cumulusnetworks.com>
References: <20200801070750.7993-1-ap420073@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <2df4a274-c14e-d9fa-3053-a543feb07a4c@nvidia.com>
Date:   Sat, 1 Aug 2020 10:09:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200801070750.7993-1-ap420073@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596301771; bh=s65qmHy45z9kHoyz0lJWLFo8V5sTOvTeOWnkzTdgoro=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=KVIvuDdXdrmabTH4F3+rdEzVgXmrfeWgJVW9R6ryCmIpR7TQ4F7Hdd2v2kzgRfWjv
         6I/VkYON04PBe3JfpZeMtyS0NhT6N37BmTbmyE1Pjk2Hd73zo/yQyks4QoXeKPAJYL
         w+tmT1devo9U2kbouXaqhJwxuN5rc8sG/x/bb8ukH3RqPl/bpY27rjCUQpwODfT7rz
         MdMaPWfZUyR8AsoD76WUUh0vW12T+k8gBvPdQo0NcrIHc4w1ltgwfR9bw2DRtxmUy6
         KmVtWOvGw3QrBo5z8mmHO1rVG+86AX3Ng3w9Hd14WOt1WjhJoD0BcDz27Irk0x/NW9
         SxzjqhS6Z36aQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/1/20 12:07 AM, Taehee Yoo wrote:
> External email: Use caution opening links or attachments
>
>
> When vxlan interface is deleted, all fdbs are deleted by vxlan_flush().
> vxlan_flush() flushes fdbs but it doesn't delete fdb, which contains
> all-zeros-mac because it is deleted by vxlan_uninit().
> But vxlan_uninit() deletes only the fdb, which contains both all-zeros-mac
> and default vni.
> So, the fdb, which contains both all-zeros-mac and non-default vni
> will not be deleted.
>
> Test commands:
>      ip link add vxlan0 type vxlan dstport 4789 external
>      ip link set vxlan0 up
>      bridge fdb add to 00:00:00:00:00:00 dst 172.0.0.1 dev vxlan0 via lo \
>              src_vni 10000 self permanent
>      ip link del vxlan0
>
> kmemleak reports as follows:
> unreferenced object 0xffff9486b25ced88 (size 96):
>    comm "bridge", pid 2151, jiffies 4294701712 (age 35506.901s)
>    hex dump (first 32 bytes):
>      02 00 00 00 ac 00 00 01 40 00 09 b1 86 94 ff ff  ........@.......
>      46 02 00 00 00 00 00 00 a7 03 00 00 12 b5 6a 6b  F.............jk
>    backtrace:
>      [<00000000c10cf651>] vxlan_fdb_append.part.51+0x3c/0xf0 [vxlan]
>      [<000000006b31a8d9>] vxlan_fdb_create+0x184/0x1a0 [vxlan]
>      [<0000000049399045>] vxlan_fdb_update+0x12f/0x220 [vxlan]
>      [<0000000090b1ef00>] vxlan_fdb_add+0x12a/0x1b0 [vxlan]
>      [<0000000056633c2c>] rtnl_fdb_add+0x187/0x270
>      [<00000000dd5dfb6b>] rtnetlink_rcv_msg+0x264/0x490
>      [<00000000fc44dd54>] netlink_rcv_skb+0x4a/0x110
>      [<00000000dff433e7>] netlink_unicast+0x18e/0x250
>      [<00000000b87fb421>] netlink_sendmsg+0x2e9/0x400
>      [<000000002ed55153>] ____sys_sendmsg+0x237/0x260
>      [<00000000faa51c66>] ___sys_sendmsg+0x88/0xd0
>      [<000000006c3982f1>] __sys_sendmsg+0x4e/0x80
>      [<00000000a8f875d2>] do_syscall_64+0x56/0xe0
>      [<000000003610eefa>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> unreferenced object 0xffff9486b1c40080 (size 128):
>    comm "bridge", pid 2157, jiffies 4294701754 (age 35506.866s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 f8 dc 42 b2 86 94 ff ff  ..........B.....
>      6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>    backtrace:
>      [<00000000a2981b60>] vxlan_fdb_create+0x67/0x1a0 [vxlan]
>      [<0000000049399045>] vxlan_fdb_update+0x12f/0x220 [vxlan]
>      [<0000000090b1ef00>] vxlan_fdb_add+0x12a/0x1b0 [vxlan]
>      [<0000000056633c2c>] rtnl_fdb_add+0x187/0x270
>      [<00000000dd5dfb6b>] rtnetlink_rcv_msg+0x264/0x490
>      [<00000000fc44dd54>] netlink_rcv_skb+0x4a/0x110
>      [<00000000dff433e7>] netlink_unicast+0x18e/0x250
>      [<00000000b87fb421>] netlink_sendmsg+0x2e9/0x400
>      [<000000002ed55153>] ____sys_sendmsg+0x237/0x260
>      [<00000000faa51c66>] ___sys_sendmsg+0x88/0xd0
>      [<000000006c3982f1>] __sys_sendmsg+0x4e/0x80
>      [<00000000a8f875d2>] do_syscall_64+0x56/0xe0
>      [<000000003610eefa>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Fixes: 3ad7a4b141eb ("vxlan: support fdb and learning in COLLECT_METADATA mode")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---

Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>


looks right, thanks


