Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A7812AAEC
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 09:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfLZIWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 03:22:54 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:51131 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfLZIWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 03:22:54 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2294C41C9C;
        Thu, 26 Dec 2019 16:22:51 +0800 (CST)
Subject: Re: Problem about gre tunnel route offload in mlxsw
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
 <6ed792a4-6f64-fe57-4e1e-215bfa701ccf@ucloud.cn>
 <20191225.195000.1150683636639114235.davem@davemloft.net>
 <8bb9cc6b-bda1-5808-d88c-6e33076ac264@ucloud.cn>
 <20191226074914.GA30900@splinter>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <ca6e27e4-8bec-8591-9bab-d411649d1834@ucloud.cn>
Date:   Thu, 26 Dec 2019 16:22:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191226074914.GA30900@splinter>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0pPS0tLSk5ITk9KTk1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDI6Gio6DTg4CjpJDBgKHx4q
        Fk0wCQFVSlVKTkxMSE9DTkxKTEpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSE5LTTcG
X-HM-Tid: 0a6f414d205c2086kuqy2294c41c9c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/26/2019 3:49 PM, Ido Schimmel wrote:
> On Thu, Dec 26, 2019 at 01:07:33PM +0800, wenxu wrote:
>> Hi mlxsw team,
>>
>>
>> I did a route test with gre tunnel and vrf.
>>
>> This test under current net-next tree with following script:
>>
>>
>> ifconfig enp3s0np31 up
>> ip a a dev enp3s0np31 172.168.152.247/24
>>
>> ip l add dev vrf11 type vrf table 11
>> ifconfig vrf11 up
>> ip l set dev enp3s0np11 master vrf11
>> ifconfig enp3s0np11 10.0.7.1/24 up
>> ip tunnel add name gre11 mode gre local 172.168.152.247 remote 172.168.152.73 key 11 tos inherit  ttl inherit
>> ip l set dev gre11 master vrf11
>> ifconfig gre11 10.0.2.1/24 up
>>
>> ip l add dev vrf21 type vrf table 21
>> ifconfig vrf21 up
>> ip l set dev enp3s0np21 master vrf21
>> ifconfig enp3s0np21 10.0.7.1/24 up
>> ip tunnel add name gre21 mode gre local 172.168.152.247 remote 172.168.152.73 key 21 tos inherit  ttl inherit
>> ip l set dev gre21 master vrf21
>> ifconfig gre21 10.0.2.1/24 up
>>
>>
>> If there is only one tunnel. The route rule can be offloaded. But two tunnel only with different key can't be offloaded.
>>
>> If I add a new address 172.168.152.248 for tunnel source and change the gre21 to
>>
>> "ip tunnel add name gre21 mode gre local 172.168.152.248 remote 172.168.152.73 key 21 tos inherit  ttl inherit"
>>
>> It's work.
>>
>> So it means dispatch based on tunnel key is not supported ?
> Yes. See:
> "No two tunnels that share underlay VRF shall share a local address
> (i.e. dispatch based on tunnel key is not supported)"
>
> https://github.com/Mellanox/mlxsw/wiki/L3-Tunneling#features-and-limitations
>
>> It is a hardware limits or just software unsupported?
> Software. In hardware you can perform decapsulation in the router or
> using ACLs. mlxsw uses the former so the key is {tb_id, prefix}. With
> ACLs it is possible to match on more attributes.
>
I find mlxsw use ACL through TC flower. But currently It does't support ecn_*_keys in the flower match?

Also it doesn't support the action "redirect to GRE Tunnel device"?

