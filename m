Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C671D12AA32
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 06:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfLZFHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 00:07:41 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:16754 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfLZFHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 00:07:41 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 45BF35C14C5
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:07:35 +0800 (CST)
From:   wenxu <wenxu@ucloud.cn>
Subject: Problem about gre tunnel route offload in mlxsw
To:     netdev@vger.kernel.org
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
 <6ed792a4-6f64-fe57-4e1e-215bfa701ccf@ucloud.cn>
 <20191225.195000.1150683636639114235.davem@davemloft.net>
Message-ID: <8bb9cc6b-bda1-5808-d88c-6e33076ac264@ucloud.cn>
Date:   Thu, 26 Dec 2019 13:07:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191225.195000.1150683636639114235.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTUtIQkJCQkxJSE9IT09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OlE6CQw*IjgxSEI#Dh9RLAk4
        TBUaCxZVSlVKTkxMSEhNQ05OSExNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUxCSDcG
X-HM-Tid: 0a6f409a5b122087kuqy45bf35c14c5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi mlxsw team,


I did a route test with gre tunnel and vrf.

This test under current net-next tree with following script:


ifconfig enp3s0np31 up
ip a a dev enp3s0np31 172.168.152.247/24

ip l add dev vrf11 type vrf table 11
ifconfig vrf11 up
ip l set dev enp3s0np11 master vrf11
ifconfig enp3s0np11 10.0.7.1/24 up
ip tunnel add name gre11 mode gre local 172.168.152.247 remote 172.168.152.73 key 11 tos inherit  ttl inherit
ip l set dev gre11 master vrf11
ifconfig gre11 10.0.2.1/24 up

ip l add dev vrf21 type vrf table 21
ifconfig vrf21 up
ip l set dev enp3s0np21 master vrf21
ifconfig enp3s0np21 10.0.7.1/24 up
ip tunnel add name gre21 mode gre local 172.168.152.247 remote 172.168.152.73 key 21 tos inherit  ttl inherit
ip l set dev gre21 master vrf21
ifconfig gre21 10.0.2.1/24 up


If there is only one tunnel. The route rule can be offloaded. But two tunnel only with different key can't be offloaded.

If I add a new address 172.168.152.248 for tunnel source and change the gre21 to

"ip tunnel add name gre21 mode gre local 172.168.152.248 remote 172.168.152.73 key 21 tos inherit  ttl inherit"

It's work.

So it means dispatch based on tunnel key is not supported ? It is a hardware limits or just software unsupported?


And if a replace the gre device to vxlan device,  the route can't be offloaded again only with one vxlan tunnel.

"ip l add dev vxlan11 type vxlan local 172.168.152.247 remote 172.168.152.73 id 11 noudpcsum tos inherit ttl inherit dstport 4789"

So currently the vxlan device can't work with routing?


BR

wenxu





